library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
library altera_mf;
use altera_mf.all;

entity pcie_tx_fifo is
	port (
		data: in std_logic_vector(131 downto 0);
		wrreq: in std_logic;
		rdreq: in std_logic;
		clock: in std_logic;
		sclr: in std_logic;
		q: out std_logic_vector(131 downto 0);
		full: out std_logic;
		empty: out std_logic;
		almost_full: out std_logic
	);
end pcie_tx_fifo;

architecture MaxDC of pcie_tx_fifo is
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
			data: in std_logic_vector(131 downto 0);
			wrreq: in std_logic;
			rdreq: in std_logic;
			clock: in std_logic;
			sclr: in std_logic;
			q: out std_logic_vector(131 downto 0);
			full: out std_logic;
			empty: out std_logic;
			almost_full: out std_logic
		);
	end component;
	attribute box_type of scfifo : component is "BLACK_BOX";
	
	-- Signal declarations
	
	signal wrapped_scfifo_q : std_logic_vector(131 downto 0);
	signal wrapped_scfifo_full : std_logic_vector(0 downto 0);
	signal wrapped_scfifo_empty : std_logic_vector(0 downto 0);
	signal wrapped_scfifo_almost_full : std_logic_vector(0 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	q <= wrapped_scfifo_q;
	full <= vec_to_bit(wrapped_scfifo_full);
	empty <= vec_to_bit(wrapped_scfifo_empty);
	almost_full <= vec_to_bit(wrapped_scfifo_almost_full);
	
	-- Register processes
	
	
	-- Entity instances
	
	wrapped_scfifo : scfifo
		generic map (
			lpm_width => 132,
			lpm_widthu => 9,
			lpm_numwords => 512,
			lpm_showahead => "OFF",
			lpm_type => "SCFIFO",
			overflow_checking => "ON",
			underflow_checking => "ON",
			use_eab => "ON",
			intended_device_family => "Stratix V",
			almost_full_value => 448
		)
		port map (
			q => wrapped_scfifo_q, -- 132 bits (out)
			full => wrapped_scfifo_full(0), -- 1 bits (out)
			empty => wrapped_scfifo_empty(0), -- 1 bits (out)
			almost_full => wrapped_scfifo_almost_full(0), -- 1 bits (out)
			data => data, -- 132 bits (in)
			wrreq => wrreq, -- 1 bits (in)
			rdreq => rdreq, -- 1 bits (in)
			clock => clock, -- 1 bits (in)
			sclr => sclr -- 1 bits (in)
		);
end MaxDC;
