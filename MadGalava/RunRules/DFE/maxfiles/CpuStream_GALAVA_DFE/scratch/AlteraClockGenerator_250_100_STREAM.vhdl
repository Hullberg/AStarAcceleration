library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity AlteraClockGenerator_250_100_STREAM is
	port (
		input_clk: in std_logic;
		pll_rst: in std_logic;
		clkbuf_clken: in std_logic;
		clkbuf_clksel: in std_logic_vector(1 downto 0);
		pll_mgmt_clk: in std_logic;
		pll_mgmt_rst: in std_logic;
		pll_mgmt_address: in std_logic_vector(5 downto 0);
		pll_mgmt_read: in std_logic;
		pll_mgmt_write: in std_logic;
		pll_mgmt_writedata: in std_logic_vector(31 downto 0);
		output_clk: out std_logic;
		output_clk_inv: out std_logic;
		pll_mgmt_readdata: out std_logic_vector(31 downto 0);
		pll_mgmt_waitrequest: out std_logic;
		locked: out std_logic
	);
end AlteraClockGenerator_250_100_STREAM;

architecture MaxDC of AlteraClockGenerator_250_100_STREAM is
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
	component StratixVClockManager_in250_out_f100p0dc50_f100p180dc50 is
		port (
			input_clock: in std_logic;
			pll_rst: in std_logic;
			pll_mgmt_clk: in std_logic;
			pll_mgmt_rst: in std_logic;
			pll_mgmt_address: in std_logic_vector(5 downto 0);
			pll_mgmt_read: in std_logic;
			pll_mgmt_write: in std_logic;
			pll_mgmt_writedata: in std_logic_vector(31 downto 0);
			clock_0: out std_logic;
			clock_1: out std_logic;
			pll_locked: out std_logic;
			pll_mgmt_readdata: out std_logic_vector(31 downto 0);
			pll_mgmt_waitrequest: out std_logic
		);
	end component;
	component MWAltClkCtrl_quartusv13_1_0_AUTO_numclk_1_ena is
		port (
			inclk: in std_logic;
			ena: in std_logic;
			outclk: out std_logic
		);
	end component;
	attribute box_type of MWAltClkCtrl_quartusv13_1_0_AUTO_numclk_1_ena : component is "BLACK_BOX";
	
	-- Signal declarations
	
	signal inst_ln11_clockmanager_clock_0 : std_logic_vector(0 downto 0);
	signal inst_ln11_clockmanager_clock_1 : std_logic_vector(0 downto 0);
	signal inst_ln11_clockmanager_pll_locked : std_logic_vector(0 downto 0);
	signal inst_ln11_clockmanager_pll_mgmt_readdata : std_logic_vector(31 downto 0);
	signal inst_ln11_clockmanager_pll_mgmt_waitrequest : std_logic_vector(0 downto 0);
	signal clockgen_altclkctrl_i_outclk : std_logic_vector(0 downto 0);
	signal clockgen_altclkctrl_inv_i_outclk : std_logic_vector(0 downto 0);
	signal clk0_bufg : std_logic_vector(0 downto 0);
	signal clk0_bufg_inv : std_logic_vector(0 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	clk0_bufg <= clockgen_altclkctrl_i_outclk;
	clk0_bufg_inv <= clockgen_altclkctrl_inv_i_outclk;
	output_clk <= vec_to_bit(clk0_bufg);
	output_clk_inv <= vec_to_bit(clk0_bufg_inv);
	pll_mgmt_readdata <= inst_ln11_clockmanager_pll_mgmt_readdata;
	pll_mgmt_waitrequest <= vec_to_bit(inst_ln11_clockmanager_pll_mgmt_waitrequest);
	locked <= vec_to_bit(inst_ln11_clockmanager_pll_locked);
	
	-- Register processes
	
	
	-- Entity instances
	
	inst_ln11_clockmanager : StratixVClockManager_in250_out_f100p0dc50_f100p180dc50
		port map (
			clock_0 => inst_ln11_clockmanager_clock_0(0), -- 1 bits (out)
			clock_1 => inst_ln11_clockmanager_clock_1(0), -- 1 bits (out)
			pll_locked => inst_ln11_clockmanager_pll_locked(0), -- 1 bits (out)
			pll_mgmt_readdata => inst_ln11_clockmanager_pll_mgmt_readdata, -- 32 bits (out)
			pll_mgmt_waitrequest => inst_ln11_clockmanager_pll_mgmt_waitrequest(0), -- 1 bits (out)
			input_clock => input_clk, -- 1 bits (in)
			pll_rst => pll_rst, -- 1 bits (in)
			pll_mgmt_clk => pll_mgmt_clk, -- 1 bits (in)
			pll_mgmt_rst => pll_mgmt_rst, -- 1 bits (in)
			pll_mgmt_address => pll_mgmt_address, -- 6 bits (in)
			pll_mgmt_read => pll_mgmt_read, -- 1 bits (in)
			pll_mgmt_write => pll_mgmt_write, -- 1 bits (in)
			pll_mgmt_writedata => pll_mgmt_writedata -- 32 bits (in)
		);
	clockgen_altclkctrl_i : MWAltClkCtrl_quartusv13_1_0_AUTO_numclk_1_ena
		port map (
			outclk => clockgen_altclkctrl_i_outclk(0), -- 1 bits (out)
			inclk => vec_to_bit(inst_ln11_clockmanager_clock_0), -- 1 bits (in)
			ena => clkbuf_clken -- 1 bits (in)
		);
	clockgen_altclkctrl_inv_i : MWAltClkCtrl_quartusv13_1_0_AUTO_numclk_1_ena
		port map (
			outclk => clockgen_altclkctrl_inv_i_outclk(0), -- 1 bits (out)
			inclk => vec_to_bit(inst_ln11_clockmanager_clock_1), -- 1 bits (in)
			ena => clkbuf_clken -- 1 bits (in)
		);
end MaxDC;
