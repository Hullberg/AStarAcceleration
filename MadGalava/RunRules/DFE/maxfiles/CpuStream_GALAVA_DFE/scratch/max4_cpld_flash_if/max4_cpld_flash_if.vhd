--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- MAX4 CPLD Interface to Flash controller
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Module gets commands from the host and forwards them
-- to the CPLD FLASH controller.
--
-- It also forwards the result to the host.
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- Typical use case (according to the sim) is that two words are written to the
-- TX_D port. The RX_D port connected to the PCIE bar space registers and will
-- be polled on the host in software. Therefore, of the two commands that are
-- issued, the response is not output until the second one is complete i.e. the
-- response of the first command is discarded.

-- The synchronisation is done with asynchronous FIFOs, since we found problems
-- with constraining the synchronisers. This is probably overkill, but ensures
-- correct operation. As far as I can tell the maximum depth required on the
-- tx_cmd_fifo is probably 4 and on the rx_cmd_fifo is probably 1.

-- The BUS_WIDTH generic seems pretty useless, I was considering removing it all
-- together, but decided to tweak the code to support it better. In reality the
-- minumum value is 64 since there are some hard coded values from the
-- TO_FLASH_D signal to the CPLD_Data buses.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

entity max4_cpld_flash_if is
   generic(
      BUS_WIDTH : integer := 64
   );
   port (
      rst             : in  std_logic;  -- Asynchronous reset
      sclk            : in  std_logic;  -- PCIe clock
      cclk            : in  std_logic;  -- Configuration clock
      -- Interface with the host (synchronous to sclk)
      TX_WE           : in  std_logic;
      TX_D            : in  std_logic_vector(BUS_WIDTH-1 downto 0);
      RX_ADDR         : in  std_logic;
      RX_D            : out std_logic_vector(BUS_WIDTH-1 downto 0);
      -- Interface with the cpld flash controller (synchronous to cclk)
      CPLD_Data_l     : inout std_logic_vector(15 downto 0);
      CPLD_Data_h     : inout std_logic_vector(9 downto 0);
      TO_CPLD_V       : out std_logic;
      FROM_CPLD_V     : in  std_logic
   );
end max4_cpld_flash_if;


architecture struct of max4_cpld_flash_if is

constant k_zero   : std_logic_vector(BUS_WIDTH-1 downto 0) := (others => '0');
constant k_one    : std_logic_vector(BUS_WIDTH-1 downto 0) := (others => '1');
constant k_FIFO_LEVEL_MAGIC_NUMBER : std_logic_vector(31 downto 0) := X"0000_005A";

--signal rst_fifo         : std_logic := '1';
--signal rst_sync         : std_logic_vector(5 downto 0) := (others => '1');

signal tx_fifo_empty   : std_logic := '1';
signal tx_fifo_wrcount : std_logic_vector(8 downto 0) := (others => '0');
signal tx_cmd_rd       : std_logic := '0';
signal tx_cmd_idle     : std_logic := '1';

signal rx_fifo_empty   : std_logic := '1';
signal rx_fifo_out     : std_logic_vector(BUS_WIDTH-1 downto 0);
signal rx_cmd_wr       : std_logic := '0';
signal rx_cmd_rd       : std_logic := '0';
signal rx_cmd_out      : std_logic_vector(BUS_WIDTH-1 downto 0);
signal rx_cmd_v        : std_logic := '0';

signal TO_FLASH_D      : std_logic_vector(BUS_WIDTH-1 downto 0);
signal TO_FLASH_V      : std_logic;
signal FROM_FLASH_D    : std_logic_vector(BUS_WIDTH-1 downto 0);
signal FROM_FLASH_V    : std_logic := '0';

signal to_flash_v_reg  : std_logic;
signal from_cpld_v_reg : std_logic;

--attribute shift_extract : string;
--attribute shift_extract of rst_sync : signal is "no";

begin

   -- Transfer commands from TX_D / TX_WE ports on sclk to the
   -- CPLD_Data / TO_CPLD_V ports on cclk
   -----------------------------------------------------------

   -- Asynchronous FIFO for transferring commands from sclk to cclk
   tx_cmd_fifo: dcfifo_mixed_widths
   generic map (
      add_ram_output_register => "OFF",
      add_usedw_msb_bit => "OFF",
      clocks_are_synchronized => "FALSE",
      delay_rdusedw => 1,
      delay_wrusedw => 1,
      lpm_numwords => 512,
      lpm_showahead => "OFF",
      lpm_width => BUS_WIDTH,
      lpm_width_r => BUS_WIDTH,
      lpm_widthu => 9,
      lpm_widthu_r => 9,
      overflow_checking => "ON",
      rdsync_delaypipe => 0,
      underflow_checking => "ON",
      use_eab => "ON",
      write_aclr_synch => "OFF",
      wrsync_delaypipe => 0,
      read_aclr_synch => "OFF",
      lpm_type => "dcfifo_mixed_widths"
   )
   port map (
      aclr => rst,
      data => TX_D,
      q => TO_FLASH_D,
      rdclk => cclk,
      rdempty => tx_fifo_empty,
      rdfull => open,
      rdreq => tx_cmd_rd,
      rdusedw => open,
      wrclk => sclk,
      wrempty => open,
      wrfull => open,
      wrreq => TX_WE,
      wrusedw => tx_fifo_wrcount
   );

   -- Read a command if the fifo isn't empty and a command is not already being
   -- processed
   tx_cmd_rd <= tx_cmd_idle and (not tx_fifo_empty);

   -- Stop being idle when a command is read from the FIFO
   process (rst, cclk)
   begin
      if rst = '1' then
         tx_cmd_idle  <= '1';
      elsif rising_edge(cclk) then
         if tx_cmd_rd = '1' then
            tx_cmd_idle  <= '0';
         elsif FROM_FLASH_V = '1' then
            tx_cmd_idle  <= '1';
         end if;
      end if;
   end process;

   -- The command is valid one cycle after it has been read
   -- (it's not a FWFT FIFO)
   process (rst, cclk)
   begin
      if rst = '1' then
         TO_FLASH_V <= '0';
      elsif rising_edge(cclk) then
         TO_FLASH_V <= tx_cmd_rd;
      end if;
   end process;


   -- Transfer commands from CPLD_Data / FROM_CPLD_V ports on cclk to the
   -- RX_D / RX_ADDR ports on sclk
   ----------------------------------------------------------------------

   -- Asynchronous FIFO for transferring commands from cclk to sclk
   rx_cmd_fifo: dcfifo_mixed_widths
   generic map (
      add_ram_output_register => "OFF",
      add_usedw_msb_bit => "OFF",
      clocks_are_synchronized => "FALSE",
      delay_rdusedw => 1,
      delay_wrusedw => 1,
      lpm_numwords => 512,
      lpm_showahead => "OFF",
      lpm_width => BUS_WIDTH,
      lpm_width_r => BUS_WIDTH,
      lpm_widthu => 9,
      lpm_widthu_r => 9,
      overflow_checking => "ON",
      rdsync_delaypipe => 0,
      underflow_checking => "ON",
      use_eab => "ON",
      write_aclr_synch => "OFF",
      wrsync_delaypipe => 0,
      read_aclr_synch => "OFF",
      lpm_type => "dcfifo_mixed_widths"
   )
   port map (
      aclr => rst,
      data => FROM_FLASH_D,
      q => rx_fifo_out,
      rdclk => sclk,
      rdempty => rx_fifo_empty,
      rdfull => open,
      rdreq => rx_cmd_rd,
      rdusedw => open,
      wrclk => cclk,
      wrempty => open,
      wrfull => open,
      wrreq => rx_cmd_wr,
      wrusedw => open
   );

   -- Write a command if it is the last in the tx_cmd_fifo
   rx_cmd_wr <= FROM_FLASH_V and tx_fifo_empty;

   -- Read a command if the fifo isn't empty
   rx_cmd_rd <= not rx_fifo_empty;


   process (rst, sclk)
   begin
      if rst = '1' then
         rx_cmd_out <= (others => '0');
         rx_cmd_v <= '0';
      elsif rising_edge(sclk) then
         if TX_WE = '1' then
            rx_cmd_out <= (others => '0');
         elsif rx_cmd_v = '1' then
            rx_cmd_out <= rx_fifo_out;
         end if;
         rx_cmd_v <= rx_cmd_rd;
      end if;
   end process;

   -- Select the output data based upon the RX_ADDR
   process (rst, sclk)
   begin
      if rst = '1' then
         RX_D <= (others => '0');
      elsif rising_edge(sclk) then
         if RX_ADDR = '0' then
            RX_D <= rx_cmd_out;
         else
            RX_D <= std_logic_vector(resize(unsigned(
               k_FIFO_LEVEL_MAGIC_NUMBER & k_zero(31 downto 18) &
               tx_fifo_wrcount & tx_fifo_wrcount), BUS_WIDTH));
         end if;
      end if;
   end process;


   ----------------------------------------------------------------------
   -- max4 cpld interface
   -- break the max3 64bit flash interface into 2 cycles of 26 bit words,
   -- some bits are unused
   ----------------------------------------------------------------------

   process (rst, cclk)
   begin
      if (rst='1') then

         FROM_FLASH_V  <= '0';
         TO_CPLD_V     <= '1';

      elsif rising_edge(cclk) then

         -- to flash
         to_flash_v_reg <= TO_FLASH_V;
         TO_CPLD_V      <= '1'; -- active low
         CPLD_Data_l    <= (others =>'Z');
         CPLD_Data_h    <= (others =>'Z');
         -- 1st cycle
         if (TO_FLASH_V ='1') then
            TO_CPLD_V   <= '0'; -- active low
            CPLD_Data_l <= TO_FLASH_D(15 downto  0);  -- data
            CPLD_Data_h <= (others =>'0');
            CPLD_Data_h(9 downto 8) <= TO_FLASH_D(63 downto 62);  -- cmd
         end if;
        -- 2nd cycle
         if (to_flash_v_reg ='1') then
            TO_CPLD_V   <= '0'; -- active low
            CPLD_Data_l <= TO_FLASH_D(15+32 downto    32);
            CPLD_Data_h <= TO_FLASH_D(25+32 downto 16+32);
         end if;

         -- from flash
         from_cpld_v_reg <= FROM_CPLD_V;
         FROM_FLASH_V    <= '0';
         FROM_FLASH_D(47 downto 16) <= (others =>'0');
         
         if (FROM_CPLD_V ='0') then -- active low
            -- 1st cycle
            if (from_cpld_v_reg ='1') then               
               FROM_FLASH_D(15 downto  0) <= CPLD_Data_l; -- data
            end if;
            -- 2nd cycle
            if (from_cpld_v_reg ='0') then
               FROM_FLASH_D(63 downto 48) <= CPLD_Data_l; -- opkt hdr
               FROM_FLASH_V <= '1';
            end if;
         end if;

      end if;
   end process;

end architecture struct;
