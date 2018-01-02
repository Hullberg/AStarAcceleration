library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity Manager_CpuStream is
	port (
		child_0_valid: in std_logic;
		child_0_done: in std_logic;
		child_0_data: in std_logic_vector(127 downto 0);
		child_1_valid: in std_logic;
		child_1_done: in std_logic;
		child_1_data: in std_logic_vector(127 downto 0);
		child_2_valid: in std_logic;
		child_2_done: in std_logic;
		child_2_data: in std_logic_vector(127 downto 0);
		child_3_valid: in std_logic;
		child_3_done: in std_logic;
		child_3_data: in std_logic_vector(127 downto 0);
		data_w_stall: in std_logic;
		STREAM: in std_logic;
		STREAM_NOBUF: in std_logic;
		STREAM_RST: in std_logic;
		STREAM_RST_DELAY: in std_logic;
		PCIE: in std_logic;
		PCIE_NOBUF: in std_logic;
		PCIE_RST: in std_logic;
		PCIE_RST_DELAY: in std_logic;
		mapped_reg_io_CpuStreamKernel_0_register_clk: in std_logic;
		mapped_reg_io_CpuStreamKernel_0_register_in: in std_logic_vector(7 downto 0);
		mapped_reg_io_CpuStreamKernel_0_register_rotate: in std_logic;
		mapped_reg_io_CpuStreamKernel_0_register_stop: in std_logic;
		mapped_reg_io_CpuStreamKernel_0_register_switch: in std_logic;
		toggle: in std_logic;
		partial_reconfig: in std_logic;
		child_0_stall: out std_logic;
		child_1_stall: out std_logic;
		child_2_stall: out std_logic;
		child_3_stall: out std_logic;
		data_w_valid: out std_logic;
		data_w_done: out std_logic;
		data_w_data: out std_logic_vector(127 downto 0);
		mapped_reg_io_CpuStreamKernel_0_register_out: out std_logic_vector(7 downto 0);
		toggle_ack: out std_logic;
		active: out std_logic
	);
end Manager_CpuStream;

architecture MaxDC of Manager_CpuStream is
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
	component Manager_CpuStream_WrapperNodeEntity_CpuStreamKernel is
		port (
			child_0_almost_empty: in std_logic;
			child_0_empty: in std_logic;
			child_0_done: in std_logic;
			child_0_data: in std_logic_vector(31 downto 0);
			child_1_almost_empty: in std_logic;
			child_1_empty: in std_logic;
			child_1_done: in std_logic;
			child_1_data: in std_logic_vector(31 downto 0);
			child_2_almost_empty: in std_logic;
			child_2_empty: in std_logic;
			child_2_done: in std_logic;
			child_2_data: in std_logic_vector(31 downto 0);
			child_3_almost_empty: in std_logic;
			child_3_empty: in std_logic;
			child_3_done: in std_logic;
			child_3_data: in std_logic_vector(31 downto 0);
			data_w_stall: in std_logic;
			clk: in std_logic;
			clk_nobuf: in std_logic;
			clk_rst: in std_logic;
			register_clk: in std_logic;
			register_in: in std_logic_vector(7 downto 0);
			register_rotate: in std_logic;
			register_stop: in std_logic;
			register_switch: in std_logic;
			child_0_read: out std_logic;
			child_1_read: out std_logic;
			child_2_read: out std_logic;
			child_3_read: out std_logic;
			data_w_valid: out std_logic;
			data_w_done: out std_logic;
			data_w_data: out std_logic_vector(31 downto 0);
			active: out std_logic;
			register_out: out std_logic_vector(7 downto 0)
		);
	end component;
	component WrapperNodeIO_child_0 is
		port (
			child_0_stall: in std_logic;
			external_valid: in std_logic;
			external_done: in std_logic;
			external_data: in std_logic_vector(127 downto 0);
			child_0_valid: out std_logic;
			child_0_done: out std_logic;
			child_0_data: out std_logic_vector(127 downto 0);
			external_stall: out std_logic
		);
	end component;
	component WrapperNodeIO_child_1 is
		port (
			child_1_stall: in std_logic;
			external_valid: in std_logic;
			external_done: in std_logic;
			external_data: in std_logic_vector(127 downto 0);
			child_1_valid: out std_logic;
			child_1_done: out std_logic;
			child_1_data: out std_logic_vector(127 downto 0);
			external_stall: out std_logic
		);
	end component;
	component WrapperNodeIO_child_2 is
		port (
			child_2_stall: in std_logic;
			external_valid: in std_logic;
			external_done: in std_logic;
			external_data: in std_logic_vector(127 downto 0);
			child_2_valid: out std_logic;
			child_2_done: out std_logic;
			child_2_data: out std_logic_vector(127 downto 0);
			external_stall: out std_logic
		);
	end component;
	component WrapperNodeIO_child_3 is
		port (
			child_3_stall: in std_logic;
			external_valid: in std_logic;
			external_done: in std_logic;
			external_data: in std_logic_vector(127 downto 0);
			child_3_valid: out std_logic;
			child_3_done: out std_logic;
			child_3_data: out std_logic_vector(127 downto 0);
			external_stall: out std_logic
		);
	end component;
	component WrapperNodeIO_data_w is
		port (
			data_w_valid: in std_logic;
			data_w_done: in std_logic;
			data_w_data: in std_logic_vector(127 downto 0);
			external_stall: in std_logic;
			data_w_stall: out std_logic;
			external_valid: out std_logic;
			external_done: out std_logic;
			external_data: out std_logic_vector(127 downto 0)
		);
	end component;
	component Manager_CpuStream_WrapperNodeEntity_Stream_1 is
		port (
			input_empty: in std_logic;
			input_done: in std_logic;
			input_data: in std_logic_vector(127 downto 0);
			output_stall: in std_logic;
			da_clk: in std_logic;
			da_clk_nobuf: in std_logic;
			da_clk_rst: in std_logic;
			input_read: out std_logic;
			output_valid: out std_logic;
			output_done: out std_logic;
			output_data: out std_logic_vector(31 downto 0)
		);
	end component;
	component Manager_CpuStream_WrapperNodeEntity_Stream_4 is
		port (
			input_empty: in std_logic;
			input_done: in std_logic;
			input_data: in std_logic_vector(127 downto 0);
			output_stall: in std_logic;
			da_clk: in std_logic;
			da_clk_nobuf: in std_logic;
			da_clk_rst: in std_logic;
			input_read: out std_logic;
			output_valid: out std_logic;
			output_done: out std_logic;
			output_data: out std_logic_vector(31 downto 0)
		);
	end component;
	component Manager_CpuStream_WrapperNodeEntity_Stream_7 is
		port (
			input_empty: in std_logic;
			input_done: in std_logic;
			input_data: in std_logic_vector(127 downto 0);
			output_stall: in std_logic;
			da_clk: in std_logic;
			da_clk_nobuf: in std_logic;
			da_clk_rst: in std_logic;
			input_read: out std_logic;
			output_valid: out std_logic;
			output_done: out std_logic;
			output_data: out std_logic_vector(31 downto 0)
		);
	end component;
	component Manager_CpuStream_WrapperNodeEntity_Stream_10 is
		port (
			input_empty: in std_logic;
			input_done: in std_logic;
			input_data: in std_logic_vector(127 downto 0);
			output_stall: in std_logic;
			da_clk: in std_logic;
			da_clk_nobuf: in std_logic;
			da_clk_rst: in std_logic;
			input_read: out std_logic;
			output_valid: out std_logic;
			output_done: out std_logic;
			output_data: out std_logic_vector(31 downto 0)
		);
	end component;
	component Manager_CpuStream_WrapperNodeEntity_Stream_14 is
		port (
			input_empty: in std_logic;
			input_done: in std_logic;
			input_data: in std_logic_vector(31 downto 0);
			output_read: in std_logic;
			da_clk: in std_logic;
			da_clk_nobuf: in std_logic;
			da_clk_rst: in std_logic;
			input_read: out std_logic;
			output_empty: out std_logic;
			output_done: out std_logic;
			output_data: out std_logic_vector(127 downto 0)
		);
	end component;
	component Manager_CpuStream_WrapperNodeEntity_Stream_35 is
		port (
			input_empty: in std_logic;
			input_done: in std_logic;
			input_data: in std_logic_vector(127 downto 0);
			output_stall: in std_logic;
			pullpush_clk: in std_logic;
			pullpush_clk_nobuf: in std_logic;
			pullpush_clk_rst: in std_logic;
			input_read: out std_logic;
			output_valid: out std_logic;
			output_done: out std_logic;
			output_data: out std_logic_vector(127 downto 0)
		);
	end component;
	component Manager_CpuStream_WrapperNodeEntity_Stream_17 is
		port (
			input_valid: in std_logic;
			input_done: in std_logic;
			input_data: in std_logic_vector(127 downto 0);
			output_read: in std_logic;
			input_clk: in std_logic;
			input_clk_nobuf: in std_logic;
			input_clk_rst: in std_logic;
			input_clk_rst_delay: in std_logic;
			output_clk: in std_logic;
			output_clk_nobuf: in std_logic;
			output_clk_rst: in std_logic;
			input_stall: out std_logic;
			output_empty: out std_logic;
			output_done: out std_logic;
			output_data: out std_logic_vector(127 downto 0)
		);
	end component;
	component Manager_CpuStream_WrapperNodeEntity_Stream_21 is
		port (
			input_valid: in std_logic;
			input_done: in std_logic;
			input_data: in std_logic_vector(127 downto 0);
			output_read: in std_logic;
			input_clk: in std_logic;
			input_clk_nobuf: in std_logic;
			input_clk_rst: in std_logic;
			input_clk_rst_delay: in std_logic;
			output_clk: in std_logic;
			output_clk_nobuf: in std_logic;
			output_clk_rst: in std_logic;
			input_stall: out std_logic;
			output_empty: out std_logic;
			output_done: out std_logic;
			output_data: out std_logic_vector(127 downto 0)
		);
	end component;
	component Manager_CpuStream_WrapperNodeEntity_Stream_25 is
		port (
			input_valid: in std_logic;
			input_done: in std_logic;
			input_data: in std_logic_vector(127 downto 0);
			output_read: in std_logic;
			input_clk: in std_logic;
			input_clk_nobuf: in std_logic;
			input_clk_rst: in std_logic;
			input_clk_rst_delay: in std_logic;
			output_clk: in std_logic;
			output_clk_nobuf: in std_logic;
			output_clk_rst: in std_logic;
			input_stall: out std_logic;
			output_empty: out std_logic;
			output_done: out std_logic;
			output_data: out std_logic_vector(127 downto 0)
		);
	end component;
	component Manager_CpuStream_WrapperNodeEntity_Stream_29 is
		port (
			input_valid: in std_logic;
			input_done: in std_logic;
			input_data: in std_logic_vector(127 downto 0);
			output_read: in std_logic;
			input_clk: in std_logic;
			input_clk_nobuf: in std_logic;
			input_clk_rst: in std_logic;
			input_clk_rst_delay: in std_logic;
			output_clk: in std_logic;
			output_clk_nobuf: in std_logic;
			output_clk_rst: in std_logic;
			input_stall: out std_logic;
			output_empty: out std_logic;
			output_done: out std_logic;
			output_data: out std_logic_vector(127 downto 0)
		);
	end component;
	component Manager_CpuStream_WrapperNodeEntity_Stream_19 is
		port (
			input_valid: in std_logic;
			input_done: in std_logic;
			input_data: in std_logic_vector(31 downto 0);
			output_read: in std_logic;
			input_clk: in std_logic;
			input_clk_nobuf: in std_logic;
			input_clk_rst: in std_logic;
			output_clk: in std_logic;
			output_clk_nobuf: in std_logic;
			output_clk_rst: in std_logic;
			output_clk_rst_delay: in std_logic;
			input_stall: out std_logic;
			output_almost_empty: out std_logic;
			output_empty: out std_logic;
			output_done: out std_logic;
			output_data: out std_logic_vector(31 downto 0)
		);
	end component;
	component Manager_CpuStream_WrapperNodeEntity_Stream_23 is
		port (
			input_valid: in std_logic;
			input_done: in std_logic;
			input_data: in std_logic_vector(31 downto 0);
			output_read: in std_logic;
			input_clk: in std_logic;
			input_clk_nobuf: in std_logic;
			input_clk_rst: in std_logic;
			output_clk: in std_logic;
			output_clk_nobuf: in std_logic;
			output_clk_rst: in std_logic;
			output_clk_rst_delay: in std_logic;
			input_stall: out std_logic;
			output_almost_empty: out std_logic;
			output_empty: out std_logic;
			output_done: out std_logic;
			output_data: out std_logic_vector(31 downto 0)
		);
	end component;
	component Manager_CpuStream_WrapperNodeEntity_Stream_27 is
		port (
			input_valid: in std_logic;
			input_done: in std_logic;
			input_data: in std_logic_vector(31 downto 0);
			output_read: in std_logic;
			input_clk: in std_logic;
			input_clk_nobuf: in std_logic;
			input_clk_rst: in std_logic;
			output_clk: in std_logic;
			output_clk_nobuf: in std_logic;
			output_clk_rst: in std_logic;
			output_clk_rst_delay: in std_logic;
			input_stall: out std_logic;
			output_almost_empty: out std_logic;
			output_empty: out std_logic;
			output_done: out std_logic;
			output_data: out std_logic_vector(31 downto 0)
		);
	end component;
	component Manager_CpuStream_WrapperNodeEntity_Stream_31 is
		port (
			input_valid: in std_logic;
			input_done: in std_logic;
			input_data: in std_logic_vector(31 downto 0);
			output_read: in std_logic;
			input_clk: in std_logic;
			input_clk_nobuf: in std_logic;
			input_clk_rst: in std_logic;
			output_clk: in std_logic;
			output_clk_nobuf: in std_logic;
			output_clk_rst: in std_logic;
			output_clk_rst_delay: in std_logic;
			input_stall: out std_logic;
			output_almost_empty: out std_logic;
			output_empty: out std_logic;
			output_done: out std_logic;
			output_data: out std_logic_vector(31 downto 0)
		);
	end component;
	component Manager_CpuStream_WrapperNodeEntity_Stream_33 is
		port (
			input_valid: in std_logic;
			input_done: in std_logic;
			input_data: in std_logic_vector(31 downto 0);
			output_read: in std_logic;
			input_clk: in std_logic;
			input_clk_nobuf: in std_logic;
			input_clk_rst: in std_logic;
			input_clk_rst_delay: in std_logic;
			output_clk: in std_logic;
			output_clk_nobuf: in std_logic;
			output_clk_rst: in std_logic;
			input_stall: out std_logic;
			output_empty: out std_logic;
			output_done: out std_logic;
			output_data: out std_logic_vector(31 downto 0)
		);
	end component;
	
	-- Signal declarations
	
	signal cpustreamkernel_child_0_read : std_logic_vector(0 downto 0);
	signal cpustreamkernel_child_1_read : std_logic_vector(0 downto 0);
	signal cpustreamkernel_child_2_read : std_logic_vector(0 downto 0);
	signal cpustreamkernel_child_3_read : std_logic_vector(0 downto 0);
	signal cpustreamkernel_data_w_valid : std_logic_vector(0 downto 0);
	signal cpustreamkernel_data_w_done : std_logic_vector(0 downto 0);
	signal cpustreamkernel_data_w_data : std_logic_vector(31 downto 0);
	signal cpustreamkernel_active : std_logic_vector(0 downto 0);
	signal cpustreamkernel_register_out : std_logic_vector(7 downto 0);
	signal child_0_child_0_valid : std_logic_vector(0 downto 0);
	signal child_0_child_0_done : std_logic_vector(0 downto 0);
	signal child_0_child_0_data : std_logic_vector(127 downto 0);
	signal child_0_external_stall : std_logic_vector(0 downto 0);
	signal child_1_child_1_valid : std_logic_vector(0 downto 0);
	signal child_1_child_1_done : std_logic_vector(0 downto 0);
	signal child_1_child_1_data : std_logic_vector(127 downto 0);
	signal child_1_external_stall : std_logic_vector(0 downto 0);
	signal child_2_child_2_valid : std_logic_vector(0 downto 0);
	signal child_2_child_2_done : std_logic_vector(0 downto 0);
	signal child_2_child_2_data : std_logic_vector(127 downto 0);
	signal child_2_external_stall : std_logic_vector(0 downto 0);
	signal child_3_child_3_valid : std_logic_vector(0 downto 0);
	signal child_3_child_3_done : std_logic_vector(0 downto 0);
	signal child_3_child_3_data : std_logic_vector(127 downto 0);
	signal child_3_external_stall : std_logic_vector(0 downto 0);
	signal data_w_data_w_stall : std_logic_vector(0 downto 0);
	signal data_w_external_valid : std_logic_vector(0 downto 0);
	signal data_w_external_done : std_logic_vector(0 downto 0);
	signal data_w_external_data : std_logic_vector(127 downto 0);
	signal stream_1_input_read : std_logic_vector(0 downto 0);
	signal stream_1_output_valid : std_logic_vector(0 downto 0);
	signal stream_1_output_done : std_logic_vector(0 downto 0);
	signal stream_1_output_data : std_logic_vector(31 downto 0);
	signal stream_4_input_read : std_logic_vector(0 downto 0);
	signal stream_4_output_valid : std_logic_vector(0 downto 0);
	signal stream_4_output_done : std_logic_vector(0 downto 0);
	signal stream_4_output_data : std_logic_vector(31 downto 0);
	signal stream_7_input_read : std_logic_vector(0 downto 0);
	signal stream_7_output_valid : std_logic_vector(0 downto 0);
	signal stream_7_output_done : std_logic_vector(0 downto 0);
	signal stream_7_output_data : std_logic_vector(31 downto 0);
	signal stream_10_input_read : std_logic_vector(0 downto 0);
	signal stream_10_output_valid : std_logic_vector(0 downto 0);
	signal stream_10_output_done : std_logic_vector(0 downto 0);
	signal stream_10_output_data : std_logic_vector(31 downto 0);
	signal stream_14_input_read : std_logic_vector(0 downto 0);
	signal stream_14_output_empty : std_logic_vector(0 downto 0);
	signal stream_14_output_done : std_logic_vector(0 downto 0);
	signal stream_14_output_data : std_logic_vector(127 downto 0);
	signal stream_35_input_read : std_logic_vector(0 downto 0);
	signal stream_35_output_valid : std_logic_vector(0 downto 0);
	signal stream_35_output_done : std_logic_vector(0 downto 0);
	signal stream_35_output_data : std_logic_vector(127 downto 0);
	signal stream_17_input_stall : std_logic_vector(0 downto 0);
	signal stream_17_output_empty : std_logic_vector(0 downto 0);
	signal stream_17_output_done : std_logic_vector(0 downto 0);
	signal stream_17_output_data : std_logic_vector(127 downto 0);
	signal stream_21_input_stall : std_logic_vector(0 downto 0);
	signal stream_21_output_empty : std_logic_vector(0 downto 0);
	signal stream_21_output_done : std_logic_vector(0 downto 0);
	signal stream_21_output_data : std_logic_vector(127 downto 0);
	signal stream_25_input_stall : std_logic_vector(0 downto 0);
	signal stream_25_output_empty : std_logic_vector(0 downto 0);
	signal stream_25_output_done : std_logic_vector(0 downto 0);
	signal stream_25_output_data : std_logic_vector(127 downto 0);
	signal stream_29_input_stall : std_logic_vector(0 downto 0);
	signal stream_29_output_empty : std_logic_vector(0 downto 0);
	signal stream_29_output_done : std_logic_vector(0 downto 0);
	signal stream_29_output_data : std_logic_vector(127 downto 0);
	signal stream_19_input_stall : std_logic_vector(0 downto 0);
	signal stream_19_output_almost_empty : std_logic_vector(0 downto 0);
	signal stream_19_output_empty : std_logic_vector(0 downto 0);
	signal stream_19_output_done : std_logic_vector(0 downto 0);
	signal stream_19_output_data : std_logic_vector(31 downto 0);
	signal stream_23_input_stall : std_logic_vector(0 downto 0);
	signal stream_23_output_almost_empty : std_logic_vector(0 downto 0);
	signal stream_23_output_empty : std_logic_vector(0 downto 0);
	signal stream_23_output_done : std_logic_vector(0 downto 0);
	signal stream_23_output_data : std_logic_vector(31 downto 0);
	signal stream_27_input_stall : std_logic_vector(0 downto 0);
	signal stream_27_output_almost_empty : std_logic_vector(0 downto 0);
	signal stream_27_output_empty : std_logic_vector(0 downto 0);
	signal stream_27_output_done : std_logic_vector(0 downto 0);
	signal stream_27_output_data : std_logic_vector(31 downto 0);
	signal stream_31_input_stall : std_logic_vector(0 downto 0);
	signal stream_31_output_almost_empty : std_logic_vector(0 downto 0);
	signal stream_31_output_empty : std_logic_vector(0 downto 0);
	signal stream_31_output_done : std_logic_vector(0 downto 0);
	signal stream_31_output_data : std_logic_vector(31 downto 0);
	signal stream_33_input_stall : std_logic_vector(0 downto 0);
	signal stream_33_output_empty : std_logic_vector(0 downto 0);
	signal stream_33_output_done : std_logic_vector(0 downto 0);
	signal stream_33_output_data : std_logic_vector(31 downto 0);
	signal clk_reset_pipe_1_CpuStreamKernel : std_logic_vector(0 downto 0) := "0";
	signal clk_reset_pipe_CpuStreamKernel : std_logic_vector(0 downto 0) := "0";
	signal da_clk_reset_pipe_1_Stream_1 : std_logic_vector(0 downto 0) := "0";
	signal da_clk_reset_pipe_Stream_1 : std_logic_vector(0 downto 0) := "0";
	signal da_clk_reset_pipe_1_Stream_4 : std_logic_vector(0 downto 0) := "0";
	signal da_clk_reset_pipe_Stream_4 : std_logic_vector(0 downto 0) := "0";
	signal da_clk_reset_pipe_1_Stream_7 : std_logic_vector(0 downto 0) := "0";
	signal da_clk_reset_pipe_Stream_7 : std_logic_vector(0 downto 0) := "0";
	signal da_clk_reset_pipe_1_Stream_10 : std_logic_vector(0 downto 0) := "0";
	signal da_clk_reset_pipe_Stream_10 : std_logic_vector(0 downto 0) := "0";
	signal da_clk_reset_pipe_1_Stream_14 : std_logic_vector(0 downto 0) := "0";
	signal da_clk_reset_pipe_Stream_14 : std_logic_vector(0 downto 0) := "0";
	signal pullpush_clk_reset_pipe_1_Stream_35 : std_logic_vector(0 downto 0) := "0";
	signal pullpush_clk_reset_pipe_Stream_35 : std_logic_vector(0 downto 0) := "0";
	signal input_clk_reset_pipe_1_Stream_17 : std_logic_vector(0 downto 0) := "0";
	signal input_clk_reset_pipe_Stream_17 : std_logic_vector(0 downto 0) := "0";
	signal output_clk_reset_pipe_1_Stream_17 : std_logic_vector(0 downto 0) := "0";
	signal output_clk_reset_pipe_Stream_17 : std_logic_vector(0 downto 0) := "0";
	signal input_clk_reset_pipe_1_Stream_21 : std_logic_vector(0 downto 0) := "0";
	signal input_clk_reset_pipe_Stream_21 : std_logic_vector(0 downto 0) := "0";
	signal output_clk_reset_pipe_1_Stream_21 : std_logic_vector(0 downto 0) := "0";
	signal output_clk_reset_pipe_Stream_21 : std_logic_vector(0 downto 0) := "0";
	signal input_clk_reset_pipe_1_Stream_25 : std_logic_vector(0 downto 0) := "0";
	signal input_clk_reset_pipe_Stream_25 : std_logic_vector(0 downto 0) := "0";
	signal output_clk_reset_pipe_1_Stream_25 : std_logic_vector(0 downto 0) := "0";
	signal output_clk_reset_pipe_Stream_25 : std_logic_vector(0 downto 0) := "0";
	signal input_clk_reset_pipe_1_Stream_29 : std_logic_vector(0 downto 0) := "0";
	signal input_clk_reset_pipe_Stream_29 : std_logic_vector(0 downto 0) := "0";
	signal output_clk_reset_pipe_1_Stream_29 : std_logic_vector(0 downto 0) := "0";
	signal output_clk_reset_pipe_Stream_29 : std_logic_vector(0 downto 0) := "0";
	signal input_clk_reset_pipe_1_Stream_19 : std_logic_vector(0 downto 0) := "0";
	signal input_clk_reset_pipe_Stream_19 : std_logic_vector(0 downto 0) := "0";
	signal output_clk_reset_pipe_1_Stream_19 : std_logic_vector(0 downto 0) := "0";
	signal output_clk_reset_pipe_Stream_19 : std_logic_vector(0 downto 0) := "0";
	signal input_clk_reset_pipe_1_Stream_23 : std_logic_vector(0 downto 0) := "0";
	signal input_clk_reset_pipe_Stream_23 : std_logic_vector(0 downto 0) := "0";
	signal output_clk_reset_pipe_1_Stream_23 : std_logic_vector(0 downto 0) := "0";
	signal output_clk_reset_pipe_Stream_23 : std_logic_vector(0 downto 0) := "0";
	signal input_clk_reset_pipe_1_Stream_27 : std_logic_vector(0 downto 0) := "0";
	signal input_clk_reset_pipe_Stream_27 : std_logic_vector(0 downto 0) := "0";
	signal output_clk_reset_pipe_1_Stream_27 : std_logic_vector(0 downto 0) := "0";
	signal output_clk_reset_pipe_Stream_27 : std_logic_vector(0 downto 0) := "0";
	signal input_clk_reset_pipe_1_Stream_31 : std_logic_vector(0 downto 0) := "0";
	signal input_clk_reset_pipe_Stream_31 : std_logic_vector(0 downto 0) := "0";
	signal output_clk_reset_pipe_1_Stream_31 : std_logic_vector(0 downto 0) := "0";
	signal output_clk_reset_pipe_Stream_31 : std_logic_vector(0 downto 0) := "0";
	signal input_clk_reset_pipe_1_Stream_33 : std_logic_vector(0 downto 0) := "0";
	signal input_clk_reset_pipe_Stream_33 : std_logic_vector(0 downto 0) := "0";
	signal output_clk_reset_pipe_1_Stream_33 : std_logic_vector(0 downto 0) := "0";
	signal output_clk_reset_pipe_Stream_33 : std_logic_vector(0 downto 0) := "0";
	signal reg_ln348_wrapperdesignentity : std_logic_vector(0 downto 0) := "0";
	
	-- Attribute type declarations
	
	attribute maxfan : integer;
	
	-- Attribute declarations
	
	attribute maxfan of clk_reset_pipe_1_CpuStreamKernel : signal is 100;
	attribute maxfan of clk_reset_pipe_CpuStreamKernel : signal is 100;
	attribute maxfan of da_clk_reset_pipe_1_Stream_1 : signal is 100;
	attribute maxfan of da_clk_reset_pipe_Stream_1 : signal is 100;
	attribute maxfan of da_clk_reset_pipe_1_Stream_4 : signal is 100;
	attribute maxfan of da_clk_reset_pipe_Stream_4 : signal is 100;
	attribute maxfan of da_clk_reset_pipe_1_Stream_7 : signal is 100;
	attribute maxfan of da_clk_reset_pipe_Stream_7 : signal is 100;
	attribute maxfan of da_clk_reset_pipe_1_Stream_10 : signal is 100;
	attribute maxfan of da_clk_reset_pipe_Stream_10 : signal is 100;
	attribute maxfan of da_clk_reset_pipe_1_Stream_14 : signal is 100;
	attribute maxfan of da_clk_reset_pipe_Stream_14 : signal is 100;
	attribute maxfan of pullpush_clk_reset_pipe_1_Stream_35 : signal is 100;
	attribute maxfan of pullpush_clk_reset_pipe_Stream_35 : signal is 100;
	attribute maxfan of input_clk_reset_pipe_1_Stream_17 : signal is 100;
	attribute maxfan of input_clk_reset_pipe_Stream_17 : signal is 100;
	attribute maxfan of output_clk_reset_pipe_1_Stream_17 : signal is 100;
	attribute maxfan of output_clk_reset_pipe_Stream_17 : signal is 100;
	attribute maxfan of input_clk_reset_pipe_1_Stream_21 : signal is 100;
	attribute maxfan of input_clk_reset_pipe_Stream_21 : signal is 100;
	attribute maxfan of output_clk_reset_pipe_1_Stream_21 : signal is 100;
	attribute maxfan of output_clk_reset_pipe_Stream_21 : signal is 100;
	attribute maxfan of input_clk_reset_pipe_1_Stream_25 : signal is 100;
	attribute maxfan of input_clk_reset_pipe_Stream_25 : signal is 100;
	attribute maxfan of output_clk_reset_pipe_1_Stream_25 : signal is 100;
	attribute maxfan of output_clk_reset_pipe_Stream_25 : signal is 100;
	attribute maxfan of input_clk_reset_pipe_1_Stream_29 : signal is 100;
	attribute maxfan of input_clk_reset_pipe_Stream_29 : signal is 100;
	attribute maxfan of output_clk_reset_pipe_1_Stream_29 : signal is 100;
	attribute maxfan of output_clk_reset_pipe_Stream_29 : signal is 100;
	attribute maxfan of input_clk_reset_pipe_1_Stream_19 : signal is 100;
	attribute maxfan of input_clk_reset_pipe_Stream_19 : signal is 100;
	attribute maxfan of output_clk_reset_pipe_1_Stream_19 : signal is 100;
	attribute maxfan of output_clk_reset_pipe_Stream_19 : signal is 100;
	attribute maxfan of input_clk_reset_pipe_1_Stream_23 : signal is 100;
	attribute maxfan of input_clk_reset_pipe_Stream_23 : signal is 100;
	attribute maxfan of output_clk_reset_pipe_1_Stream_23 : signal is 100;
	attribute maxfan of output_clk_reset_pipe_Stream_23 : signal is 100;
	attribute maxfan of input_clk_reset_pipe_1_Stream_27 : signal is 100;
	attribute maxfan of input_clk_reset_pipe_Stream_27 : signal is 100;
	attribute maxfan of output_clk_reset_pipe_1_Stream_27 : signal is 100;
	attribute maxfan of output_clk_reset_pipe_Stream_27 : signal is 100;
	attribute maxfan of input_clk_reset_pipe_1_Stream_31 : signal is 100;
	attribute maxfan of input_clk_reset_pipe_Stream_31 : signal is 100;
	attribute maxfan of output_clk_reset_pipe_1_Stream_31 : signal is 100;
	attribute maxfan of output_clk_reset_pipe_Stream_31 : signal is 100;
	attribute maxfan of input_clk_reset_pipe_1_Stream_33 : signal is 100;
	attribute maxfan of input_clk_reset_pipe_Stream_33 : signal is 100;
	attribute maxfan of output_clk_reset_pipe_1_Stream_33 : signal is 100;
	attribute maxfan of output_clk_reset_pipe_Stream_33 : signal is 100;
begin
	
	-- Assignments
	
	child_0_stall <= vec_to_bit(child_0_external_stall);
	child_1_stall <= vec_to_bit(child_1_external_stall);
	child_2_stall <= vec_to_bit(child_2_external_stall);
	child_3_stall <= vec_to_bit(child_3_external_stall);
	data_w_valid <= vec_to_bit(data_w_external_valid);
	data_w_done <= vec_to_bit(data_w_external_done);
	data_w_data <= data_w_external_data;
	mapped_reg_io_CpuStreamKernel_0_register_out <= cpustreamkernel_register_out;
	toggle_ack <= vec_to_bit(bit_to_vec(toggle));
	active <= vec_to_bit(reg_ln348_wrapperdesignentity);
	
	-- Register processes
	
	reg_process : process(STREAM)
	begin
		if rising_edge(STREAM) then
			clk_reset_pipe_1_CpuStreamKernel <= clk_reset_pipe_CpuStreamKernel;
			clk_reset_pipe_CpuStreamKernel <= bit_to_vec(STREAM_RST);
			output_clk_reset_pipe_1_Stream_19 <= output_clk_reset_pipe_Stream_19;
			output_clk_reset_pipe_Stream_19 <= bit_to_vec(STREAM_RST);
			output_clk_reset_pipe_1_Stream_23 <= output_clk_reset_pipe_Stream_23;
			output_clk_reset_pipe_Stream_23 <= bit_to_vec(STREAM_RST);
			output_clk_reset_pipe_1_Stream_27 <= output_clk_reset_pipe_Stream_27;
			output_clk_reset_pipe_Stream_27 <= bit_to_vec(STREAM_RST);
			output_clk_reset_pipe_1_Stream_31 <= output_clk_reset_pipe_Stream_31;
			output_clk_reset_pipe_Stream_31 <= bit_to_vec(STREAM_RST);
			input_clk_reset_pipe_1_Stream_33 <= input_clk_reset_pipe_Stream_33;
			input_clk_reset_pipe_Stream_33 <= bit_to_vec(STREAM_RST);
			reg_ln348_wrapperdesignentity <= cpustreamkernel_active;
		end if;
	end process;
	reg_process1 : process(PCIE)
	begin
		if rising_edge(PCIE) then
			da_clk_reset_pipe_1_Stream_1 <= da_clk_reset_pipe_Stream_1;
			da_clk_reset_pipe_Stream_1 <= bit_to_vec(PCIE_RST);
			da_clk_reset_pipe_1_Stream_4 <= da_clk_reset_pipe_Stream_4;
			da_clk_reset_pipe_Stream_4 <= bit_to_vec(PCIE_RST);
			da_clk_reset_pipe_1_Stream_7 <= da_clk_reset_pipe_Stream_7;
			da_clk_reset_pipe_Stream_7 <= bit_to_vec(PCIE_RST);
			da_clk_reset_pipe_1_Stream_10 <= da_clk_reset_pipe_Stream_10;
			da_clk_reset_pipe_Stream_10 <= bit_to_vec(PCIE_RST);
			da_clk_reset_pipe_1_Stream_14 <= da_clk_reset_pipe_Stream_14;
			da_clk_reset_pipe_Stream_14 <= bit_to_vec(PCIE_RST);
			pullpush_clk_reset_pipe_1_Stream_35 <= pullpush_clk_reset_pipe_Stream_35;
			pullpush_clk_reset_pipe_Stream_35 <= bit_to_vec(PCIE_RST);
			input_clk_reset_pipe_1_Stream_17 <= input_clk_reset_pipe_Stream_17;
			input_clk_reset_pipe_Stream_17 <= bit_to_vec(PCIE_RST);
			output_clk_reset_pipe_1_Stream_17 <= output_clk_reset_pipe_Stream_17;
			output_clk_reset_pipe_Stream_17 <= bit_to_vec(PCIE_RST);
			input_clk_reset_pipe_1_Stream_21 <= input_clk_reset_pipe_Stream_21;
			input_clk_reset_pipe_Stream_21 <= bit_to_vec(PCIE_RST);
			output_clk_reset_pipe_1_Stream_21 <= output_clk_reset_pipe_Stream_21;
			output_clk_reset_pipe_Stream_21 <= bit_to_vec(PCIE_RST);
			input_clk_reset_pipe_1_Stream_25 <= input_clk_reset_pipe_Stream_25;
			input_clk_reset_pipe_Stream_25 <= bit_to_vec(PCIE_RST);
			output_clk_reset_pipe_1_Stream_25 <= output_clk_reset_pipe_Stream_25;
			output_clk_reset_pipe_Stream_25 <= bit_to_vec(PCIE_RST);
			input_clk_reset_pipe_1_Stream_29 <= input_clk_reset_pipe_Stream_29;
			input_clk_reset_pipe_Stream_29 <= bit_to_vec(PCIE_RST);
			output_clk_reset_pipe_1_Stream_29 <= output_clk_reset_pipe_Stream_29;
			output_clk_reset_pipe_Stream_29 <= bit_to_vec(PCIE_RST);
			input_clk_reset_pipe_1_Stream_19 <= input_clk_reset_pipe_Stream_19;
			input_clk_reset_pipe_Stream_19 <= bit_to_vec(PCIE_RST);
			input_clk_reset_pipe_1_Stream_23 <= input_clk_reset_pipe_Stream_23;
			input_clk_reset_pipe_Stream_23 <= bit_to_vec(PCIE_RST);
			input_clk_reset_pipe_1_Stream_27 <= input_clk_reset_pipe_Stream_27;
			input_clk_reset_pipe_Stream_27 <= bit_to_vec(PCIE_RST);
			input_clk_reset_pipe_1_Stream_31 <= input_clk_reset_pipe_Stream_31;
			input_clk_reset_pipe_Stream_31 <= bit_to_vec(PCIE_RST);
			output_clk_reset_pipe_1_Stream_33 <= output_clk_reset_pipe_Stream_33;
			output_clk_reset_pipe_Stream_33 <= bit_to_vec(PCIE_RST);
		end if;
	end process;
	
	-- Entity instances
	
	CpuStreamKernel : Manager_CpuStream_WrapperNodeEntity_CpuStreamKernel
		port map (
			child_0_read => cpustreamkernel_child_0_read(0), -- 1 bits (out)
			child_1_read => cpustreamkernel_child_1_read(0), -- 1 bits (out)
			child_2_read => cpustreamkernel_child_2_read(0), -- 1 bits (out)
			child_3_read => cpustreamkernel_child_3_read(0), -- 1 bits (out)
			data_w_valid => cpustreamkernel_data_w_valid(0), -- 1 bits (out)
			data_w_done => cpustreamkernel_data_w_done(0), -- 1 bits (out)
			data_w_data => cpustreamkernel_data_w_data, -- 32 bits (out)
			active => cpustreamkernel_active(0), -- 1 bits (out)
			register_out => cpustreamkernel_register_out, -- 8 bits (out)
			child_0_almost_empty => vec_to_bit(stream_19_output_almost_empty), -- 1 bits (in)
			child_0_empty => vec_to_bit(stream_19_output_empty), -- 1 bits (in)
			child_0_done => vec_to_bit(stream_19_output_done), -- 1 bits (in)
			child_0_data => stream_19_output_data, -- 32 bits (in)
			child_1_almost_empty => vec_to_bit(stream_23_output_almost_empty), -- 1 bits (in)
			child_1_empty => vec_to_bit(stream_23_output_empty), -- 1 bits (in)
			child_1_done => vec_to_bit(stream_23_output_done), -- 1 bits (in)
			child_1_data => stream_23_output_data, -- 32 bits (in)
			child_2_almost_empty => vec_to_bit(stream_27_output_almost_empty), -- 1 bits (in)
			child_2_empty => vec_to_bit(stream_27_output_empty), -- 1 bits (in)
			child_2_done => vec_to_bit(stream_27_output_done), -- 1 bits (in)
			child_2_data => stream_27_output_data, -- 32 bits (in)
			child_3_almost_empty => vec_to_bit(stream_31_output_almost_empty), -- 1 bits (in)
			child_3_empty => vec_to_bit(stream_31_output_empty), -- 1 bits (in)
			child_3_done => vec_to_bit(stream_31_output_done), -- 1 bits (in)
			child_3_data => stream_31_output_data, -- 32 bits (in)
			data_w_stall => vec_to_bit(stream_33_input_stall), -- 1 bits (in)
			clk => STREAM, -- 1 bits (in)
			clk_nobuf => STREAM_NOBUF, -- 1 bits (in)
			clk_rst => vec_to_bit(clk_reset_pipe_1_CpuStreamKernel), -- 1 bits (in)
			register_clk => mapped_reg_io_CpuStreamKernel_0_register_clk, -- 1 bits (in)
			register_in => mapped_reg_io_CpuStreamKernel_0_register_in, -- 8 bits (in)
			register_rotate => mapped_reg_io_CpuStreamKernel_0_register_rotate, -- 1 bits (in)
			register_stop => mapped_reg_io_CpuStreamKernel_0_register_stop, -- 1 bits (in)
			register_switch => mapped_reg_io_CpuStreamKernel_0_register_switch -- 1 bits (in)
		);
	child_0 : WrapperNodeIO_child_0
		port map (
			child_0_valid => child_0_child_0_valid(0), -- 1 bits (out)
			child_0_done => child_0_child_0_done(0), -- 1 bits (out)
			child_0_data => child_0_child_0_data, -- 128 bits (out)
			external_stall => child_0_external_stall(0), -- 1 bits (out)
			child_0_stall => vec_to_bit(stream_17_input_stall), -- 1 bits (in)
			external_valid => child_0_valid, -- 1 bits (in)
			external_done => child_0_done, -- 1 bits (in)
			external_data => child_0_data -- 128 bits (in)
		);
	child_1 : WrapperNodeIO_child_1
		port map (
			child_1_valid => child_1_child_1_valid(0), -- 1 bits (out)
			child_1_done => child_1_child_1_done(0), -- 1 bits (out)
			child_1_data => child_1_child_1_data, -- 128 bits (out)
			external_stall => child_1_external_stall(0), -- 1 bits (out)
			child_1_stall => vec_to_bit(stream_21_input_stall), -- 1 bits (in)
			external_valid => child_1_valid, -- 1 bits (in)
			external_done => child_1_done, -- 1 bits (in)
			external_data => child_1_data -- 128 bits (in)
		);
	child_2 : WrapperNodeIO_child_2
		port map (
			child_2_valid => child_2_child_2_valid(0), -- 1 bits (out)
			child_2_done => child_2_child_2_done(0), -- 1 bits (out)
			child_2_data => child_2_child_2_data, -- 128 bits (out)
			external_stall => child_2_external_stall(0), -- 1 bits (out)
			child_2_stall => vec_to_bit(stream_25_input_stall), -- 1 bits (in)
			external_valid => child_2_valid, -- 1 bits (in)
			external_done => child_2_done, -- 1 bits (in)
			external_data => child_2_data -- 128 bits (in)
		);
	child_3 : WrapperNodeIO_child_3
		port map (
			child_3_valid => child_3_child_3_valid(0), -- 1 bits (out)
			child_3_done => child_3_child_3_done(0), -- 1 bits (out)
			child_3_data => child_3_child_3_data, -- 128 bits (out)
			external_stall => child_3_external_stall(0), -- 1 bits (out)
			child_3_stall => vec_to_bit(stream_29_input_stall), -- 1 bits (in)
			external_valid => child_3_valid, -- 1 bits (in)
			external_done => child_3_done, -- 1 bits (in)
			external_data => child_3_data -- 128 bits (in)
		);
	data_w : WrapperNodeIO_data_w
		port map (
			data_w_stall => data_w_data_w_stall(0), -- 1 bits (out)
			external_valid => data_w_external_valid(0), -- 1 bits (out)
			external_done => data_w_external_done(0), -- 1 bits (out)
			external_data => data_w_external_data, -- 128 bits (out)
			data_w_valid => vec_to_bit(stream_35_output_valid), -- 1 bits (in)
			data_w_done => vec_to_bit(stream_35_output_done), -- 1 bits (in)
			data_w_data => stream_35_output_data, -- 128 bits (in)
			external_stall => data_w_stall -- 1 bits (in)
		);
	Stream_1 : Manager_CpuStream_WrapperNodeEntity_Stream_1
		port map (
			input_read => stream_1_input_read(0), -- 1 bits (out)
			output_valid => stream_1_output_valid(0), -- 1 bits (out)
			output_done => stream_1_output_done(0), -- 1 bits (out)
			output_data => stream_1_output_data, -- 32 bits (out)
			input_empty => vec_to_bit(stream_17_output_empty), -- 1 bits (in)
			input_done => vec_to_bit(stream_17_output_done), -- 1 bits (in)
			input_data => stream_17_output_data, -- 128 bits (in)
			output_stall => vec_to_bit(stream_19_input_stall), -- 1 bits (in)
			da_clk => PCIE, -- 1 bits (in)
			da_clk_nobuf => PCIE_NOBUF, -- 1 bits (in)
			da_clk_rst => vec_to_bit(da_clk_reset_pipe_1_Stream_1) -- 1 bits (in)
		);
	Stream_4 : Manager_CpuStream_WrapperNodeEntity_Stream_4
		port map (
			input_read => stream_4_input_read(0), -- 1 bits (out)
			output_valid => stream_4_output_valid(0), -- 1 bits (out)
			output_done => stream_4_output_done(0), -- 1 bits (out)
			output_data => stream_4_output_data, -- 32 bits (out)
			input_empty => vec_to_bit(stream_21_output_empty), -- 1 bits (in)
			input_done => vec_to_bit(stream_21_output_done), -- 1 bits (in)
			input_data => stream_21_output_data, -- 128 bits (in)
			output_stall => vec_to_bit(stream_23_input_stall), -- 1 bits (in)
			da_clk => PCIE, -- 1 bits (in)
			da_clk_nobuf => PCIE_NOBUF, -- 1 bits (in)
			da_clk_rst => vec_to_bit(da_clk_reset_pipe_1_Stream_4) -- 1 bits (in)
		);
	Stream_7 : Manager_CpuStream_WrapperNodeEntity_Stream_7
		port map (
			input_read => stream_7_input_read(0), -- 1 bits (out)
			output_valid => stream_7_output_valid(0), -- 1 bits (out)
			output_done => stream_7_output_done(0), -- 1 bits (out)
			output_data => stream_7_output_data, -- 32 bits (out)
			input_empty => vec_to_bit(stream_25_output_empty), -- 1 bits (in)
			input_done => vec_to_bit(stream_25_output_done), -- 1 bits (in)
			input_data => stream_25_output_data, -- 128 bits (in)
			output_stall => vec_to_bit(stream_27_input_stall), -- 1 bits (in)
			da_clk => PCIE, -- 1 bits (in)
			da_clk_nobuf => PCIE_NOBUF, -- 1 bits (in)
			da_clk_rst => vec_to_bit(da_clk_reset_pipe_1_Stream_7) -- 1 bits (in)
		);
	Stream_10 : Manager_CpuStream_WrapperNodeEntity_Stream_10
		port map (
			input_read => stream_10_input_read(0), -- 1 bits (out)
			output_valid => stream_10_output_valid(0), -- 1 bits (out)
			output_done => stream_10_output_done(0), -- 1 bits (out)
			output_data => stream_10_output_data, -- 32 bits (out)
			input_empty => vec_to_bit(stream_29_output_empty), -- 1 bits (in)
			input_done => vec_to_bit(stream_29_output_done), -- 1 bits (in)
			input_data => stream_29_output_data, -- 128 bits (in)
			output_stall => vec_to_bit(stream_31_input_stall), -- 1 bits (in)
			da_clk => PCIE, -- 1 bits (in)
			da_clk_nobuf => PCIE_NOBUF, -- 1 bits (in)
			da_clk_rst => vec_to_bit(da_clk_reset_pipe_1_Stream_10) -- 1 bits (in)
		);
	Stream_14 : Manager_CpuStream_WrapperNodeEntity_Stream_14
		port map (
			input_read => stream_14_input_read(0), -- 1 bits (out)
			output_empty => stream_14_output_empty(0), -- 1 bits (out)
			output_done => stream_14_output_done(0), -- 1 bits (out)
			output_data => stream_14_output_data, -- 128 bits (out)
			input_empty => vec_to_bit(stream_33_output_empty), -- 1 bits (in)
			input_done => vec_to_bit(stream_33_output_done), -- 1 bits (in)
			input_data => stream_33_output_data, -- 32 bits (in)
			output_read => vec_to_bit(stream_35_input_read), -- 1 bits (in)
			da_clk => PCIE, -- 1 bits (in)
			da_clk_nobuf => PCIE_NOBUF, -- 1 bits (in)
			da_clk_rst => vec_to_bit(da_clk_reset_pipe_1_Stream_14) -- 1 bits (in)
		);
	Stream_35 : Manager_CpuStream_WrapperNodeEntity_Stream_35
		port map (
			input_read => stream_35_input_read(0), -- 1 bits (out)
			output_valid => stream_35_output_valid(0), -- 1 bits (out)
			output_done => stream_35_output_done(0), -- 1 bits (out)
			output_data => stream_35_output_data, -- 128 bits (out)
			input_empty => vec_to_bit(stream_14_output_empty), -- 1 bits (in)
			input_done => vec_to_bit(stream_14_output_done), -- 1 bits (in)
			input_data => stream_14_output_data, -- 128 bits (in)
			output_stall => vec_to_bit(data_w_data_w_stall), -- 1 bits (in)
			pullpush_clk => PCIE, -- 1 bits (in)
			pullpush_clk_nobuf => PCIE_NOBUF, -- 1 bits (in)
			pullpush_clk_rst => vec_to_bit(pullpush_clk_reset_pipe_1_Stream_35) -- 1 bits (in)
		);
	Stream_17 : Manager_CpuStream_WrapperNodeEntity_Stream_17
		port map (
			input_stall => stream_17_input_stall(0), -- 1 bits (out)
			output_empty => stream_17_output_empty(0), -- 1 bits (out)
			output_done => stream_17_output_done(0), -- 1 bits (out)
			output_data => stream_17_output_data, -- 128 bits (out)
			input_valid => vec_to_bit(child_0_child_0_valid), -- 1 bits (in)
			input_done => vec_to_bit(child_0_child_0_done), -- 1 bits (in)
			input_data => child_0_child_0_data, -- 128 bits (in)
			output_read => vec_to_bit(stream_1_input_read), -- 1 bits (in)
			input_clk => PCIE, -- 1 bits (in)
			input_clk_nobuf => PCIE_NOBUF, -- 1 bits (in)
			input_clk_rst => vec_to_bit(input_clk_reset_pipe_1_Stream_17), -- 1 bits (in)
			input_clk_rst_delay => PCIE_RST_DELAY, -- 1 bits (in)
			output_clk => PCIE, -- 1 bits (in)
			output_clk_nobuf => PCIE_NOBUF, -- 1 bits (in)
			output_clk_rst => vec_to_bit(output_clk_reset_pipe_1_Stream_17) -- 1 bits (in)
		);
	Stream_21 : Manager_CpuStream_WrapperNodeEntity_Stream_21
		port map (
			input_stall => stream_21_input_stall(0), -- 1 bits (out)
			output_empty => stream_21_output_empty(0), -- 1 bits (out)
			output_done => stream_21_output_done(0), -- 1 bits (out)
			output_data => stream_21_output_data, -- 128 bits (out)
			input_valid => vec_to_bit(child_1_child_1_valid), -- 1 bits (in)
			input_done => vec_to_bit(child_1_child_1_done), -- 1 bits (in)
			input_data => child_1_child_1_data, -- 128 bits (in)
			output_read => vec_to_bit(stream_4_input_read), -- 1 bits (in)
			input_clk => PCIE, -- 1 bits (in)
			input_clk_nobuf => PCIE_NOBUF, -- 1 bits (in)
			input_clk_rst => vec_to_bit(input_clk_reset_pipe_1_Stream_21), -- 1 bits (in)
			input_clk_rst_delay => PCIE_RST_DELAY, -- 1 bits (in)
			output_clk => PCIE, -- 1 bits (in)
			output_clk_nobuf => PCIE_NOBUF, -- 1 bits (in)
			output_clk_rst => vec_to_bit(output_clk_reset_pipe_1_Stream_21) -- 1 bits (in)
		);
	Stream_25 : Manager_CpuStream_WrapperNodeEntity_Stream_25
		port map (
			input_stall => stream_25_input_stall(0), -- 1 bits (out)
			output_empty => stream_25_output_empty(0), -- 1 bits (out)
			output_done => stream_25_output_done(0), -- 1 bits (out)
			output_data => stream_25_output_data, -- 128 bits (out)
			input_valid => vec_to_bit(child_2_child_2_valid), -- 1 bits (in)
			input_done => vec_to_bit(child_2_child_2_done), -- 1 bits (in)
			input_data => child_2_child_2_data, -- 128 bits (in)
			output_read => vec_to_bit(stream_7_input_read), -- 1 bits (in)
			input_clk => PCIE, -- 1 bits (in)
			input_clk_nobuf => PCIE_NOBUF, -- 1 bits (in)
			input_clk_rst => vec_to_bit(input_clk_reset_pipe_1_Stream_25), -- 1 bits (in)
			input_clk_rst_delay => PCIE_RST_DELAY, -- 1 bits (in)
			output_clk => PCIE, -- 1 bits (in)
			output_clk_nobuf => PCIE_NOBUF, -- 1 bits (in)
			output_clk_rst => vec_to_bit(output_clk_reset_pipe_1_Stream_25) -- 1 bits (in)
		);
	Stream_29 : Manager_CpuStream_WrapperNodeEntity_Stream_29
		port map (
			input_stall => stream_29_input_stall(0), -- 1 bits (out)
			output_empty => stream_29_output_empty(0), -- 1 bits (out)
			output_done => stream_29_output_done(0), -- 1 bits (out)
			output_data => stream_29_output_data, -- 128 bits (out)
			input_valid => vec_to_bit(child_3_child_3_valid), -- 1 bits (in)
			input_done => vec_to_bit(child_3_child_3_done), -- 1 bits (in)
			input_data => child_3_child_3_data, -- 128 bits (in)
			output_read => vec_to_bit(stream_10_input_read), -- 1 bits (in)
			input_clk => PCIE, -- 1 bits (in)
			input_clk_nobuf => PCIE_NOBUF, -- 1 bits (in)
			input_clk_rst => vec_to_bit(input_clk_reset_pipe_1_Stream_29), -- 1 bits (in)
			input_clk_rst_delay => PCIE_RST_DELAY, -- 1 bits (in)
			output_clk => PCIE, -- 1 bits (in)
			output_clk_nobuf => PCIE_NOBUF, -- 1 bits (in)
			output_clk_rst => vec_to_bit(output_clk_reset_pipe_1_Stream_29) -- 1 bits (in)
		);
	Stream_19 : Manager_CpuStream_WrapperNodeEntity_Stream_19
		port map (
			input_stall => stream_19_input_stall(0), -- 1 bits (out)
			output_almost_empty => stream_19_output_almost_empty(0), -- 1 bits (out)
			output_empty => stream_19_output_empty(0), -- 1 bits (out)
			output_done => stream_19_output_done(0), -- 1 bits (out)
			output_data => stream_19_output_data, -- 32 bits (out)
			input_valid => vec_to_bit(stream_1_output_valid), -- 1 bits (in)
			input_done => vec_to_bit(stream_1_output_done), -- 1 bits (in)
			input_data => stream_1_output_data, -- 32 bits (in)
			output_read => vec_to_bit(cpustreamkernel_child_0_read), -- 1 bits (in)
			input_clk => PCIE, -- 1 bits (in)
			input_clk_nobuf => PCIE_NOBUF, -- 1 bits (in)
			input_clk_rst => vec_to_bit(input_clk_reset_pipe_1_Stream_19), -- 1 bits (in)
			output_clk => STREAM, -- 1 bits (in)
			output_clk_nobuf => STREAM_NOBUF, -- 1 bits (in)
			output_clk_rst => vec_to_bit(output_clk_reset_pipe_1_Stream_19), -- 1 bits (in)
			output_clk_rst_delay => STREAM_RST_DELAY -- 1 bits (in)
		);
	Stream_23 : Manager_CpuStream_WrapperNodeEntity_Stream_23
		port map (
			input_stall => stream_23_input_stall(0), -- 1 bits (out)
			output_almost_empty => stream_23_output_almost_empty(0), -- 1 bits (out)
			output_empty => stream_23_output_empty(0), -- 1 bits (out)
			output_done => stream_23_output_done(0), -- 1 bits (out)
			output_data => stream_23_output_data, -- 32 bits (out)
			input_valid => vec_to_bit(stream_4_output_valid), -- 1 bits (in)
			input_done => vec_to_bit(stream_4_output_done), -- 1 bits (in)
			input_data => stream_4_output_data, -- 32 bits (in)
			output_read => vec_to_bit(cpustreamkernel_child_1_read), -- 1 bits (in)
			input_clk => PCIE, -- 1 bits (in)
			input_clk_nobuf => PCIE_NOBUF, -- 1 bits (in)
			input_clk_rst => vec_to_bit(input_clk_reset_pipe_1_Stream_23), -- 1 bits (in)
			output_clk => STREAM, -- 1 bits (in)
			output_clk_nobuf => STREAM_NOBUF, -- 1 bits (in)
			output_clk_rst => vec_to_bit(output_clk_reset_pipe_1_Stream_23), -- 1 bits (in)
			output_clk_rst_delay => STREAM_RST_DELAY -- 1 bits (in)
		);
	Stream_27 : Manager_CpuStream_WrapperNodeEntity_Stream_27
		port map (
			input_stall => stream_27_input_stall(0), -- 1 bits (out)
			output_almost_empty => stream_27_output_almost_empty(0), -- 1 bits (out)
			output_empty => stream_27_output_empty(0), -- 1 bits (out)
			output_done => stream_27_output_done(0), -- 1 bits (out)
			output_data => stream_27_output_data, -- 32 bits (out)
			input_valid => vec_to_bit(stream_7_output_valid), -- 1 bits (in)
			input_done => vec_to_bit(stream_7_output_done), -- 1 bits (in)
			input_data => stream_7_output_data, -- 32 bits (in)
			output_read => vec_to_bit(cpustreamkernel_child_2_read), -- 1 bits (in)
			input_clk => PCIE, -- 1 bits (in)
			input_clk_nobuf => PCIE_NOBUF, -- 1 bits (in)
			input_clk_rst => vec_to_bit(input_clk_reset_pipe_1_Stream_27), -- 1 bits (in)
			output_clk => STREAM, -- 1 bits (in)
			output_clk_nobuf => STREAM_NOBUF, -- 1 bits (in)
			output_clk_rst => vec_to_bit(output_clk_reset_pipe_1_Stream_27), -- 1 bits (in)
			output_clk_rst_delay => STREAM_RST_DELAY -- 1 bits (in)
		);
	Stream_31 : Manager_CpuStream_WrapperNodeEntity_Stream_31
		port map (
			input_stall => stream_31_input_stall(0), -- 1 bits (out)
			output_almost_empty => stream_31_output_almost_empty(0), -- 1 bits (out)
			output_empty => stream_31_output_empty(0), -- 1 bits (out)
			output_done => stream_31_output_done(0), -- 1 bits (out)
			output_data => stream_31_output_data, -- 32 bits (out)
			input_valid => vec_to_bit(stream_10_output_valid), -- 1 bits (in)
			input_done => vec_to_bit(stream_10_output_done), -- 1 bits (in)
			input_data => stream_10_output_data, -- 32 bits (in)
			output_read => vec_to_bit(cpustreamkernel_child_3_read), -- 1 bits (in)
			input_clk => PCIE, -- 1 bits (in)
			input_clk_nobuf => PCIE_NOBUF, -- 1 bits (in)
			input_clk_rst => vec_to_bit(input_clk_reset_pipe_1_Stream_31), -- 1 bits (in)
			output_clk => STREAM, -- 1 bits (in)
			output_clk_nobuf => STREAM_NOBUF, -- 1 bits (in)
			output_clk_rst => vec_to_bit(output_clk_reset_pipe_1_Stream_31), -- 1 bits (in)
			output_clk_rst_delay => STREAM_RST_DELAY -- 1 bits (in)
		);
	Stream_33 : Manager_CpuStream_WrapperNodeEntity_Stream_33
		port map (
			input_stall => stream_33_input_stall(0), -- 1 bits (out)
			output_empty => stream_33_output_empty(0), -- 1 bits (out)
			output_done => stream_33_output_done(0), -- 1 bits (out)
			output_data => stream_33_output_data, -- 32 bits (out)
			input_valid => vec_to_bit(cpustreamkernel_data_w_valid), -- 1 bits (in)
			input_done => vec_to_bit(cpustreamkernel_data_w_done), -- 1 bits (in)
			input_data => cpustreamkernel_data_w_data, -- 32 bits (in)
			output_read => vec_to_bit(stream_14_input_read), -- 1 bits (in)
			input_clk => STREAM, -- 1 bits (in)
			input_clk_nobuf => STREAM_NOBUF, -- 1 bits (in)
			input_clk_rst => vec_to_bit(input_clk_reset_pipe_1_Stream_33), -- 1 bits (in)
			input_clk_rst_delay => STREAM_RST_DELAY, -- 1 bits (in)
			output_clk => PCIE, -- 1 bits (in)
			output_clk_nobuf => PCIE_NOBUF, -- 1 bits (in)
			output_clk_rst => vec_to_bit(output_clk_reset_pipe_1_Stream_33) -- 1 bits (in)
		);
end MaxDC;
