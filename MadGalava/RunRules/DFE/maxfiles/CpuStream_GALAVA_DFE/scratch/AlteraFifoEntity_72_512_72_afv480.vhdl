library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
library altera_mf;
use altera_mf.all;

entity AlteraFifoEntity_72_512_72_afv480 is
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
end AlteraFifoEntity_72_512_72_afv480;

architecture MaxDC of AlteraFifoEntity_72_512_72_afv480 is
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
	component scfifo is
		generic (
			lpm_width : integer;
			lpm_widthu : integer;
			lpm_numwords : integer;
			lpm_showahead : string;
			lpm_type : string;
			overflow_checking : string;
			underflow_checking : string;
			use_eab : string;
			intended_device_family : string;
			almost_full_value : integer
		);
		port (
			data: in std_logic_vector(71 downto 0);
			wrreq: in std_logic;
			rdreq: in std_logic;
			clock: in std_logic;
			sclr: in std_logic;
			q: out std_logic_vector(71 downto 0);
			full: out std_logic;
			empty: out std_logic;
			almost_full: out std_logic
		);
	end component;
	attribute box_type of scfifo : component is "BLACK_BOX";
	
	-- Signal declarations
	
	signal inst_ln44_mwfifo_q : std_logic_vector(71 downto 0);
	signal inst_ln44_mwfifo_full : std_logic_vector(0 downto 0);
	signal inst_ln44_mwfifo_empty : std_logic_vector(0 downto 0);
	signal inst_ln44_mwfifo_almost_full : std_logic_vector(0 downto 0);
	signal sig : std_logic_vector(0 downto 0);
	signal sig1 : std_logic_vector(0 downto 0);
	signal sig2 : std_logic_vector(0 downto 0);
	signal sig3 : std_logic_vector(0 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	sig <= bit_to_vec(wr_en);
	sig1 <= bit_to_vec(rd_en);
	sig2 <= inst_ln44_mwfifo_full;
	sig3 <= inst_ln44_mwfifo_empty;
	dout <= inst_ln44_mwfifo_q;
	full <= vec_to_bit(sig2);
	empty <= vec_to_bit(sig3);
	prog_full <= vec_to_bit(inst_ln44_mwfifo_almost_full);
	
	-- Register processes
	
	
	-- Entity instances
	
	inst_ln44_mwfifo : scfifo
		generic map (
			lpm_width => 72,
			lpm_widthu => 9,
			lpm_numwords => 512,
			lpm_showahead => "OFF",
			lpm_type => "SCFIFO",
			overflow_checking => "ON",
			underflow_checking => "ON",
			use_eab => "ON",
			intended_device_family => "Stratix V",
			almost_full_value => 480
		)
		port map (
			q => inst_ln44_mwfifo_q, -- 72 bits (out)
			full => inst_ln44_mwfifo_full(0), -- 1 bits (out)
			empty => inst_ln44_mwfifo_empty(0), -- 1 bits (out)
			almost_full => inst_ln44_mwfifo_almost_full(0), -- 1 bits (out)
			data => din, -- 72 bits (in)
			wrreq => vec_to_bit(sig), -- 1 bits (in)
			rdreq => vec_to_bit(sig1), -- 1 bits (in)
			clock => clk, -- 1 bits (in)
			sclr => srst -- 1 bits (in)
		);
end MaxDC;
