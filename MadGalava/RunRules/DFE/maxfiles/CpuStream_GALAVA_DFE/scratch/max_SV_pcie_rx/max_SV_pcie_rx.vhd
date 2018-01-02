------------------------------------------------------------------
-- TLP RX for Altera PCIe
-- Copyright 2011 Maxeler Technologies Inc. All Rights Reserved
-- Author : rob, craig
------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity max_SV_pcie_rx is
    generic (
        SIM_RX : boolean := false
        );
	port (
		-- Old Xilinx EP Interface
		clk_pcie			: in std_logic;
		rst_pcie_n			: in std_logic;
		-- Altera EP Core Avalon ST Interface
		rx_st_ready	: out std_logic; -- assert to ready to indicate ready for data
		rx_st_valid	: in std_logic; -- asserted same cycle as rx_st_data
		rx_st_data	: in std_logic_vector(127 downto 0); -- Avalon RX Data
		rx_st_sop	: in std_logic; -- start of packet, valid when asserted with rx_st_valid
		rx_st_eop	: in std_logic; -- end of packet, valid when asserted with rx_st_valid
		rx_st_empty	: in std_logic_vector(1 downto 0);	-- for 128-bit rx_st_data when asserted with eop 
														-- this indicates only rx_st_data[63..0] is valid
		rx_st_err	: in std_logic;	-- asserts with rx_st_valid for at least one cycle to indicate 
									-- an uncorrectable error condition has occured. Recommended 
									-- to reset the core when detected to avoid CSR corruption 
		rx_st_mask	: out std_logic; -- assert to throttle non-posted requests
		rx_st_bar	: in std_logic_vector(7 downto 0); -- one-hot BAR decoding for PCIe mapped memory bar space
		--rx_st_be	: in std_logic_vector(15 downto 0); -- byte-enables valid with data

		-- interface to dma in
		dma_response_data		: out std_logic_vector(127 downto 0);
		dma_response_valid		: out std_logic_vector(1 downto 0);
		-- interface to dma sg - which completions we got
		dma_response_len		: out std_logic_vector(9 downto 0);
		dma_response_tag		: out std_logic_vector(7 downto 0);
		dma_response_complete   : out std_logic;
		dma_response_ready		: out std_logic;
		-- interface to registers/and sg RAM write
		reg_data_out		: out std_logic_vector(63 downto 0);
		reg_data_wren		: out std_logic_vector(7 downto 0); 
		reg_data_addr		: out std_logic_vector(63 downto 0);
		reg_data_bar0			: out std_logic := '0';
		reg_data_bar2			: out std_logic := '0';
		-- interface to register read completions
		compl_bar2		: out std_logic; 
		compl_tc		: out std_logic_vector(2 downto 0); -- read TC
		compl_td		: out std_logic; -- read TD
		compl_ep		: out std_logic; -- read EP
		compl_attr		: out std_logic_vector(1 downto 0); -- read attribute
		compl_rid		: out std_logic_vector(15 downto 0); -- read requestor ID
		compl_tag		: out std_logic_vector(7 downto 0); -- read tag
		compl_addr		: out std_logic_vector(63 downto 0); -- read address NOW 64 BITS!
		compl_size		: out std_logic_vector(9 downto 0); -- size in dwords
		compl_req		: out std_logic;
		compl_full		: in std_logic;
		-- configuration interface
		--cfg_err_ur_n		: out std_logic; -- unsupported request
		--cfg_err_tlp_cpl_header  : out std_logic_vector(47 downto 0);
		-- 47:41 lower_addr, 40:29 byte count, 28:26 TC 25:24 Attr 23:8 Req Id 7:0 tag
		--cfg_err_cpl_rdy_n	   : in std_logic
		cpl_err			 : out std_logic_vector(6 downto 0);
		cpl_pending		 : out std_logic;
		-- interface to BA4, read and write
		sl_en    : out std_logic;	-- Slave enable (bar hit)
		sl_rd_en : out std_logic;
		sl_wr_en : out std_logic;
		-- BAR4 writes
		sl_wr_addr : out std_logic_vector(63 downto 0);   -- write address
		sl_wr_size : out std_logic_vector(9 downto 0);    -- size of write, in multiples of dword - Will not decrease during the xfer
		sl_wr_data : out std_logic_vector(127 downto 0);  -- write_data
		sl_wr_be   : out std_logic_vector(15 downto 0);   -- Byte enable, valid for sl_wr_data each time sl_wren is 1
		sl_wr_last : out std_logic;                       -- asserted when the last octaword of data is transmitted
		-- Completion metadata (used for memory reads)
		sl_rd_tc    : out std_logic_vector(2 downto 0);   -- TC
		sl_rd_td    : out std_logic; -- TD
		sl_rd_ep    : out std_logic; -- EP
		sl_rd_attr  : out std_logic_vector(1 downto 0);   -- attribute
		sl_rd_rid   : out std_logic_vector(15 downto 0);  -- requestor ID
		sl_rd_tag   : out std_logic_vector(7 downto 0);   -- tag
		sl_rd_be    : out std_logic_vector(7 downto 0);   -- byte enable (7 downto 4: Last dword BE, 3 downto 0: First dword BE)
		sl_rd_addr  : out std_logic_vector(63 downto 0);  -- read address
		sl_rd_size  : out std_logic_vector(9 downto 0)    -- read size
	);
end max_SV_pcie_rx;

architecture rtl of max_SV_pcie_rx is
	
	-- memory read/write packets
	constant MEM_RD32_FMT_TYPE		: std_logic_vector(6 downto 0) := "0000000";
	constant MEM_WR32_FMT_TYPE		: std_logic_vector(6 downto 0) := "1000000";
	constant MEM_RD64_FMT_TYPE		: std_logic_vector(6 downto 0) := "0100000";
	constant MEM_WR64_FMT_TYPE		: std_logic_vector(6 downto 0) := "1100000";
	
	constant COMPLETION_DATA_FMT_TYPE	: std_logic_vector(6 downto 0) := "1001010";
	constant COMPLETION_NODATA_FMT_TYPE : std_logic_vector(6 downto 0) := "0001010";
	
	
	-- Data Remainder
	constant REM_127_0  : std_logic_vector(1 downto 0) := "00";
	constant REM_64_0 : std_logic_vector(1 downto 0) := "01";
	
	--type rx_state_t is (RST_STATE, RX_DW3DW4_UNALIGNED);
	--signal rx_state : rx_state_t := RST_STATE;

	type   data_streamer_t is (IDLE_STREAM, REM_STREAM );
	signal completion_stream_state : data_streamer_t := IDLE_STREAM;
	
	signal data_stream_aligned : std_logic := '0';
	signal data_stream_go	  : std_logic := '0';

	type   data_writer_t   is (IDLE_WRITER, DATA_ALIGNED, DATA_WR64_UNALIGNED, DATA_WR32_UNALIGNED, SL_DATA_ALIGNED);
	signal data_writer_state : data_writer_t := IDLE_WRITER;
	signal data_writer_next_addr : std_logic_vector(63 downto 0);  -- Address for the next cycle
	signal data_writer_firstbe : std_logic_vector(3 downto 0);     -- Here we store the "First BE" 4 bits from the header to be used for the first dword - note that firstbe is applied to the first dword of the octaword at each beat but except for the first beat its value will be "1111" (no effect)
	signal data_writer_lastbe : std_logic_vector(3 downto 0);     -- Here we store the "Last BE" 4 bits from the header to be used at the end of the packet
    signal data_writer_rem : std_logic;		-- store whether there is an odd number of DW in the write
    
	signal is_write_packet : std_logic;
   
	--signal fmt64_type : std_logic; 
	
	-- Header processor
	signal bars_hit : std_logic := '0';
	signal bars_hit_r : std_logic := '0';
	signal bar4_hit : std_logic := '0';
	signal bar4_hit_r : std_logic := '0';
	
	-- number of dwords left in posted write packet
	signal next_reg_wr_data_remainder_odd : std_logic;
	
	-- buffer rx interface
	signal rx_st_valid_reg	: std_logic;
	signal rx_st_data_reg	: std_logic_vector(127 downto 0);
	signal rx_st_sop_reg	: std_logic;
	signal rx_st_eop_reg	: std_logic;
	signal rx_st_empty_reg : std_logic_vector(1 downto 0);
	signal rx_st_err_reg	: std_logic;
	signal rx_st_bar_reg	: std_logic_vector(7 downto 0);   
	 
	-- completions in
	
	signal compl_be_int : std_logic_vector(7 downto 0) := (others => '0'); 
	signal compl_tc_int : std_logic_vector(2 downto 0);
	signal compl_td_int : std_logic;
	signal compl_ep_int : std_logic;
	signal compl_attr_int : std_logic_vector(1 downto 0);
	signal compl_rid_int : std_logic_vector(15 downto 0);
	signal compl_tag_int : std_logic_vector(7 downto 0);
	signal compl_addr_int : std_logic_vector(63 downto 0);
	signal compl_size_int : std_logic_vector(9 downto 0);

	attribute keep_hierarchy : string;
	attribute keep_hierarchy of rtl : architecture is "soft";

	signal rx_st_eop_r : std_logic := '0';
	signal rx_st_data_r : std_logic_vector(127 downto 0);
	signal rx_st_empty_r : std_logic_vector(1 downto 0) := "00";
	signal packet_aligned : std_logic := '0';
	signal dma_response_ready_next : std_logic := '0';

	signal reg_bar0, reg_bar2 : std_logic := '0';

	-- Altera specific add-ons:
	signal hdr_first_dw_be, hdr_last_dw_be : std_logic_vector(3 downto 0);
	signal qw_aligned_addr, wr32_type, wr64_type : std_logic;
	constant HDR_DW_ADDR_BIT : natural := 34;
	
	signal pcie_sync_rst_n :std_logic;
	signal reset_pcie_n_r : std_logic_vector(2 downto 0) := (others => '1');
  
begin

	--process (clk_pcie, rst_pcie_n)
	--begin
	--	if rst_pcie_n = '0' then
	--		reset_pcie_n_r <= "000";
	--	elsif rising_edge(clk_pcie) then
	--		reset_pcie_n_r(2) <= '1';
	--		reset_pcie_n_r(1) <= reset_pcie_n_r(2);
	--		reset_pcie_n_r(0) <= reset_pcie_n_r(1);
	--	end if;
	--end process;
	--pcie_sync_rst_n <= reset_pcie_n_r(0);
	pcie_sync_rst_n <= rst_pcie_n;
	
	compl_tc <= compl_tc_int;
	compl_td <= compl_td_int;
	compl_ep <= compl_ep_int;
	compl_attr <= compl_attr_int;
	compl_rid <= compl_rid_int;
	compl_tag <= compl_tag_int;
	compl_addr <= compl_addr_int;
	compl_size <= compl_size_int;
	
	sl_rd_tc <= compl_tc_int;
	sl_rd_td <= compl_td_int;
	sl_rd_ep <= compl_ep_int;
	sl_rd_attr <= compl_attr_int;
	sl_rd_rid <= compl_rid_int;
	sl_rd_tag <= compl_tag_int;
	sl_rd_be <= compl_be_int;
	sl_rd_addr <= compl_addr_int;
	sl_rd_size <= compl_size_int;
	
	-- always ready to receive packets
	rx_st_ready <= '1';
	
	rx_st_mask <= compl_full;
	
--  FIXME: Support erroneous requests
--   process(clk_pcie)
--   begin
--	   if rising_edge(clk_pcie) then
--		   case (compl_be(3 downto 0)) is
--			   when "1111" => cfg_err_tlp_cpl_header(40 downto 29) <= "000000000100"; -- byte count
--			   when "0111" => cfg_err_tlp_cpl_header(40 downto 29) <= "000000000011"; -- byte count
--			   when "1110" => cfg_err_tlp_cpl_header(40 downto 29) <= "000000000011"; -- byte count
--			   when "0011" => cfg_err_tlp_cpl_header(40 downto 29) <= "000000000010"; -- byte count
--			   when "0110" => cfg_err_tlp_cpl_header(40 downto 29) <= "000000000010"; -- byte count
--			   when "1100" => cfg_err_tlp_cpl_header(40 downto 29) <= "000000000010"; -- byte count
--			   when others => cfg_err_tlp_cpl_header(40 downto 29) <= "000000000001"; -- byte count
--		   end case;
--		   case (compl_be(3 downto 0)) is
--			   when "0010" => cfg_err_tlp_cpl_header(42 downto 41) <= "01"; -- ls bits of lower addr
--			   when "0110" => cfg_err_tlp_cpl_header(42 downto 41) <= "01"; -- ls bits of lower addr
--			   when "1010" => cfg_err_tlp_cpl_header(42 downto 41) <= "01"; -- ls bits of lower addr
--			   when "1110" => cfg_err_tlp_cpl_header(42 downto 41) <= "01"; -- ls bits of lower addr
--			   when "0100" => cfg_err_tlp_cpl_header(42 downto 41) <= "10"; -- ls bits of lower addr
--			   when "1100" => cfg_err_tlp_cpl_header(42 downto 41) <= "10"; -- ls bits of lower addr
--			   when "1000" => cfg_err_tlp_cpl_header(42 downto 41) <= "11"; -- ls bits of lower addr
--			   when others => cfg_err_tlp_cpl_header(42 downto 41) <= "00"; -- ls bits of lower addr
--		   end case;
--		   cfg_err_tlp_cpl_header(28 downto 26) <= compl_tc_int; -- tc
--		   cfg_err_tlp_cpl_header(25 downto 24) <= compl_attr_int; -- attr
--		   cfg_err_tlp_cpl_header(23 downto 8) <= compl_rid_int; -- req id
--		   cfg_err_tlp_cpl_header(7 downto 0) <= compl_tag_int; -- tag
--	   end if;
--   end process;

--	cfg_err_tlp_cpl_header  <= (others => '0');
--	packet_aligned		<= '1'; -- For Altera EP packet headers are always aligned... but the payload alignment can shift
--	cfg_err_ur_n		<= '1';
	cpl_err				<= (others => '0');
	cpl_pending			<= '0';
	bars_hit			<= rx_st_bar_reg(0) or rx_st_bar_reg(2);
	bar4_hit			<= rx_st_bar_reg(4);
	--reg_data_addr(63 downto 32) <= (others => '0');

	--fmt64_type <= '1' when (rx_st_data(64+62 downto 64+56) = MEM_WR64_FMT_TYPE or rx_st_data(64+62 downto 64+56) = MEM_RD64_FMT_TYPE) else '0';
	--is_write_packet <=	'1'
--			when 
--				(packet_aligned = '1' and 
--				((rx_st_data(64+62 downto 64+56) = MEM_WR32_FMT_TYPE) or (rx_st_data(64+62 downto 64+56) = MEM_WR64_FMT_TYPE))--) 
--			else '0';
	-- For MAX4, Altera Avalon ST address aligns data within an rx_st_data word. Should a header indicate data for a non QWORD aligned address then the
	-- first 32-bits of data will be offset by 32 bits in the word
	--qw_aligned_addr <= '0' when ((fmt64_type and rx_st_data(2)) or (not(fmt64_type) and rx_st_data(34))) = '1' else '1';
	
	sl_en <= '1';	-- Always active. There are sl_wr_en and sl_rd_en signals.

	process(clk_pcie)
	begin
		 -- buffer rx interface
		 if rising_edge(clk_pcie) then
			rx_st_valid_reg <= rx_st_valid;
			rx_st_data_reg <= rx_st_data;
			rx_st_sop_reg <= rx_st_sop;
			rx_st_eop_reg <= rx_st_eop;
			rx_st_empty_reg <= rx_st_empty;
			rx_st_err_reg <= rx_st_err;
			rx_st_bar_reg <= rx_st_bar;
		 end if;
	 end process;
	 
	process(clk_pcie, pcie_sync_rst_n)
	begin
		if pcie_sync_rst_n = '0' then
			data_stream_go <= '0';
			data_writer_state <= IDLE_WRITER;
			completion_stream_state <= IDLE_STREAM;
			compl_req <= '0';
			dma_response_ready <= '0';
			dma_response_ready_next <= '0';
			sl_rd_en <= '0';
			sl_wr_en <= '0';
			sl_wr_last <= '0';
		elsif rising_edge(clk_pcie) then
			reg_data_wren <= (others => '0');
			compl_req <= '0';
			dma_response_valid <= "00";
			dma_response_complete <= '0';
			dma_response_ready <= '0';
			sl_wr_en <= '0';
			sl_rd_en <= '0';
			sl_wr_last <= '0';
	
			if rx_st_valid_reg = '1' or (SIM_RX = true and data_stream_go = '1') then
				data_stream_go <= '0';
				dma_response_ready_next<= '0';
				dma_response_ready <= dma_response_ready_next;
				bars_hit_r <= bars_hit;
				bar4_hit_r <= bar4_hit; 
				
				-- Save last octaword
				rx_st_data_r <= rx_st_data_reg;
				rx_st_eop_r <= rx_st_eop_reg;
				rx_st_empty_r <= rx_st_empty_reg;
				reg_bar0 <= rx_st_bar_reg(0);
				reg_bar2 <= rx_st_bar_reg(2);

				-- Header processor
				if rx_st_sop_reg = '1' and rx_st_valid_reg = '1' then
					-- Packet always aligned 
					-- All headers will appear in the first octawords (3 or 4 DW). 
					-- Headers cannot come back to back with an unaligned packet
			
					-- Read headers are on top quad word 
					compl_tc_int <= rx_st_data_reg(22 downto 20);
					compl_td_int <= rx_st_data_reg(15);
					compl_ep_int <= rx_st_data_reg(14);
					compl_attr_int <= rx_st_data_reg(13 downto 12);
					compl_size_int <= rx_st_data_reg(9 downto 0);
					compl_rid_int <= rx_st_data_reg(63 downto 48);
					compl_tag_int <= rx_st_data_reg(47 downto 40);
					compl_be_int <= rx_st_data_reg(39 downto 32);
					compl_bar2 <= rx_st_bar_reg(2);
					
					case rx_st_data_reg(30 downto 24) is -- packet type
					when MEM_RD32_FMT_TYPE =>
						compl_addr_int <= X"00000000" & rx_st_data_reg(95 downto 66) & "00";
						if  SIM_RX = true or (bars_hit = '1' and rx_st_data_reg(39 downto 32) = X"0F") then
							compl_req <= '1';	
						end if;
						if bar4_hit = '1' then
							sl_rd_en <= '1';
						end if;
					when MEM_RD64_FMT_TYPE =>
						compl_addr_int <= rx_st_data_reg(95 downto 64) & rx_st_data_reg(127 downto 98) & "00";
						if  SIM_RX = true or (bars_hit = '1' and rx_st_data_reg(39 downto 32) = X"0F") then
							compl_req <= '1';
						end if;
						if bar4_hit = '1' then
							sl_rd_en <= '1';
						end if;
					when COMPLETION_DATA_FMT_TYPE =>
						-- all completions are quad-word aligned... why is this true?			  
						dma_response_len <= rx_st_data_reg(9 downto 0); -- length in dwords
						dma_response_tag <= rx_st_data_reg(79 downto 72);
						dma_response_ready_next <= '1';
						data_stream_aligned <= '1';
						data_stream_go <= '1';
						qw_aligned_addr <= not rx_st_data_reg(66);
					when MEM_WR32_FMT_TYPE =>
						-- bar 0 or bar 2 write
						reg_data_addr <= X"00000000" & rx_st_data_reg(95 downto 67) & "000"; -- force QWord alignemnt
						if bars_hit = '1' then
							if rx_st_data_reg(66) = '1' then
								reg_data_out(63 downto 32) <= rx_st_data_reg(127 downto 96);
								reg_data_wren <= X"F0";
							else
								data_writer_state <= DATA_ALIGNED;
							end if;
						end if;
						reg_data_bar0 <= rx_st_bar_reg(0);
						reg_data_bar2 <= rx_st_bar_reg(2);
						
						-- bar 4 write
						data_writer_next_addr <= X"00000000" & rx_st_data_reg(95 downto 64);
						sl_wr_size <= rx_st_data_reg(9 downto 0);
						data_writer_rem <= rx_st_data_reg(0);
						data_writer_lastbe <= rx_st_data_reg(39 downto 36);
						data_writer_firstbe <= rx_st_data_reg(35 downto 32);
						if SIM_RX = true or bar4_hit = '1' then
							-- bar 4 access should be all QWord aligned
							data_writer_state <= SL_DATA_ALIGNED;
						end if;
					when MEM_WR64_FMT_TYPE =>
						-- bar 0 or bar 2 write
						reg_data_addr <= rx_st_data_reg(95 downto 64) & rx_st_data_reg(127 downto 99) & "000";  -- force QWord alignemnt
						if bars_hit = '1' then
							if rx_st_data_reg(98) = '1' then
								data_writer_state <= DATA_WR64_UNALIGNED;
							else
								data_writer_state <= DATA_ALIGNED;
							end if;
						end if;
						reg_data_bar0 <= rx_st_bar_reg(0);
						reg_data_bar2 <= rx_st_bar_reg(2);
						
						-- bar 4 write
						data_writer_next_addr <= rx_st_data_reg(95 downto 64) & rx_st_data_reg(127 downto 96);
						sl_wr_size <= rx_st_data_reg(9 downto 0);
						data_writer_rem <= rx_st_data_reg(0);
						data_writer_lastbe <= rx_st_data_reg(35 downto 32);
						data_writer_firstbe <= rx_st_data_reg(35 downto 32);
						if SIM_RX = true or bar4_hit = '1' then
							-- bar 4 access should be all QWord aligned
							data_writer_state <= SL_DATA_ALIGNED;
						end if;
					when others =>
					end case;
	
				--else
				--	-- Unaligned case:
				--	-- Header DW3 and DW4 are on the second octaword
				--	-- A back to back unaligned packet is possible i.e. DW3 | DW4 (eof) | DW1 (sof) | DW2
	
				--	rx_state <= RX_DW3DW4_UNALIGNED;
	
				--	case rx_st_data(62 downto 56) is
				--		when COMPLETION_DATA_FMT_TYPE =>
				--			-- all completions are quad-word aligned
				--			data_stream_aligned <= '0';
				--			data_stream_go <= '1';
				--		when others =>
				--	end case;
	
				end if;
--			when RX_DW3DW4_UNALIGNED =>
--			-- unaligned case (won't happen)
--			-- Read headers are on bottom quad word 
--			compl_tc_int <= rx_st_data_r(54 downto 52);
--						compl_td <= rx_st_data_r(47);
--						compl_ep <= rx_st_data_r(46);
--						compl_attr_int <= rx_st_data_r(45 downto 44);
--						compl_size <= rx_st_data_r(41 downto 32);
--						compl_rid_int <= rx_st_data_r(31 downto 16);
--						compl_tag_int <= rx_st_data_r(15 downto 8);
--						compl_be <= rx_st_data_r(7 downto 0);
--			compl_bar2 <= reg_bar2;
-- 
--			case rx_st_data_r(62 downto 56) is -- packet type
--				when MEM_RD32_FMT_TYPE =>
--				compl_addr_int <= X"00000000" & rx_st_data(64+63 downto 64+34) & "00";
--				if  SIM_RX = true or (bars_hit_r = '1' and rx_st_data_r(7 downto 0) = X"0F") then
--					compl_req <= '1';	
--				end if;
--				when MEM_RD64_FMT_TYPE =>
--				compl_addr_int <= X"00000000" & rx_st_data(64+31 downto 64+2) & "00";
--				if  SIM_RX = true or (bars_hit_r = '1' and rx_st_data_r(7 downto 0) = X"0F") then
--					compl_req <= '1';
--				end if;
--				when COMPLETION_DATA_FMT_TYPE =>
--				-- all completions are quad-word aligned			  
--				dma_response_len <= rx_st_data_r(41 downto 32); -- length in dwords
--				dma_response_ready <= '1'; 
--				dma_response_tag <= rx_st_data(64+47 downto 64+40);
--			
--				when others =>
--				rx_state <= RST_STATE;
--			end case;
--
--			if rx_st_sop = '1' and rx_st_valid = '1' then -- new back to back unaligned packet
--				rx_state <= RX_DW3DW4_UNALIGNED; -- Stay, can be either a WR32/64 or a completion
--				case rx_st_data(62 downto 56) is
--				when COMPLETION_DATA_FMT_TYPE =>
--					-- all completions are quad-word aligned
--					data_stream_aligned <= '0';
--					data_stream_go <= '1';
--				when others =>
--				end case;
--			else
--				rx_state <= RST_STATE;
--			end if;
	
				-- DMA Response Machine
				case completion_stream_state is 
				when IDLE_STREAM	=>
					if data_stream_go = '1' and (SIM_RX = true or rx_st_valid_reg = '1') then
						if qw_aligned_addr = '1' then
							dma_response_data <= rx_st_data_reg; --rx_st_data(63 downto 32) & rx_st_data(95 downto 64) & rx_st_data(127 downto 96) & rx_st_data_r(31 downto 0);
						else
							dma_response_data <= rx_st_data_reg(95 downto 0) & rx_st_data_r(127 downto 96);
						end if;
						dma_response_valid <= "11";
						if rx_st_eop_reg = '1' then
							if rx_st_empty_reg(0) = '1' then
								dma_response_valid <= "01";
							end if;
							dma_response_complete <= '1';
							completion_stream_state <= IDLE_STREAM;
						else
							completion_stream_state <= REM_STREAM;
						end if;
					end if; 
				when REM_STREAM	=>
					if rx_st_valid_reg = '1' then 
				  		if qw_aligned_addr = '1' then
							dma_response_data <= rx_st_data_reg; --rx_st_data(63 downto 32) & rx_st_data(95 downto 64) & rx_st_data(127 downto 96) & rx_st_data_r(31 downto 0);
						else
							dma_response_data <= rx_st_data_reg(95 downto 0) & rx_st_data_r(127 downto 96);
						end if;
						dma_response_valid <= "11";
						if rx_st_eop_reg = '1' and rx_st_valid_reg = '1' then
							if rx_st_empty_reg(0) = '1' then
								dma_response_valid <= "01";
							end if;
							dma_response_complete <= '1';
							completion_stream_state <= IDLE_STREAM;
						end if;
				end if;
				when others		=>
					completion_stream_state <= IDLE_STREAM;
				end case;
		
				case data_writer_state is
				when IDLE_WRITER	=>
				when DATA_ALIGNED =>
					-- bar 0 or bar 2 write, only 1 DW
					reg_data_out(31 downto 0) <= rx_st_data_reg(31 downto 0);
					reg_data_wren <= X"0F";
					data_writer_state <= IDLE_WRITER;
				when DATA_WR64_UNALIGNED =>
					-- bar 0 or bar 2 write, only 1 DW
					reg_data_out(63 downto 32) <= rx_st_data_reg(63 downto 32);
					reg_data_wren <= X"F0";
					data_writer_state <= IDLE_WRITER;
				when SL_DATA_ALIGNED =>
					-- bar 4 write
					sl_wr_en <= '1';
					sl_wr_addr <= data_writer_next_addr;
					sl_wr_data <= rx_st_data_reg;
					
					if (rx_st_eop_reg = '1') then
						-- last packet
						sl_wr_last <= '1';
						if rx_st_empty_reg = REM_64_0 then
							if data_writer_rem = '1' then
								sl_wr_be <= X"000" & data_writer_lastbe;
							else 
								sl_wr_be <= X"00" & data_writer_lastbe & data_writer_firstbe;
							end if;
						else
							if data_writer_rem = '1' then
								sl_wr_be <= X"0" & data_writer_lastbe & X"F" & data_writer_firstbe;
							else 
								sl_wr_be <= data_writer_lastbe & X"FF" & data_writer_firstbe;
							end if;
						end if;
						data_writer_state <= IDLE_WRITER;
					else
						sl_wr_be <= data_writer_firstbe & X"FFF";
						data_writer_state <= SL_DATA_ALIGNED;
					end if;
					data_writer_firstbe <= X"F";
					data_writer_next_addr <= unsigned(data_writer_next_addr) + 16;
					
				when others =>
					data_writer_state <= IDLE_WRITER;
				end case; 
			end if; -- rx_st_valid_reg
		end if; -- rising_edge(clk)
	end process;
	
end rtl;
