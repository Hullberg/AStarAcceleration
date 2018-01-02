library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity StratixVHardIPPCIe is
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
end StratixVHardIPPCIe;

architecture MaxDC of StratixVHardIPPCIe is
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
	component pcie_SV_hard_ip is
		generic (
			DEVICE_ID : integer;
			GEN_RATE : string;
			MS_CYCLE_COUNT : integer
		);
		port (
			npor: in std_logic;
			pin_perst: in std_logic;
			lmi_addr: in std_logic_vector(11 downto 0);
			lmi_din: in std_logic_vector(31 downto 0);
			lmi_rden: in std_logic;
			lmi_wren: in std_logic;
			hpg_ctrler: in std_logic_vector(4 downto 0);
			cpl_err: in std_logic_vector(6 downto 0);
			cpl_pending: in std_logic;
			pm_auxpwr: in std_logic;
			pm_data: in std_logic_vector(9 downto 0);
			pme_to_cr: in std_logic;
			pm_event: in std_logic;
			test_in: in std_logic_vector(31 downto 0);
			simu_mode_pipe: in std_logic;
			rx_st_ready: in std_logic;
			rx_st_mask: in std_logic_vector(0 downto 0);
			tx_st_valid: in std_logic_vector(0 downto 0);
			tx_st_sop: in std_logic_vector(0 downto 0);
			tx_st_eop: in std_logic_vector(0 downto 0);
			tx_st_empty: in std_logic_vector(1 downto 0);
			tx_st_err: in std_logic_vector(0 downto 0);
			tx_st_data: in std_logic_vector(127 downto 0);
			pld_clk: in std_logic;
			refclk: in std_logic;
			pld_core_ready: in std_logic;
			reconfig_to_xcvr: in std_logic_vector(699 downto 0);
			rx_in0: in std_logic;
			rx_in1: in std_logic;
			rx_in2: in std_logic;
			rx_in3: in std_logic;
			rx_in4: in std_logic;
			rx_in5: in std_logic;
			rx_in6: in std_logic;
			rx_in7: in std_logic;
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
			app_int_sts: in std_logic;
			app_msi_num: in std_logic_vector(4 downto 0);
			app_msi_req: in std_logic;
			app_msi_tc: in std_logic_vector(2 downto 0);
			lmi_ack: out std_logic;
			lmi_dout: out std_logic_vector(31 downto 0);
			tl_cfg_add: out std_logic_vector(3 downto 0);
			tl_cfg_ctl: out std_logic_vector(31 downto 0);
			tl_cfg_sts: out std_logic_vector(52 downto 0);
			pme_to_sr: out std_logic;
			currentspeed: out std_logic_vector(1 downto 0);
			derr_cor_ext_rcv: out std_logic;
			derr_cor_ext_rpl: out std_logic;
			derr_rpl: out std_logic;
			dlup: out std_logic;
			dlup_exit: out std_logic;
			ev128ns: out std_logic;
			ev1us: out std_logic;
			hotrst_exit: out std_logic;
			int_status: out std_logic_vector(3 downto 0);
			l2_exit: out std_logic;
			lane_act: out std_logic_vector(3 downto 0);
			ltssmstate: out std_logic_vector(4 downto 0);
			rx_par_err: out std_logic;
			tx_par_err: out std_logic_vector(1 downto 0);
			cfg_par_err: out std_logic;
			ko_cpl_spc_header: out std_logic_vector(7 downto 0);
			ko_cpl_spc_data: out std_logic_vector(11 downto 0);
			rx_st_valid: out std_logic_vector(0 downto 0);
			rx_st_sop: out std_logic_vector(0 downto 0);
			rx_st_eop: out std_logic_vector(0 downto 0);
			rx_st_empty: out std_logic_vector(1 downto 0);
			rx_st_err: out std_logic_vector(0 downto 0);
			rx_st_data: out std_logic_vector(127 downto 0);
			rx_st_bar: out std_logic_vector(7 downto 0);
			tx_st_ready: out std_logic;
			tx_cred_datafccp: out std_logic_vector(11 downto 0);
			tx_cred_datafcnp: out std_logic_vector(11 downto 0);
			tx_cred_datafcp: out std_logic_vector(11 downto 0);
			tx_cred_fchipcons: out std_logic_vector(5 downto 0);
			tx_cred_fcinfinite: out std_logic_vector(5 downto 0);
			tx_cred_hdrfccp: out std_logic_vector(7 downto 0);
			tx_cred_hdrfcnp: out std_logic_vector(7 downto 0);
			tx_cred_hdrfcp: out std_logic_vector(7 downto 0);
			coreclkout_hip: out std_logic;
			reset_status: out std_logic;
			serdes_pll_locked: out std_logic;
			pld_clk_inuse: out std_logic;
			testin_zero: out std_logic;
			reconfig_from_xcvr: out std_logic_vector(459 downto 0);
			tx_out0: out std_logic;
			tx_out1: out std_logic;
			tx_out2: out std_logic;
			tx_out3: out std_logic;
			tx_out4: out std_logic;
			tx_out5: out std_logic;
			tx_out6: out std_logic;
			tx_out7: out std_logic;
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
			txmargin0: out std_logic_vector(2 downto 0);
			txmargin1: out std_logic_vector(2 downto 0);
			txmargin2: out std_logic_vector(2 downto 0);
			txmargin3: out std_logic_vector(2 downto 0);
			txmargin4: out std_logic_vector(2 downto 0);
			txmargin5: out std_logic_vector(2 downto 0);
			txmargin6: out std_logic_vector(2 downto 0);
			txmargin7: out std_logic_vector(2 downto 0);
			txswing0: out std_logic;
			txswing1: out std_logic;
			txswing2: out std_logic;
			txswing3: out std_logic;
			txswing4: out std_logic;
			txswing5: out std_logic;
			txswing6: out std_logic;
			txswing7: out std_logic;
			app_int_ack: out std_logic;
			app_msi_ack: out std_logic
		);
	end component;
	attribute box_type of pcie_SV_hard_ip : component is "BLACK_BOX";
	component MWAltClkCtrl_quartusv13_1_0_GCLK_numclk_1 is
		port (
			inclk: in std_logic;
			outclk: out std_logic
		);
	end component;
	attribute box_type of MWAltClkCtrl_quartusv13_1_0_GCLK_numclk_1 : component is "BLACK_BOX";
	
	-- Signal declarations
	
	signal pcie_sv_hard_ip_i_lmi_ack : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_lmi_dout : std_logic_vector(31 downto 0);
	signal pcie_sv_hard_ip_i_tl_cfg_add : std_logic_vector(3 downto 0);
	signal pcie_sv_hard_ip_i_tl_cfg_ctl : std_logic_vector(31 downto 0);
	signal pcie_sv_hard_ip_i_tl_cfg_sts : std_logic_vector(52 downto 0);
	signal pcie_sv_hard_ip_i_pme_to_sr : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_currentspeed : std_logic_vector(1 downto 0);
	signal pcie_sv_hard_ip_i_derr_cor_ext_rcv : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_derr_cor_ext_rpl : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_derr_rpl : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_dlup : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_dlup_exit : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_ev128ns : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_ev1us : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_hotrst_exit : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_int_status : std_logic_vector(3 downto 0);
	signal pcie_sv_hard_ip_i_l2_exit : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_lane_act : std_logic_vector(3 downto 0);
	signal pcie_sv_hard_ip_i_ltssmstate : std_logic_vector(4 downto 0);
	signal pcie_sv_hard_ip_i_rx_par_err : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_tx_par_err : std_logic_vector(1 downto 0);
	signal pcie_sv_hard_ip_i_cfg_par_err : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_ko_cpl_spc_header : std_logic_vector(7 downto 0);
	signal pcie_sv_hard_ip_i_ko_cpl_spc_data : std_logic_vector(11 downto 0);
	signal pcie_sv_hard_ip_i_rx_st_valid : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_rx_st_sop : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_rx_st_eop : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_rx_st_empty : std_logic_vector(1 downto 0);
	signal pcie_sv_hard_ip_i_rx_st_err : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_rx_st_data : std_logic_vector(127 downto 0);
	signal pcie_sv_hard_ip_i_rx_st_bar : std_logic_vector(7 downto 0);
	signal pcie_sv_hard_ip_i_tx_st_ready : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_tx_cred_datafccp : std_logic_vector(11 downto 0);
	signal pcie_sv_hard_ip_i_tx_cred_datafcnp : std_logic_vector(11 downto 0);
	signal pcie_sv_hard_ip_i_tx_cred_datafcp : std_logic_vector(11 downto 0);
	signal pcie_sv_hard_ip_i_tx_cred_fchipcons : std_logic_vector(5 downto 0);
	signal pcie_sv_hard_ip_i_tx_cred_fcinfinite : std_logic_vector(5 downto 0);
	signal pcie_sv_hard_ip_i_tx_cred_hdrfccp : std_logic_vector(7 downto 0);
	signal pcie_sv_hard_ip_i_tx_cred_hdrfcnp : std_logic_vector(7 downto 0);
	signal pcie_sv_hard_ip_i_tx_cred_hdrfcp : std_logic_vector(7 downto 0);
	signal pcie_sv_hard_ip_i_coreclkout_hip : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_reset_status : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_serdes_pll_locked : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_pld_clk_inuse : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_testin_zero : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_reconfig_from_xcvr : std_logic_vector(459 downto 0);
	signal pcie_sv_hard_ip_i_tx_out0 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_tx_out1 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_tx_out2 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_tx_out3 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_tx_out4 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_tx_out5 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_tx_out6 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_tx_out7 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_sim_pipe_rate : std_logic_vector(1 downto 0);
	signal pcie_sv_hard_ip_i_sim_ltssmstate : std_logic_vector(4 downto 0);
	signal pcie_sv_hard_ip_i_eidleinfersel0 : std_logic_vector(2 downto 0);
	signal pcie_sv_hard_ip_i_eidleinfersel1 : std_logic_vector(2 downto 0);
	signal pcie_sv_hard_ip_i_eidleinfersel2 : std_logic_vector(2 downto 0);
	signal pcie_sv_hard_ip_i_eidleinfersel3 : std_logic_vector(2 downto 0);
	signal pcie_sv_hard_ip_i_eidleinfersel4 : std_logic_vector(2 downto 0);
	signal pcie_sv_hard_ip_i_eidleinfersel5 : std_logic_vector(2 downto 0);
	signal pcie_sv_hard_ip_i_eidleinfersel6 : std_logic_vector(2 downto 0);
	signal pcie_sv_hard_ip_i_eidleinfersel7 : std_logic_vector(2 downto 0);
	signal pcie_sv_hard_ip_i_powerdown0 : std_logic_vector(1 downto 0);
	signal pcie_sv_hard_ip_i_powerdown1 : std_logic_vector(1 downto 0);
	signal pcie_sv_hard_ip_i_powerdown2 : std_logic_vector(1 downto 0);
	signal pcie_sv_hard_ip_i_powerdown3 : std_logic_vector(1 downto 0);
	signal pcie_sv_hard_ip_i_powerdown4 : std_logic_vector(1 downto 0);
	signal pcie_sv_hard_ip_i_powerdown5 : std_logic_vector(1 downto 0);
	signal pcie_sv_hard_ip_i_powerdown6 : std_logic_vector(1 downto 0);
	signal pcie_sv_hard_ip_i_powerdown7 : std_logic_vector(1 downto 0);
	signal pcie_sv_hard_ip_i_rxpolarity0 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_rxpolarity1 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_rxpolarity2 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_rxpolarity3 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_rxpolarity4 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_rxpolarity5 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_rxpolarity6 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_rxpolarity7 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txcompl0 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txcompl1 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txcompl2 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txcompl3 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txcompl4 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txcompl5 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txcompl6 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txcompl7 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdata0 : std_logic_vector(7 downto 0);
	signal pcie_sv_hard_ip_i_txdata1 : std_logic_vector(7 downto 0);
	signal pcie_sv_hard_ip_i_txdata2 : std_logic_vector(7 downto 0);
	signal pcie_sv_hard_ip_i_txdata3 : std_logic_vector(7 downto 0);
	signal pcie_sv_hard_ip_i_txdata4 : std_logic_vector(7 downto 0);
	signal pcie_sv_hard_ip_i_txdata5 : std_logic_vector(7 downto 0);
	signal pcie_sv_hard_ip_i_txdata6 : std_logic_vector(7 downto 0);
	signal pcie_sv_hard_ip_i_txdata7 : std_logic_vector(7 downto 0);
	signal pcie_sv_hard_ip_i_txdatak0 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdatak1 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdatak2 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdatak3 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdatak4 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdatak5 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdatak6 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdatak7 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdetectrx0 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdetectrx1 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdetectrx2 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdetectrx3 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdetectrx4 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdetectrx5 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdetectrx6 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdetectrx7 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txelecidle0 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txelecidle1 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txelecidle2 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txelecidle3 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txelecidle4 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txelecidle5 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txelecidle6 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txelecidle7 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdeemph0 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdeemph1 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdeemph2 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdeemph3 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdeemph4 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdeemph5 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdeemph6 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txdeemph7 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txmargin0 : std_logic_vector(2 downto 0);
	signal pcie_sv_hard_ip_i_txmargin1 : std_logic_vector(2 downto 0);
	signal pcie_sv_hard_ip_i_txmargin2 : std_logic_vector(2 downto 0);
	signal pcie_sv_hard_ip_i_txmargin3 : std_logic_vector(2 downto 0);
	signal pcie_sv_hard_ip_i_txmargin4 : std_logic_vector(2 downto 0);
	signal pcie_sv_hard_ip_i_txmargin5 : std_logic_vector(2 downto 0);
	signal pcie_sv_hard_ip_i_txmargin6 : std_logic_vector(2 downto 0);
	signal pcie_sv_hard_ip_i_txmargin7 : std_logic_vector(2 downto 0);
	signal pcie_sv_hard_ip_i_txswing0 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txswing1 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txswing2 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txswing3 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txswing4 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txswing5 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txswing6 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_txswing7 : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_app_int_ack : std_logic_vector(0 downto 0);
	signal pcie_sv_hard_ip_i_app_msi_ack : std_logic_vector(0 downto 0);
	signal pcie_altclkctrl_i_outclk : std_logic_vector(0 downto 0);
	signal pcie_reset_n : std_logic_vector(0 downto 0) := "0";
	signal pcie_reset_n_rr : std_logic_vector(0 downto 0) := "0";
	signal pcie_reset_n_r : std_logic_vector(0 downto 0) := "0";
	signal reg_async_reset : std_logic_vector(0 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	reg_async_reset <= pcie_sv_hard_ip_i_reset_status;
	tx_out0 <= vec_to_bit(pcie_sv_hard_ip_i_tx_out0);
	tx_out1 <= vec_to_bit(pcie_sv_hard_ip_i_tx_out1);
	tx_out2 <= vec_to_bit(pcie_sv_hard_ip_i_tx_out2);
	tx_out3 <= vec_to_bit(pcie_sv_hard_ip_i_tx_out3);
	tx_out4 <= vec_to_bit(pcie_sv_hard_ip_i_tx_out4);
	tx_out5 <= vec_to_bit(pcie_sv_hard_ip_i_tx_out5);
	tx_out6 <= vec_to_bit(pcie_sv_hard_ip_i_tx_out6);
	tx_out7 <= vec_to_bit(pcie_sv_hard_ip_i_tx_out7);
	clk_pcie <= vec_to_bit(pcie_altclkctrl_i_outclk);
	rst_pcie_n <= vec_to_bit(pcie_reset_n);
	app_int_ack <= vec_to_bit(pcie_sv_hard_ip_i_app_int_ack);
	app_msi_ack <= vec_to_bit(pcie_sv_hard_ip_i_app_msi_ack);
	tl_cfg_ctl <= pcie_sv_hard_ip_i_tl_cfg_ctl;
	tl_cfg_add <= pcie_sv_hard_ip_i_tl_cfg_add;
	ltssmstate <= pcie_sv_hard_ip_i_ltssmstate;
	tx_st_ready <= vec_to_bit(pcie_sv_hard_ip_i_tx_st_ready);
	rx_st_valid <= vec_to_bit(pcie_sv_hard_ip_i_rx_st_valid);
	rx_st_sop <= vec_to_bit(pcie_sv_hard_ip_i_rx_st_sop);
	rx_st_eop <= vec_to_bit(pcie_sv_hard_ip_i_rx_st_eop);
	rx_st_empty <= pcie_sv_hard_ip_i_rx_st_empty;
	rx_st_err <= vec_to_bit(pcie_sv_hard_ip_i_rx_st_err);
	rx_st_bar <= pcie_sv_hard_ip_i_rx_st_bar;
	rx_st_data <= pcie_sv_hard_ip_i_rx_st_data;
	reconfig_from_xcvr <= pcie_sv_hard_ip_i_reconfig_from_xcvr;
	sim_pipe_rate <= pcie_sv_hard_ip_i_sim_pipe_rate;
	sim_ltssmstate <= pcie_sv_hard_ip_i_sim_ltssmstate;
	eidleinfersel0 <= pcie_sv_hard_ip_i_eidleinfersel0;
	eidleinfersel1 <= pcie_sv_hard_ip_i_eidleinfersel1;
	eidleinfersel2 <= pcie_sv_hard_ip_i_eidleinfersel2;
	eidleinfersel3 <= pcie_sv_hard_ip_i_eidleinfersel3;
	eidleinfersel4 <= pcie_sv_hard_ip_i_eidleinfersel4;
	eidleinfersel5 <= pcie_sv_hard_ip_i_eidleinfersel5;
	eidleinfersel6 <= pcie_sv_hard_ip_i_eidleinfersel6;
	eidleinfersel7 <= pcie_sv_hard_ip_i_eidleinfersel7;
	powerdown0 <= pcie_sv_hard_ip_i_powerdown0;
	powerdown1 <= pcie_sv_hard_ip_i_powerdown1;
	powerdown2 <= pcie_sv_hard_ip_i_powerdown2;
	powerdown3 <= pcie_sv_hard_ip_i_powerdown3;
	powerdown4 <= pcie_sv_hard_ip_i_powerdown4;
	powerdown5 <= pcie_sv_hard_ip_i_powerdown5;
	powerdown6 <= pcie_sv_hard_ip_i_powerdown6;
	powerdown7 <= pcie_sv_hard_ip_i_powerdown7;
	rxpolarity0 <= vec_to_bit(pcie_sv_hard_ip_i_rxpolarity0);
	rxpolarity1 <= vec_to_bit(pcie_sv_hard_ip_i_rxpolarity1);
	rxpolarity2 <= vec_to_bit(pcie_sv_hard_ip_i_rxpolarity2);
	rxpolarity3 <= vec_to_bit(pcie_sv_hard_ip_i_rxpolarity3);
	rxpolarity4 <= vec_to_bit(pcie_sv_hard_ip_i_rxpolarity4);
	rxpolarity5 <= vec_to_bit(pcie_sv_hard_ip_i_rxpolarity5);
	rxpolarity6 <= vec_to_bit(pcie_sv_hard_ip_i_rxpolarity6);
	rxpolarity7 <= vec_to_bit(pcie_sv_hard_ip_i_rxpolarity7);
	txcompl0 <= vec_to_bit(pcie_sv_hard_ip_i_txcompl0);
	txcompl1 <= vec_to_bit(pcie_sv_hard_ip_i_txcompl1);
	txcompl2 <= vec_to_bit(pcie_sv_hard_ip_i_txcompl2);
	txcompl3 <= vec_to_bit(pcie_sv_hard_ip_i_txcompl3);
	txcompl4 <= vec_to_bit(pcie_sv_hard_ip_i_txcompl4);
	txcompl5 <= vec_to_bit(pcie_sv_hard_ip_i_txcompl5);
	txcompl6 <= vec_to_bit(pcie_sv_hard_ip_i_txcompl6);
	txcompl7 <= vec_to_bit(pcie_sv_hard_ip_i_txcompl7);
	txdata0 <= pcie_sv_hard_ip_i_txdata0;
	txdata1 <= pcie_sv_hard_ip_i_txdata1;
	txdata2 <= pcie_sv_hard_ip_i_txdata2;
	txdata3 <= pcie_sv_hard_ip_i_txdata3;
	txdata4 <= pcie_sv_hard_ip_i_txdata4;
	txdata5 <= pcie_sv_hard_ip_i_txdata5;
	txdata6 <= pcie_sv_hard_ip_i_txdata6;
	txdata7 <= pcie_sv_hard_ip_i_txdata7;
	txdatak0 <= vec_to_bit(pcie_sv_hard_ip_i_txdatak0);
	txdatak1 <= vec_to_bit(pcie_sv_hard_ip_i_txdatak1);
	txdatak2 <= vec_to_bit(pcie_sv_hard_ip_i_txdatak2);
	txdatak3 <= vec_to_bit(pcie_sv_hard_ip_i_txdatak3);
	txdatak4 <= vec_to_bit(pcie_sv_hard_ip_i_txdatak4);
	txdatak5 <= vec_to_bit(pcie_sv_hard_ip_i_txdatak5);
	txdatak6 <= vec_to_bit(pcie_sv_hard_ip_i_txdatak6);
	txdatak7 <= vec_to_bit(pcie_sv_hard_ip_i_txdatak7);
	txdetectrx0 <= vec_to_bit(pcie_sv_hard_ip_i_txdetectrx0);
	txdetectrx1 <= vec_to_bit(pcie_sv_hard_ip_i_txdetectrx1);
	txdetectrx2 <= vec_to_bit(pcie_sv_hard_ip_i_txdetectrx2);
	txdetectrx3 <= vec_to_bit(pcie_sv_hard_ip_i_txdetectrx3);
	txdetectrx4 <= vec_to_bit(pcie_sv_hard_ip_i_txdetectrx4);
	txdetectrx5 <= vec_to_bit(pcie_sv_hard_ip_i_txdetectrx5);
	txdetectrx6 <= vec_to_bit(pcie_sv_hard_ip_i_txdetectrx6);
	txdetectrx7 <= vec_to_bit(pcie_sv_hard_ip_i_txdetectrx7);
	txelecidle0 <= vec_to_bit(pcie_sv_hard_ip_i_txelecidle0);
	txelecidle1 <= vec_to_bit(pcie_sv_hard_ip_i_txelecidle1);
	txelecidle2 <= vec_to_bit(pcie_sv_hard_ip_i_txelecidle2);
	txelecidle3 <= vec_to_bit(pcie_sv_hard_ip_i_txelecidle3);
	txelecidle4 <= vec_to_bit(pcie_sv_hard_ip_i_txelecidle4);
	txelecidle5 <= vec_to_bit(pcie_sv_hard_ip_i_txelecidle5);
	txelecidle6 <= vec_to_bit(pcie_sv_hard_ip_i_txelecidle6);
	txelecidle7 <= vec_to_bit(pcie_sv_hard_ip_i_txelecidle7);
	txdeemph0 <= vec_to_bit(pcie_sv_hard_ip_i_txdeemph0);
	txdeemph1 <= vec_to_bit(pcie_sv_hard_ip_i_txdeemph1);
	txdeemph2 <= vec_to_bit(pcie_sv_hard_ip_i_txdeemph2);
	txdeemph3 <= vec_to_bit(pcie_sv_hard_ip_i_txdeemph3);
	txdeemph4 <= vec_to_bit(pcie_sv_hard_ip_i_txdeemph4);
	txdeemph5 <= vec_to_bit(pcie_sv_hard_ip_i_txdeemph5);
	txdeemph6 <= vec_to_bit(pcie_sv_hard_ip_i_txdeemph6);
	txdeemph7 <= vec_to_bit(pcie_sv_hard_ip_i_txdeemph7);
	txswing0 <= vec_to_bit(pcie_sv_hard_ip_i_txswing0);
	txswing1 <= vec_to_bit(pcie_sv_hard_ip_i_txswing1);
	txswing2 <= vec_to_bit(pcie_sv_hard_ip_i_txswing2);
	txswing3 <= vec_to_bit(pcie_sv_hard_ip_i_txswing3);
	txswing4 <= vec_to_bit(pcie_sv_hard_ip_i_txswing4);
	txswing5 <= vec_to_bit(pcie_sv_hard_ip_i_txswing5);
	txswing6 <= vec_to_bit(pcie_sv_hard_ip_i_txswing6);
	txswing7 <= vec_to_bit(pcie_sv_hard_ip_i_txswing7);
	txmargin0 <= pcie_sv_hard_ip_i_txmargin0;
	txmargin1 <= pcie_sv_hard_ip_i_txmargin1;
	txmargin2 <= pcie_sv_hard_ip_i_txmargin2;
	txmargin3 <= pcie_sv_hard_ip_i_txmargin3;
	txmargin4 <= pcie_sv_hard_ip_i_txmargin4;
	txmargin5 <= pcie_sv_hard_ip_i_txmargin5;
	txmargin6 <= pcie_sv_hard_ip_i_txmargin6;
	txmargin7 <= pcie_sv_hard_ip_i_txmargin7;
	
	-- Register processes
	
	regproc_ln125_stratixvhardippcie : process(pcie_altclkctrl_i_outclk(0), reg_async_reset)
	begin
		if reg_async_reset = "1" then
			pcie_reset_n <= "0";
		elsif rising_edge(pcie_altclkctrl_i_outclk(0)) then
			pcie_reset_n <= pcie_reset_n_rr;
		end if;
	end process;
	regproc_ln120_stratixvhardippcie : process(pcie_altclkctrl_i_outclk(0), reg_async_reset)
	begin
		if reg_async_reset = "1" then
			pcie_reset_n_rr <= "0";
		elsif rising_edge(pcie_altclkctrl_i_outclk(0)) then
			pcie_reset_n_rr <= pcie_reset_n_r;
		end if;
	end process;
	regproc_ln115_stratixvhardippcie : process(pcie_altclkctrl_i_outclk(0), reg_async_reset)
	begin
		if reg_async_reset = "1" then
			pcie_reset_n_r <= "0";
		elsif rising_edge(pcie_altclkctrl_i_outclk(0)) then
			pcie_reset_n_r <= "1";
		end if;
	end process;
	
	-- Entity instances
	
	pcie_SV_hard_ip_i : pcie_SV_hard_ip
		generic map (
			DEVICE_ID => 8,
			GEN_RATE => "Gen2 (5.0 Gbps)",
			MS_CYCLE_COUNT => 248500
		)
		port map (
			lmi_ack => pcie_sv_hard_ip_i_lmi_ack(0), -- 1 bits (out)
			lmi_dout => pcie_sv_hard_ip_i_lmi_dout, -- 32 bits (out)
			tl_cfg_add => pcie_sv_hard_ip_i_tl_cfg_add, -- 4 bits (out)
			tl_cfg_ctl => pcie_sv_hard_ip_i_tl_cfg_ctl, -- 32 bits (out)
			tl_cfg_sts => pcie_sv_hard_ip_i_tl_cfg_sts, -- 53 bits (out)
			pme_to_sr => pcie_sv_hard_ip_i_pme_to_sr(0), -- 1 bits (out)
			currentspeed => pcie_sv_hard_ip_i_currentspeed, -- 2 bits (out)
			derr_cor_ext_rcv => pcie_sv_hard_ip_i_derr_cor_ext_rcv(0), -- 1 bits (out)
			derr_cor_ext_rpl => pcie_sv_hard_ip_i_derr_cor_ext_rpl(0), -- 1 bits (out)
			derr_rpl => pcie_sv_hard_ip_i_derr_rpl(0), -- 1 bits (out)
			dlup => pcie_sv_hard_ip_i_dlup(0), -- 1 bits (out)
			dlup_exit => pcie_sv_hard_ip_i_dlup_exit(0), -- 1 bits (out)
			ev128ns => pcie_sv_hard_ip_i_ev128ns(0), -- 1 bits (out)
			ev1us => pcie_sv_hard_ip_i_ev1us(0), -- 1 bits (out)
			hotrst_exit => pcie_sv_hard_ip_i_hotrst_exit(0), -- 1 bits (out)
			int_status => pcie_sv_hard_ip_i_int_status, -- 4 bits (out)
			l2_exit => pcie_sv_hard_ip_i_l2_exit(0), -- 1 bits (out)
			lane_act => pcie_sv_hard_ip_i_lane_act, -- 4 bits (out)
			ltssmstate => pcie_sv_hard_ip_i_ltssmstate, -- 5 bits (out)
			rx_par_err => pcie_sv_hard_ip_i_rx_par_err(0), -- 1 bits (out)
			tx_par_err => pcie_sv_hard_ip_i_tx_par_err, -- 2 bits (out)
			cfg_par_err => pcie_sv_hard_ip_i_cfg_par_err(0), -- 1 bits (out)
			ko_cpl_spc_header => pcie_sv_hard_ip_i_ko_cpl_spc_header, -- 8 bits (out)
			ko_cpl_spc_data => pcie_sv_hard_ip_i_ko_cpl_spc_data, -- 12 bits (out)
			rx_st_valid => pcie_sv_hard_ip_i_rx_st_valid, -- 1 bits (out)
			rx_st_sop => pcie_sv_hard_ip_i_rx_st_sop, -- 1 bits (out)
			rx_st_eop => pcie_sv_hard_ip_i_rx_st_eop, -- 1 bits (out)
			rx_st_empty => pcie_sv_hard_ip_i_rx_st_empty, -- 2 bits (out)
			rx_st_err => pcie_sv_hard_ip_i_rx_st_err, -- 1 bits (out)
			rx_st_data => pcie_sv_hard_ip_i_rx_st_data, -- 128 bits (out)
			rx_st_bar => pcie_sv_hard_ip_i_rx_st_bar, -- 8 bits (out)
			tx_st_ready => pcie_sv_hard_ip_i_tx_st_ready(0), -- 1 bits (out)
			tx_cred_datafccp => pcie_sv_hard_ip_i_tx_cred_datafccp, -- 12 bits (out)
			tx_cred_datafcnp => pcie_sv_hard_ip_i_tx_cred_datafcnp, -- 12 bits (out)
			tx_cred_datafcp => pcie_sv_hard_ip_i_tx_cred_datafcp, -- 12 bits (out)
			tx_cred_fchipcons => pcie_sv_hard_ip_i_tx_cred_fchipcons, -- 6 bits (out)
			tx_cred_fcinfinite => pcie_sv_hard_ip_i_tx_cred_fcinfinite, -- 6 bits (out)
			tx_cred_hdrfccp => pcie_sv_hard_ip_i_tx_cred_hdrfccp, -- 8 bits (out)
			tx_cred_hdrfcnp => pcie_sv_hard_ip_i_tx_cred_hdrfcnp, -- 8 bits (out)
			tx_cred_hdrfcp => pcie_sv_hard_ip_i_tx_cred_hdrfcp, -- 8 bits (out)
			coreclkout_hip => pcie_sv_hard_ip_i_coreclkout_hip(0), -- 1 bits (out)
			reset_status => pcie_sv_hard_ip_i_reset_status(0), -- 1 bits (out)
			serdes_pll_locked => pcie_sv_hard_ip_i_serdes_pll_locked(0), -- 1 bits (out)
			pld_clk_inuse => pcie_sv_hard_ip_i_pld_clk_inuse(0), -- 1 bits (out)
			testin_zero => pcie_sv_hard_ip_i_testin_zero(0), -- 1 bits (out)
			reconfig_from_xcvr => pcie_sv_hard_ip_i_reconfig_from_xcvr, -- 460 bits (out)
			tx_out0 => pcie_sv_hard_ip_i_tx_out0(0), -- 1 bits (out)
			tx_out1 => pcie_sv_hard_ip_i_tx_out1(0), -- 1 bits (out)
			tx_out2 => pcie_sv_hard_ip_i_tx_out2(0), -- 1 bits (out)
			tx_out3 => pcie_sv_hard_ip_i_tx_out3(0), -- 1 bits (out)
			tx_out4 => pcie_sv_hard_ip_i_tx_out4(0), -- 1 bits (out)
			tx_out5 => pcie_sv_hard_ip_i_tx_out5(0), -- 1 bits (out)
			tx_out6 => pcie_sv_hard_ip_i_tx_out6(0), -- 1 bits (out)
			tx_out7 => pcie_sv_hard_ip_i_tx_out7(0), -- 1 bits (out)
			sim_pipe_rate => pcie_sv_hard_ip_i_sim_pipe_rate, -- 2 bits (out)
			sim_ltssmstate => pcie_sv_hard_ip_i_sim_ltssmstate, -- 5 bits (out)
			eidleinfersel0 => pcie_sv_hard_ip_i_eidleinfersel0, -- 3 bits (out)
			eidleinfersel1 => pcie_sv_hard_ip_i_eidleinfersel1, -- 3 bits (out)
			eidleinfersel2 => pcie_sv_hard_ip_i_eidleinfersel2, -- 3 bits (out)
			eidleinfersel3 => pcie_sv_hard_ip_i_eidleinfersel3, -- 3 bits (out)
			eidleinfersel4 => pcie_sv_hard_ip_i_eidleinfersel4, -- 3 bits (out)
			eidleinfersel5 => pcie_sv_hard_ip_i_eidleinfersel5, -- 3 bits (out)
			eidleinfersel6 => pcie_sv_hard_ip_i_eidleinfersel6, -- 3 bits (out)
			eidleinfersel7 => pcie_sv_hard_ip_i_eidleinfersel7, -- 3 bits (out)
			powerdown0 => pcie_sv_hard_ip_i_powerdown0, -- 2 bits (out)
			powerdown1 => pcie_sv_hard_ip_i_powerdown1, -- 2 bits (out)
			powerdown2 => pcie_sv_hard_ip_i_powerdown2, -- 2 bits (out)
			powerdown3 => pcie_sv_hard_ip_i_powerdown3, -- 2 bits (out)
			powerdown4 => pcie_sv_hard_ip_i_powerdown4, -- 2 bits (out)
			powerdown5 => pcie_sv_hard_ip_i_powerdown5, -- 2 bits (out)
			powerdown6 => pcie_sv_hard_ip_i_powerdown6, -- 2 bits (out)
			powerdown7 => pcie_sv_hard_ip_i_powerdown7, -- 2 bits (out)
			rxpolarity0 => pcie_sv_hard_ip_i_rxpolarity0(0), -- 1 bits (out)
			rxpolarity1 => pcie_sv_hard_ip_i_rxpolarity1(0), -- 1 bits (out)
			rxpolarity2 => pcie_sv_hard_ip_i_rxpolarity2(0), -- 1 bits (out)
			rxpolarity3 => pcie_sv_hard_ip_i_rxpolarity3(0), -- 1 bits (out)
			rxpolarity4 => pcie_sv_hard_ip_i_rxpolarity4(0), -- 1 bits (out)
			rxpolarity5 => pcie_sv_hard_ip_i_rxpolarity5(0), -- 1 bits (out)
			rxpolarity6 => pcie_sv_hard_ip_i_rxpolarity6(0), -- 1 bits (out)
			rxpolarity7 => pcie_sv_hard_ip_i_rxpolarity7(0), -- 1 bits (out)
			txcompl0 => pcie_sv_hard_ip_i_txcompl0(0), -- 1 bits (out)
			txcompl1 => pcie_sv_hard_ip_i_txcompl1(0), -- 1 bits (out)
			txcompl2 => pcie_sv_hard_ip_i_txcompl2(0), -- 1 bits (out)
			txcompl3 => pcie_sv_hard_ip_i_txcompl3(0), -- 1 bits (out)
			txcompl4 => pcie_sv_hard_ip_i_txcompl4(0), -- 1 bits (out)
			txcompl5 => pcie_sv_hard_ip_i_txcompl5(0), -- 1 bits (out)
			txcompl6 => pcie_sv_hard_ip_i_txcompl6(0), -- 1 bits (out)
			txcompl7 => pcie_sv_hard_ip_i_txcompl7(0), -- 1 bits (out)
			txdata0 => pcie_sv_hard_ip_i_txdata0, -- 8 bits (out)
			txdata1 => pcie_sv_hard_ip_i_txdata1, -- 8 bits (out)
			txdata2 => pcie_sv_hard_ip_i_txdata2, -- 8 bits (out)
			txdata3 => pcie_sv_hard_ip_i_txdata3, -- 8 bits (out)
			txdata4 => pcie_sv_hard_ip_i_txdata4, -- 8 bits (out)
			txdata5 => pcie_sv_hard_ip_i_txdata5, -- 8 bits (out)
			txdata6 => pcie_sv_hard_ip_i_txdata6, -- 8 bits (out)
			txdata7 => pcie_sv_hard_ip_i_txdata7, -- 8 bits (out)
			txdatak0 => pcie_sv_hard_ip_i_txdatak0(0), -- 1 bits (out)
			txdatak1 => pcie_sv_hard_ip_i_txdatak1(0), -- 1 bits (out)
			txdatak2 => pcie_sv_hard_ip_i_txdatak2(0), -- 1 bits (out)
			txdatak3 => pcie_sv_hard_ip_i_txdatak3(0), -- 1 bits (out)
			txdatak4 => pcie_sv_hard_ip_i_txdatak4(0), -- 1 bits (out)
			txdatak5 => pcie_sv_hard_ip_i_txdatak5(0), -- 1 bits (out)
			txdatak6 => pcie_sv_hard_ip_i_txdatak6(0), -- 1 bits (out)
			txdatak7 => pcie_sv_hard_ip_i_txdatak7(0), -- 1 bits (out)
			txdetectrx0 => pcie_sv_hard_ip_i_txdetectrx0(0), -- 1 bits (out)
			txdetectrx1 => pcie_sv_hard_ip_i_txdetectrx1(0), -- 1 bits (out)
			txdetectrx2 => pcie_sv_hard_ip_i_txdetectrx2(0), -- 1 bits (out)
			txdetectrx3 => pcie_sv_hard_ip_i_txdetectrx3(0), -- 1 bits (out)
			txdetectrx4 => pcie_sv_hard_ip_i_txdetectrx4(0), -- 1 bits (out)
			txdetectrx5 => pcie_sv_hard_ip_i_txdetectrx5(0), -- 1 bits (out)
			txdetectrx6 => pcie_sv_hard_ip_i_txdetectrx6(0), -- 1 bits (out)
			txdetectrx7 => pcie_sv_hard_ip_i_txdetectrx7(0), -- 1 bits (out)
			txelecidle0 => pcie_sv_hard_ip_i_txelecidle0(0), -- 1 bits (out)
			txelecidle1 => pcie_sv_hard_ip_i_txelecidle1(0), -- 1 bits (out)
			txelecidle2 => pcie_sv_hard_ip_i_txelecidle2(0), -- 1 bits (out)
			txelecidle3 => pcie_sv_hard_ip_i_txelecidle3(0), -- 1 bits (out)
			txelecidle4 => pcie_sv_hard_ip_i_txelecidle4(0), -- 1 bits (out)
			txelecidle5 => pcie_sv_hard_ip_i_txelecidle5(0), -- 1 bits (out)
			txelecidle6 => pcie_sv_hard_ip_i_txelecidle6(0), -- 1 bits (out)
			txelecidle7 => pcie_sv_hard_ip_i_txelecidle7(0), -- 1 bits (out)
			txdeemph0 => pcie_sv_hard_ip_i_txdeemph0(0), -- 1 bits (out)
			txdeemph1 => pcie_sv_hard_ip_i_txdeemph1(0), -- 1 bits (out)
			txdeemph2 => pcie_sv_hard_ip_i_txdeemph2(0), -- 1 bits (out)
			txdeemph3 => pcie_sv_hard_ip_i_txdeemph3(0), -- 1 bits (out)
			txdeemph4 => pcie_sv_hard_ip_i_txdeemph4(0), -- 1 bits (out)
			txdeemph5 => pcie_sv_hard_ip_i_txdeemph5(0), -- 1 bits (out)
			txdeemph6 => pcie_sv_hard_ip_i_txdeemph6(0), -- 1 bits (out)
			txdeemph7 => pcie_sv_hard_ip_i_txdeemph7(0), -- 1 bits (out)
			txmargin0 => pcie_sv_hard_ip_i_txmargin0, -- 3 bits (out)
			txmargin1 => pcie_sv_hard_ip_i_txmargin1, -- 3 bits (out)
			txmargin2 => pcie_sv_hard_ip_i_txmargin2, -- 3 bits (out)
			txmargin3 => pcie_sv_hard_ip_i_txmargin3, -- 3 bits (out)
			txmargin4 => pcie_sv_hard_ip_i_txmargin4, -- 3 bits (out)
			txmargin5 => pcie_sv_hard_ip_i_txmargin5, -- 3 bits (out)
			txmargin6 => pcie_sv_hard_ip_i_txmargin6, -- 3 bits (out)
			txmargin7 => pcie_sv_hard_ip_i_txmargin7, -- 3 bits (out)
			txswing0 => pcie_sv_hard_ip_i_txswing0(0), -- 1 bits (out)
			txswing1 => pcie_sv_hard_ip_i_txswing1(0), -- 1 bits (out)
			txswing2 => pcie_sv_hard_ip_i_txswing2(0), -- 1 bits (out)
			txswing3 => pcie_sv_hard_ip_i_txswing3(0), -- 1 bits (out)
			txswing4 => pcie_sv_hard_ip_i_txswing4(0), -- 1 bits (out)
			txswing5 => pcie_sv_hard_ip_i_txswing5(0), -- 1 bits (out)
			txswing6 => pcie_sv_hard_ip_i_txswing6(0), -- 1 bits (out)
			txswing7 => pcie_sv_hard_ip_i_txswing7(0), -- 1 bits (out)
			app_int_ack => pcie_sv_hard_ip_i_app_int_ack(0), -- 1 bits (out)
			app_msi_ack => pcie_sv_hard_ip_i_app_msi_ack(0), -- 1 bits (out)
			npor => pcie_npor, -- 1 bits (in)
			pin_perst => pcie_pin_perst, -- 1 bits (in)
			lmi_addr => "000000000000", -- 12 bits (in)
			lmi_din => "00000000000000000000000000000000", -- 32 bits (in)
			lmi_rden => vec_to_bit("0"), -- 1 bits (in)
			lmi_wren => vec_to_bit("0"), -- 1 bits (in)
			hpg_ctrler => "00000", -- 5 bits (in)
			cpl_err => cpl_err, -- 7 bits (in)
			cpl_pending => cpl_pending, -- 1 bits (in)
			pm_auxpwr => vec_to_bit("0"), -- 1 bits (in)
			pm_data => "0000000000", -- 10 bits (in)
			pme_to_cr => vec_to_bit("0"), -- 1 bits (in)
			pm_event => vec_to_bit("0"), -- 1 bits (in)
			test_in => test_in, -- 32 bits (in)
			simu_mode_pipe => simu_mode_pipe, -- 1 bits (in)
			rx_st_ready => rx_st_ready, -- 1 bits (in)
			rx_st_mask => bit_to_vec(rx_st_mask), -- 1 bits (in)
			tx_st_valid => bit_to_vec(tx_st_valid), -- 1 bits (in)
			tx_st_sop => bit_to_vec(tx_st_sop), -- 1 bits (in)
			tx_st_eop => bit_to_vec(tx_st_eop), -- 1 bits (in)
			tx_st_empty => tx_st_empty, -- 2 bits (in)
			tx_st_err => bit_to_vec(tx_st_err), -- 1 bits (in)
			tx_st_data => tx_st_data, -- 128 bits (in)
			pld_clk => vec_to_bit(pcie_sv_hard_ip_i_coreclkout_hip), -- 1 bits (in)
			refclk => pcie_ref_clk, -- 1 bits (in)
			pld_core_ready => vec_to_bit(pcie_sv_hard_ip_i_serdes_pll_locked), -- 1 bits (in)
			reconfig_to_xcvr => reconfig_to_xcvr, -- 700 bits (in)
			rx_in0 => rx_in0, -- 1 bits (in)
			rx_in1 => rx_in1, -- 1 bits (in)
			rx_in2 => rx_in2, -- 1 bits (in)
			rx_in3 => rx_in3, -- 1 bits (in)
			rx_in4 => rx_in4, -- 1 bits (in)
			rx_in5 => rx_in5, -- 1 bits (in)
			rx_in6 => rx_in6, -- 1 bits (in)
			rx_in7 => rx_in7, -- 1 bits (in)
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
			rxvalid7 => rxvalid7, -- 1 bits (in)
			app_int_sts => app_int_sts, -- 1 bits (in)
			app_msi_num => app_msi_num, -- 5 bits (in)
			app_msi_req => app_msi_req, -- 1 bits (in)
			app_msi_tc => app_msi_tc -- 3 bits (in)
		);
	pcie_altclkctrl_i : MWAltClkCtrl_quartusv13_1_0_GCLK_numclk_1
		port map (
			outclk => pcie_altclkctrl_i_outclk(0), -- 1 bits (out)
			inclk => vec_to_bit(pcie_sv_hard_ip_i_coreclkout_hip) -- 1 bits (in)
		);
end MaxDC;
