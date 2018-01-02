library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity ResponseDecoder is
	port (
		clk_pcie: in std_logic;
		rst_pcie_n: in std_logic;
		dma_response_data: in std_logic_vector(127 downto 0);
		dma_response_valid: in std_logic_vector(1 downto 0);
		dma_response_len: in std_logic_vector(9 downto 0);
		dma_response_tag: in std_logic_vector(7 downto 0);
		dma_response_complete: in std_logic;
		dma_response_ready: in std_logic;
		decoded_data: out std_logic_vector(127 downto 0);
		decoded_data_valid: out std_logic_vector(1 downto 0);
		decoded_tag: out std_logic_vector(7 downto 0);
		decoded_complete: out std_logic;
		decoded_ready: out std_logic
	);
end ResponseDecoder;

architecture MaxDC of ResponseDecoder is
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
	
	decoded_data <= dma_response_data;
	decoded_data_valid <= dma_response_valid;
	decoded_tag <= dma_response_tag;
	decoded_complete <= vec_to_bit(bit_to_vec(dma_response_complete));
	decoded_ready <= vec_to_bit(bit_to_vec(dma_response_ready));
	
	-- Register processes
	
	
	-- Entity instances
	
end MaxDC;
