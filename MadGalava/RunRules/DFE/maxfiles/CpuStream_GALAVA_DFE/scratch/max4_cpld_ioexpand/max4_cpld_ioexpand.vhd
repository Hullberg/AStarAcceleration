-------------------------------------------------------------------------------
--
-- MAX4_CPLD_IOExpand:
--
-- Shift register to expand slow speed I/O signals to/from CPLD
--
-------------------------------------------------------------------------------

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_arith.all;
   use IEEE.std_logic_unsigned.all;
   use IEEE.math_real.all;

    entity max4_cpld_ioexpand is
      generic (
         BUS_WIDTH: integer;
         QSFP_PROFILE_ISCA : boolean;
         QSFP_PROFILE_JDFE: boolean
      );
      port (
      
         ---------------------
         -- Forced interface         
         ---------------------
         
         forced_output_values : in std_logic_vector(BUS_WIDTH-1 downto 0);
         forced_output_mask   : in std_logic_vector(BUS_WIDTH-1 downto 0);
         
                
         -------------------
         -- CPLD Interface
         -------------------
      
         Clk:               in    std_logic; -- Clock from CPLD
         RSTn:              in    std_logic; -- Reset from CPLD
      
         sData_from_CPLD:   in    std_logic; -- Serial data from CPLD
         sData_to_CPLD:     out   std_logic; -- Serial data to CPLD
         sData_sync_CPLD:   in    std_logic; -- Serial data sync from CPLD
      
         ------------------------------------
         -- Expanded CPLD I/O
         ------------------------------------
      
         -- I2C
         PMBUS_ALERT:        out std_logic;
         PMBUS_SCL_drv:      in  std_logic;
         PMBUS_SCL_fb:       out std_logic;
         PMBUS_SDA_drv:     in  std_logic;
         PMBUS_SDA_fb:      out std_logic;
      
         DIMM_ALERT:         out std_logic;
         DIMM_LEFT_SDA_drv:  in  std_logic;
         DIMM_LEFT_SDA_fb:   out std_logic;
         DIMM_LEFT_SCL_drv:  in  std_logic;
         DIMM_LEFT_SCL_fb:   out std_logic;
         DIMM_RIGHT_SDA_drv: in std_logic;
         DIMM_RIGHT_SDA_fb:  out std_logic;
         DIMM_RIGHT_SCL_drv: in std_logic;
         DIMM_RIGHT_SCL_fb:  out std_logic;
      
         AUX_ALERT:         out std_logic;
         AUX_SDA_drv:       in  std_logic;
         AUX_SDA_fb:        out std_logic;      
         AUX_SCL_drv:       in std_logic;
         AUX_SCL_fb:        out std_logic;
      
         QSFP0_ALERT:         out std_logic;
         QSFP0_SDA_drv:       in  std_logic;
         QSFP0_SDA_fb:        out std_logic;      
         QSFP0_SCL_drv:       in  std_logic;
         QSFP0_SCL_fb:        out std_logic;
         QSFP0_modprsl:       out std_logic;
         QSFP0_lpmode:        in  std_logic;
         QSFP0_modsell:       in  std_logic;
         QSFP0_resetl:        in  std_logic;
      
         QSFP1_ALERT:         out std_logic;
         QSFP1_SDA_drv:       in  std_logic;
         QSFP1_SDA_fb:        out std_logic;      
         QSFP1_SCL_drv:       in  std_logic;
         QSFP1_SCL_fb:        out std_logic;
         QSFP1_modprsl:       out std_logic;
         QSFP1_lpmode:        in  std_logic;
         QSFP1_modsell:       in  std_logic;
         QSFP1_resetl:        in  std_logic;
      
         QSFP2_ALERT:         out std_logic;
         QSFP2_SDA_drv:       in  std_logic;
         QSFP2_SDA_fb:        out std_logic;      
         QSFP2_SCL_drv:       in  std_logic;
         QSFP2_SCL_fb:        out std_logic;
         QSFP2_modprsl:       out std_logic;
         QSFP2_lpmode:        in  std_logic;
         QSFP2_modsell:       in  std_logic;
         QSFP2_resetl:        in  std_logic;

         QSFP3_ALERT:         out std_logic;
         QSFP3_SDA_drv:       in  std_logic;
         QSFP3_SDA_fb:        out std_logic;      
         QSFP3_SCL_drv:       in  std_logic;
         QSFP3_SCL_fb:        out std_logic;
         QSFP3_modprsl:       out std_logic;
         QSFP3_lpmode:        in  std_logic;
         QSFP3_modsell:       in  std_logic;
         QSFP3_resetl:        in  std_logic;
      
         QSFP4_ALERT:         out std_logic;
         QSFP4_SDA_drv:       in  std_logic;
         QSFP4_SDA_fb:        out std_logic;      
         QSFP4_SCL_drv:       in  std_logic;
         QSFP4_SCL_fb:        out std_logic;
         QSFP4_modprsl:       out std_logic;
         QSFP4_lpmode:        in  std_logic;
         QSFP4_modsell:       in  std_logic;
         QSFP4_resetl:        in  std_logic;

         QSFP5_ALERT:         out std_logic;
         QSFP5_SDA_drv:       in  std_logic;
         QSFP5_SDA_fb:        out std_logic;      
         QSFP5_SCL_drv:       in  std_logic;
         QSFP5_SCL_fb:        out std_logic;
         QSFP5_modprsl:       out std_logic;
         QSFP5_lpmode:        in  std_logic;
         QSFP5_modsell:       in  std_logic;
         QSFP5_resetl:        in  std_logic;
      
         QSFP6_ALERT:         out std_logic;
         QSFP6_SDA_drv:       in  std_logic;
         QSFP6_SDA_fb:        out std_logic;      
         QSFP6_SCL_drv:       in  std_logic;
         QSFP6_SCL_fb:        out std_logic;
         QSFP6_modprsl:       out std_logic;
         QSFP6_lpmode:        in  std_logic;
         QSFP6_modsell:       in  std_logic;
         QSFP6_resetl:        in  std_logic;
      
         QSFP7_ALERT:         out std_logic;
         QSFP7_SDA_drv:       in  std_logic;
         QSFP7_SDA_fb:        out std_logic;      
         QSFP7_SCL_drv:       in  std_logic;
         QSFP7_SCL_fb:        out std_logic;
         QSFP7_modprsl:       out std_logic;
         QSFP7_lpmode:        in  std_logic;
         QSFP7_modsell:       in  std_logic;
         QSFP7_resetl:        in  std_logic;
      
         -- Misc
         ASSY_REV:           out std_logic_vector(1 downto 0);
         PCB_REV:            out std_logic_vector(1 downto 0);
         max4n_build_rev:    in  std_logic_vector(1 downto 0);
         BUILD_REV:          out std_logic_vector(1 downto 0);
      
         DDR_VREFDQ_RIGHT_POWER_GOOD:  out std_logic;
         DDR_VREFDQ_LEFT_POWER_GOOD:   out std_logic;
         CTL1_POWER_GOOD:              out std_logic;
         CTL2_POWER_GOOD:              out std_logic;
      
         FPGA_INIT_DONE:      out std_logic;
         FPGA_CRC_ERROR:      out std_logic;
         FPGA_CvP_CONFDONE:   out std_logic;
      
         DIPSW:             out std_logic_vector(3 downto 0);
      
         MAXRING_B_RESET:   in std_logic;
      
         -- LEDs
         LED_PHY1_UP:       in std_logic;
         LED_PHY2_UP:       in std_logic;
         LED_PHY3_UP:       in std_logic;
         LED_PHY4_UP:       in std_logic;
         LED_PHY5_UP:       in std_logic;
         LED_PHY6_UP:       in std_logic;
      
         LED_MAXRING_A:     in std_logic;
         LED_MAXRING_B:     in std_logic;
         LED_PAN_MAXRING_A: in std_logic;
         LED_PAN_MAXRING_B: in std_logic;
      
         LED_IDENTIFY:      in std_logic;
         LED_PCIE_UP:       in std_logic;
         LED_WARNING:       in std_logic;
         LED_ERROR:         in std_logic;
      
         -- maxring
         MAXRING_A_TOP_SB_dir:    in std_logic_vector(3 downto 0);
         MAXRING_A_TOP_SB_drv:    in std_logic_vector(3 downto 0);
         MAXRING_A_TOP_SB_fb:     out std_logic_vector(3 downto 0);
      
         MAXRING_A_BOTTOM_SB_dir: in std_logic_vector(3 downto 0);
         MAXRING_A_BOTTOM_SB_drv: in std_logic_vector(3 downto 0);
         MAXRING_A_BOTTOM_SB_fb:  out std_logic_vector(3 downto 0);
      
         MAXRING_B_MODTX_SB_dir:  in std_logic_vector(1 downto 0);
         MAXRING_B_MODTX_SB_drv:  in std_logic_vector(1 downto 0);
         MAXRING_B_MODTX_SB_fb:   out std_logic_vector(1 downto 0);
      
         MAXRING_B_MODRX_SB_dir:  in std_logic_vector(1 downto 0);
         MAXRING_B_MODRX_SB_drv:  in std_logic_vector(1 downto 0);
         MAXRING_B_MODRX_SB_fb:   out std_logic_vector(1 downto 0);
         
         CPLD_Version:            out std_logic_vector(7 downto 0); 
         Reconfig_Trigger:        in std_logic
      
      );
   end;

    architecture rtl of max4_cpld_ioexpand is
   
      -- Width of counters
      constant BUS_WIDTH_LOG2 : integer := integer(ceil(log2(real(BUS_WIDTH))));
   
      -- shift reg
      signal shift_ptr:  std_logic_vector(BUS_WIDTH_LOG2-1 downto 0);
      signal shift_ptr2: std_logic_vector(BUS_WIDTH_LOG2-1 downto 0);
      signal sync:       std_logic_vector(2 downto 0);
      signal shift_from_CPLD_r: std_logic;
      signal shift_to_CPLD:     std_logic;
      signal shift_sync_r:      std_logic;
   
      -- expanded data from CPLD
      signal Exp_from_CPLD:   std_logic_vector(BUS_WIDTH-1 downto 0) := (others =>'0');
      signal Exp_from_CPLD_i: std_logic_vector(BUS_WIDTH-1 downto 0) := (others =>'0');
      signal exp_from_cpld_v: std_logic := '0';
   
      -- expanded data to CPLD
      signal Exp_to_CPLD:     std_logic_vector(BUS_WIDTH-1 downto 0) := (others =>'0');
      signal Exp_to_CPLD_r1:  std_logic_vector(BUS_WIDTH-1 downto 0) := (others =>'0');
      signal Exp_to_CPLD_r2:  std_logic_vector(BUS_WIDTH-1 downto 0) := (others =>'0');
   
      attribute preserve: boolean;
      attribute preserve of Exp_to_CPLD_r1: signal is true;
      attribute preserve of Exp_to_CPLD_r2: signal is true;
   
      --attribute altera_attribute : string;
      --attribute altera_attribute of Exp_to_CPLD_r1 : signal is "-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS";
   
   begin
   
   
      --------------------------------------------------------
      -- shift register
   
      shift:
       process(Clk)
      begin
         if (Clk'event and Clk='1') then
         
            -- inc shift pointers
            shift_ptr  <= shift_ptr +1;
            shift_ptr2 <= shift_ptr2 +1;
         
            -- sync shift regs to CPLD shifter
            shift_sync_r  <= sData_sync_CPLD;
            if (shift_sync_r = '0') then
               shift_ptr  <= conv_std_logic_vector(1, BUS_WIDTH_LOG2); -- magic numbers to adjust for delays
               shift_ptr2 <= conv_std_logic_vector(5, BUS_WIDTH_LOG2); -- magic numbers to adjust for delays
               sync <= sync(1 downto 0) & '1';
            end if;
         
            -- retime local inputs to CPLD clock domain
            Exp_to_CPLD_r1 <= (Exp_to_CPLD and (not forced_output_mask)) or forced_output_values;
            Exp_to_CPLD_r2 <= Exp_to_CPLD_r1;
            -- send out local data
            shift_to_CPLD  <= Exp_to_CPLD_r2(conv_integer(shift_ptr2));
         
            -- read in remote data
            shift_from_CPLD_r <= sData_from_CPLD;
            Exp_from_CPLD_i(conv_integer(shift_ptr)) <= shift_from_CPLD_r;
         
            -- wait for 3 syncs before outputing data and check valid bit
            if (sync="111") then
               Exp_from_CPLD <= Exp_from_CPLD_i;
               exp_from_cpld_v <= '1';
            end if;
         
            -- sync reset
            if (RSTn='0' and Reconfig_Trigger='0') then --transmit
               shift_ptr     <= (others =>'0');
               shift_ptr2    <= (others =>'0');
               Exp_from_CPLD <= (others =>'0');
               sync          <= "000";
               exp_from_cpld_v <= '0';
            end if;
         end if;
      end process;
   
      -- send out serial data, mimic 10ns tco of pad
      sData_to_CPLD <= transport shift_to_CPLD after 10 ns;
   
   
      -----------------------------------------------------------------
      -- Map slow signals to/from shift reg, should be reverse of CPLD
   
      -- I2C
      Exp_to_CPLD(0) <= PMBUS_SCL_drv;
      Exp_to_CPLD(1) <= PMBUS_SDA_drv;
      Exp_to_CPLD(2) <= DIMM_LEFT_SCL_drv;
      Exp_to_CPLD(3) <= DIMM_LEFT_SDA_drv;
      Exp_to_CPLD(4) <= DIMM_RIGHT_SCL_drv;
      Exp_to_CPLD(5) <= DIMM_RIGHT_SDA_drv;
      Exp_to_CPLD(6) <= AUX_SCL_drv;
      Exp_to_CPLD(7) <= AUX_SDA_drv;
   
      PMBUS_SCL_fb      <= Exp_from_CPLD(0);
      PMBUS_SDA_fb     <= Exp_from_CPLD(1);
      DIMM_LEFT_SCL_fb  <= Exp_from_CPLD(2);
      DIMM_LEFT_SDA_fb  <= Exp_from_CPLD(3);
      DIMM_RIGHT_SCL_fb <= Exp_from_CPLD(4);
      DIMM_RIGHT_SDA_fb <= Exp_from_CPLD(5);
      AUX_SCL_fb        <= Exp_from_CPLD(6);
      AUX_SDA_fb        <= Exp_from_CPLD(7);
   
      PMBUS_ALERT    <= Exp_from_CPLD(8) when exp_from_cpld_v = '1' else '1';
      DIMM_ALERT     <= Exp_from_CPLD(9) when exp_from_cpld_v = '1' else '1';
      AUX_ALERT      <= Exp_from_CPLD(10) when exp_from_cpld_v = '1' else '1';
   
      -- Misc
      Exp_to_CPLD(12) <= MAXRING_B_RESET;
   
      ASSY_REV <= Exp_from_CPLD(17 downto 16);
      PCB_REV  <= Exp_from_CPLD(19 downto 18);
   
      DIPSW    <= Exp_from_CPLD(23 downto 20);
      BUILD_REV <= max4n_build_rev;
   
      CTL1_POWER_GOOD             <= Exp_from_CPLD(24) when exp_from_cpld_v = '1' else '0';
      CTL2_POWER_GOOD             <= Exp_from_CPLD(25) when exp_from_cpld_v = '1' else '0';
      DDR_VREFDQ_RIGHT_POWER_GOOD <= Exp_from_CPLD(26) when exp_from_cpld_v = '1' else '0';
      DDR_VREFDQ_LEFT_POWER_GOOD  <= Exp_from_CPLD(27) when exp_from_cpld_v = '1' else '0';
   
      FPGA_INIT_DONE    <= Exp_from_CPLD(12);
      FPGA_CRC_ERROR    <= Exp_from_CPLD(13);
      FPGA_CvP_CONFDONE <= Exp_from_CPLD(14);
   
      -- LEDs
      Exp_to_CPLD(16) <= LED_PHY1_UP;
      Exp_to_CPLD(17) <= LED_PHY2_UP;
      Exp_to_CPLD(18) <= LED_PHY3_UP;
      Exp_to_CPLD(19) <= LED_PHY4_UP;
      Exp_to_CPLD(28) <= LED_PHY5_UP;
      Exp_to_CPLD(29) <= LED_PHY6_UP;
   
      Exp_to_CPLD(20) <= LED_MAXRING_A;
      Exp_to_CPLD(21) <= LED_MAXRING_B;
      Exp_to_CPLD(22) <= LED_PAN_MAXRING_A;
      Exp_to_CPLD(23) <= LED_PAN_MAXRING_B;
   
      Exp_to_CPLD(24) <= LED_IDENTIFY;
      Exp_to_CPLD(25) <= LED_PCIE_UP;
      Exp_to_CPLD(26) <= LED_WARNING;
      Exp_to_CPLD(27) <= LED_ERROR;
   
      -- Maxring sidebands
      Exp_to_CPLD(35 downto 32) <= MAXRING_A_TOP_SB_drv;
      Exp_to_CPLD(39 downto 36) <= MAXRING_A_TOP_SB_dir;
      MAXRING_A_TOP_SB_fb <= Exp_from_CPLD(35 downto 32);
   
      Exp_to_CPLD(43 downto 40) <= MAXRING_A_BOTTOM_SB_drv;
      Exp_to_CPLD(47 downto 44) <= MAXRING_A_BOTTOM_SB_dir;
      MAXRING_A_BOTTOM_SB_fb <= Exp_from_CPLD(43 downto 40);
   
      Exp_to_CPLD(49 downto 48) <= MAXRING_B_MODTX_SB_drv;
      Exp_to_CPLD(51 downto 50) <= MAXRING_B_MODTX_SB_dir;
      MAXRING_B_MODTX_SB_fb <= Exp_from_CPLD(49 downto 48);
   
      Exp_to_CPLD(53 downto 52) <= MAXRING_B_MODRX_SB_drv;
      Exp_to_CPLD(55 downto 54) <= MAXRING_B_MODRX_SB_dir;
      MAXRING_B_MODRX_SB_fb <= Exp_from_CPLD(53 downto 52);
   
      CPLD_Version <= Exp_from_CPLD(63 downto 56);
      
      Exp_to_CPLD(60) <= Reconfig_Trigger;
      
      g_new_isca_profile: if BUS_WIDTH >= 128 and QSFP_PROFILE_ISCA generate 
         Exp_to_CPLD(64)  <= not QSFP1_SCL_drv;	-- CPLD expects inverted polarity
         Exp_to_CPLD(65)  <= not QSFP1_SDA_drv;	-- CPLD expects inverted polarity
         Exp_to_CPLD(66)  <= not QSFP1_resetl;   -- CPLD expects inverted polarity
         Exp_to_CPLD(67)  <= QSFP1_lpmode;
         QSFP1_SCL_fb  <= Exp_from_CPLD(64);
         QSFP1_SDA_fb  <= Exp_from_CPLD(65);
         QSFP1_ALERT   <= Exp_from_CPLD(66) when exp_from_cpld_v = '1' else '1';
         QSFP1_modprsl <= Exp_from_CPLD(67) when exp_from_cpld_v = '1' else '1';
      
         Exp_to_CPLD(68)  <= not QSFP2_SCL_drv;	-- CPLD expects inverted polarity
         Exp_to_CPLD(69)  <= not QSFP2_SDA_drv;	-- CPLD expects inverted polarity
         Exp_to_CPLD(70)  <= not QSFP2_resetl;   -- CPLD expects inverted polarity
         Exp_to_CPLD(71)  <= QSFP2_lpmode;
         QSFP2_SCL_fb  <= Exp_from_CPLD(68);
         QSFP2_SDA_fb  <= Exp_from_CPLD(69);
         QSFP2_ALERT   <= Exp_from_CPLD(70) when exp_from_cpld_v = '1' else '1';
         QSFP2_modprsl <= Exp_from_CPLD(71) when exp_from_cpld_v = '1' else '1';
      
         Exp_to_CPLD(72)  <= not QSFP0_SCL_drv;	-- CPLD expects inverted polarity
         Exp_to_CPLD(73)  <= not QSFP0_SDA_drv;	-- CPLD expects inverted polarity
         Exp_to_CPLD(74)  <= not QSFP0_resetl;   -- CPLD expects inverted polarity
         Exp_to_CPLD(75)  <= QSFP0_lpmode;
         QSFP0_SCL_fb  <= Exp_from_CPLD(72);
         QSFP0_SDA_fb  <= Exp_from_CPLD(73);
         QSFP0_ALERT   <= Exp_from_CPLD(74) when exp_from_cpld_v = '1' else '1';
         QSFP0_modprsl <= Exp_from_CPLD(75) when exp_from_cpld_v = '1' else '1';
         
         Exp_to_CPLD(76)  <= '1';
         Exp_to_CPLD(77)  <= '1';
         Exp_to_CPLD(78)  <= '1';
         Exp_to_CPLD(79)  <= '0';            

         QSFP3_SCL_fb  <= '0';
         QSFP3_SDA_fb  <= '0';
         QSFP3_ALERT   <= '1';
         QSFP3_modprsl <= '1';
         
         QSFP4_SCL_fb  <= '0';
         QSFP4_SDA_fb  <= '0';
         QSFP4_ALERT   <= '1';
         QSFP4_modprsl <= '1';
         
         QSFP5_SCL_fb  <= '0';
         QSFP5_SDA_fb  <= '0';
         QSFP5_ALERT   <= '1';
         QSFP5_modprsl <= '1';
         
         QSFP6_SCL_fb  <= '0';
         QSFP6_SDA_fb  <= '0';
         QSFP6_ALERT   <= '1';
         QSFP6_modprsl <= '1';
         
         QSFP7_SCL_fb  <= '0';
         QSFP7_SDA_fb  <= '0';
         QSFP7_ALERT   <= '1';
         QSFP7_modprsl <= '1';
      end generate;
      
      g_jdfe_profile: if QSFP_PROFILE_JDFE generate 
         QSFP0_SCL_fb  <= '0';
         QSFP0_SDA_fb  <= '0';
         QSFP0_ALERT   <= '1';
         QSFP0_modprsl <= '1';
         
         QSFP1_SCL_fb  <= '0';
         QSFP1_SDA_fb  <= '0';
         QSFP1_ALERT   <= '1';
         QSFP1_modprsl <= '1';
         
         QSFP2_SCL_fb  <= '0';
         QSFP2_SDA_fb  <= '0';
         QSFP2_ALERT   <= '1';
         QSFP2_modprsl <= '1';
         
         QSFP3_SCL_fb  <= '0';
         QSFP3_SDA_fb  <= '0';
         QSFP3_ALERT   <= '1';
         QSFP3_modprsl <= '1';
         
         Exp_to_CPLD(64)  <= not QSFP4_SCL_drv;	-- CPLD expects inverted polarity
         Exp_to_CPLD(65)  <= not QSFP4_SDA_drv;	-- CPLD expects inverted polarity
         Exp_to_CPLD(66)  <= not QSFP4_resetl;   -- CPLD expects inverted polarity
         Exp_to_CPLD(67)  <= QSFP4_lpmode;
         QSFP4_SCL_fb  <= Exp_from_CPLD(64);
         QSFP4_SDA_fb  <= Exp_from_CPLD(65);
         QSFP4_ALERT   <= Exp_from_CPLD(66) when exp_from_cpld_v = '1' else '1';
         QSFP4_modprsl <= Exp_from_CPLD(67) when exp_from_cpld_v = '1' else '1';
      
         Exp_to_CPLD(68)  <= not QSFP5_SCL_drv;	-- CPLD expects inverted polarity
         Exp_to_CPLD(69)  <= not QSFP5_SDA_drv;	-- CPLD expects inverted polarity
         Exp_to_CPLD(70)  <= not QSFP5_resetl;   -- CPLD expects inverted polarity
         Exp_to_CPLD(71)  <= QSFP5_lpmode;
         QSFP5_SCL_fb  <= Exp_from_CPLD(68);
         QSFP5_SDA_fb  <= Exp_from_CPLD(69);
         QSFP5_ALERT   <= Exp_from_CPLD(70) when exp_from_cpld_v = '1' else '1';
         QSFP5_modprsl <= Exp_from_CPLD(71) when exp_from_cpld_v = '1' else '1';
      
         Exp_to_CPLD(72)  <= not QSFP6_SCL_drv;	-- CPLD expects inverted polarity
         Exp_to_CPLD(73)  <= not QSFP6_SDA_drv;	-- CPLD expects inverted polarity
         Exp_to_CPLD(74)  <= not QSFP6_resetl;   -- CPLD expects inverted polarity
         Exp_to_CPLD(75)  <= QSFP6_lpmode;
         QSFP6_SCL_fb  <= Exp_from_CPLD(72);
         QSFP6_SDA_fb  <= Exp_from_CPLD(73);
         QSFP6_ALERT   <= Exp_from_CPLD(74) when exp_from_cpld_v = '1' else '1';
         QSFP6_modprsl <= Exp_from_CPLD(75) when exp_from_cpld_v = '1' else '1';
         
         Exp_to_CPLD(76)  <= not QSFP7_SCL_drv;	-- CPLD expects inverted polarity
         Exp_to_CPLD(77)  <= not QSFP7_SDA_drv;	-- CPLD expects inverted polarity
         Exp_to_CPLD(78)  <= not QSFP7_resetl;   -- CPLD expects inverted polarity
         Exp_to_CPLD(79)  <= QSFP7_lpmode;
         QSFP7_SCL_fb  <= Exp_from_CPLD(76);
         QSFP7_SDA_fb  <= Exp_from_CPLD(77);
         QSFP7_ALERT   <= Exp_from_CPLD(78) when exp_from_cpld_v = '1' else '1';
         QSFP7_modprsl <= Exp_from_CPLD(79) when exp_from_cpld_v = '1' else '1';         
      end generate;
      
      Exp_to_CPLD(BUS_WIDTH-1) <= '0'; -- used as a valid, when serial bus is tristate this bit will float high
   
   end rtl;
