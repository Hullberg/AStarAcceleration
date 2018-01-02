library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity StratixPCIeBase is
	port (
		pushup_stratixvhardippcie_i_rx_in0: in std_logic;
		pushup_stratixvhardippcie_i_rx_in1: in std_logic;
		pushup_stratixvhardippcie_i_rx_in2: in std_logic;
		pushup_stratixvhardippcie_i_rx_in3: in std_logic;
		pushup_stratixvhardippcie_i_rx_in4: in std_logic;
		pushup_stratixvhardippcie_i_rx_in5: in std_logic;
		pushup_stratixvhardippcie_i_rx_in6: in std_logic;
		pushup_stratixvhardippcie_i_rx_in7: in std_logic;
		pcie_npor: in std_logic;
		pcie_pin_perst: in std_logic;
		pcie_ref_clk: in std_logic;
		reconfig_xcvr_clk: in std_logic;
		app_int_sts: in std_logic;
		app_msi_req: in std_logic;
		app_msi_num: in std_logic_vector(4 downto 0);
		app_msi_tc: in std_logic_vector(2 downto 0);
		tx_st_valid: in std_logic;
		tx_st_sop: in std_logic;
		tx_st_eop: in std_logic;
		tx_st_empty: in std_logic_vector(1 downto 0);
		tx_st_err: in std_logic;
		tx_st_data: in std_logic_vector(127 downto 0);
		rx_st_ready: in std_logic;
		rx_st_mask: in std_logic;
		cpl_err: in std_logic_vector(6 downto 0);
		cpl_pending: in std_logic;
		test_in: in std_logic_vector(31 downto 0);
		simu_mode_pipe: in std_logic;
		sim_pipe_pclk_in: in std_logic;
		phystatus0: in std_logic;
		phystatus1: in std_logic;
		phystatus2: in std_logic;
		phystatus3: in std_logic;
		phystatus4: in std_logic;
		phystatus5: in std_logic;
		phystatus6: in std_logic;
		phystatus7: in std_logic;
		rxdata0: in std_logic_vector(7 downto 0);
		rxdata1: in std_logic_vector(7 downto 0);
		rxdata2: in std_logic_vector(7 downto 0);
		rxdata3: in std_logic_vector(7 downto 0);
		rxdata4: in std_logic_vector(7 downto 0);
		rxdata5: in std_logic_vector(7 downto 0);
		rxdata6: in std_logic_vector(7 downto 0);
		rxdata7: in std_logic_vector(7 downto 0);
		rxdatak0: in std_logic;
		rxdatak1: in std_logic;
		rxdatak2: in std_logic;
		rxdatak3: in std_logic;
		rxdatak4: in std_logic;
		rxdatak5: in std_logic;
		rxdatak6: in std_logic;
		rxdatak7: in std_logic;
		rxelecidle0: in std_logic;
		rxelecidle1: in std_logic;
		rxelecidle2: in std_logic;
		rxelecidle3: in std_logic;
		rxelecidle4: in std_logic;
		rxelecidle5: in std_logic;
		rxelecidle6: in std_logic;
		rxelecidle7: in std_logic;
		rxstatus0: in std_logic_vector(2 downto 0);
		rxstatus1: in std_logic_vector(2 downto 0);
		rxstatus2: in std_logic_vector(2 downto 0);
		rxstatus3: in std_logic_vector(2 downto 0);
		rxstatus4: in std_logic_vector(2 downto 0);
		rxstatus5: in std_logic_vector(2 downto 0);
		rxstatus6: in std_logic_vector(2 downto 0);
		rxstatus7: in std_logic_vector(2 downto 0);
		rxvalid0: in std_logic;
		rxvalid1: in std_logic;
		rxvalid2: in std_logic;
		rxvalid3: in std_logic;
		rxvalid4: in std_logic;
		rxvalid5: in std_logic;
		rxvalid6: in std_logic;
		rxvalid7: in std_logic;
		pushup_stratixvhardippcie_i_tx_out0: out std_logic;
		pushup_stratixvhardippcie_i_tx_out1: out std_logic;
		pushup_stratixvhardippcie_i_tx_out2: out std_logic;
		pushup_stratixvhardippcie_i_tx_out3: out std_logic;
		pushup_stratixvhardippcie_i_tx_out4: out std_logic;
		pushup_stratixvhardippcie_i_tx_out5: out std_logic;
		pushup_stratixvhardippcie_i_tx_out6: out std_logic;
		pushup_stratixvhardippcie_i_tx_out7: out std_logic;
		clk_pcie: out std_logic;
		rst_pcie_n: out std_logic;
		app_int_ack: out std_logic;
		app_msi_ack: out std_logic;
		tl_cfg_ctl: out std_logic_vector(31 downto 0);
		tl_cfg_add: out std_logic_vector(3 downto 0);
		ltssmstate: out std_logic_vector(4 downto 0);
		tx_st_ready: out std_logic;
		rx_st_valid: out std_logic;
		rx_st_sop: out std_logic;
		rx_st_eop: out std_logic;
		rx_st_empty: out std_logic_vector(1 downto 0);
		rx_st_err: out std_logic;
		rx_st_bar: out std_logic_vector(7 downto 0);
		rx_st_data: out std_logic_vector(127 downto 0);
		sim_pipe_rate: out std_logic_vector(1 downto 0);
		sim_ltssmstate: out std_logic_vector(4 downto 0);
		eidleinfersel0: out std_logic_vector(2 downto 0);
		eidleinfersel1: out std_logic_vector(2 downto 0);
		eidleinfersel2: out std_logic_vector(2 downto 0);
		eidleinfersel3: out std_logic_vector(2 downto 0);
		eidleinfersel4: out std_logic_vector(2 downto 0);
		eidleinfersel5: out std_logic_vector(2 downto 0);
		eidleinfersel6: out std_logic_vector(2 downto 0);
		eidleinfersel7: out std_logic_vector(2 downto 0);
		powerdown0: out std_logic_vector(1 downto 0);
		powerdown1: out std_logic_vector(1 downto 0);
		powerdown2: out std_logic_vector(1 downto 0);
		powerdown3: out std_logic_vector(1 downto 0);
		powerdown4: out std_logic_vector(1 downto 0);
		powerdown5: out std_logic_vector(1 downto 0);
		powerdown6: out std_logic_vector(1 downto 0);
		powerdown7: out std_logic_vector(1 downto 0);
		rxpolarity0: out std_logic;
		rxpolarity1: out std_logic;
		rxpolarity2: out std_logic;
		rxpolarity3: out std_logic;
		rxpolarity4: out std_logic;
		rxpolarity5: out std_logic;
		rxpolarity6: out std_logic;
		rxpolarity7: out std_logic;
		txcompl0: out std_logic;
		txcompl1: out std_logic;
		txcompl2: out std_logic;
		txcompl3: out std_logic;
		txcompl4: out std_logic;
		txcompl5: out std_logic;
		txcompl6: out std_logic;
		txcompl7: out std_logic;
		txdata0: out std_logic_vector(7 downto 0);
		txdata1: out std_logic_vector(7 downto 0);
		txdata2: out std_logic_vector(7 downto 0);
		txdata3: out std_logic_vector(7 downto 0);
		txdata4: out std_logic_vector(7 downto 0);
		txdata5: out std_logic_vector(7 downto 0);
		txdata6: out std_logic_vector(7 downto 0);
		txdata7: out std_logic_vector(7 downto 0);
		txdatak0: out std_logic;
		txdatak1: out std_logic;
		txdatak2: out std_logic;
		txdatak3: out std_logic;
		txdatak4: out std_logic;
		txdatak5: out std_logic;
		txdatak6: out std_logic;
		txdatak7: out std_logic;
		txdetectrx0: out std_logic;
		txdetectrx1: out std_logic;
		txdetectrx2: out std_logic;
		txdetectrx3: out std_logic;
		txdetectrx4: out std_logic;
		txdetectrx5: out std_logic;
		txdetectrx6: out std_logic;
		txdetectrx7: out std_logic;
		txelecidle0: out std_logic;
		txelecidle1: out std_logic;
		txelecidle2: out std_logic;
		txelecidle3: out std_logic;
		txelecidle4: out std_logic;
		txelecidle5: out std_logic;
		txelecidle6: out std_logic;
		txelecidle7: out std_logic;
		txdeemph0: out std_logic;
		txdeemph1: out std_logic;
		txdeemph2: out std_logic;
		txdeemph3: out std_logic;
		txdeemph4: out std_logic;
		txdeemph5: out std_logic;
		txdeemph6: out std_logic;
		txdeemph7: out std_logic;
		txswing0: out std_logic;
		txswing1: out std_logic;
		txswing2: out std_logic;
		txswing3: out std_logic;
		txswing4: out std_logic;
		txswing5: out std_logic;
		txswing6: out std_logic;
		txswing7: out std_logic;
		txmargin0: out std_logic_vector(2 downto 0);
		txmargin1: out std_logic_vector(2 downto 0);
		txmargin2: out std_logic_vector(2 downto 0);
		txmargin3: out std_logic_vector(2 downto 0);
		txmargin4: out std_logic_vector(2 downto 0);
		txmargin5: out std_logic_vector(2 downto 0);
		txmargin6: out std_logic_vector(2 downto 0);
		txmargin7: out std_logic_vector(2 downto 0)
	);
end StratixPCIeBase;

architecture MaxDC of StratixPCIeBase is
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
	component StratixVHardIPPCIe is
		port (
			rx_in0: in std_logic;
			rx_in1: in std_logic;
			rx_in2: in std_logic;
			rx_in3: in std_logic;
			rx_in4: in std_logic;
			rx_in5: in std_logic;
			rx_in6: in std_logic;
			rx_in7: in std_logic;
			pcie_pin_perst: in std_logic;
			pcie_ref_clk: in std_logic;
			pcie_npor: in std_logic;
			app_int_sts: in std_logic;
			app_msi_req: in std_logic;
			app_msi_num: in std_logic_vector(4 downto 0);
			app_msi_tc: in std_logic_vector(2 downto 0);
			tx_st_valid: in std_logic;
			tx_st_sop: in std_logic;
			tx_st_eop: in std_logic;
			tx_st_empty: in std_logic_vector(1 downto 0);
			tx_st_err: in std_logic;
			tx_st_data: in std_logic_vector(127 downto 0);
			rx_st_ready: in std_logic;
			rx_st_mask: in std_logic;
			cpl_err: in std_logic_vector(6 downto 0);
			cpl_pending: in std_logic;
			reconfig_to_xcvr: in std_logic_vector(699 downto 0);
			busy_xcvr_reconfig: in std_logic;
			test_in: in std_logic_vector(31 downto 0);
			simu_mode_pipe: in std_logic;
			sim_pipe_pclk_in: in std_logic;
			phystatus0: in std_logic;
			phystatus1: in std_logic;
			phystatus2: in std_logic;
			phystatus3: in std_logic;
			phystatus4: in std_logic;
			phystatus5: in std_logic;
			phystatus6: in std_logic;
			phystatus7: in std_logic;
			rxdata0: in std_logic_vector(7 downto 0);
			rxdata1: in std_logic_vector(7 downto 0);
			rxdata2: in std_logic_vector(7 downto 0);
			rxdata3: in std_logic_vector(7 downto 0);
			rxdata4: in std_logic_vector(7 downto 0);
			rxdata5: in std_logic_vector(7 downto 0);
			rxdata6: in std_logic_vector(7 downto 0);
			rxdata7: in std_logic_vector(7 downto 0);
			rxdatak0: in std_logic;
			rxdatak1: in std_logic;
			rxdatak2: in std_logic;
			rxdatak3: in std_logic;
			rxdatak4: in std_logic;
			rxdatak5: in std_logic;
			rxdatak6: in std_logic;
			rxdatak7: in std_logic;
			rxelecidle0: in std_logic;
			rxelecidle1: in std_logic;
			rxelecidle2: in std_logic;
			rxelecidle3: in std_logic;
			rxelecidle4: in std_logic;
			rxelecidle5: in std_logic;
			rxelecidle6: in std_logic;
			rxelecidle7: in std_logic;
			rxstatus0: in std_logic_vector(2 downto 0);
			rxstatus1: in std_logic_vector(2 downto 0);
			rxstatus2: in std_logic_vector(2 downto 0);
			rxstatus3: in std_logic_vector(2 downto 0);
			rxstatus4: in std_logic_vector(2 downto 0);
			rxstatus5: in std_logic_vector(2 downto 0);
			rxstatus6: in std_logic_vector(2 downto 0);
			rxstatus7: in std_logic_vector(2 downto 0);
			rxvalid0: in std_logic;
			rxvalid1: in std_logic;
			rxvalid2: in std_logic;
			rxvalid3: in std_logic;
			rxvalid4: in std_logic;
			rxvalid5: in std_logic;
			rxvalid6: in std_logic;
			rxvalid7: in std_logic;
			tx_out0: out std_logic;
			tx_out1: out std_logic;
			tx_out2: out std_logic;
			tx_out3: out std_logic;
			tx_out4: out std_logic;
			tx_out5: out std_logic;
			tx_out6: out std_logic;
			tx_out7: out std_logic;
			clk_pcie: out std_logic;
			rst_pcie_n: out std_logic;
			app_int_ack: out std_logic;
			app_msi_ack: out std_logic;
			tl_cfg_ctl: out std_logic_vector(31 downto 0);
			tl_cfg_add: out std_logic_vector(3 downto 0);
			ltssmstate: out std_logic_vector(4 downto 0);
			tx_st_ready: out std_logic;
			rx_st_valid: out std_logic;
			rx_st_sop: out std_logic;
			rx_st_eop: out std_logic;
			rx_st_empty: out std_logic_vector(1 downto 0);
			rx_st_err: out std_logic;
			rx_st_bar: out std_logic_vector(7 downto 0);
			rx_st_data: out std_logic_vector(127 downto 0);
			reconfig_from_xcvr: out std_logic_vector(459 downto 0);
			sim_pipe_rate: out std_logic_vector(1 downto 0);
			sim_ltssmstate: out std_logic_vector(4 downto 0);
			eidleinfersel0: out std_logic_vector(2 downto 0);
			eidleinfersel1: out std_logic_vector(2 downto 0);
			eidleinfersel2: out std_logic_vector(2 downto 0);
			eidleinfersel3: out std_logic_vector(2 downto 0);
			eidleinfersel4: out std_logic_vector(2 downto 0);
			eidleinfersel5: out std_logic_vector(2 downto 0);
			eidleinfersel6: out std_logic_vector(2 downto 0);
			eidleinfersel7: out std_logic_vector(2 downto 0);
			powerdown0: out std_logic_vector(1 downto 0);
			powerdown1: out std_logic_vector(1 downto 0);
			powerdown2: out std_logic_vector(1 downto 0);
			powerdown3: out std_logic_vector(1 downto 0);
			powerdown4: out std_logic_vector(1 downto 0);
			powerdown5: out std_logic_vector(1 downto 0);
			powerdown6: out std_logic_vector(1 downto 0);
			powerdown7: out std_logic_vector(1 downto 0);
			rxpolarity0: out std_logic;
			rxpolarity1: out std_logic;
			rxpolarity2: out std_logic;
			rxpolarity3: out std_logic;
			rxpolarity4: out std_logic;
			rxpolarity5: out std_logic;
			rxpolarity6: out std_logic;
			rxpolarity7: out std_logic;
			txcompl0: out std_logic;
			txcompl1: out std_logic;
			txcompl2: out std_logic;
			txcompl3: out std_logic;
			txcompl4: out std_logic;
			txcompl5: out std_logic;
			txcompl6: out std_logic;
			txcompl7: out std_logic;
			txdata0: out std_logic_vector(7 downto 0);
			txdata1: out std_logic_vector(7 downto 0);
			txdata2: out std_logic_vector(7 downto 0);
			txdata3: out std_logic_vector(7 downto 0);
			txdata4: out std_logic_vector(7 downto 0);
			txdata5: out std_logic_vector(7 downto 0);
			txdata6: out std_logic_vector(7 downto 0);
			txdata7: out std_logic_vector(7 downto 0);
			txdatak0: out std_logic;
			txdatak1: out std_logic;
			txdatak2: out std_logic;
			txdatak3: out std_logic;
			txdatak4: out std_logic;
			txdatak5: out std_logic;
			txdatak6: out std_logic;
			txdatak7: out std_logic;
			txdetectrx0: out std_logic;
			txdetectrx1: out std_logic;
			txdetectrx2: out std_logic;
			txdetectrx3: out std_logic;
			txdetectrx4: out std_logic;
			txdetectrx5: out std_logic;
			txdetectrx6: out std_logic;
			txdetectrx7: out std_logic;
			txelecidle0: out std_logic;
			txelecidle1: out std_logic;
			txelecidle2: out std_logic;
			txelecidle3: out std_logic;
			txelecidle4: out std_logic;
			txelecidle5: out std_logic;
			txelecidle6: out std_logic;
			txelecidle7: out std_logic;
			txdeemph0: out std_logic;
			txdeemph1: out std_logic;
			txdeemph2: out std_logic;
			txdeemph3: out std_logic;
			txdeemph4: out std_logic;
			txdeemph5: out std_logic;
			txdeemph6: out std_logic;
			txdeemph7: out std_logic;
			txswing0: out std_logic;
			txswing1: out std_logic;
			txswing2: out std_logic;
			txswing3: out std_logic;
			txswing4: out std_logic;
			txswing5: out std_logic;
			txswing6: out std_logic;
			txswing7: out std_logic;
			txmargin0: out std_logic_vector(2 downto 0);
			txmargin1: out std_logic_vector(2 downto 0);
			txmargin2: out std_logic_vector(2 downto 0);
			txmargin3: out std_logic_vector(2 downto 0);
			txmargin4: out std_logic_vector(2 downto 0);
			txmargin5: out std_logic_vector(2 downto 0);
			txmargin6: out std_logic_vector(2 downto 0);
			txmargin7: out std_logic_vector(2 downto 0)
		);
	end component;
	component TransceiverReconfig is
		port (
			reconfig_from_xcvr: in std_logic_vector(459 downto 0);
			npor: in std_logic;
			reconfig_xcvr_clk: in std_logic;
			reconfig_to_xcvr: out std_logic_vector(699 downto 0);
			reconfig_busy: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal stratixvhardippcie_i_tx_out0 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_tx_out1 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_tx_out2 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_tx_out3 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_tx_out4 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_tx_out5 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_tx_out6 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_tx_out7 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_clk_pcie : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_rst_pcie_n : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_app_int_ack : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_app_msi_ack : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_tl_cfg_ctl : std_logic_vector(31 downto 0);
	signal stratixvhardippcie_i_tl_cfg_add : std_logic_vector(3 downto 0);
	signal stratixvhardippcie_i_ltssmstate : std_logic_vector(4 downto 0);
	signal stratixvhardippcie_i_tx_st_ready : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_rx_st_valid : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_rx_st_sop : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_rx_st_eop : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_rx_st_empty : std_logic_vector(1 downto 0);
	signal stratixvhardippcie_i_rx_st_err : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_rx_st_bar : std_logic_vector(7 downto 0);
	signal stratixvhardippcie_i_rx_st_data : std_logic_vector(127 downto 0);
	signal stratixvhardippcie_i_reconfig_from_xcvr : std_logic_vector(459 downto 0);
	signal stratixvhardippcie_i_sim_pipe_rate : std_logic_vector(1 downto 0);
	signal stratixvhardippcie_i_sim_ltssmstate : std_logic_vector(4 downto 0);
	signal stratixvhardippcie_i_eidleinfersel0 : std_logic_vector(2 downto 0);
	signal stratixvhardippcie_i_eidleinfersel1 : std_logic_vector(2 downto 0);
	signal stratixvhardippcie_i_eidleinfersel2 : std_logic_vector(2 downto 0);
	signal stratixvhardippcie_i_eidleinfersel3 : std_logic_vector(2 downto 0);
	signal stratixvhardippcie_i_eidleinfersel4 : std_logic_vector(2 downto 0);
	signal stratixvhardippcie_i_eidleinfersel5 : std_logic_vector(2 downto 0);
	signal stratixvhardippcie_i_eidleinfersel6 : std_logic_vector(2 downto 0);
	signal stratixvhardippcie_i_eidleinfersel7 : std_logic_vector(2 downto 0);
	signal stratixvhardippcie_i_powerdown0 : std_logic_vector(1 downto 0);
	signal stratixvhardippcie_i_powerdown1 : std_logic_vector(1 downto 0);
	signal stratixvhardippcie_i_powerdown2 : std_logic_vector(1 downto 0);
	signal stratixvhardippcie_i_powerdown3 : std_logic_vector(1 downto 0);
	signal stratixvhardippcie_i_powerdown4 : std_logic_vector(1 downto 0);
	signal stratixvhardippcie_i_powerdown5 : std_logic_vector(1 downto 0);
	signal stratixvhardippcie_i_powerdown6 : std_logic_vector(1 downto 0);
	signal stratixvhardippcie_i_powerdown7 : std_logic_vector(1 downto 0);
	signal stratixvhardippcie_i_rxpolarity0 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_rxpolarity1 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_rxpolarity2 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_rxpolarity3 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_rxpolarity4 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_rxpolarity5 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_rxpolarity6 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_rxpolarity7 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txcompl0 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txcompl1 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txcompl2 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txcompl3 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txcompl4 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txcompl5 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txcompl6 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txcompl7 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdata0 : std_logic_vector(7 downto 0);
	signal stratixvhardippcie_i_txdata1 : std_logic_vector(7 downto 0);
	signal stratixvhardippcie_i_txdata2 : std_logic_vector(7 downto 0);
	signal stratixvhardippcie_i_txdata3 : std_logic_vector(7 downto 0);
	signal stratixvhardippcie_i_txdata4 : std_logic_vector(7 downto 0);
	signal stratixvhardippcie_i_txdata5 : std_logic_vector(7 downto 0);
	signal stratixvhardippcie_i_txdata6 : std_logic_vector(7 downto 0);
	signal stratixvhardippcie_i_txdata7 : std_logic_vector(7 downto 0);
	signal stratixvhardippcie_i_txdatak0 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdatak1 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdatak2 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdatak3 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdatak4 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdatak5 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdatak6 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdatak7 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdetectrx0 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdetectrx1 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdetectrx2 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdetectrx3 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdetectrx4 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdetectrx5 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdetectrx6 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdetectrx7 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txelecidle0 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txelecidle1 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txelecidle2 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txelecidle3 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txelecidle4 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txelecidle5 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txelecidle6 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txelecidle7 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdeemph0 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdeemph1 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdeemph2 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdeemph3 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdeemph4 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdeemph5 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdeemph6 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txdeemph7 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txswing0 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txswing1 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txswing2 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txswing3 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txswing4 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txswing5 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txswing6 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txswing7 : std_logic_vector(0 downto 0);
	signal stratixvhardippcie_i_txmargin0 : std_logic_vector(2 downto 0);
	signal stratixvhardippcie_i_txmargin1 : std_logic_vector(2 downto 0);
	signal stratixvhardippcie_i_txmargin2 : std_logic_vector(2 downto 0);
	signal stratixvhardippcie_i_txmargin3 : std_logic_vector(2 downto 0);
	signal stratixvhardippcie_i_txmargin4 : std_logic_vector(2 downto 0);
	signal stratixvhardippcie_i_txmargin5 : std_logic_vector(2 downto 0);
	signal stratixvhardippcie_i_txmargin6 : std_logic_vector(2 downto 0);
	signal stratixvhardippcie_i_txmargin7 : std_logic_vector(2 downto 0);
	signal pcie_xcvr_reconfig_i_reconfig_to_xcvr : std_logic_vector(699 downto 0);
	signal pcie_xcvr_reconfig_i_reconfig_busy : std_logic_vector(0 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	pushup_stratixvhardippcie_i_tx_out0 <= vec_to_bit(stratixvhardippcie_i_tx_out0);
	pushup_stratixvhardippcie_i_tx_out1 <= vec_to_bit(stratixvhardippcie_i_tx_out1);
	pushup_stratixvhardippcie_i_tx_out2 <= vec_to_bit(stratixvhardippcie_i_tx_out2);
	pushup_stratixvhardippcie_i_tx_out3 <= vec_to_bit(stratixvhardippcie_i_tx_out3);
	pushup_stratixvhardippcie_i_tx_out4 <= vec_to_bit(stratixvhardippcie_i_tx_out4);
	pushup_stratixvhardippcie_i_tx_out5 <= vec_to_bit(stratixvhardippcie_i_tx_out5);
	pushup_stratixvhardippcie_i_tx_out6 <= vec_to_bit(stratixvhardippcie_i_tx_out6);
	pushup_stratixvhardippcie_i_tx_out7 <= vec_to_bit(stratixvhardippcie_i_tx_out7);
	clk_pcie <= vec_to_bit(stratixvhardippcie_i_clk_pcie);
	rst_pcie_n <= vec_to_bit(stratixvhardippcie_i_rst_pcie_n);
	app_int_ack <= vec_to_bit(stratixvhardippcie_i_app_int_ack);
	app_msi_ack <= vec_to_bit(stratixvhardippcie_i_app_msi_ack);
	tl_cfg_ctl <= stratixvhardippcie_i_tl_cfg_ctl;
	tl_cfg_add <= stratixvhardippcie_i_tl_cfg_add;
	ltssmstate <= stratixvhardippcie_i_ltssmstate;
	tx_st_ready <= vec_to_bit(stratixvhardippcie_i_tx_st_ready);
	rx_st_valid <= vec_to_bit(stratixvhardippcie_i_rx_st_valid);
	rx_st_sop <= vec_to_bit(stratixvhardippcie_i_rx_st_sop);
	rx_st_eop <= vec_to_bit(stratixvhardippcie_i_rx_st_eop);
	rx_st_empty <= stratixvhardippcie_i_rx_st_empty;
	rx_st_err <= vec_to_bit(stratixvhardippcie_i_rx_st_err);
	rx_st_bar <= stratixvhardippcie_i_rx_st_bar;
	rx_st_data <= stratixvhardippcie_i_rx_st_data;
	sim_pipe_rate <= stratixvhardippcie_i_sim_pipe_rate;
	sim_ltssmstate <= stratixvhardippcie_i_sim_ltssmstate;
	eidleinfersel0 <= stratixvhardippcie_i_eidleinfersel0;
	eidleinfersel1 <= stratixvhardippcie_i_eidleinfersel1;
	eidleinfersel2 <= stratixvhardippcie_i_eidleinfersel2;
	eidleinfersel3 <= stratixvhardippcie_i_eidleinfersel3;
	eidleinfersel4 <= stratixvhardippcie_i_eidleinfersel4;
	eidleinfersel5 <= stratixvhardippcie_i_eidleinfersel5;
	eidleinfersel6 <= stratixvhardippcie_i_eidleinfersel6;
	eidleinfersel7 <= stratixvhardippcie_i_eidleinfersel7;
	powerdown0 <= stratixvhardippcie_i_powerdown0;
	powerdown1 <= stratixvhardippcie_i_powerdown1;
	powerdown2 <= stratixvhardippcie_i_powerdown2;
	powerdown3 <= stratixvhardippcie_i_powerdown3;
	powerdown4 <= stratixvhardippcie_i_powerdown4;
	powerdown5 <= stratixvhardippcie_i_powerdown5;
	powerdown6 <= stratixvhardippcie_i_powerdown6;
	powerdown7 <= stratixvhardippcie_i_powerdown7;
	rxpolarity0 <= vec_to_bit(stratixvhardippcie_i_rxpolarity0);
	rxpolarity1 <= vec_to_bit(stratixvhardippcie_i_rxpolarity1);
	rxpolarity2 <= vec_to_bit(stratixvhardippcie_i_rxpolarity2);
	rxpolarity3 <= vec_to_bit(stratixvhardippcie_i_rxpolarity3);
	rxpolarity4 <= vec_to_bit(stratixvhardippcie_i_rxpolarity4);
	rxpolarity5 <= vec_to_bit(stratixvhardippcie_i_rxpolarity5);
	rxpolarity6 <= vec_to_bit(stratixvhardippcie_i_rxpolarity6);
	rxpolarity7 <= vec_to_bit(stratixvhardippcie_i_rxpolarity7);
	txcompl0 <= vec_to_bit(stratixvhardippcie_i_txcompl0);
	txcompl1 <= vec_to_bit(stratixvhardippcie_i_txcompl1);
	txcompl2 <= vec_to_bit(stratixvhardippcie_i_txcompl2);
	txcompl3 <= vec_to_bit(stratixvhardippcie_i_txcompl3);
	txcompl4 <= vec_to_bit(stratixvhardippcie_i_txcompl4);
	txcompl5 <= vec_to_bit(stratixvhardippcie_i_txcompl5);
	txcompl6 <= vec_to_bit(stratixvhardippcie_i_txcompl6);
	txcompl7 <= vec_to_bit(stratixvhardippcie_i_txcompl7);
	txdata0 <= stratixvhardippcie_i_txdata0;
	txdata1 <= stratixvhardippcie_i_txdata1;
	txdata2 <= stratixvhardippcie_i_txdata2;
	txdata3 <= stratixvhardippcie_i_txdata3;
	txdata4 <= stratixvhardippcie_i_txdata4;
	txdata5 <= stratixvhardippcie_i_txdata5;
	txdata6 <= stratixvhardippcie_i_txdata6;
	txdata7 <= stratixvhardippcie_i_txdata7;
	txdatak0 <= vec_to_bit(stratixvhardippcie_i_txdatak0);
	txdatak1 <= vec_to_bit(stratixvhardippcie_i_txdatak1);
	txdatak2 <= vec_to_bit(stratixvhardippcie_i_txdatak2);
	txdatak3 <= vec_to_bit(stratixvhardippcie_i_txdatak3);
	txdatak4 <= vec_to_bit(stratixvhardippcie_i_txdatak4);
	txdatak5 <= vec_to_bit(stratixvhardippcie_i_txdatak5);
	txdatak6 <= vec_to_bit(stratixvhardippcie_i_txdatak6);
	txdatak7 <= vec_to_bit(stratixvhardippcie_i_txdatak7);
	txdetectrx0 <= vec_to_bit(stratixvhardippcie_i_txdetectrx0);
	txdetectrx1 <= vec_to_bit(stratixvhardippcie_i_txdetectrx1);
	txdetectrx2 <= vec_to_bit(stratixvhardippcie_i_txdetectrx2);
	txdetectrx3 <= vec_to_bit(stratixvhardippcie_i_txdetectrx3);
	txdetectrx4 <= vec_to_bit(stratixvhardippcie_i_txdetectrx4);
	txdetectrx5 <= vec_to_bit(stratixvhardippcie_i_txdetectrx5);
	txdetectrx6 <= vec_to_bit(stratixvhardippcie_i_txdetectrx6);
	txdetectrx7 <= vec_to_bit(stratixvhardippcie_i_txdetectrx7);
	txelecidle0 <= vec_to_bit(stratixvhardippcie_i_txelecidle0);
	txelecidle1 <= vec_to_bit(stratixvhardippcie_i_txelecidle1);
	txelecidle2 <= vec_to_bit(stratixvhardippcie_i_txelecidle2);
	txelecidle3 <= vec_to_bit(stratixvhardippcie_i_txelecidle3);
	txelecidle4 <= vec_to_bit(stratixvhardippcie_i_txelecidle4);
	txelecidle5 <= vec_to_bit(stratixvhardippcie_i_txelecidle5);
	txelecidle6 <= vec_to_bit(stratixvhardippcie_i_txelecidle6);
	txelecidle7 <= vec_to_bit(stratixvhardippcie_i_txelecidle7);
	txdeemph0 <= vec_to_bit(stratixvhardippcie_i_txdeemph0);
	txdeemph1 <= vec_to_bit(stratixvhardippcie_i_txdeemph1);
	txdeemph2 <= vec_to_bit(stratixvhardippcie_i_txdeemph2);
	txdeemph3 <= vec_to_bit(stratixvhardippcie_i_txdeemph3);
	txdeemph4 <= vec_to_bit(stratixvhardippcie_i_txdeemph4);
	txdeemph5 <= vec_to_bit(stratixvhardippcie_i_txdeemph5);
	txdeemph6 <= vec_to_bit(stratixvhardippcie_i_txdeemph6);
	txdeemph7 <= vec_to_bit(stratixvhardippcie_i_txdeemph7);
	txswing0 <= vec_to_bit(stratixvhardippcie_i_txswing0);
	txswing1 <= vec_to_bit(stratixvhardippcie_i_txswing1);
	txswing2 <= vec_to_bit(stratixvhardippcie_i_txswing2);
	txswing3 <= vec_to_bit(stratixvhardippcie_i_txswing3);
	txswing4 <= vec_to_bit(stratixvhardippcie_i_txswing4);
	txswing5 <= vec_to_bit(stratixvhardippcie_i_txswing5);
	txswing6 <= vec_to_bit(stratixvhardippcie_i_txswing6);
	txswing7 <= vec_to_bit(stratixvhardippcie_i_txswing7);
	txmargin0 <= stratixvhardippcie_i_txmargin0;
	txmargin1 <= stratixvhardippcie_i_txmargin1;
	txmargin2 <= stratixvhardippcie_i_txmargin2;
	txmargin3 <= stratixvhardippcie_i_txmargin3;
	txmargin4 <= stratixvhardippcie_i_txmargin4;
	txmargin5 <= stratixvhardippcie_i_txmargin5;
	txmargin6 <= stratixvhardippcie_i_txmargin6;
	txmargin7 <= stratixvhardippcie_i_txmargin7;
	
	-- Register processes
	
	
	-- Entity instances
	
	StratixVHardIPPCIe_i : StratixVHardIPPCIe
		port map (
			tx_out0 => stratixvhardippcie_i_tx_out0(0), -- 1 bits (out)
			tx_out1 => stratixvhardippcie_i_tx_out1(0), -- 1 bits (out)
			tx_out2 => stratixvhardippcie_i_tx_out2(0), -- 1 bits (out)
			tx_out3 => stratixvhardippcie_i_tx_out3(0), -- 1 bits (out)
			tx_out4 => stratixvhardippcie_i_tx_out4(0), -- 1 bits (out)
			tx_out5 => stratixvhardippcie_i_tx_out5(0), -- 1 bits (out)
			tx_out6 => stratixvhardippcie_i_tx_out6(0), -- 1 bits (out)
			tx_out7 => stratixvhardippcie_i_tx_out7(0), -- 1 bits (out)
			clk_pcie => stratixvhardippcie_i_clk_pcie(0), -- 1 bits (out)
			rst_pcie_n => stratixvhardippcie_i_rst_pcie_n(0), -- 1 bits (out)
			app_int_ack => stratixvhardippcie_i_app_int_ack(0), -- 1 bits (out)
			app_msi_ack => stratixvhardippcie_i_app_msi_ack(0), -- 1 bits (out)
			tl_cfg_ctl => stratixvhardippcie_i_tl_cfg_ctl, -- 32 bits (out)
			tl_cfg_add => stratixvhardippcie_i_tl_cfg_add, -- 4 bits (out)
			ltssmstate => stratixvhardippcie_i_ltssmstate, -- 5 bits (out)
			tx_st_ready => stratixvhardippcie_i_tx_st_ready(0), -- 1 bits (out)
			rx_st_valid => stratixvhardippcie_i_rx_st_valid(0), -- 1 bits (out)
			rx_st_sop => stratixvhardippcie_i_rx_st_sop(0), -- 1 bits (out)
			rx_st_eop => stratixvhardippcie_i_rx_st_eop(0), -- 1 bits (out)
			rx_st_empty => stratixvhardippcie_i_rx_st_empty, -- 2 bits (out)
			rx_st_err => stratixvhardippcie_i_rx_st_err(0), -- 1 bits (out)
			rx_st_bar => stratixvhardippcie_i_rx_st_bar, -- 8 bits (out)
			rx_st_data => stratixvhardippcie_i_rx_st_data, -- 128 bits (out)
			reconfig_from_xcvr => stratixvhardippcie_i_reconfig_from_xcvr, -- 460 bits (out)
			sim_pipe_rate => stratixvhardippcie_i_sim_pipe_rate, -- 2 bits (out)
			sim_ltssmstate => stratixvhardippcie_i_sim_ltssmstate, -- 5 bits (out)
			eidleinfersel0 => stratixvhardippcie_i_eidleinfersel0, -- 3 bits (out)
			eidleinfersel1 => stratixvhardippcie_i_eidleinfersel1, -- 3 bits (out)
			eidleinfersel2 => stratixvhardippcie_i_eidleinfersel2, -- 3 bits (out)
			eidleinfersel3 => stratixvhardippcie_i_eidleinfersel3, -- 3 bits (out)
			eidleinfersel4 => stratixvhardippcie_i_eidleinfersel4, -- 3 bits (out)
			eidleinfersel5 => stratixvhardippcie_i_eidleinfersel5, -- 3 bits (out)
			eidleinfersel6 => stratixvhardippcie_i_eidleinfersel6, -- 3 bits (out)
			eidleinfersel7 => stratixvhardippcie_i_eidleinfersel7, -- 3 bits (out)
			powerdown0 => stratixvhardippcie_i_powerdown0, -- 2 bits (out)
			powerdown1 => stratixvhardippcie_i_powerdown1, -- 2 bits (out)
			powerdown2 => stratixvhardippcie_i_powerdown2, -- 2 bits (out)
			powerdown3 => stratixvhardippcie_i_powerdown3, -- 2 bits (out)
			powerdown4 => stratixvhardippcie_i_powerdown4, -- 2 bits (out)
			powerdown5 => stratixvhardippcie_i_powerdown5, -- 2 bits (out)
			powerdown6 => stratixvhardippcie_i_powerdown6, -- 2 bits (out)
			powerdown7 => stratixvhardippcie_i_powerdown7, -- 2 bits (out)
			rxpolarity0 => stratixvhardippcie_i_rxpolarity0(0), -- 1 bits (out)
			rxpolarity1 => stratixvhardippcie_i_rxpolarity1(0), -- 1 bits (out)
			rxpolarity2 => stratixvhardippcie_i_rxpolarity2(0), -- 1 bits (out)
			rxpolarity3 => stratixvhardippcie_i_rxpolarity3(0), -- 1 bits (out)
			rxpolarity4 => stratixvhardippcie_i_rxpolarity4(0), -- 1 bits (out)
			rxpolarity5 => stratixvhardippcie_i_rxpolarity5(0), -- 1 bits (out)
			rxpolarity6 => stratixvhardippcie_i_rxpolarity6(0), -- 1 bits (out)
			rxpolarity7 => stratixvhardippcie_i_rxpolarity7(0), -- 1 bits (out)
			txcompl0 => stratixvhardippcie_i_txcompl0(0), -- 1 bits (out)
			txcompl1 => stratixvhardippcie_i_txcompl1(0), -- 1 bits (out)
			txcompl2 => stratixvhardippcie_i_txcompl2(0), -- 1 bits (out)
			txcompl3 => stratixvhardippcie_i_txcompl3(0), -- 1 bits (out)
			txcompl4 => stratixvhardippcie_i_txcompl4(0), -- 1 bits (out)
			txcompl5 => stratixvhardippcie_i_txcompl5(0), -- 1 bits (out)
			txcompl6 => stratixvhardippcie_i_txcompl6(0), -- 1 bits (out)
			txcompl7 => stratixvhardippcie_i_txcompl7(0), -- 1 bits (out)
			txdata0 => stratixvhardippcie_i_txdata0, -- 8 bits (out)
			txdata1 => stratixvhardippcie_i_txdata1, -- 8 bits (out)
			txdata2 => stratixvhardippcie_i_txdata2, -- 8 bits (out)
			txdata3 => stratixvhardippcie_i_txdata3, -- 8 bits (out)
			txdata4 => stratixvhardippcie_i_txdata4, -- 8 bits (out)
			txdata5 => stratixvhardippcie_i_txdata5, -- 8 bits (out)
			txdata6 => stratixvhardippcie_i_txdata6, -- 8 bits (out)
			txdata7 => stratixvhardippcie_i_txdata7, -- 8 bits (out)
			txdatak0 => stratixvhardippcie_i_txdatak0(0), -- 1 bits (out)
			txdatak1 => stratixvhardippcie_i_txdatak1(0), -- 1 bits (out)
			txdatak2 => stratixvhardippcie_i_txdatak2(0), -- 1 bits (out)
			txdatak3 => stratixvhardippcie_i_txdatak3(0), -- 1 bits (out)
			txdatak4 => stratixvhardippcie_i_txdatak4(0), -- 1 bits (out)
			txdatak5 => stratixvhardippcie_i_txdatak5(0), -- 1 bits (out)
			txdatak6 => stratixvhardippcie_i_txdatak6(0), -- 1 bits (out)
			txdatak7 => stratixvhardippcie_i_txdatak7(0), -- 1 bits (out)
			txdetectrx0 => stratixvhardippcie_i_txdetectrx0(0), -- 1 bits (out)
			txdetectrx1 => stratixvhardippcie_i_txdetectrx1(0), -- 1 bits (out)
			txdetectrx2 => stratixvhardippcie_i_txdetectrx2(0), -- 1 bits (out)
			txdetectrx3 => stratixvhardippcie_i_txdetectrx3(0), -- 1 bits (out)
			txdetectrx4 => stratixvhardippcie_i_txdetectrx4(0), -- 1 bits (out)
			txdetectrx5 => stratixvhardippcie_i_txdetectrx5(0), -- 1 bits (out)
			txdetectrx6 => stratixvhardippcie_i_txdetectrx6(0), -- 1 bits (out)
			txdetectrx7 => stratixvhardippcie_i_txdetectrx7(0), -- 1 bits (out)
			txelecidle0 => stratixvhardippcie_i_txelecidle0(0), -- 1 bits (out)
			txelecidle1 => stratixvhardippcie_i_txelecidle1(0), -- 1 bits (out)
			txelecidle2 => stratixvhardippcie_i_txelecidle2(0), -- 1 bits (out)
			txelecidle3 => stratixvhardippcie_i_txelecidle3(0), -- 1 bits (out)
			txelecidle4 => stratixvhardippcie_i_txelecidle4(0), -- 1 bits (out)
			txelecidle5 => stratixvhardippcie_i_txelecidle5(0), -- 1 bits (out)
			txelecidle6 => stratixvhardippcie_i_txelecidle6(0), -- 1 bits (out)
			txelecidle7 => stratixvhardippcie_i_txelecidle7(0), -- 1 bits (out)
			txdeemph0 => stratixvhardippcie_i_txdeemph0(0), -- 1 bits (out)
			txdeemph1 => stratixvhardippcie_i_txdeemph1(0), -- 1 bits (out)
			txdeemph2 => stratixvhardippcie_i_txdeemph2(0), -- 1 bits (out)
			txdeemph3 => stratixvhardippcie_i_txdeemph3(0), -- 1 bits (out)
			txdeemph4 => stratixvhardippcie_i_txdeemph4(0), -- 1 bits (out)
			txdeemph5 => stratixvhardippcie_i_txdeemph5(0), -- 1 bits (out)
			txdeemph6 => stratixvhardippcie_i_txdeemph6(0), -- 1 bits (out)
			txdeemph7 => stratixvhardippcie_i_txdeemph7(0), -- 1 bits (out)
			txswing0 => stratixvhardippcie_i_txswing0(0), -- 1 bits (out)
			txswing1 => stratixvhardippcie_i_txswing1(0), -- 1 bits (out)
			txswing2 => stratixvhardippcie_i_txswing2(0), -- 1 bits (out)
			txswing3 => stratixvhardippcie_i_txswing3(0), -- 1 bits (out)
			txswing4 => stratixvhardippcie_i_txswing4(0), -- 1 bits (out)
			txswing5 => stratixvhardippcie_i_txswing5(0), -- 1 bits (out)
			txswing6 => stratixvhardippcie_i_txswing6(0), -- 1 bits (out)
			txswing7 => stratixvhardippcie_i_txswing7(0), -- 1 bits (out)
			txmargin0 => stratixvhardippcie_i_txmargin0, -- 3 bits (out)
			txmargin1 => stratixvhardippcie_i_txmargin1, -- 3 bits (out)
			txmargin2 => stratixvhardippcie_i_txmargin2, -- 3 bits (out)
			txmargin3 => stratixvhardippcie_i_txmargin3, -- 3 bits (out)
			txmargin4 => stratixvhardippcie_i_txmargin4, -- 3 bits (out)
			txmargin5 => stratixvhardippcie_i_txmargin5, -- 3 bits (out)
			txmargin6 => stratixvhardippcie_i_txmargin6, -- 3 bits (out)
			txmargin7 => stratixvhardippcie_i_txmargin7, -- 3 bits (out)
			rx_in0 => pushup_stratixvhardippcie_i_rx_in0, -- 1 bits (in)
			rx_in1 => pushup_stratixvhardippcie_i_rx_in1, -- 1 bits (in)
			rx_in2 => pushup_stratixvhardippcie_i_rx_in2, -- 1 bits (in)
			rx_in3 => pushup_stratixvhardippcie_i_rx_in3, -- 1 bits (in)
			rx_in4 => pushup_stratixvhardippcie_i_rx_in4, -- 1 bits (in)
			rx_in5 => pushup_stratixvhardippcie_i_rx_in5, -- 1 bits (in)
			rx_in6 => pushup_stratixvhardippcie_i_rx_in6, -- 1 bits (in)
			rx_in7 => pushup_stratixvhardippcie_i_rx_in7, -- 1 bits (in)
			pcie_pin_perst => pcie_pin_perst, -- 1 bits (in)
			pcie_ref_clk => pcie_ref_clk, -- 1 bits (in)
			pcie_npor => pcie_npor, -- 1 bits (in)
			app_int_sts => app_int_sts, -- 1 bits (in)
			app_msi_req => app_msi_req, -- 1 bits (in)
			app_msi_num => app_msi_num, -- 5 bits (in)
			app_msi_tc => app_msi_tc, -- 3 bits (in)
			tx_st_valid => tx_st_valid, -- 1 bits (in)
			tx_st_sop => tx_st_sop, -- 1 bits (in)
			tx_st_eop => tx_st_eop, -- 1 bits (in)
			tx_st_empty => tx_st_empty, -- 2 bits (in)
			tx_st_err => tx_st_err, -- 1 bits (in)
			tx_st_data => tx_st_data, -- 128 bits (in)
			rx_st_ready => rx_st_ready, -- 1 bits (in)
			rx_st_mask => rx_st_mask, -- 1 bits (in)
			cpl_err => cpl_err, -- 7 bits (in)
			cpl_pending => cpl_pending, -- 1 bits (in)
			reconfig_to_xcvr => pcie_xcvr_reconfig_i_reconfig_to_xcvr, -- 700 bits (in)
			busy_xcvr_reconfig => vec_to_bit(pcie_xcvr_reconfig_i_reconfig_busy), -- 1 bits (in)
			test_in => test_in, -- 32 bits (in)
			simu_mode_pipe => simu_mode_pipe, -- 1 bits (in)
			sim_pipe_pclk_in => sim_pipe_pclk_in, -- 1 bits (in)
			phystatus0 => phystatus0, -- 1 bits (in)
			phystatus1 => phystatus1, -- 1 bits (in)
			phystatus2 => phystatus2, -- 1 bits (in)
			phystatus3 => phystatus3, -- 1 bits (in)
			phystatus4 => phystatus4, -- 1 bits (in)
			phystatus5 => phystatus5, -- 1 bits (in)
			phystatus6 => phystatus6, -- 1 bits (in)
			phystatus7 => phystatus7, -- 1 bits (in)
			rxdata0 => rxdata0, -- 8 bits (in)
			rxdata1 => rxdata1, -- 8 bits (in)
			rxdata2 => rxdata2, -- 8 bits (in)
			rxdata3 => rxdata3, -- 8 bits (in)
			rxdata4 => rxdata4, -- 8 bits (in)
			rxdata5 => rxdata5, -- 8 bits (in)
			rxdata6 => rxdata6, -- 8 bits (in)
			rxdata7 => rxdata7, -- 8 bits (in)
			rxdatak0 => rxdatak0, -- 1 bits (in)
			rxdatak1 => rxdatak1, -- 1 bits (in)
			rxdatak2 => rxdatak2, -- 1 bits (in)
			rxdatak3 => rxdatak3, -- 1 bits (in)
			rxdatak4 => rxdatak4, -- 1 bits (in)
			rxdatak5 => rxdatak5, -- 1 bits (in)
			rxdatak6 => rxdatak6, -- 1 bits (in)
			rxdatak7 => rxdatak7, -- 1 bits (in)
			rxelecidle0 => rxelecidle0, -- 1 bits (in)
			rxelecidle1 => rxelecidle1, -- 1 bits (in)
			rxelecidle2 => rxelecidle2, -- 1 bits (in)
			rxelecidle3 => rxelecidle3, -- 1 bits (in)
			rxelecidle4 => rxelecidle4, -- 1 bits (in)
			rxelecidle5 => rxelecidle5, -- 1 bits (in)
			rxelecidle6 => rxelecidle6, -- 1 bits (in)
			rxelecidle7 => rxelecidle7, -- 1 bits (in)
			rxstatus0 => rxstatus0, -- 3 bits (in)
			rxstatus1 => rxstatus1, -- 3 bits (in)
			rxstatus2 => rxstatus2, -- 3 bits (in)
			rxstatus3 => rxstatus3, -- 3 bits (in)
			rxstatus4 => rxstatus4, -- 3 bits (in)
			rxstatus5 => rxstatus5, -- 3 bits (in)
			rxstatus6 => rxstatus6, -- 3 bits (in)
			rxstatus7 => rxstatus7, -- 3 bits (in)
			rxvalid0 => rxvalid0, -- 1 bits (in)
			rxvalid1 => rxvalid1, -- 1 bits (in)
			rxvalid2 => rxvalid2, -- 1 bits (in)
			rxvalid3 => rxvalid3, -- 1 bits (in)
			rxvalid4 => rxvalid4, -- 1 bits (in)
			rxvalid5 => rxvalid5, -- 1 bits (in)
			rxvalid6 => rxvalid6, -- 1 bits (in)
			rxvalid7 => rxvalid7 -- 1 bits (in)
		);
	pcie_xcvr_reconfig_i : TransceiverReconfig
		port map (
			reconfig_to_xcvr => pcie_xcvr_reconfig_i_reconfig_to_xcvr, -- 700 bits (out)
			reconfig_busy => pcie_xcvr_reconfig_i_reconfig_busy(0), -- 1 bits (out)
			reconfig_from_xcvr => stratixvhardippcie_i_reconfig_from_xcvr, -- 460 bits (in)
			npor => pcie_npor, -- 1 bits (in)
			reconfig_xcvr_clk => reconfig_xcvr_clk -- 1 bits (in)
		);
end MaxDC;
