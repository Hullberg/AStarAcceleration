library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity MAXEvents is
	port (
		clk: in std_logic;
		rst: in std_logic;
		PMBUS_ALERT: in std_logic;
		DDR_EVENT_B: in std_logic;
		AUX_EVENT: in std_logic;
		DDR_VREFDQ_RIGHT_POWER_GOOD: in std_logic;
		DDR_VREFDQ_LEFT_POWER_GOOD: in std_logic;
		CTL1_POWER_GOOD: in std_logic;
		CTL2_POWER_GOOD: in std_logic;
		host_event_ack: in std_logic_vector(96 downto 0);
		host_event_status: out std_logic_vector(96 downto 0);
		warning_led: out std_logic
	);
end MAXEvents;

architecture MaxDC of MAXEvents is
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
	component max_events is
		generic (
			EVENT_NUM : integer;
			IS_MAX4N : boolean
		);
		port (
			rst: in std_logic;
			clk: in std_logic;
			PMBUS_ALERT: in std_logic;
			DDR_EVENT_B: in std_logic;
			DDR_VREFCA_POWER_GOOD: in std_logic;
			DDR_VREFDQ_RIGHT_POWER_GOOD: in std_logic;
			DDR_VREFDQ_LEFT_POWER_GOOD: in std_logic;
			CTL1_POWER_GOOD: in std_logic;
			CTL2_POWER_GOOD: in std_logic;
			AUX_EVENT: in std_logic;
			MAX4N_QSFP_INTL: in std_logic_vector(7 downto 0);
			MAX4N_PHY_MDINT_N: in std_logic;
			MAX4N_NETWORK_PHY_INTL: in std_logic_vector(31 downto 0);
			MAX4N_QSFP_MODPRSL: in std_logic_vector(7 downto 0);
			host_event_ack: in std_logic_vector(EVENT_NUM-1 downto 0);
			host_event_status: out std_logic_vector(EVENT_NUM-1 downto 0);
			warning_led: out std_logic
		);
	end component;
	component vhdl_bus_synchronizer is
		generic (
			width : integer
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			dat_i: in std_logic_vector(width-1 downto 0);
			dat_o: out std_logic_vector(width-1 downto 0)
		);
	end component;
	attribute box_type of vhdl_bus_synchronizer : component is "BLACK_BOX";
	
	-- Signal declarations
	
	signal inst_ln92_maxevents_host_event_status : std_logic_vector(96 downto 0);
	signal inst_ln92_maxevents_warning_led : std_logic_vector(0 downto 0);
	signal inst_ln11_bussynchroniser_dat_o : std_logic_vector(0 downto 0);
	signal inst_ln11_bussynchroniser1_dat_o : std_logic_vector(0 downto 0);
	signal inst_ln11_bussynchroniser2_dat_o : std_logic_vector(0 downto 0);
	signal inst_ln11_bussynchroniser3_dat_o : std_logic_vector(0 downto 0);
	signal inst_ln11_bussynchroniser4_dat_o : std_logic_vector(0 downto 0);
	signal inst_ln11_bussynchroniser5_dat_o : std_logic_vector(0 downto 0);
	signal inst_ln11_bussynchroniser6_dat_o : std_logic_vector(0 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	host_event_status <= inst_ln92_maxevents_host_event_status;
	warning_led <= vec_to_bit(inst_ln92_maxevents_warning_led);
	
	-- Register processes
	
	
	-- Entity instances
	
	inst_ln92_maxevents : max_events
		generic map (
			EVENT_NUM => 97,
			IS_MAX4N => false
		)
		port map (
			host_event_status => inst_ln92_maxevents_host_event_status, -- 97 bits (out)
			warning_led => inst_ln92_maxevents_warning_led(0), -- 1 bits (out)
			rst => rst, -- 1 bits (in)
			clk => clk, -- 1 bits (in)
			PMBUS_ALERT => vec_to_bit(inst_ln11_bussynchroniser_dat_o), -- 1 bits (in)
			DDR_EVENT_B => vec_to_bit(inst_ln11_bussynchroniser1_dat_o), -- 1 bits (in)
			DDR_VREFCA_POWER_GOOD => vec_to_bit("1"), -- 1 bits (in)
			DDR_VREFDQ_RIGHT_POWER_GOOD => vec_to_bit(inst_ln11_bussynchroniser3_dat_o), -- 1 bits (in)
			DDR_VREFDQ_LEFT_POWER_GOOD => vec_to_bit(inst_ln11_bussynchroniser4_dat_o), -- 1 bits (in)
			CTL1_POWER_GOOD => vec_to_bit(inst_ln11_bussynchroniser5_dat_o), -- 1 bits (in)
			CTL2_POWER_GOOD => vec_to_bit(inst_ln11_bussynchroniser6_dat_o), -- 1 bits (in)
			AUX_EVENT => vec_to_bit(inst_ln11_bussynchroniser2_dat_o), -- 1 bits (in)
			MAX4N_QSFP_INTL => "11111111", -- 8 bits (in)
			MAX4N_PHY_MDINT_N => vec_to_bit("1"), -- 1 bits (in)
			MAX4N_NETWORK_PHY_INTL => "11111111111111111111111111111111", -- 32 bits (in)
			MAX4N_QSFP_MODPRSL => "11111111", -- 8 bits (in)
			host_event_ack => host_event_ack -- 97 bits (in)
		);
	inst_ln11_bussynchroniser : vhdl_bus_synchronizer
		generic map (
			width => 1
		)
		port map (
			dat_o => inst_ln11_bussynchroniser_dat_o, -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => bit_to_vec(PMBUS_ALERT) -- 1 bits (in)
		);
	inst_ln11_bussynchroniser1 : vhdl_bus_synchronizer
		generic map (
			width => 1
		)
		port map (
			dat_o => inst_ln11_bussynchroniser1_dat_o, -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => bit_to_vec(DDR_EVENT_B) -- 1 bits (in)
		);
	inst_ln11_bussynchroniser2 : vhdl_bus_synchronizer
		generic map (
			width => 1
		)
		port map (
			dat_o => inst_ln11_bussynchroniser2_dat_o, -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => bit_to_vec(AUX_EVENT) -- 1 bits (in)
		);
	inst_ln11_bussynchroniser3 : vhdl_bus_synchronizer
		generic map (
			width => 1
		)
		port map (
			dat_o => inst_ln11_bussynchroniser3_dat_o, -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => bit_to_vec(DDR_VREFDQ_RIGHT_POWER_GOOD) -- 1 bits (in)
		);
	inst_ln11_bussynchroniser4 : vhdl_bus_synchronizer
		generic map (
			width => 1
		)
		port map (
			dat_o => inst_ln11_bussynchroniser4_dat_o, -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => bit_to_vec(DDR_VREFDQ_LEFT_POWER_GOOD) -- 1 bits (in)
		);
	inst_ln11_bussynchroniser5 : vhdl_bus_synchronizer
		generic map (
			width => 1
		)
		port map (
			dat_o => inst_ln11_bussynchroniser5_dat_o, -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => bit_to_vec(CTL1_POWER_GOOD) -- 1 bits (in)
		);
	inst_ln11_bussynchroniser6 : vhdl_bus_synchronizer
		generic map (
			width => 1
		)
		port map (
			dat_o => inst_ln11_bussynchroniser6_dat_o, -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => bit_to_vec(CTL2_POWER_GOOD) -- 1 bits (in)
		);
end MaxDC;
