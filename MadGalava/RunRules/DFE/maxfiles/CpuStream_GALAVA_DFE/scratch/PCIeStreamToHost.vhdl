library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity PCIeStreamToHost is
	port (
		streamrst_pcie: in std_logic;
		clk_pcie: in std_logic;
		rst_pcie_n: in std_logic;
		scatter_list_entry_data: in std_logic_vector(60 downto 0);
		scatter_list_entry_size: in std_logic_vector(8 downto 0);
		scatter_list_entry_last: in std_logic;
		scatter_list_entry_eos: in std_logic;
		scatter_list_abort_dma: in std_logic;
		scatter_list_empty: in std_logic;
		in_stream_valid: in std_logic;
		in_stream_done: in std_logic;
		in_stream_data: in std_logic_vector(127 downto 0);
		request_select: in std_logic;
		request_data_read: in std_logic;
		scatter_list_dma_complete: out std_logic;
		scatter_list_entry_complete: out std_logic;
		scatter_list_entry_read: out std_logic;
		in_stream_stall: out std_logic;
		request_ready: out std_logic;
		request_last: out std_logic;
		request_len: out std_logic_vector(8 downto 0);
		request_addr: out std_logic_vector(60 downto 0);
		request_data: out std_logic_vector(127 downto 0);
		request_data_valid: out std_logic
	);
end PCIeStreamToHost;

architecture MaxDC of PCIeStreamToHost is
	-- Utility functions
	
	function vec_to_bit(v: in std_logic_vector) return std_logic is
	begin
		assert v'length = 1
		report "vec_to_bit: vector must be single bit!"
		severity FAILURE;
		return v(v'left);
	end;
	function bit_to_vec(b: in std_logic) return std_logic_vector is
		variable v: std_logic_vector(0 downto 0);
	begin
		v(0) := b;
		return v;
	end;
	function bool_to_vec(b: in boolean) return std_logic_vector is
		variable v: std_logic_vector(0 downto 0);
	begin
		if b = true then
			v(0) := '1';
		else
			v(0) := '0';
		end if;
		return v;
	end;
	function sanitise_ascendingvec(i : std_logic_vector) return std_logic_vector is
		variable v: std_logic_vector((i'length - 1) downto 0);
	begin
		for j in 0 to (i'length - 1) loop
			v(j) := i(i'high - j);
		end loop;
		return v;
	end;
	function slice(i : std_logic_vector; base : integer; size : integer) return std_logic_vector is
		variable v: std_logic_vector(size - 1 downto 0);
		variable z: std_logic_vector(i'length - 1 downto 0);
	begin
		assert i'length >= (base + size)
		report "vslice: slice out of range."
		severity FAILURE;
		if i'ascending = true then
			z := sanitise_ascendingvec(i);
		else
			z := i;
		end if;
		v(size - 1 downto 0) := z((size + base - 1) downto base);
		return v;
	end;
	function slv_to_slv(v : std_logic_vector) return std_logic_vector is
	begin
		return v;
	end;
	function slv_to_signed(ARG: STD_LOGIC_VECTOR; SIZE: INTEGER) return SIGNED is
		variable result: SIGNED (SIZE-1 downto 0);
	begin
		for i in 0 to SIZE-1 loop
			result(i) := ARG(i);
		end loop;
		return result;
	end;
	
	-- Component declarations
	
	attribute box_type : string;
	component pcie_stream_to_host is
		generic (
			G_KEEP_HIERARCHY : string;
			G_BUFFER_ADDRESS_WIDTH : integer;
			G_MAX_PAYLOAD_SIZE : integer;
			G_STREAM_WIDTH : integer;
			PL_COUNT_LSB : integer;
			PL_SIZE_NATIVE : integer;
			PAGE_SIZE_PL : integer;
			PAGE_SIZE_NATIVE : integer;
			NATIVE_TO_QUAD_PAD_BIT : integer
		);
		port (
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			streamrst_pcie: in std_logic;
			scatter_list_entry_data: in std_logic_vector(60 downto 0);
			scatter_list_entry_size: in std_logic_vector(8 downto 0);
			scatter_list_entry_last: in std_logic;
			scatter_list_entry_eos: in std_logic;
			scatter_list_abort_dma: in std_logic;
			scatter_list_empty: in std_logic;
			in_stream_empty: in std_logic;
			in_stream_done: in std_logic;
			in_stream_data: in std_logic_vector(127 downto 0);
			in_stream_entries_available: in std_logic_vector(9 downto 0);
			request_select: in std_logic;
			request_data_read: in std_logic;
			scatter_list_dma_complete: out std_logic;
			scatter_list_entry_complete: out std_logic;
			scatter_list_entry_read: out std_logic;
			in_stream_read: out std_logic;
			request_ready: out std_logic;
			request_last: out std_logic;
			request_len: out std_logic_vector(8 downto 0);
			request_addr: out std_logic_vector(60 downto 0);
			request_data: out std_logic_vector(127 downto 0);
			request_data_valid: out std_logic
		);
	end component;
	component AlteraFifoEntity_128_512_128_afv448_aev2_usedw_fwft is
		port (
			clk: in std_logic;
			din: in std_logic_vector(127 downto 0);
			wr_en: in std_logic;
			rd_en: in std_logic;
			srst: in std_logic;
			dout: out std_logic_vector(127 downto 0);
			full: out std_logic;
			empty: out std_logic;
			data_count: out std_logic_vector(9 downto 0);
			almost_empty: out std_logic;
			prog_full: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal stream_imp_scatter_list_dma_complete : std_logic_vector(0 downto 0);
	signal stream_imp_scatter_list_entry_complete : std_logic_vector(0 downto 0);
	signal stream_imp_scatter_list_entry_read : std_logic_vector(0 downto 0);
	signal stream_imp_in_stream_read : std_logic_vector(0 downto 0);
	signal stream_imp_request_ready : std_logic_vector(0 downto 0);
	signal stream_imp_request_last : std_logic_vector(0 downto 0);
	signal stream_imp_request_len : std_logic_vector(8 downto 0);
	signal stream_imp_request_addr : std_logic_vector(60 downto 0);
	signal stream_imp_request_data : std_logic_vector(127 downto 0);
	signal stream_imp_request_data_valid : std_logic_vector(0 downto 0);
	signal inputbuffer_dout : std_logic_vector(127 downto 0);
	signal inputbuffer_full : std_logic_vector(0 downto 0);
	signal inputbuffer_empty : std_logic_vector(0 downto 0);
	signal inputbuffer_data_count : std_logic_vector(9 downto 0);
	signal inputbuffer_almost_empty : std_logic_vector(0 downto 0);
	signal inputbuffer_prog_full : std_logic_vector(0 downto 0);
	signal streamrst_pcie_sig : std_logic_vector(0 downto 0);
	signal real_data_count : std_logic_vector(9 downto 0) := "0000000000";
	signal muxsrc_ln90_pciestreamtohost1 : std_logic_vector(9 downto 0);
	signal cat_ln90_pciestreamtohost : std_logic_vector(9 downto 0);
	signal muxsel_ln89_pciestreamtohost1 : std_logic_vector(1 downto 0);
	signal cat_ln89_pciestreamtohost : std_logic_vector(1 downto 0);
	signal muxout_ln89_pciestreamtohost : std_logic_vector(9 downto 0);
	signal in_stream_data_r : std_logic_vector(127 downto 0) := "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
	signal valid_not_rst : std_logic_vector(0 downto 0) := "0";
	signal rst_or_full : std_logic_vector(0 downto 0) := "1";
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	streamrst_pcie_sig <= bit_to_vec(streamrst_pcie);
	cat_ln90_pciestreamtohost<=(inputbuffer_full & slice(inputbuffer_data_count, 0, 9));
	muxsrc_ln90_pciestreamtohost1 <= cat_ln90_pciestreamtohost;
	cat_ln89_pciestreamtohost<=(inputbuffer_almost_empty & inputbuffer_empty);
	muxsel_ln89_pciestreamtohost1 <= cat_ln89_pciestreamtohost;
	muxproc_ln89_pciestreamtohost : process(muxsrc_ln90_pciestreamtohost1, muxsel_ln89_pciestreamtohost1)
	begin
		case muxsel_ln89_pciestreamtohost1 is
			when "00" => muxout_ln89_pciestreamtohost <= muxsrc_ln90_pciestreamtohost1;
			when "10" => muxout_ln89_pciestreamtohost <= "0000000001";
			when "11" => muxout_ln89_pciestreamtohost <= "0000000000";
			when others => muxout_ln89_pciestreamtohost <= "0000000000";
		end case;
	end process;
	scatter_list_dma_complete <= vec_to_bit(stream_imp_scatter_list_dma_complete);
	scatter_list_entry_complete <= vec_to_bit(stream_imp_scatter_list_entry_complete);
	scatter_list_entry_read <= vec_to_bit(stream_imp_scatter_list_entry_read);
	in_stream_stall <= vec_to_bit(rst_or_full);
	request_ready <= vec_to_bit(stream_imp_request_ready);
	request_last <= vec_to_bit(stream_imp_request_last);
	request_len <= stream_imp_request_len;
	request_addr <= stream_imp_request_addr;
	request_data <= stream_imp_request_data;
	request_data_valid <= vec_to_bit(stream_imp_request_data_valid);
	
	-- Register processes
	
	reg_process : process(clk_pcie)
	begin
		if rising_edge(clk_pcie) then
			if slv_to_slv(streamrst_pcie_sig) = "1" then
				real_data_count <= "0000000000";
			else
				real_data_count <= muxout_ln89_pciestreamtohost;
			end if;
			in_stream_data_r <= in_stream_data;
			if slv_to_slv(streamrst_pcie_sig) = "1" then
				valid_not_rst <= "0";
			else
				valid_not_rst <= bit_to_vec(in_stream_valid);
			end if;
			if slv_to_slv(streamrst_pcie_sig) = "1" then
				rst_or_full <= "1";
			else
				rst_or_full <= inputbuffer_prog_full;
			end if;
		end if;
	end process;
	
	-- Entity instances
	
	stream_imp : pcie_stream_to_host
		generic map (
			G_KEEP_HIERARCHY => "false",
			G_BUFFER_ADDRESS_WIDTH => 9,
			G_MAX_PAYLOAD_SIZE => 128,
			G_STREAM_WIDTH => 128,
			PL_COUNT_LSB => 3,
			PL_SIZE_NATIVE => 8,
			PAGE_SIZE_PL => 32,
			PAGE_SIZE_NATIVE => 256,
			NATIVE_TO_QUAD_PAD_BIT => 1
		)
		port map (
			scatter_list_dma_complete => stream_imp_scatter_list_dma_complete(0), -- 1 bits (out)
			scatter_list_entry_complete => stream_imp_scatter_list_entry_complete(0), -- 1 bits (out)
			scatter_list_entry_read => stream_imp_scatter_list_entry_read(0), -- 1 bits (out)
			in_stream_read => stream_imp_in_stream_read(0), -- 1 bits (out)
			request_ready => stream_imp_request_ready(0), -- 1 bits (out)
			request_last => stream_imp_request_last(0), -- 1 bits (out)
			request_len => stream_imp_request_len, -- 9 bits (out)
			request_addr => stream_imp_request_addr, -- 61 bits (out)
			request_data => stream_imp_request_data, -- 128 bits (out)
			request_data_valid => stream_imp_request_data_valid(0), -- 1 bits (out)
			clk_pcie => clk_pcie, -- 1 bits (in)
			rst_pcie_n => rst_pcie_n, -- 1 bits (in)
			streamrst_pcie => vec_to_bit(streamrst_pcie_sig), -- 1 bits (in)
			scatter_list_entry_data => scatter_list_entry_data, -- 61 bits (in)
			scatter_list_entry_size => scatter_list_entry_size, -- 9 bits (in)
			scatter_list_entry_last => scatter_list_entry_last, -- 1 bits (in)
			scatter_list_entry_eos => scatter_list_entry_eos, -- 1 bits (in)
			scatter_list_abort_dma => scatter_list_abort_dma, -- 1 bits (in)
			scatter_list_empty => scatter_list_empty, -- 1 bits (in)
			in_stream_empty => vec_to_bit(inputbuffer_empty), -- 1 bits (in)
			in_stream_done => vec_to_bit("0"), -- 1 bits (in)
			in_stream_data => inputbuffer_dout, -- 128 bits (in)
			in_stream_entries_available => real_data_count, -- 10 bits (in)
			request_select => request_select, -- 1 bits (in)
			request_data_read => request_data_read -- 1 bits (in)
		);
	inputBuffer : AlteraFifoEntity_128_512_128_afv448_aev2_usedw_fwft
		port map (
			dout => inputbuffer_dout, -- 128 bits (out)
			full => inputbuffer_full(0), -- 1 bits (out)
			empty => inputbuffer_empty(0), -- 1 bits (out)
			data_count => inputbuffer_data_count, -- 10 bits (out)
			almost_empty => inputbuffer_almost_empty(0), -- 1 bits (out)
			prog_full => inputbuffer_prog_full(0), -- 1 bits (out)
			clk => clk_pcie, -- 1 bits (in)
			din => in_stream_data_r, -- 128 bits (in)
			wr_en => vec_to_bit(valid_not_rst), -- 1 bits (in)
			rd_en => vec_to_bit(stream_imp_in_stream_read), -- 1 bits (in)
			srst => vec_to_bit(streamrst_pcie_sig) -- 1 bits (in)
		);
end MaxDC;
