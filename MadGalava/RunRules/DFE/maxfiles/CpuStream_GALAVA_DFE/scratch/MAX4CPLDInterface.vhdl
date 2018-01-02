library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity MAX4CPLDInterface is
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
end MAX4CPLDInterface;

architecture MaxDC of MAX4CPLDInterface is
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
	component max4_cpld_ioexpand is
		generic (
			BUS_WIDTH : integer;
			QSFP_PROFILE_ISCA : boolean;
			QSFP_PROFILE_JDFE : boolean
		);
		port (
			forced_output_values: in std_logic_vector(63 downto 0);
			forced_output_mask: in std_logic_vector(63 downto 0);
			RSTn: in std_logic;
			Clk: in std_logic;
			sData_from_CPLD: in std_logic;
			sData_sync_CPLD: in std_logic;
			PMBUS_SCL_drv: in std_logic;
			PMBUS_SDA_drv: in std_logic;
			DIMM_LEFT_SCL_drv: in std_logic;
			DIMM_LEFT_SDA_drv: in std_logic;
			DIMM_RIGHT_SCL_drv: in std_logic;
			DIMM_RIGHT_SDA_drv: in std_logic;
			AUX_SCL_drv: in std_logic;
			AUX_SDA_drv: in std_logic;
			QSFP0_SCL_drv: in std_logic;
			QSFP0_SDA_drv: in std_logic;
			QSFP0_lpmode: in std_logic;
			QSFP0_modsell: in std_logic;
			QSFP0_resetl: in std_logic;
			QSFP1_SCL_drv: in std_logic;
			QSFP1_SDA_drv: in std_logic;
			QSFP1_lpmode: in std_logic;
			QSFP1_modsell: in std_logic;
			QSFP1_resetl: in std_logic;
			QSFP2_SCL_drv: in std_logic;
			QSFP2_SDA_drv: in std_logic;
			QSFP2_lpmode: in std_logic;
			QSFP2_modsell: in std_logic;
			QSFP2_resetl: in std_logic;
			QSFP3_SCL_drv: in std_logic;
			QSFP3_SDA_drv: in std_logic;
			QSFP3_lpmode: in std_logic;
			QSFP3_modsell: in std_logic;
			QSFP3_resetl: in std_logic;
			QSFP4_SCL_drv: in std_logic;
			QSFP4_SDA_drv: in std_logic;
			QSFP4_lpmode: in std_logic;
			QSFP4_modsell: in std_logic;
			QSFP4_resetl: in std_logic;
			QSFP5_SCL_drv: in std_logic;
			QSFP5_SDA_drv: in std_logic;
			QSFP5_lpmode: in std_logic;
			QSFP5_modsell: in std_logic;
			QSFP5_resetl: in std_logic;
			QSFP6_SCL_drv: in std_logic;
			QSFP6_SDA_drv: in std_logic;
			QSFP6_lpmode: in std_logic;
			QSFP6_modsell: in std_logic;
			QSFP6_resetl: in std_logic;
			QSFP7_SCL_drv: in std_logic;
			QSFP7_SDA_drv: in std_logic;
			QSFP7_lpmode: in std_logic;
			QSFP7_modsell: in std_logic;
			QSFP7_resetl: in std_logic;
			Reconfig_Trigger: in std_logic;
			max4n_build_rev: in std_logic_vector(1 downto 0);
			MAXRING_B_RESET: in std_logic;
			LED_PHY1_UP: in std_logic;
			LED_PHY2_UP: in std_logic;
			LED_PHY3_UP: in std_logic;
			LED_PHY4_UP: in std_logic;
			LED_PHY5_UP: in std_logic;
			LED_PHY6_UP: in std_logic;
			LED_MAXRING_A: in std_logic;
			LED_MAXRING_B: in std_logic;
			LED_PAN_MAXRING_A: in std_logic;
			LED_PAN_MAXRING_B: in std_logic;
			LED_IDENTIFY: in std_logic;
			LED_PCIE_UP: in std_logic;
			LED_WARNING: in std_logic;
			LED_ERROR: in std_logic;
			MAXRING_A_TOP_SB_dir: in std_logic_vector(3 downto 0);
			MAXRING_A_TOP_SB_drv: in std_logic_vector(3 downto 0);
			MAXRING_A_BOTTOM_SB_dir: in std_logic_vector(3 downto 0);
			MAXRING_A_BOTTOM_SB_drv: in std_logic_vector(3 downto 0);
			MAXRING_B_MODTX_SB_dir: in std_logic_vector(1 downto 0);
			MAXRING_B_MODTX_SB_drv: in std_logic_vector(1 downto 0);
			MAXRING_B_MODRX_SB_dir: in std_logic_vector(1 downto 0);
			MAXRING_B_MODRX_SB_drv: in std_logic_vector(1 downto 0);
			sData_to_CPLD: out std_logic;
			PMBUS_SCL_fb: out std_logic;
			PMBUS_SDA_fb: out std_logic;
			PMBUS_ALERT: out std_logic;
			DIMM_LEFT_SCL_fb: out std_logic;
			DIMM_LEFT_SDA_fb: out std_logic;
			DIMM_ALERT: out std_logic;
			DIMM_RIGHT_SCL_fb: out std_logic;
			DIMM_RIGHT_SDA_fb: out std_logic;
			AUX_SCL_fb: out std_logic;
			AUX_SDA_fb: out std_logic;
			AUX_ALERT: out std_logic;
			QSFP0_SCL_fb: out std_logic;
			QSFP0_SDA_fb: out std_logic;
			QSFP0_ALERT: out std_logic;
			QSFP0_modprsl: out std_logic;
			QSFP1_SCL_fb: out std_logic;
			QSFP1_SDA_fb: out std_logic;
			QSFP1_ALERT: out std_logic;
			QSFP1_modprsl: out std_logic;
			QSFP2_SCL_fb: out std_logic;
			QSFP2_SDA_fb: out std_logic;
			QSFP2_ALERT: out std_logic;
			QSFP2_modprsl: out std_logic;
			QSFP3_SCL_fb: out std_logic;
			QSFP3_SDA_fb: out std_logic;
			QSFP3_ALERT: out std_logic;
			QSFP3_modprsl: out std_logic;
			QSFP4_SCL_fb: out std_logic;
			QSFP4_SDA_fb: out std_logic;
			QSFP4_ALERT: out std_logic;
			QSFP4_modprsl: out std_logic;
			QSFP5_SCL_fb: out std_logic;
			QSFP5_SDA_fb: out std_logic;
			QSFP5_ALERT: out std_logic;
			QSFP5_modprsl: out std_logic;
			QSFP6_SCL_fb: out std_logic;
			QSFP6_SDA_fb: out std_logic;
			QSFP6_ALERT: out std_logic;
			QSFP6_modprsl: out std_logic;
			QSFP7_SCL_fb: out std_logic;
			QSFP7_SDA_fb: out std_logic;
			QSFP7_ALERT: out std_logic;
			QSFP7_modprsl: out std_logic;
			DDR_VREFDQ_RIGHT_POWER_GOOD: out std_logic;
			DDR_VREFDQ_LEFT_POWER_GOOD: out std_logic;
			CTL1_POWER_GOOD: out std_logic;
			CTL2_POWER_GOOD: out std_logic;
			FPGA_INIT_DONE: out std_logic;
			FPGA_CRC_ERROR: out std_logic;
			FPGA_CvP_CONFDONE: out std_logic;
			DIPSW: out std_logic_vector(3 downto 0);
			ASSY_REV: out std_logic_vector(1 downto 0);
			PCB_REV: out std_logic_vector(1 downto 0);
			CPLD_Version: out std_logic_vector(7 downto 0);
			BUILD_REV: out std_logic_vector(1 downto 0);
			MAXRING_A_TOP_SB_fb: out std_logic_vector(3 downto 0);
			MAXRING_A_BOTTOM_SB_fb: out std_logic_vector(3 downto 0);
			MAXRING_B_MODTX_SB_fb: out std_logic_vector(1 downto 0);
			MAXRING_B_MODRX_SB_fb: out std_logic_vector(1 downto 0)
		);
	end component;
	component vhdl_input_synchronized_bus_synchronizer is
		generic (
			width : integer;
			reset_value : integer;
			IS_VIRTEX6 : boolean
		);
		port (
			in_clk: in std_logic;
			in_rst: in std_logic;
			dat_i: in std_logic_vector(width-1 downto 0);
			out_clk: in std_logic;
			out_rst: in std_logic;
			dat_o: out std_logic_vector(width-1 downto 0)
		);
	end component;
	component MAXEvents is
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
	end component;
	component max4_cpld_flash_if is
		generic (
			BUS_WIDTH : integer
		);
		port (
			sclk: in std_logic;
			rst: in std_logic;
			cclk: in std_logic;
			RX_ADDR: in std_logic;
			TX_D: in std_logic_vector(BUS_WIDTH-1 downto 0);
			TX_WE: in std_logic;
			FROM_CPLD_V: in std_logic;
			CPLD_Data_l: inout std_logic_vector(15 downto 0);
			CPLD_Data_h: inout std_logic_vector(9 downto 0);
			RX_D: out std_logic_vector(BUS_WIDTH-1 downto 0);
			TO_CPLD_V: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal cpld_io_ext_inst_sdata_to_cpld : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_pmbus_scl_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_pmbus_sda_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_pmbus_alert : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_dimm_left_scl_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_dimm_left_sda_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_dimm_alert : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_dimm_right_scl_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_dimm_right_sda_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_aux_scl_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_aux_sda_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_aux_alert : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp0_scl_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp0_sda_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp0_alert : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp0_modprsl : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp1_scl_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp1_sda_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp1_alert : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp1_modprsl : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp2_scl_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp2_sda_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp2_alert : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp2_modprsl : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp3_scl_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp3_sda_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp3_alert : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp3_modprsl : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp4_scl_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp4_sda_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp4_alert : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp4_modprsl : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp5_scl_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp5_sda_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp5_alert : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp5_modprsl : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp6_scl_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp6_sda_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp6_alert : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp6_modprsl : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp7_scl_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp7_sda_fb : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp7_alert : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_qsfp7_modprsl : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_ddr_vrefdq_right_power_good : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_ddr_vrefdq_left_power_good : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_ctl1_power_good : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_ctl2_power_good : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_fpga_init_done : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_fpga_crc_error : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_fpga_cvp_confdone : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_dipsw : std_logic_vector(3 downto 0);
	signal cpld_io_ext_inst_assy_rev : std_logic_vector(1 downto 0);
	signal cpld_io_ext_inst_pcb_rev : std_logic_vector(1 downto 0);
	signal cpld_io_ext_inst_cpld_version : std_logic_vector(7 downto 0);
	signal cpld_io_ext_inst_build_rev : std_logic_vector(1 downto 0);
	signal cpld_io_ext_inst_maxring_a_top_sb_fb : std_logic_vector(3 downto 0);
	signal cpld_io_ext_inst_maxring_a_bottom_sb_fb : std_logic_vector(3 downto 0);
	signal cpld_io_ext_inst_maxring_b_modtx_sb_fb : std_logic_vector(1 downto 0);
	signal cpld_io_ext_inst_maxring_b_modrx_sb_fb : std_logic_vector(1 downto 0);
	signal reconfig_triger_strobe_dat_o : std_logic_vector(0 downto 0);
	signal max_events_host_event_status : std_logic_vector(96 downto 0);
	signal max_events_warning_led : std_logic_vector(0 downto 0);
	signal cpld_flash_ext_inst_rx_d : std_logic_vector(63 downto 0);
	signal cpld_flash_ext_inst_to_cpld_v : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_led_phy1_up1 : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_led_phy2_up1 : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_led_phy3_up1 : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_led_phy4_up1 : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_led_phy5_up1 : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_led_phy6_up1 : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_led_maxring_a1 : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_led_maxring_b1 : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_led_pan_maxring_a1 : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_led_pan_maxring_b1 : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_led_identify1 : std_logic_vector(0 downto 0);
	signal cpld_io_ext_inst_led_pcie_up1 : std_logic_vector(0 downto 0);
	signal max_events_rst1 : std_logic_vector(0 downto 0);
	signal cpld_flash_ext_inst_rst1 : std_logic_vector(0 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	cpld_io_ext_inst_led_phy1_up1 <= slice(led_phy_up, 0, 1);
	cpld_io_ext_inst_led_phy2_up1 <= slice(led_phy_up, 1, 1);
	cpld_io_ext_inst_led_phy3_up1 <= slice(led_phy_up, 2, 1);
	cpld_io_ext_inst_led_phy4_up1 <= slice(led_phy_up, 3, 1);
	cpld_io_ext_inst_led_phy5_up1 <= slice(led_phy_up, 4, 1);
	cpld_io_ext_inst_led_phy6_up1 <= slice(led_phy_up, 5, 1);
	cpld_io_ext_inst_led_maxring_a1 <= slice(led_maxring, 0, 1);
	cpld_io_ext_inst_led_maxring_b1 <= slice(led_maxring, 1, 1);
	cpld_io_ext_inst_led_pan_maxring_a1 <= slice(led_pan_maxring, 0, 1);
	cpld_io_ext_inst_led_pan_maxring_b1 <= slice(led_pan_maxring, 1, 1);
	cpld_io_ext_inst_led_identify1 <= slice(led_pcie, 1, 1);
	cpld_io_ext_inst_led_pcie_up1 <= slice(led_pcie, 0, 1);
	max_events_rst1 <= (not bit_to_vec(sys_rst_n));
	cpld_flash_ext_inst_rst1 <= (not bit_to_vec(sys_rst_n));
	to_flash_valid <= vec_to_bit(cpld_flash_ext_inst_to_cpld_v);
	PMBUS_SCL_fb <= vec_to_bit(cpld_io_ext_inst_pmbus_scl_fb);
	PMBUS_SDA_fb <= vec_to_bit(cpld_io_ext_inst_pmbus_sda_fb);
	PMBUS_ALERT <= vec_to_bit(cpld_io_ext_inst_pmbus_alert);
	DIMM_LEFT_SCL_fb <= vec_to_bit(cpld_io_ext_inst_dimm_left_scl_fb);
	DIMM_LEFT_SDA_fb <= vec_to_bit(cpld_io_ext_inst_dimm_left_sda_fb);
	DIMM_RIGHT_SCL_fb <= vec_to_bit(cpld_io_ext_inst_dimm_right_scl_fb);
	DIMM_RIGHT_SDA_fb <= vec_to_bit(cpld_io_ext_inst_dimm_right_sda_fb);
	DIMM_ALERT <= vec_to_bit(cpld_io_ext_inst_dimm_alert);
	AUX_SCL_fb <= vec_to_bit(cpld_io_ext_inst_aux_scl_fb);
	AUX_SDA_fb <= vec_to_bit(cpld_io_ext_inst_aux_sda_fb);
	AUX_ALERT <= vec_to_bit(cpld_io_ext_inst_aux_alert);
	qsfp0_i2c_SCL_fb <= vec_to_bit(cpld_io_ext_inst_qsfp0_scl_fb);
	qsfp0_i2c_SDA_fb <= vec_to_bit(cpld_io_ext_inst_qsfp0_sda_fb);
	qsfp0_i2c_ALERT <= vec_to_bit(cpld_io_ext_inst_qsfp0_alert);
	qsfp0_i2c_modprsl <= vec_to_bit(cpld_io_ext_inst_qsfp0_modprsl);
	qsfp1_i2c_SCL_fb <= vec_to_bit(cpld_io_ext_inst_qsfp1_scl_fb);
	qsfp1_i2c_SDA_fb <= vec_to_bit(cpld_io_ext_inst_qsfp1_sda_fb);
	qsfp1_i2c_ALERT <= vec_to_bit(cpld_io_ext_inst_qsfp1_alert);
	qsfp1_i2c_modprsl <= vec_to_bit(cpld_io_ext_inst_qsfp1_modprsl);
	qsfp2_i2c_SCL_fb <= vec_to_bit(cpld_io_ext_inst_qsfp2_scl_fb);
	qsfp2_i2c_SDA_fb <= vec_to_bit(cpld_io_ext_inst_qsfp2_sda_fb);
	qsfp2_i2c_ALERT <= vec_to_bit(cpld_io_ext_inst_qsfp2_alert);
	qsfp2_i2c_modprsl <= vec_to_bit(cpld_io_ext_inst_qsfp2_modprsl);
	qsfp3_i2c_SCL_fb <= vec_to_bit(cpld_io_ext_inst_qsfp3_scl_fb);
	qsfp3_i2c_SDA_fb <= vec_to_bit(cpld_io_ext_inst_qsfp3_sda_fb);
	qsfp3_i2c_ALERT <= vec_to_bit(cpld_io_ext_inst_qsfp3_alert);
	qsfp3_i2c_modprsl <= vec_to_bit(cpld_io_ext_inst_qsfp3_modprsl);
	qsfp4_i2c_SCL_fb <= vec_to_bit(cpld_io_ext_inst_qsfp4_scl_fb);
	qsfp4_i2c_SDA_fb <= vec_to_bit(cpld_io_ext_inst_qsfp4_sda_fb);
	qsfp4_i2c_ALERT <= vec_to_bit(cpld_io_ext_inst_qsfp4_alert);
	qsfp4_i2c_modprsl <= vec_to_bit(cpld_io_ext_inst_qsfp4_modprsl);
	qsfp5_i2c_SCL_fb <= vec_to_bit(cpld_io_ext_inst_qsfp5_scl_fb);
	qsfp5_i2c_SDA_fb <= vec_to_bit(cpld_io_ext_inst_qsfp5_sda_fb);
	qsfp5_i2c_ALERT <= vec_to_bit(cpld_io_ext_inst_qsfp5_alert);
	qsfp5_i2c_modprsl <= vec_to_bit(cpld_io_ext_inst_qsfp5_modprsl);
	qsfp6_i2c_SCL_fb <= vec_to_bit(cpld_io_ext_inst_qsfp6_scl_fb);
	qsfp6_i2c_SDA_fb <= vec_to_bit(cpld_io_ext_inst_qsfp6_sda_fb);
	qsfp6_i2c_ALERT <= vec_to_bit(cpld_io_ext_inst_qsfp6_alert);
	qsfp6_i2c_modprsl <= vec_to_bit(cpld_io_ext_inst_qsfp6_modprsl);
	qsfp7_i2c_SCL_fb <= vec_to_bit(cpld_io_ext_inst_qsfp7_scl_fb);
	qsfp7_i2c_SDA_fb <= vec_to_bit(cpld_io_ext_inst_qsfp7_sda_fb);
	qsfp7_i2c_ALERT <= vec_to_bit(cpld_io_ext_inst_qsfp7_alert);
	qsfp7_i2c_modprsl <= vec_to_bit(cpld_io_ext_inst_qsfp7_modprsl);
	host_event_status <= max_events_host_event_status;
	config_FPGA_INIT_DONE <= vec_to_bit(cpld_io_ext_inst_fpga_init_done);
	config_FPGA_CRC_ERROR <= vec_to_bit(cpld_io_ext_inst_fpga_crc_error);
	config_FPGA_CvP_CONFDONE <= vec_to_bit(cpld_io_ext_inst_fpga_cvp_confdone);
	rev_DIPSW <= cpld_io_ext_inst_dipsw;
	rev_ASSY_REV <= cpld_io_ext_inst_assy_rev;
	rev_PCB_REV <= cpld_io_ext_inst_pcb_rev;
	rev_CPLD_Version <= cpld_io_ext_inst_cpld_version;
	rev_BUILD_REV <= cpld_io_ext_inst_build_rev;
	flash_control_flash_rx_d <= cpld_flash_ext_inst_rx_d;
	sda_out <= vec_to_bit(cpld_io_ext_inst_sdata_to_cpld);
	
	-- Register processes
	
	
	-- Entity instances
	
	cpld_io_ext_inst : max4_cpld_ioexpand
		generic map (
			BUS_WIDTH => 64,
			QSFP_PROFILE_ISCA => false,
			QSFP_PROFILE_JDFE => false
		)
		port map (
			sData_to_CPLD => cpld_io_ext_inst_sdata_to_cpld(0), -- 1 bits (out)
			PMBUS_SCL_fb => cpld_io_ext_inst_pmbus_scl_fb(0), -- 1 bits (out)
			PMBUS_SDA_fb => cpld_io_ext_inst_pmbus_sda_fb(0), -- 1 bits (out)
			PMBUS_ALERT => cpld_io_ext_inst_pmbus_alert(0), -- 1 bits (out)
			DIMM_LEFT_SCL_fb => cpld_io_ext_inst_dimm_left_scl_fb(0), -- 1 bits (out)
			DIMM_LEFT_SDA_fb => cpld_io_ext_inst_dimm_left_sda_fb(0), -- 1 bits (out)
			DIMM_ALERT => cpld_io_ext_inst_dimm_alert(0), -- 1 bits (out)
			DIMM_RIGHT_SCL_fb => cpld_io_ext_inst_dimm_right_scl_fb(0), -- 1 bits (out)
			DIMM_RIGHT_SDA_fb => cpld_io_ext_inst_dimm_right_sda_fb(0), -- 1 bits (out)
			AUX_SCL_fb => cpld_io_ext_inst_aux_scl_fb(0), -- 1 bits (out)
			AUX_SDA_fb => cpld_io_ext_inst_aux_sda_fb(0), -- 1 bits (out)
			AUX_ALERT => cpld_io_ext_inst_aux_alert(0), -- 1 bits (out)
			QSFP0_SCL_fb => cpld_io_ext_inst_qsfp0_scl_fb(0), -- 1 bits (out)
			QSFP0_SDA_fb => cpld_io_ext_inst_qsfp0_sda_fb(0), -- 1 bits (out)
			QSFP0_ALERT => cpld_io_ext_inst_qsfp0_alert(0), -- 1 bits (out)
			QSFP0_modprsl => cpld_io_ext_inst_qsfp0_modprsl(0), -- 1 bits (out)
			QSFP1_SCL_fb => cpld_io_ext_inst_qsfp1_scl_fb(0), -- 1 bits (out)
			QSFP1_SDA_fb => cpld_io_ext_inst_qsfp1_sda_fb(0), -- 1 bits (out)
			QSFP1_ALERT => cpld_io_ext_inst_qsfp1_alert(0), -- 1 bits (out)
			QSFP1_modprsl => cpld_io_ext_inst_qsfp1_modprsl(0), -- 1 bits (out)
			QSFP2_SCL_fb => cpld_io_ext_inst_qsfp2_scl_fb(0), -- 1 bits (out)
			QSFP2_SDA_fb => cpld_io_ext_inst_qsfp2_sda_fb(0), -- 1 bits (out)
			QSFP2_ALERT => cpld_io_ext_inst_qsfp2_alert(0), -- 1 bits (out)
			QSFP2_modprsl => cpld_io_ext_inst_qsfp2_modprsl(0), -- 1 bits (out)
			QSFP3_SCL_fb => cpld_io_ext_inst_qsfp3_scl_fb(0), -- 1 bits (out)
			QSFP3_SDA_fb => cpld_io_ext_inst_qsfp3_sda_fb(0), -- 1 bits (out)
			QSFP3_ALERT => cpld_io_ext_inst_qsfp3_alert(0), -- 1 bits (out)
			QSFP3_modprsl => cpld_io_ext_inst_qsfp3_modprsl(0), -- 1 bits (out)
			QSFP4_SCL_fb => cpld_io_ext_inst_qsfp4_scl_fb(0), -- 1 bits (out)
			QSFP4_SDA_fb => cpld_io_ext_inst_qsfp4_sda_fb(0), -- 1 bits (out)
			QSFP4_ALERT => cpld_io_ext_inst_qsfp4_alert(0), -- 1 bits (out)
			QSFP4_modprsl => cpld_io_ext_inst_qsfp4_modprsl(0), -- 1 bits (out)
			QSFP5_SCL_fb => cpld_io_ext_inst_qsfp5_scl_fb(0), -- 1 bits (out)
			QSFP5_SDA_fb => cpld_io_ext_inst_qsfp5_sda_fb(0), -- 1 bits (out)
			QSFP5_ALERT => cpld_io_ext_inst_qsfp5_alert(0), -- 1 bits (out)
			QSFP5_modprsl => cpld_io_ext_inst_qsfp5_modprsl(0), -- 1 bits (out)
			QSFP6_SCL_fb => cpld_io_ext_inst_qsfp6_scl_fb(0), -- 1 bits (out)
			QSFP6_SDA_fb => cpld_io_ext_inst_qsfp6_sda_fb(0), -- 1 bits (out)
			QSFP6_ALERT => cpld_io_ext_inst_qsfp6_alert(0), -- 1 bits (out)
			QSFP6_modprsl => cpld_io_ext_inst_qsfp6_modprsl(0), -- 1 bits (out)
			QSFP7_SCL_fb => cpld_io_ext_inst_qsfp7_scl_fb(0), -- 1 bits (out)
			QSFP7_SDA_fb => cpld_io_ext_inst_qsfp7_sda_fb(0), -- 1 bits (out)
			QSFP7_ALERT => cpld_io_ext_inst_qsfp7_alert(0), -- 1 bits (out)
			QSFP7_modprsl => cpld_io_ext_inst_qsfp7_modprsl(0), -- 1 bits (out)
			DDR_VREFDQ_RIGHT_POWER_GOOD => cpld_io_ext_inst_ddr_vrefdq_right_power_good(0), -- 1 bits (out)
			DDR_VREFDQ_LEFT_POWER_GOOD => cpld_io_ext_inst_ddr_vrefdq_left_power_good(0), -- 1 bits (out)
			CTL1_POWER_GOOD => cpld_io_ext_inst_ctl1_power_good(0), -- 1 bits (out)
			CTL2_POWER_GOOD => cpld_io_ext_inst_ctl2_power_good(0), -- 1 bits (out)
			FPGA_INIT_DONE => cpld_io_ext_inst_fpga_init_done(0), -- 1 bits (out)
			FPGA_CRC_ERROR => cpld_io_ext_inst_fpga_crc_error(0), -- 1 bits (out)
			FPGA_CvP_CONFDONE => cpld_io_ext_inst_fpga_cvp_confdone(0), -- 1 bits (out)
			DIPSW => cpld_io_ext_inst_dipsw, -- 4 bits (out)
			ASSY_REV => cpld_io_ext_inst_assy_rev, -- 2 bits (out)
			PCB_REV => cpld_io_ext_inst_pcb_rev, -- 2 bits (out)
			CPLD_Version => cpld_io_ext_inst_cpld_version, -- 8 bits (out)
			BUILD_REV => cpld_io_ext_inst_build_rev, -- 2 bits (out)
			MAXRING_A_TOP_SB_fb => cpld_io_ext_inst_maxring_a_top_sb_fb, -- 4 bits (out)
			MAXRING_A_BOTTOM_SB_fb => cpld_io_ext_inst_maxring_a_bottom_sb_fb, -- 4 bits (out)
			MAXRING_B_MODTX_SB_fb => cpld_io_ext_inst_maxring_b_modtx_sb_fb, -- 2 bits (out)
			MAXRING_B_MODRX_SB_fb => cpld_io_ext_inst_maxring_b_modrx_sb_fb, -- 2 bits (out)
			forced_output_values => "0000000000000000000000000000000000000000000000000000000000000000", -- 64 bits (in)
			forced_output_mask => "0000000000000000000000000000000000000000000000000000000000000000", -- 64 bits (in)
			RSTn => sys_rst_n, -- 1 bits (in)
			Clk => cclk, -- 1 bits (in)
			sData_from_CPLD => sda_in, -- 1 bits (in)
			sData_sync_CPLD => ssync_in, -- 1 bits (in)
			PMBUS_SCL_drv => PMBUS_SCL_drv, -- 1 bits (in)
			PMBUS_SDA_drv => PMBUS_SDA_drv, -- 1 bits (in)
			DIMM_LEFT_SCL_drv => DIMM_LEFT_SCL_drv, -- 1 bits (in)
			DIMM_LEFT_SDA_drv => DIMM_LEFT_SDA_drv, -- 1 bits (in)
			DIMM_RIGHT_SCL_drv => DIMM_RIGHT_SCL_drv, -- 1 bits (in)
			DIMM_RIGHT_SDA_drv => DIMM_RIGHT_SDA_drv, -- 1 bits (in)
			AUX_SCL_drv => AUX_SCL_drv, -- 1 bits (in)
			AUX_SDA_drv => AUX_SDA_drv, -- 1 bits (in)
			QSFP0_SCL_drv => qsfp0_i2c_SCL_drv, -- 1 bits (in)
			QSFP0_SDA_drv => qsfp0_i2c_SDA_drv, -- 1 bits (in)
			QSFP0_lpmode => qsfp0_i2c_lpmode, -- 1 bits (in)
			QSFP0_modsell => qsfp0_i2c_modsell, -- 1 bits (in)
			QSFP0_resetl => qsfp0_i2c_resetl, -- 1 bits (in)
			QSFP1_SCL_drv => qsfp1_i2c_SCL_drv, -- 1 bits (in)
			QSFP1_SDA_drv => qsfp1_i2c_SDA_drv, -- 1 bits (in)
			QSFP1_lpmode => qsfp1_i2c_lpmode, -- 1 bits (in)
			QSFP1_modsell => qsfp1_i2c_modsell, -- 1 bits (in)
			QSFP1_resetl => qsfp1_i2c_resetl, -- 1 bits (in)
			QSFP2_SCL_drv => qsfp2_i2c_SCL_drv, -- 1 bits (in)
			QSFP2_SDA_drv => qsfp2_i2c_SDA_drv, -- 1 bits (in)
			QSFP2_lpmode => qsfp2_i2c_lpmode, -- 1 bits (in)
			QSFP2_modsell => qsfp2_i2c_modsell, -- 1 bits (in)
			QSFP2_resetl => qsfp2_i2c_resetl, -- 1 bits (in)
			QSFP3_SCL_drv => qsfp3_i2c_SCL_drv, -- 1 bits (in)
			QSFP3_SDA_drv => qsfp3_i2c_SDA_drv, -- 1 bits (in)
			QSFP3_lpmode => qsfp3_i2c_lpmode, -- 1 bits (in)
			QSFP3_modsell => qsfp3_i2c_modsell, -- 1 bits (in)
			QSFP3_resetl => qsfp3_i2c_resetl, -- 1 bits (in)
			QSFP4_SCL_drv => qsfp4_i2c_SCL_drv, -- 1 bits (in)
			QSFP4_SDA_drv => qsfp4_i2c_SDA_drv, -- 1 bits (in)
			QSFP4_lpmode => qsfp4_i2c_lpmode, -- 1 bits (in)
			QSFP4_modsell => qsfp4_i2c_modsell, -- 1 bits (in)
			QSFP4_resetl => qsfp4_i2c_resetl, -- 1 bits (in)
			QSFP5_SCL_drv => qsfp5_i2c_SCL_drv, -- 1 bits (in)
			QSFP5_SDA_drv => qsfp5_i2c_SDA_drv, -- 1 bits (in)
			QSFP5_lpmode => qsfp5_i2c_lpmode, -- 1 bits (in)
			QSFP5_modsell => qsfp5_i2c_modsell, -- 1 bits (in)
			QSFP5_resetl => qsfp5_i2c_resetl, -- 1 bits (in)
			QSFP6_SCL_drv => qsfp6_i2c_SCL_drv, -- 1 bits (in)
			QSFP6_SDA_drv => qsfp6_i2c_SDA_drv, -- 1 bits (in)
			QSFP6_lpmode => qsfp6_i2c_lpmode, -- 1 bits (in)
			QSFP6_modsell => qsfp6_i2c_modsell, -- 1 bits (in)
			QSFP6_resetl => qsfp6_i2c_resetl, -- 1 bits (in)
			QSFP7_SCL_drv => qsfp7_i2c_SCL_drv, -- 1 bits (in)
			QSFP7_SDA_drv => qsfp7_i2c_SDA_drv, -- 1 bits (in)
			QSFP7_lpmode => qsfp7_i2c_lpmode, -- 1 bits (in)
			QSFP7_modsell => qsfp7_i2c_modsell, -- 1 bits (in)
			QSFP7_resetl => qsfp7_i2c_resetl, -- 1 bits (in)
			Reconfig_Trigger => vec_to_bit(reconfig_triger_strobe_dat_o), -- 1 bits (in)
			max4n_build_rev => "00", -- 2 bits (in)
			MAXRING_B_RESET => MAXRING_B_RESET, -- 1 bits (in)
			LED_PHY1_UP => vec_to_bit(cpld_io_ext_inst_led_phy1_up1), -- 1 bits (in)
			LED_PHY2_UP => vec_to_bit(cpld_io_ext_inst_led_phy2_up1), -- 1 bits (in)
			LED_PHY3_UP => vec_to_bit(cpld_io_ext_inst_led_phy3_up1), -- 1 bits (in)
			LED_PHY4_UP => vec_to_bit(cpld_io_ext_inst_led_phy4_up1), -- 1 bits (in)
			LED_PHY5_UP => vec_to_bit(cpld_io_ext_inst_led_phy5_up1), -- 1 bits (in)
			LED_PHY6_UP => vec_to_bit(cpld_io_ext_inst_led_phy6_up1), -- 1 bits (in)
			LED_MAXRING_A => vec_to_bit(cpld_io_ext_inst_led_maxring_a1), -- 1 bits (in)
			LED_MAXRING_B => vec_to_bit(cpld_io_ext_inst_led_maxring_b1), -- 1 bits (in)
			LED_PAN_MAXRING_A => vec_to_bit(cpld_io_ext_inst_led_pan_maxring_a1), -- 1 bits (in)
			LED_PAN_MAXRING_B => vec_to_bit(cpld_io_ext_inst_led_pan_maxring_b1), -- 1 bits (in)
			LED_IDENTIFY => vec_to_bit(cpld_io_ext_inst_led_identify1), -- 1 bits (in)
			LED_PCIE_UP => vec_to_bit(cpld_io_ext_inst_led_pcie_up1), -- 1 bits (in)
			LED_WARNING => vec_to_bit(max_events_warning_led), -- 1 bits (in)
			LED_ERROR => vec_to_bit("0"), -- 1 bits (in)
			MAXRING_A_TOP_SB_dir => "0000", -- 4 bits (in)
			MAXRING_A_TOP_SB_drv => "0000", -- 4 bits (in)
			MAXRING_A_BOTTOM_SB_dir => "0000", -- 4 bits (in)
			MAXRING_A_BOTTOM_SB_drv => "0000", -- 4 bits (in)
			MAXRING_B_MODTX_SB_dir => "00", -- 2 bits (in)
			MAXRING_B_MODTX_SB_drv => "00", -- 2 bits (in)
			MAXRING_B_MODRX_SB_dir => "00", -- 2 bits (in)
			MAXRING_B_MODRX_SB_drv => "00" -- 2 bits (in)
		);
	reconfig_triger_strobe : vhdl_input_synchronized_bus_synchronizer
		generic map (
			width => 1,
			reset_value => 0,
			IS_VIRTEX6 => false
		)
		port map (
			dat_o => reconfig_triger_strobe_dat_o, -- 1 bits (out)
			in_clk => pcie_clk, -- 1 bits (in)
			in_rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => bit_to_vec(config_Reconfig_Trigger), -- 1 bits (in)
			out_clk => cclk, -- 1 bits (in)
			out_rst => vec_to_bit("0") -- 1 bits (in)
		);
	max_events : MAXEvents
		port map (
			host_event_status => max_events_host_event_status, -- 97 bits (out)
			warning_led => max_events_warning_led(0), -- 1 bits (out)
			clk => pcie_clk, -- 1 bits (in)
			rst => vec_to_bit(max_events_rst1), -- 1 bits (in)
			PMBUS_ALERT => vec_to_bit(cpld_io_ext_inst_pmbus_alert), -- 1 bits (in)
			DDR_EVENT_B => vec_to_bit(cpld_io_ext_inst_dimm_alert), -- 1 bits (in)
			AUX_EVENT => vec_to_bit(cpld_io_ext_inst_aux_alert), -- 1 bits (in)
			DDR_VREFDQ_RIGHT_POWER_GOOD => vec_to_bit(cpld_io_ext_inst_ddr_vrefdq_right_power_good), -- 1 bits (in)
			DDR_VREFDQ_LEFT_POWER_GOOD => vec_to_bit(cpld_io_ext_inst_ddr_vrefdq_left_power_good), -- 1 bits (in)
			CTL1_POWER_GOOD => vec_to_bit(cpld_io_ext_inst_ctl1_power_good), -- 1 bits (in)
			CTL2_POWER_GOOD => vec_to_bit(cpld_io_ext_inst_ctl2_power_good), -- 1 bits (in)
			host_event_ack => host_event_ack -- 97 bits (in)
		);
	cpld_flash_ext_inst : max4_cpld_flash_if
		generic map (
			BUS_WIDTH => 64
		)
		port map (
			RX_D => cpld_flash_ext_inst_rx_d, -- 64 bits (out)
			TO_CPLD_V => cpld_flash_ext_inst_to_cpld_v(0), -- 1 bits (out)
			CPLD_Data_l(15 downto 0) => fpga_config_fpp_data(15 downto 0), -- 16 bits (inout)
			CPLD_Data_h(9 downto 0) => flash_data(9 downto 0), -- 10 bits (inout)
			sclk => pcie_clk, -- 1 bits (in)
			rst => vec_to_bit(cpld_flash_ext_inst_rst1), -- 1 bits (in)
			cclk => cclk, -- 1 bits (in)
			RX_ADDR => flash_control_flash_rx_addr, -- 1 bits (in)
			TX_D => flash_control_flash_tx_d, -- 64 bits (in)
			TX_WE => flash_control_flash_tx_we, -- 1 bits (in)
			FROM_CPLD_V => from_flash_valid -- 1 bits (in)
		);
end MaxDC;
