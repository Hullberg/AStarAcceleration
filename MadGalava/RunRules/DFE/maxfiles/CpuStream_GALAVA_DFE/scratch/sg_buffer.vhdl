library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity sg_buffer is
	port (
		wea: in std_logic_vector(0 downto 0);
		addra: in std_logic_vector(8 downto 0);
		dina: in std_logic_vector(71 downto 0);
		clka: in std_logic;
		clkb: in std_logic;
		addrb: in std_logic_vector(8 downto 0);
		doutb: out std_logic_vector(71 downto 0)
	);
end sg_buffer;

architecture MaxDC of sg_buffer is
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
	component AlteraBlockMem_RAM_TWO_PORT_72x512_RAM_TWO_PORT_dck_ireg is
		port (
			wea: in std_logic_vector(0 downto 0);
			addra: in std_logic_vector(8 downto 0);
			dina: in std_logic_vector(71 downto 0);
			clka: in std_logic;
			clkb: in std_logic;
			addrb: in std_logic_vector(8 downto 0);
			doutb: out std_logic_vector(71 downto 0)
		);
	end component;
	
	-- Signal declarations
	
	signal wrapped_alterablockmem_ram_two_port_72x512_ram_two_port_dck_ireg_doutb : std_logic_vector(71 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	doutb <= wrapped_alterablockmem_ram_two_port_72x512_ram_two_port_dck_ireg_doutb;
	
	-- Register processes
	
	
	-- Entity instances
	
	wrapped_AlteraBlockMem_RAM_TWO_PORT_72x512_RAM_TWO_PORT_dck_ireg : AlteraBlockMem_RAM_TWO_PORT_72x512_RAM_TWO_PORT_dck_ireg
		port map (
			doutb => wrapped_alterablockmem_ram_two_port_72x512_ram_two_port_dck_ireg_doutb, -- 72 bits (out)
			wea => wea, -- 1 bits (in)
			addra => addra, -- 9 bits (in)
			dina => dina, -- 72 bits (in)
			clka => clka, -- 1 bits (in)
			clkb => clkb, -- 1 bits (in)
			addrb => addrb -- 9 bits (in)
		);
end MaxDC;
