library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.std_logic_misc.all;

library work;
use work.cross_clock_pkg.all;

entity max_events is
  generic(
    EVENT_NUM : integer := 8;
    IS_MAX4N  : boolean := false
  );
  port(
    rst                           : in  std_logic;
    clk                           : in  std_logic;

    PMBUS_ALERT                   : in  std_logic;
    DDR_EVENT_B                   : in  std_logic;
    DDR_VREFCA_POWER_GOOD         : in  std_logic;
    DDR_VREFDQ_RIGHT_POWER_GOOD   : in  std_logic;
    DDR_VREFDQ_LEFT_POWER_GOOD    : in  std_logic;
    CTL1_POWER_GOOD               : in  std_logic;
    CTL2_POWER_GOOD               : in  std_logic;
    AUX_EVENT                     : in  std_logic;
    MAX4N_QSFP_INTL               : in  std_logic_vector(7 downto 0);
    MAX4N_PHY_MDINT_N             : in  std_logic;
    MAX4N_NETWORK_PHY_INTL        : in  std_logic_vector(31 downto 0);
    MAX4N_QSFP_MODPRSL            : in  std_logic_vector(7 downto 0);

    host_event_status             : out std_logic_vector(EVENT_NUM - 1 downto 0); -- status of the alert signals
    host_event_ack                : in  std_logic_vector(EVENT_NUM - 1 downto 0); -- ACK by the host that event has been handled
--    host_event_ack_toggle         : in  std_logic;  -- host toggles this signal when the interrupt has been handled
    warning_led                   : out std_logic   -- if an event is detected, turn the warning LED on until the host has acknowledged the alert
  );
end max_events;



architecture rtl of max_events is

  signal event_inputs               : std_logic_vector(EVENT_NUM - 1 downto 0) := (others => '0');
  signal event_inputs_max4n			: std_logic_vector(EVENT_NUM - 1 downto 0) := (others => '0');
  signal event_inputs_r             : std_logic_vector(EVENT_NUM - 1 downto 0) := (others => '0');
  signal event_falling_edge         : std_logic_vector(EVENT_NUM - 1 downto 0) := (others => '0');
--  signal event_falling_edge_r       : std_logic_vector(EVENT_NUM - 1 downto 0) := (others => '0');
  signal host_event_status_int      : std_logic_vector(EVENT_NUM - 1 downto 0) := (others => '0');
  signal max4_reset_counter			: std_logic_vector(7 downto 0) := (others => '0');
  signal max4_valid_events			: std_logic;

--  signal do_irq                     : std_logic := '0';
--
--  signal host_event_ack_toggle_r    : std_logic := '0';
--  signal host_event_ack_en          : std_logic := '0';
--  
--  constant k_max4n_event_mask		: std_logic_vector(EVENT_NUM-1 downto 0) := "11" & x"8FFF000000"; 

begin

  -- MAX3: PMBUS_ALERT and CTLx_POWER_GOOD are inverted on the board
  g_if_event_num_is_7 : if EVENT_NUM = 7 generate
  begin
	  process(rst, clk)
	  begin
	    if rst = '1' then
	      event_inputs(EVENT_NUM-1 downto 0) <= (others => '0');
	    elsif rising_edge(clk) then
	      event_inputs(0) <= not to_x01(PMBUS_ALERT);
	      event_inputs(1) <= to_x01(DDR_EVENT_B);
	      event_inputs(2) <= to_x01(DDR_VREFCA_POWER_GOOD);
	      event_inputs(3) <= to_x01(DDR_VREFDQ_RIGHT_POWER_GOOD);
	      event_inputs(4) <= to_x01(DDR_VREFDQ_LEFT_POWER_GOOD);
	      event_inputs(5) <= not to_x01(CTL1_POWER_GOOD);
	      event_inputs(6) <= not to_x01(CTL2_POWER_GOOD);
	    end if;
	  end process;
  end generate;
  
  -- MAX4
  
  process(rst, clk)
  begin
  	if rst = '1' then
  		max4_reset_counter <= (others => '0');
  	elsif rising_edge(clk) then
  		if max4_reset_counter(max4_reset_counter'high) = '0' then
  			max4_reset_counter <= max4_reset_counter + 1;
  		end if;
  	end if;
  end process;
  
  max4_valid_events <= max4_reset_counter(max4_reset_counter'high);
  
  g_if_event_num_is_8 : if EVENT_NUM >= 8 generate
  begin
  	  process(rst, clk)
	  begin
	    if rst = '1' then
	      event_inputs(7 downto 0) <= (others => '0');
	    elsif rising_edge(clk) then
	   	  if max4_valid_events = '0' then
	   	    event_inputs(7 downto 0) <= (others => '0');
	   	  else
	        event_inputs(0) <= to_x01(PMBUS_ALERT); --no longer inverted on MAX4
	        event_inputs(1) <= to_x01(DDR_EVENT_B);
	        event_inputs(2) <= to_x01(DDR_VREFCA_POWER_GOOD);
	        event_inputs(3) <= to_x01(DDR_VREFDQ_RIGHT_POWER_GOOD);
	        event_inputs(4) <= to_x01(DDR_VREFDQ_LEFT_POWER_GOOD);
	        event_inputs(5) <= to_x01(CTL1_POWER_GOOD); --no longer inverted on MAX4
	        event_inputs(6) <= to_x01(CTL2_POWER_GOOD); --no longer inverted on MAX4
	        event_inputs(7) <= to_x01(AUX_EVENT);
	      end if;
	    end if;
	  end process;
	  
	  
	  -- MAX4N extra event bits
      g_is_max4n : if IS_MAX4N = true generate
      begin
      	  process(rst, clk)
	      begin
	        if rst = '1' then
	          event_inputs_max4n(96 downto 8) <= (others => '0');
	        elsif rising_edge(clk) then
	          if max4_valid_events = '0' then
	       	    event_inputs_max4n(96 downto 8) <= (others => '0');
	       	  else
	            event_inputs_max4n(10 downto 8) <= to_x01(MAX4N_QSFP_INTL(2 downto 0));
	            event_inputs_max4n(11) <= to_x01(MAX4N_PHY_MDINT_N);
	            event_inputs_max4n(23 downto 12) <= to_x01(MAX4N_NETWORK_PHY_INTL(11 downto 0));	 -- event when link goes down
	            event_inputs_max4n(35 downto 24) <= not to_x01(MAX4N_NETWORK_PHY_INTL(11 downto 0)); -- event when link goes up
	            event_inputs_max4n(38 downto 36) <= to_x01(MAX4N_QSFP_MODPRSL(2 downto 0));		 -- event when module is plugged in
	            event_inputs_max4n(41 downto 39) <= not to_x01(MAX4N_QSFP_MODPRSL(2 downto 0));      -- event when module is unplugged
                    -- Extended QSFP data for JDFE (mostly as above)
	            event_inputs_max4n(46 downto 42) <= to_x01(MAX4N_QSFP_INTL(7 downto 3));
	            event_inputs_max4n(66 downto 47) <= to_x01(MAX4N_NETWORK_PHY_INTL(31 downto 12));
	            event_inputs_max4n(86 downto 67) <= not to_x01(MAX4N_NETWORK_PHY_INTL(31 downto 12));
	            event_inputs_max4n(91 downto 87) <= to_x01(MAX4N_QSFP_MODPRSL(7 downto 3));
	            event_inputs_max4n(96 downto 92) <= not to_x01(MAX4N_QSFP_MODPRSL(7 downto 3));
	          end if;
	        end if;
	      end process;
	      
	      event_inputs(96 downto 8) <= event_inputs_max4n(96 downto 8);
      end generate;
      
      g_is_not_max4n : if IS_MAX4N = false generate
      begin
        event_inputs(41 downto 8) <= (others => '0');
      end generate;
	  
  end generate;
  


  process(rst, clk)
  begin
    if rst = '1' then
      event_inputs_r <= (others => '0');
      event_falling_edge <= (others => '0');
    elsif rising_edge(clk) then
      event_inputs_r <= event_inputs;
      event_falling_edge <= event_inputs_r and (event_inputs_r xor event_inputs);
    end if;
  end process;
  
  process(rst, clk)
  begin
    if rst = '1' then
      host_event_status_int <= (others => '0');
    elsif rising_edge(clk) then
		for i_event in 0 to EVENT_NUM - 1 loop
			if event_falling_edge(i_event) = '1' then
				host_event_status_int(i_event) <= '1';
			elsif host_event_ack(i_event) = '1' then
				host_event_status_int(i_event) <= '0';
			end if;
		end loop;
    end if;
  end process;
  
  warning_led <= or_reduce(host_event_status_int);
  host_event_status <= host_event_status_int;

end rtl;
