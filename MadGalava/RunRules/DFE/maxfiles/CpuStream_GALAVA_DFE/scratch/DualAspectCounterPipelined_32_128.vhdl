library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity DualAspectCounterPipelined_32_128 is
	port (
		clk: in std_logic;
		rst: in std_logic;
		input_empty: in std_logic;
		input_done: in std_logic;
		input_data: in std_logic_vector(127 downto 0);
		output_stall: in std_logic;
		input_read: out std_logic;
		output_valid: out std_logic;
		output_data: out std_logic_vector(31 downto 0);
		output_done: out std_logic
	);
end DualAspectCounterPipelined_32_128;

architecture MaxDC of DualAspectCounterPipelined_32_128 is
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
	component dualaspectmuxpipe_counter is
		generic (
			G_CNT_THRESHOLD : integer;
			G_NUM_STAGES : integer;
			G_ASPECT_LOG2 : integer
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			input_empty: in std_logic;
			input_done: in std_logic;
			output_stall: in std_logic;
			input_read: out std_logic;
			output_done: out std_logic;
			output_valid: out std_logic;
			count: out std_logic_vector(1 downto 0)
		);
	end component;
	component dualaspectmuxpipe_mux4 is
		generic (
			OUTPUT_WIDTH : integer
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			sel: in std_logic_vector(1 downto 0);
			output_stall: in std_logic;
			input_data: in std_logic_vector(127 downto 0);
			output_data: out std_logic_vector(31 downto 0)
		);
	end component;
	
	-- Signal declarations
	
	signal inst_ln229_dualaspectcounterpipelined_input_read : std_logic_vector(0 downto 0);
	signal inst_ln229_dualaspectcounterpipelined_output_done : std_logic_vector(0 downto 0);
	signal inst_ln229_dualaspectcounterpipelined_output_valid : std_logic_vector(0 downto 0);
	signal inst_ln229_dualaspectcounterpipelined_count : std_logic_vector(1 downto 0);
	signal inst_ln197_dualaspectcounterpipelined_output_data : std_logic_vector(31 downto 0);
	signal sig : std_logic_vector(1 downto 0);
	signal sig2 : std_logic_vector(127 downto 0);
	signal sig3 : std_logic_vector(31 downto 0);
	signal sig4 : std_logic_vector(31 downto 0);
	signal cat_ln182_dualaspectcounterpipelined : std_logic_vector(31 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	sig <= inst_ln229_dualaspectcounterpipelined_count;
	sig2 <= input_data;
	sig4 <= inst_ln197_dualaspectcounterpipelined_output_data;
	cat_ln182_dualaspectcounterpipelined<=sig4;
	sig3 <= cat_ln182_dualaspectcounterpipelined;
	input_read <= vec_to_bit(inst_ln229_dualaspectcounterpipelined_input_read);
	output_valid <= vec_to_bit(inst_ln229_dualaspectcounterpipelined_output_valid);
	output_data <= sig3;
	output_done <= vec_to_bit(inst_ln229_dualaspectcounterpipelined_output_done);
	
	-- Register processes
	
	
	-- Entity instances
	
	inst_ln229_dualaspectcounterpipelined : dualaspectmuxpipe_counter
		generic map (
			G_CNT_THRESHOLD => 4,
			G_NUM_STAGES => 1,
			G_ASPECT_LOG2 => 2
		)
		port map (
			input_read => inst_ln229_dualaspectcounterpipelined_input_read(0), -- 1 bits (out)
			output_done => inst_ln229_dualaspectcounterpipelined_output_done(0), -- 1 bits (out)
			output_valid => inst_ln229_dualaspectcounterpipelined_output_valid(0), -- 1 bits (out)
			count => inst_ln229_dualaspectcounterpipelined_count, -- 2 bits (out)
			clk => clk, -- 1 bits (in)
			rst => rst, -- 1 bits (in)
			input_empty => input_empty, -- 1 bits (in)
			input_done => input_done, -- 1 bits (in)
			output_stall => output_stall -- 1 bits (in)
		);
	inst_ln197_dualaspectcounterpipelined : dualaspectmuxpipe_mux4
		generic map (
			OUTPUT_WIDTH => 32
		)
		port map (
			output_data => inst_ln197_dualaspectcounterpipelined_output_data, -- 32 bits (out)
			clk => clk, -- 1 bits (in)
			rst => rst, -- 1 bits (in)
			sel => sig, -- 2 bits (in)
			output_stall => output_stall, -- 1 bits (in)
			input_data => sig2 -- 128 bits (in)
		);
end MaxDC;
