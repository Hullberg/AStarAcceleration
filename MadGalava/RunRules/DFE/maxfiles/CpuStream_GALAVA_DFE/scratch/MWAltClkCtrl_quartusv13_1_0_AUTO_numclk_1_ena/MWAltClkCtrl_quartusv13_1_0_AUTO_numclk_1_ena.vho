--IP Functional Simulation Model
--VERSION_BEGIN 13.1 cbx_mgl 2013:10:17:04:34:36:SJ cbx_simgen 2013:10:17:04:07:49:SJ  VERSION_END


-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- You may only use these simulation model output files for simulation
-- purposes and expressly not for synthesis or any other purposes (in which
-- event Altera disclaims all warranties of any kind).


--synopsys translate_off

 LIBRARY stratixv;
 USE stratixv.stratixv_components.all;

--synthesis_resources = stratixv_clkena 1 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  MWAltClkCtrl_quartusv13_1_0_AUTO_numclk_1_ena IS 
	 PORT 
	 ( 
		 ena	:	IN  STD_LOGIC;
		 inclk	:	IN  STD_LOGIC;
		 outclk	:	OUT  STD_LOGIC
	 ); 
 END MWAltClkCtrl_quartusv13_1_0_AUTO_numclk_1_ena;

 ARCHITECTURE RTL OF MWAltClkCtrl_quartusv13_1_0_AUTO_numclk_1_ena IS

	 ATTRIBUTE synthesis_clearbox : natural;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS 1;
	 SIGNAL  wire_nlO_outclk	:	STD_LOGIC;
 BEGIN

	outclk <= wire_nlO_outclk;
	nlO :  stratixv_clkena
	  GENERIC MAP (
		clock_type => "Auto",
		disable_mode => "low",
		ena_register_mode => "falling edge",
		ena_register_power_up => "high",
		lpm_type => "stratixv_clkena",
		test_syn => "high"
	  )
	  PORT MAP ( 
		ena => ena,
		inclk => inclk,
		outclk => wire_nlO_outclk
	  );

 END RTL; --MWAltClkCtrl_quartusv13_1_0_AUTO_numclk_1_ena
--synopsys translate_on
--VALID FILE
