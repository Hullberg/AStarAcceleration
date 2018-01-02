library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity TransceiverReconfig is
	port (
		reconfig_from_xcvr: in std_logic_vector(459 downto 0);
		npor: in std_logic;
		reconfig_xcvr_clk: in std_logic;
		reconfig_to_xcvr: out std_logic_vector(699 downto 0);
		reconfig_busy: out std_logic
	);
end TransceiverReconfig;

architecture MaxDC of TransceiverReconfig is
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
	component pcie_xcvr_reconfig_SV is
		port (
			npor: in std_logic;
			reconfig_xcvr_clk: in std_logic;
			reconfig_from_xcvr: in std_logic_vector(459 downto 0);
			reconfig_busy: out std_logic;
			reconfig_to_xcvr: out std_logic_vector(699 downto 0)
		);
	end component;
	
	-- Signal declarations
	
	signal inst_ln13_tranceiverreconfigext_v13_1_reconfig_busy : std_logic_vector(0 downto 0);
	signal inst_ln13_tranceiverreconfigext_v13_1_reconfig_to_xcvr : std_logic_vector(699 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	reconfig_to_xcvr <= inst_ln13_tranceiverreconfigext_v13_1_reconfig_to_xcvr;
	reconfig_busy <= vec_to_bit(inst_ln13_tranceiverreconfigext_v13_1_reconfig_busy);
	
	-- Register processes
	
	
	-- Entity instances
	
	inst_ln13_tranceiverreconfigext_v13_1 : pcie_xcvr_reconfig_SV
		port map (
			reconfig_busy => inst_ln13_tranceiverreconfigext_v13_1_reconfig_busy(0), -- 1 bits (out)
			reconfig_to_xcvr => inst_ln13_tranceiverreconfigext_v13_1_reconfig_to_xcvr, -- 700 bits (out)
			npor => npor, -- 1 bits (in)
			reconfig_xcvr_clk => reconfig_xcvr_clk, -- 1 bits (in)
			reconfig_from_xcvr => reconfig_from_xcvr -- 460 bits (in)
		);
end MaxDC;
