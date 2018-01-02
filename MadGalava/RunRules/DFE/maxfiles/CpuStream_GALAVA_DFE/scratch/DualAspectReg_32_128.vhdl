library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity DualAspectReg_32_128 is
	port (
		clk: in std_logic;
		rst: in std_logic;
		input_empty: in std_logic;
		input_done: in std_logic;
		input_data: in std_logic_vector(31 downto 0);
		output_read: in std_logic;
		input_read: out std_logic;
		output_empty: out std_logic;
		output_done: out std_logic;
		output_data: out std_logic_vector(127 downto 0)
	);
end DualAspectReg_32_128;

architecture MaxDC of DualAspectReg_32_128 is
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
	component dualaspectreg_int is
		generic (
			COUNT_BITS : integer;
			COUNT_MAX : integer;
			INPUT_WIDTH : integer
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			input_empty: in std_logic;
			input_data: in std_logic_vector(INPUT_WIDTH-1 downto 0);
			output_read: in std_logic;
			input_read: out std_logic;
			output_empty: out std_logic;
			output_data: out std_logic_vector((INPUT_WIDTH*(COUNT_MAX+1))-1 downto 0)
		);
	end component;
	
	-- Signal declarations
	
	signal inst_ln127_dualaspectreg_input_read : std_logic_vector(0 downto 0);
	signal inst_ln127_dualaspectreg_output_empty : std_logic_vector(0 downto 0);
	signal inst_ln127_dualaspectreg_output_data : std_logic_vector(127 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	input_read <= vec_to_bit(inst_ln127_dualaspectreg_input_read);
	output_empty <= vec_to_bit(inst_ln127_dualaspectreg_output_empty);
	output_done <= vec_to_bit((bit_to_vec(input_done) and inst_ln127_dualaspectreg_output_empty));
	output_data <= inst_ln127_dualaspectreg_output_data;
	
	-- Register processes
	
	
	-- Entity instances
	
	inst_ln127_dualaspectreg : dualaspectreg_int
		generic map (
			COUNT_BITS => 2,
			COUNT_MAX => 3,
			INPUT_WIDTH => 32
		)
		port map (
			input_read => inst_ln127_dualaspectreg_input_read(0), -- 1 bits (out)
			output_empty => inst_ln127_dualaspectreg_output_empty(0), -- 1 bits (out)
			output_data => inst_ln127_dualaspectreg_output_data, -- 128 bits (out)
			clk => clk, -- 1 bits (in)
			rst => rst, -- 1 bits (in)
			input_empty => input_empty, -- 1 bits (in)
			input_data => input_data, -- 32 bits (in)
			output_read => output_read -- 1 bits (in)
		);
end MaxDC;
