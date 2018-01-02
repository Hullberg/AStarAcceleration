library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity PCIeStreamFromHostuid4 is
	port (
		clk_pcie: in std_logic;
		rst_pcie_n: in std_logic;
		streamrst_pcie: in std_logic;
		gather_list_entry_data: in std_logic_vector(60 downto 0);
		gather_list_entry_size: in std_logic_vector(8 downto 0);
		gather_list_entry_last: in std_logic;
		gather_list_entry_eos: in std_logic;
		gather_list_abort_dma: in std_logic;
		gather_list_empty: in std_logic;
		out_stream_stall: in std_logic;
		response_valid: in std_logic_vector(1 downto 0);
		response_data: in std_logic_vector(127 downto 0);
		response_select: in std_logic;
		response_metadata: in std_logic_vector(27 downto 0);
		response_metadata_valid: in std_logic;
		request_select: in std_logic;
		gather_list_dma_complete: out std_logic;
		gather_list_entry_complete: out std_logic;
		gather_list_entry_read: out std_logic;
		out_stream_valid: out std_logic;
		out_stream_done: out std_logic;
		out_stream_data: out std_logic_vector(127 downto 0);
		response_metadata_free: out std_logic;
		request_ready: out std_logic;
		request_len: out std_logic_vector(6 downto 0);
		request_addr: out std_logic_vector(60 downto 0);
		request_metadata: out std_logic_vector(27 downto 0)
	);
end PCIeStreamFromHostuid4;

architecture MaxDC of PCIeStreamFromHostuid4 is
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
	component pcie_stream_from_host is
		generic (
			PCIE_BUS_WIDTH : integer;
			METADATA_WIDTH : integer;
			BUFFER_ADDRESS_WIDTH : integer;
			PAGE_SIZE_BUS : integer;
			QUAD_TO_BUS_SLICE_PAD : integer;
			MAX_REQUEST_SIZE_BUS : integer;
			MAX_REQUEST_SIZE_BUS_REPRESENT_WIDTH : integer;
			REQUEST_SIZE_NUM_MSBS : integer;
			REQUEST_SIZE_REM_LSBS : integer;
			RESPONSE_COUNTERS : integer;
			RESPONSE_COUNTERS_WIDTH : integer;
			MEMORY_ADDRESS_WIDTH_BUS : integer;
			NUM_VALID_BITS : integer
		);
		port (
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			streamrst_pcie: in std_logic;
			gather_list_entry_data: in std_logic_vector(60 downto 0);
			gather_list_entry_size: in std_logic_vector(8 downto 0);
			gather_list_entry_last: in std_logic;
			gather_list_entry_eos: in std_logic;
			gather_list_abort_dma: in std_logic;
			gather_list_empty: in std_logic;
			out_stream_stall: in std_logic;
			response_valid: in std_logic_vector(1 downto 0);
			response_data: in std_logic_vector(127 downto 0);
			response_select: in std_logic;
			response_metadata: in std_logic_vector(27 downto 0);
			response_metadata_valid: in std_logic;
			request_select: in std_logic;
			buf_read_data: in std_logic_vector(127 downto 0);
			gather_list_dma_complete: out std_logic;
			gather_list_entry_complete: out std_logic;
			gather_list_entry_read: out std_logic;
			out_stream_valid: out std_logic;
			out_stream_done: out std_logic;
			out_stream_data: out std_logic_vector(127 downto 0);
			response_metadata_free: out std_logic;
			request_ready: out std_logic;
			request_len: out std_logic_vector(3 downto 0);
			request_addr: out std_logic_vector(59 downto 0);
			request_metadata: out std_logic_vector(27 downto 0);
			buf_read_addr: out std_logic_vector(7 downto 0);
			buf_write_addr: out std_logic_vector(8 downto 0);
			buf_write_data: out std_logic_vector(127 downto 0);
			buf_write_en: out std_logic_vector(1 downto 0);
			stream_time: out std_logic_vector(31 downto 0)
		);
	end component;
	component AlteraBlockMem_RAM_TWO_PORT_64x256_RAM_TWO_PORT_ireg is
		port (
			wea: in std_logic_vector(0 downto 0);
			addra: in std_logic_vector(7 downto 0);
			dina: in std_logic_vector(63 downto 0);
			clka: in std_logic;
			addrb: in std_logic_vector(7 downto 0);
			doutb: out std_logic_vector(63 downto 0)
		);
	end component;
	
	-- Signal declarations
	
	signal stream_imp_gather_list_dma_complete : std_logic_vector(0 downto 0);
	signal stream_imp_gather_list_entry_complete : std_logic_vector(0 downto 0);
	signal stream_imp_gather_list_entry_read : std_logic_vector(0 downto 0);
	signal stream_imp_out_stream_valid : std_logic_vector(0 downto 0);
	signal stream_imp_out_stream_done : std_logic_vector(0 downto 0);
	signal stream_imp_out_stream_data : std_logic_vector(127 downto 0);
	signal stream_imp_response_metadata_free : std_logic_vector(0 downto 0);
	signal stream_imp_request_ready : std_logic_vector(0 downto 0);
	signal stream_imp_request_len : std_logic_vector(3 downto 0);
	signal stream_imp_request_addr : std_logic_vector(59 downto 0);
	signal stream_imp_request_metadata : std_logic_vector(27 downto 0);
	signal stream_imp_buf_read_addr : std_logic_vector(7 downto 0);
	signal stream_imp_buf_write_addr : std_logic_vector(8 downto 0);
	signal stream_imp_buf_write_data : std_logic_vector(127 downto 0);
	signal stream_imp_buf_write_en : std_logic_vector(1 downto 0);
	signal stream_imp_stream_time : std_logic_vector(31 downto 0);
	signal rd_buffer_0_doutb : std_logic_vector(63 downto 0);
	signal rd_buffer_1_doutb : std_logic_vector(63 downto 0);
	signal stream_imp_buf_read_data1 : std_logic_vector(127 downto 0);
	signal cat_ln111_pciestreamfromhost : std_logic_vector(127 downto 0);
	signal reg_ln169_pciestreamfromhost : std_logic_vector(0 downto 0) := "0";
	signal muxsrc_ln159_pciestreamfromhost1 : std_logic_vector(0 downto 0);
	signal muxsrc_ln159_pciestreamfromhost2_1 : std_logic_vector(0 downto 0);
	signal muxsel_we_rd_data_buffer_0_1 : std_logic_vector(0 downto 0);
	signal muxout_we_rd_data_buffer_0 : std_logic_vector(0 downto 0);
	signal reg_ln144_pciestreamfromhost : std_logic_vector(7 downto 0) := "00000000";
	signal muxsrc_ln114_pciestreamfromhost1 : std_logic_vector(7 downto 0);
	signal muxsrc_ln118_pciestreamfromhost1 : std_logic_vector(7 downto 0);
	signal muxsel_dest_addr1 : std_logic_vector(0 downto 0);
	signal muxout_dest_addr : std_logic_vector(7 downto 0);
	signal reg_ln168_pciestreamfromhost : std_logic_vector(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
	signal muxsrc_ln158_pciestreamfromhost1 : std_logic_vector(63 downto 0);
	signal muxsrc_ln158_pciestreamfromhost2_1 : std_logic_vector(63 downto 0);
	signal muxsel_data_source_rd_buffer_0_1 : std_logic_vector(0 downto 0);
	signal muxout_data_source_rd_buffer_0 : std_logic_vector(63 downto 0);
	signal reg_ln169_pciestreamfromhost1 : std_logic_vector(0 downto 0) := "0";
	signal muxsrc_ln159_pciestreamfromhost3_1 : std_logic_vector(0 downto 0);
	signal muxsrc_ln159_pciestreamfromhost4_1 : std_logic_vector(0 downto 0);
	signal muxsel_we_rd_data_buffer_1_1 : std_logic_vector(0 downto 0);
	signal muxout_we_rd_data_buffer_1 : std_logic_vector(0 downto 0);
	signal reg_ln146_pciestreamfromhost : std_logic_vector(7 downto 0) := "00000000";
	signal reg_ln168_pciestreamfromhost1 : std_logic_vector(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
	signal muxsrc_ln158_pciestreamfromhost3_1 : std_logic_vector(63 downto 0);
	signal muxsrc_ln158_pciestreamfromhost4_1 : std_logic_vector(63 downto 0);
	signal muxsel_data_source_rd_buffer_1_1 : std_logic_vector(0 downto 0);
	signal muxout_data_source_rd_buffer_1 : std_logic_vector(63 downto 0);
	signal cat_ln80_pciestreamfromhost : std_logic_vector(6 downto 0);
	signal cat_ln97_pciestreamfromhost : std_logic_vector(60 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	cat_ln111_pciestreamfromhost<=(rd_buffer_1_doutb & rd_buffer_0_doutb);
	stream_imp_buf_read_data1 <= cat_ln111_pciestreamfromhost;
	muxsrc_ln159_pciestreamfromhost1 <= slice(stream_imp_buf_write_en, 0, 1);
	muxsrc_ln159_pciestreamfromhost2_1 <= slice(stream_imp_buf_write_en, 1, 1);
	muxsel_we_rd_data_buffer_0_1 <= slice(stream_imp_buf_write_addr, 0, 1);
	muxproc_we_rd_data_buffer_0 : process(muxsrc_ln159_pciestreamfromhost1, muxsrc_ln159_pciestreamfromhost2_1, muxsel_we_rd_data_buffer_0_1)
	begin
		case muxsel_we_rd_data_buffer_0_1 is
			when "0" => muxout_we_rd_data_buffer_0 <= muxsrc_ln159_pciestreamfromhost1;
			when "1" => muxout_we_rd_data_buffer_0 <= muxsrc_ln159_pciestreamfromhost2_1;
			when others => 
			muxout_we_rd_data_buffer_0 <= (others => 'X');
		end case;
	end process;
	muxsrc_ln114_pciestreamfromhost1 <= slice(stream_imp_buf_write_addr, 1, 8);
	muxsrc_ln118_pciestreamfromhost1 <= (unsigned(slice(stream_imp_buf_write_addr, 1, 8)) + unsigned(slv_to_slv("00000001")));
	muxsel_dest_addr1 <= bool_to_vec((slice(stream_imp_buf_write_addr, 0, 1)) /= ("0"));
	muxproc_dest_addr : process(muxsrc_ln114_pciestreamfromhost1, muxsrc_ln118_pciestreamfromhost1, muxsel_dest_addr1)
	begin
		case muxsel_dest_addr1 is
			when "0" => muxout_dest_addr <= muxsrc_ln114_pciestreamfromhost1;
			when "1" => muxout_dest_addr <= muxsrc_ln118_pciestreamfromhost1;
			when others => 
			muxout_dest_addr <= (others => 'X');
		end case;
	end process;
	muxsrc_ln158_pciestreamfromhost1 <= slice(stream_imp_buf_write_data, 0, 64);
	muxsrc_ln158_pciestreamfromhost2_1 <= slice(stream_imp_buf_write_data, 64, 64);
	muxsel_data_source_rd_buffer_0_1 <= slice(stream_imp_buf_write_addr, 0, 1);
	muxproc_data_source_rd_buffer_0 : process(muxsrc_ln158_pciestreamfromhost1, muxsrc_ln158_pciestreamfromhost2_1, muxsel_data_source_rd_buffer_0_1)
	begin
		case muxsel_data_source_rd_buffer_0_1 is
			when "0" => muxout_data_source_rd_buffer_0 <= muxsrc_ln158_pciestreamfromhost1;
			when "1" => muxout_data_source_rd_buffer_0 <= muxsrc_ln158_pciestreamfromhost2_1;
			when others => 
			muxout_data_source_rd_buffer_0 <= (others => 'X');
		end case;
	end process;
	muxsrc_ln159_pciestreamfromhost3_1 <= slice(stream_imp_buf_write_en, 1, 1);
	muxsrc_ln159_pciestreamfromhost4_1 <= slice(stream_imp_buf_write_en, 0, 1);
	muxsel_we_rd_data_buffer_1_1 <= slice(stream_imp_buf_write_addr, 0, 1);
	muxproc_we_rd_data_buffer_1 : process(muxsrc_ln159_pciestreamfromhost3_1, muxsrc_ln159_pciestreamfromhost4_1, muxsel_we_rd_data_buffer_1_1)
	begin
		case muxsel_we_rd_data_buffer_1_1 is
			when "0" => muxout_we_rd_data_buffer_1 <= muxsrc_ln159_pciestreamfromhost3_1;
			when "1" => muxout_we_rd_data_buffer_1 <= muxsrc_ln159_pciestreamfromhost4_1;
			when others => 
			muxout_we_rd_data_buffer_1 <= (others => 'X');
		end case;
	end process;
	muxsrc_ln158_pciestreamfromhost3_1 <= slice(stream_imp_buf_write_data, 64, 64);
	muxsrc_ln158_pciestreamfromhost4_1 <= slice(stream_imp_buf_write_data, 0, 64);
	muxsel_data_source_rd_buffer_1_1 <= slice(stream_imp_buf_write_addr, 0, 1);
	muxproc_data_source_rd_buffer_1 : process(muxsrc_ln158_pciestreamfromhost3_1, muxsrc_ln158_pciestreamfromhost4_1, muxsel_data_source_rd_buffer_1_1)
	begin
		case muxsel_data_source_rd_buffer_1_1 is
			when "0" => muxout_data_source_rd_buffer_1 <= muxsrc_ln158_pciestreamfromhost3_1;
			when "1" => muxout_data_source_rd_buffer_1 <= muxsrc_ln158_pciestreamfromhost4_1;
			when others => 
			muxout_data_source_rd_buffer_1 <= (others => 'X');
		end case;
	end process;
	cat_ln80_pciestreamfromhost<=("00" & stream_imp_request_len & "0");
	cat_ln97_pciestreamfromhost<=(stream_imp_request_addr & "0");
	gather_list_dma_complete <= vec_to_bit(stream_imp_gather_list_dma_complete);
	gather_list_entry_complete <= vec_to_bit(stream_imp_gather_list_entry_complete);
	gather_list_entry_read <= vec_to_bit(stream_imp_gather_list_entry_read);
	out_stream_valid <= vec_to_bit(stream_imp_out_stream_valid);
	out_stream_done <= vec_to_bit(stream_imp_out_stream_done);
	out_stream_data <= stream_imp_out_stream_data;
	response_metadata_free <= vec_to_bit(stream_imp_response_metadata_free);
	request_ready <= vec_to_bit(stream_imp_request_ready);
	request_len <= cat_ln80_pciestreamfromhost;
	request_addr <= cat_ln97_pciestreamfromhost;
	request_metadata <= stream_imp_request_metadata;
	
	-- Register processes
	
	reg_process : process(clk_pcie)
	begin
		if rising_edge(clk_pcie) then
			if slv_to_slv(bit_to_vec(streamrst_pcie)) = "1" then
				reg_ln169_pciestreamfromhost <= "0";
			else
				reg_ln169_pciestreamfromhost <= muxout_we_rd_data_buffer_0;
			end if;
			reg_ln144_pciestreamfromhost <= muxout_dest_addr;
			reg_ln168_pciestreamfromhost <= muxout_data_source_rd_buffer_0;
			if slv_to_slv(bit_to_vec(streamrst_pcie)) = "1" then
				reg_ln169_pciestreamfromhost1 <= "0";
			else
				reg_ln169_pciestreamfromhost1 <= muxout_we_rd_data_buffer_1;
			end if;
			reg_ln146_pciestreamfromhost <= slice(stream_imp_buf_write_addr, 1, 8);
			reg_ln168_pciestreamfromhost1 <= muxout_data_source_rd_buffer_1;
		end if;
	end process;
	
	-- Entity instances
	
	stream_imp : pcie_stream_from_host
		generic map (
			PCIE_BUS_WIDTH => 128,
			METADATA_WIDTH => 28,
			BUFFER_ADDRESS_WIDTH => 8,
			PAGE_SIZE_BUS => 256,
			QUAD_TO_BUS_SLICE_PAD => 1,
			MAX_REQUEST_SIZE_BUS => 8,
			MAX_REQUEST_SIZE_BUS_REPRESENT_WIDTH => 4,
			REQUEST_SIZE_NUM_MSBS => 5,
			REQUEST_SIZE_REM_LSBS => 3,
			RESPONSE_COUNTERS => 32,
			RESPONSE_COUNTERS_WIDTH => 5,
			MEMORY_ADDRESS_WIDTH_BUS => 60,
			NUM_VALID_BITS => 2
		)
		port map (
			gather_list_dma_complete => stream_imp_gather_list_dma_complete(0), -- 1 bits (out)
			gather_list_entry_complete => stream_imp_gather_list_entry_complete(0), -- 1 bits (out)
			gather_list_entry_read => stream_imp_gather_list_entry_read(0), -- 1 bits (out)
			out_stream_valid => stream_imp_out_stream_valid(0), -- 1 bits (out)
			out_stream_done => stream_imp_out_stream_done(0), -- 1 bits (out)
			out_stream_data => stream_imp_out_stream_data, -- 128 bits (out)
			response_metadata_free => stream_imp_response_metadata_free(0), -- 1 bits (out)
			request_ready => stream_imp_request_ready(0), -- 1 bits (out)
			request_len => stream_imp_request_len, -- 4 bits (out)
			request_addr => stream_imp_request_addr, -- 60 bits (out)
			request_metadata => stream_imp_request_metadata, -- 28 bits (out)
			buf_read_addr => stream_imp_buf_read_addr, -- 8 bits (out)
			buf_write_addr => stream_imp_buf_write_addr, -- 9 bits (out)
			buf_write_data => stream_imp_buf_write_data, -- 128 bits (out)
			buf_write_en => stream_imp_buf_write_en, -- 2 bits (out)
			stream_time => stream_imp_stream_time, -- 32 bits (out)
			clk_pcie => clk_pcie, -- 1 bits (in)
			rst_pcie_n => rst_pcie_n, -- 1 bits (in)
			streamrst_pcie => streamrst_pcie, -- 1 bits (in)
			gather_list_entry_data => gather_list_entry_data, -- 61 bits (in)
			gather_list_entry_size => gather_list_entry_size, -- 9 bits (in)
			gather_list_entry_last => gather_list_entry_last, -- 1 bits (in)
			gather_list_entry_eos => gather_list_entry_eos, -- 1 bits (in)
			gather_list_abort_dma => gather_list_abort_dma, -- 1 bits (in)
			gather_list_empty => gather_list_empty, -- 1 bits (in)
			out_stream_stall => out_stream_stall, -- 1 bits (in)
			response_valid => response_valid, -- 2 bits (in)
			response_data => response_data, -- 128 bits (in)
			response_select => response_select, -- 1 bits (in)
			response_metadata => response_metadata, -- 28 bits (in)
			response_metadata_valid => response_metadata_valid, -- 1 bits (in)
			request_select => request_select, -- 1 bits (in)
			buf_read_data => stream_imp_buf_read_data1 -- 128 bits (in)
		);
	rd_buffer_0 : AlteraBlockMem_RAM_TWO_PORT_64x256_RAM_TWO_PORT_ireg
		port map (
			doutb => rd_buffer_0_doutb, -- 64 bits (out)
			wea => reg_ln169_pciestreamfromhost, -- 1 bits (in)
			addra => reg_ln144_pciestreamfromhost, -- 8 bits (in)
			dina => reg_ln168_pciestreamfromhost, -- 64 bits (in)
			clka => clk_pcie, -- 1 bits (in)
			addrb => stream_imp_buf_read_addr -- 8 bits (in)
		);
	rd_buffer_1 : AlteraBlockMem_RAM_TWO_PORT_64x256_RAM_TWO_PORT_ireg
		port map (
			doutb => rd_buffer_1_doutb, -- 64 bits (out)
			wea => reg_ln169_pciestreamfromhost1, -- 1 bits (in)
			addra => reg_ln146_pciestreamfromhost, -- 8 bits (in)
			dina => reg_ln168_pciestreamfromhost1, -- 64 bits (in)
			clka => clk_pcie, -- 1 bits (in)
			addrb => stream_imp_buf_read_addr -- 8 bits (in)
		);
end MaxDC;
