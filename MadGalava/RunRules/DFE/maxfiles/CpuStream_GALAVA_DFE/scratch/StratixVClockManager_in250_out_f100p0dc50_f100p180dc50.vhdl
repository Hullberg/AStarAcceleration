library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity StratixVClockManager_in250_out_f100p0dc50_f100p180dc50 is
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
end StratixVClockManager_in250_out_f100p0dc50_f100p180dc50;

architecture MaxDC of StratixVClockManager_in250_out_f100p0dc50_f100p180dc50 is
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
	component altera_pll is
		generic (
			fractional_vco_multiplier : string;
			reference_clock_frequency : string;
			operation_mode : string;
			number_of_clocks : integer;
			output_clock_frequency0 : string;
			phase_shift0 : string;
			duty_cycle0 : integer;
			output_clock_frequency1 : string;
			phase_shift1 : string;
			duty_cycle1 : integer;
			output_clock_frequency2 : string;
			phase_shift2 : string;
			duty_cycle2 : integer;
			output_clock_frequency3 : string;
			phase_shift3 : string;
			duty_cycle3 : integer;
			output_clock_frequency4 : string;
			phase_shift4 : string;
			duty_cycle4 : integer;
			output_clock_frequency5 : string;
			phase_shift5 : string;
			duty_cycle5 : integer;
			output_clock_frequency6 : string;
			phase_shift6 : string;
			duty_cycle6 : integer;
			output_clock_frequency7 : string;
			phase_shift7 : string;
			duty_cycle7 : integer;
			output_clock_frequency8 : string;
			phase_shift8 : string;
			duty_cycle8 : integer;
			output_clock_frequency9 : string;
			phase_shift9 : string;
			duty_cycle9 : integer;
			output_clock_frequency10 : string;
			phase_shift10 : string;
			duty_cycle10 : integer;
			output_clock_frequency11 : string;
			phase_shift11 : string;
			duty_cycle11 : integer;
			output_clock_frequency12 : string;
			phase_shift12 : string;
			duty_cycle12 : integer;
			output_clock_frequency13 : string;
			phase_shift13 : string;
			duty_cycle13 : integer;
			output_clock_frequency14 : string;
			phase_shift14 : string;
			duty_cycle14 : integer;
			output_clock_frequency15 : string;
			phase_shift15 : string;
			duty_cycle15 : integer;
			output_clock_frequency16 : string;
			phase_shift16 : string;
			duty_cycle16 : integer;
			output_clock_frequency17 : string;
			phase_shift17 : string;
			duty_cycle17 : integer;
			pll_type : string;
			m_cnt_hi_div : integer;
			m_cnt_lo_div : integer;
			n_cnt_hi_div : integer;
			n_cnt_lo_div : integer;
			m_cnt_bypass_en : string;
			n_cnt_bypass_en : string;
			m_cnt_odd_div_duty_en : string;
			n_cnt_odd_div_duty_en : string;
			c_cnt_hi_div0 : integer;
			c_cnt_lo_div0 : integer;
			c_cnt_prst0 : integer;
			c_cnt_ph_mux_prst0 : integer;
			c_cnt_bypass_en0 : string;
			c_cnt_odd_div_duty_en0 : string;
			c_cnt_hi_div1 : integer;
			c_cnt_lo_div1 : integer;
			c_cnt_prst1 : integer;
			c_cnt_ph_mux_prst1 : integer;
			c_cnt_bypass_en1 : string;
			c_cnt_odd_div_duty_en1 : string;
			c_cnt_hi_div2 : integer;
			c_cnt_lo_div2 : integer;
			c_cnt_prst2 : integer;
			c_cnt_ph_mux_prst2 : integer;
			c_cnt_bypass_en2 : string;
			c_cnt_odd_div_duty_en2 : string;
			c_cnt_hi_div3 : integer;
			c_cnt_lo_div3 : integer;
			c_cnt_prst3 : integer;
			c_cnt_ph_mux_prst3 : integer;
			c_cnt_bypass_en3 : string;
			c_cnt_odd_div_duty_en3 : string;
			c_cnt_hi_div4 : integer;
			c_cnt_lo_div4 : integer;
			c_cnt_prst4 : integer;
			c_cnt_ph_mux_prst4 : integer;
			c_cnt_bypass_en4 : string;
			c_cnt_odd_div_duty_en4 : string;
			c_cnt_hi_div5 : integer;
			c_cnt_lo_div5 : integer;
			c_cnt_prst5 : integer;
			c_cnt_ph_mux_prst5 : integer;
			c_cnt_bypass_en5 : string;
			c_cnt_odd_div_duty_en5 : string;
			c_cnt_hi_div6 : integer;
			c_cnt_lo_div6 : integer;
			c_cnt_prst6 : integer;
			c_cnt_ph_mux_prst6 : integer;
			c_cnt_bypass_en6 : string;
			c_cnt_odd_div_duty_en6 : string;
			c_cnt_hi_div7 : integer;
			c_cnt_lo_div7 : integer;
			c_cnt_prst7 : integer;
			c_cnt_ph_mux_prst7 : integer;
			c_cnt_bypass_en7 : string;
			c_cnt_odd_div_duty_en7 : string;
			c_cnt_hi_div8 : integer;
			c_cnt_lo_div8 : integer;
			c_cnt_prst8 : integer;
			c_cnt_ph_mux_prst8 : integer;
			c_cnt_bypass_en8 : string;
			c_cnt_odd_div_duty_en8 : string;
			c_cnt_hi_div9 : integer;
			c_cnt_lo_div9 : integer;
			c_cnt_prst9 : integer;
			c_cnt_ph_mux_prst9 : integer;
			c_cnt_bypass_en9 : string;
			c_cnt_odd_div_duty_en9 : string;
			c_cnt_hi_div10 : integer;
			c_cnt_lo_div10 : integer;
			c_cnt_prst10 : integer;
			c_cnt_ph_mux_prst10 : integer;
			c_cnt_bypass_en10 : string;
			c_cnt_odd_div_duty_en10 : string;
			c_cnt_hi_div11 : integer;
			c_cnt_lo_div11 : integer;
			c_cnt_prst11 : integer;
			c_cnt_ph_mux_prst11 : integer;
			c_cnt_bypass_en11 : string;
			c_cnt_odd_div_duty_en11 : string;
			c_cnt_hi_div12 : integer;
			c_cnt_lo_div12 : integer;
			c_cnt_prst12 : integer;
			c_cnt_ph_mux_prst12 : integer;
			c_cnt_bypass_en12 : string;
			c_cnt_odd_div_duty_en12 : string;
			c_cnt_hi_div13 : integer;
			c_cnt_lo_div13 : integer;
			c_cnt_prst13 : integer;
			c_cnt_ph_mux_prst13 : integer;
			c_cnt_bypass_en13 : string;
			c_cnt_odd_div_duty_en13 : string;
			c_cnt_hi_div14 : integer;
			c_cnt_lo_div14 : integer;
			c_cnt_prst14 : integer;
			c_cnt_ph_mux_prst14 : integer;
			c_cnt_bypass_en14 : string;
			c_cnt_odd_div_duty_en14 : string;
			c_cnt_hi_div15 : integer;
			c_cnt_lo_div15 : integer;
			c_cnt_prst15 : integer;
			c_cnt_ph_mux_prst15 : integer;
			c_cnt_bypass_en15 : string;
			c_cnt_odd_div_duty_en15 : string;
			c_cnt_hi_div16 : integer;
			c_cnt_lo_div16 : integer;
			c_cnt_prst16 : integer;
			c_cnt_ph_mux_prst16 : integer;
			c_cnt_bypass_en16 : string;
			c_cnt_odd_div_duty_en16 : string;
			c_cnt_hi_div17 : integer;
			c_cnt_lo_div17 : integer;
			c_cnt_prst17 : integer;
			c_cnt_ph_mux_prst17 : integer;
			c_cnt_bypass_en17 : string;
			c_cnt_odd_div_duty_en17 : string;
			pll_output_clk_frequency : string;
			pll_vco_div : integer;
			pll_cp_current : integer;
			pll_bwctrl : integer;
			pll_fractional_division : string
		);
		port (
			refclk: in std_logic;
			fbclk: in std_logic;
			rst: in std_logic;
			reconfig_to_pll: in std_logic_vector(63 downto 0);
			zdbfbclk: inout std_logic;
			outclk: out std_logic_vector(1 downto 0);
			fboutclk: out std_logic;
			locked: out std_logic;
			reconfig_from_pll: out std_logic_vector(63 downto 0)
		);
	end component;
	attribute box_type of altera_pll : component is "BLACK_BOX";
	component altera_pll_reconfig_top is
		port (
			mgmt_clk: in std_logic;
			mgmt_reset: in std_logic;
			reconfig_from_pll: in std_logic_vector(63 downto 0);
			mgmt_address: in std_logic_vector(5 downto 0);
			mgmt_read: in std_logic;
			mgmt_write: in std_logic;
			mgmt_writedata: in std_logic_vector(31 downto 0);
			reconfig_to_pll: out std_logic_vector(63 downto 0);
			mgmt_readdata: out std_logic_vector(31 downto 0);
			mgmt_waitrequest: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal altera_pll_i_outclk : std_logic_vector(1 downto 0);
	signal altera_pll_i_fboutclk : std_logic_vector(0 downto 0);
	signal altera_pll_i_locked : std_logic_vector(0 downto 0);
	signal altera_pll_i_reconfig_from_pll : std_logic_vector(63 downto 0);
	signal altera_pll_reconfig_i_reconfig_to_pll : std_logic_vector(63 downto 0);
	signal altera_pll_reconfig_i_mgmt_readdata : std_logic_vector(31 downto 0);
	signal altera_pll_reconfig_i_mgmt_waitrequest : std_logic_vector(0 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	clock_0 <= vec_to_bit(slice(altera_pll_i_outclk, 0, 1));
	clock_1 <= vec_to_bit(slice(altera_pll_i_outclk, 1, 1));
	pll_locked <= vec_to_bit(altera_pll_i_locked);
	pll_mgmt_readdata <= altera_pll_reconfig_i_mgmt_readdata;
	pll_mgmt_waitrequest <= vec_to_bit(altera_pll_reconfig_i_mgmt_waitrequest);
	
	-- Register processes
	
	
	-- Entity instances
	
	altera_pll_i : altera_pll
		generic map (
			fractional_vco_multiplier => "false",
			reference_clock_frequency => "250.0 MHz",
			operation_mode => "normal",
			number_of_clocks => 2,
			output_clock_frequency0 => "100.0 MHz",
			phase_shift0 => "0 ps",
			duty_cycle0 => 50,
			output_clock_frequency1 => "100.0 MHz",
			phase_shift1 => "5000 ps",
			duty_cycle1 => 50,
			output_clock_frequency2 => "0 MHz",
			phase_shift2 => "0 ps",
			duty_cycle2 => 50,
			output_clock_frequency3 => "0 MHz",
			phase_shift3 => "0 ps",
			duty_cycle3 => 50,
			output_clock_frequency4 => "0 MHz",
			phase_shift4 => "0 ps",
			duty_cycle4 => 50,
			output_clock_frequency5 => "0 MHz",
			phase_shift5 => "0 ps",
			duty_cycle5 => 50,
			output_clock_frequency6 => "0 MHz",
			phase_shift6 => "0 ps",
			duty_cycle6 => 50,
			output_clock_frequency7 => "0 MHz",
			phase_shift7 => "0 ps",
			duty_cycle7 => 50,
			output_clock_frequency8 => "0 MHz",
			phase_shift8 => "0 ps",
			duty_cycle8 => 50,
			output_clock_frequency9 => "0 MHz",
			phase_shift9 => "0 ps",
			duty_cycle9 => 50,
			output_clock_frequency10 => "0 MHz",
			phase_shift10 => "0 ps",
			duty_cycle10 => 50,
			output_clock_frequency11 => "0 MHz",
			phase_shift11 => "0 ps",
			duty_cycle11 => 50,
			output_clock_frequency12 => "0 MHz",
			phase_shift12 => "0 ps",
			duty_cycle12 => 50,
			output_clock_frequency13 => "0 MHz",
			phase_shift13 => "0 ps",
			duty_cycle13 => 50,
			output_clock_frequency14 => "0 MHz",
			phase_shift14 => "0 ps",
			duty_cycle14 => 50,
			output_clock_frequency15 => "0 MHz",
			phase_shift15 => "0 ps",
			duty_cycle15 => 50,
			output_clock_frequency16 => "0 MHz",
			phase_shift16 => "0 ps",
			duty_cycle16 => 50,
			output_clock_frequency17 => "0 MHz",
			phase_shift17 => "0 ps",
			duty_cycle17 => 50,
			pll_type => "General",
			m_cnt_hi_div => 1,
			m_cnt_lo_div => 1,
			n_cnt_hi_div => 1,
			n_cnt_lo_div => 1,
			m_cnt_bypass_en => "true",
			n_cnt_bypass_en => "true",
			m_cnt_odd_div_duty_en => "false",
			n_cnt_odd_div_duty_en => "false",
			c_cnt_hi_div0 => 1,
			c_cnt_lo_div0 => 1,
			c_cnt_prst0 => 1,
			c_cnt_ph_mux_prst0 => 0,
			c_cnt_bypass_en0 => "false",
			c_cnt_odd_div_duty_en0 => "false",
			c_cnt_hi_div1 => 1,
			c_cnt_lo_div1 => 1,
			c_cnt_prst1 => 1,
			c_cnt_ph_mux_prst1 => 0,
			c_cnt_bypass_en1 => "false",
			c_cnt_odd_div_duty_en1 => "false",
			c_cnt_hi_div2 => 1,
			c_cnt_lo_div2 => 1,
			c_cnt_prst2 => 1,
			c_cnt_ph_mux_prst2 => 0,
			c_cnt_bypass_en2 => "false",
			c_cnt_odd_div_duty_en2 => "false",
			c_cnt_hi_div3 => 1,
			c_cnt_lo_div3 => 1,
			c_cnt_prst3 => 1,
			c_cnt_ph_mux_prst3 => 0,
			c_cnt_bypass_en3 => "false",
			c_cnt_odd_div_duty_en3 => "false",
			c_cnt_hi_div4 => 1,
			c_cnt_lo_div4 => 1,
			c_cnt_prst4 => 1,
			c_cnt_ph_mux_prst4 => 0,
			c_cnt_bypass_en4 => "false",
			c_cnt_odd_div_duty_en4 => "false",
			c_cnt_hi_div5 => 1,
			c_cnt_lo_div5 => 1,
			c_cnt_prst5 => 1,
			c_cnt_ph_mux_prst5 => 0,
			c_cnt_bypass_en5 => "false",
			c_cnt_odd_div_duty_en5 => "false",
			c_cnt_hi_div6 => 1,
			c_cnt_lo_div6 => 1,
			c_cnt_prst6 => 1,
			c_cnt_ph_mux_prst6 => 0,
			c_cnt_bypass_en6 => "false",
			c_cnt_odd_div_duty_en6 => "false",
			c_cnt_hi_div7 => 1,
			c_cnt_lo_div7 => 1,
			c_cnt_prst7 => 1,
			c_cnt_ph_mux_prst7 => 0,
			c_cnt_bypass_en7 => "false",
			c_cnt_odd_div_duty_en7 => "false",
			c_cnt_hi_div8 => 1,
			c_cnt_lo_div8 => 1,
			c_cnt_prst8 => 1,
			c_cnt_ph_mux_prst8 => 0,
			c_cnt_bypass_en8 => "false",
			c_cnt_odd_div_duty_en8 => "false",
			c_cnt_hi_div9 => 1,
			c_cnt_lo_div9 => 1,
			c_cnt_prst9 => 1,
			c_cnt_ph_mux_prst9 => 0,
			c_cnt_bypass_en9 => "false",
			c_cnt_odd_div_duty_en9 => "false",
			c_cnt_hi_div10 => 1,
			c_cnt_lo_div10 => 1,
			c_cnt_prst10 => 1,
			c_cnt_ph_mux_prst10 => 0,
			c_cnt_bypass_en10 => "false",
			c_cnt_odd_div_duty_en10 => "false",
			c_cnt_hi_div11 => 1,
			c_cnt_lo_div11 => 1,
			c_cnt_prst11 => 1,
			c_cnt_ph_mux_prst11 => 0,
			c_cnt_bypass_en11 => "false",
			c_cnt_odd_div_duty_en11 => "false",
			c_cnt_hi_div12 => 1,
			c_cnt_lo_div12 => 1,
			c_cnt_prst12 => 1,
			c_cnt_ph_mux_prst12 => 0,
			c_cnt_bypass_en12 => "false",
			c_cnt_odd_div_duty_en12 => "false",
			c_cnt_hi_div13 => 1,
			c_cnt_lo_div13 => 1,
			c_cnt_prst13 => 1,
			c_cnt_ph_mux_prst13 => 0,
			c_cnt_bypass_en13 => "false",
			c_cnt_odd_div_duty_en13 => "false",
			c_cnt_hi_div14 => 1,
			c_cnt_lo_div14 => 1,
			c_cnt_prst14 => 1,
			c_cnt_ph_mux_prst14 => 0,
			c_cnt_bypass_en14 => "false",
			c_cnt_odd_div_duty_en14 => "false",
			c_cnt_hi_div15 => 1,
			c_cnt_lo_div15 => 1,
			c_cnt_prst15 => 1,
			c_cnt_ph_mux_prst15 => 0,
			c_cnt_bypass_en15 => "false",
			c_cnt_odd_div_duty_en15 => "false",
			c_cnt_hi_div16 => 1,
			c_cnt_lo_div16 => 1,
			c_cnt_prst16 => 1,
			c_cnt_ph_mux_prst16 => 0,
			c_cnt_bypass_en16 => "false",
			c_cnt_odd_div_duty_en16 => "false",
			c_cnt_hi_div17 => 1,
			c_cnt_lo_div17 => 1,
			c_cnt_prst17 => 1,
			c_cnt_ph_mux_prst17 => 0,
			c_cnt_bypass_en17 => "false",
			c_cnt_odd_div_duty_en17 => "false",
			pll_output_clk_frequency => "0 MHz",
			pll_vco_div => 1,
			pll_cp_current => 5,
			pll_bwctrl => 18000,
			pll_fractional_division => "1"
		)
		port map (
			outclk => altera_pll_i_outclk, -- 2 bits (out)
			fboutclk => altera_pll_i_fboutclk(0), -- 1 bits (out)
			locked => altera_pll_i_locked(0), -- 1 bits (out)
			reconfig_from_pll => altera_pll_i_reconfig_from_pll, -- 64 bits (out)
			refclk => input_clock, -- 1 bits (in)
			fbclk => vec_to_bit("0"), -- 1 bits (in)
			rst => pll_rst, -- 1 bits (in)
			reconfig_to_pll => altera_pll_reconfig_i_reconfig_to_pll -- 64 bits (in)
		);
	altera_pll_reconfig_i : altera_pll_reconfig_top
		port map (
			reconfig_to_pll => altera_pll_reconfig_i_reconfig_to_pll, -- 64 bits (out)
			mgmt_readdata => altera_pll_reconfig_i_mgmt_readdata, -- 32 bits (out)
			mgmt_waitrequest => altera_pll_reconfig_i_mgmt_waitrequest(0), -- 1 bits (out)
			mgmt_clk => pll_mgmt_clk, -- 1 bits (in)
			mgmt_reset => pll_mgmt_rst, -- 1 bits (in)
			reconfig_from_pll => altera_pll_i_reconfig_from_pll, -- 64 bits (in)
			mgmt_address => pll_mgmt_address, -- 6 bits (in)
			mgmt_read => pll_mgmt_read, -- 1 bits (in)
			mgmt_write => pll_mgmt_write, -- 1 bits (in)
			mgmt_writedata => pll_mgmt_writedata -- 32 bits (in)
		);
end MaxDC;
