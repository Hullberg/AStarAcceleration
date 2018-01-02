library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity mec_switch_arbiter_i is
	port (
		clk_pcie: in std_logic;
		rst_pcie_n: in std_logic;
		clk_switch: in std_logic;
		rst_switch: in std_logic;
		requests: in std_logic_vector(15 downto 0);
		evaluate: in std_logic;
		selects: out std_logic_vector(15 downto 0);
		selected_index: out std_logic_vector(3 downto 0);
		ready: out std_logic
	);
end mec_switch_arbiter_i;

architecture MaxDC of mec_switch_arbiter_i is
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
	component mec_switch_arbiter is
		generic (
			NUM_REQUESTERS : integer;
			NUM_REQUESTERS_WIDTH : integer
		);
		port (
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			clk_switch: in std_logic;
			rst_switch: in std_logic;
			requests: in std_logic_vector(15 downto 0);
			evaluate: in std_logic;
			selects: out std_logic_vector(15 downto 0);
			selected_index: out std_logic_vector(3 downto 0);
			ready: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal wrapped_mec_switch_arbiter_selects : std_logic_vector(15 downto 0);
	signal wrapped_mec_switch_arbiter_selected_index : std_logic_vector(3 downto 0);
	signal wrapped_mec_switch_arbiter_ready : std_logic_vector(0 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	selects <= wrapped_mec_switch_arbiter_selects;
	selected_index <= wrapped_mec_switch_arbiter_selected_index;
	ready <= vec_to_bit(wrapped_mec_switch_arbiter_ready);
	
	-- Register processes
	
	
	-- Entity instances
	
	wrapped_mec_switch_arbiter : mec_switch_arbiter
		generic map (
			NUM_REQUESTERS => 16,
			NUM_REQUESTERS_WIDTH => 4
		)
		port map (
			selects => wrapped_mec_switch_arbiter_selects, -- 16 bits (out)
			selected_index => wrapped_mec_switch_arbiter_selected_index, -- 4 bits (out)
			ready => wrapped_mec_switch_arbiter_ready(0), -- 1 bits (out)
			clk_pcie => clk_pcie, -- 1 bits (in)
			rst_pcie_n => rst_pcie_n, -- 1 bits (in)
			clk_switch => clk_switch, -- 1 bits (in)
			rst_switch => rst_switch, -- 1 bits (in)
			requests => requests, -- 16 bits (in)
			evaluate => evaluate -- 1 bits (in)
		);
end MaxDC;
