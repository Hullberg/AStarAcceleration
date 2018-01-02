------------------------------------------------------------------
-- TLP TX for Altera PCIe
-- Copyright 2007 Maxeler Technologies Inc. All Rights Reserved
-- Original Author : rob
-- Modified by: itay, November 2008 
-- Major Modifications: Itay - October 2010 - Gen2 Support, 128-bit Interface
-- Major Modifications: Wei - October 2011 - Altera
------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity max_SV_pcie_tx is
	port (
		-- interface to core
		clk_pcie : in std_logic;
		rst_pcie_n : in std_logic;
		tx_st_sop	: out std_logic := '0'; -- start of frame
		tx_st_eop	: out std_logic := '0'; -- end of frame
		tx_st_data	: out std_logic_vector(127 downto 0); -- tx data
		tx_st_empty	: out std_logic_vector(1 downto 0); -- tx remainder ("X0" = 127:0, "X1" = 63:0)
		tx_st_valid : out std_logic := '0'; -- valid data on tx_st_data
		tx_st_ready : in std_logic; -- ready for packet
		tx_st_err : out std_logic := '0'; -- nullify packet
		cfg_completer_id : in std_logic_vector(15 downto 0);
		-- interface for posted writes from DMA OUT
		dma_write_req : in std_logic;
		dma_write_ack : out std_logic;
		dma_write_done : out std_logic;
		dma_write_busy : out std_logic;
		dma_write_addr : in std_logic_vector(63 downto 0);
		dma_write_tag : in std_logic_vector(7 downto 0);
		dma_write_len : in std_logic_vector(8 downto 0); -- in quad words
		dma_write_wide_addr : in std_logic;
		-- to FIFO buffer (for posted write data)
		dma_write_rddata : in std_logic_vector(127 downto 0);
		dma_write_rden   : out std_logic;
		-- interface for non-posted reads from DMA IN
		dma_read_req : in std_logic;
		dma_read_addr : in std_logic_vector(63 downto 0);
		dma_read_len : in std_logic_vector(9 downto 0); -- in dwords
		dma_read_be  : in std_logic_vector(3 downto 0); -- last be
		dma_read_tag : in std_logic_vector(7 downto 0);
		dma_read_ack : out std_logic;
		dma_read_wide_addr : in std_logic;
		-- interface to register read for completions
		compl_req : in std_logic;
		compl_tc : in std_logic_vector(2 downto 0);
		compl_td : in std_logic;
		compl_ep : in std_logic;
		compl_attr : in std_logic_vector(1 downto 0);
		compl_rid : in std_logic_vector(15 downto 0);
		compl_tag : in std_logic_vector(7 downto 0);
		compl_addr : in std_logic_vector(12 downto 0);
		compl_ack : out std_logic;
		compl_size : in std_logic_vector(9 downto 0); -- size in dwords
		-- completion data
		compl_data : in  std_logic_vector(63 downto 0);
		compl_rden : out std_logic;
	
		-- interface for BAR(4) memory read completions
		sl_rd_compl_req : in std_logic;
		sl_rd_compl_tc : in std_logic_vector(2 downto 0);
		sl_rd_compl_td : in std_logic;
		sl_rd_compl_ep : in std_logic;
		sl_rd_compl_attr : in std_logic_vector(1 downto 0);
		sl_rd_compl_rid : in std_logic_vector(15 downto 0);
		sl_rd_compl_tag : in std_logic_vector(7 downto 0);
		sl_rd_compl_addr : in std_logic_vector(6 downto 0);	 -- 7 lower bits of the address (byte addressing) 
		sl_rd_compl_ack : out std_logic;
		sl_rd_compl_size : in std_logic_vector(11 downto 0); -- Size in bytes for this completion (aka max is max_pcie_payload)
		sl_rd_compl_rem_size : in std_logic_vector(11 downto 0); -- Size in bytes remaining for the set of completions corresponding to one read request.
		-- completion data
		sl_rd_compl_data : in  std_logic_vector(127 downto 0); -- data: First byte transfered is always data(31 downto 0).
		sl_rd_compl_rden : out std_logic;
		sl_rd_compl_done : out std_logic
	);
end max_SV_pcie_tx;

architecture rtl of max_SV_pcie_tx is
	
	constant FMT_3DW_NO_DATA   : std_logic_vector(2 downto 0) := "000";
	constant FMT_4DW_NO_DATA   : std_logic_vector(2 downto 0) := "001";
	constant FMT_3DW_WITH_DATA : std_logic_vector(2 downto 0) := "010";
	constant FMT_4DW_WITH_DATA : std_logic_vector(2 downto 0) := "011";
	
	constant TYPE_MRd		 : std_logic_vector(4 downto 0) := "00000";
	constant TYPE_MWr		 : std_logic_vector(4 downto 0) := "00000";
	constant TYPE_Cpl		 : std_logic_vector(4 downto 0) := "01010";
	constant TYPE_CplD		 : std_logic_vector(4 downto 0) := "01010";
	
	constant MEM_WR64_FMT_TYPE : std_logic_vector(7 downto 0) := FMT_4DW_WITH_DATA & TYPE_MWr;
	constant MEM_WR32_FMT_TYPE : std_logic_vector(7 downto 0) := FMT_3DW_WITH_DATA & TYPE_MWr;
	
	constant MEM_RD64_FMT_TYPE : std_logic_vector(7 downto 0) := FMT_4DW_NO_DATA & TYPE_MRd;
	constant MEM_RD32_FMT_TYPE : std_logic_vector(7 downto 0) := FMT_3DW_NO_DATA & TYPE_MRd;
	
	constant COMPLETION_DATA_FMT_TYPE : std_logic_vector(7 downto 0) := FMT_3DW_WITH_DATA & TYPE_CplD;
	constant COMPLETION_NODATA_FMT_TYPE : std_logic_vector(7 downto 0) := FMT_3DW_NO_DATA & TYPE_Cpl;
	
	-- Traffic Class
	constant TC_BEST_EFFORT : std_logic_vector(2 downto 0) := "000";
	-- EP
	constant EP_NOT_POISONED : std_logic := '0';
	-- TD : TLP Digest
	constant TD_NO_TLP_DIGEST : std_logic := '0';
	-- TH : TLP Processing Hints
	constant TH_NOT_PRESENT : std_logic := '0';
	-- ATTR: Attributes 
	constant ATTR_2_RELAXED_ORDERING : std_logic := '0';
	constant ATTR_1_RELAXED_ORDERING : std_logic := '1';
	constant ATTR_0_NO_SNOOP	   : std_logic := '0';
	-- AT: Address Type
	constant AT_UNTRANSLATED	   : std_logic_vector(1 downto 0) := "00";
	

	-- config space
	constant COMPLETER_ID_ADDR : std_logic_vector(3 downto 0) := "1111";

	-- Data Remainder
	constant REM_127_0  : std_logic_vector(1 downto 0) := "00";
	--constant REM_127_32 : std_logic_vector(1 downto 0) := "01";
	constant REM_64_0 : std_logic_vector(1 downto 0) := "01";
	--constant REM_127_96 : std_logic_vector(1 downto 0) := "11";
	
	type tx_state_t is (RST_STATE,
			COMPL_DATA_STATE,
			MEM_QW_STATE,
			MEM_QW_DATA_STATE,
			DONE_STATE,
			MEM_RD_COMPL_PIPE,
			MEM_RD_COMPL_HEADER_STATE,
			MEM_RD_COMPL_DATA_STATE);
	
	signal tx_state : tx_state_t := RST_STATE;

	component pcie_tx_fifo
		port (
				sclr			: IN STD_LOGIC ;
				clock		   : IN STD_LOGIC ;
				data			: IN STD_LOGIC_VECTOR (131 DOWNTO 0);
				rdreq		   : IN STD_LOGIC ;
				wrreq		   : IN STD_LOGIC ;
				almost_full	 : OUT STD_LOGIC ;
				full			: OUT STD_LOGIC ;
				empty		   : OUT STD_LOGIC ;
				q			   : OUT STD_LOGIC_VECTOR (131 DOWNTO 0)
		);
	end component;

	signal do_compl, do_sl_rd_compl, do_write, do_read : std_logic;
	signal do_arb : std_logic_vector(3 downto 0) := "0000";
	
	signal read_addr : std_logic_vector(9 downto 0) := (others => '0');
	
	signal dma_write_len_octawords : std_logic_vector(7 downto 0) := (others => '0');
	signal dma_write_last_octaword_index : std_logic_vector(7 downto 0) := (others => '0');
	signal dma_read_addr_r : std_logic_vector(63 downto 0) := (others => '0');
	signal dma_write_wide_addr_r : std_logic := '0';
	signal dma_write_tag_r : std_logic_vector(7 downto 0) := (others => '0');
	signal dma_write_addr_r : std_logic_vector(63 downto 0) := (others => '0');
	
	signal dma_write_rddata_saved : std_logic_vector(95 downto 0) := (others => '0');
	signal dma_write_count_octawords : std_logic_vector(7 downto 0) := (others => '0');
	signal dma_write_count_reset : std_logic := '0';
	
	
	attribute keep_hierarchy : string;
	attribute keep_hierarchy of rtl : architecture is "soft";
	signal buf_available : std_logic_vector(2 downto 0);
	
	
	signal dma_write_rden_i : std_logic := '0';
	
	signal sl_rd_compl_data_r : std_logic_vector(127 downto 0);
    signal sl_rd_compl_owords_rem : unsigned(7 downto 0) := (others => '0');	-- Number of octawords read from the requester
    signal sl_rd_dw_rem : std_logic_vector(1 downto 0) := (others => '0');		-- Will contains the value to use for trn_trem_n at the end of the transfer.
	signal sl_rd_compl_pipe_flush : std_logic;
	signal sl_rd_compl_pipe_flush_delay : std_logic;

--	constant DATA_PIPE_DEPTH : integer := 2;
--	type data_pipe_t is array (natural range <>) of std_logic_vector(127 downto 0);
--	signal data_pipe : data_pipe_t(DATA_PIPE_DEPTH-1 downto 0);
	signal data_to_dma : std_logic_vector(127 downto 0);

	
--	constant READ_PIPE_DEPTH : integer := 1; -- + DATA_PIPE_DEPTH;
--	signal read_pipe_valid	  : std_logic_vector(READ_PIPE_DEPTH-1 downto 0) := (others => '0');
--	signal read_data_ready_in_1 : std_logic := '0';
--	signal read_data_ready_in_2 : std_logic := '0';

	signal qword_aligned : std_logic := '1';

	signal read_data_count		: std_logic_vector(7 downto 0) := "00000001";
	signal can_read			: std_logic := '1';
	signal stop_reads_count		: std_logic_vector(7 downto 0) := (others => '0');
	
	signal tx_st_sop_i : std_logic := '0';
	signal tx_st_eop_i : std_logic := '0';
	signal tx_st_empty_i : std_logic_vector(1 downto 0) := "00";
	signal tx_st_data_i : std_logic_vector(127 downto 0) := (others => '0');
	signal tx_data_set	: std_logic_vector(131 downto 0) := (others => '0');
	signal tx_commit		: std_logic := '0';
	signal fifo_empty_i : std_logic := '1';
	signal item_tx  : std_logic := '0';
	signal tx_cannot_accept : std_logic := '1';

	signal tx_st_ready_r : std_logic;
	signal tx_st_valid_r : std_logic;
	signal fifo_q : std_logic_vector(131 downto 0);
	signal fifo_q_r : std_logic_vector(131 downto 0);
	
	signal rst_pcie : std_logic;
	
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
	
	compl_rden <= '0'; -- not used
	tx_st_err <= '0';
	dma_write_busy <= '0';
	rst_pcie <= not(pcie_sync_rst_n);

	item_tx <= '1' when fifo_empty_i = '0' and tx_st_ready_r = '1' else '0';

	tx_data_set <= tx_st_eop_i & tx_st_sop_i & tx_st_empty_i & tx_st_data_i;

	pcie_tx_fifo_i: pcie_tx_fifo
	port map (
	clock		=> clk_pcie,
	sclr		=> rst_pcie,
	data		=> tx_data_set, 
	wrreq		=> tx_commit,
	rdreq		=> item_tx,
	q			=> fifo_q,
	full		=> open,
	empty		=> fifo_empty_i,
	almost_full => tx_cannot_accept);

	process(clk_pcie)
	begin
		if rising_edge(clk_pcie) then
			tx_st_ready_r <= tx_st_ready;
			tx_st_valid_r <= item_tx;
		--fifo_q_r <= fifo_q;
		end if;
	end process;
	fifo_q_r <= fifo_q;

	tx_st_data <= fifo_q_r(127 downto 0);
	tx_st_empty <= fifo_q_r(129 downto 128);
	tx_st_sop <= fifo_q_r(130);
	tx_st_eop <= fifo_q_r(131);
	tx_st_valid <= tx_st_valid_r; 
	
	-- thought we could register this but it looks like that's a dumb thing to do 
	--  trn_tbuf_av_r <= trn_tbuf_av;
	
	-- priority arbiter, do completion, then read then write
	-- this should go in carry chain
	process(dma_read_req, dma_write_req, compl_req, sl_rd_compl_req)
	variable pri1, pri2, pri3 : std_logic;
	begin
		pri1 := compl_req;
		do_compl <= pri1;
		pri2 := sl_rd_compl_req and (not pri1);
		do_sl_rd_compl <= pri2;
		pri3 := dma_read_req and (not (pri2 or pri1));
		do_read <= pri3;
		do_write <= dma_write_req and (not (pri1 or (pri2 or pri3))); 
	end process;
	
	do_arb <= (do_sl_rd_compl & do_compl & do_write & do_read);
	
	stop_reads_count <= dma_write_len(dma_write_len'left downto 1);
	
	process (clk_pcie) 
	begin
		if rising_edge(clk_pcie) then
			if dma_write_req = '1' then
				dma_write_wide_addr_r <= dma_write_wide_addr;
				dma_write_tag_r <= dma_write_tag;
				dma_write_addr_r <= dma_write_addr;
				dma_write_len_octawords <= dma_write_len(dma_write_len'left downto 1);
				dma_write_last_octaword_index <= unsigned(dma_write_len(dma_write_len'left downto 1)) - 1;
			end if;
		end if;
	end process;


	qword_aligned <= '1' when dma_write_addr(2) = '0' else '0';
	can_read <= '1' when read_data_count /= stop_reads_count else '0';
	dma_write_rden <= dma_write_rden_i;

	data_to_dma <= dma_write_rddata;

--	pipe_deep_n: if READ_PIPE_DEPTH > 2 generate 
--	begin
--	read_data_ready_in_1 <= read_pipe_valid(read_pipe_valid'left-1);  
--	read_data_ready_in_2 <= read_pipe_valid(read_pipe_valid'left-2);
--	process (clk_pcie)
--	begin  
--		if rising_edge(clk_pcie) then
--		read_pipe_valid <= read_pipe_valid(read_pipe_valid'left-1 downto 0) & dma_write_rden_i;
--		end if;
--	end process;
--	end generate pipe_deep_n;
--
--	pipe_deep_2: if READ_PIPE_DEPTH = 2 generate 
--	begin
--	read_data_ready_in_1 <= read_pipe_valid(read_pipe_valid'left-1);  
--	read_data_ready_in_2 <= dma_write_rden_i; 
--	process (clk_pcie)
--	begin  
--		if rising_edge(clk_pcie) then
--		read_pipe_valid <= read_pipe_valid(read_pipe_valid'left-1 downto 0) & dma_write_rden_i;
--		end if;
--	end process;
--	end generate pipe_deep_2;
--	
--	pipe_short: if READ_PIPE_DEPTH = 1 generate 
--	begin
--	read_data_ready_in_1 <= dma_write_rden_i;
--	read_data_ready_in_2 <= '1';
--	process (clk_pcie)
--	begin  
--		if rising_edge(clk_pcie) then
--		read_pipe_valid(0) <= dma_write_rden_i;
--		end if;
--	end process;
--	end generate pipe_short;

	process(clk_pcie, pcie_sync_rst_n)
	begin
		if pcie_sync_rst_n = '0' then -- fundamental reset
			tx_state <= RST_STATE;
			tx_commit <= '0';
			tx_st_data_i <= (others => '0');
			
			sl_rd_compl_pipe_flush <= '0';
			sl_rd_compl_pipe_flush_delay <= '0';
		elsif rising_edge(clk_pcie) then
			tx_commit <= '0';
			tx_st_eop_i <= '0';
			tx_st_sop_i <= '0';
			tx_st_empty_i <= REM_127_0;
			
			dma_write_ack <= '0';
			dma_write_done <= '0';
			dma_read_ack <= '0';
			compl_ack <= '0';
			dma_write_count_reset <= '0';
			
			dma_write_rden_i <= '0';
			
			sl_rd_compl_ack <= '0';
			sl_rd_compl_done <= '0';
			sl_rd_compl_rden <= '0';
			sl_rd_compl_pipe_flush <= sl_rd_compl_pipe_flush_delay;				-- Account for that read latency at the end of the transfer
			sl_rd_compl_pipe_flush_delay <= '0';

			case tx_state is
			when RST_STATE =>
				if tx_cannot_accept = '0' then
					case do_arb is
					when "0100" => -- completion
						tx_commit <= '1';
						tx_st_sop_i <= '1';
						tx_st_data_i(31 downto 0) <=
							COMPLETION_DATA_FMT_TYPE &	-- QW0
							'0' &							  
							compl_tc &			-- traffic class
							"0000" &
							compl_td &
							compl_ep &
							compl_attr &
							"00" &
							compl_size;			-- size in dwords
						tx_st_data_i(63 downto 32) <=
							cfg_completer_id &
							"0000" &
							compl_size & "00";		-- size in bytes
						tx_st_data_i(95 downto 64) <=
							compl_rid &			-- QW 1
							compl_tag &
							'0'		&
							compl_addr(4 downto 0) & "00"; -- lower addr
						if compl_addr(0) = '1' then	-- not QW aligned
							tx_st_data_i(127 downto 96) <=
							compl_data(31 downto 0);	-- Data; always 1 dword
							tx_st_eop_i <= '1';
							compl_ack <= '1';
							tx_state <= DONE_STATE;
						else				-- QW aligned
							tx_st_data_i(127 downto 96) <= X"00000000";	-- reserved; data sent in next cycle
							tx_state <= COMPL_DATA_STATE;
						end if;
					when "1000" => -- slave memory read completion
						sl_rd_compl_ack <= '1'; -- ack request: tell requester to deassert sl_rd_compl_req and wait for sl_rd_compl_done
						if (sl_rd_compl_size(3) = '1') then
							sl_rd_dw_rem <= REM_64_0;	-- last cycle will provide 2dw (QWord aligned)
						else
							sl_rd_dw_rem <= REM_127_0;
						end if;
						if (sl_rd_compl_size(3 downto 0) = "0000") then
							sl_rd_compl_owords_rem <= unsigned(sl_rd_compl_size(11 downto 4)) - 1; -- byte size multiple of 16
						else
							sl_rd_compl_owords_rem <= unsigned(sl_rd_compl_size(11 downto 4));	-- byte size not multiple of 16
						end if;
						sl_rd_compl_rden <= '1'; -- Request data
						sl_rd_compl_pipe_flush_delay <= '1';
						tx_state <= MEM_RD_COMPL_PIPE;					
					when "0010" => -- write posted
						dma_write_ack <= '1'; -- ack request: tell requester to deassert dma_write_req and wait for dma_write_done
						dma_write_count_octawords <= (others => '0'); 
					
						read_data_count <= conv_std_logic_vector(1, read_data_count'length);
						dma_write_rden_i <= '1';
						tx_state <= MEM_QW_STATE;   -- data is always QWord aligned
					when "0001" => -- read non-posted
						dma_read_ack <= '1';
						tx_commit <= '1';
						tx_st_sop_i <= '1';
						tx_st_eop_i <= '1';
						
						if dma_read_wide_addr = '1' then
							tx_st_data_i(31 downto 24) <= MEM_RD64_FMT_TYPE; 
						else
							tx_st_data_i(31 downto 24) <= MEM_RD32_FMT_TYPE;
						end if;
						
						tx_st_data_i(23 downto 0) <= 
							'0' & -- Reserved
							TC_BEST_EFFORT & -- TC
							'0' & -- Reserved
							ATTR_2_RELAXED_ORDERING & 
							'0' & -- Reserved
							TH_NOT_PRESENT & 
							TD_NO_TLP_DIGEST & -- td (0 = no TLP digest)
							EP_NOT_POISONED & -- ep
							ATTR_1_RELAXED_ORDERING & 
							ATTR_0_NO_SNOOP & 
							AT_UNTRANSLATED & -- Address type Default/Untranslated
							dma_read_len;
							tx_st_data_i(63 downto 32) <=
							cfg_completer_id & 
							dma_read_tag & 
							dma_read_be & X"f"; -- last and first be
						
						if dma_read_wide_addr = '1' then
							tx_st_data_i(95 downto 64) <= dma_read_addr(63 downto 32);
							tx_st_data_i(127 downto 96) <= dma_read_addr(31 downto 2) & "00"; -- Reserved
						else
							tx_st_data_i(95 downto 64) <= dma_read_addr(31 downto 2) & "00";  -- Reserved
							tx_st_data_i(127 downto 96) <= X"00000000"; -- Padding
							--tx_st_empty_i <= REM_127_32;
						end if;
						tx_state <= DONE_STATE;
					when others =>
					end case;
			   	end if; -- if cannot accept
			when COMPL_DATA_STATE =>
				tx_commit <= '1';
				tx_st_data_i <= X"000000000000000000000000" & compl_data(31 downto 0);		   -- Completions are always 1 dword
				tx_st_empty_i <= REM_64_0;
				tx_st_eop_i <= '1';
				compl_ack <= '1';
				tx_state <= DONE_STATE;
			when MEM_QW_STATE =>
				if can_read = '1' then
					read_data_count <= unsigned(read_data_count) + 1;
					dma_write_rden_i <= '1';
				end if;
				tx_st_sop_i <= '1';
				
				-- QW 0
				if dma_write_wide_addr_r = '1' then
					tx_st_data_i(31 downto 24) <= MEM_WR64_FMT_TYPE; 
				else
					tx_st_data_i(31 downto 24) <= MEM_WR32_FMT_TYPE;
				end if;
				tx_st_data_i(23 downto 0) <= 
					'0' & -- Reserved
					TC_BEST_EFFORT & -- TC
					'0' & -- Reserved
					ATTR_2_RELAXED_ORDERING & 
					'0' & -- Reserved
					TH_NOT_PRESENT & 
					TD_NO_TLP_DIGEST & -- td (0 = no TLP digest)
					EP_NOT_POISONED & -- ep
					ATTR_1_RELAXED_ORDERING & 
					ATTR_0_NO_SNOOP & 
					AT_UNTRANSLATED & -- Address type Default/Untranslated
					dma_write_len_octawords & "00"; -- length in dwords (octawords*4)
				tx_st_data_i(63 downto 32) <= 
					cfg_completer_id & 
					dma_write_tag_r & 
					X"f" & X"f"; -- last and first byte enable
				-- QW 1
				if dma_write_wide_addr_r = '1' then
					tx_st_data_i(95 downto 64) <= dma_write_addr_r(63 downto 32); -- Memory target write address
					tx_st_data_i(127 downto 96) <= dma_write_addr_r(31 downto 2) & "00";
				else
					tx_st_data_i(95 downto 64) <= 
						dma_write_addr_r(31 downto 2) & "00"; -- Memory target write address
					tx_st_data_i(127 downto 96) <= X"00000000";
				end if;
				
				tx_commit <= '1';
				tx_state <= MEM_QW_DATA_STATE;
			when MEM_QW_DATA_STATE =>
				dma_write_count_octawords <= unsigned(dma_write_count_octawords) + 1; 
				if can_read = '1' then
					read_data_count <= unsigned(read_data_count) + 1;
					dma_write_rden_i <= '1';
				end if;
	
				tx_commit <= '1';
				tx_st_data_i <= data_to_dma;
				
				if dma_write_count_octawords = dma_write_last_octaword_index then -- if we just sent the last data item...
					tx_st_eop_i <= '1';
					dma_write_done <= '1';
					dma_write_count_reset <= '1';
					tx_state <= DONE_STATE;
				else
					tx_state <= MEM_QW_DATA_STATE;
				end if;
			when MEM_RD_COMPL_PIPE =>
				-- Account for that read latency at the end of the transfer
			    if sl_rd_compl_owords_rem /= 0 then
				    sl_rd_compl_owords_rem <= sl_rd_compl_owords_rem-1;
				    sl_rd_compl_rden <= '1';
				    sl_rd_compl_pipe_flush_delay <= '1';
			    end if;
		    	tx_state <= MEM_RD_COMPL_HEADER_STATE;
			when MEM_RD_COMPL_HEADER_STATE =>
				tx_commit <= '1';
				tx_st_sop_i <= '1';
				tx_st_data_i(31 downto 0) <=
					COMPLETION_DATA_FMT_TYPE &	-- QW0
					'0' &							  
					sl_rd_compl_tc &			-- traffic class
					"0000" &
					sl_rd_compl_td &
					sl_rd_compl_ep &
					sl_rd_compl_attr &
					"00" &
					sl_rd_compl_size(11 downto 2);			-- size in dwords
				tx_st_data_i(63 downto 32) <=
					cfg_completer_id &
					"0000" &
					sl_rd_compl_rem_size;		-- size in bytes
				tx_st_data_i(95 downto 64) <=
					sl_rd_compl_rid &			-- QW 1
					sl_rd_compl_tag &
					'0'		&
					sl_rd_compl_addr; -- lower addr
				-- QW aligned
				tx_st_data_i(127 downto 96) <= X"00000000";	-- reserved; data sent in next cycle
				if sl_rd_compl_owords_rem /= 0 then
				    sl_rd_compl_owords_rem <= sl_rd_compl_owords_rem-1;
				    sl_rd_compl_rden <= '1';
				    sl_rd_compl_pipe_flush_delay <= '1';
			    end if;
				tx_state <= MEM_RD_COMPL_DATA_STATE;
			when MEM_RD_COMPL_DATA_STATE =>
			    tx_commit <= '1';
			    tx_st_data_i <= sl_rd_compl_data;
			    if sl_rd_compl_owords_rem /= 0 then
					sl_rd_compl_owords_rem <= sl_rd_compl_owords_rem-1;
					sl_rd_compl_rden <= '1';
					sl_rd_compl_pipe_flush_delay <= '1';
					tx_state <= MEM_RD_COMPL_DATA_STATE;	-- stay in this state
			    else
			    	if sl_rd_compl_pipe_flush = '0' then
			    		-- last data to send
			    		sl_rd_compl_done <= '1';
			    		tx_st_eop_i <= '1';
			    		tx_st_empty_i <= sl_rd_dw_rem;
						tx_state <= DONE_STATE;-- process the remaining data beats that are in the pipe
					else
						tx_state <= MEM_RD_COMPL_DATA_STATE;
					end if;
			    end if;
			when DONE_STATE => --- Ack needs 1 cycle of latency to make all the REQs deassert.
				tx_state <= RST_STATE;
			when others =>
				tx_state <= RST_STATE;
			end case;
		end if;
	end process;
end rtl;

