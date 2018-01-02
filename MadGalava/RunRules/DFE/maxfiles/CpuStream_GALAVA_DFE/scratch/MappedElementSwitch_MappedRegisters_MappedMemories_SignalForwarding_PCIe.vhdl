library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity MappedElementSwitch_MappedRegisters_MappedMemories_SignalForwarding_PCIe is
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
end MappedElementSwitch_MappedRegisters_MappedMemories_SignalForwarding_PCIe;

architecture MaxDC of MappedElementSwitch_MappedRegisters_MappedMemories_SignalForwarding_PCIe is
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
	component mapped_element_switch is
		generic (
			NUM_EAS : integer;
			NUM_EAS_WIDTH : integer
		);
		port (
			clk_switch: in std_logic;
			rst_switch: in std_logic;
			REQUEST_SRC_SOP_N: in std_logic;
			REQUEST_SRC_EOP_N: in std_logic;
			REQUEST_SRC_SRC_RDY_N: in std_logic;
			REQUEST_SRC_DATA: in std_logic_vector(31 downto 0);
			RESPONSE_SRC_SOP_N: in std_logic;
			RESPONSE_SRC_EOP_N: in std_logic;
			RESPONSE_SRC_SRC_RDY_N: in std_logic;
			RESPONSE_SRC_DATA: in std_logic_vector(31 downto 0);
			REQUEST_DEST_DST_RDY_N: in std_logic;
			RESPONSE_DEST_DST_RDY_N: in std_logic;
			EA_READY_N: in std_logic_vector(15 downto 0);
			REQUEST_SRC_DST_RDY_N: out std_logic;
			RESPONSE_SRC_DST_RDY_N: out std_logic;
			REQUEST_DEST_SOP_N: out std_logic;
			REQUEST_DEST_EOP_N: out std_logic;
			REQUEST_DEST_SRC_RDY_N: out std_logic;
			REQUEST_DEST_DATA: out std_logic_vector(31 downto 0);
			RESPONSE_DEST_SOP_N: out std_logic;
			RESPONSE_DEST_EOP_N: out std_logic;
			RESPONSE_DEST_SRC_RDY_N: out std_logic;
			RESPONSE_DEST_DATA: out std_logic_vector(31 downto 0);
			request_src_select: out std_logic_vector(15 downto 0);
			response_src_select: out std_logic_vector(15 downto 0);
			request_dest_select: out std_logic_vector(15 downto 0);
			response_dest_select: out std_logic_vector(15 downto 0)
		);
	end component;
	
	-- Signal declarations
	
	signal mappedelementswitchexternal_i_request_src_dst_rdy_n : std_logic_vector(0 downto 0);
	signal mappedelementswitchexternal_i_response_src_dst_rdy_n : std_logic_vector(0 downto 0);
	signal mappedelementswitchexternal_i_request_dest_sop_n : std_logic_vector(0 downto 0);
	signal mappedelementswitchexternal_i_request_dest_eop_n : std_logic_vector(0 downto 0);
	signal mappedelementswitchexternal_i_request_dest_src_rdy_n : std_logic_vector(0 downto 0);
	signal mappedelementswitchexternal_i_request_dest_data : std_logic_vector(31 downto 0);
	signal mappedelementswitchexternal_i_response_dest_sop_n : std_logic_vector(0 downto 0);
	signal mappedelementswitchexternal_i_response_dest_eop_n : std_logic_vector(0 downto 0);
	signal mappedelementswitchexternal_i_response_dest_src_rdy_n : std_logic_vector(0 downto 0);
	signal mappedelementswitchexternal_i_response_dest_data : std_logic_vector(31 downto 0);
	signal mappedelementswitchexternal_i_request_src_select : std_logic_vector(15 downto 0);
	signal mappedelementswitchexternal_i_response_src_select : std_logic_vector(15 downto 0);
	signal mappedelementswitchexternal_i_request_dest_select : std_logic_vector(15 downto 0);
	signal mappedelementswitchexternal_i_response_dest_select : std_logic_vector(15 downto 0);
	signal mappedelementswitchexternal_i_request_src_sop_n1 : std_logic_vector(0 downto 0);
	signal muxsrc_ln273_mappedelementswitch1 : std_logic_vector(34 downto 0);
	signal cat_ln273_mappedelementswitch : std_logic_vector(34 downto 0);
	signal muxsrc_ln273_mappedelementswitch2_1 : std_logic_vector(34 downto 0);
	signal cat_ln273_mappedelementswitch1 : std_logic_vector(34 downto 0);
	signal muxsrc_ln273_mappedelementswitch3_1 : std_logic_vector(34 downto 0);
	signal cat_ln273_mappedelementswitch2 : std_logic_vector(34 downto 0);
	signal muxsrc_ln273_mappedelementswitch4_1 : std_logic_vector(34 downto 0);
	signal cat_ln273_mappedelementswitch3 : std_logic_vector(34 downto 0);
	signal muxsel_ln123_mappedelementswitch1 : std_logic_vector(15 downto 0);
	signal request_source_sel : std_logic_vector(15 downto 0);
	signal muxout_ln123_mappedelementswitch : std_logic_vector(34 downto 0);
	signal mappedelementswitchexternal_i_request_src_eop_n1 : std_logic_vector(0 downto 0);
	signal mappedelementswitchexternal_i_request_src_src_rdy_n1 : std_logic_vector(0 downto 0);
	signal mappedelementswitchexternal_i_request_src_data1 : std_logic_vector(31 downto 0);
	signal mappedelementswitchexternal_i_response_src_sop_n1 : std_logic_vector(0 downto 0);
	signal muxsrc_ln273_mappedelementswitch5_1 : std_logic_vector(34 downto 0);
	signal cat_ln273_mappedelementswitch4 : std_logic_vector(34 downto 0);
	signal muxsrc_ln273_mappedelementswitch6_1 : std_logic_vector(34 downto 0);
	signal cat_ln273_mappedelementswitch5 : std_logic_vector(34 downto 0);
	signal muxsrc_ln273_mappedelementswitch7_1 : std_logic_vector(34 downto 0);
	signal cat_ln273_mappedelementswitch6 : std_logic_vector(34 downto 0);
	signal muxsrc_ln273_mappedelementswitch8_1 : std_logic_vector(34 downto 0);
	signal cat_ln273_mappedelementswitch7 : std_logic_vector(34 downto 0);
	signal muxsel_ln125_mappedelementswitch1 : std_logic_vector(15 downto 0);
	signal response_source_sel : std_logic_vector(15 downto 0);
	signal muxout_ln125_mappedelementswitch : std_logic_vector(34 downto 0);
	signal mappedelementswitchexternal_i_response_src_eop_n1 : std_logic_vector(0 downto 0);
	signal mappedelementswitchexternal_i_response_src_src_rdy_n1 : std_logic_vector(0 downto 0);
	signal mappedelementswitchexternal_i_response_src_data1 : std_logic_vector(31 downto 0);
	signal mappedelementswitchexternal_i_request_dest_dst_rdy_n1 : std_logic_vector(0 downto 0);
	signal muxsel_ln128_mappedelementswitch1 : std_logic_vector(15 downto 0);
	signal request_dest_sel : std_logic_vector(15 downto 0);
	signal muxout_ln128_mappedelementswitch : std_logic_vector(0 downto 0);
	signal mappedelementswitchexternal_i_response_dest_dst_rdy_n1 : std_logic_vector(0 downto 0);
	signal muxsel_ln130_mappedelementswitch1 : std_logic_vector(15 downto 0);
	signal response_dest_sel : std_logic_vector(15 downto 0);
	signal muxout_ln130_mappedelementswitch : std_logic_vector(0 downto 0);
	signal mappedelementswitchexternal_i_ea_ready_n1 : std_logic_vector(15 downto 0);
	signal cat_ln133_mappedelementswitch : std_logic_vector(15 downto 0);
	signal muxsel_ln157_mappedelementswitch1 : std_logic_vector(1 downto 0);
	signal source_feedback_select_MappedRegisters : std_logic_vector(1 downto 0);
	signal cat_ln153_mappedelementswitch : std_logic_vector(1 downto 0);
	signal muxout_ln157_mappedelementswitch : std_logic_vector(0 downto 0);
	signal muxsrc_ln291_mappedelementswitch1 : std_logic_vector(34 downto 0);
	signal cat_ln291_mappedelementswitch : std_logic_vector(34 downto 0);
	signal muxsrc_ln291_mappedelementswitch2_1 : std_logic_vector(34 downto 0);
	signal cat_ln291_mappedelementswitch1 : std_logic_vector(34 downto 0);
	signal muxsel_ln192_mappedelementswitch1 : std_logic_vector(1 downto 0);
	signal dest_data_select_MappedRegisters : std_logic_vector(1 downto 0);
	signal cat_ln187_mappedelementswitch : std_logic_vector(1 downto 0);
	signal muxout_ln192_mappedelementswitch : std_logic_vector(34 downto 0);
	signal muxsel_ln157_mappedelementswitch2_1 : std_logic_vector(1 downto 0);
	signal source_feedback_select_MappedMemories : std_logic_vector(1 downto 0);
	signal cat_ln153_mappedelementswitch1 : std_logic_vector(1 downto 0);
	signal muxout_ln157_mappedelementswitch1 : std_logic_vector(0 downto 0);
	signal muxsrc_ln291_mappedelementswitch3_1 : std_logic_vector(34 downto 0);
	signal cat_ln291_mappedelementswitch2 : std_logic_vector(34 downto 0);
	signal muxsrc_ln291_mappedelementswitch4_1 : std_logic_vector(34 downto 0);
	signal cat_ln291_mappedelementswitch3 : std_logic_vector(34 downto 0);
	signal muxsel_ln192_mappedelementswitch2_1 : std_logic_vector(1 downto 0);
	signal dest_data_select_MappedMemories : std_logic_vector(1 downto 0);
	signal cat_ln187_mappedelementswitch1 : std_logic_vector(1 downto 0);
	signal muxout_ln192_mappedelementswitch1 : std_logic_vector(34 downto 0);
	signal muxsel_ln157_mappedelementswitch3_1 : std_logic_vector(1 downto 0);
	signal source_feedback_select_SignalForwarding : std_logic_vector(1 downto 0);
	signal cat_ln153_mappedelementswitch2 : std_logic_vector(1 downto 0);
	signal muxout_ln157_mappedelementswitch2 : std_logic_vector(0 downto 0);
	signal muxsrc_ln291_mappedelementswitch5_1 : std_logic_vector(34 downto 0);
	signal cat_ln291_mappedelementswitch4 : std_logic_vector(34 downto 0);
	signal muxsrc_ln291_mappedelementswitch6_1 : std_logic_vector(34 downto 0);
	signal cat_ln291_mappedelementswitch5 : std_logic_vector(34 downto 0);
	signal muxsel_ln192_mappedelementswitch3_1 : std_logic_vector(1 downto 0);
	signal dest_data_select_SignalForwarding : std_logic_vector(1 downto 0);
	signal cat_ln187_mappedelementswitch2 : std_logic_vector(1 downto 0);
	signal muxout_ln192_mappedelementswitch2 : std_logic_vector(34 downto 0);
	signal muxsel_ln157_mappedelementswitch4_1 : std_logic_vector(1 downto 0);
	signal source_feedback_select_PCIe : std_logic_vector(1 downto 0);
	signal cat_ln153_mappedelementswitch3 : std_logic_vector(1 downto 0);
	signal muxout_ln157_mappedelementswitch3 : std_logic_vector(0 downto 0);
	signal muxsrc_ln291_mappedelementswitch7_1 : std_logic_vector(34 downto 0);
	signal cat_ln291_mappedelementswitch6 : std_logic_vector(34 downto 0);
	signal muxsrc_ln291_mappedelementswitch8_1 : std_logic_vector(34 downto 0);
	signal cat_ln291_mappedelementswitch7 : std_logic_vector(34 downto 0);
	signal muxsel_ln192_mappedelementswitch4_1 : std_logic_vector(1 downto 0);
	signal dest_data_select_PCIe : std_logic_vector(1 downto 0);
	signal cat_ln187_mappedelementswitch3 : std_logic_vector(1 downto 0);
	signal muxout_ln192_mappedelementswitch3 : std_logic_vector(34 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	cat_ln273_mappedelementswitch<=(FROM_PCIe_DATA & bit_to_vec(FROM_PCIe_SRC_RDY_N) & bit_to_vec(FROM_PCIe_EOP_N) & bit_to_vec(FROM_PCIe_SOP_N));
	muxsrc_ln273_mappedelementswitch1 <= cat_ln273_mappedelementswitch;
	cat_ln273_mappedelementswitch1<=(FROM_MappedRegisters_DATA & bit_to_vec(FROM_MappedRegisters_SRC_RDY_N) & bit_to_vec(FROM_MappedRegisters_EOP_N) & bit_to_vec(FROM_MappedRegisters_SOP_N));
	muxsrc_ln273_mappedelementswitch2_1 <= cat_ln273_mappedelementswitch1;
	cat_ln273_mappedelementswitch2<=(FROM_MappedMemories_DATA & bit_to_vec(FROM_MappedMemories_SRC_RDY_N) & bit_to_vec(FROM_MappedMemories_EOP_N) & bit_to_vec(FROM_MappedMemories_SOP_N));
	muxsrc_ln273_mappedelementswitch3_1 <= cat_ln273_mappedelementswitch2;
	cat_ln273_mappedelementswitch3<=(FROM_SignalForwarding_DATA & bit_to_vec(FROM_SignalForwarding_SRC_RDY_N) & bit_to_vec(FROM_SignalForwarding_EOP_N) & bit_to_vec(FROM_SignalForwarding_SOP_N));
	muxsrc_ln273_mappedelementswitch4_1 <= cat_ln273_mappedelementswitch3;
	request_source_sel <= mappedelementswitchexternal_i_request_src_select;
	muxsel_ln123_mappedelementswitch1 <= request_source_sel;
	muxproc_ln123_mappedelementswitch : process(muxsrc_ln273_mappedelementswitch1, muxsrc_ln273_mappedelementswitch2_1, muxsrc_ln273_mappedelementswitch3_1, muxsrc_ln273_mappedelementswitch4_1, muxsel_ln123_mappedelementswitch1)
	begin
		case muxsel_ln123_mappedelementswitch1 is
			when "0000000000000001" => muxout_ln123_mappedelementswitch <= muxsrc_ln273_mappedelementswitch1;
			when "0000000000000010" => muxout_ln123_mappedelementswitch <= muxsrc_ln273_mappedelementswitch2_1;
			when "0000000000000100" => muxout_ln123_mappedelementswitch <= muxsrc_ln273_mappedelementswitch3_1;
			when "0000000000010000" => muxout_ln123_mappedelementswitch <= muxsrc_ln273_mappedelementswitch4_1;
			when others => muxout_ln123_mappedelementswitch <= "11111111111111111111111111111111111";
		end case;
	end process;
	mappedelementswitchexternal_i_request_src_sop_n1 <= slice(muxout_ln123_mappedelementswitch, 0, 1);
	mappedelementswitchexternal_i_request_src_eop_n1 <= slice(muxout_ln123_mappedelementswitch, 1, 1);
	mappedelementswitchexternal_i_request_src_src_rdy_n1 <= slice(muxout_ln123_mappedelementswitch, 2, 1);
	mappedelementswitchexternal_i_request_src_data1 <= slice(muxout_ln123_mappedelementswitch, 3, 32);
	cat_ln273_mappedelementswitch4<=(FROM_PCIe_DATA & bit_to_vec(FROM_PCIe_SRC_RDY_N) & bit_to_vec(FROM_PCIe_EOP_N) & bit_to_vec(FROM_PCIe_SOP_N));
	muxsrc_ln273_mappedelementswitch5_1 <= cat_ln273_mappedelementswitch4;
	cat_ln273_mappedelementswitch5<=(FROM_MappedRegisters_DATA & bit_to_vec(FROM_MappedRegisters_SRC_RDY_N) & bit_to_vec(FROM_MappedRegisters_EOP_N) & bit_to_vec(FROM_MappedRegisters_SOP_N));
	muxsrc_ln273_mappedelementswitch6_1 <= cat_ln273_mappedelementswitch5;
	cat_ln273_mappedelementswitch6<=(FROM_MappedMemories_DATA & bit_to_vec(FROM_MappedMemories_SRC_RDY_N) & bit_to_vec(FROM_MappedMemories_EOP_N) & bit_to_vec(FROM_MappedMemories_SOP_N));
	muxsrc_ln273_mappedelementswitch7_1 <= cat_ln273_mappedelementswitch6;
	cat_ln273_mappedelementswitch7<=(FROM_SignalForwarding_DATA & bit_to_vec(FROM_SignalForwarding_SRC_RDY_N) & bit_to_vec(FROM_SignalForwarding_EOP_N) & bit_to_vec(FROM_SignalForwarding_SOP_N));
	muxsrc_ln273_mappedelementswitch8_1 <= cat_ln273_mappedelementswitch7;
	response_source_sel <= mappedelementswitchexternal_i_response_src_select;
	muxsel_ln125_mappedelementswitch1 <= response_source_sel;
	muxproc_ln125_mappedelementswitch : process(muxsrc_ln273_mappedelementswitch5_1, muxsrc_ln273_mappedelementswitch6_1, muxsrc_ln273_mappedelementswitch7_1, muxsrc_ln273_mappedelementswitch8_1, muxsel_ln125_mappedelementswitch1)
	begin
		case muxsel_ln125_mappedelementswitch1 is
			when "0000000000000001" => muxout_ln125_mappedelementswitch <= muxsrc_ln273_mappedelementswitch5_1;
			when "0000000000000010" => muxout_ln125_mappedelementswitch <= muxsrc_ln273_mappedelementswitch6_1;
			when "0000000000000100" => muxout_ln125_mappedelementswitch <= muxsrc_ln273_mappedelementswitch7_1;
			when "0000000000010000" => muxout_ln125_mappedelementswitch <= muxsrc_ln273_mappedelementswitch8_1;
			when others => muxout_ln125_mappedelementswitch <= "11111111111111111111111111111111111";
		end case;
	end process;
	mappedelementswitchexternal_i_response_src_sop_n1 <= slice(muxout_ln125_mappedelementswitch, 0, 1);
	mappedelementswitchexternal_i_response_src_eop_n1 <= slice(muxout_ln125_mappedelementswitch, 1, 1);
	mappedelementswitchexternal_i_response_src_src_rdy_n1 <= slice(muxout_ln125_mappedelementswitch, 2, 1);
	mappedelementswitchexternal_i_response_src_data1 <= slice(muxout_ln125_mappedelementswitch, 3, 32);
	request_dest_sel <= mappedelementswitchexternal_i_request_dest_select;
	muxsel_ln128_mappedelementswitch1 <= request_dest_sel;
	muxproc_ln128_mappedelementswitch : process(TO_PCIe_DST_RDY_N, TO_MappedRegisters_DST_RDY_N, TO_MappedMemories_DST_RDY_N, TO_SignalForwarding_DST_RDY_N, muxsel_ln128_mappedelementswitch1)
	begin
		case muxsel_ln128_mappedelementswitch1 is
			when "0000000000000001" => muxout_ln128_mappedelementswitch <= bit_to_vec(TO_PCIe_DST_RDY_N);
			when "0000000000000010" => muxout_ln128_mappedelementswitch <= bit_to_vec(TO_MappedRegisters_DST_RDY_N);
			when "0000000000000100" => muxout_ln128_mappedelementswitch <= bit_to_vec(TO_MappedMemories_DST_RDY_N);
			when "0000000000010000" => muxout_ln128_mappedelementswitch <= bit_to_vec(TO_SignalForwarding_DST_RDY_N);
			when others => muxout_ln128_mappedelementswitch <= "1";
		end case;
	end process;
	mappedelementswitchexternal_i_request_dest_dst_rdy_n1 <= muxout_ln128_mappedelementswitch;
	response_dest_sel <= mappedelementswitchexternal_i_response_dest_select;
	muxsel_ln130_mappedelementswitch1 <= response_dest_sel;
	muxproc_ln130_mappedelementswitch : process(TO_PCIe_DST_RDY_N, TO_MappedRegisters_DST_RDY_N, TO_MappedMemories_DST_RDY_N, TO_SignalForwarding_DST_RDY_N, muxsel_ln130_mappedelementswitch1)
	begin
		case muxsel_ln130_mappedelementswitch1 is
			when "0000000000000001" => muxout_ln130_mappedelementswitch <= bit_to_vec(TO_PCIe_DST_RDY_N);
			when "0000000000000010" => muxout_ln130_mappedelementswitch <= bit_to_vec(TO_MappedRegisters_DST_RDY_N);
			when "0000000000000100" => muxout_ln130_mappedelementswitch <= bit_to_vec(TO_MappedMemories_DST_RDY_N);
			when "0000000000010000" => muxout_ln130_mappedelementswitch <= bit_to_vec(TO_SignalForwarding_DST_RDY_N);
			when others => muxout_ln130_mappedelementswitch <= "1";
		end case;
	end process;
	mappedelementswitchexternal_i_response_dest_dst_rdy_n1 <= muxout_ln130_mappedelementswitch;
	cat_ln133_mappedelementswitch<=("1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & bit_to_vec(FROM_SignalForwarding_SRC_RDY_N) & "1" & bit_to_vec(FROM_MappedMemories_SRC_RDY_N) & bit_to_vec(FROM_MappedRegisters_SRC_RDY_N) & bit_to_vec(FROM_PCIe_SRC_RDY_N));
	mappedelementswitchexternal_i_ea_ready_n1 <= cat_ln133_mappedelementswitch;
	cat_ln153_mappedelementswitch<=(slice(response_source_sel, 1, 1) & slice(request_source_sel, 1, 1));
	source_feedback_select_MappedRegisters <= cat_ln153_mappedelementswitch;
	muxsel_ln157_mappedelementswitch1 <= source_feedback_select_MappedRegisters;
	muxproc_ln157_mappedelementswitch : process(mappedelementswitchexternal_i_request_src_dst_rdy_n, mappedelementswitchexternal_i_response_src_dst_rdy_n, muxsel_ln157_mappedelementswitch1)
	begin
		case muxsel_ln157_mappedelementswitch1 is
			when "00" => muxout_ln157_mappedelementswitch <= "1";
			when "01" => muxout_ln157_mappedelementswitch <= mappedelementswitchexternal_i_request_src_dst_rdy_n;
			when "10" => muxout_ln157_mappedelementswitch <= mappedelementswitchexternal_i_response_src_dst_rdy_n;
			when "11" => muxout_ln157_mappedelementswitch <= "1";
			when others => 
			muxout_ln157_mappedelementswitch <= (others => 'X');
		end case;
	end process;
	cat_ln291_mappedelementswitch<=(mappedelementswitchexternal_i_request_dest_data & mappedelementswitchexternal_i_request_dest_src_rdy_n & mappedelementswitchexternal_i_request_dest_eop_n & mappedelementswitchexternal_i_request_dest_sop_n);
	muxsrc_ln291_mappedelementswitch1 <= cat_ln291_mappedelementswitch;
	cat_ln291_mappedelementswitch1<=(mappedelementswitchexternal_i_response_dest_data & mappedelementswitchexternal_i_response_dest_src_rdy_n & mappedelementswitchexternal_i_response_dest_eop_n & mappedelementswitchexternal_i_response_dest_sop_n);
	muxsrc_ln291_mappedelementswitch2_1 <= cat_ln291_mappedelementswitch1;
	cat_ln187_mappedelementswitch<=(slice(response_dest_sel, 1, 1) & slice(request_dest_sel, 1, 1));
	dest_data_select_MappedRegisters <= cat_ln187_mappedelementswitch;
	muxsel_ln192_mappedelementswitch1 <= dest_data_select_MappedRegisters;
	muxproc_ln192_mappedelementswitch : process(muxsrc_ln291_mappedelementswitch1, muxsrc_ln291_mappedelementswitch2_1, muxsel_ln192_mappedelementswitch1)
	begin
		case muxsel_ln192_mappedelementswitch1 is
			when "00" => muxout_ln192_mappedelementswitch <= "11111111111111111111111111111111111";
			when "01" => muxout_ln192_mappedelementswitch <= muxsrc_ln291_mappedelementswitch1;
			when "10" => muxout_ln192_mappedelementswitch <= muxsrc_ln291_mappedelementswitch2_1;
			when "11" => muxout_ln192_mappedelementswitch <= "11111111111111111111111111111111111";
			when others => 
			muxout_ln192_mappedelementswitch <= (others => 'X');
		end case;
	end process;
	cat_ln153_mappedelementswitch1<=(slice(response_source_sel, 2, 1) & slice(request_source_sel, 2, 1));
	source_feedback_select_MappedMemories <= cat_ln153_mappedelementswitch1;
	muxsel_ln157_mappedelementswitch2_1 <= source_feedback_select_MappedMemories;
	muxproc_ln157_mappedelementswitch1 : process(mappedelementswitchexternal_i_request_src_dst_rdy_n, mappedelementswitchexternal_i_response_src_dst_rdy_n, muxsel_ln157_mappedelementswitch2_1)
	begin
		case muxsel_ln157_mappedelementswitch2_1 is
			when "00" => muxout_ln157_mappedelementswitch1 <= "1";
			when "01" => muxout_ln157_mappedelementswitch1 <= mappedelementswitchexternal_i_request_src_dst_rdy_n;
			when "10" => muxout_ln157_mappedelementswitch1 <= mappedelementswitchexternal_i_response_src_dst_rdy_n;
			when "11" => muxout_ln157_mappedelementswitch1 <= "1";
			when others => 
			muxout_ln157_mappedelementswitch1 <= (others => 'X');
		end case;
	end process;
	cat_ln291_mappedelementswitch2<=(mappedelementswitchexternal_i_request_dest_data & mappedelementswitchexternal_i_request_dest_src_rdy_n & mappedelementswitchexternal_i_request_dest_eop_n & mappedelementswitchexternal_i_request_dest_sop_n);
	muxsrc_ln291_mappedelementswitch3_1 <= cat_ln291_mappedelementswitch2;
	cat_ln291_mappedelementswitch3<=(mappedelementswitchexternal_i_response_dest_data & mappedelementswitchexternal_i_response_dest_src_rdy_n & mappedelementswitchexternal_i_response_dest_eop_n & mappedelementswitchexternal_i_response_dest_sop_n);
	muxsrc_ln291_mappedelementswitch4_1 <= cat_ln291_mappedelementswitch3;
	cat_ln187_mappedelementswitch1<=(slice(response_dest_sel, 2, 1) & slice(request_dest_sel, 2, 1));
	dest_data_select_MappedMemories <= cat_ln187_mappedelementswitch1;
	muxsel_ln192_mappedelementswitch2_1 <= dest_data_select_MappedMemories;
	muxproc_ln192_mappedelementswitch1 : process(muxsrc_ln291_mappedelementswitch3_1, muxsrc_ln291_mappedelementswitch4_1, muxsel_ln192_mappedelementswitch2_1)
	begin
		case muxsel_ln192_mappedelementswitch2_1 is
			when "00" => muxout_ln192_mappedelementswitch1 <= "11111111111111111111111111111111111";
			when "01" => muxout_ln192_mappedelementswitch1 <= muxsrc_ln291_mappedelementswitch3_1;
			when "10" => muxout_ln192_mappedelementswitch1 <= muxsrc_ln291_mappedelementswitch4_1;
			when "11" => muxout_ln192_mappedelementswitch1 <= "11111111111111111111111111111111111";
			when others => 
			muxout_ln192_mappedelementswitch1 <= (others => 'X');
		end case;
	end process;
	cat_ln153_mappedelementswitch2<=(slice(response_source_sel, 4, 1) & slice(request_source_sel, 4, 1));
	source_feedback_select_SignalForwarding <= cat_ln153_mappedelementswitch2;
	muxsel_ln157_mappedelementswitch3_1 <= source_feedback_select_SignalForwarding;
	muxproc_ln157_mappedelementswitch2 : process(mappedelementswitchexternal_i_request_src_dst_rdy_n, mappedelementswitchexternal_i_response_src_dst_rdy_n, muxsel_ln157_mappedelementswitch3_1)
	begin
		case muxsel_ln157_mappedelementswitch3_1 is
			when "00" => muxout_ln157_mappedelementswitch2 <= "1";
			when "01" => muxout_ln157_mappedelementswitch2 <= mappedelementswitchexternal_i_request_src_dst_rdy_n;
			when "10" => muxout_ln157_mappedelementswitch2 <= mappedelementswitchexternal_i_response_src_dst_rdy_n;
			when "11" => muxout_ln157_mappedelementswitch2 <= "1";
			when others => 
			muxout_ln157_mappedelementswitch2 <= (others => 'X');
		end case;
	end process;
	cat_ln291_mappedelementswitch4<=(mappedelementswitchexternal_i_request_dest_data & mappedelementswitchexternal_i_request_dest_src_rdy_n & mappedelementswitchexternal_i_request_dest_eop_n & mappedelementswitchexternal_i_request_dest_sop_n);
	muxsrc_ln291_mappedelementswitch5_1 <= cat_ln291_mappedelementswitch4;
	cat_ln291_mappedelementswitch5<=(mappedelementswitchexternal_i_response_dest_data & mappedelementswitchexternal_i_response_dest_src_rdy_n & mappedelementswitchexternal_i_response_dest_eop_n & mappedelementswitchexternal_i_response_dest_sop_n);
	muxsrc_ln291_mappedelementswitch6_1 <= cat_ln291_mappedelementswitch5;
	cat_ln187_mappedelementswitch2<=(slice(response_dest_sel, 4, 1) & slice(request_dest_sel, 4, 1));
	dest_data_select_SignalForwarding <= cat_ln187_mappedelementswitch2;
	muxsel_ln192_mappedelementswitch3_1 <= dest_data_select_SignalForwarding;
	muxproc_ln192_mappedelementswitch2 : process(muxsrc_ln291_mappedelementswitch5_1, muxsrc_ln291_mappedelementswitch6_1, muxsel_ln192_mappedelementswitch3_1)
	begin
		case muxsel_ln192_mappedelementswitch3_1 is
			when "00" => muxout_ln192_mappedelementswitch2 <= "11111111111111111111111111111111111";
			when "01" => muxout_ln192_mappedelementswitch2 <= muxsrc_ln291_mappedelementswitch5_1;
			when "10" => muxout_ln192_mappedelementswitch2 <= muxsrc_ln291_mappedelementswitch6_1;
			when "11" => muxout_ln192_mappedelementswitch2 <= "11111111111111111111111111111111111";
			when others => 
			muxout_ln192_mappedelementswitch2 <= (others => 'X');
		end case;
	end process;
	cat_ln153_mappedelementswitch3<=(slice(response_source_sel, 0, 1) & slice(request_source_sel, 0, 1));
	source_feedback_select_PCIe <= cat_ln153_mappedelementswitch3;
	muxsel_ln157_mappedelementswitch4_1 <= source_feedback_select_PCIe;
	muxproc_ln157_mappedelementswitch3 : process(mappedelementswitchexternal_i_request_src_dst_rdy_n, mappedelementswitchexternal_i_response_src_dst_rdy_n, muxsel_ln157_mappedelementswitch4_1)
	begin
		case muxsel_ln157_mappedelementswitch4_1 is
			when "00" => muxout_ln157_mappedelementswitch3 <= "1";
			when "01" => muxout_ln157_mappedelementswitch3 <= mappedelementswitchexternal_i_request_src_dst_rdy_n;
			when "10" => muxout_ln157_mappedelementswitch3 <= mappedelementswitchexternal_i_response_src_dst_rdy_n;
			when "11" => muxout_ln157_mappedelementswitch3 <= "1";
			when others => 
			muxout_ln157_mappedelementswitch3 <= (others => 'X');
		end case;
	end process;
	cat_ln291_mappedelementswitch6<=(mappedelementswitchexternal_i_request_dest_data & mappedelementswitchexternal_i_request_dest_src_rdy_n & mappedelementswitchexternal_i_request_dest_eop_n & mappedelementswitchexternal_i_request_dest_sop_n);
	muxsrc_ln291_mappedelementswitch7_1 <= cat_ln291_mappedelementswitch6;
	cat_ln291_mappedelementswitch7<=(mappedelementswitchexternal_i_response_dest_data & mappedelementswitchexternal_i_response_dest_src_rdy_n & mappedelementswitchexternal_i_response_dest_eop_n & mappedelementswitchexternal_i_response_dest_sop_n);
	muxsrc_ln291_mappedelementswitch8_1 <= cat_ln291_mappedelementswitch7;
	cat_ln187_mappedelementswitch3<=(slice(response_dest_sel, 0, 1) & slice(request_dest_sel, 0, 1));
	dest_data_select_PCIe <= cat_ln187_mappedelementswitch3;
	muxsel_ln192_mappedelementswitch4_1 <= dest_data_select_PCIe;
	muxproc_ln192_mappedelementswitch3 : process(muxsrc_ln291_mappedelementswitch7_1, muxsrc_ln291_mappedelementswitch8_1, muxsel_ln192_mappedelementswitch4_1)
	begin
		case muxsel_ln192_mappedelementswitch4_1 is
			when "00" => muxout_ln192_mappedelementswitch3 <= "11111111111111111111111111111111111";
			when "01" => muxout_ln192_mappedelementswitch3 <= muxsrc_ln291_mappedelementswitch7_1;
			when "10" => muxout_ln192_mappedelementswitch3 <= muxsrc_ln291_mappedelementswitch8_1;
			when "11" => muxout_ln192_mappedelementswitch3 <= "11111111111111111111111111111111111";
			when others => 
			muxout_ln192_mappedelementswitch3 <= (others => 'X');
		end case;
	end process;
	clocking_clk_switch <= vec_to_bit(bit_to_vec(in_clocking_clk_switch));
	clocking_rst_switch <= vec_to_bit(bit_to_vec(in_clocking_rst_switch));
	FROM_MappedRegisters_DST_RDY_N <= vec_to_bit(muxout_ln157_mappedelementswitch);
	TO_MappedRegisters_SOP_N <= vec_to_bit(slice(muxout_ln192_mappedelementswitch, 0, 1));
	TO_MappedRegisters_EOP_N <= vec_to_bit(slice(muxout_ln192_mappedelementswitch, 1, 1));
	TO_MappedRegisters_SRC_RDY_N <= vec_to_bit(slice(muxout_ln192_mappedelementswitch, 2, 1));
	TO_MappedRegisters_DATA <= slice(muxout_ln192_mappedelementswitch, 3, 32);
	FROM_MappedMemories_DST_RDY_N <= vec_to_bit(muxout_ln157_mappedelementswitch1);
	TO_MappedMemories_SOP_N <= vec_to_bit(slice(muxout_ln192_mappedelementswitch1, 0, 1));
	TO_MappedMemories_EOP_N <= vec_to_bit(slice(muxout_ln192_mappedelementswitch1, 1, 1));
	TO_MappedMemories_SRC_RDY_N <= vec_to_bit(slice(muxout_ln192_mappedelementswitch1, 2, 1));
	TO_MappedMemories_DATA <= slice(muxout_ln192_mappedelementswitch1, 3, 32);
	FROM_SignalForwarding_DST_RDY_N <= vec_to_bit(muxout_ln157_mappedelementswitch2);
	TO_SignalForwarding_SOP_N <= vec_to_bit(slice(muxout_ln192_mappedelementswitch2, 0, 1));
	TO_SignalForwarding_EOP_N <= vec_to_bit(slice(muxout_ln192_mappedelementswitch2, 1, 1));
	TO_SignalForwarding_SRC_RDY_N <= vec_to_bit(slice(muxout_ln192_mappedelementswitch2, 2, 1));
	TO_SignalForwarding_DATA <= slice(muxout_ln192_mappedelementswitch2, 3, 32);
	FROM_PCIe_DST_RDY_N <= vec_to_bit(muxout_ln157_mappedelementswitch3);
	TO_PCIe_SOP_N <= vec_to_bit(slice(muxout_ln192_mappedelementswitch3, 0, 1));
	TO_PCIe_EOP_N <= vec_to_bit(slice(muxout_ln192_mappedelementswitch3, 1, 1));
	TO_PCIe_SRC_RDY_N <= vec_to_bit(slice(muxout_ln192_mappedelementswitch3, 2, 1));
	TO_PCIe_DATA <= slice(muxout_ln192_mappedelementswitch3, 3, 32);
	
	-- Register processes
	
	
	-- Entity instances
	
	MappedElementSwitchExternal_i : mapped_element_switch
		generic map (
			NUM_EAS => 16,
			NUM_EAS_WIDTH => 4
		)
		port map (
			REQUEST_SRC_DST_RDY_N => mappedelementswitchexternal_i_request_src_dst_rdy_n(0), -- 1 bits (out)
			RESPONSE_SRC_DST_RDY_N => mappedelementswitchexternal_i_response_src_dst_rdy_n(0), -- 1 bits (out)
			REQUEST_DEST_SOP_N => mappedelementswitchexternal_i_request_dest_sop_n(0), -- 1 bits (out)
			REQUEST_DEST_EOP_N => mappedelementswitchexternal_i_request_dest_eop_n(0), -- 1 bits (out)
			REQUEST_DEST_SRC_RDY_N => mappedelementswitchexternal_i_request_dest_src_rdy_n(0), -- 1 bits (out)
			REQUEST_DEST_DATA => mappedelementswitchexternal_i_request_dest_data, -- 32 bits (out)
			RESPONSE_DEST_SOP_N => mappedelementswitchexternal_i_response_dest_sop_n(0), -- 1 bits (out)
			RESPONSE_DEST_EOP_N => mappedelementswitchexternal_i_response_dest_eop_n(0), -- 1 bits (out)
			RESPONSE_DEST_SRC_RDY_N => mappedelementswitchexternal_i_response_dest_src_rdy_n(0), -- 1 bits (out)
			RESPONSE_DEST_DATA => mappedelementswitchexternal_i_response_dest_data, -- 32 bits (out)
			request_src_select => mappedelementswitchexternal_i_request_src_select, -- 16 bits (out)
			response_src_select => mappedelementswitchexternal_i_response_src_select, -- 16 bits (out)
			request_dest_select => mappedelementswitchexternal_i_request_dest_select, -- 16 bits (out)
			response_dest_select => mappedelementswitchexternal_i_response_dest_select, -- 16 bits (out)
			clk_switch => in_clocking_clk_switch, -- 1 bits (in)
			rst_switch => in_clocking_rst_switch, -- 1 bits (in)
			REQUEST_SRC_SOP_N => vec_to_bit(mappedelementswitchexternal_i_request_src_sop_n1), -- 1 bits (in)
			REQUEST_SRC_EOP_N => vec_to_bit(mappedelementswitchexternal_i_request_src_eop_n1), -- 1 bits (in)
			REQUEST_SRC_SRC_RDY_N => vec_to_bit(mappedelementswitchexternal_i_request_src_src_rdy_n1), -- 1 bits (in)
			REQUEST_SRC_DATA => mappedelementswitchexternal_i_request_src_data1, -- 32 bits (in)
			RESPONSE_SRC_SOP_N => vec_to_bit(mappedelementswitchexternal_i_response_src_sop_n1), -- 1 bits (in)
			RESPONSE_SRC_EOP_N => vec_to_bit(mappedelementswitchexternal_i_response_src_eop_n1), -- 1 bits (in)
			RESPONSE_SRC_SRC_RDY_N => vec_to_bit(mappedelementswitchexternal_i_response_src_src_rdy_n1), -- 1 bits (in)
			RESPONSE_SRC_DATA => mappedelementswitchexternal_i_response_src_data1, -- 32 bits (in)
			REQUEST_DEST_DST_RDY_N => vec_to_bit(mappedelementswitchexternal_i_request_dest_dst_rdy_n1), -- 1 bits (in)
			RESPONSE_DEST_DST_RDY_N => vec_to_bit(mappedelementswitchexternal_i_response_dest_dst_rdy_n1), -- 1 bits (in)
			EA_READY_N => mappedelementswitchexternal_i_ea_ready_n1 -- 16 bits (in)
		);
end MaxDC;
