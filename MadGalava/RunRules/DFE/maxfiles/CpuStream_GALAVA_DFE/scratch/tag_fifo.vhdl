library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity tag_fifo is
	port (
		clk: in std_logic;
		din: in std_logic_vector(4 downto 0);
		wr_en: in std_logic;
		rd_en: in std_logic;
		srst: in std_logic;
		dout: out std_logic_vector(4 downto 0);
		full: out std_logic;
		empty: out std_logic
	);
end tag_fifo;

architecture MaxDC of tag_fifo is
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
	component AlteraFifoEntity_5_64_5_fwft is
		port (
			clk: in std_logic;
			din: in std_logic_vector(4 downto 0);
			wr_en: in std_logic;
			rd_en: in std_logic;
			srst: in std_logic;
			dout: out std_logic_vector(4 downto 0);
			full: out std_logic;
			empty: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal wrapped_alterafifoentity_5_64_5_fwft_dout : std_logic_vector(4 downto 0);
	signal wrapped_alterafifoentity_5_64_5_fwft_full : std_logic_vector(0 downto 0);
	signal wrapped_alterafifoentity_5_64_5_fwft_empty : std_logic_vector(0 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	dout <= wrapped_alterafifoentity_5_64_5_fwft_dout;
	full <= vec_to_bit(wrapped_alterafifoentity_5_64_5_fwft_full);
	empty <= vec_to_bit(wrapped_alterafifoentity_5_64_5_fwft_empty);
	
	-- Register processes
	
	
	-- Entity instances
	
	wrapped_AlteraFifoEntity_5_64_5_fwft : AlteraFifoEntity_5_64_5_fwft
		port map (
			dout => wrapped_alterafifoentity_5_64_5_fwft_dout, -- 5 bits (out)
			full => wrapped_alterafifoentity_5_64_5_fwft_full(0), -- 1 bits (out)
			empty => wrapped_alterafifoentity_5_64_5_fwft_empty(0), -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			din => din, -- 5 bits (in)
			wr_en => wr_en, -- 1 bits (in)
			rd_en => rd_en, -- 1 bits (in)
			srst => srst -- 1 bits (in)
		);
end MaxDC;
