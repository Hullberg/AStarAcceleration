library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity SignalForwardingAdapter_stream_reset_memory_interrupt_crash_packet_sysmon_reset_pcc_switch_regs_pcc_start_pcc_reset_partial_reconfig_0 is
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
end SignalForwardingAdapter_stream_reset_memory_interrupt_crash_packet_sysmon_reset_pcc_switch_regs_pcc_start_pcc_reset_partial_reconfig_0;

architecture MaxDC of SignalForwardingAdapter_stream_reset_memory_interrupt_crash_packet_sysmon_reset_pcc_switch_regs_pcc_start_pcc_reset_partial_reconfig_0 is
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
	component SignalForwardingEA is
		port (
			clk_switch: in std_logic;
			rst_switch: in std_logic;
			FROM_SWITCH_SOP_N: in std_logic;
			FROM_SWITCH_EOP_N: in std_logic;
			FROM_SWITCH_SRC_RDY_N: in std_logic;
			FROM_SWITCH_DATA: in std_logic_vector(31 downto 0);
			TO_SWITCH_DST_RDY_N: in std_logic;
			ea_finished: in std_logic;
			ea_manual: in std_logic;
			FROM_EA_SOP_N: in std_logic;
			FROM_EA_EOP_N: in std_logic;
			FROM_EA_SRC_RDY_N: in std_logic;
			FROM_EA_DATA: in std_logic_vector(31 downto 0);
			TO_EA_DST_RDY_N: in std_logic;
			FROM_SWITCH_DST_RDY_N: out std_logic;
			TO_SWITCH_SOP_N: out std_logic;
			TO_SWITCH_EOP_N: out std_logic;
			TO_SWITCH_SRC_RDY_N: out std_logic;
			TO_SWITCH_DATA: out std_logic_vector(31 downto 0);
			ea_start: out std_logic;
			ea_manual_rdy: out std_logic;
			FROM_EA_DST_RDY_N: out std_logic;
			TO_EA_SOP_N: out std_logic;
			TO_EA_EOP_N: out std_logic;
			TO_EA_SRC_RDY_N: out std_logic;
			TO_EA_DATA: out std_logic_vector(31 downto 0);
			outputs_to_toggle: out std_logic_vector(29 downto 0);
			gen_ack_n: out std_logic;
			is_response_header: out std_logic
		);
	end component;
	component MappedRegBlock_4cdf0f923c75d2a0461d279b0adb9830 is
		port (
			register_clk: in std_logic;
			register_in: in std_logic_vector(7 downto 0);
			register_rotate: in std_logic;
			register_stop: in std_logic;
			register_switch: in std_logic;
			register_out: out std_logic_vector(7 downto 0);
			reg_SFA_FORWARD_EN: out std_logic_vector(31 downto 0)
		);
	end component;
	component signal_forwarding_adapter is
		generic (
			DATA_WIDTH : integer;
			IO_WIDTH : integer
		);
		port (
			clk_sfa: in std_logic;
			rst_sfa: in std_logic;
			ea_start: in std_logic;
			ea_manual_rdy: in std_logic;
			outputs_to_toggle: in std_logic_vector(7 downto 0);
			gen_ack_n: in std_logic;
			SWITCH_HEADER_1: in std_logic_vector(15 downto 0);
			SWITCH_HEADER_2: in std_logic_vector(15 downto 0);
			FORWARD_EN: in std_logic_vector(7 downto 0);
			WRITE_PORT_SOP_N: in std_logic;
			WRITE_PORT_EOP_N: in std_logic;
			WRITE_PORT_SRC_RDY_N: in std_logic;
			WRITE_PORT_DATA: in std_logic_vector(31 downto 0);
			READ_PORT_DST_RDY_N: in std_logic;
			inputs: in std_logic_vector(7 downto 0);
			ea_finished: out std_logic;
			ea_manual: out std_logic;
			WRITE_PORT_DST_RDY_N: out std_logic;
			READ_PORT_SOP_N: out std_logic;
			READ_PORT_EOP_N: out std_logic;
			READ_PORT_SRC_RDY_N: out std_logic;
			READ_PORT_DATA: out std_logic_vector(31 downto 0);
			outputs: out std_logic_vector(7 downto 0)
		);
	end component;
	
	-- Signal declarations
	
	signal signalforwardingea_i_from_switch_dst_rdy_n : std_logic_vector(0 downto 0);
	signal signalforwardingea_i_to_switch_sop_n : std_logic_vector(0 downto 0);
	signal signalforwardingea_i_to_switch_eop_n : std_logic_vector(0 downto 0);
	signal signalforwardingea_i_to_switch_src_rdy_n : std_logic_vector(0 downto 0);
	signal signalforwardingea_i_to_switch_data : std_logic_vector(31 downto 0);
	signal signalforwardingea_i_ea_start : std_logic_vector(0 downto 0);
	signal signalforwardingea_i_ea_manual_rdy : std_logic_vector(0 downto 0);
	signal signalforwardingea_i_from_ea_dst_rdy_n : std_logic_vector(0 downto 0);
	signal signalforwardingea_i_to_ea_sop_n : std_logic_vector(0 downto 0);
	signal signalforwardingea_i_to_ea_eop_n : std_logic_vector(0 downto 0);
	signal signalforwardingea_i_to_ea_src_rdy_n : std_logic_vector(0 downto 0);
	signal signalforwardingea_i_to_ea_data : std_logic_vector(31 downto 0);
	signal signalforwardingea_i_outputs_to_toggle : std_logic_vector(29 downto 0);
	signal signalforwardingea_i_gen_ack_n : std_logic_vector(0 downto 0);
	signal signalforwardingea_i_is_response_header : std_logic_vector(0 downto 0);
	signal inst_ln131_mappedregblock_register_out : std_logic_vector(7 downto 0);
	signal inst_ln131_mappedregblock_reg_sfa_forward_en : std_logic_vector(31 downto 0);
	signal signalforwardingadapterexternal_i_ea_finished : std_logic_vector(0 downto 0);
	signal signalforwardingadapterexternal_i_ea_manual : std_logic_vector(0 downto 0);
	signal signalforwardingadapterexternal_i_write_port_dst_rdy_n : std_logic_vector(0 downto 0);
	signal signalforwardingadapterexternal_i_read_port_sop_n : std_logic_vector(0 downto 0);
	signal signalforwardingadapterexternal_i_read_port_eop_n : std_logic_vector(0 downto 0);
	signal signalforwardingadapterexternal_i_read_port_src_rdy_n : std_logic_vector(0 downto 0);
	signal signalforwardingadapterexternal_i_read_port_data : std_logic_vector(31 downto 0);
	signal signalforwardingadapterexternal_i_outputs : std_logic_vector(7 downto 0);
	signal signalforwardingadapterexternal_i_outputs_to_toggle1 : std_logic_vector(7 downto 0);
	signal sig : std_logic_vector(15 downto 0);
	signal sig1 : std_logic_vector(15 downto 0);
	signal signalforwardingadapterexternal_i_forward_en1 : std_logic_vector(7 downto 0);
	signal sig2 : std_logic_vector(31 downto 0);
	signal signalforwardingadapterexternal_i_inputs1 : std_logic_vector(7 downto 0);
	signal cat_ln170_signalforwardingadapter : std_logic_vector(7 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	signalforwardingadapterexternal_i_outputs_to_toggle1 <= slice(signalforwardingea_i_outputs_to_toggle, 0, 8);
	sig <= "0000000000001000";
	sig1 <= "0000000000010000";
	sig2 <= inst_ln131_mappedregblock_reg_sfa_forward_en;
	signalforwardingadapterexternal_i_forward_en1 <= slice(sig2, 0, 8);
	cat_ln170_signalforwardingadapter<=(bit_to_vec(port_in_partial_reconfig) & bit_to_vec(port_in_pcc_reset) & bit_to_vec(port_in_pcc_start) & bit_to_vec(port_in_pcc_switch_regs) & bit_to_vec(port_in_sysmon_reset) & bit_to_vec(port_in_crash_packet) & bit_to_vec(port_in_memory_interrupt) & bit_to_vec(port_in_stream_reset));
	signalforwardingadapterexternal_i_inputs1 <= cat_ln170_signalforwardingadapter;
	FROM_SWITCH_DST_RDY_N <= vec_to_bit(signalforwardingea_i_from_switch_dst_rdy_n);
	TO_SWITCH_SOP_N <= vec_to_bit(signalforwardingea_i_to_switch_sop_n);
	TO_SWITCH_EOP_N <= vec_to_bit(signalforwardingea_i_to_switch_eop_n);
	TO_SWITCH_SRC_RDY_N <= vec_to_bit(signalforwardingea_i_to_switch_src_rdy_n);
	TO_SWITCH_DATA <= signalforwardingea_i_to_switch_data;
	register_out <= inst_ln131_mappedregblock_register_out;
	port_out_stream_reset <= vec_to_bit(slice(signalforwardingadapterexternal_i_outputs, 0, 1));
	port_out_memory_interrupt <= vec_to_bit(slice(signalforwardingadapterexternal_i_outputs, 1, 1));
	port_out_crash_packet <= vec_to_bit(slice(signalforwardingadapterexternal_i_outputs, 2, 1));
	port_out_sysmon_reset <= vec_to_bit(slice(signalforwardingadapterexternal_i_outputs, 3, 1));
	port_out_pcc_switch_regs <= vec_to_bit(slice(signalforwardingadapterexternal_i_outputs, 4, 1));
	port_out_pcc_start <= vec_to_bit(slice(signalforwardingadapterexternal_i_outputs, 5, 1));
	port_out_pcc_reset <= vec_to_bit(slice(signalforwardingadapterexternal_i_outputs, 6, 1));
	port_out_partial_reconfig <= vec_to_bit(slice(signalforwardingadapterexternal_i_outputs, 7, 1));
	
	-- Register processes
	
	
	-- Entity instances
	
	SignalForwardingEA_i : SignalForwardingEA
		port map (
			FROM_SWITCH_DST_RDY_N => signalforwardingea_i_from_switch_dst_rdy_n(0), -- 1 bits (out)
			TO_SWITCH_SOP_N => signalforwardingea_i_to_switch_sop_n(0), -- 1 bits (out)
			TO_SWITCH_EOP_N => signalforwardingea_i_to_switch_eop_n(0), -- 1 bits (out)
			TO_SWITCH_SRC_RDY_N => signalforwardingea_i_to_switch_src_rdy_n(0), -- 1 bits (out)
			TO_SWITCH_DATA => signalforwardingea_i_to_switch_data, -- 32 bits (out)
			ea_start => signalforwardingea_i_ea_start(0), -- 1 bits (out)
			ea_manual_rdy => signalforwardingea_i_ea_manual_rdy(0), -- 1 bits (out)
			FROM_EA_DST_RDY_N => signalforwardingea_i_from_ea_dst_rdy_n(0), -- 1 bits (out)
			TO_EA_SOP_N => signalforwardingea_i_to_ea_sop_n(0), -- 1 bits (out)
			TO_EA_EOP_N => signalforwardingea_i_to_ea_eop_n(0), -- 1 bits (out)
			TO_EA_SRC_RDY_N => signalforwardingea_i_to_ea_src_rdy_n(0), -- 1 bits (out)
			TO_EA_DATA => signalforwardingea_i_to_ea_data, -- 32 bits (out)
			outputs_to_toggle => signalforwardingea_i_outputs_to_toggle, -- 30 bits (out)
			gen_ack_n => signalforwardingea_i_gen_ack_n(0), -- 1 bits (out)
			is_response_header => signalforwardingea_i_is_response_header(0), -- 1 bits (out)
			clk_switch => clk_switch, -- 1 bits (in)
			rst_switch => rst_switch, -- 1 bits (in)
			FROM_SWITCH_SOP_N => FROM_SWITCH_SOP_N, -- 1 bits (in)
			FROM_SWITCH_EOP_N => FROM_SWITCH_EOP_N, -- 1 bits (in)
			FROM_SWITCH_SRC_RDY_N => FROM_SWITCH_SRC_RDY_N, -- 1 bits (in)
			FROM_SWITCH_DATA => FROM_SWITCH_DATA, -- 32 bits (in)
			TO_SWITCH_DST_RDY_N => TO_SWITCH_DST_RDY_N, -- 1 bits (in)
			ea_finished => vec_to_bit(signalforwardingadapterexternal_i_ea_finished), -- 1 bits (in)
			ea_manual => vec_to_bit(signalforwardingadapterexternal_i_ea_manual), -- 1 bits (in)
			FROM_EA_SOP_N => vec_to_bit(signalforwardingadapterexternal_i_read_port_sop_n), -- 1 bits (in)
			FROM_EA_EOP_N => vec_to_bit(signalforwardingadapterexternal_i_read_port_eop_n), -- 1 bits (in)
			FROM_EA_SRC_RDY_N => vec_to_bit(signalforwardingadapterexternal_i_read_port_src_rdy_n), -- 1 bits (in)
			FROM_EA_DATA => signalforwardingadapterexternal_i_read_port_data, -- 32 bits (in)
			TO_EA_DST_RDY_N => vec_to_bit(signalforwardingadapterexternal_i_write_port_dst_rdy_n) -- 1 bits (in)
		);
	inst_ln131_mappedregblock : MappedRegBlock_4cdf0f923c75d2a0461d279b0adb9830
		port map (
			register_out => inst_ln131_mappedregblock_register_out, -- 8 bits (out)
			reg_SFA_FORWARD_EN => inst_ln131_mappedregblock_reg_sfa_forward_en, -- 32 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => register_in, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch -- 1 bits (in)
		);
	SignalForwardingAdapterExternal_i : signal_forwarding_adapter
		generic map (
			DATA_WIDTH => 32,
			IO_WIDTH => 8
		)
		port map (
			ea_finished => signalforwardingadapterexternal_i_ea_finished(0), -- 1 bits (out)
			ea_manual => signalforwardingadapterexternal_i_ea_manual(0), -- 1 bits (out)
			WRITE_PORT_DST_RDY_N => signalforwardingadapterexternal_i_write_port_dst_rdy_n(0), -- 1 bits (out)
			READ_PORT_SOP_N => signalforwardingadapterexternal_i_read_port_sop_n(0), -- 1 bits (out)
			READ_PORT_EOP_N => signalforwardingadapterexternal_i_read_port_eop_n(0), -- 1 bits (out)
			READ_PORT_SRC_RDY_N => signalforwardingadapterexternal_i_read_port_src_rdy_n(0), -- 1 bits (out)
			READ_PORT_DATA => signalforwardingadapterexternal_i_read_port_data, -- 32 bits (out)
			outputs => signalforwardingadapterexternal_i_outputs, -- 8 bits (out)
			clk_sfa => clk_switch, -- 1 bits (in)
			rst_sfa => rst_switch, -- 1 bits (in)
			ea_start => vec_to_bit(signalforwardingea_i_ea_start), -- 1 bits (in)
			ea_manual_rdy => vec_to_bit(signalforwardingea_i_ea_manual_rdy), -- 1 bits (in)
			outputs_to_toggle => signalforwardingadapterexternal_i_outputs_to_toggle1, -- 8 bits (in)
			gen_ack_n => vec_to_bit(signalforwardingea_i_gen_ack_n), -- 1 bits (in)
			SWITCH_HEADER_1 => sig, -- 16 bits (in)
			SWITCH_HEADER_2 => sig1, -- 16 bits (in)
			FORWARD_EN => signalforwardingadapterexternal_i_forward_en1, -- 8 bits (in)
			WRITE_PORT_SOP_N => vec_to_bit(signalforwardingea_i_to_ea_sop_n), -- 1 bits (in)
			WRITE_PORT_EOP_N => vec_to_bit(signalforwardingea_i_to_ea_eop_n), -- 1 bits (in)
			WRITE_PORT_SRC_RDY_N => vec_to_bit(signalforwardingea_i_to_ea_src_rdy_n), -- 1 bits (in)
			WRITE_PORT_DATA => signalforwardingea_i_to_ea_data, -- 32 bits (in)
			READ_PORT_DST_RDY_N => vec_to_bit(signalforwardingea_i_from_ea_dst_rdy_n), -- 1 bits (in)
			inputs => signalforwardingadapterexternal_i_inputs1 -- 8 bits (in)
		);
end MaxDC;
