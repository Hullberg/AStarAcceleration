library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity MappedElementAdapterForwarder is
	port (
		FROM_SWITCH_SOP_N: in std_logic;
		FROM_SWITCH_EOP_N: in std_logic;
		FROM_SWITCH_SRC_RDY_N: in std_logic;
		FROM_SWITCH_DATA: in std_logic_vector(31 downto 0);
		FROM_SWITCH_FWD_DST_RDY_N: in std_logic;
		TO_SWITCH_DST_RDY_N: in std_logic;
		TO_SWITCH_FWD_SOP_N: in std_logic;
		TO_SWITCH_FWD_EOP_N: in std_logic;
		TO_SWITCH_FWD_SRC_RDY_N: in std_logic;
		TO_SWITCH_FWD_DATA: in std_logic_vector(31 downto 0);
		clocking_clk_switch: in std_logic;
		clocking_rst_switch: in std_logic;
		FROM_SWITCH_DST_RDY_N: out std_logic;
		FROM_SWITCH_FWD_SOP_N: out std_logic;
		FROM_SWITCH_FWD_EOP_N: out std_logic;
		FROM_SWITCH_FWD_SRC_RDY_N: out std_logic;
		FROM_SWITCH_FWD_DATA: out std_logic_vector(31 downto 0);
		TO_SWITCH_SOP_N: out std_logic;
		TO_SWITCH_EOP_N: out std_logic;
		TO_SWITCH_SRC_RDY_N: out std_logic;
		TO_SWITCH_DATA: out std_logic_vector(31 downto 0);
		TO_SWITCH_FWD_DST_RDY_N: out std_logic;
		clocking_fwd_clk_switch: out std_logic;
		clocking_fwd_rst_switch: out std_logic
	);
end MappedElementAdapterForwarder;

architecture MaxDC of MappedElementAdapterForwarder is
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
	
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	FROM_SWITCH_DST_RDY_N <= vec_to_bit(bit_to_vec(FROM_SWITCH_FWD_DST_RDY_N));
	FROM_SWITCH_FWD_SOP_N <= vec_to_bit(bit_to_vec(FROM_SWITCH_SOP_N));
	FROM_SWITCH_FWD_EOP_N <= vec_to_bit(bit_to_vec(FROM_SWITCH_EOP_N));
	FROM_SWITCH_FWD_SRC_RDY_N <= vec_to_bit(bit_to_vec(FROM_SWITCH_SRC_RDY_N));
	FROM_SWITCH_FWD_DATA <= FROM_SWITCH_DATA;
	TO_SWITCH_SOP_N <= vec_to_bit(bit_to_vec(TO_SWITCH_FWD_SOP_N));
	TO_SWITCH_EOP_N <= vec_to_bit(bit_to_vec(TO_SWITCH_FWD_EOP_N));
	TO_SWITCH_SRC_RDY_N <= vec_to_bit(bit_to_vec(TO_SWITCH_FWD_SRC_RDY_N));
	TO_SWITCH_DATA <= TO_SWITCH_FWD_DATA;
	TO_SWITCH_FWD_DST_RDY_N <= vec_to_bit(bit_to_vec(TO_SWITCH_DST_RDY_N));
	clocking_fwd_clk_switch <= vec_to_bit(bit_to_vec(clocking_clk_switch));
	clocking_fwd_rst_switch <= vec_to_bit(bit_to_vec(clocking_rst_switch));
	
	-- Register processes
	
	
	-- Entity instances
	
end MaxDC;
