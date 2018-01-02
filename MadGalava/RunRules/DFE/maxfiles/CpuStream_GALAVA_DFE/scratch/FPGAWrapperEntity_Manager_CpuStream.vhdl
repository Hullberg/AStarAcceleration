library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity FPGAWrapperEntity_Manager_CpuStream is
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
end FPGAWrapperEntity_Manager_CpuStream;

architecture MaxDC of FPGAWrapperEntity_Manager_CpuStream is
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
	component SanityBlock_cclk_STREAM_clk_pcie is
		port (
			register_clk: in std_logic;
			register_in: in std_logic_vector(7 downto 0);
			register_rotate: in std_logic;
			register_stop: in std_logic;
			register_switch: in std_logic;
			rst_async: in std_logic;
			reset_n: in std_logic;
			clk_reset_n: in std_logic;
			crash_input: in std_logic;
			clk_crash_input: in std_logic;
			cclk: in std_logic;
			STREAM: in std_logic;
			clk_pcie: in std_logic;
			STREAM_rst: in std_logic;
			clk_STREAM_rst: in std_logic;
			STREAM_rst_delay: in std_logic;
			clk_STREAM_rst_delay: in std_logic;
			PCIE_rst: in std_logic;
			clk_PCIE_rst: in std_logic;
			PCIE_rst_delay: in std_logic;
			clk_PCIE_rst_delay: in std_logic;
			register_out: out std_logic_vector(7 downto 0)
		);
	end component;
	component MappedClockControl_id_3e is
		port (
			cclk: in std_logic;
			rst: in std_logic;
			memories_data_in: in std_logic_vector(35 downto 0);
			memories_memid: in std_logic_vector(15 downto 0);
			memories_memaddr: in std_logic_vector(15 downto 0);
			memories_wren: in std_logic;
			memories_rden: in std_logic;
			memories_stop: in std_logic;
			pll_mgmt_readdata0: in std_logic_vector(31 downto 0);
			pll_mgmt_waitrequest0: in std_logic;
			pll_inst_locked0: in std_logic;
			memories_data_out: out std_logic_vector(35 downto 0);
			memories_ack: out std_logic;
			pll_mgmt_clk0: out std_logic;
			pll_mgmt_rst0: out std_logic;
			pll_mgmt_address0: out std_logic_vector(5 downto 0);
			pll_mgmt_read0: out std_logic;
			pll_mgmt_write0: out std_logic;
			pll_mgmt_writedata0: out std_logic_vector(31 downto 0);
			pll_rst0: out std_logic;
			clkbuf_clken0: out std_logic;
			clkbuf_clksel0: out std_logic_vector(1 downto 0)
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
	component MappedElementSwitch_MappedRegisters_MappedMemories_SignalForwarding_PCIe is
		port (
			in_clocking_clk_switch: in std_logic;
			in_clocking_rst_switch: in std_logic;
			FROM_MappedRegisters_SOP_N: in std_logic;
			FROM_MappedRegisters_EOP_N: in std_logic;
			FROM_MappedRegisters_SRC_RDY_N: in std_logic;
			FROM_MappedRegisters_DATA: in std_logic_vector(31 downto 0);
			TO_MappedRegisters_DST_RDY_N: in std_logic;
			FROM_MappedMemories_SOP_N: in std_logic;
			FROM_MappedMemories_EOP_N: in std_logic;
			FROM_MappedMemories_SRC_RDY_N: in std_logic;
			FROM_MappedMemories_DATA: in std_logic_vector(31 downto 0);
			TO_MappedMemories_DST_RDY_N: in std_logic;
			FROM_SignalForwarding_SOP_N: in std_logic;
			FROM_SignalForwarding_EOP_N: in std_logic;
			FROM_SignalForwarding_SRC_RDY_N: in std_logic;
			FROM_SignalForwarding_DATA: in std_logic_vector(31 downto 0);
			TO_SignalForwarding_DST_RDY_N: in std_logic;
			FROM_PCIe_SOP_N: in std_logic;
			FROM_PCIe_EOP_N: in std_logic;
			FROM_PCIe_SRC_RDY_N: in std_logic;
			FROM_PCIe_DATA: in std_logic_vector(31 downto 0);
			TO_PCIe_DST_RDY_N: in std_logic;
			clocking_clk_switch: out std_logic;
			clocking_rst_switch: out std_logic;
			FROM_MappedRegisters_DST_RDY_N: out std_logic;
			TO_MappedRegisters_SOP_N: out std_logic;
			TO_MappedRegisters_EOP_N: out std_logic;
			TO_MappedRegisters_SRC_RDY_N: out std_logic;
			TO_MappedRegisters_DATA: out std_logic_vector(31 downto 0);
			FROM_MappedMemories_DST_RDY_N: out std_logic;
			TO_MappedMemories_SOP_N: out std_logic;
			TO_MappedMemories_EOP_N: out std_logic;
			TO_MappedMemories_SRC_RDY_N: out std_logic;
			TO_MappedMemories_DATA: out std_logic_vector(31 downto 0);
			FROM_SignalForwarding_DST_RDY_N: out std_logic;
			TO_SignalForwarding_SOP_N: out std_logic;
			TO_SignalForwarding_EOP_N: out std_logic;
			TO_SignalForwarding_SRC_RDY_N: out std_logic;
			TO_SignalForwarding_DATA: out std_logic_vector(31 downto 0);
			FROM_PCIe_DST_RDY_N: out std_logic;
			TO_PCIe_SOP_N: out std_logic;
			TO_PCIe_EOP_N: out std_logic;
			TO_PCIe_SRC_RDY_N: out std_logic;
			TO_PCIe_DATA: out std_logic_vector(31 downto 0)
		);
	end component;
	component MappedRegistersController_50 is
		port (
			switch_registers: in std_logic;
			clk_switch: in std_logic;
			rst_switch: in std_logic;
			register_out: in std_logic_vector(7 downto 0);
			FROM_SWITCH_SOP_N: in std_logic;
			FROM_SWITCH_EOP_N: in std_logic;
			FROM_SWITCH_SRC_RDY_N: in std_logic;
			FROM_SWITCH_DATA: in std_logic_vector(31 downto 0);
			TO_SWITCH_DST_RDY_N: in std_logic;
			register_clk: out std_logic;
			register_in: out std_logic_vector(7 downto 0);
			register_rotate: out std_logic;
			register_stop: out std_logic;
			register_switch: out std_logic;
			FROM_SWITCH_DST_RDY_N: out std_logic;
			TO_SWITCH_SOP_N: out std_logic;
			TO_SWITCH_EOP_N: out std_logic;
			TO_SWITCH_SRC_RDY_N: out std_logic;
			TO_SWITCH_DATA: out std_logic_vector(31 downto 0)
		);
	end component;
	component MappedMemoriesControllerdomain0_drp_domain0domain1_STREAM_domain1 is
		port (
			clk_switch: in std_logic;
			rst_switch: in std_logic;
			FROM_SWITCH_SOP_N: in std_logic;
			FROM_SWITCH_EOP_N: in std_logic;
			FROM_SWITCH_SRC_RDY_N: in std_logic;
			FROM_SWITCH_DATA: in std_logic_vector(31 downto 0);
			TO_SWITCH_DST_RDY_N: in std_logic;
			domain0_drp_clk: in std_logic;
			domain0_drp_rst: in std_logic;
			domain0_drp_memories_memories_data_out: in std_logic_vector(35 downto 0);
			domain0_drp_memories_memories_ack: in std_logic;
			domain1_STREAM_clk: in std_logic;
			domain1_STREAM_rst: in std_logic;
			domain1_STREAM_memories_memories_data_out: in std_logic_vector(35 downto 0);
			domain1_STREAM_memories_memories_ack: in std_logic;
			FROM_SWITCH_DST_RDY_N: out std_logic;
			TO_SWITCH_SOP_N: out std_logic;
			TO_SWITCH_EOP_N: out std_logic;
			TO_SWITCH_SRC_RDY_N: out std_logic;
			TO_SWITCH_DATA: out std_logic_vector(31 downto 0);
			domain0_drp_memories_memories_data_in: out std_logic_vector(35 downto 0);
			domain0_drp_memories_memories_memid: out std_logic_vector(15 downto 0);
			domain0_drp_memories_memories_memaddr: out std_logic_vector(15 downto 0);
			domain0_drp_memories_memories_wren: out std_logic;
			domain0_drp_memories_memories_rden: out std_logic;
			domain0_drp_memories_memories_stop: out std_logic;
			domain1_STREAM_memories_memories_data_in: out std_logic_vector(35 downto 0);
			domain1_STREAM_memories_memories_memid: out std_logic_vector(15 downto 0);
			domain1_STREAM_memories_memories_memaddr: out std_logic_vector(15 downto 0);
			domain1_STREAM_memories_memories_wren: out std_logic;
			domain1_STREAM_memories_memories_rden: out std_logic;
			domain1_STREAM_memories_memories_stop: out std_logic
		);
	end component;
	component SignalForwardingAdapter_stream_reset_memory_interrupt_crash_packet_sysmon_reset_pcc_switch_regs_pcc_start_pcc_reset_partial_reconfig_0 is
		port (
			FROM_SWITCH_SOP_N: in std_logic;
			FROM_SWITCH_EOP_N: in std_logic;
			FROM_SWITCH_SRC_RDY_N: in std_logic;
			FROM_SWITCH_DATA: in std_logic_vector(31 downto 0);
			TO_SWITCH_DST_RDY_N: in std_logic;
			clk_switch: in std_logic;
			rst_switch: in std_logic;
			register_clk: in std_logic;
			register_in: in std_logic_vector(7 downto 0);
			register_rotate: in std_logic;
			register_stop: in std_logic;
			register_switch: in std_logic;
			port_in_stream_reset: in std_logic;
			port_in_memory_interrupt: in std_logic;
			port_in_crash_packet: in std_logic;
			port_in_sysmon_reset: in std_logic;
			port_in_pcc_switch_regs: in std_logic;
			port_in_pcc_start: in std_logic;
			port_in_pcc_reset: in std_logic;
			port_in_partial_reconfig: in std_logic;
			FROM_SWITCH_DST_RDY_N: out std_logic;
			TO_SWITCH_SOP_N: out std_logic;
			TO_SWITCH_EOP_N: out std_logic;
			TO_SWITCH_SRC_RDY_N: out std_logic;
			TO_SWITCH_DATA: out std_logic_vector(31 downto 0);
			register_out: out std_logic_vector(7 downto 0);
			port_out_stream_reset: out std_logic;
			port_out_memory_interrupt: out std_logic;
			port_out_crash_packet: out std_logic;
			port_out_sysmon_reset: out std_logic;
			port_out_pcc_switch_regs: out std_logic;
			port_out_pcc_start: out std_logic;
			port_out_pcc_reset: out std_logic;
			port_out_partial_reconfig: out std_logic
		);
	end component;
	component MappedDRP_Addr_3c0000_ChecksumMappedDRP is
		port (
			memories_data_in: in std_logic_vector(35 downto 0);
			memories_memid: in std_logic_vector(15 downto 0);
			memories_memaddr: in std_logic_vector(15 downto 0);
			memories_wren: in std_logic;
			memories_rden: in std_logic;
			memories_stop: in std_logic;
			clk: in std_logic;
			memories_data_out: out std_logic_vector(35 downto 0);
			memories_ack: out std_logic
		);
	end component;
	component Manager_CpuStream is
		port (
			child_0_valid: in std_logic;
			child_0_done: in std_logic;
			child_0_data: in std_logic_vector(127 downto 0);
			child_1_valid: in std_logic;
			child_1_done: in std_logic;
			child_1_data: in std_logic_vector(127 downto 0);
			child_2_valid: in std_logic;
			child_2_done: in std_logic;
			child_2_data: in std_logic_vector(127 downto 0);
			child_3_valid: in std_logic;
			child_3_done: in std_logic;
			child_3_data: in std_logic_vector(127 downto 0);
			data_w_stall: in std_logic;
			STREAM: in std_logic;
			STREAM_NOBUF: in std_logic;
			STREAM_RST: in std_logic;
			STREAM_RST_DELAY: in std_logic;
			PCIE: in std_logic;
			PCIE_NOBUF: in std_logic;
			PCIE_RST: in std_logic;
			PCIE_RST_DELAY: in std_logic;
			mapped_reg_io_CpuStreamKernel_0_register_clk: in std_logic;
			mapped_reg_io_CpuStreamKernel_0_register_in: in std_logic_vector(7 downto 0);
			mapped_reg_io_CpuStreamKernel_0_register_rotate: in std_logic;
			mapped_reg_io_CpuStreamKernel_0_register_stop: in std_logic;
			mapped_reg_io_CpuStreamKernel_0_register_switch: in std_logic;
			toggle: in std_logic;
			partial_reconfig: in std_logic;
			child_0_stall: out std_logic;
			child_1_stall: out std_logic;
			child_2_stall: out std_logic;
			child_3_stall: out std_logic;
			data_w_valid: out std_logic;
			data_w_done: out std_logic;
			data_w_data: out std_logic_vector(127 downto 0);
			mapped_reg_io_CpuStreamKernel_0_register_out: out std_logic_vector(7 downto 0);
			toggle_ack: out std_logic;
			active: out std_logic
		);
	end component;
	component PCIeStreaming_2_5 is
		port (
			clk: in std_logic;
			rst: in std_logic;
			PCIeClockingIOGroupDef_clk_pcie: in std_logic;
			PCIeClockingIOGroupDef_rst_pcie_n: in std_logic;
			dma_abort_sfh: in std_logic_vector(31 downto 0);
			dma_abort_sth: in std_logic_vector(31 downto 0);
			dma_ctl_address: in std_logic_vector(8 downto 0);
			dma_ctl_data: in std_logic_vector(63 downto 0);
			dma_ctl_write: in std_logic;
			dma_ctl_byte_en: in std_logic_vector(7 downto 0);
			PCIeRXDMAReadResponseIOGroupDef_dma_response_data: in std_logic_vector(127 downto 0);
			PCIeRXDMAReadResponseIOGroupDef_dma_response_valid: in std_logic_vector(1 downto 0);
			PCIeRXDMAReadResponseIOGroupDef_dma_response_len: in std_logic_vector(9 downto 0);
			PCIeRXDMAReadResponseIOGroupDef_dma_response_tag: in std_logic_vector(7 downto 0);
			PCIeRXDMAReadResponseIOGroupDef_dma_response_complete: in std_logic;
			PCIeRXDMAReadResponseIOGroupDef_dma_response_ready: in std_logic;
			PCIeTXDMAReadRequestsIOGroupDef_dma_read_ack: in std_logic;
			PCIeTXDMAWriteRequestsIOGroupDef_ack: in std_logic;
			PCIeTXDMAWriteRequestsIOGroupDef_done: in std_logic;
			PCIeTXDMAWriteRequestsIOGroupDef_busy: in std_logic;
			PCIeTXDMAWriteRequestsIOGroupDef_rden: in std_logic;
			BarSpaceExternalParserIOGroupDef_wr_addr_onehot: in std_logic_vector(255 downto 0);
			BarSpaceExternalParserIOGroupDef_wr_data: in std_logic_vector(63 downto 0);
			BarSpaceExternalParserIOGroupDef_wr_clk: in std_logic;
			BarSpaceExternalParserIOGroupDef_wr_page_sel_onehot: in std_logic_vector(1 downto 0);
			register_clk: in std_logic;
			register_in: in std_logic_vector(7 downto 0);
			register_rotate: in std_logic;
			register_stop: in std_logic;
			register_switch: in std_logic;
			sth0_valid: in std_logic;
			sth0_done: in std_logic;
			sth0_data: in std_logic_vector(127 downto 0);
			sfh0_stall: in std_logic;
			sfh1_stall: in std_logic;
			sfh2_stall: in std_logic;
			sfh3_stall: in std_logic;
			sfh4_stall: in std_logic;
			sth1_valid: in std_logic;
			sth1_done: in std_logic;
			sth1_data: in std_logic_vector(127 downto 0);
			dma_complete_sfh: out std_logic_vector(31 downto 0);
			dma_complete_sth: out std_logic_vector(31 downto 0);
			dma_ctl_read_data: out std_logic_vector(63 downto 0);
			valid: out std_logic;
			enable_id: out std_logic_vector(31 downto 0);
			PCIeTXDMAReadRequestsIOGroupDef_dma_read_req: out std_logic;
			PCIeTXDMAReadRequestsIOGroupDef_dma_read_addr: out std_logic_vector(63 downto 0);
			PCIeTXDMAReadRequestsIOGroupDef_dma_read_len: out std_logic_vector(9 downto 0);
			PCIeTXDMAReadRequestsIOGroupDef_dma_read_be: out std_logic_vector(3 downto 0);
			PCIeTXDMAReadRequestsIOGroupDef_dma_read_tag: out std_logic_vector(7 downto 0);
			PCIeTXDMAReadRequestsIOGroupDef_dma_read_wide_addr: out std_logic;
			PCIeTXDMAWriteRequestsIOGroupDef_req: out std_logic;
			PCIeTXDMAWriteRequestsIOGroupDef_addr: out std_logic_vector(63 downto 0);
			PCIeTXDMAWriteRequestsIOGroupDef_tag: out std_logic_vector(7 downto 0);
			PCIeTXDMAWriteRequestsIOGroupDef_len: out std_logic_vector(8 downto 0);
			PCIeTXDMAWriteRequestsIOGroupDef_wide_addr: out std_logic;
			PCIeTXDMAWriteRequestsIOGroupDef_rddata: out std_logic_vector(127 downto 0);
			PCIeBarReadableStatusRegisters_tx_fifo_empty: out std_logic;
			register_out: out std_logic_vector(7 downto 0);
			sth0_stall: out std_logic;
			sth_cap_0: out std_logic_vector(7 downto 0);
			sth_cap_ctrl_0: out std_logic_vector(7 downto 0);
			sfh0_valid: out std_logic;
			sfh0_done: out std_logic;
			sfh0_data: out std_logic_vector(127 downto 0);
			SFHCredits0_index: out std_logic_vector(0 downto 0);
			SFHCredits0_update: out std_logic;
			SFHCredits0_wrap: out std_logic;
			sfh_cap_0: out std_logic_vector(7 downto 0);
			sfh1_valid: out std_logic;
			sfh1_done: out std_logic;
			sfh1_data: out std_logic_vector(127 downto 0);
			SFHCredits1_index: out std_logic_vector(0 downto 0);
			SFHCredits1_update: out std_logic;
			SFHCredits1_wrap: out std_logic;
			sfh_cap_1: out std_logic_vector(7 downto 0);
			sfh2_valid: out std_logic;
			sfh2_done: out std_logic;
			sfh2_data: out std_logic_vector(127 downto 0);
			SFHCredits2_index: out std_logic_vector(0 downto 0);
			SFHCredits2_update: out std_logic;
			SFHCredits2_wrap: out std_logic;
			sfh_cap_2: out std_logic_vector(7 downto 0);
			sfh3_valid: out std_logic;
			sfh3_done: out std_logic;
			sfh3_data: out std_logic_vector(127 downto 0);
			SFHCredits3_index: out std_logic_vector(0 downto 0);
			SFHCredits3_update: out std_logic;
			SFHCredits3_wrap: out std_logic;
			sfh_cap_3: out std_logic_vector(7 downto 0);
			sfh_cap_ctrl_0: out std_logic_vector(7 downto 0);
			sfh4_valid: out std_logic;
			sfh4_done: out std_logic;
			sfh4_data: out std_logic_vector(127 downto 0);
			SFHCredits4_index: out std_logic_vector(0 downto 0);
			SFHCredits4_update: out std_logic;
			SFHCredits4_wrap: out std_logic;
			sth1_stall: out std_logic
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
	component MappedElementAdapterForwarder is
		port (
			FROM_SWITCH_SOP_N: in std_logic;
			FROM_SWITCH_EOP_N: in std_logic;
			FROM_SWITCH_SRC_RDY_N: in std_logic;
			FROM_SWITCH_DATA: in std_logic_vector(31 downto 0);
			FROM_SWITCH_FWD_DST_RDY_N: in std_logic;
			TO_SWITCH_DST_RDY_N: in std_logic;
			TO_SWITCH_FWD_SOP_N: in std_logic;
			TO_SWITCH_FWD_EOP_N: in std_logic;
			TO_SWITCH_FWD_SRC_RDY_N: in std_logic;
			TO_SWITCH_FWD_DATA: in std_logic_vector(31 downto 0);
			clocking_clk_switch: in std_logic;
			clocking_rst_switch: in std_logic;
			FROM_SWITCH_DST_RDY_N: out std_logic;
			FROM_SWITCH_FWD_SOP_N: out std_logic;
			FROM_SWITCH_FWD_EOP_N: out std_logic;
			FROM_SWITCH_FWD_SRC_RDY_N: out std_logic;
			FROM_SWITCH_FWD_DATA: out std_logic_vector(31 downto 0);
			TO_SWITCH_SOP_N: out std_logic;
			TO_SWITCH_EOP_N: out std_logic;
			TO_SWITCH_SRC_RDY_N: out std_logic;
			TO_SWITCH_DATA: out std_logic_vector(31 downto 0);
			TO_SWITCH_FWD_DST_RDY_N: out std_logic;
			clocking_fwd_clk_switch: out std_logic;
			clocking_fwd_rst_switch: out std_logic
		);
	end component;
	component PerfMonitor is
		port (
			clk: in std_logic;
			rst: in std_logic;
			active: in std_logic;
			ecc_flags: in std_logic_vector(1 downto 0);
			ecc_parity: in std_logic_vector(31 downto 0);
			ecc_corrected: in std_logic_vector(31 downto 0);
			Mem_Data_time1: in std_logic_vector(31 downto 0);
			Mem_Data_time2: in std_logic_vector(31 downto 0);
			Mem_Idle_time1: in std_logic_vector(31 downto 0);
			Mem_Idle_time2: in std_logic_vector(31 downto 0);
			perf_update: in std_logic;
			perf_memories_data_in: in std_logic_vector(35 downto 0);
			perf_memories_memid: in std_logic_vector(15 downto 0);
			perf_memories_memaddr: in std_logic_vector(15 downto 0);
			perf_memories_wren: in std_logic;
			perf_memories_rden: in std_logic;
			perf_memories_stop: in std_logic;
			qdr_phy_init_done: in std_logic;
			ddr_phy_init_done: in std_logic;
			ifpga0_up: in std_logic;
			ifpga1_up: in std_logic;
			ifpga2_up: in std_logic;
			ifpga3_up: in std_logic;
			ifpga4_up: in std_logic;
			perf_memories_data_out: out std_logic_vector(35 downto 0);
			perf_memories_ack: out std_logic
		);
	end component;
	component start_of_day_reset is
		port (
			rst_n: in std_logic;
			reset_clk: in std_logic;
			reset_out: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal inst_ln11_bussynchroniser_dat_o : std_logic_vector(0 downto 0);
	signal inst_ln11_bussynchroniser1_dat_o : std_logic_vector(0 downto 0);
	signal inst_ln11_bussynchroniser2_dat_o : std_logic_vector(0 downto 0);
	signal sanityblock_i_register_out : std_logic_vector(7 downto 0);
	signal inst_ln34_mappedclockcontrol_memories_data_out : std_logic_vector(35 downto 0);
	signal inst_ln34_mappedclockcontrol_memories_ack : std_logic_vector(0 downto 0);
	signal inst_ln34_mappedclockcontrol_pll_mgmt_clk0 : std_logic_vector(0 downto 0);
	signal inst_ln34_mappedclockcontrol_pll_mgmt_rst0 : std_logic_vector(0 downto 0);
	signal inst_ln34_mappedclockcontrol_pll_mgmt_address0 : std_logic_vector(5 downto 0);
	signal inst_ln34_mappedclockcontrol_pll_mgmt_read0 : std_logic_vector(0 downto 0);
	signal inst_ln34_mappedclockcontrol_pll_mgmt_write0 : std_logic_vector(0 downto 0);
	signal inst_ln34_mappedclockcontrol_pll_mgmt_writedata0 : std_logic_vector(31 downto 0);
	signal inst_ln34_mappedclockcontrol_pll_rst0 : std_logic_vector(0 downto 0);
	signal inst_ln34_mappedclockcontrol_clkbuf_clken0 : std_logic_vector(0 downto 0);
	signal inst_ln34_mappedclockcontrol_clkbuf_clksel0 : std_logic_vector(1 downto 0);
	signal inst_ln11_bussynchroniser3_dat_o : std_logic_vector(0 downto 0);
	signal inst_ln11_bussynchroniser4_dat_o : std_logic_vector(0 downto 0);
	signal reset_controller_reset_out : std_logic_vector(0 downto 0);
	signal reset_controller_reset_late_pulse : std_logic_vector(0 downto 0);
	signal mappedelementswitch_i_clocking_clk_switch : std_logic_vector(0 downto 0);
	signal mappedelementswitch_i_clocking_rst_switch : std_logic_vector(0 downto 0);
	signal mappedelementswitch_i_from_mappedregisters_dst_rdy_n : std_logic_vector(0 downto 0);
	signal mappedelementswitch_i_to_mappedregisters_sop_n : std_logic_vector(0 downto 0);
	signal mappedelementswitch_i_to_mappedregisters_eop_n : std_logic_vector(0 downto 0);
	signal mappedelementswitch_i_to_mappedregisters_src_rdy_n : std_logic_vector(0 downto 0);
	signal mappedelementswitch_i_to_mappedregisters_data : std_logic_vector(31 downto 0);
	signal mappedelementswitch_i_from_mappedmemories_dst_rdy_n : std_logic_vector(0 downto 0);
	signal mappedelementswitch_i_to_mappedmemories_sop_n : std_logic_vector(0 downto 0);
	signal mappedelementswitch_i_to_mappedmemories_eop_n : std_logic_vector(0 downto 0);
	signal mappedelementswitch_i_to_mappedmemories_src_rdy_n : std_logic_vector(0 downto 0);
	signal mappedelementswitch_i_to_mappedmemories_data : std_logic_vector(31 downto 0);
	signal mappedelementswitch_i_from_signalforwarding_dst_rdy_n : std_logic_vector(0 downto 0);
	signal mappedelementswitch_i_to_signalforwarding_sop_n : std_logic_vector(0 downto 0);
	signal mappedelementswitch_i_to_signalforwarding_eop_n : std_logic_vector(0 downto 0);
	signal mappedelementswitch_i_to_signalforwarding_src_rdy_n : std_logic_vector(0 downto 0);
	signal mappedelementswitch_i_to_signalforwarding_data : std_logic_vector(31 downto 0);
	signal mappedelementswitch_i_from_pcie_dst_rdy_n : std_logic_vector(0 downto 0);
	signal mappedelementswitch_i_to_pcie_sop_n : std_logic_vector(0 downto 0);
	signal mappedelementswitch_i_to_pcie_eop_n : std_logic_vector(0 downto 0);
	signal mappedelementswitch_i_to_pcie_src_rdy_n : std_logic_vector(0 downto 0);
	signal mappedelementswitch_i_to_pcie_data : std_logic_vector(31 downto 0);
	signal mappedregisterscontroller_i_register_clk : std_logic_vector(0 downto 0);
	signal mappedregisterscontroller_i_register_in : std_logic_vector(7 downto 0);
	signal mappedregisterscontroller_i_register_rotate : std_logic_vector(0 downto 0);
	signal mappedregisterscontroller_i_register_stop : std_logic_vector(0 downto 0);
	signal mappedregisterscontroller_i_register_switch : std_logic_vector(0 downto 0);
	signal mappedregisterscontroller_i_from_switch_dst_rdy_n : std_logic_vector(0 downto 0);
	signal mappedregisterscontroller_i_to_switch_sop_n : std_logic_vector(0 downto 0);
	signal mappedregisterscontroller_i_to_switch_eop_n : std_logic_vector(0 downto 0);
	signal mappedregisterscontroller_i_to_switch_src_rdy_n : std_logic_vector(0 downto 0);
	signal mappedregisterscontroller_i_to_switch_data : std_logic_vector(31 downto 0);
	signal mappedmemoriescontroller_i_from_switch_dst_rdy_n : std_logic_vector(0 downto 0);
	signal mappedmemoriescontroller_i_to_switch_sop_n : std_logic_vector(0 downto 0);
	signal mappedmemoriescontroller_i_to_switch_eop_n : std_logic_vector(0 downto 0);
	signal mappedmemoriescontroller_i_to_switch_src_rdy_n : std_logic_vector(0 downto 0);
	signal mappedmemoriescontroller_i_to_switch_data : std_logic_vector(31 downto 0);
	signal mappedmemoriescontroller_i_domain0_drp_memories_memories_data_in : std_logic_vector(35 downto 0);
	signal mappedmemoriescontroller_i_domain0_drp_memories_memories_memid : std_logic_vector(15 downto 0);
	signal mappedmemoriescontroller_i_domain0_drp_memories_memories_memaddr : std_logic_vector(15 downto 0);
	signal mappedmemoriescontroller_i_domain0_drp_memories_memories_wren : std_logic_vector(0 downto 0);
	signal mappedmemoriescontroller_i_domain0_drp_memories_memories_rden : std_logic_vector(0 downto 0);
	signal mappedmemoriescontroller_i_domain0_drp_memories_memories_stop : std_logic_vector(0 downto 0);
	signal mappedmemoriescontroller_i_domain1_stream_memories_memories_data_in : std_logic_vector(35 downto 0);
	signal mappedmemoriescontroller_i_domain1_stream_memories_memories_memid : std_logic_vector(15 downto 0);
	signal mappedmemoriescontroller_i_domain1_stream_memories_memories_memaddr : std_logic_vector(15 downto 0);
	signal mappedmemoriescontroller_i_domain1_stream_memories_memories_wren : std_logic_vector(0 downto 0);
	signal mappedmemoriescontroller_i_domain1_stream_memories_memories_rden : std_logic_vector(0 downto 0);
	signal mappedmemoriescontroller_i_domain1_stream_memories_memories_stop : std_logic_vector(0 downto 0);
	signal signalforwardingadapter_i_from_switch_dst_rdy_n : std_logic_vector(0 downto 0);
	signal signalforwardingadapter_i_to_switch_sop_n : std_logic_vector(0 downto 0);
	signal signalforwardingadapter_i_to_switch_eop_n : std_logic_vector(0 downto 0);
	signal signalforwardingadapter_i_to_switch_src_rdy_n : std_logic_vector(0 downto 0);
	signal signalforwardingadapter_i_to_switch_data : std_logic_vector(31 downto 0);
	signal signalforwardingadapter_i_register_out : std_logic_vector(7 downto 0);
	signal signalforwardingadapter_i_port_out_stream_reset : std_logic_vector(0 downto 0);
	signal signalforwardingadapter_i_port_out_memory_interrupt : std_logic_vector(0 downto 0);
	signal signalforwardingadapter_i_port_out_crash_packet : std_logic_vector(0 downto 0);
	signal signalforwardingadapter_i_port_out_sysmon_reset : std_logic_vector(0 downto 0);
	signal signalforwardingadapter_i_port_out_pcc_switch_regs : std_logic_vector(0 downto 0);
	signal signalforwardingadapter_i_port_out_pcc_start : std_logic_vector(0 downto 0);
	signal signalforwardingadapter_i_port_out_pcc_reset : std_logic_vector(0 downto 0);
	signal signalforwardingadapter_i_port_out_partial_reconfig : std_logic_vector(0 downto 0);
	signal checksum_mem_drp_memories_data_out : std_logic_vector(35 downto 0);
	signal checksum_mem_drp_memories_ack : std_logic_vector(0 downto 0);
	signal wrapper_entity_child_0_stall : std_logic_vector(0 downto 0);
	signal wrapper_entity_child_1_stall : std_logic_vector(0 downto 0);
	signal wrapper_entity_child_2_stall : std_logic_vector(0 downto 0);
	signal wrapper_entity_child_3_stall : std_logic_vector(0 downto 0);
	signal wrapper_entity_data_w_valid : std_logic_vector(0 downto 0);
	signal wrapper_entity_data_w_done : std_logic_vector(0 downto 0);
	signal wrapper_entity_data_w_data : std_logic_vector(127 downto 0);
	signal wrapper_entity_mapped_reg_io_cpustreamkernel_0_register_out : std_logic_vector(7 downto 0);
	signal wrapper_entity_toggle_ack : std_logic_vector(0 downto 0);
	signal wrapper_entity_active : std_logic_vector(0 downto 0);
	signal inst_ln11_bussynchroniser5_dat_o : std_logic_vector(0 downto 0);
	signal dynpcie_dma_complete_sfh : std_logic_vector(31 downto 0);
	signal dynpcie_dma_complete_sth : std_logic_vector(31 downto 0);
	signal dynpcie_dma_ctl_read_data : std_logic_vector(63 downto 0);
	signal dynpcie_valid : std_logic_vector(0 downto 0);
	signal dynpcie_enable_id : std_logic_vector(31 downto 0);
	signal dynpcie_pcietxdmareadrequestsiogroupdef_dma_read_req : std_logic_vector(0 downto 0);
	signal dynpcie_pcietxdmareadrequestsiogroupdef_dma_read_addr : std_logic_vector(63 downto 0);
	signal dynpcie_pcietxdmareadrequestsiogroupdef_dma_read_len : std_logic_vector(9 downto 0);
	signal dynpcie_pcietxdmareadrequestsiogroupdef_dma_read_be : std_logic_vector(3 downto 0);
	signal dynpcie_pcietxdmareadrequestsiogroupdef_dma_read_tag : std_logic_vector(7 downto 0);
	signal dynpcie_pcietxdmareadrequestsiogroupdef_dma_read_wide_addr : std_logic_vector(0 downto 0);
	signal dynpcie_pcietxdmawriterequestsiogroupdef_req : std_logic_vector(0 downto 0);
	signal dynpcie_pcietxdmawriterequestsiogroupdef_addr : std_logic_vector(63 downto 0);
	signal dynpcie_pcietxdmawriterequestsiogroupdef_tag : std_logic_vector(7 downto 0);
	signal dynpcie_pcietxdmawriterequestsiogroupdef_len : std_logic_vector(8 downto 0);
	signal dynpcie_pcietxdmawriterequestsiogroupdef_wide_addr : std_logic_vector(0 downto 0);
	signal dynpcie_pcietxdmawriterequestsiogroupdef_rddata : std_logic_vector(127 downto 0);
	signal dynpcie_pciebarreadablestatusregisters_tx_fifo_empty : std_logic_vector(0 downto 0);
	signal dynpcie_register_out : std_logic_vector(7 downto 0);
	signal dynpcie_sth0_stall : std_logic_vector(0 downto 0);
	signal dynpcie_sth_cap_0 : std_logic_vector(7 downto 0);
	signal dynpcie_sth_cap_ctrl_0 : std_logic_vector(7 downto 0);
	signal dynpcie_sfh0_valid : std_logic_vector(0 downto 0);
	signal dynpcie_sfh0_done : std_logic_vector(0 downto 0);
	signal dynpcie_sfh0_data : std_logic_vector(127 downto 0);
	signal dynpcie_sfhcredits0_index : std_logic_vector(0 downto 0);
	signal dynpcie_sfhcredits0_update : std_logic_vector(0 downto 0);
	signal dynpcie_sfhcredits0_wrap : std_logic_vector(0 downto 0);
	signal dynpcie_sfh_cap_0 : std_logic_vector(7 downto 0);
	signal dynpcie_sfh1_valid : std_logic_vector(0 downto 0);
	signal dynpcie_sfh1_done : std_logic_vector(0 downto 0);
	signal dynpcie_sfh1_data : std_logic_vector(127 downto 0);
	signal dynpcie_sfhcredits1_index : std_logic_vector(0 downto 0);
	signal dynpcie_sfhcredits1_update : std_logic_vector(0 downto 0);
	signal dynpcie_sfhcredits1_wrap : std_logic_vector(0 downto 0);
	signal dynpcie_sfh_cap_1 : std_logic_vector(7 downto 0);
	signal dynpcie_sfh2_valid : std_logic_vector(0 downto 0);
	signal dynpcie_sfh2_done : std_logic_vector(0 downto 0);
	signal dynpcie_sfh2_data : std_logic_vector(127 downto 0);
	signal dynpcie_sfhcredits2_index : std_logic_vector(0 downto 0);
	signal dynpcie_sfhcredits2_update : std_logic_vector(0 downto 0);
	signal dynpcie_sfhcredits2_wrap : std_logic_vector(0 downto 0);
	signal dynpcie_sfh_cap_2 : std_logic_vector(7 downto 0);
	signal dynpcie_sfh3_valid : std_logic_vector(0 downto 0);
	signal dynpcie_sfh3_done : std_logic_vector(0 downto 0);
	signal dynpcie_sfh3_data : std_logic_vector(127 downto 0);
	signal dynpcie_sfhcredits3_index : std_logic_vector(0 downto 0);
	signal dynpcie_sfhcredits3_update : std_logic_vector(0 downto 0);
	signal dynpcie_sfhcredits3_wrap : std_logic_vector(0 downto 0);
	signal dynpcie_sfh_cap_3 : std_logic_vector(7 downto 0);
	signal dynpcie_sfh_cap_ctrl_0 : std_logic_vector(7 downto 0);
	signal dynpcie_sfh4_valid : std_logic_vector(0 downto 0);
	signal dynpcie_sfh4_done : std_logic_vector(0 downto 0);
	signal dynpcie_sfh4_data : std_logic_vector(127 downto 0);
	signal dynpcie_sfhcredits4_index : std_logic_vector(0 downto 0);
	signal dynpcie_sfhcredits4_update : std_logic_vector(0 downto 0);
	signal dynpcie_sfhcredits4_wrap : std_logic_vector(0 downto 0);
	signal dynpcie_sth1_stall : std_logic_vector(0 downto 0);
	signal inst_ln12_inputsynchronisedsynchroniser_dat_o : std_logic_vector(0 downto 0);
	signal inst_ln12_inputsynchronisedsynchroniser1_dat_o : std_logic_vector(0 downto 0);
	signal mappedelementadapterforwarder_pcie_i_from_switch_dst_rdy_n : std_logic_vector(0 downto 0);
	signal mappedelementadapterforwarder_pcie_i_from_switch_fwd_sop_n : std_logic_vector(0 downto 0);
	signal mappedelementadapterforwarder_pcie_i_from_switch_fwd_eop_n : std_logic_vector(0 downto 0);
	signal mappedelementadapterforwarder_pcie_i_from_switch_fwd_src_rdy_n : std_logic_vector(0 downto 0);
	signal mappedelementadapterforwarder_pcie_i_from_switch_fwd_data : std_logic_vector(31 downto 0);
	signal mappedelementadapterforwarder_pcie_i_to_switch_sop_n : std_logic_vector(0 downto 0);
	signal mappedelementadapterforwarder_pcie_i_to_switch_eop_n : std_logic_vector(0 downto 0);
	signal mappedelementadapterforwarder_pcie_i_to_switch_src_rdy_n : std_logic_vector(0 downto 0);
	signal mappedelementadapterforwarder_pcie_i_to_switch_data : std_logic_vector(31 downto 0);
	signal mappedelementadapterforwarder_pcie_i_to_switch_fwd_dst_rdy_n : std_logic_vector(0 downto 0);
	signal mappedelementadapterforwarder_pcie_i_clocking_fwd_clk_switch : std_logic_vector(0 downto 0);
	signal mappedelementadapterforwarder_pcie_i_clocking_fwd_rst_switch : std_logic_vector(0 downto 0);
	signal mec_rst_user_synchronizer_dat_o : std_logic_vector(0 downto 0);
	signal inst_ln11_bussynchroniser6_dat_o : std_logic_vector(0 downto 0);
	signal inst_ln11_bussynchroniser7_dat_o : std_logic_vector(0 downto 0);
	signal inst_ln11_bussynchroniser8_dat_o : std_logic_vector(0 downto 0);
	signal perfmon_perf_memories_data_out : std_logic_vector(35 downto 0);
	signal perfmon_perf_memories_ack : std_logic_vector(0 downto 0);
	signal inst_ln10_startofdayreset_reset_out : std_logic_vector(0 downto 0);
	signal inst_ln11_bussynchroniser9_dat_o : std_logic_vector(0 downto 0);
	signal inst_ln11_bussynchroniser_dat_i1 : std_logic_vector(0 downto 0);
	signal stream_reset_out : std_logic_vector(0 downto 0);
	signal stream_reset_late_pulse : std_logic_vector(0 downto 0);
	signal sig2 : std_logic_vector(0 downto 0);
	signal sig24 : std_logic_vector(7 downto 0);
	signal sig4 : std_logic_vector(0 downto 0);
	signal sig3 : std_logic_vector(0 downto 0);
	signal sig5 : std_logic_vector(0 downto 0);
	signal sanityblock_i_reset_n1 : std_logic_vector(0 downto 0);
	signal sanityblock_i_crash_input1 : std_logic_vector(0 downto 0);
	signal crash_packet_toggle : std_logic_vector(0 downto 0);
	signal reg_ln417_fpgawrapperentity : std_logic_vector(0 downto 0) := "0";
	signal STREAM_reset_reg_1 : std_logic_vector(0 downto 0) := "0";
	signal STREAM_reset_reg_0 : std_logic_vector(0 downto 0) := "0";
	signal STREAM_reset_late_reg_1 : std_logic_vector(0 downto 0) := "0";
	signal STREAM_reset_late_reg_0 : std_logic_vector(0 downto 0) := "0";
	signal PCIE_reset_reg_1 : std_logic_vector(0 downto 0) := "0";
	signal PCIE_reset_reg_0 : std_logic_vector(0 downto 0) := "0";
	signal PCIE_reset_late_reg_1 : std_logic_vector(0 downto 0) := "0";
	signal PCIE_reset_late_reg_0 : std_logic_vector(0 downto 0) := "0";
	signal inst_ln34_mappedclockcontrol_rst1 : std_logic_vector(0 downto 0);
	signal sig6 : std_logic_vector(35 downto 0);
	signal sig7 : std_logic_vector(15 downto 0);
	signal sig8 : std_logic_vector(15 downto 0);
	signal sig9 : std_logic_vector(0 downto 0);
	signal sig10 : std_logic_vector(0 downto 0);
	signal sig11 : std_logic_vector(0 downto 0);
	signal reset_controller_rst_n1 : std_logic_vector(0 downto 0);
	signal streamrst_toggle : std_logic_vector(0 downto 0);
	signal streamrst_toggle_pcie : std_logic_vector(0 downto 0);
	signal mappedelementswitch_i_in_clocking_rst_switch1 : std_logic_vector(0 downto 0);
	signal mec_user_rst_switch : std_logic_vector(0 downto 0);
	signal m_mec_rst_from_remote : std_logic_vector(0 downto 0);
	signal m_pcc_mapped_reg_switch_toggle : std_logic_vector(0 downto 0);
	signal sig : std_logic_vector(7 downto 0);
	signal mappedmemoriescontroller_i_domain0_drp_memories_memories_data_out1 : std_logic_vector(35 downto 0);
	signal sig13 : std_logic_vector(0 downto 0);
	signal mappedmemoriescontroller_i_domain1_stream_memories_memories_data_out1 : std_logic_vector(35 downto 0);
	signal sig23 : std_logic_vector(0 downto 0);
	signal sig14 : std_logic_vector(7 downto 0);
	signal memory_interrupt_toggle_to_switch : std_logic_vector(0 downto 0);
	signal stream_interrupt_strobe_toggle_switch : std_logic_vector(0 downto 0) := "0";
	signal stream_interrupt_strobe_switch_r : std_logic_vector(0 downto 0) := "0";
	signal crash_packet_toggle_to_switch : std_logic_vector(0 downto 0);
	signal wrapper_entity_child_0_data1 : std_logic_vector(127 downto 0);
	signal cat_ln87_streamiogrouputils : std_logic_vector(127 downto 0);
	signal wrapper_entity_child_1_data1 : std_logic_vector(127 downto 0);
	signal cat_ln87_streamiogrouputils1 : std_logic_vector(127 downto 0);
	signal wrapper_entity_child_2_data1 : std_logic_vector(127 downto 0);
	signal cat_ln87_streamiogrouputils2 : std_logic_vector(127 downto 0);
	signal wrapper_entity_child_3_data1 : std_logic_vector(127 downto 0);
	signal cat_ln87_streamiogrouputils3 : std_logic_vector(127 downto 0);
	signal sig15 : std_logic_vector(7 downto 0);
	signal crash_packet_toggle_from_barspace : std_logic_vector(0 downto 0);
	signal reg_ln434_fpgawrapperentity : std_logic_vector(0 downto 0) := "0";
	signal reg_ln426_fpgawrapperentity : std_logic_vector(0 downto 0) := "0";
	signal partial_reconfig_toggle_from_switch : std_logic_vector(0 downto 0);
	signal reg_ln430_fpgawrapperentity : std_logic_vector(0 downto 0) := "0";
	signal PCIE_reset_pipe_0 : std_logic_vector(0 downto 0) := "0";
	signal sig16 : std_logic_vector(7 downto 0);
	signal dynpcie_sth0_data1 : std_logic_vector(127 downto 0);
	signal cat_ln87_streamiogrouputils4 : std_logic_vector(127 downto 0);
	signal crash_packet_toggle_to_barspace : std_logic_vector(0 downto 0);
	signal sig17 : std_logic_vector(35 downto 0);
	signal sig18 : std_logic_vector(15 downto 0);
	signal sig19 : std_logic_vector(15 downto 0);
	signal sig20 : std_logic_vector(0 downto 0);
	signal sig21 : std_logic_vector(0 downto 0);
	signal sig22 : std_logic_vector(0 downto 0);
	signal cat_ln2674_fpgawrapperentity : std_logic_vector(127 downto 0);
	signal cat_ln2675_fpgawrapperentity : std_logic_vector(127 downto 0);
	signal cat_ln320_fpgawrapperentity : std_logic_vector(13 downto 0);
	signal memory_interrupt_toggle_switch : std_logic_vector(0 downto 0);
	signal cat_ln2616_fpgawrapperentity : std_logic_vector(15 downto 0);
	
	-- Attribute type declarations
	
	attribute dont_merge : boolean;
	
	-- Attribute declarations
	
	attribute dont_merge of STREAM_reset_reg_1 : signal is true;
	attribute dont_merge of STREAM_reset_reg_0 : signal is true;
	attribute dont_merge of STREAM_reset_late_reg_1 : signal is true;
	attribute dont_merge of STREAM_reset_late_reg_0 : signal is true;
	attribute dont_merge of PCIE_reset_reg_1 : signal is true;
	attribute dont_merge of PCIE_reset_reg_0 : signal is true;
	attribute dont_merge of PCIE_reset_late_reg_1 : signal is true;
	attribute dont_merge of PCIE_reset_late_reg_0 : signal is true;
begin
	
	-- Assignments
	
	inst_ln11_bussynchroniser_dat_i1 <= (not bit_to_vec(global_global_reset_n));
	stream_reset_out <= reset_controller_reset_out;
	stream_reset_late_pulse <= reset_controller_reset_late_pulse;
	sig2 <= mappedregisterscontroller_i_register_clk;
	sig24 <= mappedregisterscontroller_i_register_in;
	sig4 <= mappedregisterscontroller_i_register_rotate;
	sig3 <= mappedregisterscontroller_i_register_stop;
	sig5 <= mappedregisterscontroller_i_register_switch;
	sanityblock_i_reset_n1 <= (not bit_to_vec(global_global_reset_n));
	crash_packet_toggle <= signalforwardingadapter_i_port_out_crash_packet;
	sanityblock_i_crash_input1 <= (crash_packet_toggle xor reg_ln417_fpgawrapperentity);
	inst_ln34_mappedclockcontrol_rst1 <= (not bit_to_vec(global_global_reset_n));
	sig6 <= mappedmemoriescontroller_i_domain0_drp_memories_memories_data_in;
	sig7 <= mappedmemoriescontroller_i_domain0_drp_memories_memories_memid;
	sig8 <= mappedmemoriescontroller_i_domain0_drp_memories_memories_memaddr;
	sig9 <= mappedmemoriescontroller_i_domain0_drp_memories_memories_wren;
	sig10 <= mappedmemoriescontroller_i_domain0_drp_memories_memories_rden;
	sig11 <= mappedmemoriescontroller_i_domain0_drp_memories_memories_stop;
	reset_controller_rst_n1 <= (bit_to_vec(global_global_reset_n) and (bit_to_vec(pll_inst_locked0)));
	streamrst_toggle_pcie <= bit_to_vec(pcie_pcie_pcie_clocking_rst_toggle);
	streamrst_toggle <= (streamrst_toggle_pcie xor signalforwardingadapter_i_port_out_stream_reset);
	mec_user_rst_switch <= mec_rst_user_synchronizer_dat_o;
	m_mec_rst_from_remote <= "0";
	mappedelementswitch_i_in_clocking_rst_switch1 <= (mec_user_rst_switch or m_mec_rst_from_remote);
	m_pcc_mapped_reg_switch_toggle <= "0";
	sig <= signalforwardingadapter_i_register_out;
	mappedmemoriescontroller_i_domain0_drp_memories_memories_data_out1 <= (inst_ln34_mappedclockcontrol_memories_data_out or checksum_mem_drp_memories_data_out);
	sig13 <= (inst_ln34_mappedclockcontrol_memories_ack or checksum_mem_drp_memories_ack);
	mappedmemoriescontroller_i_domain1_stream_memories_memories_data_out1 <= (perfmon_perf_memories_data_out);
	sig23 <= (perfmon_perf_memories_ack);
	sig14 <= wrapper_entity_mapped_reg_io_cpustreamkernel_0_register_out;
	memory_interrupt_toggle_to_switch <= stream_interrupt_strobe_toggle_switch;
	crash_packet_toggle_to_switch <= "0";
	cat_ln87_streamiogrouputils<=dynpcie_sfh0_data;
	wrapper_entity_child_0_data1 <= cat_ln87_streamiogrouputils;
	cat_ln87_streamiogrouputils1<=dynpcie_sfh1_data;
	wrapper_entity_child_1_data1 <= cat_ln87_streamiogrouputils1;
	cat_ln87_streamiogrouputils2<=dynpcie_sfh2_data;
	wrapper_entity_child_2_data1 <= cat_ln87_streamiogrouputils2;
	cat_ln87_streamiogrouputils3<=dynpcie_sfh3_data;
	wrapper_entity_child_3_data1 <= cat_ln87_streamiogrouputils3;
	sig15 <= dynpcie_register_out;
	crash_packet_toggle_from_barspace <= inst_ln12_inputsynchronisedsynchroniser_dat_o;
	partial_reconfig_toggle_from_switch <= signalforwardingadapter_i_port_out_partial_reconfig;
	sig16 <= sanityblock_i_register_out;
	cat_ln87_streamiogrouputils4<=wrapper_entity_data_w_data;
	dynpcie_sth0_data1 <= cat_ln87_streamiogrouputils4;
	crash_packet_toggle_to_barspace <= inst_ln11_bussynchroniser5_dat_o;
	sig17 <= mappedmemoriescontroller_i_domain1_stream_memories_memories_data_in;
	sig18 <= mappedmemoriescontroller_i_domain1_stream_memories_memories_memid;
	sig19 <= mappedmemoriescontroller_i_domain1_stream_memories_memories_memaddr;
	sig20 <= mappedmemoriescontroller_i_domain1_stream_memories_memories_wren;
	sig21 <= mappedmemoriescontroller_i_domain1_stream_memories_memories_rden;
	sig22 <= mappedmemoriescontroller_i_domain1_stream_memories_memories_stop;
	cat_ln2674_fpgawrapperentity<=("00000000" & "00000000" & "00000000" & "00000000" & "00000000" & "00000000" & "00000000" & "00000000" & "00000000" & "00000000" & "00000000" & "00000000" & dynpcie_sfh_cap_3 & dynpcie_sfh_cap_2 & dynpcie_sfh_cap_1 & dynpcie_sfh_cap_0);
	cat_ln2675_fpgawrapperentity<=("00000000" & "00000000" & "00000000" & "00000000" & "00000000" & "00000000" & "00000000" & "00000000" & "00000000" & "00000000" & "00000000" & "00000000" & "00000000" & "00000000" & "00000000" & dynpcie_sth_cap_0);
	cat_ln320_fpgawrapperentity<="00000000000000";
	memory_interrupt_toggle_switch <= signalforwardingadapter_i_port_out_memory_interrupt;
	cat_ln2616_fpgawrapperentity<=(cat_ln320_fpgawrapperentity & memory_interrupt_toggle_switch & memory_interrupt_toggle_to_switch);
	pll_mgmt_clk0 <= vec_to_bit(inst_ln34_mappedclockcontrol_pll_mgmt_clk0);
	pll_mgmt_rst0 <= vec_to_bit(inst_ln34_mappedclockcontrol_pll_mgmt_rst0);
	pll_mgmt_address0 <= inst_ln34_mappedclockcontrol_pll_mgmt_address0;
	pll_mgmt_read0 <= vec_to_bit(inst_ln34_mappedclockcontrol_pll_mgmt_read0);
	pll_mgmt_write0 <= vec_to_bit(inst_ln34_mappedclockcontrol_pll_mgmt_write0);
	pll_mgmt_writedata0 <= inst_ln34_mappedclockcontrol_pll_mgmt_writedata0;
	pll_rst0 <= vec_to_bit(inst_ln34_mappedclockcontrol_pll_rst0);
	clkbuf_clken0 <= vec_to_bit(inst_ln34_mappedclockcontrol_clkbuf_clken0);
	pcie_pcie_dma_control_dma_complete_sfh <= dynpcie_dma_complete_sfh;
	pcie_pcie_dma_control_dma_complete_sth <= dynpcie_dma_complete_sth;
	pcie_pcie_dma_control_dma_ctl_read_data <= dynpcie_dma_ctl_read_data;
	pcie_pcie_dmareadreq_dma_read_req <= vec_to_bit(dynpcie_pcietxdmareadrequestsiogroupdef_dma_read_req);
	pcie_pcie_dmareadreq_dma_read_addr <= dynpcie_pcietxdmareadrequestsiogroupdef_dma_read_addr;
	pcie_pcie_dmareadreq_dma_read_len <= dynpcie_pcietxdmareadrequestsiogroupdef_dma_read_len;
	pcie_pcie_dmareadreq_dma_read_be <= dynpcie_pcietxdmareadrequestsiogroupdef_dma_read_be;
	pcie_pcie_dmareadreq_dma_read_tag <= dynpcie_pcietxdmareadrequestsiogroupdef_dma_read_tag;
	pcie_pcie_dmareadreq_dma_read_wide_addr <= vec_to_bit(dynpcie_pcietxdmareadrequestsiogroupdef_dma_read_wide_addr);
	pcie_pcie_dmawritereq_req <= vec_to_bit(dynpcie_pcietxdmawriterequestsiogroupdef_req);
	pcie_pcie_dmawritereq_addr <= dynpcie_pcietxdmawriterequestsiogroupdef_addr;
	pcie_pcie_dmawritereq_tag <= dynpcie_pcietxdmawriterequestsiogroupdef_tag;
	pcie_pcie_dmawritereq_len <= dynpcie_pcietxdmawriterequestsiogroupdef_len;
	pcie_pcie_dmawritereq_wide_addr <= vec_to_bit(dynpcie_pcietxdmawriterequestsiogroupdef_wide_addr);
	pcie_pcie_dmawritereq_rddata <= dynpcie_pcietxdmawriterequestsiogroupdef_rddata;
	pcie_pcie_req_interrupt_ctl_valid <= vec_to_bit(dynpcie_valid);
	pcie_pcie_req_interrupt_ctl_enable_id <= dynpcie_enable_id;
	pcie_pcie_bar_status_tx_fifo_empty <= vec_to_bit(dynpcie_pciebarreadablestatusregisters_tx_fifo_empty);
	pcie_pcie_slave_streaming_arb_read_compl_req <= vec_to_bit("0");
	pcie_pcie_slave_streaming_arb_read_compl_metadata <= "0000000000000000000000000000000";
	pcie_pcie_slave_streaming_arb_read_compl_addr <= "0000000";
	pcie_pcie_slave_streaming_arb_read_compl_size <= "000000000000";
	pcie_pcie_slave_streaming_arb_read_compl_rem_size <= "000000000000";
	pcie_pcie_slave_streaming_arb_read_compl_data <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
	pcie_pcie_slave_sfh_credits0_index <= "0";
	pcie_pcie_slave_sfh_credits0_update <= vec_to_bit("0");
	pcie_pcie_slave_sfh_credits0_wrap <= vec_to_bit("0");
	pcie_pcie_slave_sfh_credits1_index <= "0";
	pcie_pcie_slave_sfh_credits1_update <= vec_to_bit("0");
	pcie_pcie_slave_sfh_credits1_wrap <= vec_to_bit("0");
	pcie_pcie_slave_sfh_credits2_index <= "0";
	pcie_pcie_slave_sfh_credits2_update <= vec_to_bit("0");
	pcie_pcie_slave_sfh_credits2_wrap <= vec_to_bit("0");
	pcie_pcie_slave_sfh_credits3_index <= "0";
	pcie_pcie_slave_sfh_credits3_update <= vec_to_bit("0");
	pcie_pcie_slave_sfh_credits3_wrap <= vec_to_bit("0");
	pcie_pcie_slave_sfh_credits4_index <= "0";
	pcie_pcie_slave_sfh_credits4_update <= vec_to_bit("0");
	pcie_pcie_slave_sfh_credits4_wrap <= vec_to_bit("0");
	pcie_pcie_slave_sth_credits0_index <= "0";
	pcie_pcie_slave_sth_credits0_update <= vec_to_bit("0");
	pcie_pcie_slave_sth_credits0_wrap <= vec_to_bit("0");
	pcie_pcie_slave_sth_credits1_index <= "0";
	pcie_pcie_slave_sth_credits1_update <= vec_to_bit("0");
	pcie_pcie_slave_sth_credits1_wrap <= vec_to_bit("0");
	sfh_cap <= cat_ln2674_fpgawrapperentity;
	sth_cap <= cat_ln2675_fpgawrapperentity;
	sfh_cap_ctrl_0 <= dynpcie_sfh_cap_ctrl_0;
	sth_cap_ctrl_0 <= dynpcie_sth_cap_ctrl_0;
	pcie_pcie_control_sfh_valid <= vec_to_bit(dynpcie_sfh4_valid);
	pcie_pcie_control_sfh_done <= vec_to_bit(dynpcie_sfh4_done);
	pcie_pcie_control_sfh_data <= dynpcie_sfh4_data;
	pcie_pcie_control_sth_stall <= vec_to_bit(dynpcie_sth1_stall);
	pcie_pcie_sfa_user_toggle_ack <= vec_to_bit(inst_ln12_inputsynchronisedsynchroniser1_dat_o);
	pcie_pcie_mappedreg_reg_data_out <= "00000000000000000000000000000000";
	pcie_pcie_mappedreg_reg_completion_toggle <= vec_to_bit("0");
	pcie_pcie_mappedreg_stream_interrupt_toggle <= cat_ln2616_fpgawrapperentity;
	pcie_pcie_mec_fwd_write_port_SOP_N <= vec_to_bit(mappedelementadapterforwarder_pcie_i_from_switch_fwd_sop_n);
	pcie_pcie_mec_fwd_write_port_EOP_N <= vec_to_bit(mappedelementadapterforwarder_pcie_i_from_switch_fwd_eop_n);
	pcie_pcie_mec_fwd_write_port_SRC_RDY_N <= vec_to_bit(mappedelementadapterforwarder_pcie_i_from_switch_fwd_src_rdy_n);
	pcie_pcie_mec_fwd_write_port_DATA <= mappedelementadapterforwarder_pcie_i_from_switch_fwd_data;
	pcie_pcie_mec_fwd_read_port_DST_RDY_N <= vec_to_bit(mappedelementadapterforwarder_pcie_i_to_switch_fwd_dst_rdy_n);
	pcie_pcie_mec_fwd_clocking_clk_switch <= vec_to_bit(mappedelementadapterforwarder_pcie_i_clocking_fwd_clk_switch);
	pcie_pcie_mec_fwd_clocking_rst_switch <= vec_to_bit(mappedelementadapterforwarder_pcie_i_clocking_fwd_rst_switch);
	
	-- Register processes
	
	reg_process : process(global_global_cclk)
	begin
		if rising_edge(global_global_cclk) then
			reg_ln417_fpgawrapperentity <= crash_packet_toggle;
			if slv_to_slv((inst_ln11_bussynchroniser8_dat_o and (not stream_interrupt_strobe_switch_r))) = "1" then
				stream_interrupt_strobe_toggle_switch <= (not stream_interrupt_strobe_toggle_switch);
			end if;
			stream_interrupt_strobe_switch_r <= inst_ln11_bussynchroniser8_dat_o;
			if slv_to_slv(stream_reset_out) = "1" then
				reg_ln434_fpgawrapperentity <= "0";
			else
				if slv_to_slv((reg_ln426_fpgawrapperentity xor reg_ln430_fpgawrapperentity)) = "1" then
					reg_ln434_fpgawrapperentity <= (not reg_ln434_fpgawrapperentity);
				end if;
			end if;
			reg_ln426_fpgawrapperentity <= partial_reconfig_toggle_from_switch;
			reg_ln430_fpgawrapperentity <= reg_ln426_fpgawrapperentity;
		end if;
	end process;
	reg_process1 : process(stream_clocks_gen_output_clk0)
	begin
		if rising_edge(stream_clocks_gen_output_clk0) then
			STREAM_reset_reg_1 <= STREAM_reset_reg_0;
			STREAM_reset_reg_0 <= inst_ln11_bussynchroniser3_dat_o;
			STREAM_reset_late_reg_1 <= STREAM_reset_late_reg_0;
			STREAM_reset_late_reg_0 <= inst_ln11_bussynchroniser4_dat_o;
		end if;
	end process;
	reg_process2 : process(pcie_pcie_clocking_clk_pcie)
	begin
		if rising_edge(pcie_pcie_clocking_clk_pcie) then
			PCIE_reset_reg_1 <= PCIE_reset_reg_0;
			PCIE_reset_reg_0 <= inst_ln11_bussynchroniser6_dat_o;
			PCIE_reset_late_reg_1 <= PCIE_reset_late_reg_0;
			PCIE_reset_late_reg_0 <= inst_ln11_bussynchroniser7_dat_o;
			PCIE_reset_pipe_0 <= PCIE_reset_reg_1;
		end if;
	end process;
	
	-- Entity instances
	
	inst_ln11_bussynchroniser : vhdl_bus_synchronizer
		generic map (
			width => 1
		)
		port map (
			dat_o => inst_ln11_bussynchroniser_dat_o, -- 1 bits (out)
			clk => global_global_cclk, -- 1 bits (in)
			rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => inst_ln11_bussynchroniser_dat_i1 -- 1 bits (in)
		);
	inst_ln11_bussynchroniser1 : vhdl_bus_synchronizer
		generic map (
			width => 1
		)
		port map (
			dat_o => inst_ln11_bussynchroniser1_dat_o, -- 1 bits (out)
			clk => global_global_cclk, -- 1 bits (in)
			rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => stream_reset_out -- 1 bits (in)
		);
	inst_ln11_bussynchroniser2 : vhdl_bus_synchronizer
		generic map (
			width => 1
		)
		port map (
			dat_o => inst_ln11_bussynchroniser2_dat_o, -- 1 bits (out)
			clk => global_global_cclk, -- 1 bits (in)
			rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => stream_reset_late_pulse -- 1 bits (in)
		);
	SanityBlock_i : SanityBlock_cclk_STREAM_clk_pcie
		port map (
			register_out => sanityblock_i_register_out, -- 8 bits (out)
			register_clk => vec_to_bit(sig2), -- 1 bits (in)
			register_in => sig24, -- 8 bits (in)
			register_rotate => vec_to_bit(sig4), -- 1 bits (in)
			register_stop => vec_to_bit(sig3), -- 1 bits (in)
			register_switch => vec_to_bit(sig5), -- 1 bits (in)
			rst_async => vec_to_bit(stream_reset_out), -- 1 bits (in)
			reset_n => vec_to_bit(sanityblock_i_reset_n1), -- 1 bits (in)
			clk_reset_n => global_global_cclk, -- 1 bits (in)
			crash_input => vec_to_bit(sanityblock_i_crash_input1), -- 1 bits (in)
			clk_crash_input => global_global_cclk, -- 1 bits (in)
			cclk => global_global_cclk, -- 1 bits (in)
			STREAM => stream_clocks_gen_output_clk0, -- 1 bits (in)
			clk_pcie => pcie_pcie_clocking_clk_pcie, -- 1 bits (in)
			STREAM_rst => vec_to_bit(STREAM_reset_reg_1), -- 1 bits (in)
			clk_STREAM_rst => stream_clocks_gen_output_clk0, -- 1 bits (in)
			STREAM_rst_delay => vec_to_bit(STREAM_reset_late_reg_1), -- 1 bits (in)
			clk_STREAM_rst_delay => stream_clocks_gen_output_clk0, -- 1 bits (in)
			PCIE_rst => vec_to_bit(PCIE_reset_reg_1), -- 1 bits (in)
			clk_PCIE_rst => pcie_pcie_clocking_clk_pcie, -- 1 bits (in)
			PCIE_rst_delay => vec_to_bit(PCIE_reset_late_reg_1), -- 1 bits (in)
			clk_PCIE_rst_delay => pcie_pcie_clocking_clk_pcie -- 1 bits (in)
		);
	inst_ln34_mappedclockcontrol : MappedClockControl_id_3e
		port map (
			memories_data_out => inst_ln34_mappedclockcontrol_memories_data_out, -- 36 bits (out)
			memories_ack => inst_ln34_mappedclockcontrol_memories_ack(0), -- 1 bits (out)
			pll_mgmt_clk0 => inst_ln34_mappedclockcontrol_pll_mgmt_clk0(0), -- 1 bits (out)
			pll_mgmt_rst0 => inst_ln34_mappedclockcontrol_pll_mgmt_rst0(0), -- 1 bits (out)
			pll_mgmt_address0 => inst_ln34_mappedclockcontrol_pll_mgmt_address0, -- 6 bits (out)
			pll_mgmt_read0 => inst_ln34_mappedclockcontrol_pll_mgmt_read0(0), -- 1 bits (out)
			pll_mgmt_write0 => inst_ln34_mappedclockcontrol_pll_mgmt_write0(0), -- 1 bits (out)
			pll_mgmt_writedata0 => inst_ln34_mappedclockcontrol_pll_mgmt_writedata0, -- 32 bits (out)
			pll_rst0 => inst_ln34_mappedclockcontrol_pll_rst0(0), -- 1 bits (out)
			clkbuf_clken0 => inst_ln34_mappedclockcontrol_clkbuf_clken0(0), -- 1 bits (out)
			clkbuf_clksel0 => inst_ln34_mappedclockcontrol_clkbuf_clksel0, -- 2 bits (out)
			cclk => global_global_cclk, -- 1 bits (in)
			rst => vec_to_bit(inst_ln34_mappedclockcontrol_rst1), -- 1 bits (in)
			memories_data_in => sig6, -- 36 bits (in)
			memories_memid => sig7, -- 16 bits (in)
			memories_memaddr => sig8, -- 16 bits (in)
			memories_wren => vec_to_bit(sig9), -- 1 bits (in)
			memories_rden => vec_to_bit(sig10), -- 1 bits (in)
			memories_stop => vec_to_bit(sig11), -- 1 bits (in)
			pll_mgmt_readdata0 => pll_mgmt_readdata0, -- 32 bits (in)
			pll_mgmt_waitrequest0 => pll_mgmt_waitrequest0, -- 1 bits (in)
			pll_inst_locked0 => pll_inst_locked0 -- 1 bits (in)
		);
	inst_ln11_bussynchroniser3 : vhdl_bus_synchronizer
		generic map (
			width => 1
		)
		port map (
			dat_o => inst_ln11_bussynchroniser3_dat_o, -- 1 bits (out)
			clk => stream_clocks_gen_output_clk0, -- 1 bits (in)
			rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => stream_reset_out -- 1 bits (in)
		);
	inst_ln11_bussynchroniser4 : vhdl_bus_synchronizer
		generic map (
			width => 1
		)
		port map (
			dat_o => inst_ln11_bussynchroniser4_dat_o, -- 1 bits (out)
			clk => stream_clocks_gen_output_clk0, -- 1 bits (in)
			rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => stream_reset_late_pulse -- 1 bits (in)
		);
	reset_controller : reset_control
		generic map (
			LOG2_RESET_CYCLES => 5
		)
		port map (
			reset_out => reset_controller_reset_out(0), -- 1 bits (out)
			reset_late_pulse => reset_controller_reset_late_pulse(0), -- 1 bits (out)
			rst_n => vec_to_bit(reset_controller_rst_n1), -- 1 bits (in)
			reset_clk => global_global_cclk, -- 1 bits (in)
			reset_toggle => vec_to_bit(streamrst_toggle) -- 1 bits (in)
		);
	MappedElementSwitch_i : MappedElementSwitch_MappedRegisters_MappedMemories_SignalForwarding_PCIe
		port map (
			clocking_clk_switch => mappedelementswitch_i_clocking_clk_switch(0), -- 1 bits (out)
			clocking_rst_switch => mappedelementswitch_i_clocking_rst_switch(0), -- 1 bits (out)
			FROM_MappedRegisters_DST_RDY_N => mappedelementswitch_i_from_mappedregisters_dst_rdy_n(0), -- 1 bits (out)
			TO_MappedRegisters_SOP_N => mappedelementswitch_i_to_mappedregisters_sop_n(0), -- 1 bits (out)
			TO_MappedRegisters_EOP_N => mappedelementswitch_i_to_mappedregisters_eop_n(0), -- 1 bits (out)
			TO_MappedRegisters_SRC_RDY_N => mappedelementswitch_i_to_mappedregisters_src_rdy_n(0), -- 1 bits (out)
			TO_MappedRegisters_DATA => mappedelementswitch_i_to_mappedregisters_data, -- 32 bits (out)
			FROM_MappedMemories_DST_RDY_N => mappedelementswitch_i_from_mappedmemories_dst_rdy_n(0), -- 1 bits (out)
			TO_MappedMemories_SOP_N => mappedelementswitch_i_to_mappedmemories_sop_n(0), -- 1 bits (out)
			TO_MappedMemories_EOP_N => mappedelementswitch_i_to_mappedmemories_eop_n(0), -- 1 bits (out)
			TO_MappedMemories_SRC_RDY_N => mappedelementswitch_i_to_mappedmemories_src_rdy_n(0), -- 1 bits (out)
			TO_MappedMemories_DATA => mappedelementswitch_i_to_mappedmemories_data, -- 32 bits (out)
			FROM_SignalForwarding_DST_RDY_N => mappedelementswitch_i_from_signalforwarding_dst_rdy_n(0), -- 1 bits (out)
			TO_SignalForwarding_SOP_N => mappedelementswitch_i_to_signalforwarding_sop_n(0), -- 1 bits (out)
			TO_SignalForwarding_EOP_N => mappedelementswitch_i_to_signalforwarding_eop_n(0), -- 1 bits (out)
			TO_SignalForwarding_SRC_RDY_N => mappedelementswitch_i_to_signalforwarding_src_rdy_n(0), -- 1 bits (out)
			TO_SignalForwarding_DATA => mappedelementswitch_i_to_signalforwarding_data, -- 32 bits (out)
			FROM_PCIe_DST_RDY_N => mappedelementswitch_i_from_pcie_dst_rdy_n(0), -- 1 bits (out)
			TO_PCIe_SOP_N => mappedelementswitch_i_to_pcie_sop_n(0), -- 1 bits (out)
			TO_PCIe_EOP_N => mappedelementswitch_i_to_pcie_eop_n(0), -- 1 bits (out)
			TO_PCIe_SRC_RDY_N => mappedelementswitch_i_to_pcie_src_rdy_n(0), -- 1 bits (out)
			TO_PCIe_DATA => mappedelementswitch_i_to_pcie_data, -- 32 bits (out)
			in_clocking_clk_switch => global_global_cclk, -- 1 bits (in)
			in_clocking_rst_switch => vec_to_bit(mappedelementswitch_i_in_clocking_rst_switch1), -- 1 bits (in)
			FROM_MappedRegisters_SOP_N => vec_to_bit(mappedregisterscontroller_i_to_switch_sop_n), -- 1 bits (in)
			FROM_MappedRegisters_EOP_N => vec_to_bit(mappedregisterscontroller_i_to_switch_eop_n), -- 1 bits (in)
			FROM_MappedRegisters_SRC_RDY_N => vec_to_bit(mappedregisterscontroller_i_to_switch_src_rdy_n), -- 1 bits (in)
			FROM_MappedRegisters_DATA => mappedregisterscontroller_i_to_switch_data, -- 32 bits (in)
			TO_MappedRegisters_DST_RDY_N => vec_to_bit(mappedregisterscontroller_i_from_switch_dst_rdy_n), -- 1 bits (in)
			FROM_MappedMemories_SOP_N => vec_to_bit(mappedmemoriescontroller_i_to_switch_sop_n), -- 1 bits (in)
			FROM_MappedMemories_EOP_N => vec_to_bit(mappedmemoriescontroller_i_to_switch_eop_n), -- 1 bits (in)
			FROM_MappedMemories_SRC_RDY_N => vec_to_bit(mappedmemoriescontroller_i_to_switch_src_rdy_n), -- 1 bits (in)
			FROM_MappedMemories_DATA => mappedmemoriescontroller_i_to_switch_data, -- 32 bits (in)
			TO_MappedMemories_DST_RDY_N => vec_to_bit(mappedmemoriescontroller_i_from_switch_dst_rdy_n), -- 1 bits (in)
			FROM_SignalForwarding_SOP_N => vec_to_bit(signalforwardingadapter_i_to_switch_sop_n), -- 1 bits (in)
			FROM_SignalForwarding_EOP_N => vec_to_bit(signalforwardingadapter_i_to_switch_eop_n), -- 1 bits (in)
			FROM_SignalForwarding_SRC_RDY_N => vec_to_bit(signalforwardingadapter_i_to_switch_src_rdy_n), -- 1 bits (in)
			FROM_SignalForwarding_DATA => signalforwardingadapter_i_to_switch_data, -- 32 bits (in)
			TO_SignalForwarding_DST_RDY_N => vec_to_bit(signalforwardingadapter_i_from_switch_dst_rdy_n), -- 1 bits (in)
			FROM_PCIe_SOP_N => vec_to_bit(mappedelementadapterforwarder_pcie_i_to_switch_sop_n), -- 1 bits (in)
			FROM_PCIe_EOP_N => vec_to_bit(mappedelementadapterforwarder_pcie_i_to_switch_eop_n), -- 1 bits (in)
			FROM_PCIe_SRC_RDY_N => vec_to_bit(mappedelementadapterforwarder_pcie_i_to_switch_src_rdy_n), -- 1 bits (in)
			FROM_PCIe_DATA => mappedelementadapterforwarder_pcie_i_to_switch_data, -- 32 bits (in)
			TO_PCIe_DST_RDY_N => vec_to_bit(mappedelementadapterforwarder_pcie_i_from_switch_dst_rdy_n) -- 1 bits (in)
		);
	MappedRegistersController_i : MappedRegistersController_50
		port map (
			register_clk => mappedregisterscontroller_i_register_clk(0), -- 1 bits (out)
			register_in => mappedregisterscontroller_i_register_in, -- 8 bits (out)
			register_rotate => mappedregisterscontroller_i_register_rotate(0), -- 1 bits (out)
			register_stop => mappedregisterscontroller_i_register_stop(0), -- 1 bits (out)
			register_switch => mappedregisterscontroller_i_register_switch(0), -- 1 bits (out)
			FROM_SWITCH_DST_RDY_N => mappedregisterscontroller_i_from_switch_dst_rdy_n(0), -- 1 bits (out)
			TO_SWITCH_SOP_N => mappedregisterscontroller_i_to_switch_sop_n(0), -- 1 bits (out)
			TO_SWITCH_EOP_N => mappedregisterscontroller_i_to_switch_eop_n(0), -- 1 bits (out)
			TO_SWITCH_SRC_RDY_N => mappedregisterscontroller_i_to_switch_src_rdy_n(0), -- 1 bits (out)
			TO_SWITCH_DATA => mappedregisterscontroller_i_to_switch_data, -- 32 bits (out)
			switch_registers => vec_to_bit(m_pcc_mapped_reg_switch_toggle), -- 1 bits (in)
			clk_switch => vec_to_bit(mappedelementswitch_i_clocking_clk_switch), -- 1 bits (in)
			rst_switch => vec_to_bit(mappedelementswitch_i_clocking_rst_switch), -- 1 bits (in)
			register_out => sig, -- 8 bits (in)
			FROM_SWITCH_SOP_N => vec_to_bit(mappedelementswitch_i_to_mappedregisters_sop_n), -- 1 bits (in)
			FROM_SWITCH_EOP_N => vec_to_bit(mappedelementswitch_i_to_mappedregisters_eop_n), -- 1 bits (in)
			FROM_SWITCH_SRC_RDY_N => vec_to_bit(mappedelementswitch_i_to_mappedregisters_src_rdy_n), -- 1 bits (in)
			FROM_SWITCH_DATA => mappedelementswitch_i_to_mappedregisters_data, -- 32 bits (in)
			TO_SWITCH_DST_RDY_N => vec_to_bit(mappedelementswitch_i_from_mappedregisters_dst_rdy_n) -- 1 bits (in)
		);
	MappedMemoriesController_i : MappedMemoriesControllerdomain0_drp_domain0domain1_STREAM_domain1
		port map (
			FROM_SWITCH_DST_RDY_N => mappedmemoriescontroller_i_from_switch_dst_rdy_n(0), -- 1 bits (out)
			TO_SWITCH_SOP_N => mappedmemoriescontroller_i_to_switch_sop_n(0), -- 1 bits (out)
			TO_SWITCH_EOP_N => mappedmemoriescontroller_i_to_switch_eop_n(0), -- 1 bits (out)
			TO_SWITCH_SRC_RDY_N => mappedmemoriescontroller_i_to_switch_src_rdy_n(0), -- 1 bits (out)
			TO_SWITCH_DATA => mappedmemoriescontroller_i_to_switch_data, -- 32 bits (out)
			domain0_drp_memories_memories_data_in => mappedmemoriescontroller_i_domain0_drp_memories_memories_data_in, -- 36 bits (out)
			domain0_drp_memories_memories_memid => mappedmemoriescontroller_i_domain0_drp_memories_memories_memid, -- 16 bits (out)
			domain0_drp_memories_memories_memaddr => mappedmemoriescontroller_i_domain0_drp_memories_memories_memaddr, -- 16 bits (out)
			domain0_drp_memories_memories_wren => mappedmemoriescontroller_i_domain0_drp_memories_memories_wren(0), -- 1 bits (out)
			domain0_drp_memories_memories_rden => mappedmemoriescontroller_i_domain0_drp_memories_memories_rden(0), -- 1 bits (out)
			domain0_drp_memories_memories_stop => mappedmemoriescontroller_i_domain0_drp_memories_memories_stop(0), -- 1 bits (out)
			domain1_STREAM_memories_memories_data_in => mappedmemoriescontroller_i_domain1_stream_memories_memories_data_in, -- 36 bits (out)
			domain1_STREAM_memories_memories_memid => mappedmemoriescontroller_i_domain1_stream_memories_memories_memid, -- 16 bits (out)
			domain1_STREAM_memories_memories_memaddr => mappedmemoriescontroller_i_domain1_stream_memories_memories_memaddr, -- 16 bits (out)
			domain1_STREAM_memories_memories_wren => mappedmemoriescontroller_i_domain1_stream_memories_memories_wren(0), -- 1 bits (out)
			domain1_STREAM_memories_memories_rden => mappedmemoriescontroller_i_domain1_stream_memories_memories_rden(0), -- 1 bits (out)
			domain1_STREAM_memories_memories_stop => mappedmemoriescontroller_i_domain1_stream_memories_memories_stop(0), -- 1 bits (out)
			clk_switch => vec_to_bit(mappedelementswitch_i_clocking_clk_switch), -- 1 bits (in)
			rst_switch => vec_to_bit(mappedelementswitch_i_clocking_rst_switch), -- 1 bits (in)
			FROM_SWITCH_SOP_N => vec_to_bit(mappedelementswitch_i_to_mappedmemories_sop_n), -- 1 bits (in)
			FROM_SWITCH_EOP_N => vec_to_bit(mappedelementswitch_i_to_mappedmemories_eop_n), -- 1 bits (in)
			FROM_SWITCH_SRC_RDY_N => vec_to_bit(mappedelementswitch_i_to_mappedmemories_src_rdy_n), -- 1 bits (in)
			FROM_SWITCH_DATA => mappedelementswitch_i_to_mappedmemories_data, -- 32 bits (in)
			TO_SWITCH_DST_RDY_N => vec_to_bit(mappedelementswitch_i_from_mappedmemories_dst_rdy_n), -- 1 bits (in)
			domain0_drp_clk => global_global_cclk, -- 1 bits (in)
			domain0_drp_rst => vec_to_bit(mec_user_rst_switch), -- 1 bits (in)
			domain0_drp_memories_memories_data_out => mappedmemoriescontroller_i_domain0_drp_memories_memories_data_out1, -- 36 bits (in)
			domain0_drp_memories_memories_ack => vec_to_bit(sig13), -- 1 bits (in)
			domain1_STREAM_clk => stream_clocks_gen_output_clk0, -- 1 bits (in)
			domain1_STREAM_rst => vec_to_bit(inst_ln10_startofdayreset_reset_out), -- 1 bits (in)
			domain1_STREAM_memories_memories_data_out => mappedmemoriescontroller_i_domain1_stream_memories_memories_data_out1, -- 36 bits (in)
			domain1_STREAM_memories_memories_ack => vec_to_bit(sig23) -- 1 bits (in)
		);
	SignalForwardingAdapter_i : SignalForwardingAdapter_stream_reset_memory_interrupt_crash_packet_sysmon_reset_pcc_switch_regs_pcc_start_pcc_reset_partial_reconfig_0
		port map (
			FROM_SWITCH_DST_RDY_N => signalforwardingadapter_i_from_switch_dst_rdy_n(0), -- 1 bits (out)
			TO_SWITCH_SOP_N => signalforwardingadapter_i_to_switch_sop_n(0), -- 1 bits (out)
			TO_SWITCH_EOP_N => signalforwardingadapter_i_to_switch_eop_n(0), -- 1 bits (out)
			TO_SWITCH_SRC_RDY_N => signalforwardingadapter_i_to_switch_src_rdy_n(0), -- 1 bits (out)
			TO_SWITCH_DATA => signalforwardingadapter_i_to_switch_data, -- 32 bits (out)
			register_out => signalforwardingadapter_i_register_out, -- 8 bits (out)
			port_out_stream_reset => signalforwardingadapter_i_port_out_stream_reset(0), -- 1 bits (out)
			port_out_memory_interrupt => signalforwardingadapter_i_port_out_memory_interrupt(0), -- 1 bits (out)
			port_out_crash_packet => signalforwardingadapter_i_port_out_crash_packet(0), -- 1 bits (out)
			port_out_sysmon_reset => signalforwardingadapter_i_port_out_sysmon_reset(0), -- 1 bits (out)
			port_out_pcc_switch_regs => signalforwardingadapter_i_port_out_pcc_switch_regs(0), -- 1 bits (out)
			port_out_pcc_start => signalforwardingadapter_i_port_out_pcc_start(0), -- 1 bits (out)
			port_out_pcc_reset => signalforwardingadapter_i_port_out_pcc_reset(0), -- 1 bits (out)
			port_out_partial_reconfig => signalforwardingadapter_i_port_out_partial_reconfig(0), -- 1 bits (out)
			FROM_SWITCH_SOP_N => vec_to_bit(mappedelementswitch_i_to_signalforwarding_sop_n), -- 1 bits (in)
			FROM_SWITCH_EOP_N => vec_to_bit(mappedelementswitch_i_to_signalforwarding_eop_n), -- 1 bits (in)
			FROM_SWITCH_SRC_RDY_N => vec_to_bit(mappedelementswitch_i_to_signalforwarding_src_rdy_n), -- 1 bits (in)
			FROM_SWITCH_DATA => mappedelementswitch_i_to_signalforwarding_data, -- 32 bits (in)
			TO_SWITCH_DST_RDY_N => vec_to_bit(mappedelementswitch_i_from_signalforwarding_dst_rdy_n), -- 1 bits (in)
			clk_switch => vec_to_bit(mappedelementswitch_i_clocking_clk_switch), -- 1 bits (in)
			rst_switch => vec_to_bit(mappedelementswitch_i_clocking_rst_switch), -- 1 bits (in)
			register_clk => vec_to_bit(sig2), -- 1 bits (in)
			register_in => sig14, -- 8 bits (in)
			register_rotate => vec_to_bit(sig4), -- 1 bits (in)
			register_stop => vec_to_bit(sig3), -- 1 bits (in)
			register_switch => vec_to_bit(sig5), -- 1 bits (in)
			port_in_stream_reset => vec_to_bit(streamrst_toggle_pcie), -- 1 bits (in)
			port_in_memory_interrupt => vec_to_bit(memory_interrupt_toggle_to_switch), -- 1 bits (in)
			port_in_crash_packet => vec_to_bit(crash_packet_toggle_to_switch), -- 1 bits (in)
			port_in_sysmon_reset => vec_to_bit("0"), -- 1 bits (in)
			port_in_pcc_switch_regs => vec_to_bit("0"), -- 1 bits (in)
			port_in_pcc_start => vec_to_bit("0"), -- 1 bits (in)
			port_in_pcc_reset => vec_to_bit("0"), -- 1 bits (in)
			port_in_partial_reconfig => vec_to_bit("0") -- 1 bits (in)
		);
	checksum_mem_drp : MappedDRP_Addr_3c0000_ChecksumMappedDRP
		port map (
			memories_data_out => checksum_mem_drp_memories_data_out, -- 36 bits (out)
			memories_ack => checksum_mem_drp_memories_ack(0), -- 1 bits (out)
			memories_data_in => sig6, -- 36 bits (in)
			memories_memid => sig7, -- 16 bits (in)
			memories_memaddr => sig8, -- 16 bits (in)
			memories_wren => vec_to_bit(sig9), -- 1 bits (in)
			memories_rden => vec_to_bit(sig10), -- 1 bits (in)
			memories_stop => vec_to_bit(sig11), -- 1 bits (in)
			clk => global_global_cclk -- 1 bits (in)
		);
	wrapper_entity : Manager_CpuStream
		port map (
			child_0_stall => wrapper_entity_child_0_stall(0), -- 1 bits (out)
			child_1_stall => wrapper_entity_child_1_stall(0), -- 1 bits (out)
			child_2_stall => wrapper_entity_child_2_stall(0), -- 1 bits (out)
			child_3_stall => wrapper_entity_child_3_stall(0), -- 1 bits (out)
			data_w_valid => wrapper_entity_data_w_valid(0), -- 1 bits (out)
			data_w_done => wrapper_entity_data_w_done(0), -- 1 bits (out)
			data_w_data => wrapper_entity_data_w_data, -- 128 bits (out)
			mapped_reg_io_CpuStreamKernel_0_register_out => wrapper_entity_mapped_reg_io_cpustreamkernel_0_register_out, -- 8 bits (out)
			toggle_ack => wrapper_entity_toggle_ack(0), -- 1 bits (out)
			active => wrapper_entity_active(0), -- 1 bits (out)
			child_0_valid => vec_to_bit(dynpcie_sfh0_valid), -- 1 bits (in)
			child_0_done => vec_to_bit(dynpcie_sfh0_done), -- 1 bits (in)
			child_0_data => wrapper_entity_child_0_data1, -- 128 bits (in)
			child_1_valid => vec_to_bit(dynpcie_sfh1_valid), -- 1 bits (in)
			child_1_done => vec_to_bit(dynpcie_sfh1_done), -- 1 bits (in)
			child_1_data => wrapper_entity_child_1_data1, -- 128 bits (in)
			child_2_valid => vec_to_bit(dynpcie_sfh2_valid), -- 1 bits (in)
			child_2_done => vec_to_bit(dynpcie_sfh2_done), -- 1 bits (in)
			child_2_data => wrapper_entity_child_2_data1, -- 128 bits (in)
			child_3_valid => vec_to_bit(dynpcie_sfh3_valid), -- 1 bits (in)
			child_3_done => vec_to_bit(dynpcie_sfh3_done), -- 1 bits (in)
			child_3_data => wrapper_entity_child_3_data1, -- 128 bits (in)
			data_w_stall => vec_to_bit(dynpcie_sth0_stall), -- 1 bits (in)
			STREAM => stream_clocks_gen_output_clk0, -- 1 bits (in)
			STREAM_NOBUF => stream_clocks_gen_output_clk_nobuf0, -- 1 bits (in)
			STREAM_RST => vec_to_bit(STREAM_reset_reg_1), -- 1 bits (in)
			STREAM_RST_DELAY => vec_to_bit(STREAM_reset_late_reg_1), -- 1 bits (in)
			PCIE => pcie_pcie_clocking_clk_pcie, -- 1 bits (in)
			PCIE_NOBUF => pcie_pcie_clocking_clk_pcie, -- 1 bits (in)
			PCIE_RST => vec_to_bit(PCIE_reset_reg_1), -- 1 bits (in)
			PCIE_RST_DELAY => vec_to_bit(PCIE_reset_late_reg_1), -- 1 bits (in)
			mapped_reg_io_CpuStreamKernel_0_register_clk => vec_to_bit(sig2), -- 1 bits (in)
			mapped_reg_io_CpuStreamKernel_0_register_in => sig15, -- 8 bits (in)
			mapped_reg_io_CpuStreamKernel_0_register_rotate => vec_to_bit(sig4), -- 1 bits (in)
			mapped_reg_io_CpuStreamKernel_0_register_stop => vec_to_bit(sig3), -- 1 bits (in)
			mapped_reg_io_CpuStreamKernel_0_register_switch => vec_to_bit(sig5), -- 1 bits (in)
			toggle => vec_to_bit(crash_packet_toggle_from_barspace), -- 1 bits (in)
			partial_reconfig => vec_to_bit(reg_ln434_fpgawrapperentity) -- 1 bits (in)
		);
	inst_ln11_bussynchroniser5 : vhdl_bus_synchronizer
		generic map (
			width => 1
		)
		port map (
			dat_o => inst_ln11_bussynchroniser5_dat_o, -- 1 bits (out)
			clk => global_global_cclk, -- 1 bits (in)
			rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => wrapper_entity_toggle_ack -- 1 bits (in)
		);
	dynpcie : PCIeStreaming_2_5
		port map (
			dma_complete_sfh => dynpcie_dma_complete_sfh, -- 32 bits (out)
			dma_complete_sth => dynpcie_dma_complete_sth, -- 32 bits (out)
			dma_ctl_read_data => dynpcie_dma_ctl_read_data, -- 64 bits (out)
			valid => dynpcie_valid(0), -- 1 bits (out)
			enable_id => dynpcie_enable_id, -- 32 bits (out)
			PCIeTXDMAReadRequestsIOGroupDef_dma_read_req => dynpcie_pcietxdmareadrequestsiogroupdef_dma_read_req(0), -- 1 bits (out)
			PCIeTXDMAReadRequestsIOGroupDef_dma_read_addr => dynpcie_pcietxdmareadrequestsiogroupdef_dma_read_addr, -- 64 bits (out)
			PCIeTXDMAReadRequestsIOGroupDef_dma_read_len => dynpcie_pcietxdmareadrequestsiogroupdef_dma_read_len, -- 10 bits (out)
			PCIeTXDMAReadRequestsIOGroupDef_dma_read_be => dynpcie_pcietxdmareadrequestsiogroupdef_dma_read_be, -- 4 bits (out)
			PCIeTXDMAReadRequestsIOGroupDef_dma_read_tag => dynpcie_pcietxdmareadrequestsiogroupdef_dma_read_tag, -- 8 bits (out)
			PCIeTXDMAReadRequestsIOGroupDef_dma_read_wide_addr => dynpcie_pcietxdmareadrequestsiogroupdef_dma_read_wide_addr(0), -- 1 bits (out)
			PCIeTXDMAWriteRequestsIOGroupDef_req => dynpcie_pcietxdmawriterequestsiogroupdef_req(0), -- 1 bits (out)
			PCIeTXDMAWriteRequestsIOGroupDef_addr => dynpcie_pcietxdmawriterequestsiogroupdef_addr, -- 64 bits (out)
			PCIeTXDMAWriteRequestsIOGroupDef_tag => dynpcie_pcietxdmawriterequestsiogroupdef_tag, -- 8 bits (out)
			PCIeTXDMAWriteRequestsIOGroupDef_len => dynpcie_pcietxdmawriterequestsiogroupdef_len, -- 9 bits (out)
			PCIeTXDMAWriteRequestsIOGroupDef_wide_addr => dynpcie_pcietxdmawriterequestsiogroupdef_wide_addr(0), -- 1 bits (out)
			PCIeTXDMAWriteRequestsIOGroupDef_rddata => dynpcie_pcietxdmawriterequestsiogroupdef_rddata, -- 128 bits (out)
			PCIeBarReadableStatusRegisters_tx_fifo_empty => dynpcie_pciebarreadablestatusregisters_tx_fifo_empty(0), -- 1 bits (out)
			register_out => dynpcie_register_out, -- 8 bits (out)
			sth0_stall => dynpcie_sth0_stall(0), -- 1 bits (out)
			sth_cap_0 => dynpcie_sth_cap_0, -- 8 bits (out)
			sth_cap_ctrl_0 => dynpcie_sth_cap_ctrl_0, -- 8 bits (out)
			sfh0_valid => dynpcie_sfh0_valid(0), -- 1 bits (out)
			sfh0_done => dynpcie_sfh0_done(0), -- 1 bits (out)
			sfh0_data => dynpcie_sfh0_data, -- 128 bits (out)
			SFHCredits0_index => dynpcie_sfhcredits0_index, -- 1 bits (out)
			SFHCredits0_update => dynpcie_sfhcredits0_update(0), -- 1 bits (out)
			SFHCredits0_wrap => dynpcie_sfhcredits0_wrap(0), -- 1 bits (out)
			sfh_cap_0 => dynpcie_sfh_cap_0, -- 8 bits (out)
			sfh1_valid => dynpcie_sfh1_valid(0), -- 1 bits (out)
			sfh1_done => dynpcie_sfh1_done(0), -- 1 bits (out)
			sfh1_data => dynpcie_sfh1_data, -- 128 bits (out)
			SFHCredits1_index => dynpcie_sfhcredits1_index, -- 1 bits (out)
			SFHCredits1_update => dynpcie_sfhcredits1_update(0), -- 1 bits (out)
			SFHCredits1_wrap => dynpcie_sfhcredits1_wrap(0), -- 1 bits (out)
			sfh_cap_1 => dynpcie_sfh_cap_1, -- 8 bits (out)
			sfh2_valid => dynpcie_sfh2_valid(0), -- 1 bits (out)
			sfh2_done => dynpcie_sfh2_done(0), -- 1 bits (out)
			sfh2_data => dynpcie_sfh2_data, -- 128 bits (out)
			SFHCredits2_index => dynpcie_sfhcredits2_index, -- 1 bits (out)
			SFHCredits2_update => dynpcie_sfhcredits2_update(0), -- 1 bits (out)
			SFHCredits2_wrap => dynpcie_sfhcredits2_wrap(0), -- 1 bits (out)
			sfh_cap_2 => dynpcie_sfh_cap_2, -- 8 bits (out)
			sfh3_valid => dynpcie_sfh3_valid(0), -- 1 bits (out)
			sfh3_done => dynpcie_sfh3_done(0), -- 1 bits (out)
			sfh3_data => dynpcie_sfh3_data, -- 128 bits (out)
			SFHCredits3_index => dynpcie_sfhcredits3_index, -- 1 bits (out)
			SFHCredits3_update => dynpcie_sfhcredits3_update(0), -- 1 bits (out)
			SFHCredits3_wrap => dynpcie_sfhcredits3_wrap(0), -- 1 bits (out)
			sfh_cap_3 => dynpcie_sfh_cap_3, -- 8 bits (out)
			sfh_cap_ctrl_0 => dynpcie_sfh_cap_ctrl_0, -- 8 bits (out)
			sfh4_valid => dynpcie_sfh4_valid(0), -- 1 bits (out)
			sfh4_done => dynpcie_sfh4_done(0), -- 1 bits (out)
			sfh4_data => dynpcie_sfh4_data, -- 128 bits (out)
			SFHCredits4_index => dynpcie_sfhcredits4_index, -- 1 bits (out)
			SFHCredits4_update => dynpcie_sfhcredits4_update(0), -- 1 bits (out)
			SFHCredits4_wrap => dynpcie_sfhcredits4_wrap(0), -- 1 bits (out)
			sth1_stall => dynpcie_sth1_stall(0), -- 1 bits (out)
			clk => pcie_pcie_clocking_clk_pcie, -- 1 bits (in)
			rst => vec_to_bit(PCIE_reset_pipe_0), -- 1 bits (in)
			PCIeClockingIOGroupDef_clk_pcie => pcie_pcie_clocking_clk_pcie, -- 1 bits (in)
			PCIeClockingIOGroupDef_rst_pcie_n => pcie_pcie_clocking_rst_pcie_n, -- 1 bits (in)
			dma_abort_sfh => pcie_pcie_dma_control_dma_abort_sfh, -- 32 bits (in)
			dma_abort_sth => pcie_pcie_dma_control_dma_abort_sth, -- 32 bits (in)
			dma_ctl_address => pcie_pcie_dma_control_dma_ctl_address, -- 9 bits (in)
			dma_ctl_data => pcie_pcie_dma_control_dma_ctl_data, -- 64 bits (in)
			dma_ctl_write => pcie_pcie_dma_control_dma_ctl_write, -- 1 bits (in)
			dma_ctl_byte_en => pcie_pcie_dma_control_dma_ctl_byte_en, -- 8 bits (in)
			PCIeRXDMAReadResponseIOGroupDef_dma_response_data => pcie_pcie_rxdma_dma_response_data, -- 128 bits (in)
			PCIeRXDMAReadResponseIOGroupDef_dma_response_valid => pcie_pcie_rxdma_dma_response_valid, -- 2 bits (in)
			PCIeRXDMAReadResponseIOGroupDef_dma_response_len => pcie_pcie_rxdma_dma_response_len, -- 10 bits (in)
			PCIeRXDMAReadResponseIOGroupDef_dma_response_tag => pcie_pcie_rxdma_dma_response_tag, -- 8 bits (in)
			PCIeRXDMAReadResponseIOGroupDef_dma_response_complete => pcie_pcie_rxdma_dma_response_complete, -- 1 bits (in)
			PCIeRXDMAReadResponseIOGroupDef_dma_response_ready => pcie_pcie_rxdma_dma_response_ready, -- 1 bits (in)
			PCIeTXDMAReadRequestsIOGroupDef_dma_read_ack => pcie_pcie_dmareadreq_dma_read_ack, -- 1 bits (in)
			PCIeTXDMAWriteRequestsIOGroupDef_ack => pcie_pcie_dmawritereq_ack, -- 1 bits (in)
			PCIeTXDMAWriteRequestsIOGroupDef_done => pcie_pcie_dmawritereq_done, -- 1 bits (in)
			PCIeTXDMAWriteRequestsIOGroupDef_busy => pcie_pcie_dmawritereq_busy, -- 1 bits (in)
			PCIeTXDMAWriteRequestsIOGroupDef_rden => pcie_pcie_dmawritereq_rden, -- 1 bits (in)
			BarSpaceExternalParserIOGroupDef_wr_addr_onehot => pcie_pcie_bar_parse_wr_addr_onehot, -- 256 bits (in)
			BarSpaceExternalParserIOGroupDef_wr_data => pcie_pcie_bar_parse_wr_data, -- 64 bits (in)
			BarSpaceExternalParserIOGroupDef_wr_clk => pcie_pcie_bar_parse_wr_clk, -- 1 bits (in)
			BarSpaceExternalParserIOGroupDef_wr_page_sel_onehot => pcie_pcie_bar_parse_wr_page_sel_onehot, -- 2 bits (in)
			register_clk => vec_to_bit(sig2), -- 1 bits (in)
			register_in => sig16, -- 8 bits (in)
			register_rotate => vec_to_bit(sig4), -- 1 bits (in)
			register_stop => vec_to_bit(sig3), -- 1 bits (in)
			register_switch => vec_to_bit(sig5), -- 1 bits (in)
			sth0_valid => vec_to_bit(wrapper_entity_data_w_valid), -- 1 bits (in)
			sth0_done => vec_to_bit(wrapper_entity_data_w_done), -- 1 bits (in)
			sth0_data => dynpcie_sth0_data1, -- 128 bits (in)
			sfh0_stall => vec_to_bit(wrapper_entity_child_0_stall), -- 1 bits (in)
			sfh1_stall => vec_to_bit(wrapper_entity_child_1_stall), -- 1 bits (in)
			sfh2_stall => vec_to_bit(wrapper_entity_child_2_stall), -- 1 bits (in)
			sfh3_stall => vec_to_bit(wrapper_entity_child_3_stall), -- 1 bits (in)
			sfh4_stall => pcie_pcie_control_sfh_stall, -- 1 bits (in)
			sth1_valid => pcie_pcie_control_sth_valid, -- 1 bits (in)
			sth1_done => pcie_pcie_control_sth_done, -- 1 bits (in)
			sth1_data => pcie_pcie_control_sth_data -- 128 bits (in)
		);
	inst_ln12_inputsynchronisedsynchroniser : vhdl_input_synchronized_bus_synchronizer
		generic map (
			width => 1,
			reset_value => 0,
			IS_VIRTEX6 => false
		)
		port map (
			dat_o => inst_ln12_inputsynchronisedsynchroniser_dat_o, -- 1 bits (out)
			in_clk => pcie_pcie_clocking_clk_pcie, -- 1 bits (in)
			in_rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => bit_to_vec(pcie_pcie_sfa_user_toggle), -- 1 bits (in)
			out_clk => global_global_cclk, -- 1 bits (in)
			out_rst => vec_to_bit("0") -- 1 bits (in)
		);
	inst_ln12_inputsynchronisedsynchroniser1 : vhdl_input_synchronized_bus_synchronizer
		generic map (
			width => 1,
			reset_value => 0,
			IS_VIRTEX6 => false
		)
		port map (
			dat_o => inst_ln12_inputsynchronisedsynchroniser1_dat_o, -- 1 bits (out)
			in_clk => global_global_cclk, -- 1 bits (in)
			in_rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => crash_packet_toggle_to_barspace, -- 1 bits (in)
			out_clk => pcie_pcie_clocking_clk_pcie, -- 1 bits (in)
			out_rst => vec_to_bit("0") -- 1 bits (in)
		);
	MappedElementAdapterForwarder_pcie_i : MappedElementAdapterForwarder
		port map (
			FROM_SWITCH_DST_RDY_N => mappedelementadapterforwarder_pcie_i_from_switch_dst_rdy_n(0), -- 1 bits (out)
			FROM_SWITCH_FWD_SOP_N => mappedelementadapterforwarder_pcie_i_from_switch_fwd_sop_n(0), -- 1 bits (out)
			FROM_SWITCH_FWD_EOP_N => mappedelementadapterforwarder_pcie_i_from_switch_fwd_eop_n(0), -- 1 bits (out)
			FROM_SWITCH_FWD_SRC_RDY_N => mappedelementadapterforwarder_pcie_i_from_switch_fwd_src_rdy_n(0), -- 1 bits (out)
			FROM_SWITCH_FWD_DATA => mappedelementadapterforwarder_pcie_i_from_switch_fwd_data, -- 32 bits (out)
			TO_SWITCH_SOP_N => mappedelementadapterforwarder_pcie_i_to_switch_sop_n(0), -- 1 bits (out)
			TO_SWITCH_EOP_N => mappedelementadapterforwarder_pcie_i_to_switch_eop_n(0), -- 1 bits (out)
			TO_SWITCH_SRC_RDY_N => mappedelementadapterforwarder_pcie_i_to_switch_src_rdy_n(0), -- 1 bits (out)
			TO_SWITCH_DATA => mappedelementadapterforwarder_pcie_i_to_switch_data, -- 32 bits (out)
			TO_SWITCH_FWD_DST_RDY_N => mappedelementadapterforwarder_pcie_i_to_switch_fwd_dst_rdy_n(0), -- 1 bits (out)
			clocking_fwd_clk_switch => mappedelementadapterforwarder_pcie_i_clocking_fwd_clk_switch(0), -- 1 bits (out)
			clocking_fwd_rst_switch => mappedelementadapterforwarder_pcie_i_clocking_fwd_rst_switch(0), -- 1 bits (out)
			FROM_SWITCH_SOP_N => vec_to_bit(mappedelementswitch_i_to_pcie_sop_n), -- 1 bits (in)
			FROM_SWITCH_EOP_N => vec_to_bit(mappedelementswitch_i_to_pcie_eop_n), -- 1 bits (in)
			FROM_SWITCH_SRC_RDY_N => vec_to_bit(mappedelementswitch_i_to_pcie_src_rdy_n), -- 1 bits (in)
			FROM_SWITCH_DATA => mappedelementswitch_i_to_pcie_data, -- 32 bits (in)
			FROM_SWITCH_FWD_DST_RDY_N => pcie_pcie_mec_fwd_write_port_DST_RDY_N, -- 1 bits (in)
			TO_SWITCH_DST_RDY_N => vec_to_bit(mappedelementswitch_i_from_pcie_dst_rdy_n), -- 1 bits (in)
			TO_SWITCH_FWD_SOP_N => pcie_pcie_mec_fwd_read_port_SOP_N, -- 1 bits (in)
			TO_SWITCH_FWD_EOP_N => pcie_pcie_mec_fwd_read_port_EOP_N, -- 1 bits (in)
			TO_SWITCH_FWD_SRC_RDY_N => pcie_pcie_mec_fwd_read_port_SRC_RDY_N, -- 1 bits (in)
			TO_SWITCH_FWD_DATA => pcie_pcie_mec_fwd_read_port_DATA, -- 32 bits (in)
			clocking_clk_switch => vec_to_bit(mappedelementswitch_i_clocking_clk_switch), -- 1 bits (in)
			clocking_rst_switch => vec_to_bit(mappedelementswitch_i_clocking_rst_switch) -- 1 bits (in)
		);
	mec_rst_user_synchronizer : vhdl_input_synchronized_bus_synchronizer
		generic map (
			width => 1,
			reset_value => 0,
			IS_VIRTEX6 => false
		)
		port map (
			dat_o => mec_rst_user_synchronizer_dat_o, -- 1 bits (out)
			in_clk => pcie_pcie_clocking_clk_pcie, -- 1 bits (in)
			in_rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => bit_to_vec(pcie_pcie_user_control_rst_user), -- 1 bits (in)
			out_clk => global_global_cclk, -- 1 bits (in)
			out_rst => vec_to_bit("0") -- 1 bits (in)
		);
	inst_ln11_bussynchroniser6 : vhdl_bus_synchronizer
		generic map (
			width => 1
		)
		port map (
			dat_o => inst_ln11_bussynchroniser6_dat_o, -- 1 bits (out)
			clk => pcie_pcie_clocking_clk_pcie, -- 1 bits (in)
			rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => stream_reset_out -- 1 bits (in)
		);
	inst_ln11_bussynchroniser7 : vhdl_bus_synchronizer
		generic map (
			width => 1
		)
		port map (
			dat_o => inst_ln11_bussynchroniser7_dat_o, -- 1 bits (out)
			clk => pcie_pcie_clocking_clk_pcie, -- 1 bits (in)
			rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => stream_reset_late_pulse -- 1 bits (in)
		);
	inst_ln11_bussynchroniser8 : vhdl_bus_synchronizer
		generic map (
			width => 1
		)
		port map (
			dat_o => inst_ln11_bussynchroniser8_dat_o, -- 1 bits (out)
			clk => global_global_cclk, -- 1 bits (in)
			rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => "0" -- 1 bits (in)
		);
	perfmon : PerfMonitor
		port map (
			perf_memories_data_out => perfmon_perf_memories_data_out, -- 36 bits (out)
			perf_memories_ack => perfmon_perf_memories_ack(0), -- 1 bits (out)
			clk => stream_clocks_gen_output_clk0, -- 1 bits (in)
			rst => vec_to_bit("0"), -- 1 bits (in)
			active => vec_to_bit(wrapper_entity_active), -- 1 bits (in)
			ecc_flags => "00", -- 2 bits (in)
			ecc_parity => "00000000000000000000000000000000", -- 32 bits (in)
			ecc_corrected => "00000000000000000000000000000000", -- 32 bits (in)
			Mem_Data_time1 => "00000000000000000000000000000000", -- 32 bits (in)
			Mem_Data_time2 => "00000000000000000000000000000000", -- 32 bits (in)
			Mem_Idle_time1 => "00000000000000000000000000000000", -- 32 bits (in)
			Mem_Idle_time2 => "00000000000000000000000000000000", -- 32 bits (in)
			perf_update => vec_to_bit(inst_ln11_bussynchroniser9_dat_o), -- 1 bits (in)
			perf_memories_data_in => sig17, -- 36 bits (in)
			perf_memories_memid => sig18, -- 16 bits (in)
			perf_memories_memaddr => sig19, -- 16 bits (in)
			perf_memories_wren => vec_to_bit(sig20), -- 1 bits (in)
			perf_memories_rden => vec_to_bit(sig21), -- 1 bits (in)
			perf_memories_stop => vec_to_bit(sig22), -- 1 bits (in)
			qdr_phy_init_done => vec_to_bit("1"), -- 1 bits (in)
			ddr_phy_init_done => vec_to_bit("1"), -- 1 bits (in)
			ifpga0_up => vec_to_bit("1"), -- 1 bits (in)
			ifpga1_up => vec_to_bit("1"), -- 1 bits (in)
			ifpga2_up => vec_to_bit("1"), -- 1 bits (in)
			ifpga3_up => vec_to_bit("1"), -- 1 bits (in)
			ifpga4_up => vec_to_bit("1") -- 1 bits (in)
		);
	inst_ln10_startofdayreset : start_of_day_reset
		port map (
			reset_out => inst_ln10_startofdayreset_reset_out(0), -- 1 bits (out)
			rst_n => global_global_reset_n, -- 1 bits (in)
			reset_clk => stream_clocks_gen_output_clk0 -- 1 bits (in)
		);
	inst_ln11_bussynchroniser9 : vhdl_bus_synchronizer
		generic map (
			width => 1
		)
		port map (
			dat_o => inst_ln11_bussynchroniser9_dat_o, -- 1 bits (out)
			clk => stream_clocks_gen_output_clk0, -- 1 bits (in)
			rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => "0" -- 1 bits (in)
		);
end MaxDC;
