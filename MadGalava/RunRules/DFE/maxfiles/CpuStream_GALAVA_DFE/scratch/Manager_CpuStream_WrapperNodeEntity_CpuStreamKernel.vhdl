library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity Manager_CpuStream_WrapperNodeEntity_CpuStreamKernel is
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
end Manager_CpuStream_WrapperNodeEntity_CpuStreamKernel;

architecture MaxDC of Manager_CpuStream_WrapperNodeEntity_CpuStreamKernel is
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
	component CpuStreamKernel_streamwrapper is
		port (
			clk: in std_logic;
			rst: in std_logic;
			child_0_empty: in std_logic;
			child_0_done: in std_logic;
			child_0_almost_empty: in std_logic;
			child_0_data: in std_logic_vector(31 downto 0);
			child_1_empty: in std_logic;
			child_1_done: in std_logic;
			child_1_almost_empty: in std_logic;
			child_1_data: in std_logic_vector(31 downto 0);
			child_2_empty: in std_logic;
			child_2_done: in std_logic;
			child_2_almost_empty: in std_logic;
			child_2_data: in std_logic_vector(31 downto 0);
			child_3_empty: in std_logic;
			child_3_done: in std_logic;
			child_3_almost_empty: in std_logic;
			child_3_data: in std_logic_vector(31 downto 0);
			data_w_stall: in std_logic;
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
			register_out: out std_logic_vector(7 downto 0);
			active: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal inst_ln31_streamingblock_child_0_read : std_logic_vector(0 downto 0);
	signal inst_ln31_streamingblock_child_1_read : std_logic_vector(0 downto 0);
	signal inst_ln31_streamingblock_child_2_read : std_logic_vector(0 downto 0);
	signal inst_ln31_streamingblock_child_3_read : std_logic_vector(0 downto 0);
	signal inst_ln31_streamingblock_data_w_valid : std_logic_vector(0 downto 0);
	signal inst_ln31_streamingblock_data_w_done : std_logic_vector(0 downto 0);
	signal inst_ln31_streamingblock_data_w_data : std_logic_vector(31 downto 0);
	signal inst_ln31_streamingblock_register_out : std_logic_vector(7 downto 0);
	signal inst_ln31_streamingblock_active : std_logic_vector(0 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	child_0_read <= vec_to_bit(inst_ln31_streamingblock_child_0_read);
	child_1_read <= vec_to_bit(inst_ln31_streamingblock_child_1_read);
	child_2_read <= vec_to_bit(inst_ln31_streamingblock_child_2_read);
	child_3_read <= vec_to_bit(inst_ln31_streamingblock_child_3_read);
	data_w_valid <= vec_to_bit(inst_ln31_streamingblock_data_w_valid);
	data_w_done <= vec_to_bit(inst_ln31_streamingblock_data_w_done);
	data_w_data <= inst_ln31_streamingblock_data_w_data;
	active <= vec_to_bit(inst_ln31_streamingblock_active);
	register_out <= inst_ln31_streamingblock_register_out;
	
	-- Register processes
	
	
	-- Entity instances
	
	inst_ln31_streamingblock : CpuStreamKernel_streamwrapper
		port map (
			child_0_read => inst_ln31_streamingblock_child_0_read(0), -- 1 bits (out)
			child_1_read => inst_ln31_streamingblock_child_1_read(0), -- 1 bits (out)
			child_2_read => inst_ln31_streamingblock_child_2_read(0), -- 1 bits (out)
			child_3_read => inst_ln31_streamingblock_child_3_read(0), -- 1 bits (out)
			data_w_valid => inst_ln31_streamingblock_data_w_valid(0), -- 1 bits (out)
			data_w_done => inst_ln31_streamingblock_data_w_done(0), -- 1 bits (out)
			data_w_data => inst_ln31_streamingblock_data_w_data, -- 32 bits (out)
			register_out => inst_ln31_streamingblock_register_out, -- 8 bits (out)
			active => inst_ln31_streamingblock_active(0), -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			rst => clk_rst, -- 1 bits (in)
			child_0_empty => child_0_empty, -- 1 bits (in)
			child_0_done => child_0_done, -- 1 bits (in)
			child_0_almost_empty => child_0_almost_empty, -- 1 bits (in)
			child_0_data => child_0_data, -- 32 bits (in)
			child_1_empty => child_1_empty, -- 1 bits (in)
			child_1_done => child_1_done, -- 1 bits (in)
			child_1_almost_empty => child_1_almost_empty, -- 1 bits (in)
			child_1_data => child_1_data, -- 32 bits (in)
			child_2_empty => child_2_empty, -- 1 bits (in)
			child_2_done => child_2_done, -- 1 bits (in)
			child_2_almost_empty => child_2_almost_empty, -- 1 bits (in)
			child_2_data => child_2_data, -- 32 bits (in)
			child_3_empty => child_3_empty, -- 1 bits (in)
			child_3_done => child_3_done, -- 1 bits (in)
			child_3_almost_empty => child_3_almost_empty, -- 1 bits (in)
			child_3_data => child_3_data, -- 32 bits (in)
			data_w_stall => data_w_stall, -- 1 bits (in)
			register_clk => register_clk, -- 1 bits (in)
			register_in => register_in, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch -- 1 bits (in)
		);
end MaxDC;
