library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity MAX4FPGATop is
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
end MAX4FPGATop;

architecture MaxDC of MAX4FPGATop is
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
	component FPGAWrapperEntity_Manager_CpuStream is
		port (
			global_global_sys_clk: in std_logic;
			global_global_reset_n: in std_logic;
			global_global_cclk: in std_logic;
			pll_mgmt_readdata0: in std_logic_vector(31 downto 0);
			pll_mgmt_waitrequest0: in std_logic;
			pll_inst_locked0: in std_logic;
			stream_clocks_gen_output_clk0: in std_logic;
			stream_clocks_gen_output_clk_inv0: in std_logic;
			stream_clocks_gen_output_clk_nobuf0: in std_logic;
			pcie_pcie_clocking_clk_pcie: in std_logic;
			pcie_pcie_clocking_rst_pcie_n: in std_logic;
			pcie_pcie_rxdma_dma_response_data: in std_logic_vector(127 downto 0);
			pcie_pcie_rxdma_dma_response_valid: in std_logic_vector(1 downto 0);
			pcie_pcie_rxdma_dma_response_len: in std_logic_vector(9 downto 0);
			pcie_pcie_rxdma_dma_response_tag: in std_logic_vector(7 downto 0);
			pcie_pcie_rxdma_dma_response_complete: in std_logic;
			pcie_pcie_rxdma_dma_response_ready: in std_logic;
			pcie_pcie_dma_control_dma_abort_sfh: in std_logic_vector(31 downto 0);
			pcie_pcie_dma_control_dma_abort_sth: in std_logic_vector(31 downto 0);
			pcie_pcie_dma_control_dma_ctl_address: in std_logic_vector(8 downto 0);
			pcie_pcie_dma_control_dma_ctl_data: in std_logic_vector(63 downto 0);
			pcie_pcie_dma_control_dma_ctl_write: in std_logic;
			pcie_pcie_dma_control_dma_ctl_byte_en: in std_logic_vector(7 downto 0);
			pcie_pcie_dmareadreq_dma_read_ack: in std_logic;
			pcie_pcie_dmawritereq_ack: in std_logic;
			pcie_pcie_dmawritereq_done: in std_logic;
			pcie_pcie_dmawritereq_busy: in std_logic;
			pcie_pcie_dmawritereq_rden: in std_logic;
			pcie_pcie_bar_parse_wr_addr_onehot: in std_logic_vector(255 downto 0);
			pcie_pcie_bar_parse_wr_data: in std_logic_vector(63 downto 0);
			pcie_pcie_bar_parse_wr_clk: in std_logic;
			pcie_pcie_bar_parse_wr_page_sel_onehot: in std_logic_vector(1 downto 0);
			pcie_pcie_slave_streaming_write_sfh_wren: in std_logic_vector(4 downto 0);
			pcie_pcie_slave_streaming_write_sfh_write_addr: in std_logic_vector(12 downto 0);
			pcie_pcie_slave_streaming_write_sfh_write_size: in std_logic_vector(9 downto 0);
			pcie_pcie_slave_streaming_write_sfh_write_data: in std_logic_vector(127 downto 0);
			pcie_pcie_slave_streaming_write_sfh_write_be: in std_logic_vector(15 downto 0);
			pcie_pcie_slave_streaming_write_sfh_write_last: in std_logic;
			pcie_pcie_slave_streaming_read_sth_rden: in std_logic_vector(1 downto 0);
			pcie_pcie_slave_streaming_read_sth_read_addr: in std_logic_vector(12 downto 0);
			pcie_pcie_slave_streaming_read_sth_read_size: in std_logic_vector(9 downto 0);
			pcie_pcie_slave_streaming_read_sth_read_metadata: in std_logic_vector(30 downto 0);
			pcie_pcie_slave_streaming_read_sth_read_be: in std_logic_vector(7 downto 0);
			pcie_pcie_slave_streaming_arb_read_compl_select: in std_logic;
			pcie_pcie_slave_streaming_arb_read_compl_rden: in std_logic;
			pcie_pcie_slave_streaming_arb_read_compl_done: in std_logic;
			pcie_pcie_control_sfh_stall: in std_logic;
			pcie_pcie_control_sth_valid: in std_logic;
			pcie_pcie_control_sth_done: in std_logic;
			pcie_pcie_control_sth_data: in std_logic_vector(127 downto 0);
			pcie_pcie_sfa_user_toggle: in std_logic;
			pcie_pcie_mappedreg_reg_addr: in std_logic_vector(23 downto 0);
			pcie_pcie_mappedreg_reg_byte_en: in std_logic_vector(3 downto 0);
			pcie_pcie_mappedreg_reg_data_in: in std_logic_vector(31 downto 0);
			pcie_pcie_mappedreg_reg_write_toggle: in std_logic;
			pcie_pcie_mappedreg_reg_read_toggle: in std_logic;
			pcie_pcie_pcie_clocking_rst_toggle: in std_logic;
			pcie_pcie_pcie_clocking_rst_dcm_toggle: in std_logic;
			pcie_pcie_pcie_clocking_clk: in std_logic;
			pcie_pcie_pcie_clocking_dcm_multdiv: in std_logic_vector(15 downto 0);
			pcie_pcie_mec_fwd_write_port_DST_RDY_N: in std_logic;
			pcie_pcie_mec_fwd_read_port_SOP_N: in std_logic;
			pcie_pcie_mec_fwd_read_port_EOP_N: in std_logic;
			pcie_pcie_mec_fwd_read_port_SRC_RDY_N: in std_logic;
			pcie_pcie_mec_fwd_read_port_DATA: in std_logic_vector(31 downto 0);
			pcie_pcie_user_control_rst_user: in std_logic;
			pll_mgmt_clk0: out std_logic;
			pll_mgmt_rst0: out std_logic;
			pll_mgmt_address0: out std_logic_vector(5 downto 0);
			pll_mgmt_read0: out std_logic;
			pll_mgmt_write0: out std_logic;
			pll_mgmt_writedata0: out std_logic_vector(31 downto 0);
			pll_rst0: out std_logic;
			clkbuf_clken0: out std_logic;
			pcie_pcie_dma_control_dma_complete_sfh: out std_logic_vector(31 downto 0);
			pcie_pcie_dma_control_dma_complete_sth: out std_logic_vector(31 downto 0);
			pcie_pcie_dma_control_dma_ctl_read_data: out std_logic_vector(63 downto 0);
			pcie_pcie_dmareadreq_dma_read_req: out std_logic;
			pcie_pcie_dmareadreq_dma_read_addr: out std_logic_vector(63 downto 0);
			pcie_pcie_dmareadreq_dma_read_len: out std_logic_vector(9 downto 0);
			pcie_pcie_dmareadreq_dma_read_be: out std_logic_vector(3 downto 0);
			pcie_pcie_dmareadreq_dma_read_tag: out std_logic_vector(7 downto 0);
			pcie_pcie_dmareadreq_dma_read_wide_addr: out std_logic;
			pcie_pcie_dmawritereq_req: out std_logic;
			pcie_pcie_dmawritereq_addr: out std_logic_vector(63 downto 0);
			pcie_pcie_dmawritereq_tag: out std_logic_vector(7 downto 0);
			pcie_pcie_dmawritereq_len: out std_logic_vector(8 downto 0);
			pcie_pcie_dmawritereq_wide_addr: out std_logic;
			pcie_pcie_dmawritereq_rddata: out std_logic_vector(127 downto 0);
			pcie_pcie_req_interrupt_ctl_valid: out std_logic;
			pcie_pcie_req_interrupt_ctl_enable_id: out std_logic_vector(31 downto 0);
			pcie_pcie_bar_status_tx_fifo_empty: out std_logic;
			pcie_pcie_slave_streaming_arb_read_compl_req: out std_logic;
			pcie_pcie_slave_streaming_arb_read_compl_metadata: out std_logic_vector(30 downto 0);
			pcie_pcie_slave_streaming_arb_read_compl_addr: out std_logic_vector(6 downto 0);
			pcie_pcie_slave_streaming_arb_read_compl_size: out std_logic_vector(11 downto 0);
			pcie_pcie_slave_streaming_arb_read_compl_rem_size: out std_logic_vector(11 downto 0);
			pcie_pcie_slave_streaming_arb_read_compl_data: out std_logic_vector(127 downto 0);
			pcie_pcie_slave_sfh_credits0_index: out std_logic_vector(0 downto 0);
			pcie_pcie_slave_sfh_credits0_update: out std_logic;
			pcie_pcie_slave_sfh_credits0_wrap: out std_logic;
			pcie_pcie_slave_sfh_credits1_index: out std_logic_vector(0 downto 0);
			pcie_pcie_slave_sfh_credits1_update: out std_logic;
			pcie_pcie_slave_sfh_credits1_wrap: out std_logic;
			pcie_pcie_slave_sfh_credits2_index: out std_logic_vector(0 downto 0);
			pcie_pcie_slave_sfh_credits2_update: out std_logic;
			pcie_pcie_slave_sfh_credits2_wrap: out std_logic;
			pcie_pcie_slave_sfh_credits3_index: out std_logic_vector(0 downto 0);
			pcie_pcie_slave_sfh_credits3_update: out std_logic;
			pcie_pcie_slave_sfh_credits3_wrap: out std_logic;
			pcie_pcie_slave_sfh_credits4_index: out std_logic_vector(0 downto 0);
			pcie_pcie_slave_sfh_credits4_update: out std_logic;
			pcie_pcie_slave_sfh_credits4_wrap: out std_logic;
			pcie_pcie_slave_sth_credits0_index: out std_logic_vector(0 downto 0);
			pcie_pcie_slave_sth_credits0_update: out std_logic;
			pcie_pcie_slave_sth_credits0_wrap: out std_logic;
			pcie_pcie_slave_sth_credits1_index: out std_logic_vector(0 downto 0);
			pcie_pcie_slave_sth_credits1_update: out std_logic;
			pcie_pcie_slave_sth_credits1_wrap: out std_logic;
			sfh_cap: out std_logic_vector(127 downto 0);
			sth_cap: out std_logic_vector(127 downto 0);
			sfh_cap_ctrl_0: out std_logic_vector(7 downto 0);
			sth_cap_ctrl_0: out std_logic_vector(7 downto 0);
			pcie_pcie_control_sfh_valid: out std_logic;
			pcie_pcie_control_sfh_done: out std_logic;
			pcie_pcie_control_sfh_data: out std_logic_vector(127 downto 0);
			pcie_pcie_control_sth_stall: out std_logic;
			pcie_pcie_sfa_user_toggle_ack: out std_logic;
			pcie_pcie_mappedreg_reg_data_out: out std_logic_vector(31 downto 0);
			pcie_pcie_mappedreg_reg_completion_toggle: out std_logic;
			pcie_pcie_mappedreg_stream_interrupt_toggle: out std_logic_vector(15 downto 0);
			pcie_pcie_mec_fwd_write_port_SOP_N: out std_logic;
			pcie_pcie_mec_fwd_write_port_EOP_N: out std_logic;
			pcie_pcie_mec_fwd_write_port_SRC_RDY_N: out std_logic;
			pcie_pcie_mec_fwd_write_port_DATA: out std_logic_vector(31 downto 0);
			pcie_pcie_mec_fwd_read_port_DST_RDY_N: out std_logic;
			pcie_pcie_mec_fwd_clocking_clk_switch: out std_logic;
			pcie_pcie_mec_fwd_clocking_rst_switch: out std_logic
		);
	end component;
	component MAX4PCIeSlaveInterface is
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
	end component;
	component StratixPCIeInterface is
		port (
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			tx_st_ready: in std_logic;
			cfg_completer_id: in std_logic_vector(15 downto 0);
			tx_dma_write_req: in std_logic;
			tx_dma_write_addr: in std_logic_vector(63 downto 0);
			tx_dma_write_tag: in std_logic_vector(7 downto 0);
			tx_dma_write_len: in std_logic_vector(8 downto 0);
			tx_dma_write_wide_addr: in std_logic;
			tx_dma_write_rddata: in std_logic_vector(127 downto 0);
			tx_dma_read_dma_read_req: in std_logic;
			tx_dma_read_dma_read_addr: in std_logic_vector(63 downto 0);
			tx_dma_read_dma_read_len: in std_logic_vector(9 downto 0);
			tx_dma_read_dma_read_be: in std_logic_vector(3 downto 0);
			tx_dma_read_dma_read_tag: in std_logic_vector(7 downto 0);
			tx_dma_read_dma_read_wide_addr: in std_logic;
			tx_reg_compl_req: in std_logic;
			tx_reg_compl_tc: in std_logic_vector(2 downto 0);
			tx_reg_compl_td: in std_logic;
			tx_reg_compl_ep: in std_logic;
			tx_reg_compl_attr: in std_logic_vector(1 downto 0);
			tx_reg_compl_rid: in std_logic_vector(15 downto 0);
			tx_reg_compl_tag: in std_logic_vector(7 downto 0);
			tx_reg_compl_addr: in std_logic_vector(12 downto 0);
			tx_reg_compl_data: in std_logic_vector(63 downto 0);
			tx_reg_compl_size: in std_logic_vector(9 downto 0);
			tx_slave_stream_compl_req: in std_logic;
			tx_slave_stream_compl_tc: in std_logic_vector(2 downto 0);
			tx_slave_stream_compl_td: in std_logic;
			tx_slave_stream_compl_ep: in std_logic;
			tx_slave_stream_compl_attr: in std_logic_vector(1 downto 0);
			tx_slave_stream_compl_rid: in std_logic_vector(15 downto 0);
			tx_slave_stream_compl_tag: in std_logic_vector(7 downto 0);
			tx_slave_stream_compl_addr: in std_logic_vector(6 downto 0);
			tx_slave_stream_compl_size: in std_logic_vector(11 downto 0);
			tx_slave_stream_compl_rem_size: in std_logic_vector(11 downto 0);
			tx_slave_stream_compl_data: in std_logic_vector(127 downto 0);
			rx_st_valid: in std_logic;
			rx_st_sop: in std_logic;
			rx_st_eop: in std_logic;
			rx_st_empty: in std_logic_vector(1 downto 0);
			rx_st_err: in std_logic;
			rx_st_bar: in std_logic_vector(7 downto 0);
			rx_st_data: in std_logic_vector(127 downto 0);
			rx_reg_read_compl_full: in std_logic;
			tx_st_valid: out std_logic;
			tx_st_sop: out std_logic;
			tx_st_eop: out std_logic;
			tx_st_empty: out std_logic_vector(1 downto 0);
			tx_st_err: out std_logic;
			tx_st_data: out std_logic_vector(127 downto 0);
			tx_dma_write_ack: out std_logic;
			tx_dma_write_done: out std_logic;
			tx_dma_write_busy: out std_logic;
			tx_dma_write_rden: out std_logic;
			tx_dma_read_dma_read_ack: out std_logic;
			tx_reg_compl_rden: out std_logic;
			tx_reg_compl_ack: out std_logic;
			tx_slave_stream_compl_ack: out std_logic;
			tx_slave_stream_compl_rden: out std_logic;
			tx_slave_stream_compl_done: out std_logic;
			rx_st_ready: out std_logic;
			rx_st_mask: out std_logic;
			cpl_err: out std_logic_vector(6 downto 0);
			cpl_pending: out std_logic;
			rx_dma_response_dma_response_data: out std_logic_vector(127 downto 0);
			rx_dma_response_dma_response_valid: out std_logic_vector(1 downto 0);
			rx_dma_response_dma_response_len: out std_logic_vector(9 downto 0);
			rx_dma_response_dma_response_tag: out std_logic_vector(7 downto 0);
			rx_dma_response_dma_response_complete: out std_logic;
			rx_dma_response_dma_response_ready: out std_logic;
			rx_reg_write_reg_data_out: out std_logic_vector(63 downto 0);
			rx_reg_write_reg_data_wren: out std_logic_vector(7 downto 0);
			rx_reg_write_reg_data_addr: out std_logic_vector(63 downto 0);
			rx_reg_write_reg_data_bar0: out std_logic;
			rx_reg_write_reg_data_bar2: out std_logic;
			rx_reg_read_compl_tc: out std_logic_vector(2 downto 0);
			rx_reg_read_compl_td: out std_logic;
			rx_reg_read_compl_ep: out std_logic;
			rx_reg_read_compl_attr: out std_logic_vector(1 downto 0);
			rx_reg_read_compl_rid: out std_logic_vector(15 downto 0);
			rx_reg_read_compl_tag: out std_logic_vector(7 downto 0);
			rx_reg_read_compl_addr: out std_logic_vector(63 downto 0);
			rx_reg_read_compl_bar2: out std_logic;
			rx_reg_read_compl_req: out std_logic;
			rx_reg_read_compl_size: out std_logic_vector(9 downto 0);
			rx_slave_stream_req_sl_en: out std_logic;
			rx_slave_stream_req_sl_wr_en: out std_logic;
			rx_slave_stream_req_sl_wr_addr: out std_logic_vector(63 downto 0);
			rx_slave_stream_req_sl_wr_size: out std_logic_vector(9 downto 0);
			rx_slave_stream_req_sl_wr_data: out std_logic_vector(127 downto 0);
			rx_slave_stream_req_sl_wr_be: out std_logic_vector(15 downto 0);
			rx_slave_stream_req_sl_wr_last: out std_logic;
			rx_slave_stream_req_sl_rd_en: out std_logic;
			rx_slave_stream_req_sl_rd_tc: out std_logic_vector(2 downto 0);
			rx_slave_stream_req_sl_rd_td: out std_logic;
			rx_slave_stream_req_sl_rd_ep: out std_logic;
			rx_slave_stream_req_sl_rd_attr: out std_logic_vector(1 downto 0);
			rx_slave_stream_req_sl_rd_rid: out std_logic_vector(15 downto 0);
			rx_slave_stream_req_sl_rd_tag: out std_logic_vector(7 downto 0);
			rx_slave_stream_req_sl_rd_be: out std_logic_vector(7 downto 0);
			rx_slave_stream_req_sl_rd_addr: out std_logic_vector(63 downto 0);
			rx_slave_stream_req_sl_rd_size: out std_logic_vector(9 downto 0)
		);
	end component;
	component PCIeEA is
		port (
			clk_switch: in std_logic;
			rst_switch: in std_logic;
			FROM_SWITCH_SOP_N: in std_logic;
			FROM_SWITCH_EOP_N: in std_logic;
			FROM_SWITCH_SRC_RDY_N: in std_logic;
			FROM_SWITCH_DATA: in std_logic_vector(31 downto 0);
			TO_SWITCH_DST_RDY_N: in std_logic;
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			pcie_ea_read: in std_logic;
			pcie_ea_data_in: in std_logic_vector(31 downto 0);
			pcie_ea_fc_in: in std_logic_vector(1 downto 0);
			pcie_ea_write: in std_logic;
			pcie_ea_select_dma: in std_logic;
			pcie_ea_reset: in std_logic;
			reset_ext: in std_logic;
			dma_from_host_data: in std_logic_vector(33 downto 0);
			dma_from_host_empty: in std_logic;
			FROM_SWITCH_DST_RDY_N: out std_logic;
			TO_SWITCH_SOP_N: out std_logic;
			TO_SWITCH_EOP_N: out std_logic;
			TO_SWITCH_SRC_RDY_N: out std_logic;
			TO_SWITCH_DATA: out std_logic_vector(31 downto 0);
			pcie_ea_version: out std_logic_vector(31 downto 0);
			pcie_ea_empty: out std_logic;
			pcie_ea_fc_type: out std_logic_vector(1 downto 0);
			pcie_ea_toggle: out std_logic;
			pcie_ea_data: out std_logic_vector(31 downto 0);
			pcie_ea_fill: out std_logic_vector(9 downto 0);
			user_control_rst_user: out std_logic;
			dma_from_host_rd_clk: out std_logic;
			dma_from_host_rd_rst: out std_logic;
			dma_from_host_rd_en: out std_logic
		);
	end component;
	component reset_control is
		generic (
			LOG2_RESET_CYCLES : integer
		);
		port (
			rst_n: in std_logic;
			reset_clk: in std_logic;
			reset_toggle: in std_logic;
			reset_out: out std_logic;
			reset_late_pulse: out std_logic
		);
	end component;
	component StreamFifo_altera_128_64_128_pushin_sl16_pushout_singleclock is
		port (
			clk: in std_logic;
			rst: in std_logic;
			rst_delayed: in std_logic;
			inputstream_push_valid: in std_logic;
			inputstream_push_done: in std_logic;
			inputstream_push_data: in std_logic_vector(127 downto 0);
			outputstream_push_stall: in std_logic;
			dbg_empty: out std_logic;
			dbg_stall: out std_logic;
			inputstream_push_stall: out std_logic;
			outputstream_push_valid: out std_logic;
			outputstream_push_done: out std_logic;
			outputstream_push_data: out std_logic_vector(63 downto 0)
		);
	end component;
	component AlteraFifoEntity_34_512_34_dualclock_aclr_wrusedw_fwft_pfv495 is
		port (
			wr_clk: in std_logic;
			rd_clk: in std_logic;
			din: in std_logic_vector(33 downto 0);
			wr_en: in std_logic;
			rd_en: in std_logic;
			rst: in std_logic;
			dout: out std_logic_vector(33 downto 0);
			full: out std_logic;
			empty: out std_logic;
			wr_data_count: out std_logic_vector(8 downto 0);
			prog_full: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal wrapper_pll_mgmt_clk0 : std_logic_vector(0 downto 0);
	signal wrapper_pll_mgmt_rst0 : std_logic_vector(0 downto 0);
	signal wrapper_pll_mgmt_address0 : std_logic_vector(5 downto 0);
	signal wrapper_pll_mgmt_read0 : std_logic_vector(0 downto 0);
	signal wrapper_pll_mgmt_write0 : std_logic_vector(0 downto 0);
	signal wrapper_pll_mgmt_writedata0 : std_logic_vector(31 downto 0);
	signal wrapper_pll_rst0 : std_logic_vector(0 downto 0);
	signal wrapper_clkbuf_clken0 : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_dma_control_dma_complete_sfh : std_logic_vector(31 downto 0);
	signal wrapper_pcie_pcie_dma_control_dma_complete_sth : std_logic_vector(31 downto 0);
	signal wrapper_pcie_pcie_dma_control_dma_ctl_read_data : std_logic_vector(63 downto 0);
	signal wrapper_pcie_pcie_dmareadreq_dma_read_req : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_dmareadreq_dma_read_addr : std_logic_vector(63 downto 0);
	signal wrapper_pcie_pcie_dmareadreq_dma_read_len : std_logic_vector(9 downto 0);
	signal wrapper_pcie_pcie_dmareadreq_dma_read_be : std_logic_vector(3 downto 0);
	signal wrapper_pcie_pcie_dmareadreq_dma_read_tag : std_logic_vector(7 downto 0);
	signal wrapper_pcie_pcie_dmareadreq_dma_read_wide_addr : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_dmawritereq_req : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_dmawritereq_addr : std_logic_vector(63 downto 0);
	signal wrapper_pcie_pcie_dmawritereq_tag : std_logic_vector(7 downto 0);
	signal wrapper_pcie_pcie_dmawritereq_len : std_logic_vector(8 downto 0);
	signal wrapper_pcie_pcie_dmawritereq_wide_addr : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_dmawritereq_rddata : std_logic_vector(127 downto 0);
	signal wrapper_pcie_pcie_req_interrupt_ctl_valid : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_req_interrupt_ctl_enable_id : std_logic_vector(31 downto 0);
	signal wrapper_pcie_pcie_bar_status_tx_fifo_empty : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_slave_streaming_arb_read_compl_req : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_slave_streaming_arb_read_compl_metadata : std_logic_vector(30 downto 0);
	signal wrapper_pcie_pcie_slave_streaming_arb_read_compl_addr : std_logic_vector(6 downto 0);
	signal wrapper_pcie_pcie_slave_streaming_arb_read_compl_size : std_logic_vector(11 downto 0);
	signal wrapper_pcie_pcie_slave_streaming_arb_read_compl_rem_size : std_logic_vector(11 downto 0);
	signal wrapper_pcie_pcie_slave_streaming_arb_read_compl_data : std_logic_vector(127 downto 0);
	signal wrapper_pcie_pcie_slave_sfh_credits0_index : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_slave_sfh_credits0_update : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_slave_sfh_credits0_wrap : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_slave_sfh_credits1_index : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_slave_sfh_credits1_update : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_slave_sfh_credits1_wrap : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_slave_sfh_credits2_index : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_slave_sfh_credits2_update : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_slave_sfh_credits2_wrap : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_slave_sfh_credits3_index : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_slave_sfh_credits3_update : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_slave_sfh_credits3_wrap : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_slave_sfh_credits4_index : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_slave_sfh_credits4_update : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_slave_sfh_credits4_wrap : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_slave_sth_credits0_index : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_slave_sth_credits0_update : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_slave_sth_credits0_wrap : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_slave_sth_credits1_index : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_slave_sth_credits1_update : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_slave_sth_credits1_wrap : std_logic_vector(0 downto 0);
	signal wrapper_sfh_cap : std_logic_vector(127 downto 0);
	signal wrapper_sth_cap : std_logic_vector(127 downto 0);
	signal wrapper_sfh_cap_ctrl_0 : std_logic_vector(7 downto 0);
	signal wrapper_sth_cap_ctrl_0 : std_logic_vector(7 downto 0);
	signal wrapper_pcie_pcie_control_sfh_valid : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_control_sfh_done : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_control_sfh_data : std_logic_vector(127 downto 0);
	signal wrapper_pcie_pcie_control_sth_stall : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_sfa_user_toggle_ack : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_mappedreg_reg_data_out : std_logic_vector(31 downto 0);
	signal wrapper_pcie_pcie_mappedreg_reg_completion_toggle : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_mappedreg_stream_interrupt_toggle : std_logic_vector(15 downto 0);
	signal wrapper_pcie_pcie_mec_fwd_write_port_sop_n : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_mec_fwd_write_port_eop_n : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_mec_fwd_write_port_src_rdy_n : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_mec_fwd_write_port_data : std_logic_vector(31 downto 0);
	signal wrapper_pcie_pcie_mec_fwd_read_port_dst_rdy_n : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_mec_fwd_clocking_clk_switch : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_mec_fwd_clocking_rst_switch : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_mappedreg_reg_addr : std_logic_vector(23 downto 0);
	signal max4pcieslaveinterface_i_mappedreg_reg_byte_en : std_logic_vector(3 downto 0);
	signal max4pcieslaveinterface_i_mappedreg_reg_data_in : std_logic_vector(31 downto 0);
	signal max4pcieslaveinterface_i_mappedreg_reg_write_toggle : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_mappedreg_reg_read_toggle : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_flush : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_leds : std_logic_vector(1 downto 0);
	signal max4pcieslaveinterface_i_soft_reset : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_throttle_limit : std_logic_vector(10 downto 0);
	signal max4pcieslaveinterface_i_pcie_clocking_rst_toggle : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_pcie_clocking_rst_dcm_toggle : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_pcie_clocking_clk : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_pcie_clocking_dcm_multdiv : std_logic_vector(15 downto 0);
	signal max4pcieslaveinterface_i_dma_abort_sfh : std_logic_vector(31 downto 0);
	signal max4pcieslaveinterface_i_dma_abort_sth : std_logic_vector(31 downto 0);
	signal max4pcieslaveinterface_i_dma_ctl_address : std_logic_vector(8 downto 0);
	signal max4pcieslaveinterface_i_dma_ctl_data : std_logic_vector(63 downto 0);
	signal max4pcieslaveinterface_i_dma_ctl_write : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_dma_ctl_byte_en : std_logic_vector(7 downto 0);
	signal max4pcieslaveinterface_i_rx_reg_read_compl_full : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_tx_reg_compl_req : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_tx_reg_compl_tc : std_logic_vector(2 downto 0);
	signal max4pcieslaveinterface_i_tx_reg_compl_td : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_tx_reg_compl_ep : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_tx_reg_compl_attr : std_logic_vector(1 downto 0);
	signal max4pcieslaveinterface_i_tx_reg_compl_rid : std_logic_vector(15 downto 0);
	signal max4pcieslaveinterface_i_tx_reg_compl_tag : std_logic_vector(7 downto 0);
	signal max4pcieslaveinterface_i_tx_reg_compl_addr : std_logic_vector(12 downto 0);
	signal max4pcieslaveinterface_i_tx_reg_compl_data : std_logic_vector(63 downto 0);
	signal max4pcieslaveinterface_i_tx_reg_compl_size : std_logic_vector(9 downto 0);
	signal max4pcieslaveinterface_i_app_int_sts : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_app_msi_req : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_app_msi_num : std_logic_vector(4 downto 0);
	signal max4pcieslaveinterface_i_app_msi_tc : std_logic_vector(2 downto 0);
	signal max4pcieslaveinterface_i_cfg_completer_id : std_logic_vector(15 downto 0);
	signal max4pcieslaveinterface_i_maxring_s_fh : std_logic_vector(3 downto 0);
	signal max4pcieslaveinterface_i_maxring_s_set_highz_n : std_logic_vector(3 downto 0);
	signal max4pcieslaveinterface_i_maxring_id_fh : std_logic_vector(3 downto 0);
	signal max4pcieslaveinterface_i_maxring_id_set_highz_n : std_logic_vector(3 downto 0);
	signal max4pcieslaveinterface_i_i2c_left_dimm_scl_drv : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_i2c_left_dimm_sda_drv : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_i2c_right_dimm_scl_drv : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_i2c_right_dimm_sda_drv : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_i2c_aux_scl_drv : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_i2c_aux_sda_drv : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_pmbus_scl_drv : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_pmbus_sda_drv : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_host_event_ack : std_logic_vector(96 downto 0);
	signal max4pcieslaveinterface_i_config_reconfig_trigger : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_flash_rx_addr : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_flash_tx_d : std_logic_vector(63 downto 0);
	signal max4pcieslaveinterface_i_flash_tx_we : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_ptp_phy_sresetn : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_compl_fifo_flags : std_logic_vector(1 downto 0);
	signal max4pcieslaveinterface_i_control_streams_select : std_logic_vector(3 downto 0);
	signal max4pcieslaveinterface_i_control_streams_reset_toggle : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_compute_reset_n : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_mapped_elements_read : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_mapped_elements_data_in : std_logic_vector(31 downto 0);
	signal max4pcieslaveinterface_i_mapped_elements_fc_in : std_logic_vector(1 downto 0);
	signal max4pcieslaveinterface_i_mapped_elements_write : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_mapped_elements_select_dma : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_mapped_elements_reset : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_local_ifpga_session_key : std_logic_vector(1 downto 0);
	signal max4pcieslaveinterface_i_bar_parse_wr_addr_onehot : std_logic_vector(255 downto 0);
	signal max4pcieslaveinterface_i_bar_parse_wr_data : std_logic_vector(63 downto 0);
	signal max4pcieslaveinterface_i_bar_parse_wr_clk : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_bar_parse_wr_page_sel_onehot : std_logic_vector(1 downto 0);
	signal max4pcieslaveinterface_i_sfa_user_toggle : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_slave_streaming_write_sfh_wren : std_logic_vector(4 downto 0);
	signal max4pcieslaveinterface_i_slave_streaming_write_sfh_write_addr : std_logic_vector(12 downto 0);
	signal max4pcieslaveinterface_i_slave_streaming_write_sfh_write_size : std_logic_vector(9 downto 0);
	signal max4pcieslaveinterface_i_slave_streaming_write_sfh_write_data : std_logic_vector(127 downto 0);
	signal max4pcieslaveinterface_i_slave_streaming_write_sfh_write_be : std_logic_vector(15 downto 0);
	signal max4pcieslaveinterface_i_slave_streaming_write_sfh_write_last : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_slave_streaming_read_sth_rden : std_logic_vector(1 downto 0);
	signal max4pcieslaveinterface_i_slave_streaming_read_sth_read_addr : std_logic_vector(12 downto 0);
	signal max4pcieslaveinterface_i_slave_streaming_read_sth_read_size : std_logic_vector(9 downto 0);
	signal max4pcieslaveinterface_i_slave_streaming_read_sth_read_metadata : std_logic_vector(30 downto 0);
	signal max4pcieslaveinterface_i_slave_streaming_read_sth_read_be : std_logic_vector(7 downto 0);
	signal max4pcieslaveinterface_i_tx_slave_stream_compl_req : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_tx_slave_stream_compl_tc : std_logic_vector(2 downto 0);
	signal max4pcieslaveinterface_i_tx_slave_stream_compl_td : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_tx_slave_stream_compl_ep : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_tx_slave_stream_compl_attr : std_logic_vector(1 downto 0);
	signal max4pcieslaveinterface_i_tx_slave_stream_compl_rid : std_logic_vector(15 downto 0);
	signal max4pcieslaveinterface_i_tx_slave_stream_compl_tag : std_logic_vector(7 downto 0);
	signal max4pcieslaveinterface_i_tx_slave_stream_compl_addr : std_logic_vector(6 downto 0);
	signal max4pcieslaveinterface_i_tx_slave_stream_compl_size : std_logic_vector(11 downto 0);
	signal max4pcieslaveinterface_i_tx_slave_stream_compl_rem_size : std_logic_vector(11 downto 0);
	signal max4pcieslaveinterface_i_tx_slave_stream_compl_data : std_logic_vector(127 downto 0);
	signal max4pcieslaveinterface_i_slave_streaming_arbitrated_read_compl_select : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_slave_streaming_arbitrated_read_compl_rden : std_logic_vector(0 downto 0);
	signal max4pcieslaveinterface_i_slave_streaming_arbitrated_read_compl_done : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_tx_st_valid : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_tx_st_sop : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_tx_st_eop : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_tx_st_empty : std_logic_vector(1 downto 0);
	signal stratixpcieinterface_i_tx_st_err : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_tx_st_data : std_logic_vector(127 downto 0);
	signal stratixpcieinterface_i_tx_dma_write_ack : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_tx_dma_write_done : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_tx_dma_write_busy : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_tx_dma_write_rden : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_tx_dma_read_dma_read_ack : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_tx_reg_compl_rden : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_tx_reg_compl_ack : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_tx_slave_stream_compl_ack : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_tx_slave_stream_compl_rden : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_tx_slave_stream_compl_done : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_rx_st_ready : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_rx_st_mask : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_cpl_err : std_logic_vector(6 downto 0);
	signal stratixpcieinterface_i_cpl_pending : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_rx_dma_response_dma_response_data : std_logic_vector(127 downto 0);
	signal stratixpcieinterface_i_rx_dma_response_dma_response_valid : std_logic_vector(1 downto 0);
	signal stratixpcieinterface_i_rx_dma_response_dma_response_len : std_logic_vector(9 downto 0);
	signal stratixpcieinterface_i_rx_dma_response_dma_response_tag : std_logic_vector(7 downto 0);
	signal stratixpcieinterface_i_rx_dma_response_dma_response_complete : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_rx_dma_response_dma_response_ready : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_rx_reg_write_reg_data_out : std_logic_vector(63 downto 0);
	signal stratixpcieinterface_i_rx_reg_write_reg_data_wren : std_logic_vector(7 downto 0);
	signal stratixpcieinterface_i_rx_reg_write_reg_data_addr : std_logic_vector(63 downto 0);
	signal stratixpcieinterface_i_rx_reg_write_reg_data_bar0 : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_rx_reg_write_reg_data_bar2 : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_rx_reg_read_compl_tc : std_logic_vector(2 downto 0);
	signal stratixpcieinterface_i_rx_reg_read_compl_td : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_rx_reg_read_compl_ep : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_rx_reg_read_compl_attr : std_logic_vector(1 downto 0);
	signal stratixpcieinterface_i_rx_reg_read_compl_rid : std_logic_vector(15 downto 0);
	signal stratixpcieinterface_i_rx_reg_read_compl_tag : std_logic_vector(7 downto 0);
	signal stratixpcieinterface_i_rx_reg_read_compl_addr : std_logic_vector(63 downto 0);
	signal stratixpcieinterface_i_rx_reg_read_compl_bar2 : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_rx_reg_read_compl_req : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_rx_reg_read_compl_size : std_logic_vector(9 downto 0);
	signal stratixpcieinterface_i_rx_slave_stream_req_sl_en : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_rx_slave_stream_req_sl_wr_en : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_rx_slave_stream_req_sl_wr_addr : std_logic_vector(63 downto 0);
	signal stratixpcieinterface_i_rx_slave_stream_req_sl_wr_size : std_logic_vector(9 downto 0);
	signal stratixpcieinterface_i_rx_slave_stream_req_sl_wr_data : std_logic_vector(127 downto 0);
	signal stratixpcieinterface_i_rx_slave_stream_req_sl_wr_be : std_logic_vector(15 downto 0);
	signal stratixpcieinterface_i_rx_slave_stream_req_sl_wr_last : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_rx_slave_stream_req_sl_rd_en : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_rx_slave_stream_req_sl_rd_tc : std_logic_vector(2 downto 0);
	signal stratixpcieinterface_i_rx_slave_stream_req_sl_rd_td : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_rx_slave_stream_req_sl_rd_ep : std_logic_vector(0 downto 0);
	signal stratixpcieinterface_i_rx_slave_stream_req_sl_rd_attr : std_logic_vector(1 downto 0);
	signal stratixpcieinterface_i_rx_slave_stream_req_sl_rd_rid : std_logic_vector(15 downto 0);
	signal stratixpcieinterface_i_rx_slave_stream_req_sl_rd_tag : std_logic_vector(7 downto 0);
	signal stratixpcieinterface_i_rx_slave_stream_req_sl_rd_be : std_logic_vector(7 downto 0);
	signal stratixpcieinterface_i_rx_slave_stream_req_sl_rd_addr : std_logic_vector(63 downto 0);
	signal stratixpcieinterface_i_rx_slave_stream_req_sl_rd_size : std_logic_vector(9 downto 0);
	signal pcieea_i_from_switch_dst_rdy_n : std_logic_vector(0 downto 0);
	signal pcieea_i_to_switch_sop_n : std_logic_vector(0 downto 0);
	signal pcieea_i_to_switch_eop_n : std_logic_vector(0 downto 0);
	signal pcieea_i_to_switch_src_rdy_n : std_logic_vector(0 downto 0);
	signal pcieea_i_to_switch_data : std_logic_vector(31 downto 0);
	signal pcieea_i_pcie_ea_version : std_logic_vector(31 downto 0);
	signal pcieea_i_pcie_ea_empty : std_logic_vector(0 downto 0);
	signal pcieea_i_pcie_ea_fc_type : std_logic_vector(1 downto 0);
	signal pcieea_i_pcie_ea_toggle : std_logic_vector(0 downto 0);
	signal pcieea_i_pcie_ea_data : std_logic_vector(31 downto 0);
	signal pcieea_i_pcie_ea_fill : std_logic_vector(9 downto 0);
	signal pcieea_i_user_control_rst_user : std_logic_vector(0 downto 0);
	signal pcieea_i_dma_from_host_rd_clk : std_logic_vector(0 downto 0);
	signal pcieea_i_dma_from_host_rd_rst : std_logic_vector(0 downto 0);
	signal pcieea_i_dma_from_host_rd_en : std_logic_vector(0 downto 0);
	signal control_streams_rst_ctl_reset_out : std_logic_vector(0 downto 0);
	signal control_streams_rst_ctl_reset_late_pulse : std_logic_vector(0 downto 0);
	signal ftb_archange_mappedelementsswitchpcieea_dbg_empty : std_logic_vector(0 downto 0);
	signal ftb_archange_mappedelementsswitchpcieea_dbg_stall : std_logic_vector(0 downto 0);
	signal ftb_archange_mappedelementsswitchpcieea_inputstream_push_stall : std_logic_vector(0 downto 0);
	signal ftb_archange_mappedelementsswitchpcieea_outputstream_push_valid : std_logic_vector(0 downto 0);
	signal ftb_archange_mappedelementsswitchpcieea_outputstream_push_done : std_logic_vector(0 downto 0);
	signal ftb_archange_mappedelementsswitchpcieea_outputstream_push_data : std_logic_vector(63 downto 0);
	signal ftb_mappedelementsswitchpcieea_dout : std_logic_vector(33 downto 0);
	signal ftb_mappedelementsswitchpcieea_full : std_logic_vector(0 downto 0);
	signal ftb_mappedelementsswitchpcieea_empty : std_logic_vector(0 downto 0);
	signal ftb_mappedelementsswitchpcieea_wr_data_count : std_logic_vector(8 downto 0);
	signal ftb_mappedelementsswitchpcieea_prog_full : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_control_sfh_stall1 : std_logic_vector(0 downto 0);
	signal muxsel_mux_stb_stall1 : std_logic_vector(3 downto 0);
	signal muxout_mux_stb_stall : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_control_sth_valid1 : std_logic_vector(0 downto 0);
	signal muxsel_ln906_max4fpgatop1 : std_logic_vector(3 downto 0);
	signal muxout_ln906_max4fpgatop : std_logic_vector(0 downto 0);
	signal wrapper_pcie_pcie_control_sth_data1 : std_logic_vector(127 downto 0);
	signal muxsel_ln907_max4fpgatop1 : std_logic_vector(3 downto 0);
	signal muxout_ln907_max4fpgatop : std_logic_vector(33 downto 0);
	signal cat_ln910_max4fpgatop : std_logic_vector(127 downto 0);
	signal pcieea_i_reset_ext1 : std_logic_vector(0 downto 0);
	signal ftb_archange_mappedelementsswitchpcieea_inputstream_push_valid1 : std_logic_vector(0 downto 0);
	signal reg_ln220_pcieea : std_logic_vector(33 downto 0) := "0000000000000000000000000000000000";
	signal reg_ln991_max4fpgatop : std_logic_vector(33 downto 0) := "0000000000000000000000000000000000";
	signal reg_ln219_pcieea : std_logic_vector(0 downto 0) := "0";
	signal reg_ln990_max4fpgatop : std_logic_vector(0 downto 0) := "0";
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	muxsel_mux_stb_stall1 <= max4pcieslaveinterface_i_control_streams_select;
	muxproc_mux_stb_stall : process(ftb_archange_mappedelementsswitchpcieea_inputstream_push_stall, muxsel_mux_stb_stall1)
	begin
		case muxsel_mux_stb_stall1 is
			when "0001" => muxout_mux_stb_stall <= ftb_archange_mappedelementsswitchpcieea_inputstream_push_stall;
			when "0010" => muxout_mux_stb_stall <= "1";
			when "0100" => muxout_mux_stb_stall <= "1";
			when "1000" => muxout_mux_stb_stall <= "1";
			when others => 
			muxout_mux_stb_stall <= (others => 'X');
		end case;
	end process;
	wrapper_pcie_pcie_control_sfh_stall1 <= muxout_mux_stb_stall;
	muxsel_ln906_max4fpgatop1 <= max4pcieslaveinterface_i_control_streams_select;
	muxproc_ln906_max4fpgatop : process(muxsel_ln906_max4fpgatop1)
	begin
		case muxsel_ln906_max4fpgatop1 is
			when "0001" => muxout_ln906_max4fpgatop <= "0";
			when "0010" => muxout_ln906_max4fpgatop <= "0";
			when "0100" => muxout_ln906_max4fpgatop <= "0";
			when "1000" => muxout_ln906_max4fpgatop <= "0";
			when others => 
			muxout_ln906_max4fpgatop <= (others => 'X');
		end case;
	end process;
	wrapper_pcie_pcie_control_sth_valid1 <= muxout_ln906_max4fpgatop;
	muxsel_ln907_max4fpgatop1 <= max4pcieslaveinterface_i_control_streams_select;
	muxproc_ln907_max4fpgatop : process(muxsel_ln907_max4fpgatop1)
	begin
		case muxsel_ln907_max4fpgatop1 is
			when "0001" => muxout_ln907_max4fpgatop <= "0000000000000000000000000000000000";
			when "0010" => muxout_ln907_max4fpgatop <= "0000000000000000000000000000000000";
			when "0100" => muxout_ln907_max4fpgatop <= "0000000000000000000000000000000000";
			when "1000" => muxout_ln907_max4fpgatop <= "0000000000000000000000000000000000";
			when others => 
			muxout_ln907_max4fpgatop <= (others => 'X');
		end case;
	end process;
	cat_ln910_max4fpgatop<=("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" & muxout_ln907_max4fpgatop);
	wrapper_pcie_pcie_control_sth_data1 <= cat_ln910_max4fpgatop;
	pcieea_i_reset_ext1 <= (not bit_to_vec(rst_pcie_n));
	ftb_archange_mappedelementsswitchpcieea_inputstream_push_valid1 <= (slice(max4pcieslaveinterface_i_control_streams_select, 0, 1) and wrapper_pcie_pcie_control_sfh_valid);
	pll_mgmt_clk0 <= vec_to_bit(wrapper_pll_mgmt_clk0);
	pll_mgmt_rst0 <= vec_to_bit(wrapper_pll_mgmt_rst0);
	pll_mgmt_address0 <= wrapper_pll_mgmt_address0;
	pll_mgmt_read0 <= vec_to_bit(wrapper_pll_mgmt_read0);
	pll_mgmt_write0 <= vec_to_bit(wrapper_pll_mgmt_write0);
	pll_mgmt_writedata0 <= wrapper_pll_mgmt_writedata0;
	pll_rst0 <= vec_to_bit(wrapper_pll_rst0);
	clkbuf_clken0 <= vec_to_bit(wrapper_clkbuf_clken0);
	app_int_sts <= vec_to_bit(max4pcieslaveinterface_i_app_int_sts);
	app_msi_req <= vec_to_bit(max4pcieslaveinterface_i_app_msi_req);
	app_msi_num <= max4pcieslaveinterface_i_app_msi_num;
	app_msi_tc <= max4pcieslaveinterface_i_app_msi_tc;
	tx_st_valid <= vec_to_bit(stratixpcieinterface_i_tx_st_valid);
	tx_st_sop <= vec_to_bit(stratixpcieinterface_i_tx_st_sop);
	tx_st_eop <= vec_to_bit(stratixpcieinterface_i_tx_st_eop);
	tx_st_empty <= stratixpcieinterface_i_tx_st_empty;
	tx_st_err <= vec_to_bit(stratixpcieinterface_i_tx_st_err);
	tx_st_data <= stratixpcieinterface_i_tx_st_data;
	rx_st_ready <= vec_to_bit(stratixpcieinterface_i_rx_st_ready);
	rx_st_mask <= vec_to_bit(stratixpcieinterface_i_rx_st_mask);
	cpl_err <= stratixpcieinterface_i_cpl_err;
	cpl_pending <= vec_to_bit(stratixpcieinterface_i_cpl_pending);
	slave_leds <= max4pcieslaveinterface_i_leds;
	i2c_left_dimm_SCL_drv <= vec_to_bit(max4pcieslaveinterface_i_i2c_left_dimm_scl_drv);
	i2c_left_dimm_SDA_drv <= vec_to_bit(max4pcieslaveinterface_i_i2c_left_dimm_sda_drv);
	i2c_right_dimm_SCL_drv <= vec_to_bit(max4pcieslaveinterface_i_i2c_right_dimm_scl_drv);
	i2c_right_dimm_SDA_drv <= vec_to_bit(max4pcieslaveinterface_i_i2c_right_dimm_sda_drv);
	i2c_aux_SCL_drv <= vec_to_bit(max4pcieslaveinterface_i_i2c_aux_scl_drv);
	i2c_aux_SDA_drv <= vec_to_bit(max4pcieslaveinterface_i_i2c_aux_sda_drv);
	pmbus_SCL_drv <= vec_to_bit(max4pcieslaveinterface_i_pmbus_scl_drv);
	pmbus_SDA_drv <= vec_to_bit(max4pcieslaveinterface_i_pmbus_sda_drv);
	host_event_ack <= max4pcieslaveinterface_i_host_event_ack;
	config_Reconfig_Trigger <= vec_to_bit(max4pcieslaveinterface_i_config_reconfig_trigger);
	flash_control_flash_rx_addr <= vec_to_bit(max4pcieslaveinterface_i_flash_rx_addr);
	flash_control_flash_tx_d <= max4pcieslaveinterface_i_flash_tx_d;
	flash_control_flash_tx_we <= vec_to_bit(max4pcieslaveinterface_i_flash_tx_we);
	
	-- Register processes
	
	reg_process : process(clk_pcie)
	begin
		if rising_edge(clk_pcie) then
			reg_ln220_pcieea <= reg_ln991_max4fpgatop;
			reg_ln991_max4fpgatop <= slice(ftb_archange_mappedelementsswitchpcieea_outputstream_push_data, 0, 34);
			reg_ln219_pcieea <= (reg_ln990_max4fpgatop and (slice(reg_ln991_max4fpgatop, 32, 1) or slice(reg_ln991_max4fpgatop, 33, 1)));
			reg_ln990_max4fpgatop <= (slice(max4pcieslaveinterface_i_control_streams_select, 0, 1) and ftb_archange_mappedelementsswitchpcieea_outputstream_push_valid);
		end if;
	end process;
	
	-- Entity instances
	
	wrapper : FPGAWrapperEntity_Manager_CpuStream
		port map (
			pll_mgmt_clk0 => wrapper_pll_mgmt_clk0(0), -- 1 bits (out)
			pll_mgmt_rst0 => wrapper_pll_mgmt_rst0(0), -- 1 bits (out)
			pll_mgmt_address0 => wrapper_pll_mgmt_address0, -- 6 bits (out)
			pll_mgmt_read0 => wrapper_pll_mgmt_read0(0), -- 1 bits (out)
			pll_mgmt_write0 => wrapper_pll_mgmt_write0(0), -- 1 bits (out)
			pll_mgmt_writedata0 => wrapper_pll_mgmt_writedata0, -- 32 bits (out)
			pll_rst0 => wrapper_pll_rst0(0), -- 1 bits (out)
			clkbuf_clken0 => wrapper_clkbuf_clken0(0), -- 1 bits (out)
			pcie_pcie_dma_control_dma_complete_sfh => wrapper_pcie_pcie_dma_control_dma_complete_sfh, -- 32 bits (out)
			pcie_pcie_dma_control_dma_complete_sth => wrapper_pcie_pcie_dma_control_dma_complete_sth, -- 32 bits (out)
			pcie_pcie_dma_control_dma_ctl_read_data => wrapper_pcie_pcie_dma_control_dma_ctl_read_data, -- 64 bits (out)
			pcie_pcie_dmareadreq_dma_read_req => wrapper_pcie_pcie_dmareadreq_dma_read_req(0), -- 1 bits (out)
			pcie_pcie_dmareadreq_dma_read_addr => wrapper_pcie_pcie_dmareadreq_dma_read_addr, -- 64 bits (out)
			pcie_pcie_dmareadreq_dma_read_len => wrapper_pcie_pcie_dmareadreq_dma_read_len, -- 10 bits (out)
			pcie_pcie_dmareadreq_dma_read_be => wrapper_pcie_pcie_dmareadreq_dma_read_be, -- 4 bits (out)
			pcie_pcie_dmareadreq_dma_read_tag => wrapper_pcie_pcie_dmareadreq_dma_read_tag, -- 8 bits (out)
			pcie_pcie_dmareadreq_dma_read_wide_addr => wrapper_pcie_pcie_dmareadreq_dma_read_wide_addr(0), -- 1 bits (out)
			pcie_pcie_dmawritereq_req => wrapper_pcie_pcie_dmawritereq_req(0), -- 1 bits (out)
			pcie_pcie_dmawritereq_addr => wrapper_pcie_pcie_dmawritereq_addr, -- 64 bits (out)
			pcie_pcie_dmawritereq_tag => wrapper_pcie_pcie_dmawritereq_tag, -- 8 bits (out)
			pcie_pcie_dmawritereq_len => wrapper_pcie_pcie_dmawritereq_len, -- 9 bits (out)
			pcie_pcie_dmawritereq_wide_addr => wrapper_pcie_pcie_dmawritereq_wide_addr(0), -- 1 bits (out)
			pcie_pcie_dmawritereq_rddata => wrapper_pcie_pcie_dmawritereq_rddata, -- 128 bits (out)
			pcie_pcie_req_interrupt_ctl_valid => wrapper_pcie_pcie_req_interrupt_ctl_valid(0), -- 1 bits (out)
			pcie_pcie_req_interrupt_ctl_enable_id => wrapper_pcie_pcie_req_interrupt_ctl_enable_id, -- 32 bits (out)
			pcie_pcie_bar_status_tx_fifo_empty => wrapper_pcie_pcie_bar_status_tx_fifo_empty(0), -- 1 bits (out)
			pcie_pcie_slave_streaming_arb_read_compl_req => wrapper_pcie_pcie_slave_streaming_arb_read_compl_req(0), -- 1 bits (out)
			pcie_pcie_slave_streaming_arb_read_compl_metadata => wrapper_pcie_pcie_slave_streaming_arb_read_compl_metadata, -- 31 bits (out)
			pcie_pcie_slave_streaming_arb_read_compl_addr => wrapper_pcie_pcie_slave_streaming_arb_read_compl_addr, -- 7 bits (out)
			pcie_pcie_slave_streaming_arb_read_compl_size => wrapper_pcie_pcie_slave_streaming_arb_read_compl_size, -- 12 bits (out)
			pcie_pcie_slave_streaming_arb_read_compl_rem_size => wrapper_pcie_pcie_slave_streaming_arb_read_compl_rem_size, -- 12 bits (out)
			pcie_pcie_slave_streaming_arb_read_compl_data => wrapper_pcie_pcie_slave_streaming_arb_read_compl_data, -- 128 bits (out)
			pcie_pcie_slave_sfh_credits0_index => wrapper_pcie_pcie_slave_sfh_credits0_index, -- 1 bits (out)
			pcie_pcie_slave_sfh_credits0_update => wrapper_pcie_pcie_slave_sfh_credits0_update(0), -- 1 bits (out)
			pcie_pcie_slave_sfh_credits0_wrap => wrapper_pcie_pcie_slave_sfh_credits0_wrap(0), -- 1 bits (out)
			pcie_pcie_slave_sfh_credits1_index => wrapper_pcie_pcie_slave_sfh_credits1_index, -- 1 bits (out)
			pcie_pcie_slave_sfh_credits1_update => wrapper_pcie_pcie_slave_sfh_credits1_update(0), -- 1 bits (out)
			pcie_pcie_slave_sfh_credits1_wrap => wrapper_pcie_pcie_slave_sfh_credits1_wrap(0), -- 1 bits (out)
			pcie_pcie_slave_sfh_credits2_index => wrapper_pcie_pcie_slave_sfh_credits2_index, -- 1 bits (out)
			pcie_pcie_slave_sfh_credits2_update => wrapper_pcie_pcie_slave_sfh_credits2_update(0), -- 1 bits (out)
			pcie_pcie_slave_sfh_credits2_wrap => wrapper_pcie_pcie_slave_sfh_credits2_wrap(0), -- 1 bits (out)
			pcie_pcie_slave_sfh_credits3_index => wrapper_pcie_pcie_slave_sfh_credits3_index, -- 1 bits (out)
			pcie_pcie_slave_sfh_credits3_update => wrapper_pcie_pcie_slave_sfh_credits3_update(0), -- 1 bits (out)
			pcie_pcie_slave_sfh_credits3_wrap => wrapper_pcie_pcie_slave_sfh_credits3_wrap(0), -- 1 bits (out)
			pcie_pcie_slave_sfh_credits4_index => wrapper_pcie_pcie_slave_sfh_credits4_index, -- 1 bits (out)
			pcie_pcie_slave_sfh_credits4_update => wrapper_pcie_pcie_slave_sfh_credits4_update(0), -- 1 bits (out)
			pcie_pcie_slave_sfh_credits4_wrap => wrapper_pcie_pcie_slave_sfh_credits4_wrap(0), -- 1 bits (out)
			pcie_pcie_slave_sth_credits0_index => wrapper_pcie_pcie_slave_sth_credits0_index, -- 1 bits (out)
			pcie_pcie_slave_sth_credits0_update => wrapper_pcie_pcie_slave_sth_credits0_update(0), -- 1 bits (out)
			pcie_pcie_slave_sth_credits0_wrap => wrapper_pcie_pcie_slave_sth_credits0_wrap(0), -- 1 bits (out)
			pcie_pcie_slave_sth_credits1_index => wrapper_pcie_pcie_slave_sth_credits1_index, -- 1 bits (out)
			pcie_pcie_slave_sth_credits1_update => wrapper_pcie_pcie_slave_sth_credits1_update(0), -- 1 bits (out)
			pcie_pcie_slave_sth_credits1_wrap => wrapper_pcie_pcie_slave_sth_credits1_wrap(0), -- 1 bits (out)
			sfh_cap => wrapper_sfh_cap, -- 128 bits (out)
			sth_cap => wrapper_sth_cap, -- 128 bits (out)
			sfh_cap_ctrl_0 => wrapper_sfh_cap_ctrl_0, -- 8 bits (out)
			sth_cap_ctrl_0 => wrapper_sth_cap_ctrl_0, -- 8 bits (out)
			pcie_pcie_control_sfh_valid => wrapper_pcie_pcie_control_sfh_valid(0), -- 1 bits (out)
			pcie_pcie_control_sfh_done => wrapper_pcie_pcie_control_sfh_done(0), -- 1 bits (out)
			pcie_pcie_control_sfh_data => wrapper_pcie_pcie_control_sfh_data, -- 128 bits (out)
			pcie_pcie_control_sth_stall => wrapper_pcie_pcie_control_sth_stall(0), -- 1 bits (out)
			pcie_pcie_sfa_user_toggle_ack => wrapper_pcie_pcie_sfa_user_toggle_ack(0), -- 1 bits (out)
			pcie_pcie_mappedreg_reg_data_out => wrapper_pcie_pcie_mappedreg_reg_data_out, -- 32 bits (out)
			pcie_pcie_mappedreg_reg_completion_toggle => wrapper_pcie_pcie_mappedreg_reg_completion_toggle(0), -- 1 bits (out)
			pcie_pcie_mappedreg_stream_interrupt_toggle => wrapper_pcie_pcie_mappedreg_stream_interrupt_toggle, -- 16 bits (out)
			pcie_pcie_mec_fwd_write_port_SOP_N => wrapper_pcie_pcie_mec_fwd_write_port_sop_n(0), -- 1 bits (out)
			pcie_pcie_mec_fwd_write_port_EOP_N => wrapper_pcie_pcie_mec_fwd_write_port_eop_n(0), -- 1 bits (out)
			pcie_pcie_mec_fwd_write_port_SRC_RDY_N => wrapper_pcie_pcie_mec_fwd_write_port_src_rdy_n(0), -- 1 bits (out)
			pcie_pcie_mec_fwd_write_port_DATA => wrapper_pcie_pcie_mec_fwd_write_port_data, -- 32 bits (out)
			pcie_pcie_mec_fwd_read_port_DST_RDY_N => wrapper_pcie_pcie_mec_fwd_read_port_dst_rdy_n(0), -- 1 bits (out)
			pcie_pcie_mec_fwd_clocking_clk_switch => wrapper_pcie_pcie_mec_fwd_clocking_clk_switch(0), -- 1 bits (out)
			pcie_pcie_mec_fwd_clocking_rst_switch => wrapper_pcie_pcie_mec_fwd_clocking_rst_switch(0), -- 1 bits (out)
			global_global_sys_clk => sys_clk, -- 1 bits (in)
			global_global_reset_n => rst_pcie_n, -- 1 bits (in)
			global_global_cclk => cclk, -- 1 bits (in)
			pll_mgmt_readdata0 => pll_mgmt_readdata0, -- 32 bits (in)
			pll_mgmt_waitrequest0 => pll_mgmt_waitrequest0, -- 1 bits (in)
			pll_inst_locked0 => pll_inst_locked0, -- 1 bits (in)
			stream_clocks_gen_output_clk0 => stream_clocks_gen_output_clk0, -- 1 bits (in)
			stream_clocks_gen_output_clk_inv0 => stream_clocks_gen_output_clk_inv0, -- 1 bits (in)
			stream_clocks_gen_output_clk_nobuf0 => stream_clocks_gen_output_clk0, -- 1 bits (in)
			pcie_pcie_clocking_clk_pcie => clk_pcie, -- 1 bits (in)
			pcie_pcie_clocking_rst_pcie_n => rst_pcie_n, -- 1 bits (in)
			pcie_pcie_rxdma_dma_response_data => stratixpcieinterface_i_rx_dma_response_dma_response_data, -- 128 bits (in)
			pcie_pcie_rxdma_dma_response_valid => stratixpcieinterface_i_rx_dma_response_dma_response_valid, -- 2 bits (in)
			pcie_pcie_rxdma_dma_response_len => stratixpcieinterface_i_rx_dma_response_dma_response_len, -- 10 bits (in)
			pcie_pcie_rxdma_dma_response_tag => stratixpcieinterface_i_rx_dma_response_dma_response_tag, -- 8 bits (in)
			pcie_pcie_rxdma_dma_response_complete => vec_to_bit(stratixpcieinterface_i_rx_dma_response_dma_response_complete), -- 1 bits (in)
			pcie_pcie_rxdma_dma_response_ready => vec_to_bit(stratixpcieinterface_i_rx_dma_response_dma_response_ready), -- 1 bits (in)
			pcie_pcie_dma_control_dma_abort_sfh => max4pcieslaveinterface_i_dma_abort_sfh, -- 32 bits (in)
			pcie_pcie_dma_control_dma_abort_sth => max4pcieslaveinterface_i_dma_abort_sth, -- 32 bits (in)
			pcie_pcie_dma_control_dma_ctl_address => max4pcieslaveinterface_i_dma_ctl_address, -- 9 bits (in)
			pcie_pcie_dma_control_dma_ctl_data => max4pcieslaveinterface_i_dma_ctl_data, -- 64 bits (in)
			pcie_pcie_dma_control_dma_ctl_write => vec_to_bit(max4pcieslaveinterface_i_dma_ctl_write), -- 1 bits (in)
			pcie_pcie_dma_control_dma_ctl_byte_en => max4pcieslaveinterface_i_dma_ctl_byte_en, -- 8 bits (in)
			pcie_pcie_dmareadreq_dma_read_ack => vec_to_bit(stratixpcieinterface_i_tx_dma_read_dma_read_ack), -- 1 bits (in)
			pcie_pcie_dmawritereq_ack => vec_to_bit(stratixpcieinterface_i_tx_dma_write_ack), -- 1 bits (in)
			pcie_pcie_dmawritereq_done => vec_to_bit(stratixpcieinterface_i_tx_dma_write_done), -- 1 bits (in)
			pcie_pcie_dmawritereq_busy => vec_to_bit(stratixpcieinterface_i_tx_dma_write_busy), -- 1 bits (in)
			pcie_pcie_dmawritereq_rden => vec_to_bit(stratixpcieinterface_i_tx_dma_write_rden), -- 1 bits (in)
			pcie_pcie_bar_parse_wr_addr_onehot => max4pcieslaveinterface_i_bar_parse_wr_addr_onehot, -- 256 bits (in)
			pcie_pcie_bar_parse_wr_data => max4pcieslaveinterface_i_bar_parse_wr_data, -- 64 bits (in)
			pcie_pcie_bar_parse_wr_clk => vec_to_bit(max4pcieslaveinterface_i_bar_parse_wr_clk), -- 1 bits (in)
			pcie_pcie_bar_parse_wr_page_sel_onehot => max4pcieslaveinterface_i_bar_parse_wr_page_sel_onehot, -- 2 bits (in)
			pcie_pcie_slave_streaming_write_sfh_wren => max4pcieslaveinterface_i_slave_streaming_write_sfh_wren, -- 5 bits (in)
			pcie_pcie_slave_streaming_write_sfh_write_addr => max4pcieslaveinterface_i_slave_streaming_write_sfh_write_addr, -- 13 bits (in)
			pcie_pcie_slave_streaming_write_sfh_write_size => max4pcieslaveinterface_i_slave_streaming_write_sfh_write_size, -- 10 bits (in)
			pcie_pcie_slave_streaming_write_sfh_write_data => max4pcieslaveinterface_i_slave_streaming_write_sfh_write_data, -- 128 bits (in)
			pcie_pcie_slave_streaming_write_sfh_write_be => max4pcieslaveinterface_i_slave_streaming_write_sfh_write_be, -- 16 bits (in)
			pcie_pcie_slave_streaming_write_sfh_write_last => vec_to_bit(max4pcieslaveinterface_i_slave_streaming_write_sfh_write_last), -- 1 bits (in)
			pcie_pcie_slave_streaming_read_sth_rden => max4pcieslaveinterface_i_slave_streaming_read_sth_rden, -- 2 bits (in)
			pcie_pcie_slave_streaming_read_sth_read_addr => max4pcieslaveinterface_i_slave_streaming_read_sth_read_addr, -- 13 bits (in)
			pcie_pcie_slave_streaming_read_sth_read_size => max4pcieslaveinterface_i_slave_streaming_read_sth_read_size, -- 10 bits (in)
			pcie_pcie_slave_streaming_read_sth_read_metadata => max4pcieslaveinterface_i_slave_streaming_read_sth_read_metadata, -- 31 bits (in)
			pcie_pcie_slave_streaming_read_sth_read_be => max4pcieslaveinterface_i_slave_streaming_read_sth_read_be, -- 8 bits (in)
			pcie_pcie_slave_streaming_arb_read_compl_select => vec_to_bit(max4pcieslaveinterface_i_slave_streaming_arbitrated_read_compl_select), -- 1 bits (in)
			pcie_pcie_slave_streaming_arb_read_compl_rden => vec_to_bit(max4pcieslaveinterface_i_slave_streaming_arbitrated_read_compl_rden), -- 1 bits (in)
			pcie_pcie_slave_streaming_arb_read_compl_done => vec_to_bit(max4pcieslaveinterface_i_slave_streaming_arbitrated_read_compl_done), -- 1 bits (in)
			pcie_pcie_control_sfh_stall => vec_to_bit(wrapper_pcie_pcie_control_sfh_stall1), -- 1 bits (in)
			pcie_pcie_control_sth_valid => vec_to_bit(wrapper_pcie_pcie_control_sth_valid1), -- 1 bits (in)
			pcie_pcie_control_sth_done => vec_to_bit("0"), -- 1 bits (in)
			pcie_pcie_control_sth_data => wrapper_pcie_pcie_control_sth_data1, -- 128 bits (in)
			pcie_pcie_sfa_user_toggle => vec_to_bit(max4pcieslaveinterface_i_sfa_user_toggle), -- 1 bits (in)
			pcie_pcie_mappedreg_reg_addr => max4pcieslaveinterface_i_mappedreg_reg_addr, -- 24 bits (in)
			pcie_pcie_mappedreg_reg_byte_en => max4pcieslaveinterface_i_mappedreg_reg_byte_en, -- 4 bits (in)
			pcie_pcie_mappedreg_reg_data_in => max4pcieslaveinterface_i_mappedreg_reg_data_in, -- 32 bits (in)
			pcie_pcie_mappedreg_reg_write_toggle => vec_to_bit(max4pcieslaveinterface_i_mappedreg_reg_write_toggle), -- 1 bits (in)
			pcie_pcie_mappedreg_reg_read_toggle => vec_to_bit(max4pcieslaveinterface_i_mappedreg_reg_read_toggle), -- 1 bits (in)
			pcie_pcie_pcie_clocking_rst_toggle => vec_to_bit(max4pcieslaveinterface_i_pcie_clocking_rst_toggle), -- 1 bits (in)
			pcie_pcie_pcie_clocking_rst_dcm_toggle => vec_to_bit(max4pcieslaveinterface_i_pcie_clocking_rst_dcm_toggle), -- 1 bits (in)
			pcie_pcie_pcie_clocking_clk => vec_to_bit(max4pcieslaveinterface_i_pcie_clocking_clk), -- 1 bits (in)
			pcie_pcie_pcie_clocking_dcm_multdiv => max4pcieslaveinterface_i_pcie_clocking_dcm_multdiv, -- 16 bits (in)
			pcie_pcie_mec_fwd_write_port_DST_RDY_N => vec_to_bit(pcieea_i_from_switch_dst_rdy_n), -- 1 bits (in)
			pcie_pcie_mec_fwd_read_port_SOP_N => vec_to_bit(pcieea_i_to_switch_sop_n), -- 1 bits (in)
			pcie_pcie_mec_fwd_read_port_EOP_N => vec_to_bit(pcieea_i_to_switch_eop_n), -- 1 bits (in)
			pcie_pcie_mec_fwd_read_port_SRC_RDY_N => vec_to_bit(pcieea_i_to_switch_src_rdy_n), -- 1 bits (in)
			pcie_pcie_mec_fwd_read_port_DATA => pcieea_i_to_switch_data, -- 32 bits (in)
			pcie_pcie_user_control_rst_user => vec_to_bit(pcieea_i_user_control_rst_user) -- 1 bits (in)
		);
	MAX4PCIeSlaveInterface_i : MAX4PCIeSlaveInterface
		port map (
			mappedreg_reg_addr => max4pcieslaveinterface_i_mappedreg_reg_addr, -- 24 bits (out)
			mappedreg_reg_byte_en => max4pcieslaveinterface_i_mappedreg_reg_byte_en, -- 4 bits (out)
			mappedreg_reg_data_in => max4pcieslaveinterface_i_mappedreg_reg_data_in, -- 32 bits (out)
			mappedreg_reg_write_toggle => max4pcieslaveinterface_i_mappedreg_reg_write_toggle(0), -- 1 bits (out)
			mappedreg_reg_read_toggle => max4pcieslaveinterface_i_mappedreg_reg_read_toggle(0), -- 1 bits (out)
			flush => max4pcieslaveinterface_i_flush(0), -- 1 bits (out)
			leds => max4pcieslaveinterface_i_leds, -- 2 bits (out)
			soft_reset => max4pcieslaveinterface_i_soft_reset(0), -- 1 bits (out)
			throttle_limit => max4pcieslaveinterface_i_throttle_limit, -- 11 bits (out)
			pcie_clocking_rst_toggle => max4pcieslaveinterface_i_pcie_clocking_rst_toggle(0), -- 1 bits (out)
			pcie_clocking_rst_dcm_toggle => max4pcieslaveinterface_i_pcie_clocking_rst_dcm_toggle(0), -- 1 bits (out)
			pcie_clocking_clk => max4pcieslaveinterface_i_pcie_clocking_clk(0), -- 1 bits (out)
			pcie_clocking_dcm_multdiv => max4pcieslaveinterface_i_pcie_clocking_dcm_multdiv, -- 16 bits (out)
			dma_abort_sfh => max4pcieslaveinterface_i_dma_abort_sfh, -- 32 bits (out)
			dma_abort_sth => max4pcieslaveinterface_i_dma_abort_sth, -- 32 bits (out)
			dma_ctl_address => max4pcieslaveinterface_i_dma_ctl_address, -- 9 bits (out)
			dma_ctl_data => max4pcieslaveinterface_i_dma_ctl_data, -- 64 bits (out)
			dma_ctl_write => max4pcieslaveinterface_i_dma_ctl_write(0), -- 1 bits (out)
			dma_ctl_byte_en => max4pcieslaveinterface_i_dma_ctl_byte_en, -- 8 bits (out)
			rx_reg_read_compl_full => max4pcieslaveinterface_i_rx_reg_read_compl_full(0), -- 1 bits (out)
			tx_reg_compl_req => max4pcieslaveinterface_i_tx_reg_compl_req(0), -- 1 bits (out)
			tx_reg_compl_tc => max4pcieslaveinterface_i_tx_reg_compl_tc, -- 3 bits (out)
			tx_reg_compl_td => max4pcieslaveinterface_i_tx_reg_compl_td(0), -- 1 bits (out)
			tx_reg_compl_ep => max4pcieslaveinterface_i_tx_reg_compl_ep(0), -- 1 bits (out)
			tx_reg_compl_attr => max4pcieslaveinterface_i_tx_reg_compl_attr, -- 2 bits (out)
			tx_reg_compl_rid => max4pcieslaveinterface_i_tx_reg_compl_rid, -- 16 bits (out)
			tx_reg_compl_tag => max4pcieslaveinterface_i_tx_reg_compl_tag, -- 8 bits (out)
			tx_reg_compl_addr => max4pcieslaveinterface_i_tx_reg_compl_addr, -- 13 bits (out)
			tx_reg_compl_data => max4pcieslaveinterface_i_tx_reg_compl_data, -- 64 bits (out)
			tx_reg_compl_size => max4pcieslaveinterface_i_tx_reg_compl_size, -- 10 bits (out)
			app_int_sts => max4pcieslaveinterface_i_app_int_sts(0), -- 1 bits (out)
			app_msi_req => max4pcieslaveinterface_i_app_msi_req(0), -- 1 bits (out)
			app_msi_num => max4pcieslaveinterface_i_app_msi_num, -- 5 bits (out)
			app_msi_tc => max4pcieslaveinterface_i_app_msi_tc, -- 3 bits (out)
			cfg_completer_id => max4pcieslaveinterface_i_cfg_completer_id, -- 16 bits (out)
			maxring_s_fh => max4pcieslaveinterface_i_maxring_s_fh, -- 4 bits (out)
			maxring_s_set_highZ_n => max4pcieslaveinterface_i_maxring_s_set_highz_n, -- 4 bits (out)
			maxring_id_fh => max4pcieslaveinterface_i_maxring_id_fh, -- 4 bits (out)
			maxring_id_set_highZ_n => max4pcieslaveinterface_i_maxring_id_set_highz_n, -- 4 bits (out)
			i2c_left_dimm_SCL_drv => max4pcieslaveinterface_i_i2c_left_dimm_scl_drv(0), -- 1 bits (out)
			i2c_left_dimm_SDA_drv => max4pcieslaveinterface_i_i2c_left_dimm_sda_drv(0), -- 1 bits (out)
			i2c_right_dimm_SCL_drv => max4pcieslaveinterface_i_i2c_right_dimm_scl_drv(0), -- 1 bits (out)
			i2c_right_dimm_SDA_drv => max4pcieslaveinterface_i_i2c_right_dimm_sda_drv(0), -- 1 bits (out)
			i2c_aux_SCL_drv => max4pcieslaveinterface_i_i2c_aux_scl_drv(0), -- 1 bits (out)
			i2c_aux_SDA_drv => max4pcieslaveinterface_i_i2c_aux_sda_drv(0), -- 1 bits (out)
			pmbus_SCL_drv => max4pcieslaveinterface_i_pmbus_scl_drv(0), -- 1 bits (out)
			pmbus_SDA_drv => max4pcieslaveinterface_i_pmbus_sda_drv(0), -- 1 bits (out)
			host_event_ack => max4pcieslaveinterface_i_host_event_ack, -- 97 bits (out)
			config_Reconfig_Trigger => max4pcieslaveinterface_i_config_reconfig_trigger(0), -- 1 bits (out)
			flash_rx_addr => max4pcieslaveinterface_i_flash_rx_addr(0), -- 1 bits (out)
			flash_tx_d => max4pcieslaveinterface_i_flash_tx_d, -- 64 bits (out)
			flash_tx_we => max4pcieslaveinterface_i_flash_tx_we(0), -- 1 bits (out)
			ptp_phy_sresetn => max4pcieslaveinterface_i_ptp_phy_sresetn(0), -- 1 bits (out)
			compl_fifo_flags => max4pcieslaveinterface_i_compl_fifo_flags, -- 2 bits (out)
			control_streams_select => max4pcieslaveinterface_i_control_streams_select, -- 4 bits (out)
			control_streams_reset_toggle => max4pcieslaveinterface_i_control_streams_reset_toggle(0), -- 1 bits (out)
			compute_reset_n => max4pcieslaveinterface_i_compute_reset_n(0), -- 1 bits (out)
			mapped_elements_read => max4pcieslaveinterface_i_mapped_elements_read(0), -- 1 bits (out)
			mapped_elements_data_in => max4pcieslaveinterface_i_mapped_elements_data_in, -- 32 bits (out)
			mapped_elements_fc_in => max4pcieslaveinterface_i_mapped_elements_fc_in, -- 2 bits (out)
			mapped_elements_write => max4pcieslaveinterface_i_mapped_elements_write(0), -- 1 bits (out)
			mapped_elements_select_dma => max4pcieslaveinterface_i_mapped_elements_select_dma(0), -- 1 bits (out)
			mapped_elements_reset => max4pcieslaveinterface_i_mapped_elements_reset(0), -- 1 bits (out)
			local_ifpga_session_key => max4pcieslaveinterface_i_local_ifpga_session_key, -- 2 bits (out)
			bar_parse_wr_addr_onehot => max4pcieslaveinterface_i_bar_parse_wr_addr_onehot, -- 256 bits (out)
			bar_parse_wr_data => max4pcieslaveinterface_i_bar_parse_wr_data, -- 64 bits (out)
			bar_parse_wr_clk => max4pcieslaveinterface_i_bar_parse_wr_clk(0), -- 1 bits (out)
			bar_parse_wr_page_sel_onehot => max4pcieslaveinterface_i_bar_parse_wr_page_sel_onehot, -- 2 bits (out)
			sfa_user_toggle => max4pcieslaveinterface_i_sfa_user_toggle(0), -- 1 bits (out)
			slave_streaming_write_sfh_wren => max4pcieslaveinterface_i_slave_streaming_write_sfh_wren, -- 5 bits (out)
			slave_streaming_write_sfh_write_addr => max4pcieslaveinterface_i_slave_streaming_write_sfh_write_addr, -- 13 bits (out)
			slave_streaming_write_sfh_write_size => max4pcieslaveinterface_i_slave_streaming_write_sfh_write_size, -- 10 bits (out)
			slave_streaming_write_sfh_write_data => max4pcieslaveinterface_i_slave_streaming_write_sfh_write_data, -- 128 bits (out)
			slave_streaming_write_sfh_write_be => max4pcieslaveinterface_i_slave_streaming_write_sfh_write_be, -- 16 bits (out)
			slave_streaming_write_sfh_write_last => max4pcieslaveinterface_i_slave_streaming_write_sfh_write_last(0), -- 1 bits (out)
			slave_streaming_read_sth_rden => max4pcieslaveinterface_i_slave_streaming_read_sth_rden, -- 2 bits (out)
			slave_streaming_read_sth_read_addr => max4pcieslaveinterface_i_slave_streaming_read_sth_read_addr, -- 13 bits (out)
			slave_streaming_read_sth_read_size => max4pcieslaveinterface_i_slave_streaming_read_sth_read_size, -- 10 bits (out)
			slave_streaming_read_sth_read_metadata => max4pcieslaveinterface_i_slave_streaming_read_sth_read_metadata, -- 31 bits (out)
			slave_streaming_read_sth_read_be => max4pcieslaveinterface_i_slave_streaming_read_sth_read_be, -- 8 bits (out)
			tx_slave_stream_compl_req => max4pcieslaveinterface_i_tx_slave_stream_compl_req(0), -- 1 bits (out)
			tx_slave_stream_compl_tc => max4pcieslaveinterface_i_tx_slave_stream_compl_tc, -- 3 bits (out)
			tx_slave_stream_compl_td => max4pcieslaveinterface_i_tx_slave_stream_compl_td(0), -- 1 bits (out)
			tx_slave_stream_compl_ep => max4pcieslaveinterface_i_tx_slave_stream_compl_ep(0), -- 1 bits (out)
			tx_slave_stream_compl_attr => max4pcieslaveinterface_i_tx_slave_stream_compl_attr, -- 2 bits (out)
			tx_slave_stream_compl_rid => max4pcieslaveinterface_i_tx_slave_stream_compl_rid, -- 16 bits (out)
			tx_slave_stream_compl_tag => max4pcieslaveinterface_i_tx_slave_stream_compl_tag, -- 8 bits (out)
			tx_slave_stream_compl_addr => max4pcieslaveinterface_i_tx_slave_stream_compl_addr, -- 7 bits (out)
			tx_slave_stream_compl_size => max4pcieslaveinterface_i_tx_slave_stream_compl_size, -- 12 bits (out)
			tx_slave_stream_compl_rem_size => max4pcieslaveinterface_i_tx_slave_stream_compl_rem_size, -- 12 bits (out)
			tx_slave_stream_compl_data => max4pcieslaveinterface_i_tx_slave_stream_compl_data, -- 128 bits (out)
			slave_streaming_arbitrated_read_compl_select => max4pcieslaveinterface_i_slave_streaming_arbitrated_read_compl_select(0), -- 1 bits (out)
			slave_streaming_arbitrated_read_compl_rden => max4pcieslaveinterface_i_slave_streaming_arbitrated_read_compl_rden(0), -- 1 bits (out)
			slave_streaming_arbitrated_read_compl_done => max4pcieslaveinterface_i_slave_streaming_arbitrated_read_compl_done(0), -- 1 bits (out)
			clk_pcie => clk_pcie, -- 1 bits (in)
			rst_pcie_n => rst_pcie_n, -- 1 bits (in)
			mappedreg_reg_data_out => wrapper_pcie_pcie_mappedreg_reg_data_out, -- 32 bits (in)
			mappedreg_reg_completion_toggle => vec_to_bit(wrapper_pcie_pcie_mappedreg_reg_completion_toggle), -- 1 bits (in)
			mappedreg_stream_interrupt_toggle => wrapper_pcie_pcie_mappedreg_stream_interrupt_toggle, -- 16 bits (in)
			pcie_capabilities => "0000000000000000", -- 16 bits (in)
			slave_streaming_buf_cap => "00000000000000000000000000000000", -- 32 bits (in)
			dma_complete_sfh => wrapper_pcie_pcie_dma_control_dma_complete_sfh, -- 32 bits (in)
			dma_complete_sth => wrapper_pcie_pcie_dma_control_dma_complete_sth, -- 32 bits (in)
			dma_ctl_read_data => wrapper_pcie_pcie_dma_control_dma_ctl_read_data, -- 64 bits (in)
			req_interrupt_ctl_valid => vec_to_bit(wrapper_pcie_pcie_req_interrupt_ctl_valid), -- 1 bits (in)
			req_interrupt_ctl_enable_id => wrapper_pcie_pcie_req_interrupt_ctl_enable_id, -- 32 bits (in)
			reg_data_out => stratixpcieinterface_i_rx_reg_write_reg_data_out, -- 64 bits (in)
			reg_data_wren => stratixpcieinterface_i_rx_reg_write_reg_data_wren, -- 8 bits (in)
			reg_data_addr => stratixpcieinterface_i_rx_reg_write_reg_data_addr, -- 64 bits (in)
			reg_data_bar0 => vec_to_bit(stratixpcieinterface_i_rx_reg_write_reg_data_bar0), -- 1 bits (in)
			reg_data_bar2 => vec_to_bit(stratixpcieinterface_i_rx_reg_write_reg_data_bar2), -- 1 bits (in)
			rx_reg_read_compl_tc => stratixpcieinterface_i_rx_reg_read_compl_tc, -- 3 bits (in)
			rx_reg_read_compl_td => vec_to_bit(stratixpcieinterface_i_rx_reg_read_compl_td), -- 1 bits (in)
			rx_reg_read_compl_ep => vec_to_bit(stratixpcieinterface_i_rx_reg_read_compl_ep), -- 1 bits (in)
			rx_reg_read_compl_attr => stratixpcieinterface_i_rx_reg_read_compl_attr, -- 2 bits (in)
			rx_reg_read_compl_rid => stratixpcieinterface_i_rx_reg_read_compl_rid, -- 16 bits (in)
			rx_reg_read_compl_tag => stratixpcieinterface_i_rx_reg_read_compl_tag, -- 8 bits (in)
			rx_reg_read_compl_addr => stratixpcieinterface_i_rx_reg_read_compl_addr, -- 64 bits (in)
			rx_reg_read_compl_bar2 => vec_to_bit(stratixpcieinterface_i_rx_reg_read_compl_bar2), -- 1 bits (in)
			rx_reg_read_compl_req => vec_to_bit(stratixpcieinterface_i_rx_reg_read_compl_req), -- 1 bits (in)
			rx_reg_read_compl_size => stratixpcieinterface_i_rx_reg_read_compl_size, -- 10 bits (in)
			tx_reg_compl_rden => vec_to_bit(stratixpcieinterface_i_tx_reg_compl_rden), -- 1 bits (in)
			tx_reg_compl_ack => vec_to_bit(stratixpcieinterface_i_tx_reg_compl_ack), -- 1 bits (in)
			app_int_ack => app_int_ack, -- 1 bits (in)
			app_msi_ack => app_msi_ack, -- 1 bits (in)
			tl_cfg_ctl => tl_cfg_ctl, -- 32 bits (in)
			tl_cfg_add => tl_cfg_add, -- 4 bits (in)
			ltssmstate => ltssmstate, -- 5 bits (in)
			maxring_s_th => "1111", -- 4 bits (in)
			maxring_id_th => "1111", -- 4 bits (in)
			maxring_prsn_th => vec_to_bit("1"), -- 1 bits (in)
			maxring_type_th => "11", -- 2 bits (in)
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
			flash_rx_d => flash_control_flash_rx_d, -- 64 bits (in)
			mapped_elements_version => pcieea_i_pcie_ea_version, -- 32 bits (in)
			mapped_elements_empty => vec_to_bit(pcieea_i_pcie_ea_empty), -- 1 bits (in)
			mapped_elements_fc_type => pcieea_i_pcie_ea_fc_type, -- 2 bits (in)
			mapped_elements_toggle => vec_to_bit(pcieea_i_pcie_ea_toggle), -- 1 bits (in)
			mapped_elements_data => pcieea_i_pcie_ea_data, -- 32 bits (in)
			mapped_elements_fill => pcieea_i_pcie_ea_fill, -- 10 bits (in)
			bar_status_tx_fifo_empty => vec_to_bit(wrapper_pcie_pcie_bar_status_tx_fifo_empty), -- 1 bits (in)
			sfa_user_toggle_ack => vec_to_bit(wrapper_pcie_pcie_sfa_user_toggle_ack), -- 1 bits (in)
			slave_sfh_card_credits0_index => wrapper_pcie_pcie_slave_sfh_credits0_index, -- 1 bits (in)
			slave_sfh_card_credits0_update => vec_to_bit(wrapper_pcie_pcie_slave_sfh_credits0_update), -- 1 bits (in)
			slave_sfh_card_credits0_wrap => vec_to_bit(wrapper_pcie_pcie_slave_sfh_credits0_wrap), -- 1 bits (in)
			slave_sfh_card_credits1_index => wrapper_pcie_pcie_slave_sfh_credits1_index, -- 1 bits (in)
			slave_sfh_card_credits1_update => vec_to_bit(wrapper_pcie_pcie_slave_sfh_credits1_update), -- 1 bits (in)
			slave_sfh_card_credits1_wrap => vec_to_bit(wrapper_pcie_pcie_slave_sfh_credits1_wrap), -- 1 bits (in)
			slave_sfh_card_credits2_index => wrapper_pcie_pcie_slave_sfh_credits2_index, -- 1 bits (in)
			slave_sfh_card_credits2_update => vec_to_bit(wrapper_pcie_pcie_slave_sfh_credits2_update), -- 1 bits (in)
			slave_sfh_card_credits2_wrap => vec_to_bit(wrapper_pcie_pcie_slave_sfh_credits2_wrap), -- 1 bits (in)
			slave_sfh_card_credits3_index => wrapper_pcie_pcie_slave_sfh_credits3_index, -- 1 bits (in)
			slave_sfh_card_credits3_update => vec_to_bit(wrapper_pcie_pcie_slave_sfh_credits3_update), -- 1 bits (in)
			slave_sfh_card_credits3_wrap => vec_to_bit(wrapper_pcie_pcie_slave_sfh_credits3_wrap), -- 1 bits (in)
			slave_sfh_card_credits4_index => wrapper_pcie_pcie_slave_sfh_credits4_index, -- 1 bits (in)
			slave_sfh_card_credits4_update => vec_to_bit(wrapper_pcie_pcie_slave_sfh_credits4_update), -- 1 bits (in)
			slave_sfh_card_credits4_wrap => vec_to_bit(wrapper_pcie_pcie_slave_sfh_credits4_wrap), -- 1 bits (in)
			slave_sth_card_credits0_index => wrapper_pcie_pcie_slave_sth_credits0_index, -- 1 bits (in)
			slave_sth_card_credits0_update => vec_to_bit(wrapper_pcie_pcie_slave_sth_credits0_update), -- 1 bits (in)
			slave_sth_card_credits0_wrap => vec_to_bit(wrapper_pcie_pcie_slave_sth_credits0_wrap), -- 1 bits (in)
			slave_sth_card_credits1_index => wrapper_pcie_pcie_slave_sth_credits1_index, -- 1 bits (in)
			slave_sth_card_credits1_update => vec_to_bit(wrapper_pcie_pcie_slave_sth_credits1_update), -- 1 bits (in)
			slave_sth_card_credits1_wrap => vec_to_bit(wrapper_pcie_pcie_slave_sth_credits1_wrap), -- 1 bits (in)
			rx_slave_stream_req_sl_en => vec_to_bit(stratixpcieinterface_i_rx_slave_stream_req_sl_en), -- 1 bits (in)
			rx_slave_stream_req_sl_wr_en => vec_to_bit(stratixpcieinterface_i_rx_slave_stream_req_sl_wr_en), -- 1 bits (in)
			rx_slave_stream_req_sl_wr_addr => stratixpcieinterface_i_rx_slave_stream_req_sl_wr_addr, -- 64 bits (in)
			rx_slave_stream_req_sl_wr_size => stratixpcieinterface_i_rx_slave_stream_req_sl_wr_size, -- 10 bits (in)
			rx_slave_stream_req_sl_wr_data => stratixpcieinterface_i_rx_slave_stream_req_sl_wr_data, -- 128 bits (in)
			rx_slave_stream_req_sl_wr_be => stratixpcieinterface_i_rx_slave_stream_req_sl_wr_be, -- 16 bits (in)
			rx_slave_stream_req_sl_wr_last => vec_to_bit(stratixpcieinterface_i_rx_slave_stream_req_sl_wr_last), -- 1 bits (in)
			rx_slave_stream_req_sl_rd_en => vec_to_bit(stratixpcieinterface_i_rx_slave_stream_req_sl_rd_en), -- 1 bits (in)
			rx_slave_stream_req_sl_rd_tc => stratixpcieinterface_i_rx_slave_stream_req_sl_rd_tc, -- 3 bits (in)
			rx_slave_stream_req_sl_rd_td => vec_to_bit(stratixpcieinterface_i_rx_slave_stream_req_sl_rd_td), -- 1 bits (in)
			rx_slave_stream_req_sl_rd_ep => vec_to_bit(stratixpcieinterface_i_rx_slave_stream_req_sl_rd_ep), -- 1 bits (in)
			rx_slave_stream_req_sl_rd_attr => stratixpcieinterface_i_rx_slave_stream_req_sl_rd_attr, -- 2 bits (in)
			rx_slave_stream_req_sl_rd_rid => stratixpcieinterface_i_rx_slave_stream_req_sl_rd_rid, -- 16 bits (in)
			rx_slave_stream_req_sl_rd_tag => stratixpcieinterface_i_rx_slave_stream_req_sl_rd_tag, -- 8 bits (in)
			rx_slave_stream_req_sl_rd_be => stratixpcieinterface_i_rx_slave_stream_req_sl_rd_be, -- 8 bits (in)
			rx_slave_stream_req_sl_rd_addr => stratixpcieinterface_i_rx_slave_stream_req_sl_rd_addr, -- 64 bits (in)
			rx_slave_stream_req_sl_rd_size => stratixpcieinterface_i_rx_slave_stream_req_sl_rd_size, -- 10 bits (in)
			sth_cap_ctrl_0 => wrapper_sth_cap_ctrl_0, -- 8 bits (in)
			sfh_cap_ctrl_0 => wrapper_sfh_cap_ctrl_0, -- 8 bits (in)
			sth_cap => wrapper_sth_cap, -- 128 bits (in)
			sfh_cap => wrapper_sfh_cap, -- 128 bits (in)
			tx_slave_stream_compl_ack => vec_to_bit(stratixpcieinterface_i_tx_slave_stream_compl_ack), -- 1 bits (in)
			tx_slave_stream_compl_rden => vec_to_bit(stratixpcieinterface_i_tx_slave_stream_compl_rden), -- 1 bits (in)
			tx_slave_stream_compl_done => vec_to_bit(stratixpcieinterface_i_tx_slave_stream_compl_done), -- 1 bits (in)
			slave_streaming_arbitrated_read_compl_req => vec_to_bit(wrapper_pcie_pcie_slave_streaming_arb_read_compl_req), -- 1 bits (in)
			slave_streaming_arbitrated_read_compl_metadata => wrapper_pcie_pcie_slave_streaming_arb_read_compl_metadata, -- 31 bits (in)
			slave_streaming_arbitrated_read_compl_addr => wrapper_pcie_pcie_slave_streaming_arb_read_compl_addr, -- 7 bits (in)
			slave_streaming_arbitrated_read_compl_size => wrapper_pcie_pcie_slave_streaming_arb_read_compl_size, -- 12 bits (in)
			slave_streaming_arbitrated_read_compl_rem_size => wrapper_pcie_pcie_slave_streaming_arb_read_compl_rem_size, -- 12 bits (in)
			slave_streaming_arbitrated_read_compl_data => wrapper_pcie_pcie_slave_streaming_arb_read_compl_data -- 128 bits (in)
		);
	StratixPCIeInterface_i : StratixPCIeInterface
		port map (
			tx_st_valid => stratixpcieinterface_i_tx_st_valid(0), -- 1 bits (out)
			tx_st_sop => stratixpcieinterface_i_tx_st_sop(0), -- 1 bits (out)
			tx_st_eop => stratixpcieinterface_i_tx_st_eop(0), -- 1 bits (out)
			tx_st_empty => stratixpcieinterface_i_tx_st_empty, -- 2 bits (out)
			tx_st_err => stratixpcieinterface_i_tx_st_err(0), -- 1 bits (out)
			tx_st_data => stratixpcieinterface_i_tx_st_data, -- 128 bits (out)
			tx_dma_write_ack => stratixpcieinterface_i_tx_dma_write_ack(0), -- 1 bits (out)
			tx_dma_write_done => stratixpcieinterface_i_tx_dma_write_done(0), -- 1 bits (out)
			tx_dma_write_busy => stratixpcieinterface_i_tx_dma_write_busy(0), -- 1 bits (out)
			tx_dma_write_rden => stratixpcieinterface_i_tx_dma_write_rden(0), -- 1 bits (out)
			tx_dma_read_dma_read_ack => stratixpcieinterface_i_tx_dma_read_dma_read_ack(0), -- 1 bits (out)
			tx_reg_compl_rden => stratixpcieinterface_i_tx_reg_compl_rden(0), -- 1 bits (out)
			tx_reg_compl_ack => stratixpcieinterface_i_tx_reg_compl_ack(0), -- 1 bits (out)
			tx_slave_stream_compl_ack => stratixpcieinterface_i_tx_slave_stream_compl_ack(0), -- 1 bits (out)
			tx_slave_stream_compl_rden => stratixpcieinterface_i_tx_slave_stream_compl_rden(0), -- 1 bits (out)
			tx_slave_stream_compl_done => stratixpcieinterface_i_tx_slave_stream_compl_done(0), -- 1 bits (out)
			rx_st_ready => stratixpcieinterface_i_rx_st_ready(0), -- 1 bits (out)
			rx_st_mask => stratixpcieinterface_i_rx_st_mask(0), -- 1 bits (out)
			cpl_err => stratixpcieinterface_i_cpl_err, -- 7 bits (out)
			cpl_pending => stratixpcieinterface_i_cpl_pending(0), -- 1 bits (out)
			rx_dma_response_dma_response_data => stratixpcieinterface_i_rx_dma_response_dma_response_data, -- 128 bits (out)
			rx_dma_response_dma_response_valid => stratixpcieinterface_i_rx_dma_response_dma_response_valid, -- 2 bits (out)
			rx_dma_response_dma_response_len => stratixpcieinterface_i_rx_dma_response_dma_response_len, -- 10 bits (out)
			rx_dma_response_dma_response_tag => stratixpcieinterface_i_rx_dma_response_dma_response_tag, -- 8 bits (out)
			rx_dma_response_dma_response_complete => stratixpcieinterface_i_rx_dma_response_dma_response_complete(0), -- 1 bits (out)
			rx_dma_response_dma_response_ready => stratixpcieinterface_i_rx_dma_response_dma_response_ready(0), -- 1 bits (out)
			rx_reg_write_reg_data_out => stratixpcieinterface_i_rx_reg_write_reg_data_out, -- 64 bits (out)
			rx_reg_write_reg_data_wren => stratixpcieinterface_i_rx_reg_write_reg_data_wren, -- 8 bits (out)
			rx_reg_write_reg_data_addr => stratixpcieinterface_i_rx_reg_write_reg_data_addr, -- 64 bits (out)
			rx_reg_write_reg_data_bar0 => stratixpcieinterface_i_rx_reg_write_reg_data_bar0(0), -- 1 bits (out)
			rx_reg_write_reg_data_bar2 => stratixpcieinterface_i_rx_reg_write_reg_data_bar2(0), -- 1 bits (out)
			rx_reg_read_compl_tc => stratixpcieinterface_i_rx_reg_read_compl_tc, -- 3 bits (out)
			rx_reg_read_compl_td => stratixpcieinterface_i_rx_reg_read_compl_td(0), -- 1 bits (out)
			rx_reg_read_compl_ep => stratixpcieinterface_i_rx_reg_read_compl_ep(0), -- 1 bits (out)
			rx_reg_read_compl_attr => stratixpcieinterface_i_rx_reg_read_compl_attr, -- 2 bits (out)
			rx_reg_read_compl_rid => stratixpcieinterface_i_rx_reg_read_compl_rid, -- 16 bits (out)
			rx_reg_read_compl_tag => stratixpcieinterface_i_rx_reg_read_compl_tag, -- 8 bits (out)
			rx_reg_read_compl_addr => stratixpcieinterface_i_rx_reg_read_compl_addr, -- 64 bits (out)
			rx_reg_read_compl_bar2 => stratixpcieinterface_i_rx_reg_read_compl_bar2(0), -- 1 bits (out)
			rx_reg_read_compl_req => stratixpcieinterface_i_rx_reg_read_compl_req(0), -- 1 bits (out)
			rx_reg_read_compl_size => stratixpcieinterface_i_rx_reg_read_compl_size, -- 10 bits (out)
			rx_slave_stream_req_sl_en => stratixpcieinterface_i_rx_slave_stream_req_sl_en(0), -- 1 bits (out)
			rx_slave_stream_req_sl_wr_en => stratixpcieinterface_i_rx_slave_stream_req_sl_wr_en(0), -- 1 bits (out)
			rx_slave_stream_req_sl_wr_addr => stratixpcieinterface_i_rx_slave_stream_req_sl_wr_addr, -- 64 bits (out)
			rx_slave_stream_req_sl_wr_size => stratixpcieinterface_i_rx_slave_stream_req_sl_wr_size, -- 10 bits (out)
			rx_slave_stream_req_sl_wr_data => stratixpcieinterface_i_rx_slave_stream_req_sl_wr_data, -- 128 bits (out)
			rx_slave_stream_req_sl_wr_be => stratixpcieinterface_i_rx_slave_stream_req_sl_wr_be, -- 16 bits (out)
			rx_slave_stream_req_sl_wr_last => stratixpcieinterface_i_rx_slave_stream_req_sl_wr_last(0), -- 1 bits (out)
			rx_slave_stream_req_sl_rd_en => stratixpcieinterface_i_rx_slave_stream_req_sl_rd_en(0), -- 1 bits (out)
			rx_slave_stream_req_sl_rd_tc => stratixpcieinterface_i_rx_slave_stream_req_sl_rd_tc, -- 3 bits (out)
			rx_slave_stream_req_sl_rd_td => stratixpcieinterface_i_rx_slave_stream_req_sl_rd_td(0), -- 1 bits (out)
			rx_slave_stream_req_sl_rd_ep => stratixpcieinterface_i_rx_slave_stream_req_sl_rd_ep(0), -- 1 bits (out)
			rx_slave_stream_req_sl_rd_attr => stratixpcieinterface_i_rx_slave_stream_req_sl_rd_attr, -- 2 bits (out)
			rx_slave_stream_req_sl_rd_rid => stratixpcieinterface_i_rx_slave_stream_req_sl_rd_rid, -- 16 bits (out)
			rx_slave_stream_req_sl_rd_tag => stratixpcieinterface_i_rx_slave_stream_req_sl_rd_tag, -- 8 bits (out)
			rx_slave_stream_req_sl_rd_be => stratixpcieinterface_i_rx_slave_stream_req_sl_rd_be, -- 8 bits (out)
			rx_slave_stream_req_sl_rd_addr => stratixpcieinterface_i_rx_slave_stream_req_sl_rd_addr, -- 64 bits (out)
			rx_slave_stream_req_sl_rd_size => stratixpcieinterface_i_rx_slave_stream_req_sl_rd_size, -- 10 bits (out)
			clk_pcie => clk_pcie, -- 1 bits (in)
			rst_pcie_n => rst_pcie_n, -- 1 bits (in)
			tx_st_ready => tx_st_ready, -- 1 bits (in)
			cfg_completer_id => max4pcieslaveinterface_i_cfg_completer_id, -- 16 bits (in)
			tx_dma_write_req => vec_to_bit(wrapper_pcie_pcie_dmawritereq_req), -- 1 bits (in)
			tx_dma_write_addr => wrapper_pcie_pcie_dmawritereq_addr, -- 64 bits (in)
			tx_dma_write_tag => wrapper_pcie_pcie_dmawritereq_tag, -- 8 bits (in)
			tx_dma_write_len => wrapper_pcie_pcie_dmawritereq_len, -- 9 bits (in)
			tx_dma_write_wide_addr => vec_to_bit(wrapper_pcie_pcie_dmawritereq_wide_addr), -- 1 bits (in)
			tx_dma_write_rddata => wrapper_pcie_pcie_dmawritereq_rddata, -- 128 bits (in)
			tx_dma_read_dma_read_req => vec_to_bit(wrapper_pcie_pcie_dmareadreq_dma_read_req), -- 1 bits (in)
			tx_dma_read_dma_read_addr => wrapper_pcie_pcie_dmareadreq_dma_read_addr, -- 64 bits (in)
			tx_dma_read_dma_read_len => wrapper_pcie_pcie_dmareadreq_dma_read_len, -- 10 bits (in)
			tx_dma_read_dma_read_be => wrapper_pcie_pcie_dmareadreq_dma_read_be, -- 4 bits (in)
			tx_dma_read_dma_read_tag => wrapper_pcie_pcie_dmareadreq_dma_read_tag, -- 8 bits (in)
			tx_dma_read_dma_read_wide_addr => vec_to_bit(wrapper_pcie_pcie_dmareadreq_dma_read_wide_addr), -- 1 bits (in)
			tx_reg_compl_req => vec_to_bit(max4pcieslaveinterface_i_tx_reg_compl_req), -- 1 bits (in)
			tx_reg_compl_tc => max4pcieslaveinterface_i_tx_reg_compl_tc, -- 3 bits (in)
			tx_reg_compl_td => vec_to_bit(max4pcieslaveinterface_i_tx_reg_compl_td), -- 1 bits (in)
			tx_reg_compl_ep => vec_to_bit(max4pcieslaveinterface_i_tx_reg_compl_ep), -- 1 bits (in)
			tx_reg_compl_attr => max4pcieslaveinterface_i_tx_reg_compl_attr, -- 2 bits (in)
			tx_reg_compl_rid => max4pcieslaveinterface_i_tx_reg_compl_rid, -- 16 bits (in)
			tx_reg_compl_tag => max4pcieslaveinterface_i_tx_reg_compl_tag, -- 8 bits (in)
			tx_reg_compl_addr => max4pcieslaveinterface_i_tx_reg_compl_addr, -- 13 bits (in)
			tx_reg_compl_data => max4pcieslaveinterface_i_tx_reg_compl_data, -- 64 bits (in)
			tx_reg_compl_size => max4pcieslaveinterface_i_tx_reg_compl_size, -- 10 bits (in)
			tx_slave_stream_compl_req => vec_to_bit(max4pcieslaveinterface_i_tx_slave_stream_compl_req), -- 1 bits (in)
			tx_slave_stream_compl_tc => max4pcieslaveinterface_i_tx_slave_stream_compl_tc, -- 3 bits (in)
			tx_slave_stream_compl_td => vec_to_bit(max4pcieslaveinterface_i_tx_slave_stream_compl_td), -- 1 bits (in)
			tx_slave_stream_compl_ep => vec_to_bit(max4pcieslaveinterface_i_tx_slave_stream_compl_ep), -- 1 bits (in)
			tx_slave_stream_compl_attr => max4pcieslaveinterface_i_tx_slave_stream_compl_attr, -- 2 bits (in)
			tx_slave_stream_compl_rid => max4pcieslaveinterface_i_tx_slave_stream_compl_rid, -- 16 bits (in)
			tx_slave_stream_compl_tag => max4pcieslaveinterface_i_tx_slave_stream_compl_tag, -- 8 bits (in)
			tx_slave_stream_compl_addr => max4pcieslaveinterface_i_tx_slave_stream_compl_addr, -- 7 bits (in)
			tx_slave_stream_compl_size => max4pcieslaveinterface_i_tx_slave_stream_compl_size, -- 12 bits (in)
			tx_slave_stream_compl_rem_size => max4pcieslaveinterface_i_tx_slave_stream_compl_rem_size, -- 12 bits (in)
			tx_slave_stream_compl_data => max4pcieslaveinterface_i_tx_slave_stream_compl_data, -- 128 bits (in)
			rx_st_valid => rx_st_valid, -- 1 bits (in)
			rx_st_sop => rx_st_sop, -- 1 bits (in)
			rx_st_eop => rx_st_eop, -- 1 bits (in)
			rx_st_empty => rx_st_empty, -- 2 bits (in)
			rx_st_err => rx_st_err, -- 1 bits (in)
			rx_st_bar => rx_st_bar, -- 8 bits (in)
			rx_st_data => rx_st_data, -- 128 bits (in)
			rx_reg_read_compl_full => vec_to_bit(max4pcieslaveinterface_i_rx_reg_read_compl_full) -- 1 bits (in)
		);
	PCIeEA_i : PCIeEA
		port map (
			FROM_SWITCH_DST_RDY_N => pcieea_i_from_switch_dst_rdy_n(0), -- 1 bits (out)
			TO_SWITCH_SOP_N => pcieea_i_to_switch_sop_n(0), -- 1 bits (out)
			TO_SWITCH_EOP_N => pcieea_i_to_switch_eop_n(0), -- 1 bits (out)
			TO_SWITCH_SRC_RDY_N => pcieea_i_to_switch_src_rdy_n(0), -- 1 bits (out)
			TO_SWITCH_DATA => pcieea_i_to_switch_data, -- 32 bits (out)
			pcie_ea_version => pcieea_i_pcie_ea_version, -- 32 bits (out)
			pcie_ea_empty => pcieea_i_pcie_ea_empty(0), -- 1 bits (out)
			pcie_ea_fc_type => pcieea_i_pcie_ea_fc_type, -- 2 bits (out)
			pcie_ea_toggle => pcieea_i_pcie_ea_toggle(0), -- 1 bits (out)
			pcie_ea_data => pcieea_i_pcie_ea_data, -- 32 bits (out)
			pcie_ea_fill => pcieea_i_pcie_ea_fill, -- 10 bits (out)
			user_control_rst_user => pcieea_i_user_control_rst_user(0), -- 1 bits (out)
			dma_from_host_rd_clk => pcieea_i_dma_from_host_rd_clk(0), -- 1 bits (out)
			dma_from_host_rd_rst => pcieea_i_dma_from_host_rd_rst(0), -- 1 bits (out)
			dma_from_host_rd_en => pcieea_i_dma_from_host_rd_en(0), -- 1 bits (out)
			clk_switch => vec_to_bit(wrapper_pcie_pcie_mec_fwd_clocking_clk_switch), -- 1 bits (in)
			rst_switch => vec_to_bit(wrapper_pcie_pcie_mec_fwd_clocking_rst_switch), -- 1 bits (in)
			FROM_SWITCH_SOP_N => vec_to_bit(wrapper_pcie_pcie_mec_fwd_write_port_sop_n), -- 1 bits (in)
			FROM_SWITCH_EOP_N => vec_to_bit(wrapper_pcie_pcie_mec_fwd_write_port_eop_n), -- 1 bits (in)
			FROM_SWITCH_SRC_RDY_N => vec_to_bit(wrapper_pcie_pcie_mec_fwd_write_port_src_rdy_n), -- 1 bits (in)
			FROM_SWITCH_DATA => wrapper_pcie_pcie_mec_fwd_write_port_data, -- 32 bits (in)
			TO_SWITCH_DST_RDY_N => vec_to_bit(wrapper_pcie_pcie_mec_fwd_read_port_dst_rdy_n), -- 1 bits (in)
			clk_pcie => clk_pcie, -- 1 bits (in)
			rst_pcie_n => rst_pcie_n, -- 1 bits (in)
			pcie_ea_read => vec_to_bit(max4pcieslaveinterface_i_mapped_elements_read), -- 1 bits (in)
			pcie_ea_data_in => max4pcieslaveinterface_i_mapped_elements_data_in, -- 32 bits (in)
			pcie_ea_fc_in => max4pcieslaveinterface_i_mapped_elements_fc_in, -- 2 bits (in)
			pcie_ea_write => vec_to_bit(max4pcieslaveinterface_i_mapped_elements_write), -- 1 bits (in)
			pcie_ea_select_dma => vec_to_bit(max4pcieslaveinterface_i_mapped_elements_select_dma), -- 1 bits (in)
			pcie_ea_reset => vec_to_bit(max4pcieslaveinterface_i_mapped_elements_reset), -- 1 bits (in)
			reset_ext => vec_to_bit(pcieea_i_reset_ext1), -- 1 bits (in)
			dma_from_host_data => ftb_mappedelementsswitchpcieea_dout, -- 34 bits (in)
			dma_from_host_empty => vec_to_bit(ftb_mappedelementsswitchpcieea_empty) -- 1 bits (in)
		);
	control_streams_rst_ctl : reset_control
		generic map (
			LOG2_RESET_CYCLES => 5
		)
		port map (
			reset_out => control_streams_rst_ctl_reset_out(0), -- 1 bits (out)
			reset_late_pulse => control_streams_rst_ctl_reset_late_pulse(0), -- 1 bits (out)
			rst_n => rst_pcie_n, -- 1 bits (in)
			reset_clk => clk_pcie, -- 1 bits (in)
			reset_toggle => vec_to_bit(max4pcieslaveinterface_i_control_streams_reset_toggle) -- 1 bits (in)
		);
	ftb_ARChange_MappedElementsSwitchPCIeEA : StreamFifo_altera_128_64_128_pushin_sl16_pushout_singleclock
		port map (
			dbg_empty => ftb_archange_mappedelementsswitchpcieea_dbg_empty(0), -- 1 bits (out)
			dbg_stall => ftb_archange_mappedelementsswitchpcieea_dbg_stall(0), -- 1 bits (out)
			inputstream_push_stall => ftb_archange_mappedelementsswitchpcieea_inputstream_push_stall(0), -- 1 bits (out)
			outputstream_push_valid => ftb_archange_mappedelementsswitchpcieea_outputstream_push_valid(0), -- 1 bits (out)
			outputstream_push_done => ftb_archange_mappedelementsswitchpcieea_outputstream_push_done(0), -- 1 bits (out)
			outputstream_push_data => ftb_archange_mappedelementsswitchpcieea_outputstream_push_data, -- 64 bits (out)
			clk => clk_pcie, -- 1 bits (in)
			rst => vec_to_bit(control_streams_rst_ctl_reset_out), -- 1 bits (in)
			rst_delayed => vec_to_bit(control_streams_rst_ctl_reset_late_pulse), -- 1 bits (in)
			inputstream_push_valid => vec_to_bit(ftb_archange_mappedelementsswitchpcieea_inputstream_push_valid1), -- 1 bits (in)
			inputstream_push_done => vec_to_bit("0"), -- 1 bits (in)
			inputstream_push_data => wrapper_pcie_pcie_control_sfh_data, -- 128 bits (in)
			outputstream_push_stall => vec_to_bit(ftb_mappedelementsswitchpcieea_prog_full) -- 1 bits (in)
		);
	ftb_MappedElementsSwitchPCIeEA : AlteraFifoEntity_34_512_34_dualclock_aclr_wrusedw_fwft_pfv495
		port map (
			dout => ftb_mappedelementsswitchpcieea_dout, -- 34 bits (out)
			full => ftb_mappedelementsswitchpcieea_full(0), -- 1 bits (out)
			empty => ftb_mappedelementsswitchpcieea_empty(0), -- 1 bits (out)
			wr_data_count => ftb_mappedelementsswitchpcieea_wr_data_count, -- 9 bits (out)
			prog_full => ftb_mappedelementsswitchpcieea_prog_full(0), -- 1 bits (out)
			wr_clk => clk_pcie, -- 1 bits (in)
			rd_clk => vec_to_bit(pcieea_i_dma_from_host_rd_clk), -- 1 bits (in)
			din => reg_ln220_pcieea, -- 34 bits (in)
			wr_en => vec_to_bit(reg_ln219_pcieea), -- 1 bits (in)
			rd_en => vec_to_bit(pcieea_i_dma_from_host_rd_en), -- 1 bits (in)
			rst => vec_to_bit(pcieea_i_dma_from_host_rd_rst) -- 1 bits (in)
		);
end MaxDC;
