library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity SGListFetchEngine is
	port (
		clk_pcie: in std_logic;
		rst_pcie_n: in std_logic;
		streamrst_pcie: in std_logic;
		response_valid: in std_logic_vector(1 downto 0);
		response_data: in std_logic_vector(127 downto 0);
		response_select: in std_logic;
		response_metadata: in std_logic_vector(27 downto 0);
		response_metadata_valid: in std_logic;
		request_select: in std_logic;
		dma_abort_sfh: in std_logic_vector(31 downto 0);
		dma_abort_sth: in std_logic_vector(31 downto 0);
		dma_ctl_address: in std_logic_vector(8 downto 0);
		dma_ctl_data: in std_logic_vector(63 downto 0);
		dma_ctl_write: in std_logic;
		dma_ctl_byte_en: in std_logic_vector(7 downto 0);
		bar_parse_wr_addr_onehot: in std_logic_vector(255 downto 0);
		bar_parse_wr_data: in std_logic_vector(63 downto 0);
		bar_parse_wr_clk: in std_logic;
		bar_parse_wr_page_sel_onehot: in std_logic_vector(1 downto 0);
		sfh0_port_dma_complete: in std_logic;
		sfh0_port_entry_complete: in std_logic;
		sfh0_port_entry_read: in std_logic;
		sfh1_port_dma_complete: in std_logic;
		sfh1_port_entry_complete: in std_logic;
		sfh1_port_entry_read: in std_logic;
		sfh2_port_dma_complete: in std_logic;
		sfh2_port_entry_complete: in std_logic;
		sfh2_port_entry_read: in std_logic;
		sfh3_port_dma_complete: in std_logic;
		sfh3_port_entry_complete: in std_logic;
		sfh3_port_entry_read: in std_logic;
		sfh4_port_dma_complete: in std_logic;
		sfh4_port_entry_complete: in std_logic;
		sfh4_port_entry_read: in std_logic;
		sg_ring_write_sfh4_select: in std_logic;
		sg_ring_write_sfh4_data_read: in std_logic;
		sth0_port_dma_complete: in std_logic;
		sth0_port_entry_complete: in std_logic;
		sth0_port_entry_read: in std_logic;
		sth1_port_dma_complete: in std_logic;
		sth1_port_entry_complete: in std_logic;
		sth1_port_entry_read: in std_logic;
		response_metadata_free: out std_logic;
		request_ready: out std_logic;
		request_len: out std_logic_vector(6 downto 0);
		request_addr: out std_logic_vector(60 downto 0);
		request_metadata: out std_logic_vector(27 downto 0);
		dma_complete_sfh: out std_logic_vector(31 downto 0);
		dma_complete_sth: out std_logic_vector(31 downto 0);
		dma_ctl_read_data: out std_logic_vector(63 downto 0);
		sfh0_port_entry_data: out std_logic_vector(60 downto 0);
		sfh0_port_entry_size: out std_logic_vector(8 downto 0);
		sfh0_port_entry_last: out std_logic;
		sfh0_port_entry_eos: out std_logic;
		sfh0_port_abort_dma: out std_logic;
		sfh0_port_empty: out std_logic;
		sfh_ring_reset0: out std_logic;
		sfh1_port_entry_data: out std_logic_vector(60 downto 0);
		sfh1_port_entry_size: out std_logic_vector(8 downto 0);
		sfh1_port_entry_last: out std_logic;
		sfh1_port_entry_eos: out std_logic;
		sfh1_port_abort_dma: out std_logic;
		sfh1_port_empty: out std_logic;
		sfh_ring_reset1: out std_logic;
		sfh2_port_entry_data: out std_logic_vector(60 downto 0);
		sfh2_port_entry_size: out std_logic_vector(8 downto 0);
		sfh2_port_entry_last: out std_logic;
		sfh2_port_entry_eos: out std_logic;
		sfh2_port_abort_dma: out std_logic;
		sfh2_port_empty: out std_logic;
		sfh_ring_reset2: out std_logic;
		sfh3_port_entry_data: out std_logic_vector(60 downto 0);
		sfh3_port_entry_size: out std_logic_vector(8 downto 0);
		sfh3_port_entry_last: out std_logic;
		sfh3_port_entry_eos: out std_logic;
		sfh3_port_abort_dma: out std_logic;
		sfh3_port_empty: out std_logic;
		sfh_ring_reset3: out std_logic;
		sfh4_port_entry_data: out std_logic_vector(60 downto 0);
		sfh4_port_entry_size: out std_logic_vector(8 downto 0);
		sfh4_port_entry_last: out std_logic;
		sfh4_port_entry_eos: out std_logic;
		sfh4_port_abort_dma: out std_logic;
		sfh4_port_empty: out std_logic;
		sfh_ring_reset4: out std_logic;
		sg_ring_write_sfh4_ready: out std_logic;
		sg_ring_write_sfh4_last: out std_logic;
		sg_ring_write_sfh4_len: out std_logic_vector(8 downto 0);
		sg_ring_write_sfh4_addr: out std_logic_vector(60 downto 0);
		sg_ring_write_sfh4_data: out std_logic_vector(127 downto 0);
		sg_ring_write_sfh4_data_valid: out std_logic;
		sth0_port_entry_data: out std_logic_vector(60 downto 0);
		sth0_port_entry_size: out std_logic_vector(8 downto 0);
		sth0_port_entry_last: out std_logic;
		sth0_port_entry_eos: out std_logic;
		sth0_port_abort_dma: out std_logic;
		sth0_port_empty: out std_logic;
		sth_ring_reset0: out std_logic;
		sth1_port_entry_data: out std_logic_vector(60 downto 0);
		sth1_port_entry_size: out std_logic_vector(8 downto 0);
		sth1_port_entry_last: out std_logic;
		sth1_port_entry_eos: out std_logic;
		sth1_port_abort_dma: out std_logic;
		sth1_port_empty: out std_logic;
		sth_ring_reset1: out std_logic
	);
end SGListFetchEngine;

architecture MaxDC of SGListFetchEngine is
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
	component sg_fetcher is
		generic (
			VALID_WIDTH : integer;
			PCIE_BUS_WIDTH : integer;
			METADATA_WIDTH : integer;
			NUM_STREAMS_TO_HOST : integer;
			NUM_STREAMS_FROM_HOST : integer;
			NUM_STREAMS_WIDTH : integer;
			ADB : integer
		);
		port (
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			streamrst_pcie: in std_logic;
			response_valid: in std_logic_vector(1 downto 0);
			response_data: in std_logic_vector(63 downto 0);
			response_select: in std_logic;
			response_metadata: in std_logic_vector(27 downto 0);
			response_metadata_valid: in std_logic;
			response_gen2_valid: in std_logic;
			response_gen2_metadata: in std_logic_vector(27 downto 0);
			request_select: in std_logic;
			dma_ctl_read_data: in std_logic_vector(63 downto 0);
			condensed_dma_abort: in std_logic_vector(6 downto 0);
			sg_fifo_can_fetch: in std_logic_vector(6 downto 0);
			response_metadata_free: out std_logic;
			request_ready: out std_logic;
			request_len: out std_logic_vector(6 downto 0);
			request_addr: out std_logic_vector(60 downto 0);
			request_metadata: out std_logic_vector(27 downto 0);
			dma_ctl_address: out std_logic_vector(8 downto 0);
			dma_ctl_write_data: out std_logic_vector(63 downto 0);
			dma_ctl_write_enable: out std_logic;
			sg_fifo_data: out std_logic_vector(71 downto 0);
			sg_fifo_select: out std_logic_vector(6 downto 0)
		);
	end component;
	component SGGen2InputBuffer is
		port (
			clk: in std_logic;
			rst: in std_logic;
			response_data: in std_logic_vector(127 downto 0);
			response_metadata: in std_logic_vector(27 downto 0);
			response_valid: in std_logic_vector(1 downto 0);
			response_select: in std_logic;
			response_metadata_valid: in std_logic;
			response_word: out std_logic_vector(63 downto 0);
			response_sel_vld: out std_logic;
			response_metadata_out: out std_logic_vector(27 downto 0)
		);
	end component;
	component AlteraBlockMem_RAM_DUAL_PORT_64x512_RAM_DUAL_PORT_bw_ireg_readfirst is
		port (
			clka: in std_logic;
			addra: in std_logic_vector(8 downto 0);
			dina: in std_logic_vector(63 downto 0);
			addrb: in std_logic_vector(8 downto 0);
			dinb: in std_logic_vector(63 downto 0);
			wea: in std_logic_vector(7 downto 0);
			web: in std_logic_vector(7 downto 0);
			douta: out std_logic_vector(63 downto 0);
			doutb: out std_logic_vector(63 downto 0)
		);
	end component;
	component PCIeRingBufferBarParser is
		port (
			bar_parse_wr_addr_onehot: in std_logic_vector(255 downto 0);
			bar_parse_wr_data: in std_logic_vector(63 downto 0);
			bar_parse_wr_clk: in std_logic;
			bar_parse_wr_page_sel_onehot: in std_logic_vector(1 downto 0);
			ring_sg_buffer_entry: out std_logic_vector(71 downto 0);
			ring_vfifo_userspace_ptr: out std_logic_vector(63 downto 0);
			ring_last_entry_index: out std_logic_vector(31 downto 0);
			ring_current_entry_index: out std_logic_vector(31 downto 0);
			ring_stream_select_sfh: out std_logic_vector(15 downto 0);
			ring_stream_select_sth: out std_logic_vector(15 downto 0);
			ring_config_valid: out std_logic;
			ring_reset: out std_logic_vector(31 downto 0);
			ring_reset_valid: out std_logic;
			ring_driving_ptr_sfh0: out std_logic_vector(31 downto 0);
			ring_driving_ptr_sfh0_valid: out std_logic;
			ring_driving_ptr_sfh1: out std_logic_vector(31 downto 0);
			ring_driving_ptr_sfh1_valid: out std_logic;
			ring_driving_ptr_sfh2: out std_logic_vector(31 downto 0);
			ring_driving_ptr_sfh2_valid: out std_logic;
			ring_driving_ptr_sfh3: out std_logic_vector(31 downto 0);
			ring_driving_ptr_sfh3_valid: out std_logic;
			ring_driving_ptr_sfh4: out std_logic_vector(31 downto 0);
			ring_driving_ptr_sfh4_valid: out std_logic;
			ring_driving_ptr_sth0: out std_logic_vector(31 downto 0);
			ring_driving_ptr_sth0_valid: out std_logic;
			ring_driving_ptr_sth1: out std_logic_vector(31 downto 0);
			ring_driving_ptr_sth1_valid: out std_logic;
			bar_valid_sfh4: out std_logic
		);
	end component;
	component SGFifo is
		port (
			din: in std_logic_vector(71 downto 0);
			wr_en: in std_logic;
			rd_en: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			dout: out std_logic_vector(71 downto 0);
			empty: out std_logic;
			can_fetch: out std_logic
		);
	end component;
	component sg_ring is
		generic (
			RING_ADDR_WIDTH : integer;
			SG_FIFO_WIDTH : integer;
			HOST_MEMORY_ADDR_WIDTH : integer;
			HOST_DATA_WIDTH : integer;
			NATIVE_TO_QUAD_PAD_BIT : integer;
			MODE_WRITE : boolean
		);
		port (
			clk: in std_logic;
			rst_sync: in std_logic;
			abort: in std_logic;
			bar_sg_data: in std_logic_vector(71 downto 0);
			bar_sg_index: in std_logic_vector(8 downto 0);
			bar_last_buffer_index: in std_logic_vector(8 downto 0);
			bar_user_pointer: in std_logic_vector(60 downto 0);
			bar_valid: in std_logic;
			bar_driving_ptr: in std_logic_vector(9 downto 0);
			bar_driving_ptr_valid: in std_logic;
			sgfifo_full: in std_logic;
			stream_buffer_done: in std_logic;
			request_select: in std_logic;
			request_data_read: in std_logic;
			sgfifo_din: out std_logic_vector(71 downto 0);
			sgfifo_wren: out std_logic;
			request_ready: out std_logic;
			request_last: out std_logic;
			request_len: out std_logic_vector(8 downto 0);
			request_addr: out std_logic_vector(60 downto 0);
			request_data: out std_logic_vector(127 downto 0);
			request_data_valid: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal sg_fetcher_external_response_metadata_free : std_logic_vector(0 downto 0);
	signal sg_fetcher_external_request_ready : std_logic_vector(0 downto 0);
	signal sg_fetcher_external_request_len : std_logic_vector(6 downto 0);
	signal sg_fetcher_external_request_addr : std_logic_vector(60 downto 0);
	signal sg_fetcher_external_request_metadata : std_logic_vector(27 downto 0);
	signal sg_fetcher_external_dma_ctl_address : std_logic_vector(8 downto 0);
	signal sg_fetcher_external_dma_ctl_write_data : std_logic_vector(63 downto 0);
	signal sg_fetcher_external_dma_ctl_write_enable : std_logic_vector(0 downto 0);
	signal sg_fetcher_external_sg_fifo_data : std_logic_vector(71 downto 0);
	signal sg_fetcher_external_sg_fifo_select : std_logic_vector(6 downto 0);
	signal sg_gen2_input_buffer_response_word : std_logic_vector(63 downto 0);
	signal sg_gen2_input_buffer_response_sel_vld : std_logic_vector(0 downto 0);
	signal sg_gen2_input_buffer_response_metadata_out : std_logic_vector(27 downto 0);
	signal dma_control_ram_douta : std_logic_vector(63 downto 0);
	signal dma_control_ram_doutb : std_logic_vector(63 downto 0);
	signal pcieringbufferbarparser_i_ring_sg_buffer_entry : std_logic_vector(71 downto 0);
	signal pcieringbufferbarparser_i_ring_vfifo_userspace_ptr : std_logic_vector(63 downto 0);
	signal pcieringbufferbarparser_i_ring_last_entry_index : std_logic_vector(31 downto 0);
	signal pcieringbufferbarparser_i_ring_current_entry_index : std_logic_vector(31 downto 0);
	signal pcieringbufferbarparser_i_ring_stream_select_sfh : std_logic_vector(15 downto 0);
	signal pcieringbufferbarparser_i_ring_stream_select_sth : std_logic_vector(15 downto 0);
	signal pcieringbufferbarparser_i_ring_config_valid : std_logic_vector(0 downto 0);
	signal pcieringbufferbarparser_i_ring_reset : std_logic_vector(31 downto 0);
	signal pcieringbufferbarparser_i_ring_reset_valid : std_logic_vector(0 downto 0);
	signal pcieringbufferbarparser_i_ring_driving_ptr_sfh0 : std_logic_vector(31 downto 0);
	signal pcieringbufferbarparser_i_ring_driving_ptr_sfh0_valid : std_logic_vector(0 downto 0);
	signal pcieringbufferbarparser_i_ring_driving_ptr_sfh1 : std_logic_vector(31 downto 0);
	signal pcieringbufferbarparser_i_ring_driving_ptr_sfh1_valid : std_logic_vector(0 downto 0);
	signal pcieringbufferbarparser_i_ring_driving_ptr_sfh2 : std_logic_vector(31 downto 0);
	signal pcieringbufferbarparser_i_ring_driving_ptr_sfh2_valid : std_logic_vector(0 downto 0);
	signal pcieringbufferbarparser_i_ring_driving_ptr_sfh3 : std_logic_vector(31 downto 0);
	signal pcieringbufferbarparser_i_ring_driving_ptr_sfh3_valid : std_logic_vector(0 downto 0);
	signal pcieringbufferbarparser_i_ring_driving_ptr_sfh4 : std_logic_vector(31 downto 0);
	signal pcieringbufferbarparser_i_ring_driving_ptr_sfh4_valid : std_logic_vector(0 downto 0);
	signal pcieringbufferbarparser_i_ring_driving_ptr_sth0 : std_logic_vector(31 downto 0);
	signal pcieringbufferbarparser_i_ring_driving_ptr_sth0_valid : std_logic_vector(0 downto 0);
	signal pcieringbufferbarparser_i_ring_driving_ptr_sth1 : std_logic_vector(31 downto 0);
	signal pcieringbufferbarparser_i_ring_driving_ptr_sth1_valid : std_logic_vector(0 downto 0);
	signal pcieringbufferbarparser_i_bar_valid_sfh4 : std_logic_vector(0 downto 0);
	signal sg_fifo_sfh0_dout : std_logic_vector(71 downto 0);
	signal sg_fifo_sfh0_empty : std_logic_vector(0 downto 0);
	signal sg_fifo_sfh0_can_fetch : std_logic_vector(0 downto 0);
	signal sg_fifo_sfh1_dout : std_logic_vector(71 downto 0);
	signal sg_fifo_sfh1_empty : std_logic_vector(0 downto 0);
	signal sg_fifo_sfh1_can_fetch : std_logic_vector(0 downto 0);
	signal sg_fifo_sfh2_dout : std_logic_vector(71 downto 0);
	signal sg_fifo_sfh2_empty : std_logic_vector(0 downto 0);
	signal sg_fifo_sfh2_can_fetch : std_logic_vector(0 downto 0);
	signal sg_fifo_sfh3_dout : std_logic_vector(71 downto 0);
	signal sg_fifo_sfh3_empty : std_logic_vector(0 downto 0);
	signal sg_fifo_sfh3_can_fetch : std_logic_vector(0 downto 0);
	signal sg_fifo_sfh4_dout : std_logic_vector(71 downto 0);
	signal sg_fifo_sfh4_empty : std_logic_vector(0 downto 0);
	signal sg_fifo_sfh4_can_fetch : std_logic_vector(0 downto 0);
	signal sgring_sfh4_i_sgfifo_din : std_logic_vector(71 downto 0);
	signal sgring_sfh4_i_sgfifo_wren : std_logic_vector(0 downto 0);
	signal sgring_sfh4_i_request_ready : std_logic_vector(0 downto 0);
	signal sgring_sfh4_i_request_last : std_logic_vector(0 downto 0);
	signal sgring_sfh4_i_request_len : std_logic_vector(8 downto 0);
	signal sgring_sfh4_i_request_addr : std_logic_vector(60 downto 0);
	signal sgring_sfh4_i_request_data : std_logic_vector(127 downto 0);
	signal sgring_sfh4_i_request_data_valid : std_logic_vector(0 downto 0);
	signal sg_fifo_sth0_dout : std_logic_vector(71 downto 0);
	signal sg_fifo_sth0_empty : std_logic_vector(0 downto 0);
	signal sg_fifo_sth0_can_fetch : std_logic_vector(0 downto 0);
	signal sg_fifo_sth1_dout : std_logic_vector(71 downto 0);
	signal sg_fifo_sth1_empty : std_logic_vector(0 downto 0);
	signal sg_fifo_sth1_can_fetch : std_logic_vector(0 downto 0);
	signal sg_fetcher_external_condensed_dma_abort1 : std_logic_vector(6 downto 0);
	signal cat_ln285_sglistfetchengine : std_logic_vector(6 downto 0);
	signal sg_fetcher_external_sg_fifo_can_fetch1 : std_logic_vector(6 downto 0);
	signal cat_ln313_sglistfetchengine : std_logic_vector(6 downto 0);
	signal dma_control_ram_wea1 : std_logic_vector(7 downto 0);
	signal muxsel_ln245_sglistfetchengine1 : std_logic_vector(0 downto 0);
	signal muxout_ln245_sglistfetchengine : std_logic_vector(7 downto 0);
	signal dma_control_ram_web1 : std_logic_vector(7 downto 0);
	signal muxsel_ln307_sglistfetchengine1 : std_logic_vector(0 downto 0);
	signal muxout_ln307_sglistfetchengine : std_logic_vector(7 downto 0);
	signal sig1 : std_logic_vector(71 downto 0);
	signal fetcher_data_r0 : std_logic_vector(71 downto 0) := "000000000000000000000000000000000000000000000000000000000000000000000000";
	signal sig : std_logic_vector(0 downto 0);
	signal fetcher_write_r0 : std_logic_vector(0 downto 0) := "0";
	signal sg_fifo_select : std_logic_vector(6 downto 0);
	signal sg_fifo_sfh0_rst1 : std_logic_vector(0 downto 0);
	signal fifo_rst0 : std_logic_vector(0 downto 0) := "1";
	signal dma_abort_sfh_r : std_logic_vector(4 downto 0) := "00000";
	signal sig3 : std_logic_vector(71 downto 0);
	signal fetcher_data_r1 : std_logic_vector(71 downto 0) := "000000000000000000000000000000000000000000000000000000000000000000000000";
	signal sig2 : std_logic_vector(0 downto 0);
	signal fetcher_write_r1 : std_logic_vector(0 downto 0) := "0";
	signal sg_fifo_sfh1_rst1 : std_logic_vector(0 downto 0);
	signal fifo_rst1 : std_logic_vector(0 downto 0) := "1";
	signal sig5 : std_logic_vector(71 downto 0);
	signal fetcher_data_r2 : std_logic_vector(71 downto 0) := "000000000000000000000000000000000000000000000000000000000000000000000000";
	signal sig4 : std_logic_vector(0 downto 0);
	signal fetcher_write_r2 : std_logic_vector(0 downto 0) := "0";
	signal sg_fifo_sfh2_rst1 : std_logic_vector(0 downto 0);
	signal fifo_rst2 : std_logic_vector(0 downto 0) := "1";
	signal sig7 : std_logic_vector(71 downto 0);
	signal fetcher_data_r3 : std_logic_vector(71 downto 0) := "000000000000000000000000000000000000000000000000000000000000000000000000";
	signal sig6 : std_logic_vector(0 downto 0);
	signal fetcher_write_r3 : std_logic_vector(0 downto 0) := "0";
	signal sg_fifo_sfh3_rst1 : std_logic_vector(0 downto 0);
	signal fifo_rst3 : std_logic_vector(0 downto 0) := "1";
	signal sig9 : std_logic_vector(71 downto 0);
	signal sg_fifo_data_r4 : std_logic_vector(71 downto 0) := "000000000000000000000000000000000000000000000000000000000000000000000000";
	signal fetcher_data_r4 : std_logic_vector(71 downto 0) := "000000000000000000000000000000000000000000000000000000000000000000000000";
	signal muxsel_ln406_sglistfetchengine1 : std_logic_vector(0 downto 0);
	signal muxout_ln406_sglistfetchengine : std_logic_vector(71 downto 0);
	signal sig8 : std_logic_vector(0 downto 0);
	signal sg_fifo_wren_4 : std_logic_vector(0 downto 0) := "0";
	signal fetcher_write_r4 : std_logic_vector(0 downto 0) := "0";
	signal sg_fifo_sfh4_rst1 : std_logic_vector(0 downto 0);
	signal fifo_rst4 : std_logic_vector(0 downto 0) := "1";
	signal sgring_sfh4_i_rst_sync1 : std_logic_vector(0 downto 0);
	signal sgring_sfh4_i_abort1 : std_logic_vector(0 downto 0);
	signal sgring_sfh4_i_bar_sg_index1 : std_logic_vector(8 downto 0);
	signal sgring_sfh4_i_bar_last_buffer_index1 : std_logic_vector(8 downto 0);
	signal sgring_sfh4_i_bar_user_pointer1 : std_logic_vector(60 downto 0);
	signal sgring_sfh4_i_bar_driving_ptr1 : std_logic_vector(9 downto 0);
	signal sgring_sfh4_i_sgfifo_full1 : std_logic_vector(0 downto 0);
	signal sig11 : std_logic_vector(71 downto 0);
	signal fetcher_data_r5 : std_logic_vector(71 downto 0) := "000000000000000000000000000000000000000000000000000000000000000000000000";
	signal sig10 : std_logic_vector(0 downto 0);
	signal fetcher_write_r5 : std_logic_vector(0 downto 0) := "0";
	signal sg_fifo_sth0_rst1 : std_logic_vector(0 downto 0);
	signal fifo_rst5 : std_logic_vector(0 downto 0) := "1";
	signal dma_abort_sth_r : std_logic_vector(1 downto 0) := "00";
	signal sig13 : std_logic_vector(71 downto 0);
	signal fetcher_data_r6 : std_logic_vector(71 downto 0) := "000000000000000000000000000000000000000000000000000000000000000000000000";
	signal sig12 : std_logic_vector(0 downto 0);
	signal fetcher_write_r6 : std_logic_vector(0 downto 0) := "0";
	signal sg_fifo_sth1_rst1 : std_logic_vector(0 downto 0);
	signal fifo_rst6 : std_logic_vector(0 downto 0) := "1";
	signal cat_ln318_sglistfetchengine : std_logic_vector(31 downto 0);
	signal cat_ln319_sglistfetchengine : std_logic_vector(31 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	cat_ln285_sglistfetchengine<=(slice(dma_abort_sth, 0, 2) & slice(dma_abort_sfh, 0, 5));
	sg_fetcher_external_condensed_dma_abort1 <= cat_ln285_sglistfetchengine;
	cat_ln313_sglistfetchengine<=(sg_fifo_sth1_can_fetch & sg_fifo_sth0_can_fetch & sg_fifo_sfh4_can_fetch & sg_fifo_sfh3_can_fetch & sg_fifo_sfh2_can_fetch & sg_fifo_sfh1_can_fetch & sg_fifo_sfh0_can_fetch);
	sg_fetcher_external_sg_fifo_can_fetch1 <= cat_ln313_sglistfetchengine;
	muxsel_ln245_sglistfetchengine1 <= bit_to_vec(dma_ctl_write);
	muxproc_ln245_sglistfetchengine : process(dma_ctl_byte_en, muxsel_ln245_sglistfetchengine1)
	begin
		case muxsel_ln245_sglistfetchengine1 is
			when "0" => muxout_ln245_sglistfetchengine <= "00000000";
			when "1" => muxout_ln245_sglistfetchengine <= dma_ctl_byte_en;
			when others => 
			muxout_ln245_sglistfetchengine <= (others => 'X');
		end case;
	end process;
	dma_control_ram_wea1 <= muxout_ln245_sglistfetchengine;
	muxsel_ln307_sglistfetchengine1 <= sg_fetcher_external_dma_ctl_write_enable;
	muxproc_ln307_sglistfetchengine : process(muxsel_ln307_sglistfetchengine1)
	begin
		case muxsel_ln307_sglistfetchengine1 is
			when "0" => muxout_ln307_sglistfetchengine <= "00000000";
			when "1" => muxout_ln307_sglistfetchengine <= "11111111";
			when others => 
			muxout_ln307_sglistfetchengine <= (others => 'X');
		end case;
	end process;
	dma_control_ram_web1 <= muxout_ln307_sglistfetchengine;
	sig1 <= fetcher_data_r0;
	sg_fifo_select <= sg_fetcher_external_sg_fifo_select;
	sig <= fetcher_write_r0;
	sg_fifo_sfh0_rst1 <= (fifo_rst0 or (slice(pcieringbufferbarparser_i_ring_reset, 0, 1) and pcieringbufferbarparser_i_ring_reset_valid));
	sig3 <= fetcher_data_r1;
	sig2 <= fetcher_write_r1;
	sg_fifo_sfh1_rst1 <= (fifo_rst1 or (slice(pcieringbufferbarparser_i_ring_reset, 1, 1) and pcieringbufferbarparser_i_ring_reset_valid));
	sig5 <= fetcher_data_r2;
	sig4 <= fetcher_write_r2;
	sg_fifo_sfh2_rst1 <= (fifo_rst2 or (slice(pcieringbufferbarparser_i_ring_reset, 2, 1) and pcieringbufferbarparser_i_ring_reset_valid));
	sig7 <= fetcher_data_r3;
	sig6 <= fetcher_write_r3;
	sg_fifo_sfh3_rst1 <= (fifo_rst3 or (slice(pcieringbufferbarparser_i_ring_reset, 3, 1) and pcieringbufferbarparser_i_ring_reset_valid));
	muxsel_ln406_sglistfetchengine1 <= sgring_sfh4_i_sgfifo_wren;
	muxproc_ln406_sglistfetchengine : process(fetcher_data_r4, sgring_sfh4_i_sgfifo_din, muxsel_ln406_sglistfetchengine1)
	begin
		case muxsel_ln406_sglistfetchengine1 is
			when "0" => muxout_ln406_sglistfetchengine <= fetcher_data_r4;
			when "1" => muxout_ln406_sglistfetchengine <= sgring_sfh4_i_sgfifo_din;
			when others => 
			muxout_ln406_sglistfetchengine <= (others => 'X');
		end case;
	end process;
	sig9 <= sg_fifo_data_r4;
	sig8 <= sg_fifo_wren_4;
	sg_fifo_sfh4_rst1 <= (fifo_rst4 or (slice(pcieringbufferbarparser_i_ring_reset, 4, 1) and pcieringbufferbarparser_i_ring_reset_valid));
	sgring_sfh4_i_rst_sync1 <= (bit_to_vec(streamrst_pcie) or (slice(pcieringbufferbarparser_i_ring_reset, 4, 1) and pcieringbufferbarparser_i_ring_reset_valid));
	sgring_sfh4_i_abort1 <= slice(slice(dma_abort_sfh, 0, 5), 4, 1);
	sgring_sfh4_i_bar_sg_index1 <= slice(pcieringbufferbarparser_i_ring_current_entry_index, 0, 9);
	sgring_sfh4_i_bar_last_buffer_index1 <= slice(pcieringbufferbarparser_i_ring_last_entry_index, 0, 9);
	sgring_sfh4_i_bar_user_pointer1 <= slice(pcieringbufferbarparser_i_ring_vfifo_userspace_ptr, 0, 61);
	sgring_sfh4_i_bar_driving_ptr1 <= slice(pcieringbufferbarparser_i_ring_driving_ptr_sfh4, 0, 10);
	sgring_sfh4_i_sgfifo_full1 <= (not sg_fifo_sfh4_can_fetch);
	sig11 <= fetcher_data_r5;
	sig10 <= fetcher_write_r5;
	sg_fifo_sth0_rst1 <= (fifo_rst5 or (slice(pcieringbufferbarparser_i_ring_reset, 16, 1) and pcieringbufferbarparser_i_ring_reset_valid));
	sig13 <= fetcher_data_r6;
	sig12 <= fetcher_write_r6;
	sg_fifo_sth1_rst1 <= (fifo_rst6 or (slice(pcieringbufferbarparser_i_ring_reset, 17, 1) and pcieringbufferbarparser_i_ring_reset_valid));
	cat_ln318_sglistfetchengine<=("000000000000000000000000000" & bit_to_vec(sfh4_port_dma_complete) & bit_to_vec(sfh3_port_dma_complete) & bit_to_vec(sfh2_port_dma_complete) & bit_to_vec(sfh1_port_dma_complete) & bit_to_vec(sfh0_port_dma_complete));
	cat_ln319_sglistfetchengine<=("000000000000000000000000000000" & bit_to_vec(sth1_port_dma_complete) & bit_to_vec(sth0_port_dma_complete));
	response_metadata_free <= vec_to_bit(sg_fetcher_external_response_metadata_free);
	request_ready <= vec_to_bit(sg_fetcher_external_request_ready);
	request_len <= sg_fetcher_external_request_len;
	request_addr <= sg_fetcher_external_request_addr;
	request_metadata <= sg_fetcher_external_request_metadata;
	dma_complete_sfh <= cat_ln318_sglistfetchengine;
	dma_complete_sth <= cat_ln319_sglistfetchengine;
	dma_ctl_read_data <= dma_control_ram_douta;
	sfh0_port_entry_data <= slice(sg_fifo_sfh0_dout, 2, 61);
	sfh0_port_entry_size <= slice(sg_fifo_sfh0_dout, 63, 9);
	sfh0_port_entry_last <= vec_to_bit(slice(sg_fifo_sfh0_dout, 1, 1));
	sfh0_port_entry_eos <= vec_to_bit(slice(sg_fifo_sfh0_dout, 0, 1));
	sfh0_port_abort_dma <= vec_to_bit(slice(slice(dma_abort_sfh, 0, 5), 0, 1));
	sfh0_port_empty <= vec_to_bit(sg_fifo_sfh0_empty);
	sfh_ring_reset0 <= vec_to_bit((bit_to_vec(streamrst_pcie) or (slice(pcieringbufferbarparser_i_ring_reset, 0, 1) and pcieringbufferbarparser_i_ring_reset_valid)));
	sfh1_port_entry_data <= slice(sg_fifo_sfh1_dout, 2, 61);
	sfh1_port_entry_size <= slice(sg_fifo_sfh1_dout, 63, 9);
	sfh1_port_entry_last <= vec_to_bit(slice(sg_fifo_sfh1_dout, 1, 1));
	sfh1_port_entry_eos <= vec_to_bit(slice(sg_fifo_sfh1_dout, 0, 1));
	sfh1_port_abort_dma <= vec_to_bit(slice(slice(dma_abort_sfh, 0, 5), 1, 1));
	sfh1_port_empty <= vec_to_bit(sg_fifo_sfh1_empty);
	sfh_ring_reset1 <= vec_to_bit((bit_to_vec(streamrst_pcie) or (slice(pcieringbufferbarparser_i_ring_reset, 1, 1) and pcieringbufferbarparser_i_ring_reset_valid)));
	sfh2_port_entry_data <= slice(sg_fifo_sfh2_dout, 2, 61);
	sfh2_port_entry_size <= slice(sg_fifo_sfh2_dout, 63, 9);
	sfh2_port_entry_last <= vec_to_bit(slice(sg_fifo_sfh2_dout, 1, 1));
	sfh2_port_entry_eos <= vec_to_bit(slice(sg_fifo_sfh2_dout, 0, 1));
	sfh2_port_abort_dma <= vec_to_bit(slice(slice(dma_abort_sfh, 0, 5), 2, 1));
	sfh2_port_empty <= vec_to_bit(sg_fifo_sfh2_empty);
	sfh_ring_reset2 <= vec_to_bit((bit_to_vec(streamrst_pcie) or (slice(pcieringbufferbarparser_i_ring_reset, 2, 1) and pcieringbufferbarparser_i_ring_reset_valid)));
	sfh3_port_entry_data <= slice(sg_fifo_sfh3_dout, 2, 61);
	sfh3_port_entry_size <= slice(sg_fifo_sfh3_dout, 63, 9);
	sfh3_port_entry_last <= vec_to_bit(slice(sg_fifo_sfh3_dout, 1, 1));
	sfh3_port_entry_eos <= vec_to_bit(slice(sg_fifo_sfh3_dout, 0, 1));
	sfh3_port_abort_dma <= vec_to_bit(slice(slice(dma_abort_sfh, 0, 5), 3, 1));
	sfh3_port_empty <= vec_to_bit(sg_fifo_sfh3_empty);
	sfh_ring_reset3 <= vec_to_bit((bit_to_vec(streamrst_pcie) or (slice(pcieringbufferbarparser_i_ring_reset, 3, 1) and pcieringbufferbarparser_i_ring_reset_valid)));
	sfh4_port_entry_data <= slice(sg_fifo_sfh4_dout, 2, 61);
	sfh4_port_entry_size <= slice(sg_fifo_sfh4_dout, 63, 9);
	sfh4_port_entry_last <= vec_to_bit(slice(sg_fifo_sfh4_dout, 1, 1));
	sfh4_port_entry_eos <= vec_to_bit(slice(sg_fifo_sfh4_dout, 0, 1));
	sfh4_port_abort_dma <= vec_to_bit(slice(slice(dma_abort_sfh, 0, 5), 4, 1));
	sfh4_port_empty <= vec_to_bit(sg_fifo_sfh4_empty);
	sfh_ring_reset4 <= vec_to_bit((bit_to_vec(streamrst_pcie) or (slice(pcieringbufferbarparser_i_ring_reset, 4, 1) and pcieringbufferbarparser_i_ring_reset_valid)));
	sg_ring_write_sfh4_ready <= vec_to_bit(sgring_sfh4_i_request_ready);
	sg_ring_write_sfh4_last <= vec_to_bit(sgring_sfh4_i_request_last);
	sg_ring_write_sfh4_len <= sgring_sfh4_i_request_len;
	sg_ring_write_sfh4_addr <= sgring_sfh4_i_request_addr;
	sg_ring_write_sfh4_data <= sgring_sfh4_i_request_data;
	sg_ring_write_sfh4_data_valid <= vec_to_bit(sgring_sfh4_i_request_data_valid);
	sth0_port_entry_data <= slice(sg_fifo_sth0_dout, 2, 61);
	sth0_port_entry_size <= slice(sg_fifo_sth0_dout, 63, 9);
	sth0_port_entry_last <= vec_to_bit(slice(sg_fifo_sth0_dout, 1, 1));
	sth0_port_entry_eos <= vec_to_bit(slice(sg_fifo_sth0_dout, 0, 1));
	sth0_port_abort_dma <= vec_to_bit(slice(slice(dma_abort_sth, 0, 2), 0, 1));
	sth0_port_empty <= vec_to_bit(sg_fifo_sth0_empty);
	sth_ring_reset0 <= vec_to_bit((bit_to_vec(streamrst_pcie) or (slice(pcieringbufferbarparser_i_ring_reset, 16, 1) and pcieringbufferbarparser_i_ring_reset_valid)));
	sth1_port_entry_data <= slice(sg_fifo_sth1_dout, 2, 61);
	sth1_port_entry_size <= slice(sg_fifo_sth1_dout, 63, 9);
	sth1_port_entry_last <= vec_to_bit(slice(sg_fifo_sth1_dout, 1, 1));
	sth1_port_entry_eos <= vec_to_bit(slice(sg_fifo_sth1_dout, 0, 1));
	sth1_port_abort_dma <= vec_to_bit(slice(slice(dma_abort_sth, 0, 2), 1, 1));
	sth1_port_empty <= vec_to_bit(sg_fifo_sth1_empty);
	sth_ring_reset1 <= vec_to_bit((bit_to_vec(streamrst_pcie) or (slice(pcieringbufferbarparser_i_ring_reset, 17, 1) and pcieringbufferbarparser_i_ring_reset_valid)));
	
	-- Register processes
	
	reg_process : process(clk_pcie)
	begin
		if rising_edge(clk_pcie) then
			fetcher_data_r0 <= sg_fetcher_external_sg_fifo_data;
			fetcher_write_r0 <= slice(sg_fifo_select, 0, 1);
			if slv_to_slv(bit_to_vec(streamrst_pcie)) = "1" then
				fifo_rst0 <= "1";
			else
				fifo_rst0 <= slice(dma_abort_sfh_r, 0, 1);
			end if;
			dma_abort_sfh_r <= slice(dma_abort_sfh, 0, 5);
			fetcher_data_r1 <= sg_fetcher_external_sg_fifo_data;
			fetcher_write_r1 <= slice(sg_fifo_select, 1, 1);
			if slv_to_slv(bit_to_vec(streamrst_pcie)) = "1" then
				fifo_rst1 <= "1";
			else
				fifo_rst1 <= slice(dma_abort_sfh_r, 1, 1);
			end if;
			fetcher_data_r2 <= sg_fetcher_external_sg_fifo_data;
			fetcher_write_r2 <= slice(sg_fifo_select, 2, 1);
			if slv_to_slv(bit_to_vec(streamrst_pcie)) = "1" then
				fifo_rst2 <= "1";
			else
				fifo_rst2 <= slice(dma_abort_sfh_r, 2, 1);
			end if;
			fetcher_data_r3 <= sg_fetcher_external_sg_fifo_data;
			fetcher_write_r3 <= slice(sg_fifo_select, 3, 1);
			if slv_to_slv(bit_to_vec(streamrst_pcie)) = "1" then
				fifo_rst3 <= "1";
			else
				fifo_rst3 <= slice(dma_abort_sfh_r, 3, 1);
			end if;
			sg_fifo_data_r4 <= muxout_ln406_sglistfetchengine;
			fetcher_data_r4 <= sg_fetcher_external_sg_fifo_data;
			sg_fifo_wren_4 <= (sgring_sfh4_i_sgfifo_wren or fetcher_write_r4);
			fetcher_write_r4 <= slice(sg_fifo_select, 4, 1);
			if slv_to_slv(bit_to_vec(streamrst_pcie)) = "1" then
				fifo_rst4 <= "1";
			else
				fifo_rst4 <= slice(dma_abort_sfh_r, 4, 1);
			end if;
			fetcher_data_r5 <= sg_fetcher_external_sg_fifo_data;
			fetcher_write_r5 <= slice(sg_fifo_select, 5, 1);
			if slv_to_slv(bit_to_vec(streamrst_pcie)) = "1" then
				fifo_rst5 <= "1";
			else
				fifo_rst5 <= slice(dma_abort_sth_r, 0, 1);
			end if;
			dma_abort_sth_r <= slice(dma_abort_sth, 0, 2);
			fetcher_data_r6 <= sg_fetcher_external_sg_fifo_data;
			fetcher_write_r6 <= slice(sg_fifo_select, 6, 1);
			if slv_to_slv(bit_to_vec(streamrst_pcie)) = "1" then
				fifo_rst6 <= "1";
			else
				fifo_rst6 <= slice(dma_abort_sth_r, 1, 1);
			end if;
		end if;
	end process;
	
	-- Entity instances
	
	sg_fetcher_external : sg_fetcher
		generic map (
			VALID_WIDTH => 2,
			PCIE_BUS_WIDTH => 128,
			METADATA_WIDTH => 28,
			NUM_STREAMS_TO_HOST => 2,
			NUM_STREAMS_FROM_HOST => 5,
			NUM_STREAMS_WIDTH => 3,
			ADB => 128
		)
		port map (
			response_metadata_free => sg_fetcher_external_response_metadata_free(0), -- 1 bits (out)
			request_ready => sg_fetcher_external_request_ready(0), -- 1 bits (out)
			request_len => sg_fetcher_external_request_len, -- 7 bits (out)
			request_addr => sg_fetcher_external_request_addr, -- 61 bits (out)
			request_metadata => sg_fetcher_external_request_metadata, -- 28 bits (out)
			dma_ctl_address => sg_fetcher_external_dma_ctl_address, -- 9 bits (out)
			dma_ctl_write_data => sg_fetcher_external_dma_ctl_write_data, -- 64 bits (out)
			dma_ctl_write_enable => sg_fetcher_external_dma_ctl_write_enable(0), -- 1 bits (out)
			sg_fifo_data => sg_fetcher_external_sg_fifo_data, -- 72 bits (out)
			sg_fifo_select => sg_fetcher_external_sg_fifo_select, -- 7 bits (out)
			clk_pcie => clk_pcie, -- 1 bits (in)
			rst_pcie_n => rst_pcie_n, -- 1 bits (in)
			streamrst_pcie => streamrst_pcie, -- 1 bits (in)
			response_valid => response_valid, -- 2 bits (in)
			response_data => sg_gen2_input_buffer_response_word, -- 64 bits (in)
			response_select => response_select, -- 1 bits (in)
			response_metadata => response_metadata, -- 28 bits (in)
			response_metadata_valid => response_metadata_valid, -- 1 bits (in)
			response_gen2_valid => vec_to_bit(sg_gen2_input_buffer_response_sel_vld), -- 1 bits (in)
			response_gen2_metadata => sg_gen2_input_buffer_response_metadata_out, -- 28 bits (in)
			request_select => request_select, -- 1 bits (in)
			dma_ctl_read_data => dma_control_ram_doutb, -- 64 bits (in)
			condensed_dma_abort => sg_fetcher_external_condensed_dma_abort1, -- 7 bits (in)
			sg_fifo_can_fetch => sg_fetcher_external_sg_fifo_can_fetch1 -- 7 bits (in)
		);
	sg_gen2_input_buffer : SGGen2InputBuffer
		port map (
			response_word => sg_gen2_input_buffer_response_word, -- 64 bits (out)
			response_sel_vld => sg_gen2_input_buffer_response_sel_vld(0), -- 1 bits (out)
			response_metadata_out => sg_gen2_input_buffer_response_metadata_out, -- 28 bits (out)
			clk => clk_pcie, -- 1 bits (in)
			rst => streamrst_pcie, -- 1 bits (in)
			response_data => response_data, -- 128 bits (in)
			response_metadata => response_metadata, -- 28 bits (in)
			response_valid => response_valid, -- 2 bits (in)
			response_select => response_select, -- 1 bits (in)
			response_metadata_valid => response_metadata_valid -- 1 bits (in)
		);
	dma_control_ram : AlteraBlockMem_RAM_DUAL_PORT_64x512_RAM_DUAL_PORT_bw_ireg_readfirst
		port map (
			douta => dma_control_ram_douta, -- 64 bits (out)
			doutb => dma_control_ram_doutb, -- 64 bits (out)
			clka => clk_pcie, -- 1 bits (in)
			addra => dma_ctl_address, -- 9 bits (in)
			dina => dma_ctl_data, -- 64 bits (in)
			addrb => sg_fetcher_external_dma_ctl_address, -- 9 bits (in)
			dinb => sg_fetcher_external_dma_ctl_write_data, -- 64 bits (in)
			wea => dma_control_ram_wea1, -- 8 bits (in)
			web => dma_control_ram_web1 -- 8 bits (in)
		);
	PCIeRingBufferBarParser_i : PCIeRingBufferBarParser
		port map (
			ring_sg_buffer_entry => pcieringbufferbarparser_i_ring_sg_buffer_entry, -- 72 bits (out)
			ring_vfifo_userspace_ptr => pcieringbufferbarparser_i_ring_vfifo_userspace_ptr, -- 64 bits (out)
			ring_last_entry_index => pcieringbufferbarparser_i_ring_last_entry_index, -- 32 bits (out)
			ring_current_entry_index => pcieringbufferbarparser_i_ring_current_entry_index, -- 32 bits (out)
			ring_stream_select_sfh => pcieringbufferbarparser_i_ring_stream_select_sfh, -- 16 bits (out)
			ring_stream_select_sth => pcieringbufferbarparser_i_ring_stream_select_sth, -- 16 bits (out)
			ring_config_valid => pcieringbufferbarparser_i_ring_config_valid(0), -- 1 bits (out)
			ring_reset => pcieringbufferbarparser_i_ring_reset, -- 32 bits (out)
			ring_reset_valid => pcieringbufferbarparser_i_ring_reset_valid(0), -- 1 bits (out)
			ring_driving_ptr_sfh0 => pcieringbufferbarparser_i_ring_driving_ptr_sfh0, -- 32 bits (out)
			ring_driving_ptr_sfh0_valid => pcieringbufferbarparser_i_ring_driving_ptr_sfh0_valid(0), -- 1 bits (out)
			ring_driving_ptr_sfh1 => pcieringbufferbarparser_i_ring_driving_ptr_sfh1, -- 32 bits (out)
			ring_driving_ptr_sfh1_valid => pcieringbufferbarparser_i_ring_driving_ptr_sfh1_valid(0), -- 1 bits (out)
			ring_driving_ptr_sfh2 => pcieringbufferbarparser_i_ring_driving_ptr_sfh2, -- 32 bits (out)
			ring_driving_ptr_sfh2_valid => pcieringbufferbarparser_i_ring_driving_ptr_sfh2_valid(0), -- 1 bits (out)
			ring_driving_ptr_sfh3 => pcieringbufferbarparser_i_ring_driving_ptr_sfh3, -- 32 bits (out)
			ring_driving_ptr_sfh3_valid => pcieringbufferbarparser_i_ring_driving_ptr_sfh3_valid(0), -- 1 bits (out)
			ring_driving_ptr_sfh4 => pcieringbufferbarparser_i_ring_driving_ptr_sfh4, -- 32 bits (out)
			ring_driving_ptr_sfh4_valid => pcieringbufferbarparser_i_ring_driving_ptr_sfh4_valid(0), -- 1 bits (out)
			ring_driving_ptr_sth0 => pcieringbufferbarparser_i_ring_driving_ptr_sth0, -- 32 bits (out)
			ring_driving_ptr_sth0_valid => pcieringbufferbarparser_i_ring_driving_ptr_sth0_valid(0), -- 1 bits (out)
			ring_driving_ptr_sth1 => pcieringbufferbarparser_i_ring_driving_ptr_sth1, -- 32 bits (out)
			ring_driving_ptr_sth1_valid => pcieringbufferbarparser_i_ring_driving_ptr_sth1_valid(0), -- 1 bits (out)
			bar_valid_sfh4 => pcieringbufferbarparser_i_bar_valid_sfh4(0), -- 1 bits (out)
			bar_parse_wr_addr_onehot => bar_parse_wr_addr_onehot, -- 256 bits (in)
			bar_parse_wr_data => bar_parse_wr_data, -- 64 bits (in)
			bar_parse_wr_clk => bar_parse_wr_clk, -- 1 bits (in)
			bar_parse_wr_page_sel_onehot => bar_parse_wr_page_sel_onehot -- 2 bits (in)
		);
	sg_fifo_sfh0 : SGFifo
		port map (
			dout => sg_fifo_sfh0_dout, -- 72 bits (out)
			empty => sg_fifo_sfh0_empty(0), -- 1 bits (out)
			can_fetch => sg_fifo_sfh0_can_fetch(0), -- 1 bits (out)
			din => sig1, -- 72 bits (in)
			wr_en => vec_to_bit(sig), -- 1 bits (in)
			rd_en => sfh0_port_entry_read, -- 1 bits (in)
			clk => clk_pcie, -- 1 bits (in)
			rst => vec_to_bit(sg_fifo_sfh0_rst1) -- 1 bits (in)
		);
	sg_fifo_sfh1 : SGFifo
		port map (
			dout => sg_fifo_sfh1_dout, -- 72 bits (out)
			empty => sg_fifo_sfh1_empty(0), -- 1 bits (out)
			can_fetch => sg_fifo_sfh1_can_fetch(0), -- 1 bits (out)
			din => sig3, -- 72 bits (in)
			wr_en => vec_to_bit(sig2), -- 1 bits (in)
			rd_en => sfh1_port_entry_read, -- 1 bits (in)
			clk => clk_pcie, -- 1 bits (in)
			rst => vec_to_bit(sg_fifo_sfh1_rst1) -- 1 bits (in)
		);
	sg_fifo_sfh2 : SGFifo
		port map (
			dout => sg_fifo_sfh2_dout, -- 72 bits (out)
			empty => sg_fifo_sfh2_empty(0), -- 1 bits (out)
			can_fetch => sg_fifo_sfh2_can_fetch(0), -- 1 bits (out)
			din => sig5, -- 72 bits (in)
			wr_en => vec_to_bit(sig4), -- 1 bits (in)
			rd_en => sfh2_port_entry_read, -- 1 bits (in)
			clk => clk_pcie, -- 1 bits (in)
			rst => vec_to_bit(sg_fifo_sfh2_rst1) -- 1 bits (in)
		);
	sg_fifo_sfh3 : SGFifo
		port map (
			dout => sg_fifo_sfh3_dout, -- 72 bits (out)
			empty => sg_fifo_sfh3_empty(0), -- 1 bits (out)
			can_fetch => sg_fifo_sfh3_can_fetch(0), -- 1 bits (out)
			din => sig7, -- 72 bits (in)
			wr_en => vec_to_bit(sig6), -- 1 bits (in)
			rd_en => sfh3_port_entry_read, -- 1 bits (in)
			clk => clk_pcie, -- 1 bits (in)
			rst => vec_to_bit(sg_fifo_sfh3_rst1) -- 1 bits (in)
		);
	sg_fifo_sfh4 : SGFifo
		port map (
			dout => sg_fifo_sfh4_dout, -- 72 bits (out)
			empty => sg_fifo_sfh4_empty(0), -- 1 bits (out)
			can_fetch => sg_fifo_sfh4_can_fetch(0), -- 1 bits (out)
			din => sig9, -- 72 bits (in)
			wr_en => vec_to_bit(sig8), -- 1 bits (in)
			rd_en => sfh4_port_entry_read, -- 1 bits (in)
			clk => clk_pcie, -- 1 bits (in)
			rst => vec_to_bit(sg_fifo_sfh4_rst1) -- 1 bits (in)
		);
	SGRing_sfh4_i : sg_ring
		generic map (
			RING_ADDR_WIDTH => 9,
			SG_FIFO_WIDTH => 72,
			HOST_MEMORY_ADDR_WIDTH => 61,
			HOST_DATA_WIDTH => 128,
			NATIVE_TO_QUAD_PAD_BIT => 1,
			MODE_WRITE => false
		)
		port map (
			sgfifo_din => sgring_sfh4_i_sgfifo_din, -- 72 bits (out)
			sgfifo_wren => sgring_sfh4_i_sgfifo_wren(0), -- 1 bits (out)
			request_ready => sgring_sfh4_i_request_ready(0), -- 1 bits (out)
			request_last => sgring_sfh4_i_request_last(0), -- 1 bits (out)
			request_len => sgring_sfh4_i_request_len, -- 9 bits (out)
			request_addr => sgring_sfh4_i_request_addr, -- 61 bits (out)
			request_data => sgring_sfh4_i_request_data, -- 128 bits (out)
			request_data_valid => sgring_sfh4_i_request_data_valid(0), -- 1 bits (out)
			clk => clk_pcie, -- 1 bits (in)
			rst_sync => vec_to_bit(sgring_sfh4_i_rst_sync1), -- 1 bits (in)
			abort => vec_to_bit(sgring_sfh4_i_abort1), -- 1 bits (in)
			bar_sg_data => pcieringbufferbarparser_i_ring_sg_buffer_entry, -- 72 bits (in)
			bar_sg_index => sgring_sfh4_i_bar_sg_index1, -- 9 bits (in)
			bar_last_buffer_index => sgring_sfh4_i_bar_last_buffer_index1, -- 9 bits (in)
			bar_user_pointer => sgring_sfh4_i_bar_user_pointer1, -- 61 bits (in)
			bar_valid => vec_to_bit(pcieringbufferbarparser_i_bar_valid_sfh4), -- 1 bits (in)
			bar_driving_ptr => sgring_sfh4_i_bar_driving_ptr1, -- 10 bits (in)
			bar_driving_ptr_valid => vec_to_bit(pcieringbufferbarparser_i_ring_driving_ptr_sfh4_valid), -- 1 bits (in)
			sgfifo_full => vec_to_bit(sgring_sfh4_i_sgfifo_full1), -- 1 bits (in)
			stream_buffer_done => sfh4_port_entry_complete, -- 1 bits (in)
			request_select => sg_ring_write_sfh4_select, -- 1 bits (in)
			request_data_read => sg_ring_write_sfh4_data_read -- 1 bits (in)
		);
	sg_fifo_sth0 : SGFifo
		port map (
			dout => sg_fifo_sth0_dout, -- 72 bits (out)
			empty => sg_fifo_sth0_empty(0), -- 1 bits (out)
			can_fetch => sg_fifo_sth0_can_fetch(0), -- 1 bits (out)
			din => sig11, -- 72 bits (in)
			wr_en => vec_to_bit(sig10), -- 1 bits (in)
			rd_en => sth0_port_entry_read, -- 1 bits (in)
			clk => clk_pcie, -- 1 bits (in)
			rst => vec_to_bit(sg_fifo_sth0_rst1) -- 1 bits (in)
		);
	sg_fifo_sth1 : SGFifo
		port map (
			dout => sg_fifo_sth1_dout, -- 72 bits (out)
			empty => sg_fifo_sth1_empty(0), -- 1 bits (out)
			can_fetch => sg_fifo_sth1_can_fetch(0), -- 1 bits (out)
			din => sig13, -- 72 bits (in)
			wr_en => vec_to_bit(sig12), -- 1 bits (in)
			rd_en => sth1_port_entry_read, -- 1 bits (in)
			clk => clk_pcie, -- 1 bits (in)
			rst => vec_to_bit(sg_fifo_sth1_rst1) -- 1 bits (in)
		);
end MaxDC;
