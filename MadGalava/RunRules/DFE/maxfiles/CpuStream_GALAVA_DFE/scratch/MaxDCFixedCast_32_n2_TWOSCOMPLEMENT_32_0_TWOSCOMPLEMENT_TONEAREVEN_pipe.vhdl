library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity MaxDCFixedCast_32_n2_TWOSCOMPLEMENT_32_0_TWOSCOMPLEMENT_TONEAREVEN_pipe is
	port (
		clk: in std_logic;
		ce: in std_logic;
		i: in std_logic_vector(31 downto 0);
		o: out std_logic_vector(31 downto 0)
	);
end MaxDCFixedCast_32_n2_TWOSCOMPLEMENT_32_0_TWOSCOMPLEMENT_TONEAREVEN_pipe;

architecture MaxDC of MaxDCFixedCast_32_n2_TWOSCOMPLEMENT_32_0_TWOSCOMPLEMENT_TONEAREVEN_pipe is
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
	
	signal pipelinereg : std_logic_vector(30 downto 0) := "0000000000000000000000000000000";
	signal cat_ln327_maxdcfixedcast : std_logic_vector(0 downto 0);
	signal cat_ln329_maxdcfixedcast : std_logic_vector(32 downto 0);
	signal cat_ln327_maxdcfixedcast1 : std_logic_vector(0 downto 0);
	signal cat_ln329_maxdcfixedcast1 : std_logic_vector(31 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	cat_ln327_maxdcfixedcast<=slice(i, 31, 1);
	cat_ln329_maxdcfixedcast<=(cat_ln327_maxdcfixedcast & i);
	cat_ln327_maxdcfixedcast1<=slice(pipelinereg, 30, 1);
	cat_ln329_maxdcfixedcast1<=(cat_ln327_maxdcfixedcast1 & pipelinereg);
	o <= cat_ln329_maxdcfixedcast1;
	
	-- Register processes
	
	reg_process : process(clk)
	begin
		if rising_edge(clk) then
			if slv_to_slv(bit_to_vec(ce)) = "1" then
				pipelinereg <= (unsigned(slice(cat_ln329_maxdcfixedcast, 2, 31)) + unsigned((slice(cat_ln329_maxdcfixedcast, 1, 1) and (slice(cat_ln329_maxdcfixedcast, 0, 1) or slice(cat_ln329_maxdcfixedcast, 2, 1)))));
			end if;
		end if;
	end process;
	
	-- Entity instances
	
end MaxDC;
