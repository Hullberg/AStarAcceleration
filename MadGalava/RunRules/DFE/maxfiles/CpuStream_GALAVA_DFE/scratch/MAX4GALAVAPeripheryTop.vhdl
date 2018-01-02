library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity MAX4GALAVAPeripheryTop is
	port (
		cclk: in std_logic;
		sys_rst_n: in std_logic;
		pcie_ref_clk: in std_logic;
		pcie_pin_perst: in std_logic;
		left_pll_ref_clk: in std_logic;
		right_pll_ref_clk: in std_logic;
		maxring_refclk: in std_logic;
		rx_in0: in std_logic;
		rx_in1: in std_logic;
		rx_in2: in std_logic;
		rx_in3: in std_logic;
		rx_in4: in std_logic;
		rx_in5: in std_logic;
		rx_in6: in std_logic;
		rx_in7: in std_logic;
		from_flash_valid: in std_logic;
		sda_in: in std_logic;
		ssync_in: in std_logic;
		flash_data: inout std_logic_vector(9 downto 0);
		fpga_config_fpp_data: inout std_logic_vector(15 downto 0);
		tx_out0: out std_logic;
		tx_out1: out std_logic;
		tx_out2: out std_logic;
		tx_out3: out std_logic;
		tx_out4: out std_logic;
		tx_out5: out std_logic;
		tx_out6: out std_logic;
		tx_out7: out std_logic;
		to_flash_valid: out std_logic;
		sda_out: out std_logic
	);
end MAX4GALAVAPeripheryTop;

architecture MaxDC of MAX4GALAVAPeripheryTop is
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
	component MAX4FPGATop is
		port (
			sys_clk: in std_logic;
			cclk: in std_logic;
			pll_mgmt_readdata0: in std_logic_vector(31 downto 0);
			pll_mgmt_waitrequest0: in std_logic;
			pll_inst_locked0: in std_logic;
			stream_clocks_gen_output_clk0: in std_logic;
			stream_clocks_gen_output_clk_inv0: in std_logic;
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			app_int_ack: in std_logic;
			app_msi_ack: in std_logic;
			tl_cfg_ctl: in std_logic_vector(31 downto 0);
			tl_cfg_add: in std_logic_vector(3 downto 0);
			ltssmstate: in std_logic_vector(4 downto 0);
			tx_st_ready: in std_logic;
			rx_st_valid: in std_logic;
			rx_st_sop: in std_logic;
			rx_st_eop: in std_logic;
			rx_st_empty: in std_logic_vector(1 downto 0);
			rx_st_err: in std_logic;
			rx_st_bar: in std_logic_vector(7 downto 0);
			rx_st_data: in std_logic_vector(127 downto 0);
			i2c_left_dimm_SCL_fb: in std_logic;
			i2c_left_dimm_SDA_fb: in std_logic;
			i2c_right_dimm_SCL_fb: in std_logic;
			i2c_right_dimm_SDA_fb: in std_logic;
			i2c_dimm_alert: in std_logic;
			i2c_aux_SCL_fb: in std_logic;
			i2c_aux_SDA_fb: in std_logic;
			i2c_aux_ALERT: in std_logic;
			pmbus_SCL_fb: in std_logic;
			pmbus_SDA_fb: in std_logic;
			pmbus_ALERT: in std_logic;
			host_event_status: in std_logic_vector(96 downto 0);
			config_FPGA_INIT_DONE: in std_logic;
			config_FPGA_CRC_ERROR: in std_logic;
			config_FPGA_CvP_CONFDONE: in std_logic;
			rev_DIPSW: in std_logic_vector(3 downto 0);
			rev_ASSY_REV: in std_logic_vector(1 downto 0);
			rev_PCB_REV: in std_logic_vector(1 downto 0);
			rev_CPLD_Version: in std_logic_vector(7 downto 0);
			rev_BUILD_REV: in std_logic_vector(1 downto 0);
			flash_control_flash_rx_d: in std_logic_vector(63 downto 0);
			pll_mgmt_clk0: out std_logic;
			pll_mgmt_rst0: out std_logic;
			pll_mgmt_address0: out std_logic_vector(5 downto 0);
			pll_mgmt_read0: out std_logic;
			pll_mgmt_write0: out std_logic;
			pll_mgmt_writedata0: out std_logic_vector(31 downto 0);
			pll_rst0: out std_logic;
			clkbuf_clken0: out std_logic;
			app_int_sts: out std_logic;
			app_msi_req: out std_logic;
			app_msi_num: out std_logic_vector(4 downto 0);
			app_msi_tc: out std_logic_vector(2 downto 0);
			tx_st_valid: out std_logic;
			tx_st_sop: out std_logic;
			tx_st_eop: out std_logic;
			tx_st_empty: out std_logic_vector(1 downto 0);
			tx_st_err: out std_logic;
			tx_st_data: out std_logic_vector(127 downto 0);
			rx_st_ready: out std_logic;
			rx_st_mask: out std_logic;
			cpl_err: out std_logic_vector(6 downto 0);
			cpl_pending: out std_logic;
			slave_leds: out std_logic_vector(1 downto 0);
			i2c_left_dimm_SCL_drv: out std_logic;
			i2c_left_dimm_SDA_drv: out std_logic;
			i2c_right_dimm_SCL_drv: out std_logic;
			i2c_right_dimm_SDA_drv: out std_logic;
			i2c_aux_SCL_drv: out std_logic;
			i2c_aux_SDA_drv: out std_logic;
			pmbus_SCL_drv: out std_logic;
			pmbus_SDA_drv: out std_logic;
			host_event_ack: out std_logic_vector(96 downto 0);
			config_Reconfig_Trigger: out std_logic;
			flash_control_flash_rx_addr: out std_logic;
			flash_control_flash_tx_d: out std_logic_vector(63 downto 0);
			flash_control_flash_tx_we: out std_logic
		);
	end component;
	component AlteraClockGenerator_250_100_STREAM is
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
	end component;
	component StratixPCIeBase is
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
	end component;
	component MAX4CPLDInterface is
		port (
			sys_rst_n: in std_logic;
			cclk: in std_logic;
			pcie_clk: in std_logic;
			led_phy_up: in std_logic_vector(5 downto 0);
			led_maxring: in std_logic_vector(1 downto 0);
			led_pan_maxring: in std_logic_vector(1 downto 0);
			led_pcie: in std_logic_vector(1 downto 0);
			from_flash_valid: in std_logic;
			PMBUS_SCL_drv: in std_logic;
			PMBUS_SDA_drv: in std_logic;
			DIMM_LEFT_SCL_drv: in std_logic;
			DIMM_LEFT_SDA_drv: in std_logic;
			DIMM_RIGHT_SCL_drv: in std_logic;
			DIMM_RIGHT_SDA_drv: in std_logic;
			AUX_SCL_drv: in std_logic;
			AUX_SDA_drv: in std_logic;
			qsfp0_i2c_SCL_drv: in std_logic;
			qsfp0_i2c_SDA_drv: in std_logic;
			qsfp0_i2c_lpmode: in std_logic;
			qsfp0_i2c_modsell: in std_logic;
			qsfp0_i2c_resetl: in std_logic;
			qsfp1_i2c_SCL_drv: in std_logic;
			qsfp1_i2c_SDA_drv: in std_logic;
			qsfp1_i2c_lpmode: in std_logic;
			qsfp1_i2c_modsell: in std_logic;
			qsfp1_i2c_resetl: in std_logic;
			qsfp2_i2c_SCL_drv: in std_logic;
			qsfp2_i2c_SDA_drv: in std_logic;
			qsfp2_i2c_lpmode: in std_logic;
			qsfp2_i2c_modsell: in std_logic;
			qsfp2_i2c_resetl: in std_logic;
			qsfp3_i2c_SCL_drv: in std_logic;
			qsfp3_i2c_SDA_drv: in std_logic;
			qsfp3_i2c_lpmode: in std_logic;
			qsfp3_i2c_modsell: in std_logic;
			qsfp3_i2c_resetl: in std_logic;
			qsfp4_i2c_SCL_drv: in std_logic;
			qsfp4_i2c_SDA_drv: in std_logic;
			qsfp4_i2c_lpmode: in std_logic;
			qsfp4_i2c_modsell: in std_logic;
			qsfp4_i2c_resetl: in std_logic;
			qsfp5_i2c_SCL_drv: in std_logic;
			qsfp5_i2c_SDA_drv: in std_logic;
			qsfp5_i2c_lpmode: in std_logic;
			qsfp5_i2c_modsell: in std_logic;
			qsfp5_i2c_resetl: in std_logic;
			qsfp6_i2c_SCL_drv: in std_logic;
			qsfp6_i2c_SDA_drv: in std_logic;
			qsfp6_i2c_lpmode: in std_logic;
			qsfp6_i2c_modsell: in std_logic;
			qsfp6_i2c_resetl: in std_logic;
			qsfp7_i2c_SCL_drv: in std_logic;
			qsfp7_i2c_SDA_drv: in std_logic;
			qsfp7_i2c_lpmode: in std_logic;
			qsfp7_i2c_modsell: in std_logic;
			qsfp7_i2c_resetl: in std_logic;
			host_event_ack: in std_logic_vector(96 downto 0);
			config_Reconfig_Trigger: in std_logic;
			flash_control_flash_rx_addr: in std_logic;
			flash_control_flash_tx_d: in std_logic_vector(63 downto 0);
			flash_control_flash_tx_we: in std_logic;
			sda_in: in std_logic;
			ssync_in: in std_logic;
			MAXRING_B_RESET: in std_logic;
			flash_data: inout std_logic_vector(9 downto 0);
			fpga_config_fpp_data: inout std_logic_vector(15 downto 0);
			to_flash_valid: out std_logic;
			PMBUS_SCL_fb: out std_logic;
			PMBUS_SDA_fb: out std_logic;
			PMBUS_ALERT: out std_logic;
			DIMM_LEFT_SCL_fb: out std_logic;
			DIMM_LEFT_SDA_fb: out std_logic;
			DIMM_RIGHT_SCL_fb: out std_logic;
			DIMM_RIGHT_SDA_fb: out std_logic;
			DIMM_ALERT: out std_logic;
			AUX_SCL_fb: out std_logic;
			AUX_SDA_fb: out std_logic;
			AUX_ALERT: out std_logic;
			qsfp0_i2c_SCL_fb: out std_logic;
			qsfp0_i2c_SDA_fb: out std_logic;
			qsfp0_i2c_ALERT: out std_logic;
			qsfp0_i2c_modprsl: out std_logic;
			qsfp1_i2c_SCL_fb: out std_logic;
			qsfp1_i2c_SDA_fb: out std_logic;
			qsfp1_i2c_ALERT: out std_logic;
			qsfp1_i2c_modprsl: out std_logic;
			qsfp2_i2c_SCL_fb: out std_logic;
			qsfp2_i2c_SDA_fb: out std_logic;
			qsfp2_i2c_ALERT: out std_logic;
			qsfp2_i2c_modprsl: out std_logic;
			qsfp3_i2c_SCL_fb: out std_logic;
			qsfp3_i2c_SDA_fb: out std_logic;
			qsfp3_i2c_ALERT: out std_logic;
			qsfp3_i2c_modprsl: out std_logic;
			qsfp4_i2c_SCL_fb: out std_logic;
			qsfp4_i2c_SDA_fb: out std_logic;
			qsfp4_i2c_ALERT: out std_logic;
			qsfp4_i2c_modprsl: out std_logic;
			qsfp5_i2c_SCL_fb: out std_logic;
			qsfp5_i2c_SDA_fb: out std_logic;
			qsfp5_i2c_ALERT: out std_logic;
			qsfp5_i2c_modprsl: out std_logic;
			qsfp6_i2c_SCL_fb: out std_logic;
			qsfp6_i2c_SDA_fb: out std_logic;
			qsfp6_i2c_ALERT: out std_logic;
			qsfp6_i2c_modprsl: out std_logic;
			qsfp7_i2c_SCL_fb: out std_logic;
			qsfp7_i2c_SDA_fb: out std_logic;
			qsfp7_i2c_ALERT: out std_logic;
			qsfp7_i2c_modprsl: out std_logic;
			host_event_status: out std_logic_vector(96 downto 0);
			config_FPGA_INIT_DONE: out std_logic;
			config_FPGA_CRC_ERROR: out std_logic;
			config_FPGA_CvP_CONFDONE: out std_logic;
			rev_DIPSW: out std_logic_vector(3 downto 0);
			rev_ASSY_REV: out std_logic_vector(1 downto 0);
			rev_PCB_REV: out std_logic_vector(1 downto 0);
			rev_CPLD_Version: out std_logic_vector(7 downto 0);
			rev_BUILD_REV: out std_logic_vector(1 downto 0);
			flash_control_flash_rx_d: out std_logic_vector(63 downto 0);
			sda_out: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal max4galavafabrictop_i_pll_mgmt_clk0 : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_pll_mgmt_rst0 : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_pll_mgmt_address0 : std_logic_vector(5 downto 0);
	signal max4galavafabrictop_i_pll_mgmt_read0 : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_pll_mgmt_write0 : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_pll_mgmt_writedata0 : std_logic_vector(31 downto 0);
	signal max4galavafabrictop_i_pll_rst0 : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_clkbuf_clken0 : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_app_int_sts : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_app_msi_req : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_app_msi_num : std_logic_vector(4 downto 0);
	signal max4galavafabrictop_i_app_msi_tc : std_logic_vector(2 downto 0);
	signal max4galavafabrictop_i_tx_st_valid : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_tx_st_sop : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_tx_st_eop : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_tx_st_empty : std_logic_vector(1 downto 0);
	signal max4galavafabrictop_i_tx_st_err : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_tx_st_data : std_logic_vector(127 downto 0);
	signal max4galavafabrictop_i_rx_st_ready : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_rx_st_mask : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_cpl_err : std_logic_vector(6 downto 0);
	signal max4galavafabrictop_i_cpl_pending : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_slave_leds : std_logic_vector(1 downto 0);
	signal max4galavafabrictop_i_i2c_left_dimm_scl_drv : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_i2c_left_dimm_sda_drv : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_i2c_right_dimm_scl_drv : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_i2c_right_dimm_sda_drv : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_i2c_aux_scl_drv : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_i2c_aux_sda_drv : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_pmbus_scl_drv : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_pmbus_sda_drv : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_host_event_ack : std_logic_vector(96 downto 0);
	signal max4galavafabrictop_i_config_reconfig_trigger : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_flash_control_flash_rx_addr : std_logic_vector(0 downto 0);
	signal max4galavafabrictop_i_flash_control_flash_tx_d : std_logic_vector(63 downto 0);
	signal max4galavafabrictop_i_flash_control_flash_tx_we : std_logic_vector(0 downto 0);
	signal stream0_clock_gen_i_output_clk : std_logic_vector(0 downto 0);
	signal stream0_clock_gen_i_output_clk_inv : std_logic_vector(0 downto 0);
	signal stream0_clock_gen_i_pll_mgmt_readdata : std_logic_vector(31 downto 0);
	signal stream0_clock_gen_i_pll_mgmt_waitrequest : std_logic_vector(0 downto 0);
	signal stream0_clock_gen_i_locked : std_logic_vector(0 downto 0);
	signal pciebase_i_pushup_stratixvhardippcie_i_tx_out0 : std_logic_vector(0 downto 0);
	signal pciebase_i_pushup_stratixvhardippcie_i_tx_out1 : std_logic_vector(0 downto 0);
	signal pciebase_i_pushup_stratixvhardippcie_i_tx_out2 : std_logic_vector(0 downto 0);
	signal pciebase_i_pushup_stratixvhardippcie_i_tx_out3 : std_logic_vector(0 downto 0);
	signal pciebase_i_pushup_stratixvhardippcie_i_tx_out4 : std_logic_vector(0 downto 0);
	signal pciebase_i_pushup_stratixvhardippcie_i_tx_out5 : std_logic_vector(0 downto 0);
	signal pciebase_i_pushup_stratixvhardippcie_i_tx_out6 : std_logic_vector(0 downto 0);
	signal pciebase_i_pushup_stratixvhardippcie_i_tx_out7 : std_logic_vector(0 downto 0);
	signal pciebase_i_clk_pcie : std_logic_vector(0 downto 0);
	signal pciebase_i_rst_pcie_n : std_logic_vector(0 downto 0);
	signal pciebase_i_app_int_ack : std_logic_vector(0 downto 0);
	signal pciebase_i_app_msi_ack : std_logic_vector(0 downto 0);
	signal pciebase_i_tl_cfg_ctl : std_logic_vector(31 downto 0);
	signal pciebase_i_tl_cfg_add : std_logic_vector(3 downto 0);
	signal pciebase_i_ltssmstate : std_logic_vector(4 downto 0);
	signal pciebase_i_tx_st_ready : std_logic_vector(0 downto 0);
	signal pciebase_i_rx_st_valid : std_logic_vector(0 downto 0);
	signal pciebase_i_rx_st_sop : std_logic_vector(0 downto 0);
	signal pciebase_i_rx_st_eop : std_logic_vector(0 downto 0);
	signal pciebase_i_rx_st_empty : std_logic_vector(1 downto 0);
	signal pciebase_i_rx_st_err : std_logic_vector(0 downto 0);
	signal pciebase_i_rx_st_bar : std_logic_vector(7 downto 0);
	signal pciebase_i_rx_st_data : std_logic_vector(127 downto 0);
	signal pciebase_i_sim_pipe_rate : std_logic_vector(1 downto 0);
	signal pciebase_i_sim_ltssmstate : std_logic_vector(4 downto 0);
	signal pciebase_i_eidleinfersel0 : std_logic_vector(2 downto 0);
	signal pciebase_i_eidleinfersel1 : std_logic_vector(2 downto 0);
	signal pciebase_i_eidleinfersel2 : std_logic_vector(2 downto 0);
	signal pciebase_i_eidleinfersel3 : std_logic_vector(2 downto 0);
	signal pciebase_i_eidleinfersel4 : std_logic_vector(2 downto 0);
	signal pciebase_i_eidleinfersel5 : std_logic_vector(2 downto 0);
	signal pciebase_i_eidleinfersel6 : std_logic_vector(2 downto 0);
	signal pciebase_i_eidleinfersel7 : std_logic_vector(2 downto 0);
	signal pciebase_i_powerdown0 : std_logic_vector(1 downto 0);
	signal pciebase_i_powerdown1 : std_logic_vector(1 downto 0);
	signal pciebase_i_powerdown2 : std_logic_vector(1 downto 0);
	signal pciebase_i_powerdown3 : std_logic_vector(1 downto 0);
	signal pciebase_i_powerdown4 : std_logic_vector(1 downto 0);
	signal pciebase_i_powerdown5 : std_logic_vector(1 downto 0);
	signal pciebase_i_powerdown6 : std_logic_vector(1 downto 0);
	signal pciebase_i_powerdown7 : std_logic_vector(1 downto 0);
	signal pciebase_i_rxpolarity0 : std_logic_vector(0 downto 0);
	signal pciebase_i_rxpolarity1 : std_logic_vector(0 downto 0);
	signal pciebase_i_rxpolarity2 : std_logic_vector(0 downto 0);
	signal pciebase_i_rxpolarity3 : std_logic_vector(0 downto 0);
	signal pciebase_i_rxpolarity4 : std_logic_vector(0 downto 0);
	signal pciebase_i_rxpolarity5 : std_logic_vector(0 downto 0);
	signal pciebase_i_rxpolarity6 : std_logic_vector(0 downto 0);
	signal pciebase_i_rxpolarity7 : std_logic_vector(0 downto 0);
	signal pciebase_i_txcompl0 : std_logic_vector(0 downto 0);
	signal pciebase_i_txcompl1 : std_logic_vector(0 downto 0);
	signal pciebase_i_txcompl2 : std_logic_vector(0 downto 0);
	signal pciebase_i_txcompl3 : std_logic_vector(0 downto 0);
	signal pciebase_i_txcompl4 : std_logic_vector(0 downto 0);
	signal pciebase_i_txcompl5 : std_logic_vector(0 downto 0);
	signal pciebase_i_txcompl6 : std_logic_vector(0 downto 0);
	signal pciebase_i_txcompl7 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdata0 : std_logic_vector(7 downto 0);
	signal pciebase_i_txdata1 : std_logic_vector(7 downto 0);
	signal pciebase_i_txdata2 : std_logic_vector(7 downto 0);
	signal pciebase_i_txdata3 : std_logic_vector(7 downto 0);
	signal pciebase_i_txdata4 : std_logic_vector(7 downto 0);
	signal pciebase_i_txdata5 : std_logic_vector(7 downto 0);
	signal pciebase_i_txdata6 : std_logic_vector(7 downto 0);
	signal pciebase_i_txdata7 : std_logic_vector(7 downto 0);
	signal pciebase_i_txdatak0 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdatak1 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdatak2 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdatak3 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdatak4 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdatak5 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdatak6 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdatak7 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdetectrx0 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdetectrx1 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdetectrx2 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdetectrx3 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdetectrx4 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdetectrx5 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdetectrx6 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdetectrx7 : std_logic_vector(0 downto 0);
	signal pciebase_i_txelecidle0 : std_logic_vector(0 downto 0);
	signal pciebase_i_txelecidle1 : std_logic_vector(0 downto 0);
	signal pciebase_i_txelecidle2 : std_logic_vector(0 downto 0);
	signal pciebase_i_txelecidle3 : std_logic_vector(0 downto 0);
	signal pciebase_i_txelecidle4 : std_logic_vector(0 downto 0);
	signal pciebase_i_txelecidle5 : std_logic_vector(0 downto 0);
	signal pciebase_i_txelecidle6 : std_logic_vector(0 downto 0);
	signal pciebase_i_txelecidle7 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdeemph0 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdeemph1 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdeemph2 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdeemph3 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdeemph4 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdeemph5 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdeemph6 : std_logic_vector(0 downto 0);
	signal pciebase_i_txdeemph7 : std_logic_vector(0 downto 0);
	signal pciebase_i_txswing0 : std_logic_vector(0 downto 0);
	signal pciebase_i_txswing1 : std_logic_vector(0 downto 0);
	signal pciebase_i_txswing2 : std_logic_vector(0 downto 0);
	signal pciebase_i_txswing3 : std_logic_vector(0 downto 0);
	signal pciebase_i_txswing4 : std_logic_vector(0 downto 0);
	signal pciebase_i_txswing5 : std_logic_vector(0 downto 0);
	signal pciebase_i_txswing6 : std_logic_vector(0 downto 0);
	signal pciebase_i_txswing7 : std_logic_vector(0 downto 0);
	signal pciebase_i_txmargin0 : std_logic_vector(2 downto 0);
	signal pciebase_i_txmargin1 : std_logic_vector(2 downto 0);
	signal pciebase_i_txmargin2 : std_logic_vector(2 downto 0);
	signal pciebase_i_txmargin3 : std_logic_vector(2 downto 0);
	signal pciebase_i_txmargin4 : std_logic_vector(2 downto 0);
	signal pciebase_i_txmargin5 : std_logic_vector(2 downto 0);
	signal pciebase_i_txmargin6 : std_logic_vector(2 downto 0);
	signal pciebase_i_txmargin7 : std_logic_vector(2 downto 0);
	signal max4_cpld_top_level_to_flash_valid : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_pmbus_scl_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_pmbus_sda_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_pmbus_alert : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_dimm_left_scl_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_dimm_left_sda_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_dimm_right_scl_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_dimm_right_sda_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_dimm_alert : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_aux_scl_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_aux_sda_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_aux_alert : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp0_i2c_scl_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp0_i2c_sda_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp0_i2c_alert : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp0_i2c_modprsl : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp1_i2c_scl_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp1_i2c_sda_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp1_i2c_alert : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp1_i2c_modprsl : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp2_i2c_scl_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp2_i2c_sda_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp2_i2c_alert : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp2_i2c_modprsl : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp3_i2c_scl_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp3_i2c_sda_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp3_i2c_alert : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp3_i2c_modprsl : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp4_i2c_scl_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp4_i2c_sda_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp4_i2c_alert : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp4_i2c_modprsl : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp5_i2c_scl_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp5_i2c_sda_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp5_i2c_alert : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp5_i2c_modprsl : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp6_i2c_scl_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp6_i2c_sda_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp6_i2c_alert : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp6_i2c_modprsl : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp7_i2c_scl_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp7_i2c_sda_fb : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp7_i2c_alert : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_qsfp7_i2c_modprsl : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_host_event_status : std_logic_vector(96 downto 0);
	signal max4_cpld_top_level_config_fpga_init_done : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_config_fpga_crc_error : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_config_fpga_cvp_confdone : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_rev_dipsw : std_logic_vector(3 downto 0);
	signal max4_cpld_top_level_rev_assy_rev : std_logic_vector(1 downto 0);
	signal max4_cpld_top_level_rev_pcb_rev : std_logic_vector(1 downto 0);
	signal max4_cpld_top_level_rev_cpld_version : std_logic_vector(7 downto 0);
	signal max4_cpld_top_level_rev_build_rev : std_logic_vector(1 downto 0);
	signal max4_cpld_top_level_flash_control_flash_rx_d : std_logic_vector(63 downto 0);
	signal max4_cpld_top_level_sda_out : std_logic_vector(0 downto 0);
	signal max4_cpld_top_level_led_maxring1 : std_logic_vector(1 downto 0);
	signal cat_ln536_max4galavaperipherytop : std_logic_vector(1 downto 0);
	signal max4_cpld_top_level_led_pan_maxring1 : std_logic_vector(1 downto 0);
	signal cat_ln537_max4galavaperipherytop : std_logic_vector(1 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	cat_ln536_max4galavaperipherytop<=("0" & "0");
	max4_cpld_top_level_led_maxring1 <= cat_ln536_max4galavaperipherytop;
	cat_ln537_max4galavaperipherytop<=("0" & "0");
	max4_cpld_top_level_led_pan_maxring1 <= cat_ln537_max4galavaperipherytop;
	tx_out0 <= vec_to_bit(pciebase_i_pushup_stratixvhardippcie_i_tx_out0);
	tx_out1 <= vec_to_bit(pciebase_i_pushup_stratixvhardippcie_i_tx_out1);
	tx_out2 <= vec_to_bit(pciebase_i_pushup_stratixvhardippcie_i_tx_out2);
	tx_out3 <= vec_to_bit(pciebase_i_pushup_stratixvhardippcie_i_tx_out3);
	tx_out4 <= vec_to_bit(pciebase_i_pushup_stratixvhardippcie_i_tx_out4);
	tx_out5 <= vec_to_bit(pciebase_i_pushup_stratixvhardippcie_i_tx_out5);
	tx_out6 <= vec_to_bit(pciebase_i_pushup_stratixvhardippcie_i_tx_out6);
	tx_out7 <= vec_to_bit(pciebase_i_pushup_stratixvhardippcie_i_tx_out7);
	to_flash_valid <= vec_to_bit(max4_cpld_top_level_to_flash_valid);
	sda_out <= vec_to_bit(max4_cpld_top_level_sda_out);
	
	-- Register processes
	
	
	-- Entity instances
	
	MAX4GalavaFabricTop_i : MAX4FPGATop
		port map (
			pll_mgmt_clk0 => max4galavafabrictop_i_pll_mgmt_clk0(0), -- 1 bits (out)
			pll_mgmt_rst0 => max4galavafabrictop_i_pll_mgmt_rst0(0), -- 1 bits (out)
			pll_mgmt_address0 => max4galavafabrictop_i_pll_mgmt_address0, -- 6 bits (out)
			pll_mgmt_read0 => max4galavafabrictop_i_pll_mgmt_read0(0), -- 1 bits (out)
			pll_mgmt_write0 => max4galavafabrictop_i_pll_mgmt_write0(0), -- 1 bits (out)
			pll_mgmt_writedata0 => max4galavafabrictop_i_pll_mgmt_writedata0, -- 32 bits (out)
			pll_rst0 => max4galavafabrictop_i_pll_rst0(0), -- 1 bits (out)
			clkbuf_clken0 => max4galavafabrictop_i_clkbuf_clken0(0), -- 1 bits (out)
			app_int_sts => max4galavafabrictop_i_app_int_sts(0), -- 1 bits (out)
			app_msi_req => max4galavafabrictop_i_app_msi_req(0), -- 1 bits (out)
			app_msi_num => max4galavafabrictop_i_app_msi_num, -- 5 bits (out)
			app_msi_tc => max4galavafabrictop_i_app_msi_tc, -- 3 bits (out)
			tx_st_valid => max4galavafabrictop_i_tx_st_valid(0), -- 1 bits (out)
			tx_st_sop => max4galavafabrictop_i_tx_st_sop(0), -- 1 bits (out)
			tx_st_eop => max4galavafabrictop_i_tx_st_eop(0), -- 1 bits (out)
			tx_st_empty => max4galavafabrictop_i_tx_st_empty, -- 2 bits (out)
			tx_st_err => max4galavafabrictop_i_tx_st_err(0), -- 1 bits (out)
			tx_st_data => max4galavafabrictop_i_tx_st_data, -- 128 bits (out)
			rx_st_ready => max4galavafabrictop_i_rx_st_ready(0), -- 1 bits (out)
			rx_st_mask => max4galavafabrictop_i_rx_st_mask(0), -- 1 bits (out)
			cpl_err => max4galavafabrictop_i_cpl_err, -- 7 bits (out)
			cpl_pending => max4galavafabrictop_i_cpl_pending(0), -- 1 bits (out)
			slave_leds => max4galavafabrictop_i_slave_leds, -- 2 bits (out)
			i2c_left_dimm_SCL_drv => max4galavafabrictop_i_i2c_left_dimm_scl_drv(0), -- 1 bits (out)
			i2c_left_dimm_SDA_drv => max4galavafabrictop_i_i2c_left_dimm_sda_drv(0), -- 1 bits (out)
			i2c_right_dimm_SCL_drv => max4galavafabrictop_i_i2c_right_dimm_scl_drv(0), -- 1 bits (out)
			i2c_right_dimm_SDA_drv => max4galavafabrictop_i_i2c_right_dimm_sda_drv(0), -- 1 bits (out)
			i2c_aux_SCL_drv => max4galavafabrictop_i_i2c_aux_scl_drv(0), -- 1 bits (out)
			i2c_aux_SDA_drv => max4galavafabrictop_i_i2c_aux_sda_drv(0), -- 1 bits (out)
			pmbus_SCL_drv => max4galavafabrictop_i_pmbus_scl_drv(0), -- 1 bits (out)
			pmbus_SDA_drv => max4galavafabrictop_i_pmbus_sda_drv(0), -- 1 bits (out)
			host_event_ack => max4galavafabrictop_i_host_event_ack, -- 97 bits (out)
			config_Reconfig_Trigger => max4galavafabrictop_i_config_reconfig_trigger(0), -- 1 bits (out)
			flash_control_flash_rx_addr => max4galavafabrictop_i_flash_control_flash_rx_addr(0), -- 1 bits (out)
			flash_control_flash_tx_d => max4galavafabrictop_i_flash_control_flash_tx_d, -- 64 bits (out)
			flash_control_flash_tx_we => max4galavafabrictop_i_flash_control_flash_tx_we(0), -- 1 bits (out)
			sys_clk => vec_to_bit("0"), -- 1 bits (in)
			cclk => cclk, -- 1 bits (in)
			pll_mgmt_readdata0 => stream0_clock_gen_i_pll_mgmt_readdata, -- 32 bits (in)
			pll_mgmt_waitrequest0 => vec_to_bit(stream0_clock_gen_i_pll_mgmt_waitrequest), -- 1 bits (in)
			pll_inst_locked0 => vec_to_bit(stream0_clock_gen_i_locked), -- 1 bits (in)
			stream_clocks_gen_output_clk0 => vec_to_bit(stream0_clock_gen_i_output_clk), -- 1 bits (in)
			stream_clocks_gen_output_clk_inv0 => vec_to_bit(stream0_clock_gen_i_output_clk_inv), -- 1 bits (in)
			clk_pcie => vec_to_bit(pciebase_i_clk_pcie), -- 1 bits (in)
			rst_pcie_n => vec_to_bit(pciebase_i_rst_pcie_n), -- 1 bits (in)
			app_int_ack => vec_to_bit(pciebase_i_app_int_ack), -- 1 bits (in)
			app_msi_ack => vec_to_bit(pciebase_i_app_msi_ack), -- 1 bits (in)
			tl_cfg_ctl => pciebase_i_tl_cfg_ctl, -- 32 bits (in)
			tl_cfg_add => pciebase_i_tl_cfg_add, -- 4 bits (in)
			ltssmstate => pciebase_i_ltssmstate, -- 5 bits (in)
			tx_st_ready => vec_to_bit(pciebase_i_tx_st_ready), -- 1 bits (in)
			rx_st_valid => vec_to_bit(pciebase_i_rx_st_valid), -- 1 bits (in)
			rx_st_sop => vec_to_bit(pciebase_i_rx_st_sop), -- 1 bits (in)
			rx_st_eop => vec_to_bit(pciebase_i_rx_st_eop), -- 1 bits (in)
			rx_st_empty => pciebase_i_rx_st_empty, -- 2 bits (in)
			rx_st_err => vec_to_bit(pciebase_i_rx_st_err), -- 1 bits (in)
			rx_st_bar => pciebase_i_rx_st_bar, -- 8 bits (in)
			rx_st_data => pciebase_i_rx_st_data, -- 128 bits (in)
			i2c_left_dimm_SCL_fb => vec_to_bit(max4_cpld_top_level_dimm_left_scl_fb), -- 1 bits (in)
			i2c_left_dimm_SDA_fb => vec_to_bit(max4_cpld_top_level_dimm_left_sda_fb), -- 1 bits (in)
			i2c_right_dimm_SCL_fb => vec_to_bit(max4_cpld_top_level_dimm_right_scl_fb), -- 1 bits (in)
			i2c_right_dimm_SDA_fb => vec_to_bit(max4_cpld_top_level_dimm_right_sda_fb), -- 1 bits (in)
			i2c_dimm_alert => vec_to_bit(max4_cpld_top_level_dimm_alert), -- 1 bits (in)
			i2c_aux_SCL_fb => vec_to_bit(max4_cpld_top_level_aux_scl_fb), -- 1 bits (in)
			i2c_aux_SDA_fb => vec_to_bit(max4_cpld_top_level_aux_sda_fb), -- 1 bits (in)
			i2c_aux_ALERT => vec_to_bit(max4_cpld_top_level_aux_alert), -- 1 bits (in)
			pmbus_SCL_fb => vec_to_bit(max4_cpld_top_level_pmbus_scl_fb), -- 1 bits (in)
			pmbus_SDA_fb => vec_to_bit(max4_cpld_top_level_pmbus_sda_fb), -- 1 bits (in)
			pmbus_ALERT => vec_to_bit(max4_cpld_top_level_pmbus_alert), -- 1 bits (in)
			host_event_status => max4_cpld_top_level_host_event_status, -- 97 bits (in)
			config_FPGA_INIT_DONE => vec_to_bit(max4_cpld_top_level_config_fpga_init_done), -- 1 bits (in)
			config_FPGA_CRC_ERROR => vec_to_bit(max4_cpld_top_level_config_fpga_crc_error), -- 1 bits (in)
			config_FPGA_CvP_CONFDONE => vec_to_bit(max4_cpld_top_level_config_fpga_cvp_confdone), -- 1 bits (in)
			rev_DIPSW => max4_cpld_top_level_rev_dipsw, -- 4 bits (in)
			rev_ASSY_REV => max4_cpld_top_level_rev_assy_rev, -- 2 bits (in)
			rev_PCB_REV => max4_cpld_top_level_rev_pcb_rev, -- 2 bits (in)
			rev_CPLD_Version => max4_cpld_top_level_rev_cpld_version, -- 8 bits (in)
			rev_BUILD_REV => max4_cpld_top_level_rev_build_rev, -- 2 bits (in)
			flash_control_flash_rx_d => max4_cpld_top_level_flash_control_flash_rx_d -- 64 bits (in)
		);
	STREAM0_clock_gen_i : AlteraClockGenerator_250_100_STREAM
		port map (
			output_clk => stream0_clock_gen_i_output_clk(0), -- 1 bits (out)
			output_clk_inv => stream0_clock_gen_i_output_clk_inv(0), -- 1 bits (out)
			pll_mgmt_readdata => stream0_clock_gen_i_pll_mgmt_readdata, -- 32 bits (out)
			pll_mgmt_waitrequest => stream0_clock_gen_i_pll_mgmt_waitrequest(0), -- 1 bits (out)
			locked => stream0_clock_gen_i_locked(0), -- 1 bits (out)
			input_clk => maxring_refclk, -- 1 bits (in)
			pll_rst => vec_to_bit(max4galavafabrictop_i_pll_rst0), -- 1 bits (in)
			clkbuf_clken => vec_to_bit(max4galavafabrictop_i_clkbuf_clken0), -- 1 bits (in)
			clkbuf_clksel => "00", -- 2 bits (in)
			pll_mgmt_clk => vec_to_bit(max4galavafabrictop_i_pll_mgmt_clk0), -- 1 bits (in)
			pll_mgmt_rst => vec_to_bit(max4galavafabrictop_i_pll_mgmt_rst0), -- 1 bits (in)
			pll_mgmt_address => max4galavafabrictop_i_pll_mgmt_address0, -- 6 bits (in)
			pll_mgmt_read => vec_to_bit(max4galavafabrictop_i_pll_mgmt_read0), -- 1 bits (in)
			pll_mgmt_write => vec_to_bit(max4galavafabrictop_i_pll_mgmt_write0), -- 1 bits (in)
			pll_mgmt_writedata => max4galavafabrictop_i_pll_mgmt_writedata0 -- 32 bits (in)
		);
	PCIeBase_i : StratixPCIeBase
		port map (
			pushup_stratixvhardippcie_i_tx_out0 => pciebase_i_pushup_stratixvhardippcie_i_tx_out0(0), -- 1 bits (out)
			pushup_stratixvhardippcie_i_tx_out1 => pciebase_i_pushup_stratixvhardippcie_i_tx_out1(0), -- 1 bits (out)
			pushup_stratixvhardippcie_i_tx_out2 => pciebase_i_pushup_stratixvhardippcie_i_tx_out2(0), -- 1 bits (out)
			pushup_stratixvhardippcie_i_tx_out3 => pciebase_i_pushup_stratixvhardippcie_i_tx_out3(0), -- 1 bits (out)
			pushup_stratixvhardippcie_i_tx_out4 => pciebase_i_pushup_stratixvhardippcie_i_tx_out4(0), -- 1 bits (out)
			pushup_stratixvhardippcie_i_tx_out5 => pciebase_i_pushup_stratixvhardippcie_i_tx_out5(0), -- 1 bits (out)
			pushup_stratixvhardippcie_i_tx_out6 => pciebase_i_pushup_stratixvhardippcie_i_tx_out6(0), -- 1 bits (out)
			pushup_stratixvhardippcie_i_tx_out7 => pciebase_i_pushup_stratixvhardippcie_i_tx_out7(0), -- 1 bits (out)
			clk_pcie => pciebase_i_clk_pcie(0), -- 1 bits (out)
			rst_pcie_n => pciebase_i_rst_pcie_n(0), -- 1 bits (out)
			app_int_ack => pciebase_i_app_int_ack(0), -- 1 bits (out)
			app_msi_ack => pciebase_i_app_msi_ack(0), -- 1 bits (out)
			tl_cfg_ctl => pciebase_i_tl_cfg_ctl, -- 32 bits (out)
			tl_cfg_add => pciebase_i_tl_cfg_add, -- 4 bits (out)
			ltssmstate => pciebase_i_ltssmstate, -- 5 bits (out)
			tx_st_ready => pciebase_i_tx_st_ready(0), -- 1 bits (out)
			rx_st_valid => pciebase_i_rx_st_valid(0), -- 1 bits (out)
			rx_st_sop => pciebase_i_rx_st_sop(0), -- 1 bits (out)
			rx_st_eop => pciebase_i_rx_st_eop(0), -- 1 bits (out)
			rx_st_empty => pciebase_i_rx_st_empty, -- 2 bits (out)
			rx_st_err => pciebase_i_rx_st_err(0), -- 1 bits (out)
			rx_st_bar => pciebase_i_rx_st_bar, -- 8 bits (out)
			rx_st_data => pciebase_i_rx_st_data, -- 128 bits (out)
			sim_pipe_rate => pciebase_i_sim_pipe_rate, -- 2 bits (out)
			sim_ltssmstate => pciebase_i_sim_ltssmstate, -- 5 bits (out)
			eidleinfersel0 => pciebase_i_eidleinfersel0, -- 3 bits (out)
			eidleinfersel1 => pciebase_i_eidleinfersel1, -- 3 bits (out)
			eidleinfersel2 => pciebase_i_eidleinfersel2, -- 3 bits (out)
			eidleinfersel3 => pciebase_i_eidleinfersel3, -- 3 bits (out)
			eidleinfersel4 => pciebase_i_eidleinfersel4, -- 3 bits (out)
			eidleinfersel5 => pciebase_i_eidleinfersel5, -- 3 bits (out)
			eidleinfersel6 => pciebase_i_eidleinfersel6, -- 3 bits (out)
			eidleinfersel7 => pciebase_i_eidleinfersel7, -- 3 bits (out)
			powerdown0 => pciebase_i_powerdown0, -- 2 bits (out)
			powerdown1 => pciebase_i_powerdown1, -- 2 bits (out)
			powerdown2 => pciebase_i_powerdown2, -- 2 bits (out)
			powerdown3 => pciebase_i_powerdown3, -- 2 bits (out)
			powerdown4 => pciebase_i_powerdown4, -- 2 bits (out)
			powerdown5 => pciebase_i_powerdown5, -- 2 bits (out)
			powerdown6 => pciebase_i_powerdown6, -- 2 bits (out)
			powerdown7 => pciebase_i_powerdown7, -- 2 bits (out)
			rxpolarity0 => pciebase_i_rxpolarity0(0), -- 1 bits (out)
			rxpolarity1 => pciebase_i_rxpolarity1(0), -- 1 bits (out)
			rxpolarity2 => pciebase_i_rxpolarity2(0), -- 1 bits (out)
			rxpolarity3 => pciebase_i_rxpolarity3(0), -- 1 bits (out)
			rxpolarity4 => pciebase_i_rxpolarity4(0), -- 1 bits (out)
			rxpolarity5 => pciebase_i_rxpolarity5(0), -- 1 bits (out)
			rxpolarity6 => pciebase_i_rxpolarity6(0), -- 1 bits (out)
			rxpolarity7 => pciebase_i_rxpolarity7(0), -- 1 bits (out)
			txcompl0 => pciebase_i_txcompl0(0), -- 1 bits (out)
			txcompl1 => pciebase_i_txcompl1(0), -- 1 bits (out)
			txcompl2 => pciebase_i_txcompl2(0), -- 1 bits (out)
			txcompl3 => pciebase_i_txcompl3(0), -- 1 bits (out)
			txcompl4 => pciebase_i_txcompl4(0), -- 1 bits (out)
			txcompl5 => pciebase_i_txcompl5(0), -- 1 bits (out)
			txcompl6 => pciebase_i_txcompl6(0), -- 1 bits (out)
			txcompl7 => pciebase_i_txcompl7(0), -- 1 bits (out)
			txdata0 => pciebase_i_txdata0, -- 8 bits (out)
			txdata1 => pciebase_i_txdata1, -- 8 bits (out)
			txdata2 => pciebase_i_txdata2, -- 8 bits (out)
			txdata3 => pciebase_i_txdata3, -- 8 bits (out)
			txdata4 => pciebase_i_txdata4, -- 8 bits (out)
			txdata5 => pciebase_i_txdata5, -- 8 bits (out)
			txdata6 => pciebase_i_txdata6, -- 8 bits (out)
			txdata7 => pciebase_i_txdata7, -- 8 bits (out)
			txdatak0 => pciebase_i_txdatak0(0), -- 1 bits (out)
			txdatak1 => pciebase_i_txdatak1(0), -- 1 bits (out)
			txdatak2 => pciebase_i_txdatak2(0), -- 1 bits (out)
			txdatak3 => pciebase_i_txdatak3(0), -- 1 bits (out)
			txdatak4 => pciebase_i_txdatak4(0), -- 1 bits (out)
			txdatak5 => pciebase_i_txdatak5(0), -- 1 bits (out)
			txdatak6 => pciebase_i_txdatak6(0), -- 1 bits (out)
			txdatak7 => pciebase_i_txdatak7(0), -- 1 bits (out)
			txdetectrx0 => pciebase_i_txdetectrx0(0), -- 1 bits (out)
			txdetectrx1 => pciebase_i_txdetectrx1(0), -- 1 bits (out)
			txdetectrx2 => pciebase_i_txdetectrx2(0), -- 1 bits (out)
			txdetectrx3 => pciebase_i_txdetectrx3(0), -- 1 bits (out)
			txdetectrx4 => pciebase_i_txdetectrx4(0), -- 1 bits (out)
			txdetectrx5 => pciebase_i_txdetectrx5(0), -- 1 bits (out)
			txdetectrx6 => pciebase_i_txdetectrx6(0), -- 1 bits (out)
			txdetectrx7 => pciebase_i_txdetectrx7(0), -- 1 bits (out)
			txelecidle0 => pciebase_i_txelecidle0(0), -- 1 bits (out)
			txelecidle1 => pciebase_i_txelecidle1(0), -- 1 bits (out)
			txelecidle2 => pciebase_i_txelecidle2(0), -- 1 bits (out)
			txelecidle3 => pciebase_i_txelecidle3(0), -- 1 bits (out)
			txelecidle4 => pciebase_i_txelecidle4(0), -- 1 bits (out)
			txelecidle5 => pciebase_i_txelecidle5(0), -- 1 bits (out)
			txelecidle6 => pciebase_i_txelecidle6(0), -- 1 bits (out)
			txelecidle7 => pciebase_i_txelecidle7(0), -- 1 bits (out)
			txdeemph0 => pciebase_i_txdeemph0(0), -- 1 bits (out)
			txdeemph1 => pciebase_i_txdeemph1(0), -- 1 bits (out)
			txdeemph2 => pciebase_i_txdeemph2(0), -- 1 bits (out)
			txdeemph3 => pciebase_i_txdeemph3(0), -- 1 bits (out)
			txdeemph4 => pciebase_i_txdeemph4(0), -- 1 bits (out)
			txdeemph5 => pciebase_i_txdeemph5(0), -- 1 bits (out)
			txdeemph6 => pciebase_i_txdeemph6(0), -- 1 bits (out)
			txdeemph7 => pciebase_i_txdeemph7(0), -- 1 bits (out)
			txswing0 => pciebase_i_txswing0(0), -- 1 bits (out)
			txswing1 => pciebase_i_txswing1(0), -- 1 bits (out)
			txswing2 => pciebase_i_txswing2(0), -- 1 bits (out)
			txswing3 => pciebase_i_txswing3(0), -- 1 bits (out)
			txswing4 => pciebase_i_txswing4(0), -- 1 bits (out)
			txswing5 => pciebase_i_txswing5(0), -- 1 bits (out)
			txswing6 => pciebase_i_txswing6(0), -- 1 bits (out)
			txswing7 => pciebase_i_txswing7(0), -- 1 bits (out)
			txmargin0 => pciebase_i_txmargin0, -- 3 bits (out)
			txmargin1 => pciebase_i_txmargin1, -- 3 bits (out)
			txmargin2 => pciebase_i_txmargin2, -- 3 bits (out)
			txmargin3 => pciebase_i_txmargin3, -- 3 bits (out)
			txmargin4 => pciebase_i_txmargin4, -- 3 bits (out)
			txmargin5 => pciebase_i_txmargin5, -- 3 bits (out)
			txmargin6 => pciebase_i_txmargin6, -- 3 bits (out)
			txmargin7 => pciebase_i_txmargin7, -- 3 bits (out)
			pushup_stratixvhardippcie_i_rx_in0 => rx_in0, -- 1 bits (in)
			pushup_stratixvhardippcie_i_rx_in1 => rx_in1, -- 1 bits (in)
			pushup_stratixvhardippcie_i_rx_in2 => rx_in2, -- 1 bits (in)
			pushup_stratixvhardippcie_i_rx_in3 => rx_in3, -- 1 bits (in)
			pushup_stratixvhardippcie_i_rx_in4 => rx_in4, -- 1 bits (in)
			pushup_stratixvhardippcie_i_rx_in5 => rx_in5, -- 1 bits (in)
			pushup_stratixvhardippcie_i_rx_in6 => rx_in6, -- 1 bits (in)
			pushup_stratixvhardippcie_i_rx_in7 => rx_in7, -- 1 bits (in)
			pcie_npor => sys_rst_n, -- 1 bits (in)
			pcie_pin_perst => pcie_pin_perst, -- 1 bits (in)
			pcie_ref_clk => pcie_ref_clk, -- 1 bits (in)
			reconfig_xcvr_clk => pcie_ref_clk, -- 1 bits (in)
			app_int_sts => vec_to_bit(max4galavafabrictop_i_app_int_sts), -- 1 bits (in)
			app_msi_req => vec_to_bit(max4galavafabrictop_i_app_msi_req), -- 1 bits (in)
			app_msi_num => max4galavafabrictop_i_app_msi_num, -- 5 bits (in)
			app_msi_tc => max4galavafabrictop_i_app_msi_tc, -- 3 bits (in)
			tx_st_valid => vec_to_bit(max4galavafabrictop_i_tx_st_valid), -- 1 bits (in)
			tx_st_sop => vec_to_bit(max4galavafabrictop_i_tx_st_sop), -- 1 bits (in)
			tx_st_eop => vec_to_bit(max4galavafabrictop_i_tx_st_eop), -- 1 bits (in)
			tx_st_empty => max4galavafabrictop_i_tx_st_empty, -- 2 bits (in)
			tx_st_err => vec_to_bit(max4galavafabrictop_i_tx_st_err), -- 1 bits (in)
			tx_st_data => max4galavafabrictop_i_tx_st_data, -- 128 bits (in)
			rx_st_ready => vec_to_bit(max4galavafabrictop_i_rx_st_ready), -- 1 bits (in)
			rx_st_mask => vec_to_bit(max4galavafabrictop_i_rx_st_mask), -- 1 bits (in)
			cpl_err => max4galavafabrictop_i_cpl_err, -- 7 bits (in)
			cpl_pending => vec_to_bit(max4galavafabrictop_i_cpl_pending), -- 1 bits (in)
			test_in => "00000000000000000000000010110000", -- 32 bits (in)
			simu_mode_pipe => vec_to_bit("0"), -- 1 bits (in)
			sim_pipe_pclk_in => vec_to_bit("0"), -- 1 bits (in)
			phystatus0 => vec_to_bit("0"), -- 1 bits (in)
			phystatus1 => vec_to_bit("0"), -- 1 bits (in)
			phystatus2 => vec_to_bit("0"), -- 1 bits (in)
			phystatus3 => vec_to_bit("0"), -- 1 bits (in)
			phystatus4 => vec_to_bit("0"), -- 1 bits (in)
			phystatus5 => vec_to_bit("0"), -- 1 bits (in)
			phystatus6 => vec_to_bit("0"), -- 1 bits (in)
			phystatus7 => vec_to_bit("0"), -- 1 bits (in)
			rxdata0 => "00000000", -- 8 bits (in)
			rxdata1 => "00000000", -- 8 bits (in)
			rxdata2 => "00000000", -- 8 bits (in)
			rxdata3 => "00000000", -- 8 bits (in)
			rxdata4 => "00000000", -- 8 bits (in)
			rxdata5 => "00000000", -- 8 bits (in)
			rxdata6 => "00000000", -- 8 bits (in)
			rxdata7 => "00000000", -- 8 bits (in)
			rxdatak0 => vec_to_bit("0"), -- 1 bits (in)
			rxdatak1 => vec_to_bit("0"), -- 1 bits (in)
			rxdatak2 => vec_to_bit("0"), -- 1 bits (in)
			rxdatak3 => vec_to_bit("0"), -- 1 bits (in)
			rxdatak4 => vec_to_bit("0"), -- 1 bits (in)
			rxdatak5 => vec_to_bit("0"), -- 1 bits (in)
			rxdatak6 => vec_to_bit("0"), -- 1 bits (in)
			rxdatak7 => vec_to_bit("0"), -- 1 bits (in)
			rxelecidle0 => vec_to_bit("0"), -- 1 bits (in)
			rxelecidle1 => vec_to_bit("0"), -- 1 bits (in)
			rxelecidle2 => vec_to_bit("0"), -- 1 bits (in)
			rxelecidle3 => vec_to_bit("0"), -- 1 bits (in)
			rxelecidle4 => vec_to_bit("0"), -- 1 bits (in)
			rxelecidle5 => vec_to_bit("0"), -- 1 bits (in)
			rxelecidle6 => vec_to_bit("0"), -- 1 bits (in)
			rxelecidle7 => vec_to_bit("0"), -- 1 bits (in)
			rxstatus0 => "000", -- 3 bits (in)
			rxstatus1 => "000", -- 3 bits (in)
			rxstatus2 => "000", -- 3 bits (in)
			rxstatus3 => "000", -- 3 bits (in)
			rxstatus4 => "000", -- 3 bits (in)
			rxstatus5 => "000", -- 3 bits (in)
			rxstatus6 => "000", -- 3 bits (in)
			rxstatus7 => "000", -- 3 bits (in)
			rxvalid0 => vec_to_bit("0"), -- 1 bits (in)
			rxvalid1 => vec_to_bit("0"), -- 1 bits (in)
			rxvalid2 => vec_to_bit("0"), -- 1 bits (in)
			rxvalid3 => vec_to_bit("0"), -- 1 bits (in)
			rxvalid4 => vec_to_bit("0"), -- 1 bits (in)
			rxvalid5 => vec_to_bit("0"), -- 1 bits (in)
			rxvalid6 => vec_to_bit("0"), -- 1 bits (in)
			rxvalid7 => vec_to_bit("0") -- 1 bits (in)
		);
	max4_cpld_top_level : MAX4CPLDInterface
		port map (
			to_flash_valid => max4_cpld_top_level_to_flash_valid(0), -- 1 bits (out)
			PMBUS_SCL_fb => max4_cpld_top_level_pmbus_scl_fb(0), -- 1 bits (out)
			PMBUS_SDA_fb => max4_cpld_top_level_pmbus_sda_fb(0), -- 1 bits (out)
			PMBUS_ALERT => max4_cpld_top_level_pmbus_alert(0), -- 1 bits (out)
			DIMM_LEFT_SCL_fb => max4_cpld_top_level_dimm_left_scl_fb(0), -- 1 bits (out)
			DIMM_LEFT_SDA_fb => max4_cpld_top_level_dimm_left_sda_fb(0), -- 1 bits (out)
			DIMM_RIGHT_SCL_fb => max4_cpld_top_level_dimm_right_scl_fb(0), -- 1 bits (out)
			DIMM_RIGHT_SDA_fb => max4_cpld_top_level_dimm_right_sda_fb(0), -- 1 bits (out)
			DIMM_ALERT => max4_cpld_top_level_dimm_alert(0), -- 1 bits (out)
			AUX_SCL_fb => max4_cpld_top_level_aux_scl_fb(0), -- 1 bits (out)
			AUX_SDA_fb => max4_cpld_top_level_aux_sda_fb(0), -- 1 bits (out)
			AUX_ALERT => max4_cpld_top_level_aux_alert(0), -- 1 bits (out)
			qsfp0_i2c_SCL_fb => max4_cpld_top_level_qsfp0_i2c_scl_fb(0), -- 1 bits (out)
			qsfp0_i2c_SDA_fb => max4_cpld_top_level_qsfp0_i2c_sda_fb(0), -- 1 bits (out)
			qsfp0_i2c_ALERT => max4_cpld_top_level_qsfp0_i2c_alert(0), -- 1 bits (out)
			qsfp0_i2c_modprsl => max4_cpld_top_level_qsfp0_i2c_modprsl(0), -- 1 bits (out)
			qsfp1_i2c_SCL_fb => max4_cpld_top_level_qsfp1_i2c_scl_fb(0), -- 1 bits (out)
			qsfp1_i2c_SDA_fb => max4_cpld_top_level_qsfp1_i2c_sda_fb(0), -- 1 bits (out)
			qsfp1_i2c_ALERT => max4_cpld_top_level_qsfp1_i2c_alert(0), -- 1 bits (out)
			qsfp1_i2c_modprsl => max4_cpld_top_level_qsfp1_i2c_modprsl(0), -- 1 bits (out)
			qsfp2_i2c_SCL_fb => max4_cpld_top_level_qsfp2_i2c_scl_fb(0), -- 1 bits (out)
			qsfp2_i2c_SDA_fb => max4_cpld_top_level_qsfp2_i2c_sda_fb(0), -- 1 bits (out)
			qsfp2_i2c_ALERT => max4_cpld_top_level_qsfp2_i2c_alert(0), -- 1 bits (out)
			qsfp2_i2c_modprsl => max4_cpld_top_level_qsfp2_i2c_modprsl(0), -- 1 bits (out)
			qsfp3_i2c_SCL_fb => max4_cpld_top_level_qsfp3_i2c_scl_fb(0), -- 1 bits (out)
			qsfp3_i2c_SDA_fb => max4_cpld_top_level_qsfp3_i2c_sda_fb(0), -- 1 bits (out)
			qsfp3_i2c_ALERT => max4_cpld_top_level_qsfp3_i2c_alert(0), -- 1 bits (out)
			qsfp3_i2c_modprsl => max4_cpld_top_level_qsfp3_i2c_modprsl(0), -- 1 bits (out)
			qsfp4_i2c_SCL_fb => max4_cpld_top_level_qsfp4_i2c_scl_fb(0), -- 1 bits (out)
			qsfp4_i2c_SDA_fb => max4_cpld_top_level_qsfp4_i2c_sda_fb(0), -- 1 bits (out)
			qsfp4_i2c_ALERT => max4_cpld_top_level_qsfp4_i2c_alert(0), -- 1 bits (out)
			qsfp4_i2c_modprsl => max4_cpld_top_level_qsfp4_i2c_modprsl(0), -- 1 bits (out)
			qsfp5_i2c_SCL_fb => max4_cpld_top_level_qsfp5_i2c_scl_fb(0), -- 1 bits (out)
			qsfp5_i2c_SDA_fb => max4_cpld_top_level_qsfp5_i2c_sda_fb(0), -- 1 bits (out)
			qsfp5_i2c_ALERT => max4_cpld_top_level_qsfp5_i2c_alert(0), -- 1 bits (out)
			qsfp5_i2c_modprsl => max4_cpld_top_level_qsfp5_i2c_modprsl(0), -- 1 bits (out)
			qsfp6_i2c_SCL_fb => max4_cpld_top_level_qsfp6_i2c_scl_fb(0), -- 1 bits (out)
			qsfp6_i2c_SDA_fb => max4_cpld_top_level_qsfp6_i2c_sda_fb(0), -- 1 bits (out)
			qsfp6_i2c_ALERT => max4_cpld_top_level_qsfp6_i2c_alert(0), -- 1 bits (out)
			qsfp6_i2c_modprsl => max4_cpld_top_level_qsfp6_i2c_modprsl(0), -- 1 bits (out)
			qsfp7_i2c_SCL_fb => max4_cpld_top_level_qsfp7_i2c_scl_fb(0), -- 1 bits (out)
			qsfp7_i2c_SDA_fb => max4_cpld_top_level_qsfp7_i2c_sda_fb(0), -- 1 bits (out)
			qsfp7_i2c_ALERT => max4_cpld_top_level_qsfp7_i2c_alert(0), -- 1 bits (out)
			qsfp7_i2c_modprsl => max4_cpld_top_level_qsfp7_i2c_modprsl(0), -- 1 bits (out)
			host_event_status => max4_cpld_top_level_host_event_status, -- 97 bits (out)
			config_FPGA_INIT_DONE => max4_cpld_top_level_config_fpga_init_done(0), -- 1 bits (out)
			config_FPGA_CRC_ERROR => max4_cpld_top_level_config_fpga_crc_error(0), -- 1 bits (out)
			config_FPGA_CvP_CONFDONE => max4_cpld_top_level_config_fpga_cvp_confdone(0), -- 1 bits (out)
			rev_DIPSW => max4_cpld_top_level_rev_dipsw, -- 4 bits (out)
			rev_ASSY_REV => max4_cpld_top_level_rev_assy_rev, -- 2 bits (out)
			rev_PCB_REV => max4_cpld_top_level_rev_pcb_rev, -- 2 bits (out)
			rev_CPLD_Version => max4_cpld_top_level_rev_cpld_version, -- 8 bits (out)
			rev_BUILD_REV => max4_cpld_top_level_rev_build_rev, -- 2 bits (out)
			flash_control_flash_rx_d => max4_cpld_top_level_flash_control_flash_rx_d, -- 64 bits (out)
			sda_out => max4_cpld_top_level_sda_out(0), -- 1 bits (out)
			flash_data(9 downto 0) => flash_data(9 downto 0), -- 10 bits (inout)
			fpga_config_fpp_data(15 downto 0) => fpga_config_fpp_data(15 downto 0), -- 16 bits (inout)
			sys_rst_n => sys_rst_n, -- 1 bits (in)
			cclk => cclk, -- 1 bits (in)
			pcie_clk => vec_to_bit(pciebase_i_clk_pcie), -- 1 bits (in)
			led_phy_up => "000000", -- 6 bits (in)
			led_maxring => max4_cpld_top_level_led_maxring1, -- 2 bits (in)
			led_pan_maxring => max4_cpld_top_level_led_pan_maxring1, -- 2 bits (in)
			led_pcie => max4galavafabrictop_i_slave_leds, -- 2 bits (in)
			from_flash_valid => from_flash_valid, -- 1 bits (in)
			PMBUS_SCL_drv => vec_to_bit(max4galavafabrictop_i_pmbus_scl_drv), -- 1 bits (in)
			PMBUS_SDA_drv => vec_to_bit(max4galavafabrictop_i_pmbus_sda_drv), -- 1 bits (in)
			DIMM_LEFT_SCL_drv => vec_to_bit(max4galavafabrictop_i_i2c_left_dimm_scl_drv), -- 1 bits (in)
			DIMM_LEFT_SDA_drv => vec_to_bit(max4galavafabrictop_i_i2c_left_dimm_sda_drv), -- 1 bits (in)
			DIMM_RIGHT_SCL_drv => vec_to_bit(max4galavafabrictop_i_i2c_right_dimm_scl_drv), -- 1 bits (in)
			DIMM_RIGHT_SDA_drv => vec_to_bit(max4galavafabrictop_i_i2c_right_dimm_sda_drv), -- 1 bits (in)
			AUX_SCL_drv => vec_to_bit(max4galavafabrictop_i_i2c_aux_scl_drv), -- 1 bits (in)
			AUX_SDA_drv => vec_to_bit(max4galavafabrictop_i_i2c_aux_sda_drv), -- 1 bits (in)
			qsfp0_i2c_SCL_drv => vec_to_bit("0"), -- 1 bits (in)
			qsfp0_i2c_SDA_drv => vec_to_bit("0"), -- 1 bits (in)
			qsfp0_i2c_lpmode => vec_to_bit("0"), -- 1 bits (in)
			qsfp0_i2c_modsell => vec_to_bit("0"), -- 1 bits (in)
			qsfp0_i2c_resetl => vec_to_bit("0"), -- 1 bits (in)
			qsfp1_i2c_SCL_drv => vec_to_bit("0"), -- 1 bits (in)
			qsfp1_i2c_SDA_drv => vec_to_bit("0"), -- 1 bits (in)
			qsfp1_i2c_lpmode => vec_to_bit("0"), -- 1 bits (in)
			qsfp1_i2c_modsell => vec_to_bit("0"), -- 1 bits (in)
			qsfp1_i2c_resetl => vec_to_bit("0"), -- 1 bits (in)
			qsfp2_i2c_SCL_drv => vec_to_bit("0"), -- 1 bits (in)
			qsfp2_i2c_SDA_drv => vec_to_bit("0"), -- 1 bits (in)
			qsfp2_i2c_lpmode => vec_to_bit("0"), -- 1 bits (in)
			qsfp2_i2c_modsell => vec_to_bit("0"), -- 1 bits (in)
			qsfp2_i2c_resetl => vec_to_bit("0"), -- 1 bits (in)
			qsfp3_i2c_SCL_drv => vec_to_bit("0"), -- 1 bits (in)
			qsfp3_i2c_SDA_drv => vec_to_bit("0"), -- 1 bits (in)
			qsfp3_i2c_lpmode => vec_to_bit("0"), -- 1 bits (in)
			qsfp3_i2c_modsell => vec_to_bit("0"), -- 1 bits (in)
			qsfp3_i2c_resetl => vec_to_bit("0"), -- 1 bits (in)
			qsfp4_i2c_SCL_drv => vec_to_bit("0"), -- 1 bits (in)
			qsfp4_i2c_SDA_drv => vec_to_bit("0"), -- 1 bits (in)
			qsfp4_i2c_lpmode => vec_to_bit("0"), -- 1 bits (in)
			qsfp4_i2c_modsell => vec_to_bit("0"), -- 1 bits (in)
			qsfp4_i2c_resetl => vec_to_bit("0"), -- 1 bits (in)
			qsfp5_i2c_SCL_drv => vec_to_bit("0"), -- 1 bits (in)
			qsfp5_i2c_SDA_drv => vec_to_bit("0"), -- 1 bits (in)
			qsfp5_i2c_lpmode => vec_to_bit("0"), -- 1 bits (in)
			qsfp5_i2c_modsell => vec_to_bit("0"), -- 1 bits (in)
			qsfp5_i2c_resetl => vec_to_bit("0"), -- 1 bits (in)
			qsfp6_i2c_SCL_drv => vec_to_bit("0"), -- 1 bits (in)
			qsfp6_i2c_SDA_drv => vec_to_bit("0"), -- 1 bits (in)
			qsfp6_i2c_lpmode => vec_to_bit("0"), -- 1 bits (in)
			qsfp6_i2c_modsell => vec_to_bit("0"), -- 1 bits (in)
			qsfp6_i2c_resetl => vec_to_bit("0"), -- 1 bits (in)
			qsfp7_i2c_SCL_drv => vec_to_bit("0"), -- 1 bits (in)
			qsfp7_i2c_SDA_drv => vec_to_bit("0"), -- 1 bits (in)
			qsfp7_i2c_lpmode => vec_to_bit("0"), -- 1 bits (in)
			qsfp7_i2c_modsell => vec_to_bit("0"), -- 1 bits (in)
			qsfp7_i2c_resetl => vec_to_bit("0"), -- 1 bits (in)
			host_event_ack => max4galavafabrictop_i_host_event_ack, -- 97 bits (in)
			config_Reconfig_Trigger => vec_to_bit(max4galavafabrictop_i_config_reconfig_trigger), -- 1 bits (in)
			flash_control_flash_rx_addr => vec_to_bit(max4galavafabrictop_i_flash_control_flash_rx_addr), -- 1 bits (in)
			flash_control_flash_tx_d => max4galavafabrictop_i_flash_control_flash_tx_d, -- 64 bits (in)
			flash_control_flash_tx_we => vec_to_bit(max4galavafabrictop_i_flash_control_flash_tx_we), -- 1 bits (in)
			sda_in => sda_in, -- 1 bits (in)
			ssync_in => ssync_in, -- 1 bits (in)
			MAXRING_B_RESET => vec_to_bit("0") -- 1 bits (in)
		);
end MaxDC;
