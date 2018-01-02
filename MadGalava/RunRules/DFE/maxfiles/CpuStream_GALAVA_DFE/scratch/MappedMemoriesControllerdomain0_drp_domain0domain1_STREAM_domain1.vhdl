library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity MappedMemoriesControllerdomain0_drp_domain0domain1_STREAM_domain1 is
	port (
		clk_switch: in std_logic;
		rst_switch: in std_logic;
		FROM_SWITCH_SOP_N: in std_logic;
		FROM_SWITCH_EOP_N: in std_logic;
		FROM_SWITCH_SRC_RDY_N: in std_logic;
		FROM_SWITCH_DATA: in std_logic_vector(31 downto 0);
		TO_SWITCH_DST_RDY_N: in std_logic;
		domain0_drp_clk: in std_logic;
		domain0_drp_rst: in std_logic;
		domain0_drp_memories_memories_data_out: in std_logic_vector(35 downto 0);
		domain0_drp_memories_memories_ack: in std_logic;
		domain1_STREAM_clk: in std_logic;
		domain1_STREAM_rst: in std_logic;
		domain1_STREAM_memories_memories_data_out: in std_logic_vector(35 downto 0);
		domain1_STREAM_memories_memories_ack: in std_logic;
		FROM_SWITCH_DST_RDY_N: out std_logic;
		TO_SWITCH_SOP_N: out std_logic;
		TO_SWITCH_EOP_N: out std_logic;
		TO_SWITCH_SRC_RDY_N: out std_logic;
		TO_SWITCH_DATA: out std_logic_vector(31 downto 0);
		domain0_drp_memories_memories_data_in: out std_logic_vector(35 downto 0);
		domain0_drp_memories_memories_memid: out std_logic_vector(15 downto 0);
		domain0_drp_memories_memories_memaddr: out std_logic_vector(15 downto 0);
		domain0_drp_memories_memories_wren: out std_logic;
		domain0_drp_memories_memories_rden: out std_logic;
		domain0_drp_memories_memories_stop: out std_logic;
		domain1_STREAM_memories_memories_data_in: out std_logic_vector(35 downto 0);
		domain1_STREAM_memories_memories_memid: out std_logic_vector(15 downto 0);
		domain1_STREAM_memories_memories_memaddr: out std_logic_vector(15 downto 0);
		domain1_STREAM_memories_memories_wren: out std_logic;
		domain1_STREAM_memories_memories_rden: out std_logic;
		domain1_STREAM_memories_memories_stop: out std_logic
	);
end MappedMemoriesControllerdomain0_drp_domain0domain1_STREAM_domain1;

architecture MaxDC of MappedMemoriesControllerdomain0_drp_domain0domain1_STREAM_domain1 is
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
	component mapped_memories_controller_core is
		generic (
			MEM_ID_WIDTH : integer;
			ADDRESS_WIDTH : integer;
			DATA_WIDTH : integer;
			SWITCH_DATA_WIDTH : integer
		);
		port (
			clk_switch: in std_logic;
			rst_switch: in std_logic;
			controller_start: in std_logic;
			assert_stop: in std_logic;
			is_write: in std_logic;
			memory_id: in std_logic_vector(15 downto 0);
			base_address: in std_logic_vector(15 downto 0);
			last_read_address: in std_logic_vector(15 downto 0);
			WRITE_PORT_SOP_N: in std_logic;
			WRITE_PORT_EOP_N: in std_logic;
			WRITE_PORT_SRC_RDY_N: in std_logic;
			WRITE_PORT_DATA: in std_logic_vector(31 downto 0);
			READ_PORT_DST_RDY_N: in std_logic;
			request_full: in std_logic;
			response_empty: in std_logic;
			response_mem_data_out: in std_logic_vector(35 downto 0);
			controller_finished: out std_logic;
			WRITE_PORT_DST_RDY_N: out std_logic;
			READ_PORT_SOP_N: out std_logic;
			READ_PORT_EOP_N: out std_logic;
			READ_PORT_SRC_RDY_N: out std_logic;
			READ_PORT_DATA: out std_logic_vector(31 downto 0);
			request_write: out std_logic;
			request_mem_data_in: out std_logic_vector(35 downto 0);
			request_mem_id: out std_logic_vector(15 downto 0);
			request_mem_memaddr: out std_logic_vector(15 downto 0);
			request_mem_wren: out std_logic;
			request_mem_rden: out std_logic;
			request_mem_stop: out std_logic;
			response_read: out std_logic
		);
	end component;
	component MappedMemoriesEA is
		port (
			clk_switch: in std_logic;
			rst_switch: in std_logic;
			FROM_SWITCH_SOP_N: in std_logic;
			FROM_SWITCH_EOP_N: in std_logic;
			FROM_SWITCH_SRC_RDY_N: in std_logic;
			FROM_SWITCH_DATA: in std_logic_vector(31 downto 0);
			TO_SWITCH_DST_RDY_N: in std_logic;
			ea_finished: in std_logic;
			FROM_EA_SOP_N: in std_logic;
			FROM_EA_EOP_N: in std_logic;
			FROM_EA_SRC_RDY_N: in std_logic;
			FROM_EA_DATA: in std_logic_vector(31 downto 0);
			TO_EA_DST_RDY_N: in std_logic;
			FROM_SWITCH_DST_RDY_N: out std_logic;
			TO_SWITCH_SOP_N: out std_logic;
			TO_SWITCH_EOP_N: out std_logic;
			TO_SWITCH_SRC_RDY_N: out std_logic;
			TO_SWITCH_DATA: out std_logic_vector(31 downto 0);
			ea_start: out std_logic;
			FROM_EA_DST_RDY_N: out std_logic;
			TO_EA_SOP_N: out std_logic;
			TO_EA_EOP_N: out std_logic;
			TO_EA_SRC_RDY_N: out std_logic;
			TO_EA_DATA: out std_logic_vector(31 downto 0);
			memory_id: out std_logic_vector(15 downto 0);
			reserved_0: out std_logic_vector(12 downto 0);
			assert_stop: out std_logic;
			w_nr: out std_logic;
			is_response_header: out std_logic;
			base_address: out std_logic_vector(15 downto 0);
			last_read_address: out std_logic_vector(15 downto 0)
		);
	end component;
	component mapped_memories_adapter is
		generic (
			REQUEST_STROBE_DELAY : integer;
			DATA_WIDTH : integer;
			ADDRESS_WIDTH : integer;
			MULTI_CYCLE : boolean
		);
		port (
			clk_memory: in std_logic;
			rst_memory: in std_logic;
			request_empty: in std_logic;
			request_mem_data_in: in std_logic_vector(35 downto 0);
			request_mem_id: in std_logic_vector(15 downto 0);
			request_mem_memaddr: in std_logic_vector(15 downto 0);
			request_mem_wren: in std_logic;
			request_mem_rden: in std_logic;
			request_mem_stop: in std_logic;
			response_full: in std_logic;
			memories_data_out: in std_logic_vector(35 downto 0);
			memories_ack: in std_logic;
			request_read: out std_logic;
			response_write: out std_logic;
			response_mem_data_out: out std_logic_vector(35 downto 0);
			memories_data_in: out std_logic_vector(35 downto 0);
			memories_memid: out std_logic_vector(15 downto 0);
			memories_memaddr: out std_logic_vector(15 downto 0);
			memories_wren: out std_logic;
			memories_rden: out std_logic;
			memories_stop: out std_logic
		);
	end component;
	component AlteraFifoEntity_71_512_71_dualclock_aclr is
		port (
			wr_clk: in std_logic;
			rd_clk: in std_logic;
			din: in std_logic_vector(70 downto 0);
			wr_en: in std_logic;
			rd_en: in std_logic;
			rst: in std_logic;
			dout: out std_logic_vector(70 downto 0);
			full: out std_logic;
			empty: out std_logic
		);
	end component;
	component AlteraFifoEntity_36_512_36_dualclock_aclr is
		port (
			wr_clk: in std_logic;
			rd_clk: in std_logic;
			din: in std_logic_vector(35 downto 0);
			wr_en: in std_logic;
			rd_en: in std_logic;
			rst: in std_logic;
			dout: out std_logic_vector(35 downto 0);
			full: out std_logic;
			empty: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal mappedmemoriescontrollercoreexternal_i_controller_finished : std_logic_vector(0 downto 0);
	signal mappedmemoriescontrollercoreexternal_i_write_port_dst_rdy_n : std_logic_vector(0 downto 0);
	signal mappedmemoriescontrollercoreexternal_i_read_port_sop_n : std_logic_vector(0 downto 0);
	signal mappedmemoriescontrollercoreexternal_i_read_port_eop_n : std_logic_vector(0 downto 0);
	signal mappedmemoriescontrollercoreexternal_i_read_port_src_rdy_n : std_logic_vector(0 downto 0);
	signal mappedmemoriescontrollercoreexternal_i_read_port_data : std_logic_vector(31 downto 0);
	signal mappedmemoriescontrollercoreexternal_i_request_write : std_logic_vector(0 downto 0);
	signal mappedmemoriescontrollercoreexternal_i_request_mem_data_in : std_logic_vector(35 downto 0);
	signal mappedmemoriescontrollercoreexternal_i_request_mem_id : std_logic_vector(15 downto 0);
	signal mappedmemoriescontrollercoreexternal_i_request_mem_memaddr : std_logic_vector(15 downto 0);
	signal mappedmemoriescontrollercoreexternal_i_request_mem_wren : std_logic_vector(0 downto 0);
	signal mappedmemoriescontrollercoreexternal_i_request_mem_rden : std_logic_vector(0 downto 0);
	signal mappedmemoriescontrollercoreexternal_i_request_mem_stop : std_logic_vector(0 downto 0);
	signal mappedmemoriescontrollercoreexternal_i_response_read : std_logic_vector(0 downto 0);
	signal mappedmemoriesea_i_from_switch_dst_rdy_n : std_logic_vector(0 downto 0);
	signal mappedmemoriesea_i_to_switch_sop_n : std_logic_vector(0 downto 0);
	signal mappedmemoriesea_i_to_switch_eop_n : std_logic_vector(0 downto 0);
	signal mappedmemoriesea_i_to_switch_src_rdy_n : std_logic_vector(0 downto 0);
	signal mappedmemoriesea_i_to_switch_data : std_logic_vector(31 downto 0);
	signal mappedmemoriesea_i_ea_start : std_logic_vector(0 downto 0);
	signal mappedmemoriesea_i_from_ea_dst_rdy_n : std_logic_vector(0 downto 0);
	signal mappedmemoriesea_i_to_ea_sop_n : std_logic_vector(0 downto 0);
	signal mappedmemoriesea_i_to_ea_eop_n : std_logic_vector(0 downto 0);
	signal mappedmemoriesea_i_to_ea_src_rdy_n : std_logic_vector(0 downto 0);
	signal mappedmemoriesea_i_to_ea_data : std_logic_vector(31 downto 0);
	signal mappedmemoriesea_i_memory_id : std_logic_vector(15 downto 0);
	signal mappedmemoriesea_i_reserved_0 : std_logic_vector(12 downto 0);
	signal mappedmemoriesea_i_assert_stop : std_logic_vector(0 downto 0);
	signal mappedmemoriesea_i_w_nr : std_logic_vector(0 downto 0);
	signal mappedmemoriesea_i_is_response_header : std_logic_vector(0 downto 0);
	signal mappedmemoriesea_i_base_address : std_logic_vector(15 downto 0);
	signal mappedmemoriesea_i_last_read_address : std_logic_vector(15 downto 0);
	signal mapped_memories_domain_adapter_drp_request_read : std_logic_vector(0 downto 0);
	signal mapped_memories_domain_adapter_drp_response_write : std_logic_vector(0 downto 0);
	signal mapped_memories_domain_adapter_drp_response_mem_data_out : std_logic_vector(35 downto 0);
	signal mapped_memories_domain_adapter_drp_memories_data_in : std_logic_vector(35 downto 0);
	signal mapped_memories_domain_adapter_drp_memories_memid : std_logic_vector(15 downto 0);
	signal mapped_memories_domain_adapter_drp_memories_memaddr : std_logic_vector(15 downto 0);
	signal mapped_memories_domain_adapter_drp_memories_wren : std_logic_vector(0 downto 0);
	signal mapped_memories_domain_adapter_drp_memories_rden : std_logic_vector(0 downto 0);
	signal mapped_memories_domain_adapter_drp_memories_stop : std_logic_vector(0 downto 0);
	signal request_fifo_drp_dout : std_logic_vector(70 downto 0);
	signal request_fifo_drp_full : std_logic_vector(0 downto 0);
	signal request_fifo_drp_empty : std_logic_vector(0 downto 0);
	signal response_fifo_drp_dout : std_logic_vector(35 downto 0);
	signal response_fifo_drp_full : std_logic_vector(0 downto 0);
	signal response_fifo_drp_empty : std_logic_vector(0 downto 0);
	signal mapped_memories_domain_adapter_stream_request_read : std_logic_vector(0 downto 0);
	signal mapped_memories_domain_adapter_stream_response_write : std_logic_vector(0 downto 0);
	signal mapped_memories_domain_adapter_stream_response_mem_data_out : std_logic_vector(35 downto 0);
	signal mapped_memories_domain_adapter_stream_memories_data_in : std_logic_vector(35 downto 0);
	signal mapped_memories_domain_adapter_stream_memories_memid : std_logic_vector(15 downto 0);
	signal mapped_memories_domain_adapter_stream_memories_memaddr : std_logic_vector(15 downto 0);
	signal mapped_memories_domain_adapter_stream_memories_wren : std_logic_vector(0 downto 0);
	signal mapped_memories_domain_adapter_stream_memories_rden : std_logic_vector(0 downto 0);
	signal mapped_memories_domain_adapter_stream_memories_stop : std_logic_vector(0 downto 0);
	signal request_fifo_stream_dout : std_logic_vector(70 downto 0);
	signal request_fifo_stream_full : std_logic_vector(0 downto 0);
	signal request_fifo_stream_empty : std_logic_vector(0 downto 0);
	signal response_fifo_stream_dout : std_logic_vector(35 downto 0);
	signal response_fifo_stream_full : std_logic_vector(0 downto 0);
	signal response_fifo_stream_empty : std_logic_vector(0 downto 0);
	signal mappedmemoriescontrollercoreexternal_i_request_full1 : std_logic_vector(0 downto 0);
	signal mappedmemoriescontrollercoreexternal_i_response_empty1 : std_logic_vector(0 downto 0);
	signal mappedmemoriescontrollercoreexternal_i_response_mem_data_out1 : std_logic_vector(35 downto 0);
	signal muxsel_ln246_mappedmemoriescontroller1 : std_logic_vector(0 downto 0);
	signal drp_response_empty_r : std_logic_vector(0 downto 0) := "1";
	signal muxout_ln246_mappedmemoriescontroller : std_logic_vector(35 downto 0);
	signal muxsel_ln246_mappedmemoriescontroller2_1 : std_logic_vector(0 downto 0);
	signal STREAM_response_empty_r : std_logic_vector(0 downto 0) := "1";
	signal muxout_ln246_mappedmemoriescontroller1 : std_logic_vector(35 downto 0);
	signal mapped_memories_domain_adapter_drp_request_mem_data_in1 : std_logic_vector(35 downto 0);
	signal mapped_memories_domain_adapter_drp_request_mem_id1 : std_logic_vector(15 downto 0);
	signal mapped_memories_domain_adapter_drp_request_mem_memaddr1 : std_logic_vector(15 downto 0);
	signal mapped_memories_domain_adapter_drp_request_mem_wren1 : std_logic_vector(0 downto 0);
	signal mapped_memories_domain_adapter_drp_request_mem_rden1 : std_logic_vector(0 downto 0);
	signal mapped_memories_domain_adapter_drp_request_mem_stop1 : std_logic_vector(0 downto 0);
	signal request_fifo_drp_din1 : std_logic_vector(70 downto 0);
	signal cat_ln167_mappedmemoriescontroller : std_logic_vector(70 downto 0);
	signal mapped_memories_domain_adapter_stream_request_mem_data_in1 : std_logic_vector(35 downto 0);
	signal mapped_memories_domain_adapter_stream_request_mem_id1 : std_logic_vector(15 downto 0);
	signal mapped_memories_domain_adapter_stream_request_mem_memaddr1 : std_logic_vector(15 downto 0);
	signal mapped_memories_domain_adapter_stream_request_mem_wren1 : std_logic_vector(0 downto 0);
	signal mapped_memories_domain_adapter_stream_request_mem_rden1 : std_logic_vector(0 downto 0);
	signal mapped_memories_domain_adapter_stream_request_mem_stop1 : std_logic_vector(0 downto 0);
	signal request_fifo_stream_din1 : std_logic_vector(70 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	mappedmemoriescontrollercoreexternal_i_request_full1 <= (request_fifo_drp_full or request_fifo_stream_full);
	mappedmemoriescontrollercoreexternal_i_response_empty1 <= (response_fifo_drp_empty and response_fifo_stream_empty);
	muxsel_ln246_mappedmemoriescontroller1 <= drp_response_empty_r;
	muxproc_ln246_mappedmemoriescontroller : process(response_fifo_drp_dout, muxsel_ln246_mappedmemoriescontroller1)
	begin
		case muxsel_ln246_mappedmemoriescontroller1 is
			when "0" => muxout_ln246_mappedmemoriescontroller <= response_fifo_drp_dout;
			when "1" => muxout_ln246_mappedmemoriescontroller <= "000000000000000000000000000000000000";
			when others => 
			muxout_ln246_mappedmemoriescontroller <= (others => 'X');
		end case;
	end process;
	muxsel_ln246_mappedmemoriescontroller2_1 <= STREAM_response_empty_r;
	muxproc_ln246_mappedmemoriescontroller1 : process(response_fifo_stream_dout, muxsel_ln246_mappedmemoriescontroller2_1)
	begin
		case muxsel_ln246_mappedmemoriescontroller2_1 is
			when "0" => muxout_ln246_mappedmemoriescontroller1 <= response_fifo_stream_dout;
			when "1" => muxout_ln246_mappedmemoriescontroller1 <= "000000000000000000000000000000000000";
			when others => 
			muxout_ln246_mappedmemoriescontroller1 <= (others => 'X');
		end case;
	end process;
	mappedmemoriescontrollercoreexternal_i_response_mem_data_out1 <= (muxout_ln246_mappedmemoriescontroller or muxout_ln246_mappedmemoriescontroller1);
	mapped_memories_domain_adapter_drp_request_mem_data_in1 <= slice(request_fifo_drp_dout, 35, 36);
	mapped_memories_domain_adapter_drp_request_mem_id1 <= slice(request_fifo_drp_dout, 19, 16);
	mapped_memories_domain_adapter_drp_request_mem_memaddr1 <= slice(request_fifo_drp_dout, 3, 16);
	mapped_memories_domain_adapter_drp_request_mem_wren1 <= slice(request_fifo_drp_dout, 2, 1);
	mapped_memories_domain_adapter_drp_request_mem_rden1 <= slice(request_fifo_drp_dout, 1, 1);
	mapped_memories_domain_adapter_drp_request_mem_stop1 <= slice(request_fifo_drp_dout, 0, 1);
	cat_ln167_mappedmemoriescontroller<=(mappedmemoriescontrollercoreexternal_i_request_mem_data_in & mappedmemoriescontrollercoreexternal_i_request_mem_id & mappedmemoriescontrollercoreexternal_i_request_mem_memaddr & mappedmemoriescontrollercoreexternal_i_request_mem_wren & mappedmemoriescontrollercoreexternal_i_request_mem_rden & mappedmemoriescontrollercoreexternal_i_request_mem_stop);
	request_fifo_drp_din1 <= cat_ln167_mappedmemoriescontroller;
	mapped_memories_domain_adapter_stream_request_mem_data_in1 <= slice(request_fifo_stream_dout, 35, 36);
	mapped_memories_domain_adapter_stream_request_mem_id1 <= slice(request_fifo_stream_dout, 19, 16);
	mapped_memories_domain_adapter_stream_request_mem_memaddr1 <= slice(request_fifo_stream_dout, 3, 16);
	mapped_memories_domain_adapter_stream_request_mem_wren1 <= slice(request_fifo_stream_dout, 2, 1);
	mapped_memories_domain_adapter_stream_request_mem_rden1 <= slice(request_fifo_stream_dout, 1, 1);
	mapped_memories_domain_adapter_stream_request_mem_stop1 <= slice(request_fifo_stream_dout, 0, 1);
	request_fifo_stream_din1 <= cat_ln167_mappedmemoriescontroller;
	FROM_SWITCH_DST_RDY_N <= vec_to_bit(mappedmemoriesea_i_from_switch_dst_rdy_n);
	TO_SWITCH_SOP_N <= vec_to_bit(mappedmemoriesea_i_to_switch_sop_n);
	TO_SWITCH_EOP_N <= vec_to_bit(mappedmemoriesea_i_to_switch_eop_n);
	TO_SWITCH_SRC_RDY_N <= vec_to_bit(mappedmemoriesea_i_to_switch_src_rdy_n);
	TO_SWITCH_DATA <= mappedmemoriesea_i_to_switch_data;
	domain0_drp_memories_memories_data_in <= mapped_memories_domain_adapter_drp_memories_data_in;
	domain0_drp_memories_memories_memid <= mapped_memories_domain_adapter_drp_memories_memid;
	domain0_drp_memories_memories_memaddr <= mapped_memories_domain_adapter_drp_memories_memaddr;
	domain0_drp_memories_memories_wren <= vec_to_bit(mapped_memories_domain_adapter_drp_memories_wren);
	domain0_drp_memories_memories_rden <= vec_to_bit(mapped_memories_domain_adapter_drp_memories_rden);
	domain0_drp_memories_memories_stop <= vec_to_bit(mapped_memories_domain_adapter_drp_memories_stop);
	domain1_STREAM_memories_memories_data_in <= mapped_memories_domain_adapter_stream_memories_data_in;
	domain1_STREAM_memories_memories_memid <= mapped_memories_domain_adapter_stream_memories_memid;
	domain1_STREAM_memories_memories_memaddr <= mapped_memories_domain_adapter_stream_memories_memaddr;
	domain1_STREAM_memories_memories_wren <= vec_to_bit(mapped_memories_domain_adapter_stream_memories_wren);
	domain1_STREAM_memories_memories_rden <= vec_to_bit(mapped_memories_domain_adapter_stream_memories_rden);
	domain1_STREAM_memories_memories_stop <= vec_to_bit(mapped_memories_domain_adapter_stream_memories_stop);
	
	-- Register processes
	
	reg_process : process(clk_switch)
	begin
		if rising_edge(clk_switch) then
			if slv_to_slv(bit_to_vec(rst_switch)) = "1" then
				drp_response_empty_r <= "1";
			else
				drp_response_empty_r <= response_fifo_drp_empty;
			end if;
			if slv_to_slv(bit_to_vec(rst_switch)) = "1" then
				STREAM_response_empty_r <= "1";
			else
				STREAM_response_empty_r <= response_fifo_stream_empty;
			end if;
		end if;
	end process;
	
	-- Entity instances
	
	MappedMemoriesControllerCoreExternal_i : mapped_memories_controller_core
		generic map (
			MEM_ID_WIDTH => 16,
			ADDRESS_WIDTH => 16,
			DATA_WIDTH => 36,
			SWITCH_DATA_WIDTH => 32
		)
		port map (
			controller_finished => mappedmemoriescontrollercoreexternal_i_controller_finished(0), -- 1 bits (out)
			WRITE_PORT_DST_RDY_N => mappedmemoriescontrollercoreexternal_i_write_port_dst_rdy_n(0), -- 1 bits (out)
			READ_PORT_SOP_N => mappedmemoriescontrollercoreexternal_i_read_port_sop_n(0), -- 1 bits (out)
			READ_PORT_EOP_N => mappedmemoriescontrollercoreexternal_i_read_port_eop_n(0), -- 1 bits (out)
			READ_PORT_SRC_RDY_N => mappedmemoriescontrollercoreexternal_i_read_port_src_rdy_n(0), -- 1 bits (out)
			READ_PORT_DATA => mappedmemoriescontrollercoreexternal_i_read_port_data, -- 32 bits (out)
			request_write => mappedmemoriescontrollercoreexternal_i_request_write(0), -- 1 bits (out)
			request_mem_data_in => mappedmemoriescontrollercoreexternal_i_request_mem_data_in, -- 36 bits (out)
			request_mem_id => mappedmemoriescontrollercoreexternal_i_request_mem_id, -- 16 bits (out)
			request_mem_memaddr => mappedmemoriescontrollercoreexternal_i_request_mem_memaddr, -- 16 bits (out)
			request_mem_wren => mappedmemoriescontrollercoreexternal_i_request_mem_wren(0), -- 1 bits (out)
			request_mem_rden => mappedmemoriescontrollercoreexternal_i_request_mem_rden(0), -- 1 bits (out)
			request_mem_stop => mappedmemoriescontrollercoreexternal_i_request_mem_stop(0), -- 1 bits (out)
			response_read => mappedmemoriescontrollercoreexternal_i_response_read(0), -- 1 bits (out)
			clk_switch => clk_switch, -- 1 bits (in)
			rst_switch => rst_switch, -- 1 bits (in)
			controller_start => vec_to_bit(mappedmemoriesea_i_ea_start), -- 1 bits (in)
			assert_stop => vec_to_bit(mappedmemoriesea_i_assert_stop), -- 1 bits (in)
			is_write => vec_to_bit(mappedmemoriesea_i_w_nr), -- 1 bits (in)
			memory_id => mappedmemoriesea_i_memory_id, -- 16 bits (in)
			base_address => mappedmemoriesea_i_base_address, -- 16 bits (in)
			last_read_address => mappedmemoriesea_i_last_read_address, -- 16 bits (in)
			WRITE_PORT_SOP_N => vec_to_bit(mappedmemoriesea_i_to_ea_sop_n), -- 1 bits (in)
			WRITE_PORT_EOP_N => vec_to_bit(mappedmemoriesea_i_to_ea_eop_n), -- 1 bits (in)
			WRITE_PORT_SRC_RDY_N => vec_to_bit(mappedmemoriesea_i_to_ea_src_rdy_n), -- 1 bits (in)
			WRITE_PORT_DATA => mappedmemoriesea_i_to_ea_data, -- 32 bits (in)
			READ_PORT_DST_RDY_N => vec_to_bit(mappedmemoriesea_i_from_ea_dst_rdy_n), -- 1 bits (in)
			request_full => vec_to_bit(mappedmemoriescontrollercoreexternal_i_request_full1), -- 1 bits (in)
			response_empty => vec_to_bit(mappedmemoriescontrollercoreexternal_i_response_empty1), -- 1 bits (in)
			response_mem_data_out => mappedmemoriescontrollercoreexternal_i_response_mem_data_out1 -- 36 bits (in)
		);
	MappedmemoriesEA_i : MappedMemoriesEA
		port map (
			FROM_SWITCH_DST_RDY_N => mappedmemoriesea_i_from_switch_dst_rdy_n(0), -- 1 bits (out)
			TO_SWITCH_SOP_N => mappedmemoriesea_i_to_switch_sop_n(0), -- 1 bits (out)
			TO_SWITCH_EOP_N => mappedmemoriesea_i_to_switch_eop_n(0), -- 1 bits (out)
			TO_SWITCH_SRC_RDY_N => mappedmemoriesea_i_to_switch_src_rdy_n(0), -- 1 bits (out)
			TO_SWITCH_DATA => mappedmemoriesea_i_to_switch_data, -- 32 bits (out)
			ea_start => mappedmemoriesea_i_ea_start(0), -- 1 bits (out)
			FROM_EA_DST_RDY_N => mappedmemoriesea_i_from_ea_dst_rdy_n(0), -- 1 bits (out)
			TO_EA_SOP_N => mappedmemoriesea_i_to_ea_sop_n(0), -- 1 bits (out)
			TO_EA_EOP_N => mappedmemoriesea_i_to_ea_eop_n(0), -- 1 bits (out)
			TO_EA_SRC_RDY_N => mappedmemoriesea_i_to_ea_src_rdy_n(0), -- 1 bits (out)
			TO_EA_DATA => mappedmemoriesea_i_to_ea_data, -- 32 bits (out)
			memory_id => mappedmemoriesea_i_memory_id, -- 16 bits (out)
			reserved_0 => mappedmemoriesea_i_reserved_0, -- 13 bits (out)
			assert_stop => mappedmemoriesea_i_assert_stop(0), -- 1 bits (out)
			w_nr => mappedmemoriesea_i_w_nr(0), -- 1 bits (out)
			is_response_header => mappedmemoriesea_i_is_response_header(0), -- 1 bits (out)
			base_address => mappedmemoriesea_i_base_address, -- 16 bits (out)
			last_read_address => mappedmemoriesea_i_last_read_address, -- 16 bits (out)
			clk_switch => clk_switch, -- 1 bits (in)
			rst_switch => rst_switch, -- 1 bits (in)
			FROM_SWITCH_SOP_N => FROM_SWITCH_SOP_N, -- 1 bits (in)
			FROM_SWITCH_EOP_N => FROM_SWITCH_EOP_N, -- 1 bits (in)
			FROM_SWITCH_SRC_RDY_N => FROM_SWITCH_SRC_RDY_N, -- 1 bits (in)
			FROM_SWITCH_DATA => FROM_SWITCH_DATA, -- 32 bits (in)
			TO_SWITCH_DST_RDY_N => TO_SWITCH_DST_RDY_N, -- 1 bits (in)
			ea_finished => vec_to_bit(mappedmemoriescontrollercoreexternal_i_controller_finished), -- 1 bits (in)
			FROM_EA_SOP_N => vec_to_bit(mappedmemoriescontrollercoreexternal_i_read_port_sop_n), -- 1 bits (in)
			FROM_EA_EOP_N => vec_to_bit(mappedmemoriescontrollercoreexternal_i_read_port_eop_n), -- 1 bits (in)
			FROM_EA_SRC_RDY_N => vec_to_bit(mappedmemoriescontrollercoreexternal_i_read_port_src_rdy_n), -- 1 bits (in)
			FROM_EA_DATA => mappedmemoriescontrollercoreexternal_i_read_port_data, -- 32 bits (in)
			TO_EA_DST_RDY_N => vec_to_bit(mappedmemoriescontrollercoreexternal_i_write_port_dst_rdy_n) -- 1 bits (in)
		);
	mapped_memories_domain_adapter_drp : mapped_memories_adapter
		generic map (
			REQUEST_STROBE_DELAY => 4,
			DATA_WIDTH => 36,
			ADDRESS_WIDTH => 16,
			MULTI_CYCLE => false
		)
		port map (
			request_read => mapped_memories_domain_adapter_drp_request_read(0), -- 1 bits (out)
			response_write => mapped_memories_domain_adapter_drp_response_write(0), -- 1 bits (out)
			response_mem_data_out => mapped_memories_domain_adapter_drp_response_mem_data_out, -- 36 bits (out)
			memories_data_in => mapped_memories_domain_adapter_drp_memories_data_in, -- 36 bits (out)
			memories_memid => mapped_memories_domain_adapter_drp_memories_memid, -- 16 bits (out)
			memories_memaddr => mapped_memories_domain_adapter_drp_memories_memaddr, -- 16 bits (out)
			memories_wren => mapped_memories_domain_adapter_drp_memories_wren(0), -- 1 bits (out)
			memories_rden => mapped_memories_domain_adapter_drp_memories_rden(0), -- 1 bits (out)
			memories_stop => mapped_memories_domain_adapter_drp_memories_stop(0), -- 1 bits (out)
			clk_memory => domain0_drp_clk, -- 1 bits (in)
			rst_memory => domain0_drp_rst, -- 1 bits (in)
			request_empty => vec_to_bit(request_fifo_drp_empty), -- 1 bits (in)
			request_mem_data_in => mapped_memories_domain_adapter_drp_request_mem_data_in1, -- 36 bits (in)
			request_mem_id => mapped_memories_domain_adapter_drp_request_mem_id1, -- 16 bits (in)
			request_mem_memaddr => mapped_memories_domain_adapter_drp_request_mem_memaddr1, -- 16 bits (in)
			request_mem_wren => vec_to_bit(mapped_memories_domain_adapter_drp_request_mem_wren1), -- 1 bits (in)
			request_mem_rden => vec_to_bit(mapped_memories_domain_adapter_drp_request_mem_rden1), -- 1 bits (in)
			request_mem_stop => vec_to_bit(mapped_memories_domain_adapter_drp_request_mem_stop1), -- 1 bits (in)
			response_full => vec_to_bit(response_fifo_drp_full), -- 1 bits (in)
			memories_data_out => domain0_drp_memories_memories_data_out, -- 36 bits (in)
			memories_ack => domain0_drp_memories_memories_ack -- 1 bits (in)
		);
	request_fifo_drp : AlteraFifoEntity_71_512_71_dualclock_aclr
		port map (
			dout => request_fifo_drp_dout, -- 71 bits (out)
			full => request_fifo_drp_full(0), -- 1 bits (out)
			empty => request_fifo_drp_empty(0), -- 1 bits (out)
			wr_clk => clk_switch, -- 1 bits (in)
			rd_clk => domain0_drp_clk, -- 1 bits (in)
			din => request_fifo_drp_din1, -- 71 bits (in)
			wr_en => vec_to_bit(mappedmemoriescontrollercoreexternal_i_request_write), -- 1 bits (in)
			rd_en => vec_to_bit(mapped_memories_domain_adapter_drp_request_read), -- 1 bits (in)
			rst => domain0_drp_rst -- 1 bits (in)
		);
	response_fifo_drp : AlteraFifoEntity_36_512_36_dualclock_aclr
		port map (
			dout => response_fifo_drp_dout, -- 36 bits (out)
			full => response_fifo_drp_full(0), -- 1 bits (out)
			empty => response_fifo_drp_empty(0), -- 1 bits (out)
			wr_clk => domain0_drp_clk, -- 1 bits (in)
			rd_clk => clk_switch, -- 1 bits (in)
			din => mapped_memories_domain_adapter_drp_response_mem_data_out, -- 36 bits (in)
			wr_en => vec_to_bit(mapped_memories_domain_adapter_drp_response_write), -- 1 bits (in)
			rd_en => vec_to_bit(mappedmemoriescontrollercoreexternal_i_response_read), -- 1 bits (in)
			rst => domain0_drp_rst -- 1 bits (in)
		);
	mapped_memories_domain_adapter_STREAM : mapped_memories_adapter
		generic map (
			REQUEST_STROBE_DELAY => 4,
			DATA_WIDTH => 36,
			ADDRESS_WIDTH => 16,
			MULTI_CYCLE => false
		)
		port map (
			request_read => mapped_memories_domain_adapter_stream_request_read(0), -- 1 bits (out)
			response_write => mapped_memories_domain_adapter_stream_response_write(0), -- 1 bits (out)
			response_mem_data_out => mapped_memories_domain_adapter_stream_response_mem_data_out, -- 36 bits (out)
			memories_data_in => mapped_memories_domain_adapter_stream_memories_data_in, -- 36 bits (out)
			memories_memid => mapped_memories_domain_adapter_stream_memories_memid, -- 16 bits (out)
			memories_memaddr => mapped_memories_domain_adapter_stream_memories_memaddr, -- 16 bits (out)
			memories_wren => mapped_memories_domain_adapter_stream_memories_wren(0), -- 1 bits (out)
			memories_rden => mapped_memories_domain_adapter_stream_memories_rden(0), -- 1 bits (out)
			memories_stop => mapped_memories_domain_adapter_stream_memories_stop(0), -- 1 bits (out)
			clk_memory => domain1_STREAM_clk, -- 1 bits (in)
			rst_memory => domain1_STREAM_rst, -- 1 bits (in)
			request_empty => vec_to_bit(request_fifo_stream_empty), -- 1 bits (in)
			request_mem_data_in => mapped_memories_domain_adapter_stream_request_mem_data_in1, -- 36 bits (in)
			request_mem_id => mapped_memories_domain_adapter_stream_request_mem_id1, -- 16 bits (in)
			request_mem_memaddr => mapped_memories_domain_adapter_stream_request_mem_memaddr1, -- 16 bits (in)
			request_mem_wren => vec_to_bit(mapped_memories_domain_adapter_stream_request_mem_wren1), -- 1 bits (in)
			request_mem_rden => vec_to_bit(mapped_memories_domain_adapter_stream_request_mem_rden1), -- 1 bits (in)
			request_mem_stop => vec_to_bit(mapped_memories_domain_adapter_stream_request_mem_stop1), -- 1 bits (in)
			response_full => vec_to_bit(response_fifo_stream_full), -- 1 bits (in)
			memories_data_out => domain1_STREAM_memories_memories_data_out, -- 36 bits (in)
			memories_ack => domain1_STREAM_memories_memories_ack -- 1 bits (in)
		);
	request_fifo_STREAM : AlteraFifoEntity_71_512_71_dualclock_aclr
		port map (
			dout => request_fifo_stream_dout, -- 71 bits (out)
			full => request_fifo_stream_full(0), -- 1 bits (out)
			empty => request_fifo_stream_empty(0), -- 1 bits (out)
			wr_clk => clk_switch, -- 1 bits (in)
			rd_clk => domain1_STREAM_clk, -- 1 bits (in)
			din => request_fifo_stream_din1, -- 71 bits (in)
			wr_en => vec_to_bit(mappedmemoriescontrollercoreexternal_i_request_write), -- 1 bits (in)
			rd_en => vec_to_bit(mapped_memories_domain_adapter_stream_request_read), -- 1 bits (in)
			rst => domain1_STREAM_rst -- 1 bits (in)
		);
	response_fifo_STREAM : AlteraFifoEntity_36_512_36_dualclock_aclr
		port map (
			dout => response_fifo_stream_dout, -- 36 bits (out)
			full => response_fifo_stream_full(0), -- 1 bits (out)
			empty => response_fifo_stream_empty(0), -- 1 bits (out)
			wr_clk => domain1_STREAM_clk, -- 1 bits (in)
			rd_clk => clk_switch, -- 1 bits (in)
			din => mapped_memories_domain_adapter_stream_response_mem_data_out, -- 36 bits (in)
			wr_en => vec_to_bit(mapped_memories_domain_adapter_stream_response_write), -- 1 bits (in)
			rd_en => vec_to_bit(mappedmemoriescontrollercoreexternal_i_response_read), -- 1 bits (in)
			rst => domain1_STREAM_rst -- 1 bits (in)
		);
end MaxDC;
