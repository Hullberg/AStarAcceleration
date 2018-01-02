library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity StreamPullPushAdapter128 is
	port (
		clk: in std_logic;
		rst: in std_logic;
		inputstream_pull_empty: in std_logic;
		inputstream_pull_done: in std_logic;
		inputstream_pull_data: in std_logic_vector(127 downto 0);
		outputstream_push_stall: in std_logic;
		inputstream_pull_read: out std_logic;
		outputstream_push_valid: out std_logic;
		outputstream_push_done: out std_logic;
		outputstream_push_data: out std_logic_vector(127 downto 0)
	);
end StreamPullPushAdapter128;

architecture MaxDC of StreamPullPushAdapter128 is
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
	
	-- Signal declarations
	
	signal reg_ln48_streampullpushadapter : std_logic_vector(0 downto 0) := "0";
	signal reg_ln43_streampullpushadapter : std_logic_vector(0 downto 0) := "0";
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	inputstream_pull_read <= vec_to_bit((not (bit_to_vec(outputstream_push_stall) or bit_to_vec(inputstream_pull_empty))));
	outputstream_push_valid <= vec_to_bit(reg_ln48_streampullpushadapter);
	outputstream_push_done <= vec_to_bit(reg_ln43_streampullpushadapter);
	outputstream_push_data <= inputstream_pull_data;
	
	-- Register processes
	
	reg_process : process(clk)
	begin
		if rising_edge(clk) then
			reg_ln48_streampullpushadapter <= (not (bit_to_vec(outputstream_push_stall) or bit_to_vec(inputstream_pull_empty)));
			reg_ln43_streampullpushadapter <= bit_to_vec(inputstream_pull_done);
		end if;
	end process;
	
	-- Entity instances
	
end MaxDC;
