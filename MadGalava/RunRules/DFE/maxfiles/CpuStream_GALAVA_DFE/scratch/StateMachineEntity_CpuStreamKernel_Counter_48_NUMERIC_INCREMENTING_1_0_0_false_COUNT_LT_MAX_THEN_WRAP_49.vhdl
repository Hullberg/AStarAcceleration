library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity StateMachineEntity_CpuStreamKernel_Counter_48_NUMERIC_INCREMENTING_1_0_0_false_COUNT_LT_MAX_THEN_WRAP_49 is
	port (
		enable: in std_logic_vector(0 downto 0);
		max: in std_logic_vector(48 downto 0);
		clk: in std_logic;
		ce: in std_logic;
		rst: in std_logic;
		count: out std_logic_vector(47 downto 0);
		wrap: out std_logic_vector(0 downto 0)
	);
end StateMachineEntity_CpuStreamKernel_Counter_48_NUMERIC_INCREMENTING_1_0_0_false_COUNT_LT_MAX_THEN_WRAP_49;

architecture MaxDC of StateMachineEntity_CpuStreamKernel_Counter_48_NUMERIC_INCREMENTING_1_0_0_false_COUNT_LT_MAX_THEN_WRAP_49 is
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
	component CpuStreamKernel_Counter_48_NUMERIC_INCREMENTING_1_0_0_false_COUNT_LT_MAX_THEN_WRAP_49 is
		port (
			clk: in std_logic;
			ce: in std_logic;
			rst: in std_logic;
			inputdata_enable: in std_logic_vector(0 downto 0);
			inputdata_max: in std_logic_vector(48 downto 0);
			outputdata_count: out std_logic_vector(47 downto 0);
			outputdata_wrap: out std_logic_vector(0 downto 0)
		);
	end component;
	
	-- Signal declarations
	
	signal inst_ln162_statemachineentitycore_outputdata_count : std_logic_vector(47 downto 0);
	signal inst_ln162_statemachineentitycore_outputdata_wrap : std_logic_vector(0 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	count <= inst_ln162_statemachineentitycore_outputdata_count;
	wrap <= inst_ln162_statemachineentitycore_outputdata_wrap;
	
	-- Register processes
	
	
	-- Entity instances
	
	inst_ln162_statemachineentitycore : CpuStreamKernel_Counter_48_NUMERIC_INCREMENTING_1_0_0_false_COUNT_LT_MAX_THEN_WRAP_49
		port map (
			outputdata_count => inst_ln162_statemachineentitycore_outputdata_count, -- 48 bits (out)
			outputdata_wrap => inst_ln162_statemachineentitycore_outputdata_wrap, -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			ce => ce, -- 1 bits (in)
			rst => rst, -- 1 bits (in)
			inputdata_enable => enable, -- 1 bits (in)
			inputdata_max => max -- 49 bits (in)
		);
end MaxDC;
