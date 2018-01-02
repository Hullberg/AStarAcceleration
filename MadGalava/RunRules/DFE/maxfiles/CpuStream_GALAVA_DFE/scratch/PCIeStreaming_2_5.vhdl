library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity PCIeStreaming_2_5 is
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
end PCIeStreaming_2_5;

architecture MaxDC of PCIeStreaming_2_5 is
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
	component MappedRegBlock_68934a3e9455fa72420237eb05902327 is
		port (
			register_clk: in std_logic;
			register_in: in std_logic_vector(7 downto 0);
			register_rotate: in std_logic;
			register_stop: in std_logic;
			register_switch: in std_logic;
			register_out: out std_logic_vector(7 downto 0)
		);
	end component;
	component RequestEncoder is
		port (
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			streamrst_pcie: in std_logic;
			read_ready: in std_logic;
			read_len: in std_logic_vector(6 downto 0);
			read_addr: in std_logic_vector(60 downto 0);
			read_tag: in std_logic_vector(7 downto 0);
			dma_read_ack: in std_logic;
			write_ready: in std_logic;
			write_last: in std_logic;
			write_id: in std_logic_vector(31 downto 0);
			write_len: in std_logic_vector(8 downto 0);
			write_addr: in std_logic_vector(60 downto 0);
			write_tag: in std_logic_vector(7 downto 0);
			write_data: in std_logic_vector(127 downto 0);
			write_data_valid: in std_logic;
			tx_dma_write_ack: in std_logic;
			tx_dma_write_done: in std_logic;
			tx_dma_write_busy: in std_logic;
			tx_dma_write_rden: in std_logic;
			tx_stop: in std_logic;
			read_done: out std_logic;
			dma_read_req: out std_logic;
			dma_read_addr: out std_logic_vector(63 downto 0);
			dma_read_len: out std_logic_vector(9 downto 0);
			dma_read_be: out std_logic_vector(3 downto 0);
			dma_read_tag: out std_logic_vector(7 downto 0);
			dma_read_wide_addr: out std_logic;
			write_done: out std_logic;
			write_data_read: out std_logic;
			tx_dma_write_req: out std_logic;
			tx_dma_write_addr: out std_logic_vector(63 downto 0);
			tx_dma_write_tag: out std_logic_vector(7 downto 0);
			tx_dma_write_len: out std_logic_vector(8 downto 0);
			tx_dma_write_wide_addr: out std_logic;
			tx_dma_write_rddata: out std_logic_vector(127 downto 0);
			interrupt_ctl_valid: out std_logic;
			interrupt_ctl_enable_id: out std_logic_vector(31 downto 0);
			tx_fifo_empty: out std_logic
		);
	end component;
	component TXStopBarParser is
		port (
			bar_parse_wr_addr_onehot: in std_logic_vector(255 downto 0);
			bar_parse_wr_data: in std_logic_vector(63 downto 0);
			bar_parse_wr_clk: in std_logic;
			bar_parse_wr_page_sel_onehot: in std_logic_vector(1 downto 0);
			rst_sync: in std_logic;
			tx_stop: out std_logic
		);
	end component;
	component ResponseDecoder is
		port (
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			dma_response_data: in std_logic_vector(127 downto 0);
			dma_response_valid: in std_logic_vector(1 downto 0);
			dma_response_len: in std_logic_vector(9 downto 0);
			dma_response_tag: in std_logic_vector(7 downto 0);
			dma_response_complete: in std_logic;
			dma_response_ready: in std_logic;
			decoded_data: out std_logic_vector(127 downto 0);
			decoded_data_valid: out std_logic_vector(1 downto 0);
			decoded_tag: out std_logic_vector(7 downto 0);
			decoded_complete: out std_logic;
			decoded_ready: out std_logic
		);
	end component;
	component TagManager is
		port (
			streamrst_pcie: in std_logic;
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			in_write_req_ready: in std_logic;
			in_write_req_last: in std_logic;
			in_write_req_id: in std_logic_vector(31 downto 0);
			in_write_req_len: in std_logic_vector(8 downto 0);
			in_write_req_addr: in std_logic_vector(60 downto 0);
			in_write_req_data: in std_logic_vector(127 downto 0);
			in_write_req_data_valid: in std_logic;
			out_write_req_done: in std_logic;
			out_write_req_data_read: in std_logic;
			in_read_req_ready: in std_logic;
			in_read_req_len: in std_logic_vector(6 downto 0);
			in_read_req_addr: in std_logic_vector(60 downto 0);
			in_read_req_metadata: in std_logic_vector(35 downto 0);
			out_read_req_done: in std_logic;
			in_read_response_data: in std_logic_vector(127 downto 0);
			in_read_response_data_valid: in std_logic_vector(1 downto 0);
			in_read_response_tag: in std_logic_vector(7 downto 0);
			in_read_response_complete: in std_logic;
			in_read_response_ready: in std_logic;
			out_read_response_metadata_free: in std_logic;
			in_write_req_done: out std_logic;
			in_write_req_data_read: out std_logic;
			out_write_req_ready: out std_logic;
			out_write_req_last: out std_logic;
			out_write_req_id: out std_logic_vector(31 downto 0);
			out_write_req_len: out std_logic_vector(8 downto 0);
			out_write_req_addr: out std_logic_vector(60 downto 0);
			out_write_req_tag: out std_logic_vector(7 downto 0);
			out_write_req_data: out std_logic_vector(127 downto 0);
			out_write_req_data_valid: out std_logic;
			in_read_req_done: out std_logic;
			out_read_req_ready: out std_logic;
			out_read_req_len: out std_logic_vector(6 downto 0);
			out_read_req_addr: out std_logic_vector(60 downto 0);
			out_read_req_tag: out std_logic_vector(7 downto 0);
			out_read_response_data_valid: out std_logic_vector(1 downto 0);
			out_read_response_data: out std_logic_vector(127 downto 0);
			out_read_response_metadata: out std_logic_vector(35 downto 0);
			out_read_response_metadata_valid: out std_logic
		);
	end component;
	component MemReadRequestArbiter is
		port (
			streamrst_pcie: in std_logic;
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			output_done: in std_logic;
			port0_ready: in std_logic;
			port0_len: in std_logic_vector(6 downto 0);
			port0_addr: in std_logic_vector(60 downto 0);
			port0_metadata: in std_logic_vector(27 downto 0);
			port1_ready: in std_logic;
			port1_len: in std_logic_vector(6 downto 0);
			port1_addr: in std_logic_vector(60 downto 0);
			port1_metadata: in std_logic_vector(27 downto 0);
			port2_ready: in std_logic;
			port2_len: in std_logic_vector(6 downto 0);
			port2_addr: in std_logic_vector(60 downto 0);
			port2_metadata: in std_logic_vector(27 downto 0);
			port3_ready: in std_logic;
			port3_len: in std_logic_vector(6 downto 0);
			port3_addr: in std_logic_vector(60 downto 0);
			port3_metadata: in std_logic_vector(27 downto 0);
			port4_ready: in std_logic;
			port4_len: in std_logic_vector(6 downto 0);
			port4_addr: in std_logic_vector(60 downto 0);
			port4_metadata: in std_logic_vector(27 downto 0);
			port5_ready: in std_logic;
			port5_len: in std_logic_vector(6 downto 0);
			port5_addr: in std_logic_vector(60 downto 0);
			port5_metadata: in std_logic_vector(27 downto 0);
			output_ready: out std_logic;
			output_len: out std_logic_vector(6 downto 0);
			output_addr: out std_logic_vector(60 downto 0);
			output_metadata: out std_logic_vector(35 downto 0);
			port0_select: out std_logic;
			port1_select: out std_logic;
			port2_select: out std_logic;
			port3_select: out std_logic;
			port4_select: out std_logic;
			port5_select: out std_logic
		);
	end component;
	component MemWriteRequestArbiter is
		port (
			streamrst_pcie: in std_logic;
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			output_done: in std_logic;
			output_data_read: in std_logic;
			port0_ready: in std_logic;
			port0_last: in std_logic;
			port0_len: in std_logic_vector(8 downto 0);
			port0_addr: in std_logic_vector(60 downto 0);
			port0_data: in std_logic_vector(127 downto 0);
			port0_data_valid: in std_logic;
			port1_ready: in std_logic;
			port1_last: in std_logic;
			port1_len: in std_logic_vector(8 downto 0);
			port1_addr: in std_logic_vector(60 downto 0);
			port1_data: in std_logic_vector(127 downto 0);
			port1_data_valid: in std_logic;
			port2_ready: in std_logic;
			port2_last: in std_logic;
			port2_len: in std_logic_vector(8 downto 0);
			port2_addr: in std_logic_vector(60 downto 0);
			port2_data: in std_logic_vector(127 downto 0);
			port2_data_valid: in std_logic;
			output_ready: out std_logic;
			output_last: out std_logic;
			output_id: out std_logic_vector(31 downto 0);
			output_len: out std_logic_vector(8 downto 0);
			output_addr: out std_logic_vector(60 downto 0);
			output_data: out std_logic_vector(127 downto 0);
			output_data_valid: out std_logic;
			port0_select: out std_logic;
			port0_data_read: out std_logic;
			port1_select: out std_logic;
			port1_data_read: out std_logic;
			port2_select: out std_logic;
			port2_data_read: out std_logic
		);
	end component;
	component MemReadResponseDispatcher is
		port (
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			decoder_data_valid: in std_logic_vector(1 downto 0);
			decoder_data: in std_logic_vector(127 downto 0);
			decoder_metadata: in std_logic_vector(35 downto 0);
			decoder_metadata_valid: in std_logic;
			receiver0_metadata_free: in std_logic;
			receiver1_metadata_free: in std_logic;
			receiver2_metadata_free: in std_logic;
			receiver3_metadata_free: in std_logic;
			receiver4_metadata_free: in std_logic;
			receiver5_metadata_free: in std_logic;
			decoder_metadata_free: out std_logic;
			receiver0_valid: out std_logic_vector(1 downto 0);
			receiver0_data: out std_logic_vector(127 downto 0);
			receiver0_select: out std_logic;
			receiver0_metadata: out std_logic_vector(27 downto 0);
			receiver0_metadata_valid: out std_logic;
			receiver1_valid: out std_logic_vector(1 downto 0);
			receiver1_data: out std_logic_vector(127 downto 0);
			receiver1_select: out std_logic;
			receiver1_metadata: out std_logic_vector(27 downto 0);
			receiver1_metadata_valid: out std_logic;
			receiver2_valid: out std_logic_vector(1 downto 0);
			receiver2_data: out std_logic_vector(127 downto 0);
			receiver2_select: out std_logic;
			receiver2_metadata: out std_logic_vector(27 downto 0);
			receiver2_metadata_valid: out std_logic;
			receiver3_valid: out std_logic_vector(1 downto 0);
			receiver3_data: out std_logic_vector(127 downto 0);
			receiver3_select: out std_logic;
			receiver3_metadata: out std_logic_vector(27 downto 0);
			receiver3_metadata_valid: out std_logic;
			receiver4_valid: out std_logic_vector(1 downto 0);
			receiver4_data: out std_logic_vector(127 downto 0);
			receiver4_select: out std_logic;
			receiver4_metadata: out std_logic_vector(27 downto 0);
			receiver4_metadata_valid: out std_logic;
			receiver5_valid: out std_logic_vector(1 downto 0);
			receiver5_data: out std_logic_vector(127 downto 0);
			receiver5_select: out std_logic;
			receiver5_metadata: out std_logic_vector(27 downto 0);
			receiver5_metadata_valid: out std_logic
		);
	end component;
	component SGListFetchEngine is
		port (
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			streamrst_pcie: in std_logic;
			response_valid: in std_logic_vector(1 downto 0);
			response_data: in std_logic_vector(127 downto 0);
			response_select: in std_logic;
			response_metadata: in std_logic_vector(27 downto 0);
			response_metadata_valid: in std_logic;
			request_select: in std_logic;
			dma_abort_sfh: in std_logic_vector(31 downto 0);
			dma_abort_sth: in std_logic_vector(31 downto 0);
			dma_ctl_address: in std_logic_vector(8 downto 0);
			dma_ctl_data: in std_logic_vector(63 downto 0);
			dma_ctl_write: in std_logic;
			dma_ctl_byte_en: in std_logic_vector(7 downto 0);
			bar_parse_wr_addr_onehot: in std_logic_vector(255 downto 0);
			bar_parse_wr_data: in std_logic_vector(63 downto 0);
			bar_parse_wr_clk: in std_logic;
			bar_parse_wr_page_sel_onehot: in std_logic_vector(1 downto 0);
			sfh0_port_dma_complete: in std_logic;
			sfh0_port_entry_complete: in std_logic;
			sfh0_port_entry_read: in std_logic;
			sfh1_port_dma_complete: in std_logic;
			sfh1_port_entry_complete: in std_logic;
			sfh1_port_entry_read: in std_logic;
			sfh2_port_dma_complete: in std_logic;
			sfh2_port_entry_complete: in std_logic;
			sfh2_port_entry_read: in std_logic;
			sfh3_port_dma_complete: in std_logic;
			sfh3_port_entry_complete: in std_logic;
			sfh3_port_entry_read: in std_logic;
			sfh4_port_dma_complete: in std_logic;
			sfh4_port_entry_complete: in std_logic;
			sfh4_port_entry_read: in std_logic;
			sg_ring_write_sfh4_select: in std_logic;
			sg_ring_write_sfh4_data_read: in std_logic;
			sth0_port_dma_complete: in std_logic;
			sth0_port_entry_complete: in std_logic;
			sth0_port_entry_read: in std_logic;
			sth1_port_dma_complete: in std_logic;
			sth1_port_entry_complete: in std_logic;
			sth1_port_entry_read: in std_logic;
			response_metadata_free: out std_logic;
			request_ready: out std_logic;
			request_len: out std_logic_vector(6 downto 0);
			request_addr: out std_logic_vector(60 downto 0);
			request_metadata: out std_logic_vector(27 downto 0);
			dma_complete_sfh: out std_logic_vector(31 downto 0);
			dma_complete_sth: out std_logic_vector(31 downto 0);
			dma_ctl_read_data: out std_logic_vector(63 downto 0);
			sfh0_port_entry_data: out std_logic_vector(60 downto 0);
			sfh0_port_entry_size: out std_logic_vector(8 downto 0);
			sfh0_port_entry_last: out std_logic;
			sfh0_port_entry_eos: out std_logic;
			sfh0_port_abort_dma: out std_logic;
			sfh0_port_empty: out std_logic;
			sfh_ring_reset0: out std_logic;
			sfh1_port_entry_data: out std_logic_vector(60 downto 0);
			sfh1_port_entry_size: out std_logic_vector(8 downto 0);
			sfh1_port_entry_last: out std_logic;
			sfh1_port_entry_eos: out std_logic;
			sfh1_port_abort_dma: out std_logic;
			sfh1_port_empty: out std_logic;
			sfh_ring_reset1: out std_logic;
			sfh2_port_entry_data: out std_logic_vector(60 downto 0);
			sfh2_port_entry_size: out std_logic_vector(8 downto 0);
			sfh2_port_entry_last: out std_logic;
			sfh2_port_entry_eos: out std_logic;
			sfh2_port_abort_dma: out std_logic;
			sfh2_port_empty: out std_logic;
			sfh_ring_reset2: out std_logic;
			sfh3_port_entry_data: out std_logic_vector(60 downto 0);
			sfh3_port_entry_size: out std_logic_vector(8 downto 0);
			sfh3_port_entry_last: out std_logic;
			sfh3_port_entry_eos: out std_logic;
			sfh3_port_abort_dma: out std_logic;
			sfh3_port_empty: out std_logic;
			sfh_ring_reset3: out std_logic;
			sfh4_port_entry_data: out std_logic_vector(60 downto 0);
			sfh4_port_entry_size: out std_logic_vector(8 downto 0);
			sfh4_port_entry_last: out std_logic;
			sfh4_port_entry_eos: out std_logic;
			sfh4_port_abort_dma: out std_logic;
			sfh4_port_empty: out std_logic;
			sfh_ring_reset4: out std_logic;
			sg_ring_write_sfh4_ready: out std_logic;
			sg_ring_write_sfh4_last: out std_logic;
			sg_ring_write_sfh4_len: out std_logic_vector(8 downto 0);
			sg_ring_write_sfh4_addr: out std_logic_vector(60 downto 0);
			sg_ring_write_sfh4_data: out std_logic_vector(127 downto 0);
			sg_ring_write_sfh4_data_valid: out std_logic;
			sth0_port_entry_data: out std_logic_vector(60 downto 0);
			sth0_port_entry_size: out std_logic_vector(8 downto 0);
			sth0_port_entry_last: out std_logic;
			sth0_port_entry_eos: out std_logic;
			sth0_port_abort_dma: out std_logic;
			sth0_port_empty: out std_logic;
			sth_ring_reset0: out std_logic;
			sth1_port_entry_data: out std_logic_vector(60 downto 0);
			sth1_port_entry_size: out std_logic_vector(8 downto 0);
			sth1_port_entry_last: out std_logic;
			sth1_port_entry_eos: out std_logic;
			sth1_port_abort_dma: out std_logic;
			sth1_port_empty: out std_logic;
			sth_ring_reset1: out std_logic
		);
	end component;
	component PCIeStreamToHost is
		port (
			streamrst_pcie: in std_logic;
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			scatter_list_entry_data: in std_logic_vector(60 downto 0);
			scatter_list_entry_size: in std_logic_vector(8 downto 0);
			scatter_list_entry_last: in std_logic;
			scatter_list_entry_eos: in std_logic;
			scatter_list_abort_dma: in std_logic;
			scatter_list_empty: in std_logic;
			in_stream_valid: in std_logic;
			in_stream_done: in std_logic;
			in_stream_data: in std_logic_vector(127 downto 0);
			request_select: in std_logic;
			request_data_read: in std_logic;
			scatter_list_dma_complete: out std_logic;
			scatter_list_entry_complete: out std_logic;
			scatter_list_entry_read: out std_logic;
			in_stream_stall: out std_logic;
			request_ready: out std_logic;
			request_last: out std_logic;
			request_len: out std_logic_vector(8 downto 0);
			request_addr: out std_logic_vector(60 downto 0);
			request_data: out std_logic_vector(127 downto 0);
			request_data_valid: out std_logic
		);
	end component;
	component PCIeStreamFromHostuid0 is
		port (
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			streamrst_pcie: in std_logic;
			gather_list_entry_data: in std_logic_vector(60 downto 0);
			gather_list_entry_size: in std_logic_vector(8 downto 0);
			gather_list_entry_last: in std_logic;
			gather_list_entry_eos: in std_logic;
			gather_list_abort_dma: in std_logic;
			gather_list_empty: in std_logic;
			out_stream_stall: in std_logic;
			response_valid: in std_logic_vector(1 downto 0);
			response_data: in std_logic_vector(127 downto 0);
			response_select: in std_logic;
			response_metadata: in std_logic_vector(27 downto 0);
			response_metadata_valid: in std_logic;
			request_select: in std_logic;
			gather_list_dma_complete: out std_logic;
			gather_list_entry_complete: out std_logic;
			gather_list_entry_read: out std_logic;
			out_stream_valid: out std_logic;
			out_stream_done: out std_logic;
			out_stream_data: out std_logic_vector(127 downto 0);
			response_metadata_free: out std_logic;
			request_ready: out std_logic;
			request_len: out std_logic_vector(6 downto 0);
			request_addr: out std_logic_vector(60 downto 0);
			request_metadata: out std_logic_vector(27 downto 0)
		);
	end component;
	component PCIeStreamFromHostuid1 is
		port (
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			streamrst_pcie: in std_logic;
			gather_list_entry_data: in std_logic_vector(60 downto 0);
			gather_list_entry_size: in std_logic_vector(8 downto 0);
			gather_list_entry_last: in std_logic;
			gather_list_entry_eos: in std_logic;
			gather_list_abort_dma: in std_logic;
			gather_list_empty: in std_logic;
			out_stream_stall: in std_logic;
			response_valid: in std_logic_vector(1 downto 0);
			response_data: in std_logic_vector(127 downto 0);
			response_select: in std_logic;
			response_metadata: in std_logic_vector(27 downto 0);
			response_metadata_valid: in std_logic;
			request_select: in std_logic;
			gather_list_dma_complete: out std_logic;
			gather_list_entry_complete: out std_logic;
			gather_list_entry_read: out std_logic;
			out_stream_valid: out std_logic;
			out_stream_done: out std_logic;
			out_stream_data: out std_logic_vector(127 downto 0);
			response_metadata_free: out std_logic;
			request_ready: out std_logic;
			request_len: out std_logic_vector(6 downto 0);
			request_addr: out std_logic_vector(60 downto 0);
			request_metadata: out std_logic_vector(27 downto 0)
		);
	end component;
	component PCIeStreamFromHostuid2 is
		port (
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			streamrst_pcie: in std_logic;
			gather_list_entry_data: in std_logic_vector(60 downto 0);
			gather_list_entry_size: in std_logic_vector(8 downto 0);
			gather_list_entry_last: in std_logic;
			gather_list_entry_eos: in std_logic;
			gather_list_abort_dma: in std_logic;
			gather_list_empty: in std_logic;
			out_stream_stall: in std_logic;
			response_valid: in std_logic_vector(1 downto 0);
			response_data: in std_logic_vector(127 downto 0);
			response_select: in std_logic;
			response_metadata: in std_logic_vector(27 downto 0);
			response_metadata_valid: in std_logic;
			request_select: in std_logic;
			gather_list_dma_complete: out std_logic;
			gather_list_entry_complete: out std_logic;
			gather_list_entry_read: out std_logic;
			out_stream_valid: out std_logic;
			out_stream_done: out std_logic;
			out_stream_data: out std_logic_vector(127 downto 0);
			response_metadata_free: out std_logic;
			request_ready: out std_logic;
			request_len: out std_logic_vector(6 downto 0);
			request_addr: out std_logic_vector(60 downto 0);
			request_metadata: out std_logic_vector(27 downto 0)
		);
	end component;
	component PCIeStreamFromHostuid3 is
		port (
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			streamrst_pcie: in std_logic;
			gather_list_entry_data: in std_logic_vector(60 downto 0);
			gather_list_entry_size: in std_logic_vector(8 downto 0);
			gather_list_entry_last: in std_logic;
			gather_list_entry_eos: in std_logic;
			gather_list_abort_dma: in std_logic;
			gather_list_empty: in std_logic;
			out_stream_stall: in std_logic;
			response_valid: in std_logic_vector(1 downto 0);
			response_data: in std_logic_vector(127 downto 0);
			response_select: in std_logic;
			response_metadata: in std_logic_vector(27 downto 0);
			response_metadata_valid: in std_logic;
			request_select: in std_logic;
			gather_list_dma_complete: out std_logic;
			gather_list_entry_complete: out std_logic;
			gather_list_entry_read: out std_logic;
			out_stream_valid: out std_logic;
			out_stream_done: out std_logic;
			out_stream_data: out std_logic_vector(127 downto 0);
			response_metadata_free: out std_logic;
			request_ready: out std_logic;
			request_len: out std_logic_vector(6 downto 0);
			request_addr: out std_logic_vector(60 downto 0);
			request_metadata: out std_logic_vector(27 downto 0)
		);
	end component;
	component PCIeStreamFromHostuid4 is
		port (
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			streamrst_pcie: in std_logic;
			gather_list_entry_data: in std_logic_vector(60 downto 0);
			gather_list_entry_size: in std_logic_vector(8 downto 0);
			gather_list_entry_last: in std_logic;
			gather_list_entry_eos: in std_logic;
			gather_list_abort_dma: in std_logic;
			gather_list_empty: in std_logic;
			out_stream_stall: in std_logic;
			response_valid: in std_logic_vector(1 downto 0);
			response_data: in std_logic_vector(127 downto 0);
			response_select: in std_logic;
			response_metadata: in std_logic_vector(27 downto 0);
			response_metadata_valid: in std_logic;
			request_select: in std_logic;
			gather_list_dma_complete: out std_logic;
			gather_list_entry_complete: out std_logic;
			gather_list_entry_read: out std_logic;
			out_stream_valid: out std_logic;
			out_stream_done: out std_logic;
			out_stream_data: out std_logic_vector(127 downto 0);
			response_metadata_free: out std_logic;
			request_ready: out std_logic;
			request_len: out std_logic_vector(6 downto 0);
			request_addr: out std_logic_vector(60 downto 0);
			request_metadata: out std_logic_vector(27 downto 0)
		);
	end component;
	
	-- Signal declarations
	
	signal inst_ln131_mappedregblock_register_out : std_logic_vector(7 downto 0);
	signal requestencoder_i_read_done : std_logic_vector(0 downto 0);
	signal requestencoder_i_dma_read_req : std_logic_vector(0 downto 0);
	signal requestencoder_i_dma_read_addr : std_logic_vector(63 downto 0);
	signal requestencoder_i_dma_read_len : std_logic_vector(9 downto 0);
	signal requestencoder_i_dma_read_be : std_logic_vector(3 downto 0);
	signal requestencoder_i_dma_read_tag : std_logic_vector(7 downto 0);
	signal requestencoder_i_dma_read_wide_addr : std_logic_vector(0 downto 0);
	signal requestencoder_i_write_done : std_logic_vector(0 downto 0);
	signal requestencoder_i_write_data_read : std_logic_vector(0 downto 0);
	signal requestencoder_i_tx_dma_write_req : std_logic_vector(0 downto 0);
	signal requestencoder_i_tx_dma_write_addr : std_logic_vector(63 downto 0);
	signal requestencoder_i_tx_dma_write_tag : std_logic_vector(7 downto 0);
	signal requestencoder_i_tx_dma_write_len : std_logic_vector(8 downto 0);
	signal requestencoder_i_tx_dma_write_wide_addr : std_logic_vector(0 downto 0);
	signal requestencoder_i_tx_dma_write_rddata : std_logic_vector(127 downto 0);
	signal requestencoder_i_interrupt_ctl_valid : std_logic_vector(0 downto 0);
	signal requestencoder_i_interrupt_ctl_enable_id : std_logic_vector(31 downto 0);
	signal requestencoder_i_tx_fifo_empty : std_logic_vector(0 downto 0);
	signal txstopbarparser_i_tx_stop : std_logic_vector(0 downto 0);
	signal responsedecoder_i_decoded_data : std_logic_vector(127 downto 0);
	signal responsedecoder_i_decoded_data_valid : std_logic_vector(1 downto 0);
	signal responsedecoder_i_decoded_tag : std_logic_vector(7 downto 0);
	signal responsedecoder_i_decoded_complete : std_logic_vector(0 downto 0);
	signal responsedecoder_i_decoded_ready : std_logic_vector(0 downto 0);
	signal tagmanager_i_in_write_req_done : std_logic_vector(0 downto 0);
	signal tagmanager_i_in_write_req_data_read : std_logic_vector(0 downto 0);
	signal tagmanager_i_out_write_req_ready : std_logic_vector(0 downto 0);
	signal tagmanager_i_out_write_req_last : std_logic_vector(0 downto 0);
	signal tagmanager_i_out_write_req_id : std_logic_vector(31 downto 0);
	signal tagmanager_i_out_write_req_len : std_logic_vector(8 downto 0);
	signal tagmanager_i_out_write_req_addr : std_logic_vector(60 downto 0);
	signal tagmanager_i_out_write_req_tag : std_logic_vector(7 downto 0);
	signal tagmanager_i_out_write_req_data : std_logic_vector(127 downto 0);
	signal tagmanager_i_out_write_req_data_valid : std_logic_vector(0 downto 0);
	signal tagmanager_i_in_read_req_done : std_logic_vector(0 downto 0);
	signal tagmanager_i_out_read_req_ready : std_logic_vector(0 downto 0);
	signal tagmanager_i_out_read_req_len : std_logic_vector(6 downto 0);
	signal tagmanager_i_out_read_req_addr : std_logic_vector(60 downto 0);
	signal tagmanager_i_out_read_req_tag : std_logic_vector(7 downto 0);
	signal tagmanager_i_out_read_response_data_valid : std_logic_vector(1 downto 0);
	signal tagmanager_i_out_read_response_data : std_logic_vector(127 downto 0);
	signal tagmanager_i_out_read_response_metadata : std_logic_vector(35 downto 0);
	signal tagmanager_i_out_read_response_metadata_valid : std_logic_vector(0 downto 0);
	signal memreadrequestarbiter_i_output_ready : std_logic_vector(0 downto 0);
	signal memreadrequestarbiter_i_output_len : std_logic_vector(6 downto 0);
	signal memreadrequestarbiter_i_output_addr : std_logic_vector(60 downto 0);
	signal memreadrequestarbiter_i_output_metadata : std_logic_vector(35 downto 0);
	signal memreadrequestarbiter_i_port0_select : std_logic_vector(0 downto 0);
	signal memreadrequestarbiter_i_port1_select : std_logic_vector(0 downto 0);
	signal memreadrequestarbiter_i_port2_select : std_logic_vector(0 downto 0);
	signal memreadrequestarbiter_i_port3_select : std_logic_vector(0 downto 0);
	signal memreadrequestarbiter_i_port4_select : std_logic_vector(0 downto 0);
	signal memreadrequestarbiter_i_port5_select : std_logic_vector(0 downto 0);
	signal memwriterequestarbiter_i_output_ready : std_logic_vector(0 downto 0);
	signal memwriterequestarbiter_i_output_last : std_logic_vector(0 downto 0);
	signal memwriterequestarbiter_i_output_id : std_logic_vector(31 downto 0);
	signal memwriterequestarbiter_i_output_len : std_logic_vector(8 downto 0);
	signal memwriterequestarbiter_i_output_addr : std_logic_vector(60 downto 0);
	signal memwriterequestarbiter_i_output_data : std_logic_vector(127 downto 0);
	signal memwriterequestarbiter_i_output_data_valid : std_logic_vector(0 downto 0);
	signal memwriterequestarbiter_i_port0_select : std_logic_vector(0 downto 0);
	signal memwriterequestarbiter_i_port0_data_read : std_logic_vector(0 downto 0);
	signal memwriterequestarbiter_i_port1_select : std_logic_vector(0 downto 0);
	signal memwriterequestarbiter_i_port1_data_read : std_logic_vector(0 downto 0);
	signal memwriterequestarbiter_i_port2_select : std_logic_vector(0 downto 0);
	signal memwriterequestarbiter_i_port2_data_read : std_logic_vector(0 downto 0);
	signal memreadresponsedispatcher_i_decoder_metadata_free : std_logic_vector(0 downto 0);
	signal memreadresponsedispatcher_i_receiver0_valid : std_logic_vector(1 downto 0);
	signal memreadresponsedispatcher_i_receiver0_data : std_logic_vector(127 downto 0);
	signal memreadresponsedispatcher_i_receiver0_select : std_logic_vector(0 downto 0);
	signal memreadresponsedispatcher_i_receiver0_metadata : std_logic_vector(27 downto 0);
	signal memreadresponsedispatcher_i_receiver0_metadata_valid : std_logic_vector(0 downto 0);
	signal memreadresponsedispatcher_i_receiver1_valid : std_logic_vector(1 downto 0);
	signal memreadresponsedispatcher_i_receiver1_data : std_logic_vector(127 downto 0);
	signal memreadresponsedispatcher_i_receiver1_select : std_logic_vector(0 downto 0);
	signal memreadresponsedispatcher_i_receiver1_metadata : std_logic_vector(27 downto 0);
	signal memreadresponsedispatcher_i_receiver1_metadata_valid : std_logic_vector(0 downto 0);
	signal memreadresponsedispatcher_i_receiver2_valid : std_logic_vector(1 downto 0);
	signal memreadresponsedispatcher_i_receiver2_data : std_logic_vector(127 downto 0);
	signal memreadresponsedispatcher_i_receiver2_select : std_logic_vector(0 downto 0);
	signal memreadresponsedispatcher_i_receiver2_metadata : std_logic_vector(27 downto 0);
	signal memreadresponsedispatcher_i_receiver2_metadata_valid : std_logic_vector(0 downto 0);
	signal memreadresponsedispatcher_i_receiver3_valid : std_logic_vector(1 downto 0);
	signal memreadresponsedispatcher_i_receiver3_data : std_logic_vector(127 downto 0);
	signal memreadresponsedispatcher_i_receiver3_select : std_logic_vector(0 downto 0);
	signal memreadresponsedispatcher_i_receiver3_metadata : std_logic_vector(27 downto 0);
	signal memreadresponsedispatcher_i_receiver3_metadata_valid : std_logic_vector(0 downto 0);
	signal memreadresponsedispatcher_i_receiver4_valid : std_logic_vector(1 downto 0);
	signal memreadresponsedispatcher_i_receiver4_data : std_logic_vector(127 downto 0);
	signal memreadresponsedispatcher_i_receiver4_select : std_logic_vector(0 downto 0);
	signal memreadresponsedispatcher_i_receiver4_metadata : std_logic_vector(27 downto 0);
	signal memreadresponsedispatcher_i_receiver4_metadata_valid : std_logic_vector(0 downto 0);
	signal memreadresponsedispatcher_i_receiver5_valid : std_logic_vector(1 downto 0);
	signal memreadresponsedispatcher_i_receiver5_data : std_logic_vector(127 downto 0);
	signal memreadresponsedispatcher_i_receiver5_select : std_logic_vector(0 downto 0);
	signal memreadresponsedispatcher_i_receiver5_metadata : std_logic_vector(27 downto 0);
	signal memreadresponsedispatcher_i_receiver5_metadata_valid : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_response_metadata_free : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_request_ready : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_request_len : std_logic_vector(6 downto 0);
	signal sglistfetchengine_i_request_addr : std_logic_vector(60 downto 0);
	signal sglistfetchengine_i_request_metadata : std_logic_vector(27 downto 0);
	signal sglistfetchengine_i_dma_complete_sfh : std_logic_vector(31 downto 0);
	signal sglistfetchengine_i_dma_complete_sth : std_logic_vector(31 downto 0);
	signal sglistfetchengine_i_dma_ctl_read_data : std_logic_vector(63 downto 0);
	signal sglistfetchengine_i_sfh0_port_entry_data : std_logic_vector(60 downto 0);
	signal sglistfetchengine_i_sfh0_port_entry_size : std_logic_vector(8 downto 0);
	signal sglistfetchengine_i_sfh0_port_entry_last : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh0_port_entry_eos : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh0_port_abort_dma : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh0_port_empty : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh_ring_reset0 : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh1_port_entry_data : std_logic_vector(60 downto 0);
	signal sglistfetchengine_i_sfh1_port_entry_size : std_logic_vector(8 downto 0);
	signal sglistfetchengine_i_sfh1_port_entry_last : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh1_port_entry_eos : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh1_port_abort_dma : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh1_port_empty : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh_ring_reset1 : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh2_port_entry_data : std_logic_vector(60 downto 0);
	signal sglistfetchengine_i_sfh2_port_entry_size : std_logic_vector(8 downto 0);
	signal sglistfetchengine_i_sfh2_port_entry_last : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh2_port_entry_eos : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh2_port_abort_dma : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh2_port_empty : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh_ring_reset2 : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh3_port_entry_data : std_logic_vector(60 downto 0);
	signal sglistfetchengine_i_sfh3_port_entry_size : std_logic_vector(8 downto 0);
	signal sglistfetchengine_i_sfh3_port_entry_last : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh3_port_entry_eos : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh3_port_abort_dma : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh3_port_empty : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh_ring_reset3 : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh4_port_entry_data : std_logic_vector(60 downto 0);
	signal sglistfetchengine_i_sfh4_port_entry_size : std_logic_vector(8 downto 0);
	signal sglistfetchengine_i_sfh4_port_entry_last : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh4_port_entry_eos : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh4_port_abort_dma : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh4_port_empty : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sfh_ring_reset4 : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sg_ring_write_sfh4_ready : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sg_ring_write_sfh4_last : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sg_ring_write_sfh4_len : std_logic_vector(8 downto 0);
	signal sglistfetchengine_i_sg_ring_write_sfh4_addr : std_logic_vector(60 downto 0);
	signal sglistfetchengine_i_sg_ring_write_sfh4_data : std_logic_vector(127 downto 0);
	signal sglistfetchengine_i_sg_ring_write_sfh4_data_valid : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sth0_port_entry_data : std_logic_vector(60 downto 0);
	signal sglistfetchengine_i_sth0_port_entry_size : std_logic_vector(8 downto 0);
	signal sglistfetchengine_i_sth0_port_entry_last : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sth0_port_entry_eos : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sth0_port_abort_dma : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sth0_port_empty : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sth_ring_reset0 : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sth1_port_entry_data : std_logic_vector(60 downto 0);
	signal sglistfetchengine_i_sth1_port_entry_size : std_logic_vector(8 downto 0);
	signal sglistfetchengine_i_sth1_port_entry_last : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sth1_port_entry_eos : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sth1_port_abort_dma : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sth1_port_empty : std_logic_vector(0 downto 0);
	signal sglistfetchengine_i_sth_ring_reset1 : std_logic_vector(0 downto 0);
	signal pciestreamtohost0_scatter_list_dma_complete : std_logic_vector(0 downto 0);
	signal pciestreamtohost0_scatter_list_entry_complete : std_logic_vector(0 downto 0);
	signal pciestreamtohost0_scatter_list_entry_read : std_logic_vector(0 downto 0);
	signal pciestreamtohost0_in_stream_stall : std_logic_vector(0 downto 0);
	signal pciestreamtohost0_request_ready : std_logic_vector(0 downto 0);
	signal pciestreamtohost0_request_last : std_logic_vector(0 downto 0);
	signal pciestreamtohost0_request_len : std_logic_vector(8 downto 0);
	signal pciestreamtohost0_request_addr : std_logic_vector(60 downto 0);
	signal pciestreamtohost0_request_data : std_logic_vector(127 downto 0);
	signal pciestreamtohost0_request_data_valid : std_logic_vector(0 downto 0);
	signal pciestreamfromhost0_gather_list_dma_complete : std_logic_vector(0 downto 0);
	signal pciestreamfromhost0_gather_list_entry_complete : std_logic_vector(0 downto 0);
	signal pciestreamfromhost0_gather_list_entry_read : std_logic_vector(0 downto 0);
	signal pciestreamfromhost0_out_stream_valid : std_logic_vector(0 downto 0);
	signal pciestreamfromhost0_out_stream_done : std_logic_vector(0 downto 0);
	signal pciestreamfromhost0_out_stream_data : std_logic_vector(127 downto 0);
	signal pciestreamfromhost0_response_metadata_free : std_logic_vector(0 downto 0);
	signal pciestreamfromhost0_request_ready : std_logic_vector(0 downto 0);
	signal pciestreamfromhost0_request_len : std_logic_vector(6 downto 0);
	signal pciestreamfromhost0_request_addr : std_logic_vector(60 downto 0);
	signal pciestreamfromhost0_request_metadata : std_logic_vector(27 downto 0);
	signal pciestreamfromhost1_gather_list_dma_complete : std_logic_vector(0 downto 0);
	signal pciestreamfromhost1_gather_list_entry_complete : std_logic_vector(0 downto 0);
	signal pciestreamfromhost1_gather_list_entry_read : std_logic_vector(0 downto 0);
	signal pciestreamfromhost1_out_stream_valid : std_logic_vector(0 downto 0);
	signal pciestreamfromhost1_out_stream_done : std_logic_vector(0 downto 0);
	signal pciestreamfromhost1_out_stream_data : std_logic_vector(127 downto 0);
	signal pciestreamfromhost1_response_metadata_free : std_logic_vector(0 downto 0);
	signal pciestreamfromhost1_request_ready : std_logic_vector(0 downto 0);
	signal pciestreamfromhost1_request_len : std_logic_vector(6 downto 0);
	signal pciestreamfromhost1_request_addr : std_logic_vector(60 downto 0);
	signal pciestreamfromhost1_request_metadata : std_logic_vector(27 downto 0);
	signal pciestreamfromhost2_gather_list_dma_complete : std_logic_vector(0 downto 0);
	signal pciestreamfromhost2_gather_list_entry_complete : std_logic_vector(0 downto 0);
	signal pciestreamfromhost2_gather_list_entry_read : std_logic_vector(0 downto 0);
	signal pciestreamfromhost2_out_stream_valid : std_logic_vector(0 downto 0);
	signal pciestreamfromhost2_out_stream_done : std_logic_vector(0 downto 0);
	signal pciestreamfromhost2_out_stream_data : std_logic_vector(127 downto 0);
	signal pciestreamfromhost2_response_metadata_free : std_logic_vector(0 downto 0);
	signal pciestreamfromhost2_request_ready : std_logic_vector(0 downto 0);
	signal pciestreamfromhost2_request_len : std_logic_vector(6 downto 0);
	signal pciestreamfromhost2_request_addr : std_logic_vector(60 downto 0);
	signal pciestreamfromhost2_request_metadata : std_logic_vector(27 downto 0);
	signal pciestreamfromhost3_gather_list_dma_complete : std_logic_vector(0 downto 0);
	signal pciestreamfromhost3_gather_list_entry_complete : std_logic_vector(0 downto 0);
	signal pciestreamfromhost3_gather_list_entry_read : std_logic_vector(0 downto 0);
	signal pciestreamfromhost3_out_stream_valid : std_logic_vector(0 downto 0);
	signal pciestreamfromhost3_out_stream_done : std_logic_vector(0 downto 0);
	signal pciestreamfromhost3_out_stream_data : std_logic_vector(127 downto 0);
	signal pciestreamfromhost3_response_metadata_free : std_logic_vector(0 downto 0);
	signal pciestreamfromhost3_request_ready : std_logic_vector(0 downto 0);
	signal pciestreamfromhost3_request_len : std_logic_vector(6 downto 0);
	signal pciestreamfromhost3_request_addr : std_logic_vector(60 downto 0);
	signal pciestreamfromhost3_request_metadata : std_logic_vector(27 downto 0);
	signal pciestreamfromhost4_gather_list_dma_complete : std_logic_vector(0 downto 0);
	signal pciestreamfromhost4_gather_list_entry_complete : std_logic_vector(0 downto 0);
	signal pciestreamfromhost4_gather_list_entry_read : std_logic_vector(0 downto 0);
	signal pciestreamfromhost4_out_stream_valid : std_logic_vector(0 downto 0);
	signal pciestreamfromhost4_out_stream_done : std_logic_vector(0 downto 0);
	signal pciestreamfromhost4_out_stream_data : std_logic_vector(127 downto 0);
	signal pciestreamfromhost4_response_metadata_free : std_logic_vector(0 downto 0);
	signal pciestreamfromhost4_request_ready : std_logic_vector(0 downto 0);
	signal pciestreamfromhost4_request_len : std_logic_vector(6 downto 0);
	signal pciestreamfromhost4_request_addr : std_logic_vector(60 downto 0);
	signal pciestreamfromhost4_request_metadata : std_logic_vector(27 downto 0);
	signal pciestreamtohost1_scatter_list_dma_complete : std_logic_vector(0 downto 0);
	signal pciestreamtohost1_scatter_list_entry_complete : std_logic_vector(0 downto 0);
	signal pciestreamtohost1_scatter_list_entry_read : std_logic_vector(0 downto 0);
	signal pciestreamtohost1_in_stream_stall : std_logic_vector(0 downto 0);
	signal pciestreamtohost1_request_ready : std_logic_vector(0 downto 0);
	signal pciestreamtohost1_request_last : std_logic_vector(0 downto 0);
	signal pciestreamtohost1_request_len : std_logic_vector(8 downto 0);
	signal pciestreamtohost1_request_addr : std_logic_vector(60 downto 0);
	signal pciestreamtohost1_request_data : std_logic_vector(127 downto 0);
	signal pciestreamtohost1_request_data_valid : std_logic_vector(0 downto 0);
	signal sfh0_stall_r : std_logic_vector(0 downto 0) := "0";
	signal sfh1_stall_r : std_logic_vector(0 downto 0) := "0";
	signal sfh2_stall_r : std_logic_vector(0 downto 0) := "0";
	signal sfh3_stall_r : std_logic_vector(0 downto 0) := "0";
	signal sfh4_stall_r : std_logic_vector(0 downto 0) := "0";
	signal sfh0_valid_r : std_logic_vector(0 downto 0) := "0";
	signal sfh0_data_r : std_logic_vector(127 downto 0) := "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
	signal sfh1_valid_r : std_logic_vector(0 downto 0) := "0";
	signal sfh1_data_r : std_logic_vector(127 downto 0) := "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
	signal sfh2_valid_r : std_logic_vector(0 downto 0) := "0";
	signal sfh2_data_r : std_logic_vector(127 downto 0) := "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
	signal sfh3_valid_r : std_logic_vector(0 downto 0) := "0";
	signal sfh3_data_r : std_logic_vector(127 downto 0) := "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
	signal sfh4_valid_r : std_logic_vector(0 downto 0) := "0";
	signal sfh4_data_r : std_logic_vector(127 downto 0) := "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	dma_complete_sfh <= sglistfetchengine_i_dma_complete_sfh;
	dma_complete_sth <= sglistfetchengine_i_dma_complete_sth;
	dma_ctl_read_data <= sglistfetchengine_i_dma_ctl_read_data;
	valid <= vec_to_bit(requestencoder_i_interrupt_ctl_valid);
	enable_id <= requestencoder_i_interrupt_ctl_enable_id;
	PCIeTXDMAReadRequestsIOGroupDef_dma_read_req <= vec_to_bit(requestencoder_i_dma_read_req);
	PCIeTXDMAReadRequestsIOGroupDef_dma_read_addr <= requestencoder_i_dma_read_addr;
	PCIeTXDMAReadRequestsIOGroupDef_dma_read_len <= requestencoder_i_dma_read_len;
	PCIeTXDMAReadRequestsIOGroupDef_dma_read_be <= requestencoder_i_dma_read_be;
	PCIeTXDMAReadRequestsIOGroupDef_dma_read_tag <= requestencoder_i_dma_read_tag;
	PCIeTXDMAReadRequestsIOGroupDef_dma_read_wide_addr <= vec_to_bit(requestencoder_i_dma_read_wide_addr);
	PCIeTXDMAWriteRequestsIOGroupDef_req <= vec_to_bit(requestencoder_i_tx_dma_write_req);
	PCIeTXDMAWriteRequestsIOGroupDef_addr <= requestencoder_i_tx_dma_write_addr;
	PCIeTXDMAWriteRequestsIOGroupDef_tag <= requestencoder_i_tx_dma_write_tag;
	PCIeTXDMAWriteRequestsIOGroupDef_len <= requestencoder_i_tx_dma_write_len;
	PCIeTXDMAWriteRequestsIOGroupDef_wide_addr <= vec_to_bit(requestencoder_i_tx_dma_write_wide_addr);
	PCIeTXDMAWriteRequestsIOGroupDef_rddata <= requestencoder_i_tx_dma_write_rddata;
	PCIeBarReadableStatusRegisters_tx_fifo_empty <= vec_to_bit(requestencoder_i_tx_fifo_empty);
	register_out <= inst_ln131_mappedregblock_register_out;
	sth0_stall <= vec_to_bit(pciestreamtohost0_in_stream_stall);
	sth_cap_0 <= "00000001";
	sth_cap_ctrl_0 <= "00000001";
	sfh0_valid <= vec_to_bit(sfh0_valid_r);
	sfh0_done <= vec_to_bit(pciestreamfromhost0_out_stream_done);
	sfh0_data <= sfh0_data_r;
	SFHCredits0_index <= "0";
	SFHCredits0_update <= vec_to_bit("0");
	SFHCredits0_wrap <= vec_to_bit("0");
	sfh_cap_0 <= "00000001";
	sfh1_valid <= vec_to_bit(sfh1_valid_r);
	sfh1_done <= vec_to_bit(pciestreamfromhost1_out_stream_done);
	sfh1_data <= sfh1_data_r;
	SFHCredits1_index <= "0";
	SFHCredits1_update <= vec_to_bit("0");
	SFHCredits1_wrap <= vec_to_bit("0");
	sfh_cap_1 <= "00000001";
	sfh2_valid <= vec_to_bit(sfh2_valid_r);
	sfh2_done <= vec_to_bit(pciestreamfromhost2_out_stream_done);
	sfh2_data <= sfh2_data_r;
	SFHCredits2_index <= "0";
	SFHCredits2_update <= vec_to_bit("0");
	SFHCredits2_wrap <= vec_to_bit("0");
	sfh_cap_2 <= "00000001";
	sfh3_valid <= vec_to_bit(sfh3_valid_r);
	sfh3_done <= vec_to_bit(pciestreamfromhost3_out_stream_done);
	sfh3_data <= sfh3_data_r;
	SFHCredits3_index <= "0";
	SFHCredits3_update <= vec_to_bit("0");
	SFHCredits3_wrap <= vec_to_bit("0");
	sfh_cap_3 <= "00000001";
	sfh_cap_ctrl_0 <= "00000011";
	sfh4_valid <= vec_to_bit(sfh4_valid_r);
	sfh4_done <= vec_to_bit(pciestreamfromhost4_out_stream_done);
	sfh4_data <= sfh4_data_r;
	SFHCredits4_index <= "0";
	SFHCredits4_update <= vec_to_bit("0");
	SFHCredits4_wrap <= vec_to_bit("0");
	sth1_stall <= vec_to_bit(pciestreamtohost1_in_stream_stall);
	
	-- Register processes
	
	reg_process : process(PCIeClockingIOGroupDef_clk_pcie)
	begin
		if rising_edge(PCIeClockingIOGroupDef_clk_pcie) then
			sfh0_stall_r <= bit_to_vec(sfh0_stall);
			sfh1_stall_r <= bit_to_vec(sfh1_stall);
			sfh2_stall_r <= bit_to_vec(sfh2_stall);
			sfh3_stall_r <= bit_to_vec(sfh3_stall);
			sfh4_stall_r <= bit_to_vec(sfh4_stall);
			sfh0_valid_r <= pciestreamfromhost0_out_stream_valid;
			sfh0_data_r <= pciestreamfromhost0_out_stream_data;
			sfh1_valid_r <= pciestreamfromhost1_out_stream_valid;
			sfh1_data_r <= pciestreamfromhost1_out_stream_data;
			sfh2_valid_r <= pciestreamfromhost2_out_stream_valid;
			sfh2_data_r <= pciestreamfromhost2_out_stream_data;
			sfh3_valid_r <= pciestreamfromhost3_out_stream_valid;
			sfh3_data_r <= pciestreamfromhost3_out_stream_data;
			sfh4_valid_r <= pciestreamfromhost4_out_stream_valid;
			sfh4_data_r <= pciestreamfromhost4_out_stream_data;
		end if;
	end process;
	
	-- Entity instances
	
	inst_ln131_mappedregblock : MappedRegBlock_68934a3e9455fa72420237eb05902327
		port map (
			register_out => inst_ln131_mappedregblock_register_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => register_in, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch -- 1 bits (in)
		);
	RequestEncoder_i : RequestEncoder
		port map (
			read_done => requestencoder_i_read_done(0), -- 1 bits (out)
			dma_read_req => requestencoder_i_dma_read_req(0), -- 1 bits (out)
			dma_read_addr => requestencoder_i_dma_read_addr, -- 64 bits (out)
			dma_read_len => requestencoder_i_dma_read_len, -- 10 bits (out)
			dma_read_be => requestencoder_i_dma_read_be, -- 4 bits (out)
			dma_read_tag => requestencoder_i_dma_read_tag, -- 8 bits (out)
			dma_read_wide_addr => requestencoder_i_dma_read_wide_addr(0), -- 1 bits (out)
			write_done => requestencoder_i_write_done(0), -- 1 bits (out)
			write_data_read => requestencoder_i_write_data_read(0), -- 1 bits (out)
			tx_dma_write_req => requestencoder_i_tx_dma_write_req(0), -- 1 bits (out)
			tx_dma_write_addr => requestencoder_i_tx_dma_write_addr, -- 64 bits (out)
			tx_dma_write_tag => requestencoder_i_tx_dma_write_tag, -- 8 bits (out)
			tx_dma_write_len => requestencoder_i_tx_dma_write_len, -- 9 bits (out)
			tx_dma_write_wide_addr => requestencoder_i_tx_dma_write_wide_addr(0), -- 1 bits (out)
			tx_dma_write_rddata => requestencoder_i_tx_dma_write_rddata, -- 128 bits (out)
			interrupt_ctl_valid => requestencoder_i_interrupt_ctl_valid(0), -- 1 bits (out)
			interrupt_ctl_enable_id => requestencoder_i_interrupt_ctl_enable_id, -- 32 bits (out)
			tx_fifo_empty => requestencoder_i_tx_fifo_empty(0), -- 1 bits (out)
			clk_pcie => PCIeClockingIOGroupDef_clk_pcie, -- 1 bits (in)
			rst_pcie_n => PCIeClockingIOGroupDef_rst_pcie_n, -- 1 bits (in)
			streamrst_pcie => rst, -- 1 bits (in)
			read_ready => vec_to_bit(tagmanager_i_out_read_req_ready), -- 1 bits (in)
			read_len => tagmanager_i_out_read_req_len, -- 7 bits (in)
			read_addr => tagmanager_i_out_read_req_addr, -- 61 bits (in)
			read_tag => tagmanager_i_out_read_req_tag, -- 8 bits (in)
			dma_read_ack => PCIeTXDMAReadRequestsIOGroupDef_dma_read_ack, -- 1 bits (in)
			write_ready => vec_to_bit(tagmanager_i_out_write_req_ready), -- 1 bits (in)
			write_last => vec_to_bit(tagmanager_i_out_write_req_last), -- 1 bits (in)
			write_id => tagmanager_i_out_write_req_id, -- 32 bits (in)
			write_len => tagmanager_i_out_write_req_len, -- 9 bits (in)
			write_addr => tagmanager_i_out_write_req_addr, -- 61 bits (in)
			write_tag => tagmanager_i_out_write_req_tag, -- 8 bits (in)
			write_data => tagmanager_i_out_write_req_data, -- 128 bits (in)
			write_data_valid => vec_to_bit(tagmanager_i_out_write_req_data_valid), -- 1 bits (in)
			tx_dma_write_ack => PCIeTXDMAWriteRequestsIOGroupDef_ack, -- 1 bits (in)
			tx_dma_write_done => PCIeTXDMAWriteRequestsIOGroupDef_done, -- 1 bits (in)
			tx_dma_write_busy => PCIeTXDMAWriteRequestsIOGroupDef_busy, -- 1 bits (in)
			tx_dma_write_rden => PCIeTXDMAWriteRequestsIOGroupDef_rden, -- 1 bits (in)
			tx_stop => vec_to_bit(txstopbarparser_i_tx_stop) -- 1 bits (in)
		);
	TXStopBarParser_i : TXStopBarParser
		port map (
			tx_stop => txstopbarparser_i_tx_stop(0), -- 1 bits (out)
			bar_parse_wr_addr_onehot => BarSpaceExternalParserIOGroupDef_wr_addr_onehot, -- 256 bits (in)
			bar_parse_wr_data => BarSpaceExternalParserIOGroupDef_wr_data, -- 64 bits (in)
			bar_parse_wr_clk => BarSpaceExternalParserIOGroupDef_wr_clk, -- 1 bits (in)
			bar_parse_wr_page_sel_onehot => BarSpaceExternalParserIOGroupDef_wr_page_sel_onehot, -- 2 bits (in)
			rst_sync => rst -- 1 bits (in)
		);
	ResponseDecoder_i : ResponseDecoder
		port map (
			decoded_data => responsedecoder_i_decoded_data, -- 128 bits (out)
			decoded_data_valid => responsedecoder_i_decoded_data_valid, -- 2 bits (out)
			decoded_tag => responsedecoder_i_decoded_tag, -- 8 bits (out)
			decoded_complete => responsedecoder_i_decoded_complete(0), -- 1 bits (out)
			decoded_ready => responsedecoder_i_decoded_ready(0), -- 1 bits (out)
			clk_pcie => PCIeClockingIOGroupDef_clk_pcie, -- 1 bits (in)
			rst_pcie_n => PCIeClockingIOGroupDef_rst_pcie_n, -- 1 bits (in)
			dma_response_data => PCIeRXDMAReadResponseIOGroupDef_dma_response_data, -- 128 bits (in)
			dma_response_valid => PCIeRXDMAReadResponseIOGroupDef_dma_response_valid, -- 2 bits (in)
			dma_response_len => PCIeRXDMAReadResponseIOGroupDef_dma_response_len, -- 10 bits (in)
			dma_response_tag => PCIeRXDMAReadResponseIOGroupDef_dma_response_tag, -- 8 bits (in)
			dma_response_complete => PCIeRXDMAReadResponseIOGroupDef_dma_response_complete, -- 1 bits (in)
			dma_response_ready => PCIeRXDMAReadResponseIOGroupDef_dma_response_ready -- 1 bits (in)
		);
	TagManager_i : TagManager
		port map (
			in_write_req_done => tagmanager_i_in_write_req_done(0), -- 1 bits (out)
			in_write_req_data_read => tagmanager_i_in_write_req_data_read(0), -- 1 bits (out)
			out_write_req_ready => tagmanager_i_out_write_req_ready(0), -- 1 bits (out)
			out_write_req_last => tagmanager_i_out_write_req_last(0), -- 1 bits (out)
			out_write_req_id => tagmanager_i_out_write_req_id, -- 32 bits (out)
			out_write_req_len => tagmanager_i_out_write_req_len, -- 9 bits (out)
			out_write_req_addr => tagmanager_i_out_write_req_addr, -- 61 bits (out)
			out_write_req_tag => tagmanager_i_out_write_req_tag, -- 8 bits (out)
			out_write_req_data => tagmanager_i_out_write_req_data, -- 128 bits (out)
			out_write_req_data_valid => tagmanager_i_out_write_req_data_valid(0), -- 1 bits (out)
			in_read_req_done => tagmanager_i_in_read_req_done(0), -- 1 bits (out)
			out_read_req_ready => tagmanager_i_out_read_req_ready(0), -- 1 bits (out)
			out_read_req_len => tagmanager_i_out_read_req_len, -- 7 bits (out)
			out_read_req_addr => tagmanager_i_out_read_req_addr, -- 61 bits (out)
			out_read_req_tag => tagmanager_i_out_read_req_tag, -- 8 bits (out)
			out_read_response_data_valid => tagmanager_i_out_read_response_data_valid, -- 2 bits (out)
			out_read_response_data => tagmanager_i_out_read_response_data, -- 128 bits (out)
			out_read_response_metadata => tagmanager_i_out_read_response_metadata, -- 36 bits (out)
			out_read_response_metadata_valid => tagmanager_i_out_read_response_metadata_valid(0), -- 1 bits (out)
			streamrst_pcie => rst, -- 1 bits (in)
			clk_pcie => PCIeClockingIOGroupDef_clk_pcie, -- 1 bits (in)
			rst_pcie_n => PCIeClockingIOGroupDef_rst_pcie_n, -- 1 bits (in)
			in_write_req_ready => vec_to_bit(memwriterequestarbiter_i_output_ready), -- 1 bits (in)
			in_write_req_last => vec_to_bit(memwriterequestarbiter_i_output_last), -- 1 bits (in)
			in_write_req_id => memwriterequestarbiter_i_output_id, -- 32 bits (in)
			in_write_req_len => memwriterequestarbiter_i_output_len, -- 9 bits (in)
			in_write_req_addr => memwriterequestarbiter_i_output_addr, -- 61 bits (in)
			in_write_req_data => memwriterequestarbiter_i_output_data, -- 128 bits (in)
			in_write_req_data_valid => vec_to_bit(memwriterequestarbiter_i_output_data_valid), -- 1 bits (in)
			out_write_req_done => vec_to_bit(requestencoder_i_write_done), -- 1 bits (in)
			out_write_req_data_read => vec_to_bit(requestencoder_i_write_data_read), -- 1 bits (in)
			in_read_req_ready => vec_to_bit(memreadrequestarbiter_i_output_ready), -- 1 bits (in)
			in_read_req_len => memreadrequestarbiter_i_output_len, -- 7 bits (in)
			in_read_req_addr => memreadrequestarbiter_i_output_addr, -- 61 bits (in)
			in_read_req_metadata => memreadrequestarbiter_i_output_metadata, -- 36 bits (in)
			out_read_req_done => vec_to_bit(requestencoder_i_read_done), -- 1 bits (in)
			in_read_response_data => responsedecoder_i_decoded_data, -- 128 bits (in)
			in_read_response_data_valid => responsedecoder_i_decoded_data_valid, -- 2 bits (in)
			in_read_response_tag => responsedecoder_i_decoded_tag, -- 8 bits (in)
			in_read_response_complete => vec_to_bit(responsedecoder_i_decoded_complete), -- 1 bits (in)
			in_read_response_ready => vec_to_bit(responsedecoder_i_decoded_ready), -- 1 bits (in)
			out_read_response_metadata_free => vec_to_bit(memreadresponsedispatcher_i_decoder_metadata_free) -- 1 bits (in)
		);
	MemReadRequestArbiter_i : MemReadRequestArbiter
		port map (
			output_ready => memreadrequestarbiter_i_output_ready(0), -- 1 bits (out)
			output_len => memreadrequestarbiter_i_output_len, -- 7 bits (out)
			output_addr => memreadrequestarbiter_i_output_addr, -- 61 bits (out)
			output_metadata => memreadrequestarbiter_i_output_metadata, -- 36 bits (out)
			port0_select => memreadrequestarbiter_i_port0_select(0), -- 1 bits (out)
			port1_select => memreadrequestarbiter_i_port1_select(0), -- 1 bits (out)
			port2_select => memreadrequestarbiter_i_port2_select(0), -- 1 bits (out)
			port3_select => memreadrequestarbiter_i_port3_select(0), -- 1 bits (out)
			port4_select => memreadrequestarbiter_i_port4_select(0), -- 1 bits (out)
			port5_select => memreadrequestarbiter_i_port5_select(0), -- 1 bits (out)
			streamrst_pcie => rst, -- 1 bits (in)
			clk_pcie => PCIeClockingIOGroupDef_clk_pcie, -- 1 bits (in)
			rst_pcie_n => PCIeClockingIOGroupDef_rst_pcie_n, -- 1 bits (in)
			output_done => vec_to_bit(tagmanager_i_in_read_req_done), -- 1 bits (in)
			port0_ready => vec_to_bit(sglistfetchengine_i_request_ready), -- 1 bits (in)
			port0_len => sglistfetchengine_i_request_len, -- 7 bits (in)
			port0_addr => sglistfetchengine_i_request_addr, -- 61 bits (in)
			port0_metadata => sglistfetchengine_i_request_metadata, -- 28 bits (in)
			port1_ready => vec_to_bit(pciestreamfromhost0_request_ready), -- 1 bits (in)
			port1_len => pciestreamfromhost0_request_len, -- 7 bits (in)
			port1_addr => pciestreamfromhost0_request_addr, -- 61 bits (in)
			port1_metadata => pciestreamfromhost0_request_metadata, -- 28 bits (in)
			port2_ready => vec_to_bit(pciestreamfromhost1_request_ready), -- 1 bits (in)
			port2_len => pciestreamfromhost1_request_len, -- 7 bits (in)
			port2_addr => pciestreamfromhost1_request_addr, -- 61 bits (in)
			port2_metadata => pciestreamfromhost1_request_metadata, -- 28 bits (in)
			port3_ready => vec_to_bit(pciestreamfromhost2_request_ready), -- 1 bits (in)
			port3_len => pciestreamfromhost2_request_len, -- 7 bits (in)
			port3_addr => pciestreamfromhost2_request_addr, -- 61 bits (in)
			port3_metadata => pciestreamfromhost2_request_metadata, -- 28 bits (in)
			port4_ready => vec_to_bit(pciestreamfromhost3_request_ready), -- 1 bits (in)
			port4_len => pciestreamfromhost3_request_len, -- 7 bits (in)
			port4_addr => pciestreamfromhost3_request_addr, -- 61 bits (in)
			port4_metadata => pciestreamfromhost3_request_metadata, -- 28 bits (in)
			port5_ready => vec_to_bit(pciestreamfromhost4_request_ready), -- 1 bits (in)
			port5_len => pciestreamfromhost4_request_len, -- 7 bits (in)
			port5_addr => pciestreamfromhost4_request_addr, -- 61 bits (in)
			port5_metadata => pciestreamfromhost4_request_metadata -- 28 bits (in)
		);
	MemWriteRequestArbiter_i : MemWriteRequestArbiter
		port map (
			output_ready => memwriterequestarbiter_i_output_ready(0), -- 1 bits (out)
			output_last => memwriterequestarbiter_i_output_last(0), -- 1 bits (out)
			output_id => memwriterequestarbiter_i_output_id, -- 32 bits (out)
			output_len => memwriterequestarbiter_i_output_len, -- 9 bits (out)
			output_addr => memwriterequestarbiter_i_output_addr, -- 61 bits (out)
			output_data => memwriterequestarbiter_i_output_data, -- 128 bits (out)
			output_data_valid => memwriterequestarbiter_i_output_data_valid(0), -- 1 bits (out)
			port0_select => memwriterequestarbiter_i_port0_select(0), -- 1 bits (out)
			port0_data_read => memwriterequestarbiter_i_port0_data_read(0), -- 1 bits (out)
			port1_select => memwriterequestarbiter_i_port1_select(0), -- 1 bits (out)
			port1_data_read => memwriterequestarbiter_i_port1_data_read(0), -- 1 bits (out)
			port2_select => memwriterequestarbiter_i_port2_select(0), -- 1 bits (out)
			port2_data_read => memwriterequestarbiter_i_port2_data_read(0), -- 1 bits (out)
			streamrst_pcie => rst, -- 1 bits (in)
			clk_pcie => PCIeClockingIOGroupDef_clk_pcie, -- 1 bits (in)
			rst_pcie_n => PCIeClockingIOGroupDef_rst_pcie_n, -- 1 bits (in)
			output_done => vec_to_bit(tagmanager_i_in_write_req_done), -- 1 bits (in)
			output_data_read => vec_to_bit(tagmanager_i_in_write_req_data_read), -- 1 bits (in)
			port0_ready => vec_to_bit(sglistfetchengine_i_sg_ring_write_sfh4_ready), -- 1 bits (in)
			port0_last => vec_to_bit(sglistfetchengine_i_sg_ring_write_sfh4_last), -- 1 bits (in)
			port0_len => sglistfetchengine_i_sg_ring_write_sfh4_len, -- 9 bits (in)
			port0_addr => sglistfetchengine_i_sg_ring_write_sfh4_addr, -- 61 bits (in)
			port0_data => sglistfetchengine_i_sg_ring_write_sfh4_data, -- 128 bits (in)
			port0_data_valid => vec_to_bit(sglistfetchengine_i_sg_ring_write_sfh4_data_valid), -- 1 bits (in)
			port1_ready => vec_to_bit(pciestreamtohost0_request_ready), -- 1 bits (in)
			port1_last => vec_to_bit(pciestreamtohost0_request_last), -- 1 bits (in)
			port1_len => pciestreamtohost0_request_len, -- 9 bits (in)
			port1_addr => pciestreamtohost0_request_addr, -- 61 bits (in)
			port1_data => pciestreamtohost0_request_data, -- 128 bits (in)
			port1_data_valid => vec_to_bit(pciestreamtohost0_request_data_valid), -- 1 bits (in)
			port2_ready => vec_to_bit(pciestreamtohost1_request_ready), -- 1 bits (in)
			port2_last => vec_to_bit(pciestreamtohost1_request_last), -- 1 bits (in)
			port2_len => pciestreamtohost1_request_len, -- 9 bits (in)
			port2_addr => pciestreamtohost1_request_addr, -- 61 bits (in)
			port2_data => pciestreamtohost1_request_data, -- 128 bits (in)
			port2_data_valid => vec_to_bit(pciestreamtohost1_request_data_valid) -- 1 bits (in)
		);
	MemReadResponseDispatcher_i : MemReadResponseDispatcher
		port map (
			decoder_metadata_free => memreadresponsedispatcher_i_decoder_metadata_free(0), -- 1 bits (out)
			receiver0_valid => memreadresponsedispatcher_i_receiver0_valid, -- 2 bits (out)
			receiver0_data => memreadresponsedispatcher_i_receiver0_data, -- 128 bits (out)
			receiver0_select => memreadresponsedispatcher_i_receiver0_select(0), -- 1 bits (out)
			receiver0_metadata => memreadresponsedispatcher_i_receiver0_metadata, -- 28 bits (out)
			receiver0_metadata_valid => memreadresponsedispatcher_i_receiver0_metadata_valid(0), -- 1 bits (out)
			receiver1_valid => memreadresponsedispatcher_i_receiver1_valid, -- 2 bits (out)
			receiver1_data => memreadresponsedispatcher_i_receiver1_data, -- 128 bits (out)
			receiver1_select => memreadresponsedispatcher_i_receiver1_select(0), -- 1 bits (out)
			receiver1_metadata => memreadresponsedispatcher_i_receiver1_metadata, -- 28 bits (out)
			receiver1_metadata_valid => memreadresponsedispatcher_i_receiver1_metadata_valid(0), -- 1 bits (out)
			receiver2_valid => memreadresponsedispatcher_i_receiver2_valid, -- 2 bits (out)
			receiver2_data => memreadresponsedispatcher_i_receiver2_data, -- 128 bits (out)
			receiver2_select => memreadresponsedispatcher_i_receiver2_select(0), -- 1 bits (out)
			receiver2_metadata => memreadresponsedispatcher_i_receiver2_metadata, -- 28 bits (out)
			receiver2_metadata_valid => memreadresponsedispatcher_i_receiver2_metadata_valid(0), -- 1 bits (out)
			receiver3_valid => memreadresponsedispatcher_i_receiver3_valid, -- 2 bits (out)
			receiver3_data => memreadresponsedispatcher_i_receiver3_data, -- 128 bits (out)
			receiver3_select => memreadresponsedispatcher_i_receiver3_select(0), -- 1 bits (out)
			receiver3_metadata => memreadresponsedispatcher_i_receiver3_metadata, -- 28 bits (out)
			receiver3_metadata_valid => memreadresponsedispatcher_i_receiver3_metadata_valid(0), -- 1 bits (out)
			receiver4_valid => memreadresponsedispatcher_i_receiver4_valid, -- 2 bits (out)
			receiver4_data => memreadresponsedispatcher_i_receiver4_data, -- 128 bits (out)
			receiver4_select => memreadresponsedispatcher_i_receiver4_select(0), -- 1 bits (out)
			receiver4_metadata => memreadresponsedispatcher_i_receiver4_metadata, -- 28 bits (out)
			receiver4_metadata_valid => memreadresponsedispatcher_i_receiver4_metadata_valid(0), -- 1 bits (out)
			receiver5_valid => memreadresponsedispatcher_i_receiver5_valid, -- 2 bits (out)
			receiver5_data => memreadresponsedispatcher_i_receiver5_data, -- 128 bits (out)
			receiver5_select => memreadresponsedispatcher_i_receiver5_select(0), -- 1 bits (out)
			receiver5_metadata => memreadresponsedispatcher_i_receiver5_metadata, -- 28 bits (out)
			receiver5_metadata_valid => memreadresponsedispatcher_i_receiver5_metadata_valid(0), -- 1 bits (out)
			clk_pcie => PCIeClockingIOGroupDef_clk_pcie, -- 1 bits (in)
			rst_pcie_n => PCIeClockingIOGroupDef_rst_pcie_n, -- 1 bits (in)
			decoder_data_valid => tagmanager_i_out_read_response_data_valid, -- 2 bits (in)
			decoder_data => tagmanager_i_out_read_response_data, -- 128 bits (in)
			decoder_metadata => tagmanager_i_out_read_response_metadata, -- 36 bits (in)
			decoder_metadata_valid => vec_to_bit(tagmanager_i_out_read_response_metadata_valid), -- 1 bits (in)
			receiver0_metadata_free => vec_to_bit(sglistfetchengine_i_response_metadata_free), -- 1 bits (in)
			receiver1_metadata_free => vec_to_bit(pciestreamfromhost0_response_metadata_free), -- 1 bits (in)
			receiver2_metadata_free => vec_to_bit(pciestreamfromhost1_response_metadata_free), -- 1 bits (in)
			receiver3_metadata_free => vec_to_bit(pciestreamfromhost2_response_metadata_free), -- 1 bits (in)
			receiver4_metadata_free => vec_to_bit(pciestreamfromhost3_response_metadata_free), -- 1 bits (in)
			receiver5_metadata_free => vec_to_bit(pciestreamfromhost4_response_metadata_free) -- 1 bits (in)
		);
	SGListFetchEngine_i : SGListFetchEngine
		port map (
			response_metadata_free => sglistfetchengine_i_response_metadata_free(0), -- 1 bits (out)
			request_ready => sglistfetchengine_i_request_ready(0), -- 1 bits (out)
			request_len => sglistfetchengine_i_request_len, -- 7 bits (out)
			request_addr => sglistfetchengine_i_request_addr, -- 61 bits (out)
			request_metadata => sglistfetchengine_i_request_metadata, -- 28 bits (out)
			dma_complete_sfh => sglistfetchengine_i_dma_complete_sfh, -- 32 bits (out)
			dma_complete_sth => sglistfetchengine_i_dma_complete_sth, -- 32 bits (out)
			dma_ctl_read_data => sglistfetchengine_i_dma_ctl_read_data, -- 64 bits (out)
			sfh0_port_entry_data => sglistfetchengine_i_sfh0_port_entry_data, -- 61 bits (out)
			sfh0_port_entry_size => sglistfetchengine_i_sfh0_port_entry_size, -- 9 bits (out)
			sfh0_port_entry_last => sglistfetchengine_i_sfh0_port_entry_last(0), -- 1 bits (out)
			sfh0_port_entry_eos => sglistfetchengine_i_sfh0_port_entry_eos(0), -- 1 bits (out)
			sfh0_port_abort_dma => sglistfetchengine_i_sfh0_port_abort_dma(0), -- 1 bits (out)
			sfh0_port_empty => sglistfetchengine_i_sfh0_port_empty(0), -- 1 bits (out)
			sfh_ring_reset0 => sglistfetchengine_i_sfh_ring_reset0(0), -- 1 bits (out)
			sfh1_port_entry_data => sglistfetchengine_i_sfh1_port_entry_data, -- 61 bits (out)
			sfh1_port_entry_size => sglistfetchengine_i_sfh1_port_entry_size, -- 9 bits (out)
			sfh1_port_entry_last => sglistfetchengine_i_sfh1_port_entry_last(0), -- 1 bits (out)
			sfh1_port_entry_eos => sglistfetchengine_i_sfh1_port_entry_eos(0), -- 1 bits (out)
			sfh1_port_abort_dma => sglistfetchengine_i_sfh1_port_abort_dma(0), -- 1 bits (out)
			sfh1_port_empty => sglistfetchengine_i_sfh1_port_empty(0), -- 1 bits (out)
			sfh_ring_reset1 => sglistfetchengine_i_sfh_ring_reset1(0), -- 1 bits (out)
			sfh2_port_entry_data => sglistfetchengine_i_sfh2_port_entry_data, -- 61 bits (out)
			sfh2_port_entry_size => sglistfetchengine_i_sfh2_port_entry_size, -- 9 bits (out)
			sfh2_port_entry_last => sglistfetchengine_i_sfh2_port_entry_last(0), -- 1 bits (out)
			sfh2_port_entry_eos => sglistfetchengine_i_sfh2_port_entry_eos(0), -- 1 bits (out)
			sfh2_port_abort_dma => sglistfetchengine_i_sfh2_port_abort_dma(0), -- 1 bits (out)
			sfh2_port_empty => sglistfetchengine_i_sfh2_port_empty(0), -- 1 bits (out)
			sfh_ring_reset2 => sglistfetchengine_i_sfh_ring_reset2(0), -- 1 bits (out)
			sfh3_port_entry_data => sglistfetchengine_i_sfh3_port_entry_data, -- 61 bits (out)
			sfh3_port_entry_size => sglistfetchengine_i_sfh3_port_entry_size, -- 9 bits (out)
			sfh3_port_entry_last => sglistfetchengine_i_sfh3_port_entry_last(0), -- 1 bits (out)
			sfh3_port_entry_eos => sglistfetchengine_i_sfh3_port_entry_eos(0), -- 1 bits (out)
			sfh3_port_abort_dma => sglistfetchengine_i_sfh3_port_abort_dma(0), -- 1 bits (out)
			sfh3_port_empty => sglistfetchengine_i_sfh3_port_empty(0), -- 1 bits (out)
			sfh_ring_reset3 => sglistfetchengine_i_sfh_ring_reset3(0), -- 1 bits (out)
			sfh4_port_entry_data => sglistfetchengine_i_sfh4_port_entry_data, -- 61 bits (out)
			sfh4_port_entry_size => sglistfetchengine_i_sfh4_port_entry_size, -- 9 bits (out)
			sfh4_port_entry_last => sglistfetchengine_i_sfh4_port_entry_last(0), -- 1 bits (out)
			sfh4_port_entry_eos => sglistfetchengine_i_sfh4_port_entry_eos(0), -- 1 bits (out)
			sfh4_port_abort_dma => sglistfetchengine_i_sfh4_port_abort_dma(0), -- 1 bits (out)
			sfh4_port_empty => sglistfetchengine_i_sfh4_port_empty(0), -- 1 bits (out)
			sfh_ring_reset4 => sglistfetchengine_i_sfh_ring_reset4(0), -- 1 bits (out)
			sg_ring_write_sfh4_ready => sglistfetchengine_i_sg_ring_write_sfh4_ready(0), -- 1 bits (out)
			sg_ring_write_sfh4_last => sglistfetchengine_i_sg_ring_write_sfh4_last(0), -- 1 bits (out)
			sg_ring_write_sfh4_len => sglistfetchengine_i_sg_ring_write_sfh4_len, -- 9 bits (out)
			sg_ring_write_sfh4_addr => sglistfetchengine_i_sg_ring_write_sfh4_addr, -- 61 bits (out)
			sg_ring_write_sfh4_data => sglistfetchengine_i_sg_ring_write_sfh4_data, -- 128 bits (out)
			sg_ring_write_sfh4_data_valid => sglistfetchengine_i_sg_ring_write_sfh4_data_valid(0), -- 1 bits (out)
			sth0_port_entry_data => sglistfetchengine_i_sth0_port_entry_data, -- 61 bits (out)
			sth0_port_entry_size => sglistfetchengine_i_sth0_port_entry_size, -- 9 bits (out)
			sth0_port_entry_last => sglistfetchengine_i_sth0_port_entry_last(0), -- 1 bits (out)
			sth0_port_entry_eos => sglistfetchengine_i_sth0_port_entry_eos(0), -- 1 bits (out)
			sth0_port_abort_dma => sglistfetchengine_i_sth0_port_abort_dma(0), -- 1 bits (out)
			sth0_port_empty => sglistfetchengine_i_sth0_port_empty(0), -- 1 bits (out)
			sth_ring_reset0 => sglistfetchengine_i_sth_ring_reset0(0), -- 1 bits (out)
			sth1_port_entry_data => sglistfetchengine_i_sth1_port_entry_data, -- 61 bits (out)
			sth1_port_entry_size => sglistfetchengine_i_sth1_port_entry_size, -- 9 bits (out)
			sth1_port_entry_last => sglistfetchengine_i_sth1_port_entry_last(0), -- 1 bits (out)
			sth1_port_entry_eos => sglistfetchengine_i_sth1_port_entry_eos(0), -- 1 bits (out)
			sth1_port_abort_dma => sglistfetchengine_i_sth1_port_abort_dma(0), -- 1 bits (out)
			sth1_port_empty => sglistfetchengine_i_sth1_port_empty(0), -- 1 bits (out)
			sth_ring_reset1 => sglistfetchengine_i_sth_ring_reset1(0), -- 1 bits (out)
			clk_pcie => PCIeClockingIOGroupDef_clk_pcie, -- 1 bits (in)
			rst_pcie_n => PCIeClockingIOGroupDef_rst_pcie_n, -- 1 bits (in)
			streamrst_pcie => rst, -- 1 bits (in)
			response_valid => memreadresponsedispatcher_i_receiver0_valid, -- 2 bits (in)
			response_data => memreadresponsedispatcher_i_receiver0_data, -- 128 bits (in)
			response_select => vec_to_bit(memreadresponsedispatcher_i_receiver0_select), -- 1 bits (in)
			response_metadata => memreadresponsedispatcher_i_receiver0_metadata, -- 28 bits (in)
			response_metadata_valid => vec_to_bit(memreadresponsedispatcher_i_receiver0_metadata_valid), -- 1 bits (in)
			request_select => vec_to_bit(memreadrequestarbiter_i_port0_select), -- 1 bits (in)
			dma_abort_sfh => dma_abort_sfh, -- 32 bits (in)
			dma_abort_sth => dma_abort_sth, -- 32 bits (in)
			dma_ctl_address => dma_ctl_address, -- 9 bits (in)
			dma_ctl_data => dma_ctl_data, -- 64 bits (in)
			dma_ctl_write => dma_ctl_write, -- 1 bits (in)
			dma_ctl_byte_en => dma_ctl_byte_en, -- 8 bits (in)
			bar_parse_wr_addr_onehot => BarSpaceExternalParserIOGroupDef_wr_addr_onehot, -- 256 bits (in)
			bar_parse_wr_data => BarSpaceExternalParserIOGroupDef_wr_data, -- 64 bits (in)
			bar_parse_wr_clk => BarSpaceExternalParserIOGroupDef_wr_clk, -- 1 bits (in)
			bar_parse_wr_page_sel_onehot => BarSpaceExternalParserIOGroupDef_wr_page_sel_onehot, -- 2 bits (in)
			sfh0_port_dma_complete => vec_to_bit(pciestreamfromhost0_gather_list_dma_complete), -- 1 bits (in)
			sfh0_port_entry_complete => vec_to_bit(pciestreamfromhost0_gather_list_entry_complete), -- 1 bits (in)
			sfh0_port_entry_read => vec_to_bit(pciestreamfromhost0_gather_list_entry_read), -- 1 bits (in)
			sfh1_port_dma_complete => vec_to_bit(pciestreamfromhost1_gather_list_dma_complete), -- 1 bits (in)
			sfh1_port_entry_complete => vec_to_bit(pciestreamfromhost1_gather_list_entry_complete), -- 1 bits (in)
			sfh1_port_entry_read => vec_to_bit(pciestreamfromhost1_gather_list_entry_read), -- 1 bits (in)
			sfh2_port_dma_complete => vec_to_bit(pciestreamfromhost2_gather_list_dma_complete), -- 1 bits (in)
			sfh2_port_entry_complete => vec_to_bit(pciestreamfromhost2_gather_list_entry_complete), -- 1 bits (in)
			sfh2_port_entry_read => vec_to_bit(pciestreamfromhost2_gather_list_entry_read), -- 1 bits (in)
			sfh3_port_dma_complete => vec_to_bit(pciestreamfromhost3_gather_list_dma_complete), -- 1 bits (in)
			sfh3_port_entry_complete => vec_to_bit(pciestreamfromhost3_gather_list_entry_complete), -- 1 bits (in)
			sfh3_port_entry_read => vec_to_bit(pciestreamfromhost3_gather_list_entry_read), -- 1 bits (in)
			sfh4_port_dma_complete => vec_to_bit(pciestreamfromhost4_gather_list_dma_complete), -- 1 bits (in)
			sfh4_port_entry_complete => vec_to_bit(pciestreamfromhost4_gather_list_entry_complete), -- 1 bits (in)
			sfh4_port_entry_read => vec_to_bit(pciestreamfromhost4_gather_list_entry_read), -- 1 bits (in)
			sg_ring_write_sfh4_select => vec_to_bit(memwriterequestarbiter_i_port0_select), -- 1 bits (in)
			sg_ring_write_sfh4_data_read => vec_to_bit(memwriterequestarbiter_i_port0_data_read), -- 1 bits (in)
			sth0_port_dma_complete => vec_to_bit(pciestreamtohost0_scatter_list_dma_complete), -- 1 bits (in)
			sth0_port_entry_complete => vec_to_bit(pciestreamtohost0_scatter_list_entry_complete), -- 1 bits (in)
			sth0_port_entry_read => vec_to_bit(pciestreamtohost0_scatter_list_entry_read), -- 1 bits (in)
			sth1_port_dma_complete => vec_to_bit(pciestreamtohost1_scatter_list_dma_complete), -- 1 bits (in)
			sth1_port_entry_complete => vec_to_bit(pciestreamtohost1_scatter_list_entry_complete), -- 1 bits (in)
			sth1_port_entry_read => vec_to_bit(pciestreamtohost1_scatter_list_entry_read) -- 1 bits (in)
		);
	PCIeStreamToHost0 : PCIeStreamToHost
		port map (
			scatter_list_dma_complete => pciestreamtohost0_scatter_list_dma_complete(0), -- 1 bits (out)
			scatter_list_entry_complete => pciestreamtohost0_scatter_list_entry_complete(0), -- 1 bits (out)
			scatter_list_entry_read => pciestreamtohost0_scatter_list_entry_read(0), -- 1 bits (out)
			in_stream_stall => pciestreamtohost0_in_stream_stall(0), -- 1 bits (out)
			request_ready => pciestreamtohost0_request_ready(0), -- 1 bits (out)
			request_last => pciestreamtohost0_request_last(0), -- 1 bits (out)
			request_len => pciestreamtohost0_request_len, -- 9 bits (out)
			request_addr => pciestreamtohost0_request_addr, -- 61 bits (out)
			request_data => pciestreamtohost0_request_data, -- 128 bits (out)
			request_data_valid => pciestreamtohost0_request_data_valid(0), -- 1 bits (out)
			streamrst_pcie => vec_to_bit(sglistfetchengine_i_sth_ring_reset0), -- 1 bits (in)
			clk_pcie => PCIeClockingIOGroupDef_clk_pcie, -- 1 bits (in)
			rst_pcie_n => PCIeClockingIOGroupDef_rst_pcie_n, -- 1 bits (in)
			scatter_list_entry_data => sglistfetchengine_i_sth0_port_entry_data, -- 61 bits (in)
			scatter_list_entry_size => sglistfetchengine_i_sth0_port_entry_size, -- 9 bits (in)
			scatter_list_entry_last => vec_to_bit(sglistfetchengine_i_sth0_port_entry_last), -- 1 bits (in)
			scatter_list_entry_eos => vec_to_bit(sglistfetchengine_i_sth0_port_entry_eos), -- 1 bits (in)
			scatter_list_abort_dma => vec_to_bit(sglistfetchengine_i_sth0_port_abort_dma), -- 1 bits (in)
			scatter_list_empty => vec_to_bit(sglistfetchengine_i_sth0_port_empty), -- 1 bits (in)
			in_stream_valid => sth0_valid, -- 1 bits (in)
			in_stream_done => sth0_done, -- 1 bits (in)
			in_stream_data => sth0_data, -- 128 bits (in)
			request_select => vec_to_bit(memwriterequestarbiter_i_port1_select), -- 1 bits (in)
			request_data_read => vec_to_bit(memwriterequestarbiter_i_port1_data_read) -- 1 bits (in)
		);
	PCIeStreamFromHost0 : PCIeStreamFromHostuid0
		port map (
			gather_list_dma_complete => pciestreamfromhost0_gather_list_dma_complete(0), -- 1 bits (out)
			gather_list_entry_complete => pciestreamfromhost0_gather_list_entry_complete(0), -- 1 bits (out)
			gather_list_entry_read => pciestreamfromhost0_gather_list_entry_read(0), -- 1 bits (out)
			out_stream_valid => pciestreamfromhost0_out_stream_valid(0), -- 1 bits (out)
			out_stream_done => pciestreamfromhost0_out_stream_done(0), -- 1 bits (out)
			out_stream_data => pciestreamfromhost0_out_stream_data, -- 128 bits (out)
			response_metadata_free => pciestreamfromhost0_response_metadata_free(0), -- 1 bits (out)
			request_ready => pciestreamfromhost0_request_ready(0), -- 1 bits (out)
			request_len => pciestreamfromhost0_request_len, -- 7 bits (out)
			request_addr => pciestreamfromhost0_request_addr, -- 61 bits (out)
			request_metadata => pciestreamfromhost0_request_metadata, -- 28 bits (out)
			clk_pcie => PCIeClockingIOGroupDef_clk_pcie, -- 1 bits (in)
			rst_pcie_n => PCIeClockingIOGroupDef_rst_pcie_n, -- 1 bits (in)
			streamrst_pcie => vec_to_bit(sglistfetchengine_i_sfh_ring_reset0), -- 1 bits (in)
			gather_list_entry_data => sglistfetchengine_i_sfh0_port_entry_data, -- 61 bits (in)
			gather_list_entry_size => sglistfetchengine_i_sfh0_port_entry_size, -- 9 bits (in)
			gather_list_entry_last => vec_to_bit(sglistfetchengine_i_sfh0_port_entry_last), -- 1 bits (in)
			gather_list_entry_eos => vec_to_bit(sglistfetchengine_i_sfh0_port_entry_eos), -- 1 bits (in)
			gather_list_abort_dma => vec_to_bit(sglistfetchengine_i_sfh0_port_abort_dma), -- 1 bits (in)
			gather_list_empty => vec_to_bit(sglistfetchengine_i_sfh0_port_empty), -- 1 bits (in)
			out_stream_stall => vec_to_bit(sfh0_stall_r), -- 1 bits (in)
			response_valid => memreadresponsedispatcher_i_receiver1_valid, -- 2 bits (in)
			response_data => memreadresponsedispatcher_i_receiver1_data, -- 128 bits (in)
			response_select => vec_to_bit(memreadresponsedispatcher_i_receiver1_select), -- 1 bits (in)
			response_metadata => memreadresponsedispatcher_i_receiver1_metadata, -- 28 bits (in)
			response_metadata_valid => vec_to_bit(memreadresponsedispatcher_i_receiver1_metadata_valid), -- 1 bits (in)
			request_select => vec_to_bit(memreadrequestarbiter_i_port1_select) -- 1 bits (in)
		);
	PCIeStreamFromHost1 : PCIeStreamFromHostuid1
		port map (
			gather_list_dma_complete => pciestreamfromhost1_gather_list_dma_complete(0), -- 1 bits (out)
			gather_list_entry_complete => pciestreamfromhost1_gather_list_entry_complete(0), -- 1 bits (out)
			gather_list_entry_read => pciestreamfromhost1_gather_list_entry_read(0), -- 1 bits (out)
			out_stream_valid => pciestreamfromhost1_out_stream_valid(0), -- 1 bits (out)
			out_stream_done => pciestreamfromhost1_out_stream_done(0), -- 1 bits (out)
			out_stream_data => pciestreamfromhost1_out_stream_data, -- 128 bits (out)
			response_metadata_free => pciestreamfromhost1_response_metadata_free(0), -- 1 bits (out)
			request_ready => pciestreamfromhost1_request_ready(0), -- 1 bits (out)
			request_len => pciestreamfromhost1_request_len, -- 7 bits (out)
			request_addr => pciestreamfromhost1_request_addr, -- 61 bits (out)
			request_metadata => pciestreamfromhost1_request_metadata, -- 28 bits (out)
			clk_pcie => PCIeClockingIOGroupDef_clk_pcie, -- 1 bits (in)
			rst_pcie_n => PCIeClockingIOGroupDef_rst_pcie_n, -- 1 bits (in)
			streamrst_pcie => vec_to_bit(sglistfetchengine_i_sfh_ring_reset1), -- 1 bits (in)
			gather_list_entry_data => sglistfetchengine_i_sfh1_port_entry_data, -- 61 bits (in)
			gather_list_entry_size => sglistfetchengine_i_sfh1_port_entry_size, -- 9 bits (in)
			gather_list_entry_last => vec_to_bit(sglistfetchengine_i_sfh1_port_entry_last), -- 1 bits (in)
			gather_list_entry_eos => vec_to_bit(sglistfetchengine_i_sfh1_port_entry_eos), -- 1 bits (in)
			gather_list_abort_dma => vec_to_bit(sglistfetchengine_i_sfh1_port_abort_dma), -- 1 bits (in)
			gather_list_empty => vec_to_bit(sglistfetchengine_i_sfh1_port_empty), -- 1 bits (in)
			out_stream_stall => vec_to_bit(sfh1_stall_r), -- 1 bits (in)
			response_valid => memreadresponsedispatcher_i_receiver2_valid, -- 2 bits (in)
			response_data => memreadresponsedispatcher_i_receiver2_data, -- 128 bits (in)
			response_select => vec_to_bit(memreadresponsedispatcher_i_receiver2_select), -- 1 bits (in)
			response_metadata => memreadresponsedispatcher_i_receiver2_metadata, -- 28 bits (in)
			response_metadata_valid => vec_to_bit(memreadresponsedispatcher_i_receiver2_metadata_valid), -- 1 bits (in)
			request_select => vec_to_bit(memreadrequestarbiter_i_port2_select) -- 1 bits (in)
		);
	PCIeStreamFromHost2 : PCIeStreamFromHostuid2
		port map (
			gather_list_dma_complete => pciestreamfromhost2_gather_list_dma_complete(0), -- 1 bits (out)
			gather_list_entry_complete => pciestreamfromhost2_gather_list_entry_complete(0), -- 1 bits (out)
			gather_list_entry_read => pciestreamfromhost2_gather_list_entry_read(0), -- 1 bits (out)
			out_stream_valid => pciestreamfromhost2_out_stream_valid(0), -- 1 bits (out)
			out_stream_done => pciestreamfromhost2_out_stream_done(0), -- 1 bits (out)
			out_stream_data => pciestreamfromhost2_out_stream_data, -- 128 bits (out)
			response_metadata_free => pciestreamfromhost2_response_metadata_free(0), -- 1 bits (out)
			request_ready => pciestreamfromhost2_request_ready(0), -- 1 bits (out)
			request_len => pciestreamfromhost2_request_len, -- 7 bits (out)
			request_addr => pciestreamfromhost2_request_addr, -- 61 bits (out)
			request_metadata => pciestreamfromhost2_request_metadata, -- 28 bits (out)
			clk_pcie => PCIeClockingIOGroupDef_clk_pcie, -- 1 bits (in)
			rst_pcie_n => PCIeClockingIOGroupDef_rst_pcie_n, -- 1 bits (in)
			streamrst_pcie => vec_to_bit(sglistfetchengine_i_sfh_ring_reset2), -- 1 bits (in)
			gather_list_entry_data => sglistfetchengine_i_sfh2_port_entry_data, -- 61 bits (in)
			gather_list_entry_size => sglistfetchengine_i_sfh2_port_entry_size, -- 9 bits (in)
			gather_list_entry_last => vec_to_bit(sglistfetchengine_i_sfh2_port_entry_last), -- 1 bits (in)
			gather_list_entry_eos => vec_to_bit(sglistfetchengine_i_sfh2_port_entry_eos), -- 1 bits (in)
			gather_list_abort_dma => vec_to_bit(sglistfetchengine_i_sfh2_port_abort_dma), -- 1 bits (in)
			gather_list_empty => vec_to_bit(sglistfetchengine_i_sfh2_port_empty), -- 1 bits (in)
			out_stream_stall => vec_to_bit(sfh2_stall_r), -- 1 bits (in)
			response_valid => memreadresponsedispatcher_i_receiver3_valid, -- 2 bits (in)
			response_data => memreadresponsedispatcher_i_receiver3_data, -- 128 bits (in)
			response_select => vec_to_bit(memreadresponsedispatcher_i_receiver3_select), -- 1 bits (in)
			response_metadata => memreadresponsedispatcher_i_receiver3_metadata, -- 28 bits (in)
			response_metadata_valid => vec_to_bit(memreadresponsedispatcher_i_receiver3_metadata_valid), -- 1 bits (in)
			request_select => vec_to_bit(memreadrequestarbiter_i_port3_select) -- 1 bits (in)
		);
	PCIeStreamFromHost3 : PCIeStreamFromHostuid3
		port map (
			gather_list_dma_complete => pciestreamfromhost3_gather_list_dma_complete(0), -- 1 bits (out)
			gather_list_entry_complete => pciestreamfromhost3_gather_list_entry_complete(0), -- 1 bits (out)
			gather_list_entry_read => pciestreamfromhost3_gather_list_entry_read(0), -- 1 bits (out)
			out_stream_valid => pciestreamfromhost3_out_stream_valid(0), -- 1 bits (out)
			out_stream_done => pciestreamfromhost3_out_stream_done(0), -- 1 bits (out)
			out_stream_data => pciestreamfromhost3_out_stream_data, -- 128 bits (out)
			response_metadata_free => pciestreamfromhost3_response_metadata_free(0), -- 1 bits (out)
			request_ready => pciestreamfromhost3_request_ready(0), -- 1 bits (out)
			request_len => pciestreamfromhost3_request_len, -- 7 bits (out)
			request_addr => pciestreamfromhost3_request_addr, -- 61 bits (out)
			request_metadata => pciestreamfromhost3_request_metadata, -- 28 bits (out)
			clk_pcie => PCIeClockingIOGroupDef_clk_pcie, -- 1 bits (in)
			rst_pcie_n => PCIeClockingIOGroupDef_rst_pcie_n, -- 1 bits (in)
			streamrst_pcie => vec_to_bit(sglistfetchengine_i_sfh_ring_reset3), -- 1 bits (in)
			gather_list_entry_data => sglistfetchengine_i_sfh3_port_entry_data, -- 61 bits (in)
			gather_list_entry_size => sglistfetchengine_i_sfh3_port_entry_size, -- 9 bits (in)
			gather_list_entry_last => vec_to_bit(sglistfetchengine_i_sfh3_port_entry_last), -- 1 bits (in)
			gather_list_entry_eos => vec_to_bit(sglistfetchengine_i_sfh3_port_entry_eos), -- 1 bits (in)
			gather_list_abort_dma => vec_to_bit(sglistfetchengine_i_sfh3_port_abort_dma), -- 1 bits (in)
			gather_list_empty => vec_to_bit(sglistfetchengine_i_sfh3_port_empty), -- 1 bits (in)
			out_stream_stall => vec_to_bit(sfh3_stall_r), -- 1 bits (in)
			response_valid => memreadresponsedispatcher_i_receiver4_valid, -- 2 bits (in)
			response_data => memreadresponsedispatcher_i_receiver4_data, -- 128 bits (in)
			response_select => vec_to_bit(memreadresponsedispatcher_i_receiver4_select), -- 1 bits (in)
			response_metadata => memreadresponsedispatcher_i_receiver4_metadata, -- 28 bits (in)
			response_metadata_valid => vec_to_bit(memreadresponsedispatcher_i_receiver4_metadata_valid), -- 1 bits (in)
			request_select => vec_to_bit(memreadrequestarbiter_i_port4_select) -- 1 bits (in)
		);
	PCIeStreamFromHost4 : PCIeStreamFromHostuid4
		port map (
			gather_list_dma_complete => pciestreamfromhost4_gather_list_dma_complete(0), -- 1 bits (out)
			gather_list_entry_complete => pciestreamfromhost4_gather_list_entry_complete(0), -- 1 bits (out)
			gather_list_entry_read => pciestreamfromhost4_gather_list_entry_read(0), -- 1 bits (out)
			out_stream_valid => pciestreamfromhost4_out_stream_valid(0), -- 1 bits (out)
			out_stream_done => pciestreamfromhost4_out_stream_done(0), -- 1 bits (out)
			out_stream_data => pciestreamfromhost4_out_stream_data, -- 128 bits (out)
			response_metadata_free => pciestreamfromhost4_response_metadata_free(0), -- 1 bits (out)
			request_ready => pciestreamfromhost4_request_ready(0), -- 1 bits (out)
			request_len => pciestreamfromhost4_request_len, -- 7 bits (out)
			request_addr => pciestreamfromhost4_request_addr, -- 61 bits (out)
			request_metadata => pciestreamfromhost4_request_metadata, -- 28 bits (out)
			clk_pcie => PCIeClockingIOGroupDef_clk_pcie, -- 1 bits (in)
			rst_pcie_n => PCIeClockingIOGroupDef_rst_pcie_n, -- 1 bits (in)
			streamrst_pcie => vec_to_bit(sglistfetchengine_i_sfh_ring_reset4), -- 1 bits (in)
			gather_list_entry_data => sglistfetchengine_i_sfh4_port_entry_data, -- 61 bits (in)
			gather_list_entry_size => sglistfetchengine_i_sfh4_port_entry_size, -- 9 bits (in)
			gather_list_entry_last => vec_to_bit(sglistfetchengine_i_sfh4_port_entry_last), -- 1 bits (in)
			gather_list_entry_eos => vec_to_bit(sglistfetchengine_i_sfh4_port_entry_eos), -- 1 bits (in)
			gather_list_abort_dma => vec_to_bit(sglistfetchengine_i_sfh4_port_abort_dma), -- 1 bits (in)
			gather_list_empty => vec_to_bit(sglistfetchengine_i_sfh4_port_empty), -- 1 bits (in)
			out_stream_stall => vec_to_bit(sfh4_stall_r), -- 1 bits (in)
			response_valid => memreadresponsedispatcher_i_receiver5_valid, -- 2 bits (in)
			response_data => memreadresponsedispatcher_i_receiver5_data, -- 128 bits (in)
			response_select => vec_to_bit(memreadresponsedispatcher_i_receiver5_select), -- 1 bits (in)
			response_metadata => memreadresponsedispatcher_i_receiver5_metadata, -- 28 bits (in)
			response_metadata_valid => vec_to_bit(memreadresponsedispatcher_i_receiver5_metadata_valid), -- 1 bits (in)
			request_select => vec_to_bit(memreadrequestarbiter_i_port5_select) -- 1 bits (in)
		);
	PCIeStreamToHost1 : PCIeStreamToHost
		port map (
			scatter_list_dma_complete => pciestreamtohost1_scatter_list_dma_complete(0), -- 1 bits (out)
			scatter_list_entry_complete => pciestreamtohost1_scatter_list_entry_complete(0), -- 1 bits (out)
			scatter_list_entry_read => pciestreamtohost1_scatter_list_entry_read(0), -- 1 bits (out)
			in_stream_stall => pciestreamtohost1_in_stream_stall(0), -- 1 bits (out)
			request_ready => pciestreamtohost1_request_ready(0), -- 1 bits (out)
			request_last => pciestreamtohost1_request_last(0), -- 1 bits (out)
			request_len => pciestreamtohost1_request_len, -- 9 bits (out)
			request_addr => pciestreamtohost1_request_addr, -- 61 bits (out)
			request_data => pciestreamtohost1_request_data, -- 128 bits (out)
			request_data_valid => pciestreamtohost1_request_data_valid(0), -- 1 bits (out)
			streamrst_pcie => vec_to_bit(sglistfetchengine_i_sth_ring_reset1), -- 1 bits (in)
			clk_pcie => PCIeClockingIOGroupDef_clk_pcie, -- 1 bits (in)
			rst_pcie_n => PCIeClockingIOGroupDef_rst_pcie_n, -- 1 bits (in)
			scatter_list_entry_data => sglistfetchengine_i_sth1_port_entry_data, -- 61 bits (in)
			scatter_list_entry_size => sglistfetchengine_i_sth1_port_entry_size, -- 9 bits (in)
			scatter_list_entry_last => vec_to_bit(sglistfetchengine_i_sth1_port_entry_last), -- 1 bits (in)
			scatter_list_entry_eos => vec_to_bit(sglistfetchengine_i_sth1_port_entry_eos), -- 1 bits (in)
			scatter_list_abort_dma => vec_to_bit(sglistfetchengine_i_sth1_port_abort_dma), -- 1 bits (in)
			scatter_list_empty => vec_to_bit(sglistfetchengine_i_sth1_port_empty), -- 1 bits (in)
			in_stream_valid => sth1_valid, -- 1 bits (in)
			in_stream_done => sth1_done, -- 1 bits (in)
			in_stream_data => sth1_data, -- 128 bits (in)
			request_select => vec_to_bit(memwriterequestarbiter_i_port2_select), -- 1 bits (in)
			request_data_read => vec_to_bit(memwriterequestarbiter_i_port2_data_read) -- 1 bits (in)
		);
end MaxDC;
