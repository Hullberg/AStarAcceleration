library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity SGFifo is
	port (
		din: in std_logic_vector(71 downto 0);
		wr_en: in std_logic;
		rd_en: in std_logic;
		clk: in std_logic;
		rst: in std_logic;
		dout: out std_logic_vector(71 downto 0);
		empty: out std_logic;
		can_fetch: out std_logic
	);
end SGFifo;

architecture MaxDC of SGFifo is
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
	component AlteraFifoEntity_72_512_72_afv480 is
		port (
			clk: in std_logic;
			din: in std_logic_vector(71 downto 0);
			wr_en: in std_logic;
			rd_en: in std_logic;
			srst: in std_logic;
			dout: out std_logic_vector(71 downto 0);
			full: out std_logic;
			empty: out std_logic;
			prog_full: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal inst_ln47_alterafifo_dout : std_logic_vector(71 downto 0);
	signal inst_ln47_alterafifo_full : std_logic_vector(0 downto 0);
	signal inst_ln47_alterafifo_empty : std_logic_vector(0 downto 0);
	signal inst_ln47_alterafifo_prog_full : std_logic_vector(0 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	dout <= inst_ln47_alterafifo_dout;
	empty <= vec_to_bit(inst_ln47_alterafifo_empty);
	can_fetch <= vec_to_bit((not inst_ln47_alterafifo_prog_full));
	
	-- Register processes
	
	
	-- Entity instances
	
	inst_ln47_alterafifo : AlteraFifoEntity_72_512_72_afv480
		port map (
			dout => inst_ln47_alterafifo_dout, -- 72 bits (out)
			full => inst_ln47_alterafifo_full(0), -- 1 bits (out)
			empty => inst_ln47_alterafifo_empty(0), -- 1 bits (out)
			prog_full => inst_ln47_alterafifo_prog_full(0), -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			din => din, -- 72 bits (in)
			wr_en => wr_en, -- 1 bits (in)
			rd_en => rd_en, -- 1 bits (in)
			srst => rst -- 1 bits (in)
		);
end MaxDC;
