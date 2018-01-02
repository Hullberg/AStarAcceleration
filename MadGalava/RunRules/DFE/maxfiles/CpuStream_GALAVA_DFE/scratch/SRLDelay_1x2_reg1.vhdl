library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity SRLDelay_1x2_reg1 is
	port (
		clk: in std_logic;
		ce: in std_logic;
		input: in std_logic;
		output: out std_logic
	);
end SRLDelay_1x2_reg1;

architecture MaxDC of SRLDelay_1x2_reg1 is
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
	component SimpleSR is
		generic (
			SR_WIDTH : integer;
			SR_DEPTH : integer;
			SR_RAM_IMPL : string;
			SR_DEPTH_THRESH : integer
		);
		port (
			input: in std_logic_vector(0 downto 0);
			ce: in std_logic;
			clk: in std_logic;
			output: out std_logic_vector(0 downto 0)
		);
	end component;
	
	-- Signal declarations
	
	signal inst_ln34_alterasrldelay_output : std_logic_vector(0 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	output <= vec_to_bit(inst_ln34_alterasrldelay_output);
	
	-- Register processes
	
	
	-- Entity instances
	
	inst_ln34_alterasrldelay : SimpleSR
		generic map (
			SR_WIDTH => 1,
			SR_DEPTH => 2,
			SR_RAM_IMPL => "mlab",
			SR_DEPTH_THRESH => 64
		)
		port map (
			output => inst_ln34_alterasrldelay_output, -- 1 bits (out)
			input => bit_to_vec(input), -- 1 bits (in)
			ce => ce, -- 1 bits (in)
			clk => clk -- 1 bits (in)
		);
end MaxDC;
