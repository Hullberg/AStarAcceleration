library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity MappedRegBlock_4cdf0f923c75d2a0461d279b0adb9830 is
	port (
		register_clk: in std_logic;
		register_in: in std_logic_vector(7 downto 0);
		register_rotate: in std_logic;
		register_stop: in std_logic;
		register_switch: in std_logic;
		register_out: out std_logic_vector(7 downto 0);
		reg_SFA_FORWARD_EN: out std_logic_vector(31 downto 0)
	);
end MappedRegBlock_4cdf0f923c75d2a0461d279b0adb9830;

architecture MaxDC of MappedRegBlock_4cdf0f923c75d2a0461d279b0adb9830 is
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
	component mapped_register is
		generic (
			BYTE_WIDTH : integer;
			SHADOW_REGISTER : boolean;
			SWITCHABLE : boolean;
			BIG_ENDIAN : boolean
		);
		port (
			register_clk: in std_logic;
			register_in: in std_logic_vector(7 downto 0);
			register_rotate: in std_logic;
			register_stop: in std_logic;
			register_switch: in std_logic;
			register_out: out std_logic_vector(7 downto 0);
			reg_out: out std_logic_vector(BYTE_WIDTH*8-1 downto 0)
		);
	end component;
	
	-- Signal declarations
	
	signal inst_ln525_mappedregblock_register_out : std_logic_vector(7 downto 0);
	signal inst_ln525_mappedregblock_reg_out : std_logic_vector(31 downto 0);
	signal sig1 : std_logic_vector(7 downto 0);
	signal sig : std_logic_vector(7 downto 0);
	signal reg_SFA_FORWARD_EN_out_int : std_logic_vector(31 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	sig1 <= register_in;
	sig <= inst_ln525_mappedregblock_register_out;
	reg_SFA_FORWARD_EN_out_int <= inst_ln525_mappedregblock_reg_out;
	register_out <= sig;
	reg_SFA_FORWARD_EN <= reg_SFA_FORWARD_EN_out_int;
	
	-- Register processes
	
	
	-- Entity instances
	
	inst_ln525_mappedregblock : mapped_register
		generic map (
			BYTE_WIDTH => 4,
			SHADOW_REGISTER => true,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln525_mappedregblock_register_out, -- 8 bits (out)
			reg_out => inst_ln525_mappedregblock_reg_out, -- 32 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig1, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch -- 1 bits (in)
		);
end MaxDC;
