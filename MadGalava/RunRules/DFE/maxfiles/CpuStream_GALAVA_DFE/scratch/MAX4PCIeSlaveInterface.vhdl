library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity MAX4PCIeSlaveInterface is
	port (
		clk_pcie: in std_logic;
		rst_pcie_n: in std_logic;
		mappedreg_reg_data_out: in std_logic_vector(31 downto 0);
		mappedreg_reg_completion_toggle: in std_logic;
		mappedreg_stream_interrupt_toggle: in std_logic_vector(15 downto 0);
		pcie_capabilities: in std_logic_vector(15 downto 0);
		slave_streaming_buf_cap: in std_logic_vector(31 downto 0);
		dma_complete_sfh: in std_logic_vector(31 downto 0);
		dma_complete_sth: in std_logic_vector(31 downto 0);
		dma_ctl_read_data: in std_logic_vector(63 downto 0);
		req_interrupt_ctl_valid: in std_logic;
		req_interrupt_ctl_enable_id: in std_logic_vector(31 downto 0);
		reg_data_out: in std_logic_vector(63 downto 0);
		reg_data_wren: in std_logic_vector(7 downto 0);
		reg_data_addr: in std_logic_vector(63 downto 0);
		reg_data_bar0: in std_logic;
		reg_data_bar2: in std_logic;
		rx_reg_read_compl_tc: in std_logic_vector(2 downto 0);
		rx_reg_read_compl_td: in std_logic;
		rx_reg_read_compl_ep: in std_logic;
		rx_reg_read_compl_attr: in std_logic_vector(1 downto 0);
		rx_reg_read_compl_rid: in std_logic_vector(15 downto 0);
		rx_reg_read_compl_tag: in std_logic_vector(7 downto 0);
		rx_reg_read_compl_addr: in std_logic_vector(63 downto 0);
		rx_reg_read_compl_bar2: in std_logic;
		rx_reg_read_compl_req: in std_logic;
		rx_reg_read_compl_size: in std_logic_vector(9 downto 0);
		tx_reg_compl_rden: in std_logic;
		tx_reg_compl_ack: in std_logic;
		app_int_ack: in std_logic;
		app_msi_ack: in std_logic;
		tl_cfg_ctl: in std_logic_vector(31 downto 0);
		tl_cfg_add: in std_logic_vector(3 downto 0);
		ltssmstate: in std_logic_vector(4 downto 0);
		maxring_s_th: in std_logic_vector(3 downto 0);
		maxring_id_th: in std_logic_vector(3 downto 0);
		maxring_prsn_th: in std_logic;
		maxring_type_th: in std_logic_vector(1 downto 0);
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
		flash_rx_d: in std_logic_vector(63 downto 0);
		mapped_elements_version: in std_logic_vector(31 downto 0);
		mapped_elements_empty: in std_logic;
		mapped_elements_fc_type: in std_logic_vector(1 downto 0);
		mapped_elements_toggle: in std_logic;
		mapped_elements_data: in std_logic_vector(31 downto 0);
		mapped_elements_fill: in std_logic_vector(9 downto 0);
		bar_status_tx_fifo_empty: in std_logic;
		sfa_user_toggle_ack: in std_logic;
		slave_sfh_card_credits0_index: in std_logic_vector(0 downto 0);
		slave_sfh_card_credits0_update: in std_logic;
		slave_sfh_card_credits0_wrap: in std_logic;
		slave_sfh_card_credits1_index: in std_logic_vector(0 downto 0);
		slave_sfh_card_credits1_update: in std_logic;
		slave_sfh_card_credits1_wrap: in std_logic;
		slave_sfh_card_credits2_index: in std_logic_vector(0 downto 0);
		slave_sfh_card_credits2_update: in std_logic;
		slave_sfh_card_credits2_wrap: in std_logic;
		slave_sfh_card_credits3_index: in std_logic_vector(0 downto 0);
		slave_sfh_card_credits3_update: in std_logic;
		slave_sfh_card_credits3_wrap: in std_logic;
		slave_sfh_card_credits4_index: in std_logic_vector(0 downto 0);
		slave_sfh_card_credits4_update: in std_logic;
		slave_sfh_card_credits4_wrap: in std_logic;
		slave_sth_card_credits0_index: in std_logic_vector(0 downto 0);
		slave_sth_card_credits0_update: in std_logic;
		slave_sth_card_credits0_wrap: in std_logic;
		slave_sth_card_credits1_index: in std_logic_vector(0 downto 0);
		slave_sth_card_credits1_update: in std_logic;
		slave_sth_card_credits1_wrap: in std_logic;
		rx_slave_stream_req_sl_en: in std_logic;
		rx_slave_stream_req_sl_wr_en: in std_logic;
		rx_slave_stream_req_sl_wr_addr: in std_logic_vector(63 downto 0);
		rx_slave_stream_req_sl_wr_size: in std_logic_vector(9 downto 0);
		rx_slave_stream_req_sl_wr_data: in std_logic_vector(127 downto 0);
		rx_slave_stream_req_sl_wr_be: in std_logic_vector(15 downto 0);
		rx_slave_stream_req_sl_wr_last: in std_logic;
		rx_slave_stream_req_sl_rd_en: in std_logic;
		rx_slave_stream_req_sl_rd_tc: in std_logic_vector(2 downto 0);
		rx_slave_stream_req_sl_rd_td: in std_logic;
		rx_slave_stream_req_sl_rd_ep: in std_logic;
		rx_slave_stream_req_sl_rd_attr: in std_logic_vector(1 downto 0);
		rx_slave_stream_req_sl_rd_rid: in std_logic_vector(15 downto 0);
		rx_slave_stream_req_sl_rd_tag: in std_logic_vector(7 downto 0);
		rx_slave_stream_req_sl_rd_be: in std_logic_vector(7 downto 0);
		rx_slave_stream_req_sl_rd_addr: in std_logic_vector(63 downto 0);
		rx_slave_stream_req_sl_rd_size: in std_logic_vector(9 downto 0);
		sth_cap_ctrl_0: in std_logic_vector(7 downto 0);
		sfh_cap_ctrl_0: in std_logic_vector(7 downto 0);
		sth_cap: in std_logic_vector(127 downto 0);
		sfh_cap: in std_logic_vector(127 downto 0);
		tx_slave_stream_compl_ack: in std_logic;
		tx_slave_stream_compl_rden: in std_logic;
		tx_slave_stream_compl_done: in std_logic;
		slave_streaming_arbitrated_read_compl_req: in std_logic;
		slave_streaming_arbitrated_read_compl_metadata: in std_logic_vector(30 downto 0);
		slave_streaming_arbitrated_read_compl_addr: in std_logic_vector(6 downto 0);
		slave_streaming_arbitrated_read_compl_size: in std_logic_vector(11 downto 0);
		slave_streaming_arbitrated_read_compl_rem_size: in std_logic_vector(11 downto 0);
		slave_streaming_arbitrated_read_compl_data: in std_logic_vector(127 downto 0);
		mappedreg_reg_addr: out std_logic_vector(23 downto 0);
		mappedreg_reg_byte_en: out std_logic_vector(3 downto 0);
		mappedreg_reg_data_in: out std_logic_vector(31 downto 0);
		mappedreg_reg_write_toggle: out std_logic;
		mappedreg_reg_read_toggle: out std_logic;
		flush: out std_logic;
		leds: out std_logic_vector(1 downto 0);
		soft_reset: out std_logic;
		throttle_limit: out std_logic_vector(10 downto 0);
		pcie_clocking_rst_toggle: out std_logic;
		pcie_clocking_rst_dcm_toggle: out std_logic;
		pcie_clocking_clk: out std_logic;
		pcie_clocking_dcm_multdiv: out std_logic_vector(15 downto 0);
		dma_abort_sfh: out std_logic_vector(31 downto 0);
		dma_abort_sth: out std_logic_vector(31 downto 0);
		dma_ctl_address: out std_logic_vector(8 downto 0);
		dma_ctl_data: out std_logic_vector(63 downto 0);
		dma_ctl_write: out std_logic;
		dma_ctl_byte_en: out std_logic_vector(7 downto 0);
		rx_reg_read_compl_full: out std_logic;
		tx_reg_compl_req: out std_logic;
		tx_reg_compl_tc: out std_logic_vector(2 downto 0);
		tx_reg_compl_td: out std_logic;
		tx_reg_compl_ep: out std_logic;
		tx_reg_compl_attr: out std_logic_vector(1 downto 0);
		tx_reg_compl_rid: out std_logic_vector(15 downto 0);
		tx_reg_compl_tag: out std_logic_vector(7 downto 0);
		tx_reg_compl_addr: out std_logic_vector(12 downto 0);
		tx_reg_compl_data: out std_logic_vector(63 downto 0);
		tx_reg_compl_size: out std_logic_vector(9 downto 0);
		app_int_sts: out std_logic;
		app_msi_req: out std_logic;
		app_msi_num: out std_logic_vector(4 downto 0);
		app_msi_tc: out std_logic_vector(2 downto 0);
		cfg_completer_id: out std_logic_vector(15 downto 0);
		maxring_s_fh: out std_logic_vector(3 downto 0);
		maxring_s_set_highZ_n: out std_logic_vector(3 downto 0);
		maxring_id_fh: out std_logic_vector(3 downto 0);
		maxring_id_set_highZ_n: out std_logic_vector(3 downto 0);
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
		flash_rx_addr: out std_logic;
		flash_tx_d: out std_logic_vector(63 downto 0);
		flash_tx_we: out std_logic;
		ptp_phy_sresetn: out std_logic;
		compl_fifo_flags: out std_logic_vector(1 downto 0);
		control_streams_select: out std_logic_vector(3 downto 0);
		control_streams_reset_toggle: out std_logic;
		compute_reset_n: out std_logic;
		mapped_elements_read: out std_logic;
		mapped_elements_data_in: out std_logic_vector(31 downto 0);
		mapped_elements_fc_in: out std_logic_vector(1 downto 0);
		mapped_elements_write: out std_logic;
		mapped_elements_select_dma: out std_logic;
		mapped_elements_reset: out std_logic;
		local_ifpga_session_key: out std_logic_vector(1 downto 0);
		bar_parse_wr_addr_onehot: out std_logic_vector(255 downto 0);
		bar_parse_wr_data: out std_logic_vector(63 downto 0);
		bar_parse_wr_clk: out std_logic;
		bar_parse_wr_page_sel_onehot: out std_logic_vector(1 downto 0);
		sfa_user_toggle: out std_logic;
		slave_streaming_write_sfh_wren: out std_logic_vector(4 downto 0);
		slave_streaming_write_sfh_write_addr: out std_logic_vector(12 downto 0);
		slave_streaming_write_sfh_write_size: out std_logic_vector(9 downto 0);
		slave_streaming_write_sfh_write_data: out std_logic_vector(127 downto 0);
		slave_streaming_write_sfh_write_be: out std_logic_vector(15 downto 0);
		slave_streaming_write_sfh_write_last: out std_logic;
		slave_streaming_read_sth_rden: out std_logic_vector(1 downto 0);
		slave_streaming_read_sth_read_addr: out std_logic_vector(12 downto 0);
		slave_streaming_read_sth_read_size: out std_logic_vector(9 downto 0);
		slave_streaming_read_sth_read_metadata: out std_logic_vector(30 downto 0);
		slave_streaming_read_sth_read_be: out std_logic_vector(7 downto 0);
		tx_slave_stream_compl_req: out std_logic;
		tx_slave_stream_compl_tc: out std_logic_vector(2 downto 0);
		tx_slave_stream_compl_td: out std_logic;
		tx_slave_stream_compl_ep: out std_logic;
		tx_slave_stream_compl_attr: out std_logic_vector(1 downto 0);
		tx_slave_stream_compl_rid: out std_logic_vector(15 downto 0);
		tx_slave_stream_compl_tag: out std_logic_vector(7 downto 0);
		tx_slave_stream_compl_addr: out std_logic_vector(6 downto 0);
		tx_slave_stream_compl_size: out std_logic_vector(11 downto 0);
		tx_slave_stream_compl_rem_size: out std_logic_vector(11 downto 0);
		tx_slave_stream_compl_data: out std_logic_vector(127 downto 0);
		slave_streaming_arbitrated_read_compl_select: out std_logic;
		slave_streaming_arbitrated_read_compl_rden: out std_logic;
		slave_streaming_arbitrated_read_compl_done: out std_logic
	);
end MAX4PCIeSlaveInterface;

architecture MaxDC of MAX4PCIeSlaveInterface is
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
	component max_SV_pcie_slave is
		generic (
			NUM_STREAMS_TO_HOST : integer;
			NUM_STREAMS_FROM_HOST : integer;
			BAR_MAX_DWORD_ADDR : integer;
			BAR_MAX_PAGES : integer;
			NUM_EVENTS : integer;
			NUM_MAX4N_EVENTS : integer;
			IS_MAX4N : boolean;
			SLAVE_RB_CREDITS_WIDTH : integer
		);
		port (
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			register_out: in std_logic_vector(31 downto 0);
			register_completion_toggle: in std_logic;
			stream_interrupt_toggle: in std_logic_vector(15 downto 0);
			dma_complete_sfh: in std_logic_vector(31 downto 0);
			dma_complete_sth: in std_logic_vector(31 downto 0);
			dma_ctl_read_data: in std_logic_vector(63 downto 0);
			req_interrupt_ctl_valid: in std_logic;
			req_interrupt_ctl_enable_id: in std_logic_vector(31 downto 0);
			reg_data_out: in std_logic_vector(63 downto 0);
			reg_data_wren: in std_logic_vector(7 downto 0);
			reg_data_addr: in std_logic_vector(63 downto 0);
			reg_data_bar0: in std_logic;
			reg_data_bar2: in std_logic;
			rx_reg_read_compl_tc: in std_logic_vector(2 downto 0);
			rx_reg_read_compl_td: in std_logic;
			rx_reg_read_compl_ep: in std_logic;
			rx_reg_read_compl_attr: in std_logic_vector(1 downto 0);
			rx_reg_read_compl_rid: in std_logic_vector(15 downto 0);
			rx_reg_read_compl_tag: in std_logic_vector(7 downto 0);
			rx_reg_read_compl_addr: in std_logic_vector(63 downto 0);
			rx_reg_read_compl_bar2: in std_logic;
			rx_reg_read_compl_req: in std_logic;
			rx_reg_read_compl_size: in std_logic_vector(9 downto 0);
			tx_reg_compl_rden: in std_logic;
			tx_reg_compl_ack: in std_logic;
			app_int_ack: in std_logic;
			app_msi_ack: in std_logic;
			tl_cfg_ctl: in std_logic_vector(31 downto 0);
			tl_cfg_add: in std_logic_vector(3 downto 0);
			ltssmstate: in std_logic_vector(4 downto 0);
			maxring_s_th: in std_logic_vector(3 downto 0);
			maxring_id_th: in std_logic_vector(3 downto 0);
			maxring_prsn_th: in std_logic;
			maxring_type_th: in std_logic_vector(1 downto 0);
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
			qsfp0_i2c_SCL_fb: in std_logic;
			qsfp0_i2c_SDA_fb: in std_logic;
			qsfp0_i2c_ALERT: in std_logic;
			qsfp0_i2c_modprsl: in std_logic;
			qsfp1_i2c_SCL_fb: in std_logic;
			qsfp1_i2c_SDA_fb: in std_logic;
			qsfp1_i2c_ALERT: in std_logic;
			qsfp1_i2c_modprsl: in std_logic;
			qsfp2_i2c_SCL_fb: in std_logic;
			qsfp2_i2c_SDA_fb: in std_logic;
			qsfp2_i2c_ALERT: in std_logic;
			qsfp2_i2c_modprsl: in std_logic;
			qsfp3_i2c_SCL_fb: in std_logic;
			qsfp3_i2c_SDA_fb: in std_logic;
			qsfp3_i2c_ALERT: in std_logic;
			qsfp3_i2c_modprsl: in std_logic;
			qsfp4_i2c_SCL_fb: in std_logic;
			qsfp4_i2c_SDA_fb: in std_logic;
			qsfp4_i2c_ALERT: in std_logic;
			qsfp4_i2c_modprsl: in std_logic;
			qsfp5_i2c_SCL_fb: in std_logic;
			qsfp5_i2c_SDA_fb: in std_logic;
			qsfp5_i2c_ALERT: in std_logic;
			qsfp5_i2c_modprsl: in std_logic;
			qsfp6_i2c_SCL_fb: in std_logic;
			qsfp6_i2c_SDA_fb: in std_logic;
			qsfp6_i2c_ALERT: in std_logic;
			qsfp6_i2c_modprsl: in std_logic;
			qsfp7_i2c_SCL_fb: in std_logic;
			qsfp7_i2c_SDA_fb: in std_logic;
			qsfp7_i2c_ALERT: in std_logic;
			qsfp7_i2c_modprsl: in std_logic;
			ptp_phy_mdio_scl_to_host: in std_logic;
			ptp_phy_mdio_sda_to_host: in std_logic;
			ptp_phy_mdio_event_to_host: in std_logic;
			flash_rx_d: in std_logic_vector(63 downto 0);
			capabilities: in std_logic_vector(31 downto 0);
			pcie_capabilities: in std_logic_vector(15 downto 0);
			slave_streaming_buf_cap: in std_logic_vector(31 downto 0);
			bar_status_tx_fifo_empty: in std_logic;
			sfa_user_toggle_ack: in std_logic;
			slave_sfh_card_credits_index: in std_logic_vector(4 downto 0);
			slave_sfh_card_credits_wrap: in std_logic_vector(4 downto 0);
			slave_sfh_card_credits_update: in std_logic_vector(4 downto 0);
			slave_sth_card_credits_index: in std_logic_vector(1 downto 0);
			slave_sth_card_credits_wrap: in std_logic_vector(1 downto 0);
			slave_sth_card_credits_update: in std_logic_vector(1 downto 0);
			sfh_cap: in std_logic_vector(127 downto 0);
			sth_cap: in std_logic_vector(127 downto 0);
			sfh_cap_ctrl_0: in std_logic_vector(7 downto 0);
			sth_cap_ctrl_0: in std_logic_vector(7 downto 0);
			mapped_elements_version: in std_logic_vector(31 downto 0);
			mapped_elements_empty: in std_logic;
			mapped_elements_fc_type: in std_logic_vector(1 downto 0);
			mapped_elements_toggle: in std_logic;
			mapped_elements_data: in std_logic_vector(31 downto 0);
			mapped_elements_fill: in std_logic_vector(9 downto 0);
			register_in: out std_logic_vector(31 downto 0);
			register_addr: out std_logic_vector(31 downto 0);
			control_toggle: out std_logic_vector(4 downto 0);
			dma_abort_sfh: out std_logic_vector(31 downto 0);
			dma_abort_sth: out std_logic_vector(31 downto 0);
			dma_ctl_address: out std_logic_vector(8 downto 0);
			dma_ctl_data: out std_logic_vector(63 downto 0);
			dma_ctl_write: out std_logic;
			dma_ctl_byte_en: out std_logic_vector(7 downto 0);
			rx_reg_read_compl_full: out std_logic;
			rx_reg_read_compl_overflow: out std_logic;
			rx_reg_read_compl_underflow: out std_logic;
			tx_reg_compl_req: out std_logic;
			tx_reg_compl_tc: out std_logic_vector(2 downto 0);
			tx_reg_compl_td: out std_logic;
			tx_reg_compl_ep: out std_logic;
			tx_reg_compl_attr: out std_logic_vector(1 downto 0);
			tx_reg_compl_rid: out std_logic_vector(15 downto 0);
			tx_reg_compl_tag: out std_logic_vector(7 downto 0);
			tx_reg_compl_addr: out std_logic_vector(12 downto 0);
			tx_reg_compl_data: out std_logic_vector(63 downto 0);
			tx_reg_compl_size: out std_logic_vector(9 downto 0);
			app_int_sts: out std_logic;
			app_msi_req: out std_logic;
			app_msi_num: out std_logic_vector(4 downto 0);
			app_msi_tc: out std_logic_vector(2 downto 0);
			cfg_completer_id: out std_logic_vector(15 downto 0);
			maxring_s_fh: out std_logic_vector(3 downto 0);
			maxring_s_set_highZ_n: out std_logic_vector(3 downto 0);
			maxring_id_fh: out std_logic_vector(3 downto 0);
			maxring_id_set_highZ_n: out std_logic_vector(3 downto 0);
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
			qsfp0_i2c_SCL_drv: out std_logic;
			qsfp0_i2c_SDA_drv: out std_logic;
			qsfp0_i2c_lpmode: out std_logic;
			qsfp0_i2c_modsell: out std_logic;
			qsfp0_i2c_resetl: out std_logic;
			qsfp1_i2c_SCL_drv: out std_logic;
			qsfp1_i2c_SDA_drv: out std_logic;
			qsfp1_i2c_lpmode: out std_logic;
			qsfp1_i2c_modsell: out std_logic;
			qsfp1_i2c_resetl: out std_logic;
			qsfp2_i2c_SCL_drv: out std_logic;
			qsfp2_i2c_SDA_drv: out std_logic;
			qsfp2_i2c_lpmode: out std_logic;
			qsfp2_i2c_modsell: out std_logic;
			qsfp2_i2c_resetl: out std_logic;
			qsfp3_i2c_SCL_drv: out std_logic;
			qsfp3_i2c_SDA_drv: out std_logic;
			qsfp3_i2c_lpmode: out std_logic;
			qsfp3_i2c_modsell: out std_logic;
			qsfp3_i2c_resetl: out std_logic;
			qsfp4_i2c_SCL_drv: out std_logic;
			qsfp4_i2c_SDA_drv: out std_logic;
			qsfp4_i2c_lpmode: out std_logic;
			qsfp4_i2c_modsell: out std_logic;
			qsfp4_i2c_resetl: out std_logic;
			qsfp5_i2c_SCL_drv: out std_logic;
			qsfp5_i2c_SDA_drv: out std_logic;
			qsfp5_i2c_lpmode: out std_logic;
			qsfp5_i2c_modsell: out std_logic;
			qsfp5_i2c_resetl: out std_logic;
			qsfp6_i2c_SCL_drv: out std_logic;
			qsfp6_i2c_SDA_drv: out std_logic;
			qsfp6_i2c_lpmode: out std_logic;
			qsfp6_i2c_modsell: out std_logic;
			qsfp6_i2c_resetl: out std_logic;
			qsfp7_i2c_SCL_drv: out std_logic;
			qsfp7_i2c_SDA_drv: out std_logic;
			qsfp7_i2c_lpmode: out std_logic;
			qsfp7_i2c_modsell: out std_logic;
			qsfp7_i2c_resetl: out std_logic;
			ptp_phy_mdio_scl_from_host: out std_logic;
			ptp_phy_mdio_sda_from_host: out std_logic;
			ptp_phy_sresetn: out std_logic;
			flash_rx_addr: out std_logic;
			flash_tx_d: out std_logic_vector(63 downto 0);
			flash_tx_we: out std_logic;
			leds: out std_logic_vector(1 downto 0);
			soft_reset: out std_logic;
			throttle_limit: out std_logic_vector(10 downto 0);
			dcm_multdiv: out std_logic_vector(15 downto 0);
			control_streams_select: out std_logic_vector(3 downto 0);
			control_streams_reset_toggle: out std_logic;
			bar_parse_wr_addr_onehot: out std_logic_vector(255 downto 0);
			bar_parse_wr_data: out std_logic_vector(63 downto 0);
			bar_parse_wr_clk: out std_logic;
			bar_parse_wr_page_sel_onehot: out std_logic_vector(1 downto 0);
			sfa_user_toggle: out std_logic;
			compute_reset_n: out std_logic;
			mapped_elements_read: out std_logic;
			mapped_elements_data_in: out std_logic_vector(31 downto 0);
			mapped_elements_fc_in: out std_logic_vector(1 downto 0);
			mapped_elements_write: out std_logic;
			mapped_elements_select_dma: out std_logic;
			mapped_elements_reset: out std_logic;
			local_ifpga_session_key: out std_logic_vector(1 downto 0)
		);
	end component;
	component max_pcie_slave_req_dispatcher is
		generic (
			NUM_STREAMS_TO_HOST : integer;
			NUM_STREAMS_FROM_HOST : integer;
			NUM_STREAM_BIT_WIDTH : integer;
			STREAM_ADDR_SEGMENT_BIT_WIDTH : integer
		);
		port (
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			sl_en: in std_logic;
			sl_wr_en: in std_logic;
			sl_wr_addr: in std_logic_vector(63 downto 0);
			sl_wr_size: in std_logic_vector(9 downto 0);
			sl_wr_data: in std_logic_vector(127 downto 0);
			sl_wr_be: in std_logic_vector(15 downto 0);
			sl_wr_last: in std_logic;
			sl_rd_en: in std_logic;
			sl_rd_tc: in std_logic_vector(2 downto 0);
			sl_rd_td: in std_logic;
			sl_rd_ep: in std_logic;
			sl_rd_attr: in std_logic_vector(1 downto 0);
			sl_rd_rid: in std_logic_vector(15 downto 0);
			sl_rd_tag: in std_logic_vector(7 downto 0);
			sl_rd_be: in std_logic_vector(7 downto 0);
			sl_rd_addr: in std_logic_vector(63 downto 0);
			sl_rd_size: in std_logic_vector(9 downto 0);
			sfh_wren: out std_logic_vector(4 downto 0);
			sfh_write_addr: out std_logic_vector(12 downto 0);
			sfh_write_size: out std_logic_vector(9 downto 0);
			sfh_write_data: out std_logic_vector(127 downto 0);
			sfh_write_be: out std_logic_vector(15 downto 0);
			sfh_write_last: out std_logic;
			sth_rden: out std_logic_vector(1 downto 0);
			sth_read_addr: out std_logic_vector(12 downto 0);
			sth_read_size: out std_logic_vector(9 downto 0);
			sth_read_metadata: out std_logic_vector(30 downto 0);
			sth_read_be: out std_logic_vector(7 downto 0)
		);
	end component;
	
	-- Signal declarations
	
	signal pcieslaveinterface_imp_register_in : std_logic_vector(31 downto 0);
	signal pcieslaveinterface_imp_register_addr : std_logic_vector(31 downto 0);
	signal pcieslaveinterface_imp_control_toggle : std_logic_vector(4 downto 0);
	signal pcieslaveinterface_imp_dma_abort_sfh : std_logic_vector(31 downto 0);
	signal pcieslaveinterface_imp_dma_abort_sth : std_logic_vector(31 downto 0);
	signal pcieslaveinterface_imp_dma_ctl_address : std_logic_vector(8 downto 0);
	signal pcieslaveinterface_imp_dma_ctl_data : std_logic_vector(63 downto 0);
	signal pcieslaveinterface_imp_dma_ctl_write : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_dma_ctl_byte_en : std_logic_vector(7 downto 0);
	signal pcieslaveinterface_imp_rx_reg_read_compl_full : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_rx_reg_read_compl_overflow : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_rx_reg_read_compl_underflow : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_tx_reg_compl_req : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_tx_reg_compl_tc : std_logic_vector(2 downto 0);
	signal pcieslaveinterface_imp_tx_reg_compl_td : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_tx_reg_compl_ep : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_tx_reg_compl_attr : std_logic_vector(1 downto 0);
	signal pcieslaveinterface_imp_tx_reg_compl_rid : std_logic_vector(15 downto 0);
	signal pcieslaveinterface_imp_tx_reg_compl_tag : std_logic_vector(7 downto 0);
	signal pcieslaveinterface_imp_tx_reg_compl_addr : std_logic_vector(12 downto 0);
	signal pcieslaveinterface_imp_tx_reg_compl_data : std_logic_vector(63 downto 0);
	signal pcieslaveinterface_imp_tx_reg_compl_size : std_logic_vector(9 downto 0);
	signal pcieslaveinterface_imp_app_int_sts : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_app_msi_req : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_app_msi_num : std_logic_vector(4 downto 0);
	signal pcieslaveinterface_imp_app_msi_tc : std_logic_vector(2 downto 0);
	signal pcieslaveinterface_imp_cfg_completer_id : std_logic_vector(15 downto 0);
	signal pcieslaveinterface_imp_maxring_s_fh : std_logic_vector(3 downto 0);
	signal pcieslaveinterface_imp_maxring_s_set_highz_n : std_logic_vector(3 downto 0);
	signal pcieslaveinterface_imp_maxring_id_fh : std_logic_vector(3 downto 0);
	signal pcieslaveinterface_imp_maxring_id_set_highz_n : std_logic_vector(3 downto 0);
	signal pcieslaveinterface_imp_i2c_left_dimm_scl_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_i2c_left_dimm_sda_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_i2c_right_dimm_scl_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_i2c_right_dimm_sda_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_i2c_aux_scl_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_i2c_aux_sda_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_pmbus_scl_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_pmbus_sda_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_host_event_ack : std_logic_vector(96 downto 0);
	signal pcieslaveinterface_imp_config_reconfig_trigger : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp0_i2c_scl_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp0_i2c_sda_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp0_i2c_lpmode : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp0_i2c_modsell : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp0_i2c_resetl : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp1_i2c_scl_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp1_i2c_sda_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp1_i2c_lpmode : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp1_i2c_modsell : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp1_i2c_resetl : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp2_i2c_scl_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp2_i2c_sda_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp2_i2c_lpmode : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp2_i2c_modsell : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp2_i2c_resetl : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp3_i2c_scl_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp3_i2c_sda_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp3_i2c_lpmode : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp3_i2c_modsell : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp3_i2c_resetl : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp4_i2c_scl_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp4_i2c_sda_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp4_i2c_lpmode : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp4_i2c_modsell : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp4_i2c_resetl : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp5_i2c_scl_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp5_i2c_sda_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp5_i2c_lpmode : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp5_i2c_modsell : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp5_i2c_resetl : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp6_i2c_scl_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp6_i2c_sda_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp6_i2c_lpmode : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp6_i2c_modsell : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp6_i2c_resetl : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp7_i2c_scl_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp7_i2c_sda_drv : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp7_i2c_lpmode : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp7_i2c_modsell : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_qsfp7_i2c_resetl : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_ptp_phy_mdio_scl_from_host : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_ptp_phy_mdio_sda_from_host : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_ptp_phy_sresetn : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_flash_rx_addr : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_flash_tx_d : std_logic_vector(63 downto 0);
	signal pcieslaveinterface_imp_flash_tx_we : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_leds : std_logic_vector(1 downto 0);
	signal pcieslaveinterface_imp_soft_reset : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_throttle_limit : std_logic_vector(10 downto 0);
	signal pcieslaveinterface_imp_dcm_multdiv : std_logic_vector(15 downto 0);
	signal pcieslaveinterface_imp_control_streams_select : std_logic_vector(3 downto 0);
	signal pcieslaveinterface_imp_control_streams_reset_toggle : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_bar_parse_wr_addr_onehot : std_logic_vector(255 downto 0);
	signal pcieslaveinterface_imp_bar_parse_wr_data : std_logic_vector(63 downto 0);
	signal pcieslaveinterface_imp_bar_parse_wr_clk : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_bar_parse_wr_page_sel_onehot : std_logic_vector(1 downto 0);
	signal pcieslaveinterface_imp_sfa_user_toggle : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_compute_reset_n : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_mapped_elements_read : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_mapped_elements_data_in : std_logic_vector(31 downto 0);
	signal pcieslaveinterface_imp_mapped_elements_fc_in : std_logic_vector(1 downto 0);
	signal pcieslaveinterface_imp_mapped_elements_write : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_mapped_elements_select_dma : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_mapped_elements_reset : std_logic_vector(0 downto 0);
	signal pcieslaveinterface_imp_local_ifpga_session_key : std_logic_vector(1 downto 0);
	signal pcieslavereqdispatcher_imp_sfh_wren : std_logic_vector(4 downto 0);
	signal pcieslavereqdispatcher_imp_sfh_write_addr : std_logic_vector(12 downto 0);
	signal pcieslavereqdispatcher_imp_sfh_write_size : std_logic_vector(9 downto 0);
	signal pcieslavereqdispatcher_imp_sfh_write_data : std_logic_vector(127 downto 0);
	signal pcieslavereqdispatcher_imp_sfh_write_be : std_logic_vector(15 downto 0);
	signal pcieslavereqdispatcher_imp_sfh_write_last : std_logic_vector(0 downto 0);
	signal pcieslavereqdispatcher_imp_sth_rden : std_logic_vector(1 downto 0);
	signal pcieslavereqdispatcher_imp_sth_read_addr : std_logic_vector(12 downto 0);
	signal pcieslavereqdispatcher_imp_sth_read_size : std_logic_vector(9 downto 0);
	signal pcieslavereqdispatcher_imp_sth_read_metadata : std_logic_vector(30 downto 0);
	signal pcieslavereqdispatcher_imp_sth_read_be : std_logic_vector(7 downto 0);
	signal pcieslaveinterface_imp_capabilities1 : std_logic_vector(31 downto 0);
	signal cat_ln136_max4pcieslaveinterface : std_logic_vector(7 downto 0);
	signal cat_ln140_max4pcieslaveinterface : std_logic_vector(31 downto 0);
	signal pcieslaveinterface_imp_slave_sfh_card_credits_index1 : std_logic_vector(4 downto 0);
	signal cat_ln294_max4pcieslaveinterface : std_logic_vector(4 downto 0);
	signal pcieslaveinterface_imp_slave_sfh_card_credits_wrap1 : std_logic_vector(4 downto 0);
	signal cat_ln295_max4pcieslaveinterface : std_logic_vector(4 downto 0);
	signal pcieslaveinterface_imp_slave_sfh_card_credits_update1 : std_logic_vector(4 downto 0);
	signal cat_ln296_max4pcieslaveinterface : std_logic_vector(4 downto 0);
	signal pcieslaveinterface_imp_slave_sth_card_credits_index1 : std_logic_vector(1 downto 0);
	signal cat_ln309_max4pcieslaveinterface : std_logic_vector(1 downto 0);
	signal pcieslaveinterface_imp_slave_sth_card_credits_wrap1 : std_logic_vector(1 downto 0);
	signal cat_ln310_max4pcieslaveinterface : std_logic_vector(1 downto 0);
	signal pcieslaveinterface_imp_slave_sth_card_credits_update1 : std_logic_vector(1 downto 0);
	signal cat_ln311_max4pcieslaveinterface : std_logic_vector(1 downto 0);
	signal cat_ln218_max4pcieslaveinterface : std_logic_vector(1 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	cat_ln136_max4pcieslaveinterface<=("0001" & "0100");
	cat_ln140_max4pcieslaveinterface<=("000000000000000000000000" & cat_ln136_max4pcieslaveinterface);
	pcieslaveinterface_imp_capabilities1 <= cat_ln140_max4pcieslaveinterface;
	cat_ln294_max4pcieslaveinterface<=(slave_sfh_card_credits4_index & slave_sfh_card_credits3_index & slave_sfh_card_credits2_index & slave_sfh_card_credits1_index & slave_sfh_card_credits0_index);
	pcieslaveinterface_imp_slave_sfh_card_credits_index1 <= cat_ln294_max4pcieslaveinterface;
	cat_ln295_max4pcieslaveinterface<=(bit_to_vec(slave_sfh_card_credits4_wrap) & bit_to_vec(slave_sfh_card_credits3_wrap) & bit_to_vec(slave_sfh_card_credits2_wrap) & bit_to_vec(slave_sfh_card_credits1_wrap) & bit_to_vec(slave_sfh_card_credits0_wrap));
	pcieslaveinterface_imp_slave_sfh_card_credits_wrap1 <= cat_ln295_max4pcieslaveinterface;
	cat_ln296_max4pcieslaveinterface<=(bit_to_vec(slave_sfh_card_credits4_update) & bit_to_vec(slave_sfh_card_credits3_update) & bit_to_vec(slave_sfh_card_credits2_update) & bit_to_vec(slave_sfh_card_credits1_update) & bit_to_vec(slave_sfh_card_credits0_update));
	pcieslaveinterface_imp_slave_sfh_card_credits_update1 <= cat_ln296_max4pcieslaveinterface;
	cat_ln309_max4pcieslaveinterface<=(slave_sth_card_credits1_index & slave_sth_card_credits0_index);
	pcieslaveinterface_imp_slave_sth_card_credits_index1 <= cat_ln309_max4pcieslaveinterface;
	cat_ln310_max4pcieslaveinterface<=(bit_to_vec(slave_sth_card_credits1_wrap) & bit_to_vec(slave_sth_card_credits0_wrap));
	pcieslaveinterface_imp_slave_sth_card_credits_wrap1 <= cat_ln310_max4pcieslaveinterface;
	cat_ln311_max4pcieslaveinterface<=(bit_to_vec(slave_sth_card_credits1_update) & bit_to_vec(slave_sth_card_credits0_update));
	pcieslaveinterface_imp_slave_sth_card_credits_update1 <= cat_ln311_max4pcieslaveinterface;
	cat_ln218_max4pcieslaveinterface<=(pcieslaveinterface_imp_rx_reg_read_compl_overflow & pcieslaveinterface_imp_rx_reg_read_compl_underflow);
	mappedreg_reg_addr <= slice(pcieslaveinterface_imp_register_addr, 0, 24);
	mappedreg_reg_byte_en <= slice(pcieslaveinterface_imp_dcm_multdiv, 0, 4);
	mappedreg_reg_data_in <= pcieslaveinterface_imp_register_in;
	mappedreg_reg_write_toggle <= vec_to_bit(slice(pcieslaveinterface_imp_control_toggle, 4, 1));
	mappedreg_reg_read_toggle <= vec_to_bit(slice(pcieslaveinterface_imp_control_toggle, 3, 1));
	flush <= vec_to_bit(slice(pcieslaveinterface_imp_control_toggle, 1, 1));
	leds <= pcieslaveinterface_imp_leds;
	soft_reset <= vec_to_bit(pcieslaveinterface_imp_soft_reset);
	throttle_limit <= pcieslaveinterface_imp_throttle_limit;
	pcie_clocking_rst_toggle <= vec_to_bit(slice(pcieslaveinterface_imp_control_toggle, 0, 1));
	pcie_clocking_rst_dcm_toggle <= vec_to_bit("0");
	pcie_clocking_clk <= vec_to_bit(bit_to_vec(clk_pcie));
	pcie_clocking_dcm_multdiv <= pcieslaveinterface_imp_dcm_multdiv;
	dma_abort_sfh <= pcieslaveinterface_imp_dma_abort_sfh;
	dma_abort_sth <= pcieslaveinterface_imp_dma_abort_sth;
	dma_ctl_address <= pcieslaveinterface_imp_dma_ctl_address;
	dma_ctl_data <= pcieslaveinterface_imp_dma_ctl_data;
	dma_ctl_write <= vec_to_bit(pcieslaveinterface_imp_dma_ctl_write);
	dma_ctl_byte_en <= pcieslaveinterface_imp_dma_ctl_byte_en;
	rx_reg_read_compl_full <= vec_to_bit(pcieslaveinterface_imp_rx_reg_read_compl_full);
	tx_reg_compl_req <= vec_to_bit(pcieslaveinterface_imp_tx_reg_compl_req);
	tx_reg_compl_tc <= pcieslaveinterface_imp_tx_reg_compl_tc;
	tx_reg_compl_td <= vec_to_bit(pcieslaveinterface_imp_tx_reg_compl_td);
	tx_reg_compl_ep <= vec_to_bit(pcieslaveinterface_imp_tx_reg_compl_ep);
	tx_reg_compl_attr <= pcieslaveinterface_imp_tx_reg_compl_attr;
	tx_reg_compl_rid <= pcieslaveinterface_imp_tx_reg_compl_rid;
	tx_reg_compl_tag <= pcieslaveinterface_imp_tx_reg_compl_tag;
	tx_reg_compl_addr <= pcieslaveinterface_imp_tx_reg_compl_addr;
	tx_reg_compl_data <= pcieslaveinterface_imp_tx_reg_compl_data;
	tx_reg_compl_size <= pcieslaveinterface_imp_tx_reg_compl_size;
	app_int_sts <= vec_to_bit(pcieslaveinterface_imp_app_int_sts);
	app_msi_req <= vec_to_bit(pcieslaveinterface_imp_app_msi_req);
	app_msi_num <= pcieslaveinterface_imp_app_msi_num;
	app_msi_tc <= pcieslaveinterface_imp_app_msi_tc;
	cfg_completer_id <= pcieslaveinterface_imp_cfg_completer_id;
	maxring_s_fh <= pcieslaveinterface_imp_maxring_s_fh;
	maxring_s_set_highZ_n <= pcieslaveinterface_imp_maxring_s_set_highz_n;
	maxring_id_fh <= pcieslaveinterface_imp_maxring_id_fh;
	maxring_id_set_highZ_n <= pcieslaveinterface_imp_maxring_id_set_highz_n;
	i2c_left_dimm_SCL_drv <= vec_to_bit(pcieslaveinterface_imp_i2c_left_dimm_scl_drv);
	i2c_left_dimm_SDA_drv <= vec_to_bit(pcieslaveinterface_imp_i2c_left_dimm_sda_drv);
	i2c_right_dimm_SCL_drv <= vec_to_bit(pcieslaveinterface_imp_i2c_right_dimm_scl_drv);
	i2c_right_dimm_SDA_drv <= vec_to_bit(pcieslaveinterface_imp_i2c_right_dimm_sda_drv);
	i2c_aux_SCL_drv <= vec_to_bit(pcieslaveinterface_imp_i2c_aux_scl_drv);
	i2c_aux_SDA_drv <= vec_to_bit(pcieslaveinterface_imp_i2c_aux_sda_drv);
	pmbus_SCL_drv <= vec_to_bit(pcieslaveinterface_imp_pmbus_scl_drv);
	pmbus_SDA_drv <= vec_to_bit(pcieslaveinterface_imp_pmbus_sda_drv);
	host_event_ack <= pcieslaveinterface_imp_host_event_ack;
	config_Reconfig_Trigger <= vec_to_bit(pcieslaveinterface_imp_config_reconfig_trigger);
	flash_rx_addr <= vec_to_bit(pcieslaveinterface_imp_flash_rx_addr);
	flash_tx_d <= pcieslaveinterface_imp_flash_tx_d;
	flash_tx_we <= vec_to_bit(pcieslaveinterface_imp_flash_tx_we);
	ptp_phy_sresetn <= vec_to_bit(pcieslaveinterface_imp_ptp_phy_sresetn);
	compl_fifo_flags <= cat_ln218_max4pcieslaveinterface;
	control_streams_select <= pcieslaveinterface_imp_control_streams_select;
	control_streams_reset_toggle <= vec_to_bit(pcieslaveinterface_imp_control_streams_reset_toggle);
	compute_reset_n <= vec_to_bit(pcieslaveinterface_imp_compute_reset_n);
	mapped_elements_read <= vec_to_bit(pcieslaveinterface_imp_mapped_elements_read);
	mapped_elements_data_in <= pcieslaveinterface_imp_mapped_elements_data_in;
	mapped_elements_fc_in <= pcieslaveinterface_imp_mapped_elements_fc_in;
	mapped_elements_write <= vec_to_bit(pcieslaveinterface_imp_mapped_elements_write);
	mapped_elements_select_dma <= vec_to_bit(pcieslaveinterface_imp_mapped_elements_select_dma);
	mapped_elements_reset <= vec_to_bit(pcieslaveinterface_imp_mapped_elements_reset);
	local_ifpga_session_key <= pcieslaveinterface_imp_local_ifpga_session_key;
	bar_parse_wr_addr_onehot <= pcieslaveinterface_imp_bar_parse_wr_addr_onehot;
	bar_parse_wr_data <= pcieslaveinterface_imp_bar_parse_wr_data;
	bar_parse_wr_clk <= vec_to_bit(pcieslaveinterface_imp_bar_parse_wr_clk);
	bar_parse_wr_page_sel_onehot <= pcieslaveinterface_imp_bar_parse_wr_page_sel_onehot;
	sfa_user_toggle <= vec_to_bit(pcieslaveinterface_imp_sfa_user_toggle);
	slave_streaming_write_sfh_wren <= pcieslavereqdispatcher_imp_sfh_wren;
	slave_streaming_write_sfh_write_addr <= pcieslavereqdispatcher_imp_sfh_write_addr;
	slave_streaming_write_sfh_write_size <= pcieslavereqdispatcher_imp_sfh_write_size;
	slave_streaming_write_sfh_write_data <= pcieslavereqdispatcher_imp_sfh_write_data;
	slave_streaming_write_sfh_write_be <= pcieslavereqdispatcher_imp_sfh_write_be;
	slave_streaming_write_sfh_write_last <= vec_to_bit(pcieslavereqdispatcher_imp_sfh_write_last);
	slave_streaming_read_sth_rden <= pcieslavereqdispatcher_imp_sth_rden;
	slave_streaming_read_sth_read_addr <= pcieslavereqdispatcher_imp_sth_read_addr;
	slave_streaming_read_sth_read_size <= pcieslavereqdispatcher_imp_sth_read_size;
	slave_streaming_read_sth_read_metadata <= pcieslavereqdispatcher_imp_sth_read_metadata;
	slave_streaming_read_sth_read_be <= pcieslavereqdispatcher_imp_sth_read_be;
	tx_slave_stream_compl_req <= vec_to_bit(bit_to_vec(slave_streaming_arbitrated_read_compl_req));
	tx_slave_stream_compl_tc <= slice(slave_streaming_arbitrated_read_compl_metadata, 0, 3);
	tx_slave_stream_compl_td <= vec_to_bit(slice(slave_streaming_arbitrated_read_compl_metadata, 3, 1));
	tx_slave_stream_compl_ep <= vec_to_bit(slice(slave_streaming_arbitrated_read_compl_metadata, 4, 1));
	tx_slave_stream_compl_attr <= slice(slave_streaming_arbitrated_read_compl_metadata, 5, 2);
	tx_slave_stream_compl_rid <= slice(slave_streaming_arbitrated_read_compl_metadata, 7, 16);
	tx_slave_stream_compl_tag <= slice(slave_streaming_arbitrated_read_compl_metadata, 23, 8);
	tx_slave_stream_compl_addr <= slave_streaming_arbitrated_read_compl_addr;
	tx_slave_stream_compl_size <= slave_streaming_arbitrated_read_compl_size;
	tx_slave_stream_compl_rem_size <= slave_streaming_arbitrated_read_compl_rem_size;
	tx_slave_stream_compl_data <= slave_streaming_arbitrated_read_compl_data;
	slave_streaming_arbitrated_read_compl_select <= vec_to_bit(bit_to_vec(tx_slave_stream_compl_ack));
	slave_streaming_arbitrated_read_compl_rden <= vec_to_bit(bit_to_vec(tx_slave_stream_compl_rden));
	slave_streaming_arbitrated_read_compl_done <= vec_to_bit(bit_to_vec(tx_slave_stream_compl_done));
	
	-- Register processes
	
	
	-- Entity instances
	
	PCIeSlaveInterface_imp : max_SV_pcie_slave
		generic map (
			NUM_STREAMS_TO_HOST => 1,
			NUM_STREAMS_FROM_HOST => 4,
			BAR_MAX_DWORD_ADDR => 256,
			BAR_MAX_PAGES => 2,
			NUM_EVENTS => 8,
			NUM_MAX4N_EVENTS => 89,
			IS_MAX4N => false,
			SLAVE_RB_CREDITS_WIDTH => 1
		)
		port map (
			register_in => pcieslaveinterface_imp_register_in, -- 32 bits (out)
			register_addr => pcieslaveinterface_imp_register_addr, -- 32 bits (out)
			control_toggle => pcieslaveinterface_imp_control_toggle, -- 5 bits (out)
			dma_abort_sfh => pcieslaveinterface_imp_dma_abort_sfh, -- 32 bits (out)
			dma_abort_sth => pcieslaveinterface_imp_dma_abort_sth, -- 32 bits (out)
			dma_ctl_address => pcieslaveinterface_imp_dma_ctl_address, -- 9 bits (out)
			dma_ctl_data => pcieslaveinterface_imp_dma_ctl_data, -- 64 bits (out)
			dma_ctl_write => pcieslaveinterface_imp_dma_ctl_write(0), -- 1 bits (out)
			dma_ctl_byte_en => pcieslaveinterface_imp_dma_ctl_byte_en, -- 8 bits (out)
			rx_reg_read_compl_full => pcieslaveinterface_imp_rx_reg_read_compl_full(0), -- 1 bits (out)
			rx_reg_read_compl_overflow => pcieslaveinterface_imp_rx_reg_read_compl_overflow(0), -- 1 bits (out)
			rx_reg_read_compl_underflow => pcieslaveinterface_imp_rx_reg_read_compl_underflow(0), -- 1 bits (out)
			tx_reg_compl_req => pcieslaveinterface_imp_tx_reg_compl_req(0), -- 1 bits (out)
			tx_reg_compl_tc => pcieslaveinterface_imp_tx_reg_compl_tc, -- 3 bits (out)
			tx_reg_compl_td => pcieslaveinterface_imp_tx_reg_compl_td(0), -- 1 bits (out)
			tx_reg_compl_ep => pcieslaveinterface_imp_tx_reg_compl_ep(0), -- 1 bits (out)
			tx_reg_compl_attr => pcieslaveinterface_imp_tx_reg_compl_attr, -- 2 bits (out)
			tx_reg_compl_rid => pcieslaveinterface_imp_tx_reg_compl_rid, -- 16 bits (out)
			tx_reg_compl_tag => pcieslaveinterface_imp_tx_reg_compl_tag, -- 8 bits (out)
			tx_reg_compl_addr => pcieslaveinterface_imp_tx_reg_compl_addr, -- 13 bits (out)
			tx_reg_compl_data => pcieslaveinterface_imp_tx_reg_compl_data, -- 64 bits (out)
			tx_reg_compl_size => pcieslaveinterface_imp_tx_reg_compl_size, -- 10 bits (out)
			app_int_sts => pcieslaveinterface_imp_app_int_sts(0), -- 1 bits (out)
			app_msi_req => pcieslaveinterface_imp_app_msi_req(0), -- 1 bits (out)
			app_msi_num => pcieslaveinterface_imp_app_msi_num, -- 5 bits (out)
			app_msi_tc => pcieslaveinterface_imp_app_msi_tc, -- 3 bits (out)
			cfg_completer_id => pcieslaveinterface_imp_cfg_completer_id, -- 16 bits (out)
			maxring_s_fh => pcieslaveinterface_imp_maxring_s_fh, -- 4 bits (out)
			maxring_s_set_highZ_n => pcieslaveinterface_imp_maxring_s_set_highz_n, -- 4 bits (out)
			maxring_id_fh => pcieslaveinterface_imp_maxring_id_fh, -- 4 bits (out)
			maxring_id_set_highZ_n => pcieslaveinterface_imp_maxring_id_set_highz_n, -- 4 bits (out)
			i2c_left_dimm_SCL_drv => pcieslaveinterface_imp_i2c_left_dimm_scl_drv(0), -- 1 bits (out)
			i2c_left_dimm_SDA_drv => pcieslaveinterface_imp_i2c_left_dimm_sda_drv(0), -- 1 bits (out)
			i2c_right_dimm_SCL_drv => pcieslaveinterface_imp_i2c_right_dimm_scl_drv(0), -- 1 bits (out)
			i2c_right_dimm_SDA_drv => pcieslaveinterface_imp_i2c_right_dimm_sda_drv(0), -- 1 bits (out)
			i2c_aux_SCL_drv => pcieslaveinterface_imp_i2c_aux_scl_drv(0), -- 1 bits (out)
			i2c_aux_SDA_drv => pcieslaveinterface_imp_i2c_aux_sda_drv(0), -- 1 bits (out)
			pmbus_SCL_drv => pcieslaveinterface_imp_pmbus_scl_drv(0), -- 1 bits (out)
			pmbus_SDA_drv => pcieslaveinterface_imp_pmbus_sda_drv(0), -- 1 bits (out)
			host_event_ack => pcieslaveinterface_imp_host_event_ack, -- 97 bits (out)
			config_Reconfig_Trigger => pcieslaveinterface_imp_config_reconfig_trigger(0), -- 1 bits (out)
			qsfp0_i2c_SCL_drv => pcieslaveinterface_imp_qsfp0_i2c_scl_drv(0), -- 1 bits (out)
			qsfp0_i2c_SDA_drv => pcieslaveinterface_imp_qsfp0_i2c_sda_drv(0), -- 1 bits (out)
			qsfp0_i2c_lpmode => pcieslaveinterface_imp_qsfp0_i2c_lpmode(0), -- 1 bits (out)
			qsfp0_i2c_modsell => pcieslaveinterface_imp_qsfp0_i2c_modsell(0), -- 1 bits (out)
			qsfp0_i2c_resetl => pcieslaveinterface_imp_qsfp0_i2c_resetl(0), -- 1 bits (out)
			qsfp1_i2c_SCL_drv => pcieslaveinterface_imp_qsfp1_i2c_scl_drv(0), -- 1 bits (out)
			qsfp1_i2c_SDA_drv => pcieslaveinterface_imp_qsfp1_i2c_sda_drv(0), -- 1 bits (out)
			qsfp1_i2c_lpmode => pcieslaveinterface_imp_qsfp1_i2c_lpmode(0), -- 1 bits (out)
			qsfp1_i2c_modsell => pcieslaveinterface_imp_qsfp1_i2c_modsell(0), -- 1 bits (out)
			qsfp1_i2c_resetl => pcieslaveinterface_imp_qsfp1_i2c_resetl(0), -- 1 bits (out)
			qsfp2_i2c_SCL_drv => pcieslaveinterface_imp_qsfp2_i2c_scl_drv(0), -- 1 bits (out)
			qsfp2_i2c_SDA_drv => pcieslaveinterface_imp_qsfp2_i2c_sda_drv(0), -- 1 bits (out)
			qsfp2_i2c_lpmode => pcieslaveinterface_imp_qsfp2_i2c_lpmode(0), -- 1 bits (out)
			qsfp2_i2c_modsell => pcieslaveinterface_imp_qsfp2_i2c_modsell(0), -- 1 bits (out)
			qsfp2_i2c_resetl => pcieslaveinterface_imp_qsfp2_i2c_resetl(0), -- 1 bits (out)
			qsfp3_i2c_SCL_drv => pcieslaveinterface_imp_qsfp3_i2c_scl_drv(0), -- 1 bits (out)
			qsfp3_i2c_SDA_drv => pcieslaveinterface_imp_qsfp3_i2c_sda_drv(0), -- 1 bits (out)
			qsfp3_i2c_lpmode => pcieslaveinterface_imp_qsfp3_i2c_lpmode(0), -- 1 bits (out)
			qsfp3_i2c_modsell => pcieslaveinterface_imp_qsfp3_i2c_modsell(0), -- 1 bits (out)
			qsfp3_i2c_resetl => pcieslaveinterface_imp_qsfp3_i2c_resetl(0), -- 1 bits (out)
			qsfp4_i2c_SCL_drv => pcieslaveinterface_imp_qsfp4_i2c_scl_drv(0), -- 1 bits (out)
			qsfp4_i2c_SDA_drv => pcieslaveinterface_imp_qsfp4_i2c_sda_drv(0), -- 1 bits (out)
			qsfp4_i2c_lpmode => pcieslaveinterface_imp_qsfp4_i2c_lpmode(0), -- 1 bits (out)
			qsfp4_i2c_modsell => pcieslaveinterface_imp_qsfp4_i2c_modsell(0), -- 1 bits (out)
			qsfp4_i2c_resetl => pcieslaveinterface_imp_qsfp4_i2c_resetl(0), -- 1 bits (out)
			qsfp5_i2c_SCL_drv => pcieslaveinterface_imp_qsfp5_i2c_scl_drv(0), -- 1 bits (out)
			qsfp5_i2c_SDA_drv => pcieslaveinterface_imp_qsfp5_i2c_sda_drv(0), -- 1 bits (out)
			qsfp5_i2c_lpmode => pcieslaveinterface_imp_qsfp5_i2c_lpmode(0), -- 1 bits (out)
			qsfp5_i2c_modsell => pcieslaveinterface_imp_qsfp5_i2c_modsell(0), -- 1 bits (out)
			qsfp5_i2c_resetl => pcieslaveinterface_imp_qsfp5_i2c_resetl(0), -- 1 bits (out)
			qsfp6_i2c_SCL_drv => pcieslaveinterface_imp_qsfp6_i2c_scl_drv(0), -- 1 bits (out)
			qsfp6_i2c_SDA_drv => pcieslaveinterface_imp_qsfp6_i2c_sda_drv(0), -- 1 bits (out)
			qsfp6_i2c_lpmode => pcieslaveinterface_imp_qsfp6_i2c_lpmode(0), -- 1 bits (out)
			qsfp6_i2c_modsell => pcieslaveinterface_imp_qsfp6_i2c_modsell(0), -- 1 bits (out)
			qsfp6_i2c_resetl => pcieslaveinterface_imp_qsfp6_i2c_resetl(0), -- 1 bits (out)
			qsfp7_i2c_SCL_drv => pcieslaveinterface_imp_qsfp7_i2c_scl_drv(0), -- 1 bits (out)
			qsfp7_i2c_SDA_drv => pcieslaveinterface_imp_qsfp7_i2c_sda_drv(0), -- 1 bits (out)
			qsfp7_i2c_lpmode => pcieslaveinterface_imp_qsfp7_i2c_lpmode(0), -- 1 bits (out)
			qsfp7_i2c_modsell => pcieslaveinterface_imp_qsfp7_i2c_modsell(0), -- 1 bits (out)
			qsfp7_i2c_resetl => pcieslaveinterface_imp_qsfp7_i2c_resetl(0), -- 1 bits (out)
			ptp_phy_mdio_scl_from_host => pcieslaveinterface_imp_ptp_phy_mdio_scl_from_host(0), -- 1 bits (out)
			ptp_phy_mdio_sda_from_host => pcieslaveinterface_imp_ptp_phy_mdio_sda_from_host(0), -- 1 bits (out)
			ptp_phy_sresetn => pcieslaveinterface_imp_ptp_phy_sresetn(0), -- 1 bits (out)
			flash_rx_addr => pcieslaveinterface_imp_flash_rx_addr(0), -- 1 bits (out)
			flash_tx_d => pcieslaveinterface_imp_flash_tx_d, -- 64 bits (out)
			flash_tx_we => pcieslaveinterface_imp_flash_tx_we(0), -- 1 bits (out)
			leds => pcieslaveinterface_imp_leds, -- 2 bits (out)
			soft_reset => pcieslaveinterface_imp_soft_reset(0), -- 1 bits (out)
			throttle_limit => pcieslaveinterface_imp_throttle_limit, -- 11 bits (out)
			dcm_multdiv => pcieslaveinterface_imp_dcm_multdiv, -- 16 bits (out)
			control_streams_select => pcieslaveinterface_imp_control_streams_select, -- 4 bits (out)
			control_streams_reset_toggle => pcieslaveinterface_imp_control_streams_reset_toggle(0), -- 1 bits (out)
			bar_parse_wr_addr_onehot => pcieslaveinterface_imp_bar_parse_wr_addr_onehot, -- 256 bits (out)
			bar_parse_wr_data => pcieslaveinterface_imp_bar_parse_wr_data, -- 64 bits (out)
			bar_parse_wr_clk => pcieslaveinterface_imp_bar_parse_wr_clk(0), -- 1 bits (out)
			bar_parse_wr_page_sel_onehot => pcieslaveinterface_imp_bar_parse_wr_page_sel_onehot, -- 2 bits (out)
			sfa_user_toggle => pcieslaveinterface_imp_sfa_user_toggle(0), -- 1 bits (out)
			compute_reset_n => pcieslaveinterface_imp_compute_reset_n(0), -- 1 bits (out)
			mapped_elements_read => pcieslaveinterface_imp_mapped_elements_read(0), -- 1 bits (out)
			mapped_elements_data_in => pcieslaveinterface_imp_mapped_elements_data_in, -- 32 bits (out)
			mapped_elements_fc_in => pcieslaveinterface_imp_mapped_elements_fc_in, -- 2 bits (out)
			mapped_elements_write => pcieslaveinterface_imp_mapped_elements_write(0), -- 1 bits (out)
			mapped_elements_select_dma => pcieslaveinterface_imp_mapped_elements_select_dma(0), -- 1 bits (out)
			mapped_elements_reset => pcieslaveinterface_imp_mapped_elements_reset(0), -- 1 bits (out)
			local_ifpga_session_key => pcieslaveinterface_imp_local_ifpga_session_key, -- 2 bits (out)
			clk_pcie => clk_pcie, -- 1 bits (in)
			rst_pcie_n => rst_pcie_n, -- 1 bits (in)
			register_out => mappedreg_reg_data_out, -- 32 bits (in)
			register_completion_toggle => mappedreg_reg_completion_toggle, -- 1 bits (in)
			stream_interrupt_toggle => mappedreg_stream_interrupt_toggle, -- 16 bits (in)
			dma_complete_sfh => dma_complete_sfh, -- 32 bits (in)
			dma_complete_sth => dma_complete_sth, -- 32 bits (in)
			dma_ctl_read_data => dma_ctl_read_data, -- 64 bits (in)
			req_interrupt_ctl_valid => req_interrupt_ctl_valid, -- 1 bits (in)
			req_interrupt_ctl_enable_id => req_interrupt_ctl_enable_id, -- 32 bits (in)
			reg_data_out => reg_data_out, -- 64 bits (in)
			reg_data_wren => reg_data_wren, -- 8 bits (in)
			reg_data_addr => reg_data_addr, -- 64 bits (in)
			reg_data_bar0 => reg_data_bar0, -- 1 bits (in)
			reg_data_bar2 => reg_data_bar2, -- 1 bits (in)
			rx_reg_read_compl_tc => rx_reg_read_compl_tc, -- 3 bits (in)
			rx_reg_read_compl_td => rx_reg_read_compl_td, -- 1 bits (in)
			rx_reg_read_compl_ep => rx_reg_read_compl_ep, -- 1 bits (in)
			rx_reg_read_compl_attr => rx_reg_read_compl_attr, -- 2 bits (in)
			rx_reg_read_compl_rid => rx_reg_read_compl_rid, -- 16 bits (in)
			rx_reg_read_compl_tag => rx_reg_read_compl_tag, -- 8 bits (in)
			rx_reg_read_compl_addr => rx_reg_read_compl_addr, -- 64 bits (in)
			rx_reg_read_compl_bar2 => rx_reg_read_compl_bar2, -- 1 bits (in)
			rx_reg_read_compl_req => rx_reg_read_compl_req, -- 1 bits (in)
			rx_reg_read_compl_size => rx_reg_read_compl_size, -- 10 bits (in)
			tx_reg_compl_rden => tx_reg_compl_rden, -- 1 bits (in)
			tx_reg_compl_ack => tx_reg_compl_ack, -- 1 bits (in)
			app_int_ack => app_int_ack, -- 1 bits (in)
			app_msi_ack => app_msi_ack, -- 1 bits (in)
			tl_cfg_ctl => tl_cfg_ctl, -- 32 bits (in)
			tl_cfg_add => tl_cfg_add, -- 4 bits (in)
			ltssmstate => ltssmstate, -- 5 bits (in)
			maxring_s_th => maxring_s_th, -- 4 bits (in)
			maxring_id_th => maxring_id_th, -- 4 bits (in)
			maxring_prsn_th => maxring_prsn_th, -- 1 bits (in)
			maxring_type_th => maxring_type_th, -- 2 bits (in)
			i2c_left_dimm_SCL_fb => i2c_left_dimm_SCL_fb, -- 1 bits (in)
			i2c_left_dimm_SDA_fb => i2c_left_dimm_SDA_fb, -- 1 bits (in)
			i2c_right_dimm_SCL_fb => i2c_right_dimm_SCL_fb, -- 1 bits (in)
			i2c_right_dimm_SDA_fb => i2c_right_dimm_SDA_fb, -- 1 bits (in)
			i2c_dimm_alert => i2c_dimm_alert, -- 1 bits (in)
			i2c_aux_SCL_fb => i2c_aux_SCL_fb, -- 1 bits (in)
			i2c_aux_SDA_fb => i2c_aux_SDA_fb, -- 1 bits (in)
			i2c_aux_ALERT => i2c_aux_ALERT, -- 1 bits (in)
			pmbus_SCL_fb => pmbus_SCL_fb, -- 1 bits (in)
			pmbus_SDA_fb => pmbus_SDA_fb, -- 1 bits (in)
			pmbus_ALERT => pmbus_ALERT, -- 1 bits (in)
			host_event_status => host_event_status, -- 97 bits (in)
			config_FPGA_INIT_DONE => config_FPGA_INIT_DONE, -- 1 bits (in)
			config_FPGA_CRC_ERROR => config_FPGA_CRC_ERROR, -- 1 bits (in)
			config_FPGA_CvP_CONFDONE => config_FPGA_CvP_CONFDONE, -- 1 bits (in)
			rev_DIPSW => rev_DIPSW, -- 4 bits (in)
			rev_ASSY_REV => rev_ASSY_REV, -- 2 bits (in)
			rev_PCB_REV => rev_PCB_REV, -- 2 bits (in)
			rev_CPLD_Version => rev_CPLD_Version, -- 8 bits (in)
			rev_BUILD_REV => rev_BUILD_REV, -- 2 bits (in)
			qsfp0_i2c_SCL_fb => vec_to_bit("0"), -- 1 bits (in)
			qsfp0_i2c_SDA_fb => vec_to_bit("0"), -- 1 bits (in)
			qsfp0_i2c_ALERT => vec_to_bit("0"), -- 1 bits (in)
			qsfp0_i2c_modprsl => vec_to_bit("0"), -- 1 bits (in)
			qsfp1_i2c_SCL_fb => vec_to_bit("0"), -- 1 bits (in)
			qsfp1_i2c_SDA_fb => vec_to_bit("0"), -- 1 bits (in)
			qsfp1_i2c_ALERT => vec_to_bit("0"), -- 1 bits (in)
			qsfp1_i2c_modprsl => vec_to_bit("0"), -- 1 bits (in)
			qsfp2_i2c_SCL_fb => vec_to_bit("0"), -- 1 bits (in)
			qsfp2_i2c_SDA_fb => vec_to_bit("0"), -- 1 bits (in)
			qsfp2_i2c_ALERT => vec_to_bit("0"), -- 1 bits (in)
			qsfp2_i2c_modprsl => vec_to_bit("0"), -- 1 bits (in)
			qsfp3_i2c_SCL_fb => vec_to_bit("0"), -- 1 bits (in)
			qsfp3_i2c_SDA_fb => vec_to_bit("0"), -- 1 bits (in)
			qsfp3_i2c_ALERT => vec_to_bit("0"), -- 1 bits (in)
			qsfp3_i2c_modprsl => vec_to_bit("0"), -- 1 bits (in)
			qsfp4_i2c_SCL_fb => vec_to_bit("0"), -- 1 bits (in)
			qsfp4_i2c_SDA_fb => vec_to_bit("0"), -- 1 bits (in)
			qsfp4_i2c_ALERT => vec_to_bit("0"), -- 1 bits (in)
			qsfp4_i2c_modprsl => vec_to_bit("0"), -- 1 bits (in)
			qsfp5_i2c_SCL_fb => vec_to_bit("0"), -- 1 bits (in)
			qsfp5_i2c_SDA_fb => vec_to_bit("0"), -- 1 bits (in)
			qsfp5_i2c_ALERT => vec_to_bit("0"), -- 1 bits (in)
			qsfp5_i2c_modprsl => vec_to_bit("0"), -- 1 bits (in)
			qsfp6_i2c_SCL_fb => vec_to_bit("0"), -- 1 bits (in)
			qsfp6_i2c_SDA_fb => vec_to_bit("0"), -- 1 bits (in)
			qsfp6_i2c_ALERT => vec_to_bit("0"), -- 1 bits (in)
			qsfp6_i2c_modprsl => vec_to_bit("0"), -- 1 bits (in)
			qsfp7_i2c_SCL_fb => vec_to_bit("0"), -- 1 bits (in)
			qsfp7_i2c_SDA_fb => vec_to_bit("0"), -- 1 bits (in)
			qsfp7_i2c_ALERT => vec_to_bit("0"), -- 1 bits (in)
			qsfp7_i2c_modprsl => vec_to_bit("0"), -- 1 bits (in)
			ptp_phy_mdio_scl_to_host => vec_to_bit("0"), -- 1 bits (in)
			ptp_phy_mdio_sda_to_host => vec_to_bit("0"), -- 1 bits (in)
			ptp_phy_mdio_event_to_host => vec_to_bit("0"), -- 1 bits (in)
			flash_rx_d => flash_rx_d, -- 64 bits (in)
			capabilities => pcieslaveinterface_imp_capabilities1, -- 32 bits (in)
			pcie_capabilities => pcie_capabilities, -- 16 bits (in)
			slave_streaming_buf_cap => slave_streaming_buf_cap, -- 32 bits (in)
			bar_status_tx_fifo_empty => bar_status_tx_fifo_empty, -- 1 bits (in)
			sfa_user_toggle_ack => sfa_user_toggle_ack, -- 1 bits (in)
			slave_sfh_card_credits_index => pcieslaveinterface_imp_slave_sfh_card_credits_index1, -- 5 bits (in)
			slave_sfh_card_credits_wrap => pcieslaveinterface_imp_slave_sfh_card_credits_wrap1, -- 5 bits (in)
			slave_sfh_card_credits_update => pcieslaveinterface_imp_slave_sfh_card_credits_update1, -- 5 bits (in)
			slave_sth_card_credits_index => pcieslaveinterface_imp_slave_sth_card_credits_index1, -- 2 bits (in)
			slave_sth_card_credits_wrap => pcieslaveinterface_imp_slave_sth_card_credits_wrap1, -- 2 bits (in)
			slave_sth_card_credits_update => pcieslaveinterface_imp_slave_sth_card_credits_update1, -- 2 bits (in)
			sfh_cap => sfh_cap, -- 128 bits (in)
			sth_cap => sth_cap, -- 128 bits (in)
			sfh_cap_ctrl_0 => sfh_cap_ctrl_0, -- 8 bits (in)
			sth_cap_ctrl_0 => sth_cap_ctrl_0, -- 8 bits (in)
			mapped_elements_version => mapped_elements_version, -- 32 bits (in)
			mapped_elements_empty => mapped_elements_empty, -- 1 bits (in)
			mapped_elements_fc_type => mapped_elements_fc_type, -- 2 bits (in)
			mapped_elements_toggle => mapped_elements_toggle, -- 1 bits (in)
			mapped_elements_data => mapped_elements_data, -- 32 bits (in)
			mapped_elements_fill => mapped_elements_fill -- 10 bits (in)
		);
	PCIeSlaveReqDispatcher_imp : max_pcie_slave_req_dispatcher
		generic map (
			NUM_STREAMS_TO_HOST => 2,
			NUM_STREAMS_FROM_HOST => 5,
			NUM_STREAM_BIT_WIDTH => 5,
			STREAM_ADDR_SEGMENT_BIT_WIDTH => 13
		)
		port map (
			sfh_wren => pcieslavereqdispatcher_imp_sfh_wren, -- 5 bits (out)
			sfh_write_addr => pcieslavereqdispatcher_imp_sfh_write_addr, -- 13 bits (out)
			sfh_write_size => pcieslavereqdispatcher_imp_sfh_write_size, -- 10 bits (out)
			sfh_write_data => pcieslavereqdispatcher_imp_sfh_write_data, -- 128 bits (out)
			sfh_write_be => pcieslavereqdispatcher_imp_sfh_write_be, -- 16 bits (out)
			sfh_write_last => pcieslavereqdispatcher_imp_sfh_write_last(0), -- 1 bits (out)
			sth_rden => pcieslavereqdispatcher_imp_sth_rden, -- 2 bits (out)
			sth_read_addr => pcieslavereqdispatcher_imp_sth_read_addr, -- 13 bits (out)
			sth_read_size => pcieslavereqdispatcher_imp_sth_read_size, -- 10 bits (out)
			sth_read_metadata => pcieslavereqdispatcher_imp_sth_read_metadata, -- 31 bits (out)
			sth_read_be => pcieslavereqdispatcher_imp_sth_read_be, -- 8 bits (out)
			clk_pcie => clk_pcie, -- 1 bits (in)
			rst_pcie_n => rst_pcie_n, -- 1 bits (in)
			sl_en => rx_slave_stream_req_sl_en, -- 1 bits (in)
			sl_wr_en => rx_slave_stream_req_sl_wr_en, -- 1 bits (in)
			sl_wr_addr => rx_slave_stream_req_sl_wr_addr, -- 64 bits (in)
			sl_wr_size => rx_slave_stream_req_sl_wr_size, -- 10 bits (in)
			sl_wr_data => rx_slave_stream_req_sl_wr_data, -- 128 bits (in)
			sl_wr_be => rx_slave_stream_req_sl_wr_be, -- 16 bits (in)
			sl_wr_last => rx_slave_stream_req_sl_wr_last, -- 1 bits (in)
			sl_rd_en => rx_slave_stream_req_sl_rd_en, -- 1 bits (in)
			sl_rd_tc => rx_slave_stream_req_sl_rd_tc, -- 3 bits (in)
			sl_rd_td => rx_slave_stream_req_sl_rd_td, -- 1 bits (in)
			sl_rd_ep => rx_slave_stream_req_sl_rd_ep, -- 1 bits (in)
			sl_rd_attr => rx_slave_stream_req_sl_rd_attr, -- 2 bits (in)
			sl_rd_rid => rx_slave_stream_req_sl_rd_rid, -- 16 bits (in)
			sl_rd_tag => rx_slave_stream_req_sl_rd_tag, -- 8 bits (in)
			sl_rd_be => rx_slave_stream_req_sl_rd_be, -- 8 bits (in)
			sl_rd_addr => rx_slave_stream_req_sl_rd_addr, -- 64 bits (in)
			sl_rd_size => rx_slave_stream_req_sl_rd_size -- 10 bits (in)
		);
end MaxDC;
