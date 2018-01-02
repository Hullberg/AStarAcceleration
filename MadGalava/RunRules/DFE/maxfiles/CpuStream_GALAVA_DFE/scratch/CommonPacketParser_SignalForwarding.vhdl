library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity CommonPacketParser_SignalForwarding is
	port (
		clk_switch: in std_logic;
		rst_switch: in std_logic;
		FROM_SWITCH_SOP_N: in std_logic;
		FROM_SWITCH_EOP_N: in std_logic;
		FROM_SWITCH_SRC_RDY_N: in std_logic;
		FROM_SWITCH_DATA: in std_logic_vector(31 downto 0);
		TO_SWITCH_DST_RDY_N: in std_logic;
		FROM_EA_SOP_N: in std_logic;
		FROM_EA_EOP_N: in std_logic;
		FROM_EA_SRC_RDY_N: in std_logic;
		FROM_EA_DATA: in std_logic_vector(31 downto 0);
		TO_EA_DST_RDY_N: in std_logic;
		ea_finished: in std_logic;
		ea_manual: in std_logic;
		FROM_SWITCH_DST_RDY_N: out std_logic;
		TO_SWITCH_SOP_N: out std_logic;
		TO_SWITCH_EOP_N: out std_logic;
		TO_SWITCH_SRC_RDY_N: out std_logic;
		TO_SWITCH_DATA: out std_logic_vector(31 downto 0);
		FROM_EA_DST_RDY_N: out std_logic;
		TO_EA_SOP_N: out std_logic;
		TO_EA_EOP_N: out std_logic;
		TO_EA_SRC_RDY_N: out std_logic;
		TO_EA_DATA: out std_logic_vector(31 downto 0);
		ea_start: out std_logic;
		ea_manual_rdy: out std_logic;
		outputs_to_toggle: out std_logic_vector(29 downto 0);
		gen_ack_n: out std_logic;
		is_response_header: out std_logic
	);
end CommonPacketParser_SignalForwarding;

architecture MaxDC of CommonPacketParser_SignalForwarding is
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
	component common_packet_parser is
		generic (
			NUM_HEADERS : integer;
			NUM_HEADERS_WIDTH : integer;
			HEADER_WIDTH : integer
		);
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
			FROM_SWITCH_DST_RDY_N: out std_logic;
			TO_SWITCH_SOP_N: out std_logic;
			TO_SWITCH_EOP_N: out std_logic;
			TO_SWITCH_SRC_RDY_N: out std_logic;
			TO_SWITCH_DATA: out std_logic_vector(31 downto 0);
			ea_start: out std_logic;
			ea_manual_rdy: out std_logic;
			select_ea: out std_logic;
			headers: out std_logic_vector(31 downto 0)
		);
	end component;
	component ControlMux is
		port (
			select_ea: in std_logic;
			FROM_SWITCH_SOP_N: in std_logic;
			FROM_SWITCH_EOP_N: in std_logic;
			FROM_SWITCH_SRC_RDY_N: in std_logic;
			FROM_SWITCH_DATA: in std_logic_vector(31 downto 0);
			TO_SWITCH_DST_RDY_N: in std_logic;
			FROM_CPP_SOP_N: in std_logic;
			FROM_CPP_EOP_N: in std_logic;
			FROM_CPP_SRC_RDY_N: in std_logic;
			FROM_CPP_DATA: in std_logic_vector(31 downto 0);
			TO_CPP_DST_RDY_N: in std_logic;
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
			FROM_CPP_DST_RDY_N: out std_logic;
			TO_CPP_SOP_N: out std_logic;
			TO_CPP_EOP_N: out std_logic;
			TO_CPP_SRC_RDY_N: out std_logic;
			TO_CPP_DATA: out std_logic_vector(31 downto 0);
			FROM_EA_DST_RDY_N: out std_logic;
			TO_EA_SOP_N: out std_logic;
			TO_EA_EOP_N: out std_logic;
			TO_EA_SRC_RDY_N: out std_logic;
			TO_EA_DATA: out std_logic_vector(31 downto 0)
		);
	end component;
	
	-- Signal declarations
	
	signal commonpacketparserexternal_signalforwarding_from_switch_dst_rdy_n : std_logic_vector(0 downto 0);
	signal commonpacketparserexternal_signalforwarding_to_switch_sop_n : std_logic_vector(0 downto 0);
	signal commonpacketparserexternal_signalforwarding_to_switch_eop_n : std_logic_vector(0 downto 0);
	signal commonpacketparserexternal_signalforwarding_to_switch_src_rdy_n : std_logic_vector(0 downto 0);
	signal commonpacketparserexternal_signalforwarding_to_switch_data : std_logic_vector(31 downto 0);
	signal commonpacketparserexternal_signalforwarding_ea_start : std_logic_vector(0 downto 0);
	signal commonpacketparserexternal_signalforwarding_ea_manual_rdy : std_logic_vector(0 downto 0);
	signal commonpacketparserexternal_signalforwarding_select_ea : std_logic_vector(0 downto 0);
	signal commonpacketparserexternal_signalforwarding_headers : std_logic_vector(31 downto 0);
	signal control_mux_from_switch_dst_rdy_n : std_logic_vector(0 downto 0);
	signal control_mux_to_switch_sop_n : std_logic_vector(0 downto 0);
	signal control_mux_to_switch_eop_n : std_logic_vector(0 downto 0);
	signal control_mux_to_switch_src_rdy_n : std_logic_vector(0 downto 0);
	signal control_mux_to_switch_data : std_logic_vector(31 downto 0);
	signal control_mux_from_cpp_dst_rdy_n : std_logic_vector(0 downto 0);
	signal control_mux_to_cpp_sop_n : std_logic_vector(0 downto 0);
	signal control_mux_to_cpp_eop_n : std_logic_vector(0 downto 0);
	signal control_mux_to_cpp_src_rdy_n : std_logic_vector(0 downto 0);
	signal control_mux_to_cpp_data : std_logic_vector(31 downto 0);
	signal control_mux_from_ea_dst_rdy_n : std_logic_vector(0 downto 0);
	signal control_mux_to_ea_sop_n : std_logic_vector(0 downto 0);
	signal control_mux_to_ea_eop_n : std_logic_vector(0 downto 0);
	signal control_mux_to_ea_src_rdy_n : std_logic_vector(0 downto 0);
	signal control_mux_to_ea_data : std_logic_vector(31 downto 0);
	signal headerslice_outputs_to_toggle : std_logic_vector(29 downto 0);
	signal headerslice_gen_ack_n : std_logic_vector(0 downto 0);
	signal headerslice_is_response_header : std_logic_vector(0 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	headerslice_outputs_to_toggle <= slice(commonpacketparserexternal_signalforwarding_headers, 0, 30);
	headerslice_gen_ack_n <= slice(commonpacketparserexternal_signalforwarding_headers, 30, 1);
	headerslice_is_response_header <= slice(commonpacketparserexternal_signalforwarding_headers, 31, 1);
	FROM_SWITCH_DST_RDY_N <= vec_to_bit(control_mux_from_switch_dst_rdy_n);
	TO_SWITCH_SOP_N <= vec_to_bit(control_mux_to_switch_sop_n);
	TO_SWITCH_EOP_N <= vec_to_bit(control_mux_to_switch_eop_n);
	TO_SWITCH_SRC_RDY_N <= vec_to_bit(control_mux_to_switch_src_rdy_n);
	TO_SWITCH_DATA <= control_mux_to_switch_data;
	FROM_EA_DST_RDY_N <= vec_to_bit(control_mux_from_ea_dst_rdy_n);
	TO_EA_SOP_N <= vec_to_bit(control_mux_to_ea_sop_n);
	TO_EA_EOP_N <= vec_to_bit(control_mux_to_ea_eop_n);
	TO_EA_SRC_RDY_N <= vec_to_bit(control_mux_to_ea_src_rdy_n);
	TO_EA_DATA <= control_mux_to_ea_data;
	ea_start <= vec_to_bit(commonpacketparserexternal_signalforwarding_ea_start);
	ea_manual_rdy <= vec_to_bit(commonpacketparserexternal_signalforwarding_ea_manual_rdy);
	outputs_to_toggle <= headerslice_outputs_to_toggle;
	gen_ack_n <= vec_to_bit(headerslice_gen_ack_n);
	is_response_header <= vec_to_bit(headerslice_is_response_header);
	
	-- Register processes
	
	
	-- Entity instances
	
	CommonPacketParserExternal_SignalForwarding : common_packet_parser
		generic map (
			NUM_HEADERS => 1,
			NUM_HEADERS_WIDTH => 6,
			HEADER_WIDTH => 32
		)
		port map (
			FROM_SWITCH_DST_RDY_N => commonpacketparserexternal_signalforwarding_from_switch_dst_rdy_n(0), -- 1 bits (out)
			TO_SWITCH_SOP_N => commonpacketparserexternal_signalforwarding_to_switch_sop_n(0), -- 1 bits (out)
			TO_SWITCH_EOP_N => commonpacketparserexternal_signalforwarding_to_switch_eop_n(0), -- 1 bits (out)
			TO_SWITCH_SRC_RDY_N => commonpacketparserexternal_signalforwarding_to_switch_src_rdy_n(0), -- 1 bits (out)
			TO_SWITCH_DATA => commonpacketparserexternal_signalforwarding_to_switch_data, -- 32 bits (out)
			ea_start => commonpacketparserexternal_signalforwarding_ea_start(0), -- 1 bits (out)
			ea_manual_rdy => commonpacketparserexternal_signalforwarding_ea_manual_rdy(0), -- 1 bits (out)
			select_ea => commonpacketparserexternal_signalforwarding_select_ea(0), -- 1 bits (out)
			headers => commonpacketparserexternal_signalforwarding_headers, -- 32 bits (out)
			clk_switch => clk_switch, -- 1 bits (in)
			rst_switch => rst_switch, -- 1 bits (in)
			FROM_SWITCH_SOP_N => vec_to_bit(control_mux_to_cpp_sop_n), -- 1 bits (in)
			FROM_SWITCH_EOP_N => vec_to_bit(control_mux_to_cpp_eop_n), -- 1 bits (in)
			FROM_SWITCH_SRC_RDY_N => vec_to_bit(control_mux_to_cpp_src_rdy_n), -- 1 bits (in)
			FROM_SWITCH_DATA => control_mux_to_cpp_data, -- 32 bits (in)
			TO_SWITCH_DST_RDY_N => vec_to_bit(control_mux_from_cpp_dst_rdy_n), -- 1 bits (in)
			ea_finished => ea_finished, -- 1 bits (in)
			ea_manual => ea_manual -- 1 bits (in)
		);
	control_mux : ControlMux
		port map (
			FROM_SWITCH_DST_RDY_N => control_mux_from_switch_dst_rdy_n(0), -- 1 bits (out)
			TO_SWITCH_SOP_N => control_mux_to_switch_sop_n(0), -- 1 bits (out)
			TO_SWITCH_EOP_N => control_mux_to_switch_eop_n(0), -- 1 bits (out)
			TO_SWITCH_SRC_RDY_N => control_mux_to_switch_src_rdy_n(0), -- 1 bits (out)
			TO_SWITCH_DATA => control_mux_to_switch_data, -- 32 bits (out)
			FROM_CPP_DST_RDY_N => control_mux_from_cpp_dst_rdy_n(0), -- 1 bits (out)
			TO_CPP_SOP_N => control_mux_to_cpp_sop_n(0), -- 1 bits (out)
			TO_CPP_EOP_N => control_mux_to_cpp_eop_n(0), -- 1 bits (out)
			TO_CPP_SRC_RDY_N => control_mux_to_cpp_src_rdy_n(0), -- 1 bits (out)
			TO_CPP_DATA => control_mux_to_cpp_data, -- 32 bits (out)
			FROM_EA_DST_RDY_N => control_mux_from_ea_dst_rdy_n(0), -- 1 bits (out)
			TO_EA_SOP_N => control_mux_to_ea_sop_n(0), -- 1 bits (out)
			TO_EA_EOP_N => control_mux_to_ea_eop_n(0), -- 1 bits (out)
			TO_EA_SRC_RDY_N => control_mux_to_ea_src_rdy_n(0), -- 1 bits (out)
			TO_EA_DATA => control_mux_to_ea_data, -- 32 bits (out)
			select_ea => vec_to_bit(commonpacketparserexternal_signalforwarding_select_ea), -- 1 bits (in)
			FROM_SWITCH_SOP_N => FROM_SWITCH_SOP_N, -- 1 bits (in)
			FROM_SWITCH_EOP_N => FROM_SWITCH_EOP_N, -- 1 bits (in)
			FROM_SWITCH_SRC_RDY_N => FROM_SWITCH_SRC_RDY_N, -- 1 bits (in)
			FROM_SWITCH_DATA => FROM_SWITCH_DATA, -- 32 bits (in)
			TO_SWITCH_DST_RDY_N => TO_SWITCH_DST_RDY_N, -- 1 bits (in)
			FROM_CPP_SOP_N => vec_to_bit(commonpacketparserexternal_signalforwarding_to_switch_sop_n), -- 1 bits (in)
			FROM_CPP_EOP_N => vec_to_bit(commonpacketparserexternal_signalforwarding_to_switch_eop_n), -- 1 bits (in)
			FROM_CPP_SRC_RDY_N => vec_to_bit(commonpacketparserexternal_signalforwarding_to_switch_src_rdy_n), -- 1 bits (in)
			FROM_CPP_DATA => commonpacketparserexternal_signalforwarding_to_switch_data, -- 32 bits (in)
			TO_CPP_DST_RDY_N => vec_to_bit(commonpacketparserexternal_signalforwarding_from_switch_dst_rdy_n), -- 1 bits (in)
			FROM_EA_SOP_N => FROM_EA_SOP_N, -- 1 bits (in)
			FROM_EA_EOP_N => FROM_EA_EOP_N, -- 1 bits (in)
			FROM_EA_SRC_RDY_N => FROM_EA_SRC_RDY_N, -- 1 bits (in)
			FROM_EA_DATA => FROM_EA_DATA, -- 32 bits (in)
			TO_EA_DST_RDY_N => TO_EA_DST_RDY_N -- 1 bits (in)
		);
end MaxDC;
