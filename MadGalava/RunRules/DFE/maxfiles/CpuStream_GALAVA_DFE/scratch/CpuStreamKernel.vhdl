library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity CpuStreamKernel is
	port (
		clk: in std_logic;
		rst: in std_logic;
		ce: in std_logic;
		fill_level: in std_logic_vector(3 downto 0);
		flush_level: in std_logic_vector(3 downto 0);
		flushing: in std_logic;
		done: in std_logic;
		next_ce: in std_logic;
		next_fill_level: in std_logic_vector(3 downto 0);
		enable_ce_fill_0_0: in std_logic_vector(3 downto 0);
		enable_ce_fill_0_1: in std_logic;
		enable_ce_flush_0_2: in std_logic;
		mappedreg_io_data_w_force_disabled: in std_logic;
		mappedreg_io_child_0_force_disabled: in std_logic;
		child_0_data: in std_logic_vector(31 downto 0);
		mappedreg_io_child_1_force_disabled: in std_logic;
		child_1_data: in std_logic_vector(31 downto 0);
		mappedreg_io_child_2_force_disabled: in std_logic;
		child_2_data: in std_logic_vector(31 downto 0);
		mappedreg_io_child_3_force_disabled: in std_logic;
		child_3_data: in std_logic_vector(31 downto 0);
		mappedreg_run_cycle_count: in std_logic_vector(47 downto 0);
		child_0_en: out std_logic;
		child_1_en: out std_logic;
		child_2_en: out std_logic;
		child_3_en: out std_logic;
		data_w_output_control: out std_logic;
		data_w_data: out std_logic_vector(31 downto 0);
		data_w_valid: out std_logic;
		mappedreg_current_run_cycle_count: out std_logic_vector(47 downto 0);
		flush_start_output: out std_logic
	);
end CpuStreamKernel;

architecture MaxDC of CpuStreamKernel is
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
	component PhotonBitwiseNot_1 is
		port (
			a: in std_logic;
			result: out std_logic
		);
	end component;
	component dff_ce_syncsr is
		generic (
			INIT : bit
		);
		port (
			C: in std_logic;
			CE: in std_logic;
			D: in std_logic;
			R: in std_logic;
			S: in std_logic;
			Q: out std_logic
		);
	end component;
	component SRLDelay_1x4_reg2 is
		port (
			clk: in std_logic;
			ce: in std_logic;
			input: in std_logic;
			output: out std_logic
		);
	end component;
	component InputRegisterEntity2013_32 is
		port (
			clk: in std_logic;
			ce: in std_logic;
			en: in std_logic;
			rst: in std_logic;
			signal_in: in std_logic_vector(31 downto 0);
			signal_out: out std_logic_vector(31 downto 0)
		);
	end component;
	component MaxDCFixed_ADD_32_0_TWOSCOMPLEMENT_32_0_TWOSCOMPLEMENT_nogrowbits_pipe1 is
		port (
			clk: in std_logic;
			ce: in std_logic;
			a: in std_logic_vector(31 downto 0);
			b: in std_logic_vector(31 downto 0);
			result: out std_logic_vector(31 downto 0)
		);
	end component;
	component MaxDCFixedCast_32_n2_TWOSCOMPLEMENT_32_0_TWOSCOMPLEMENT_TONEAREVEN_pipe is
		port (
			clk: in std_logic;
			ce: in std_logic;
			i: in std_logic_vector(31 downto 0);
			o: out std_logic_vector(31 downto 0)
		);
	end component;
	component StateMachineEntity_CpuStreamKernel_Counter_48_NUMERIC_INCREMENTING_1_0_0_false_COUNT_LT_MAX_THEN_WRAP_49 is
		port (
			enable: in std_logic_vector(0 downto 0);
			max: in std_logic_vector(48 downto 0);
			clk: in std_logic;
			ce: in std_logic;
			rst: in std_logic;
			count: out std_logic_vector(47 downto 0);
			wrap: out std_logic_vector(0 downto 0)
		);
	end component;
	component OutputRegisterEntity_48with_reset is
		port (
			clk: in std_logic;
			signal_in: in std_logic_vector(47 downto 0);
			reg_ce: in std_logic;
			rst: in std_logic;
			signal_out: out std_logic_vector(47 downto 0)
		);
	end component;
	component MaxDCFixed_48_NodeEqInlined_pipe is
		port (
			clk: in std_logic;
			ce: in std_logic;
			a: in std_logic_vector(47 downto 0);
			b: in std_logic_vector(47 downto 0);
			result: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal node_id19_nodenot_result : std_logic_vector(0 downto 0);
	signal node_id1_nodenot_result : std_logic_vector(0 downto 0);
	signal node_id2_nodeinput_ce_pipereg_inst_0_q : std_logic_vector(0 downto 0);
	signal node_id2_nodeinput_has_filled_reg_0_q : std_logic_vector(0 downto 0);
	signal node_id2_nodeinput_ce_pipereg1_inst_0_q : std_logic_vector(0 downto 0);
	signal inst_ln61_alterasrldelay_output : std_logic_vector(0 downto 0);
	signal node_id2_nodeinput_child_0child_0_data0_reg_signal_out : std_logic_vector(31 downto 0);
	signal node_id4_nodenot_result : std_logic_vector(0 downto 0);
	signal node_id5_nodeinput_ce_pipereg_inst_0_q : std_logic_vector(0 downto 0);
	signal node_id5_nodeinput_has_filled_reg_0_q : std_logic_vector(0 downto 0);
	signal node_id5_nodeinput_ce_pipereg1_inst_0_q : std_logic_vector(0 downto 0);
	signal inst_ln61_alterasrldelay1_output : std_logic_vector(0 downto 0);
	signal node_id5_nodeinput_child_1child_1_data0_reg_signal_out : std_logic_vector(31 downto 0);
	signal node_id37_nodeadd_result : std_logic_vector(31 downto 0);
	signal node_id37_nodeadd_ce_pipereg_inst_0_q : std_logic_vector(0 downto 0);
	signal node_id7_nodenot_result : std_logic_vector(0 downto 0);
	signal node_id8_nodeinput_ce_pipereg_inst_0_q : std_logic_vector(0 downto 0);
	signal node_id8_nodeinput_has_filled_reg_0_q : std_logic_vector(0 downto 0);
	signal node_id8_nodeinput_ce_pipereg1_inst_0_q : std_logic_vector(0 downto 0);
	signal inst_ln61_alterasrldelay2_output : std_logic_vector(0 downto 0);
	signal node_id8_nodeinput_child_2child_2_data0_reg_signal_out : std_logic_vector(31 downto 0);
	signal node_id10_nodenot_result : std_logic_vector(0 downto 0);
	signal node_id11_nodeinput_ce_pipereg_inst_0_q : std_logic_vector(0 downto 0);
	signal node_id11_nodeinput_has_filled_reg_0_q : std_logic_vector(0 downto 0);
	signal node_id11_nodeinput_ce_pipereg1_inst_0_q : std_logic_vector(0 downto 0);
	signal inst_ln61_alterasrldelay3_output : std_logic_vector(0 downto 0);
	signal node_id11_nodeinput_child_3child_3_data0_reg_signal_out : std_logic_vector(31 downto 0);
	signal node_id38_nodeadd_result : std_logic_vector(31 downto 0);
	signal node_id38_nodeadd_ce_pipereg_inst_0_q : std_logic_vector(0 downto 0);
	signal node_id39_nodeadd_result : std_logic_vector(31 downto 0);
	signal node_id39_nodeadd_ce_pipereg_inst_0_q : std_logic_vector(0 downto 0);
	signal node_id35_nodecast_o : std_logic_vector(31 downto 0);
	signal node_id35_nodecast_ce_pipereg_inst_0_q : std_logic_vector(0 downto 0);
	signal node_id21_nodeoutput_ce_pipereg_inst_0_q : std_logic_vector(0 downto 0);
	signal node_id21_nodeoutput_has_filled_reg_0_q : std_logic_vector(0 downto 0);
	signal node_id24_nodecounter_count : std_logic_vector(47 downto 0);
	signal node_id24_nodecounter_wrap : std_logic_vector(0 downto 0);
	signal node_id24_nodecounter_ce_pipereg_inst_0_q : std_logic_vector(0 downto 0);
	signal node_id24_nodecounter_has_filled_reg_0_q : std_logic_vector(0 downto 0);
	signal node_id27_nodeoutputmappedreg_ce_pipereg_inst_0_q : std_logic_vector(0 downto 0);
	signal node_id27_nodeoutputmappedreg_has_filled_reg_0_q : std_logic_vector(0 downto 0);
	signal node_id27current_run_cycle_count_reg_signal_out : std_logic_vector(47 downto 0);
	signal node_id30_nodecounter_count : std_logic_vector(47 downto 0);
	signal node_id30_nodecounter_wrap : std_logic_vector(0 downto 0);
	signal node_id30_nodecounter_ce_pipereg_inst_0_q : std_logic_vector(0 downto 0);
	signal node_id30_nodecounter_has_filled_reg_0_q : std_logic_vector(0 downto 0);
	signal node_id36_nodeeqinlined_result : std_logic_vector(0 downto 0);
	signal node_id36_nodeeqinlined_ce_pipereg_inst_0_q : std_logic_vector(0 downto 0);
	signal node_id31_nodeflush_ce_pipereg_inst_0_q : std_logic_vector(0 downto 0);
	signal node_id31_nodeflush_has_filled_reg_0_q : std_logic_vector(0 downto 0);
	signal mappedreg_sigfoo_io_data_w_force_disabled : std_logic_vector(0 downto 0);
	signal mappedreg_sigfoo_io_child_0_force_disabled : std_logic_vector(0 downto 0);
	signal node_id2_nodeinput_has_filled_reg_0_d1 : std_logic_vector(0 downto 0);
	signal cat_ln313_controlsignalgeneratorphotonsm : std_logic_vector(0 downto 0);
	signal node_id2_nodeinput_ce_pipereg1_ce_pipereg_sig : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm : std_logic_vector(0 downto 0);
	signal inst_ln61_alterasrldelay_input1 : std_logic_vector(0 downto 0);
	signal node_id2_nodeinput_ce_pipereg_ce_pipereg_sig : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm1 : std_logic_vector(0 downto 0);
	signal has_filled_2 : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm2 : std_logic_vector(0 downto 0);
	signal has_flushed_2 : std_logic_vector(0 downto 0);
	signal mappedreg_sigfoo_io_child_1_force_disabled : std_logic_vector(0 downto 0);
	signal node_id5_nodeinput_has_filled_reg_0_d1 : std_logic_vector(0 downto 0);
	signal cat_ln313_controlsignalgeneratorphotonsm1 : std_logic_vector(0 downto 0);
	signal node_id5_nodeinput_ce_pipereg1_ce_pipereg_sig : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm3 : std_logic_vector(0 downto 0);
	signal inst_ln61_alterasrldelay1_input1 : std_logic_vector(0 downto 0);
	signal node_id5_nodeinput_ce_pipereg_ce_pipereg_sig : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm4 : std_logic_vector(0 downto 0);
	signal has_filled_5 : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm5 : std_logic_vector(0 downto 0);
	signal has_flushed_5 : std_logic_vector(0 downto 0);
	signal node_id37_nodeadd_ce_pipereg_ce_pipereg_sig : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm6 : std_logic_vector(0 downto 0);
	signal mappedreg_sigfoo_io_child_2_force_disabled : std_logic_vector(0 downto 0);
	signal node_id8_nodeinput_has_filled_reg_0_d1 : std_logic_vector(0 downto 0);
	signal cat_ln313_controlsignalgeneratorphotonsm2 : std_logic_vector(0 downto 0);
	signal node_id8_nodeinput_ce_pipereg1_ce_pipereg_sig : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm7 : std_logic_vector(0 downto 0);
	signal inst_ln61_alterasrldelay2_input1 : std_logic_vector(0 downto 0);
	signal node_id8_nodeinput_ce_pipereg_ce_pipereg_sig : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm8 : std_logic_vector(0 downto 0);
	signal has_filled_8 : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm9 : std_logic_vector(0 downto 0);
	signal has_flushed_8 : std_logic_vector(0 downto 0);
	signal mappedreg_sigfoo_io_child_3_force_disabled : std_logic_vector(0 downto 0);
	signal node_id11_nodeinput_has_filled_reg_0_d1 : std_logic_vector(0 downto 0);
	signal cat_ln313_controlsignalgeneratorphotonsm3 : std_logic_vector(0 downto 0);
	signal node_id11_nodeinput_ce_pipereg1_ce_pipereg_sig : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm10 : std_logic_vector(0 downto 0);
	signal inst_ln61_alterasrldelay3_input1 : std_logic_vector(0 downto 0);
	signal node_id11_nodeinput_ce_pipereg_ce_pipereg_sig : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm11 : std_logic_vector(0 downto 0);
	signal has_filled_11 : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm12 : std_logic_vector(0 downto 0);
	signal has_flushed_11 : std_logic_vector(0 downto 0);
	signal node_id38_nodeadd_ce_pipereg_ce_pipereg_sig : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm13 : std_logic_vector(0 downto 0);
	signal node_id39_nodeadd_ce_pipereg_ce_pipereg_sig : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm14 : std_logic_vector(0 downto 0);
	signal node_id35_nodecast_ce_pipereg_ce_pipereg_sig : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm15 : std_logic_vector(0 downto 0);
	signal node_id24_nodecounter_ce1 : std_logic_vector(0 downto 0);
	signal node_id24_nodecounter_ce_pipereg_ce_pipereg_sig : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm16 : std_logic_vector(0 downto 0);
	signal has_filled_24 : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm17 : std_logic_vector(0 downto 0);
	signal node_id24_nodecounter_has_filled_reg_0_d1 : std_logic_vector(0 downto 0);
	signal cat_ln313_controlsignalgeneratorphotonsm4 : std_logic_vector(0 downto 0);
	signal node_id27_nodeoutputmappedreg_has_filled_reg_0_d1 : std_logic_vector(0 downto 0);
	signal cat_ln313_controlsignalgeneratorphotonsm5 : std_logic_vector(0 downto 0);
	signal node_id27current_run_cycle_count_reg_reg_ce1 : std_logic_vector(0 downto 0);
	signal node_id27_nodeoutputmappedreg_ce_pipereg_ce_pipereg_sig : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm18 : std_logic_vector(0 downto 0);
	signal has_filled_27 : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm19 : std_logic_vector(0 downto 0);
	signal has_flushed_27 : std_logic_vector(0 downto 0);
	signal node_id30_nodecounter_ce1 : std_logic_vector(0 downto 0);
	signal node_id30_nodecounter_ce_pipereg_ce_pipereg_sig : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm20 : std_logic_vector(0 downto 0);
	signal has_filled_30 : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm21 : std_logic_vector(0 downto 0);
	signal node_id30_nodecounter_has_filled_reg_0_d1 : std_logic_vector(0 downto 0);
	signal cat_ln313_controlsignalgeneratorphotonsm6 : std_logic_vector(0 downto 0);
	signal node_id36_nodeeqinlined_ce_pipereg_ce_pipereg_sig : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm22 : std_logic_vector(0 downto 0);
	signal mappedreg_sigfoo_run_cycle_count : std_logic_vector(47 downto 0);
	signal node_id31_nodeflush_has_filled_reg_0_d1 : std_logic_vector(0 downto 0);
	signal cat_ln313_controlsignalgeneratorphotonsm7 : std_logic_vector(0 downto 0);
	signal node_id21_nodeoutput_ce_pipereg_ce_pipereg_sig : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm23 : std_logic_vector(0 downto 0);
	signal has_filled_21 : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm24 : std_logic_vector(0 downto 0);
	signal has_flushed_21 : std_logic_vector(0 downto 0);
	signal node_id31_nodeflush_ce_pipereg_ce_pipereg_sig : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm25 : std_logic_vector(0 downto 0);
	signal has_filled_31 : std_logic_vector(0 downto 0);
	signal cat_ln601_controlsignalgeneratorphotonsm26 : std_logic_vector(0 downto 0);
	
	-- Attribute type declarations
	
	attribute keep : boolean;
	attribute dont_merge : boolean;
	
	-- Attribute declarations
	
	attribute keep of mappedreg_sigfoo_io_data_w_force_disabled : signal is true;
	attribute keep of mappedreg_sigfoo_io_child_0_force_disabled : signal is true;
	attribute dont_merge of node_id2_nodeinput_ce_pipereg1_ce_pipereg_sig : signal is true;
	attribute dont_merge of node_id2_nodeinput_ce_pipereg_ce_pipereg_sig : signal is true;
	attribute keep of mappedreg_sigfoo_io_child_1_force_disabled : signal is true;
	attribute dont_merge of node_id5_nodeinput_ce_pipereg1_ce_pipereg_sig : signal is true;
	attribute dont_merge of node_id5_nodeinput_ce_pipereg_ce_pipereg_sig : signal is true;
	attribute dont_merge of node_id37_nodeadd_ce_pipereg_ce_pipereg_sig : signal is true;
	attribute keep of mappedreg_sigfoo_io_child_2_force_disabled : signal is true;
	attribute dont_merge of node_id8_nodeinput_ce_pipereg1_ce_pipereg_sig : signal is true;
	attribute dont_merge of node_id8_nodeinput_ce_pipereg_ce_pipereg_sig : signal is true;
	attribute keep of mappedreg_sigfoo_io_child_3_force_disabled : signal is true;
	attribute dont_merge of node_id11_nodeinput_ce_pipereg1_ce_pipereg_sig : signal is true;
	attribute dont_merge of node_id11_nodeinput_ce_pipereg_ce_pipereg_sig : signal is true;
	attribute dont_merge of node_id38_nodeadd_ce_pipereg_ce_pipereg_sig : signal is true;
	attribute dont_merge of node_id39_nodeadd_ce_pipereg_ce_pipereg_sig : signal is true;
	attribute dont_merge of node_id35_nodecast_ce_pipereg_ce_pipereg_sig : signal is true;
	attribute dont_merge of node_id24_nodecounter_ce_pipereg_ce_pipereg_sig : signal is true;
	attribute dont_merge of node_id27_nodeoutputmappedreg_ce_pipereg_ce_pipereg_sig : signal is true;
	attribute dont_merge of node_id30_nodecounter_ce_pipereg_ce_pipereg_sig : signal is true;
	attribute dont_merge of node_id36_nodeeqinlined_ce_pipereg_ce_pipereg_sig : signal is true;
	attribute keep of mappedreg_sigfoo_run_cycle_count : signal is true;
	attribute dont_merge of node_id21_nodeoutput_ce_pipereg_ce_pipereg_sig : signal is true;
	attribute dont_merge of node_id31_nodeflush_ce_pipereg_ce_pipereg_sig : signal is true;
begin
	
	-- Assignments
	
	mappedreg_sigfoo_io_data_w_force_disabled <= bit_to_vec(mappedreg_io_data_w_force_disabled);
	mappedreg_sigfoo_io_child_0_force_disabled <= bit_to_vec(mappedreg_io_child_0_force_disabled);
	cat_ln313_controlsignalgeneratorphotonsm<=slice(enable_ce_fill_0_0, 3, 1);
	node_id2_nodeinput_has_filled_reg_0_d1 <= cat_ln313_controlsignalgeneratorphotonsm;
	cat_ln601_controlsignalgeneratorphotonsm<=node_id2_nodeinput_ce_pipereg1_inst_0_q;
	node_id2_nodeinput_ce_pipereg1_ce_pipereg_sig <= cat_ln601_controlsignalgeneratorphotonsm;
	cat_ln601_controlsignalgeneratorphotonsm1<=node_id2_nodeinput_ce_pipereg_inst_0_q;
	node_id2_nodeinput_ce_pipereg_ce_pipereg_sig <= cat_ln601_controlsignalgeneratorphotonsm1;
	cat_ln601_controlsignalgeneratorphotonsm2<=node_id2_nodeinput_has_filled_reg_0_q;
	has_filled_2 <= cat_ln601_controlsignalgeneratorphotonsm2;
	has_flushed_2 <= bit_to_vec(flushing);
	inst_ln61_alterasrldelay_input1 <= (((node_id2_nodeinput_ce_pipereg_ce_pipereg_sig and has_filled_2 and (not has_flushed_2))) and node_id1_nodenot_result);
	mappedreg_sigfoo_io_child_1_force_disabled <= bit_to_vec(mappedreg_io_child_1_force_disabled);
	cat_ln313_controlsignalgeneratorphotonsm1<=slice(enable_ce_fill_0_0, 3, 1);
	node_id5_nodeinput_has_filled_reg_0_d1 <= cat_ln313_controlsignalgeneratorphotonsm1;
	cat_ln601_controlsignalgeneratorphotonsm3<=node_id5_nodeinput_ce_pipereg1_inst_0_q;
	node_id5_nodeinput_ce_pipereg1_ce_pipereg_sig <= cat_ln601_controlsignalgeneratorphotonsm3;
	cat_ln601_controlsignalgeneratorphotonsm4<=node_id5_nodeinput_ce_pipereg_inst_0_q;
	node_id5_nodeinput_ce_pipereg_ce_pipereg_sig <= cat_ln601_controlsignalgeneratorphotonsm4;
	cat_ln601_controlsignalgeneratorphotonsm5<=node_id5_nodeinput_has_filled_reg_0_q;
	has_filled_5 <= cat_ln601_controlsignalgeneratorphotonsm5;
	has_flushed_5 <= bit_to_vec(flushing);
	inst_ln61_alterasrldelay1_input1 <= (((node_id5_nodeinput_ce_pipereg_ce_pipereg_sig and has_filled_5 and (not has_flushed_5))) and node_id4_nodenot_result);
	cat_ln601_controlsignalgeneratorphotonsm6<=node_id37_nodeadd_ce_pipereg_inst_0_q;
	node_id37_nodeadd_ce_pipereg_ce_pipereg_sig <= cat_ln601_controlsignalgeneratorphotonsm6;
	mappedreg_sigfoo_io_child_2_force_disabled <= bit_to_vec(mappedreg_io_child_2_force_disabled);
	cat_ln313_controlsignalgeneratorphotonsm2<=slice(enable_ce_fill_0_0, 3, 1);
	node_id8_nodeinput_has_filled_reg_0_d1 <= cat_ln313_controlsignalgeneratorphotonsm2;
	cat_ln601_controlsignalgeneratorphotonsm7<=node_id8_nodeinput_ce_pipereg1_inst_0_q;
	node_id8_nodeinput_ce_pipereg1_ce_pipereg_sig <= cat_ln601_controlsignalgeneratorphotonsm7;
	cat_ln601_controlsignalgeneratorphotonsm8<=node_id8_nodeinput_ce_pipereg_inst_0_q;
	node_id8_nodeinput_ce_pipereg_ce_pipereg_sig <= cat_ln601_controlsignalgeneratorphotonsm8;
	cat_ln601_controlsignalgeneratorphotonsm9<=node_id8_nodeinput_has_filled_reg_0_q;
	has_filled_8 <= cat_ln601_controlsignalgeneratorphotonsm9;
	has_flushed_8 <= bit_to_vec(flushing);
	inst_ln61_alterasrldelay2_input1 <= (((node_id8_nodeinput_ce_pipereg_ce_pipereg_sig and has_filled_8 and (not has_flushed_8))) and node_id7_nodenot_result);
	mappedreg_sigfoo_io_child_3_force_disabled <= bit_to_vec(mappedreg_io_child_3_force_disabled);
	cat_ln313_controlsignalgeneratorphotonsm3<=slice(enable_ce_fill_0_0, 3, 1);
	node_id11_nodeinput_has_filled_reg_0_d1 <= cat_ln313_controlsignalgeneratorphotonsm3;
	cat_ln601_controlsignalgeneratorphotonsm10<=node_id11_nodeinput_ce_pipereg1_inst_0_q;
	node_id11_nodeinput_ce_pipereg1_ce_pipereg_sig <= cat_ln601_controlsignalgeneratorphotonsm10;
	cat_ln601_controlsignalgeneratorphotonsm11<=node_id11_nodeinput_ce_pipereg_inst_0_q;
	node_id11_nodeinput_ce_pipereg_ce_pipereg_sig <= cat_ln601_controlsignalgeneratorphotonsm11;
	cat_ln601_controlsignalgeneratorphotonsm12<=node_id11_nodeinput_has_filled_reg_0_q;
	has_filled_11 <= cat_ln601_controlsignalgeneratorphotonsm12;
	has_flushed_11 <= bit_to_vec(flushing);
	inst_ln61_alterasrldelay3_input1 <= (((node_id11_nodeinput_ce_pipereg_ce_pipereg_sig and has_filled_11 and (not has_flushed_11))) and node_id10_nodenot_result);
	cat_ln601_controlsignalgeneratorphotonsm13<=node_id38_nodeadd_ce_pipereg_inst_0_q;
	node_id38_nodeadd_ce_pipereg_ce_pipereg_sig <= cat_ln601_controlsignalgeneratorphotonsm13;
	cat_ln601_controlsignalgeneratorphotonsm14<=node_id39_nodeadd_ce_pipereg_inst_0_q;
	node_id39_nodeadd_ce_pipereg_ce_pipereg_sig <= cat_ln601_controlsignalgeneratorphotonsm14;
	cat_ln601_controlsignalgeneratorphotonsm15<=node_id35_nodecast_ce_pipereg_inst_0_q;
	node_id35_nodecast_ce_pipereg_ce_pipereg_sig <= cat_ln601_controlsignalgeneratorphotonsm15;
	cat_ln601_controlsignalgeneratorphotonsm16<=node_id24_nodecounter_ce_pipereg_inst_0_q;
	node_id24_nodecounter_ce_pipereg_ce_pipereg_sig <= cat_ln601_controlsignalgeneratorphotonsm16;
	cat_ln601_controlsignalgeneratorphotonsm17<=node_id24_nodecounter_has_filled_reg_0_q;
	has_filled_24 <= cat_ln601_controlsignalgeneratorphotonsm17;
	node_id24_nodecounter_ce1 <= (node_id24_nodecounter_ce_pipereg_ce_pipereg_sig and has_filled_24);
	cat_ln313_controlsignalgeneratorphotonsm4<=slice(enable_ce_fill_0_0, 2, 1);
	node_id24_nodecounter_has_filled_reg_0_d1 <= cat_ln313_controlsignalgeneratorphotonsm4;
	cat_ln313_controlsignalgeneratorphotonsm5<=slice(enable_ce_fill_0_0, 3, 1);
	node_id27_nodeoutputmappedreg_has_filled_reg_0_d1 <= cat_ln313_controlsignalgeneratorphotonsm5;
	cat_ln601_controlsignalgeneratorphotonsm18<=node_id27_nodeoutputmappedreg_ce_pipereg_inst_0_q;
	node_id27_nodeoutputmappedreg_ce_pipereg_ce_pipereg_sig <= cat_ln601_controlsignalgeneratorphotonsm18;
	cat_ln601_controlsignalgeneratorphotonsm19<=node_id27_nodeoutputmappedreg_has_filled_reg_0_q;
	has_filled_27 <= cat_ln601_controlsignalgeneratorphotonsm19;
	has_flushed_27 <= bit_to_vec(flushing);
	node_id27current_run_cycle_count_reg_reg_ce1 <= ((node_id27_nodeoutputmappedreg_ce_pipereg_ce_pipereg_sig and has_filled_27 and (not has_flushed_27)) and "1");
	cat_ln601_controlsignalgeneratorphotonsm20<=node_id30_nodecounter_ce_pipereg_inst_0_q;
	node_id30_nodecounter_ce_pipereg_ce_pipereg_sig <= cat_ln601_controlsignalgeneratorphotonsm20;
	cat_ln601_controlsignalgeneratorphotonsm21<=node_id30_nodecounter_has_filled_reg_0_q;
	has_filled_30 <= cat_ln601_controlsignalgeneratorphotonsm21;
	node_id30_nodecounter_ce1 <= (node_id30_nodecounter_ce_pipereg_ce_pipereg_sig and has_filled_30);
	cat_ln313_controlsignalgeneratorphotonsm6<=slice(enable_ce_fill_0_0, 0, 1);
	node_id30_nodecounter_has_filled_reg_0_d1 <= cat_ln313_controlsignalgeneratorphotonsm6;
	cat_ln601_controlsignalgeneratorphotonsm22<=node_id36_nodeeqinlined_ce_pipereg_inst_0_q;
	node_id36_nodeeqinlined_ce_pipereg_ce_pipereg_sig <= cat_ln601_controlsignalgeneratorphotonsm22;
	mappedreg_sigfoo_run_cycle_count <= mappedreg_run_cycle_count;
	cat_ln313_controlsignalgeneratorphotonsm7<=slice(enable_ce_fill_0_0, 1, 1);
	node_id31_nodeflush_has_filled_reg_0_d1 <= cat_ln313_controlsignalgeneratorphotonsm7;
	cat_ln601_controlsignalgeneratorphotonsm23<=node_id21_nodeoutput_ce_pipereg_inst_0_q;
	node_id21_nodeoutput_ce_pipereg_ce_pipereg_sig <= cat_ln601_controlsignalgeneratorphotonsm23;
	cat_ln601_controlsignalgeneratorphotonsm24<=node_id21_nodeoutput_has_filled_reg_0_q;
	has_filled_21 <= cat_ln601_controlsignalgeneratorphotonsm24;
	has_flushed_21 <= bit_to_vec(enable_ce_flush_0_2);
	cat_ln601_controlsignalgeneratorphotonsm25<=node_id31_nodeflush_ce_pipereg_inst_0_q;
	node_id31_nodeflush_ce_pipereg_ce_pipereg_sig <= cat_ln601_controlsignalgeneratorphotonsm25;
	cat_ln601_controlsignalgeneratorphotonsm26<=node_id31_nodeflush_has_filled_reg_0_q;
	has_filled_31 <= cat_ln601_controlsignalgeneratorphotonsm26;
	child_0_en <= vec_to_bit((((node_id2_nodeinput_ce_pipereg_ce_pipereg_sig and has_filled_2 and (not has_flushed_2))) and node_id1_nodenot_result));
	child_1_en <= vec_to_bit((((node_id5_nodeinput_ce_pipereg_ce_pipereg_sig and has_filled_5 and (not has_flushed_5))) and node_id4_nodenot_result));
	child_2_en <= vec_to_bit((((node_id8_nodeinput_ce_pipereg_ce_pipereg_sig and has_filled_8 and (not has_flushed_8))) and node_id7_nodenot_result));
	child_3_en <= vec_to_bit((((node_id11_nodeinput_ce_pipereg_ce_pipereg_sig and has_filled_11 and (not has_flushed_11))) and node_id10_nodenot_result));
	data_w_output_control <= vec_to_bit(node_id19_nodenot_result);
	data_w_data <= node_id35_nodecast_o;
	data_w_valid <= vec_to_bit(((node_id21_nodeoutput_ce_pipereg_ce_pipereg_sig and has_filled_21 and (not has_flushed_21)) and node_id19_nodenot_result));
	mappedreg_current_run_cycle_count <= node_id27current_run_cycle_count_reg_signal_out;
	flush_start_output <= vec_to_bit((node_id36_nodeeqinlined_result and (node_id31_nodeflush_ce_pipereg_ce_pipereg_sig and has_filled_31)));
	
	-- Register processes
	
	
	-- Entity instances
	
	node_id19_nodenot : PhotonBitwiseNot_1
		port map (
			result => node_id19_nodenot_result(0), -- 1 bits (out)
			a => vec_to_bit(mappedreg_sigfoo_io_data_w_force_disabled) -- 1 bits (in)
		);
	node_id1_nodenot : PhotonBitwiseNot_1
		port map (
			result => node_id1_nodenot_result(0), -- 1 bits (out)
			a => vec_to_bit(mappedreg_sigfoo_io_child_0_force_disabled) -- 1 bits (in)
		);
	node_id2_nodeinput_ce_pipereg_inst_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id2_nodeinput_ce_pipereg_inst_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => next_ce, -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	node_id2_NodeInput_has_filled_reg_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id2_nodeinput_has_filled_reg_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => vec_to_bit(node_id2_nodeinput_has_filled_reg_0_d1), -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	node_id2_nodeinput_ce_pipereg1_inst_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id2_nodeinput_ce_pipereg1_inst_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => next_ce, -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	inst_ln61_alterasrldelay : SRLDelay_1x4_reg2
		port map (
			output => inst_ln61_alterasrldelay_output(0), -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			ce => vec_to_bit(node_id2_nodeinput_ce_pipereg1_ce_pipereg_sig), -- 1 bits (in)
			input => vec_to_bit(inst_ln61_alterasrldelay_input1) -- 1 bits (in)
		);
	node_id2_nodeinput_child_0child_0_data0_reg : InputRegisterEntity2013_32
		port map (
			signal_out => node_id2_nodeinput_child_0child_0_data0_reg_signal_out, -- 32 bits (out)
			clk => clk, -- 1 bits (in)
			ce => vec_to_bit(node_id2_nodeinput_ce_pipereg1_ce_pipereg_sig), -- 1 bits (in)
			en => vec_to_bit(inst_ln61_alterasrldelay_output), -- 1 bits (in)
			rst => rst, -- 1 bits (in)
			signal_in => child_0_data -- 32 bits (in)
		);
	node_id4_nodenot : PhotonBitwiseNot_1
		port map (
			result => node_id4_nodenot_result(0), -- 1 bits (out)
			a => vec_to_bit(mappedreg_sigfoo_io_child_1_force_disabled) -- 1 bits (in)
		);
	node_id5_nodeinput_ce_pipereg_inst_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id5_nodeinput_ce_pipereg_inst_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => next_ce, -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	node_id5_NodeInput_has_filled_reg_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id5_nodeinput_has_filled_reg_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => vec_to_bit(node_id5_nodeinput_has_filled_reg_0_d1), -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	node_id5_nodeinput_ce_pipereg1_inst_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id5_nodeinput_ce_pipereg1_inst_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => next_ce, -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	inst_ln61_alterasrldelay1 : SRLDelay_1x4_reg2
		port map (
			output => inst_ln61_alterasrldelay1_output(0), -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			ce => vec_to_bit(node_id5_nodeinput_ce_pipereg1_ce_pipereg_sig), -- 1 bits (in)
			input => vec_to_bit(inst_ln61_alterasrldelay1_input1) -- 1 bits (in)
		);
	node_id5_nodeinput_child_1child_1_data0_reg : InputRegisterEntity2013_32
		port map (
			signal_out => node_id5_nodeinput_child_1child_1_data0_reg_signal_out, -- 32 bits (out)
			clk => clk, -- 1 bits (in)
			ce => vec_to_bit(node_id5_nodeinput_ce_pipereg1_ce_pipereg_sig), -- 1 bits (in)
			en => vec_to_bit(inst_ln61_alterasrldelay1_output), -- 1 bits (in)
			rst => rst, -- 1 bits (in)
			signal_in => child_1_data -- 32 bits (in)
		);
	node_id37_nodeadd : MaxDCFixed_ADD_32_0_TWOSCOMPLEMENT_32_0_TWOSCOMPLEMENT_nogrowbits_pipe1
		port map (
			result => node_id37_nodeadd_result, -- 32 bits (out)
			clk => clk, -- 1 bits (in)
			ce => vec_to_bit(node_id37_nodeadd_ce_pipereg_ce_pipereg_sig), -- 1 bits (in)
			a => node_id2_nodeinput_child_0child_0_data0_reg_signal_out, -- 32 bits (in)
			b => node_id5_nodeinput_child_1child_1_data0_reg_signal_out -- 32 bits (in)
		);
	node_id37_nodeadd_ce_pipereg_inst_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id37_nodeadd_ce_pipereg_inst_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => next_ce, -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	node_id7_nodenot : PhotonBitwiseNot_1
		port map (
			result => node_id7_nodenot_result(0), -- 1 bits (out)
			a => vec_to_bit(mappedreg_sigfoo_io_child_2_force_disabled) -- 1 bits (in)
		);
	node_id8_nodeinput_ce_pipereg_inst_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id8_nodeinput_ce_pipereg_inst_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => next_ce, -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	node_id8_NodeInput_has_filled_reg_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id8_nodeinput_has_filled_reg_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => vec_to_bit(node_id8_nodeinput_has_filled_reg_0_d1), -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	node_id8_nodeinput_ce_pipereg1_inst_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id8_nodeinput_ce_pipereg1_inst_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => next_ce, -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	inst_ln61_alterasrldelay2 : SRLDelay_1x4_reg2
		port map (
			output => inst_ln61_alterasrldelay2_output(0), -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			ce => vec_to_bit(node_id8_nodeinput_ce_pipereg1_ce_pipereg_sig), -- 1 bits (in)
			input => vec_to_bit(inst_ln61_alterasrldelay2_input1) -- 1 bits (in)
		);
	node_id8_nodeinput_child_2child_2_data0_reg : InputRegisterEntity2013_32
		port map (
			signal_out => node_id8_nodeinput_child_2child_2_data0_reg_signal_out, -- 32 bits (out)
			clk => clk, -- 1 bits (in)
			ce => vec_to_bit(node_id8_nodeinput_ce_pipereg1_ce_pipereg_sig), -- 1 bits (in)
			en => vec_to_bit(inst_ln61_alterasrldelay2_output), -- 1 bits (in)
			rst => rst, -- 1 bits (in)
			signal_in => child_2_data -- 32 bits (in)
		);
	node_id10_nodenot : PhotonBitwiseNot_1
		port map (
			result => node_id10_nodenot_result(0), -- 1 bits (out)
			a => vec_to_bit(mappedreg_sigfoo_io_child_3_force_disabled) -- 1 bits (in)
		);
	node_id11_nodeinput_ce_pipereg_inst_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id11_nodeinput_ce_pipereg_inst_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => next_ce, -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	node_id11_NodeInput_has_filled_reg_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id11_nodeinput_has_filled_reg_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => vec_to_bit(node_id11_nodeinput_has_filled_reg_0_d1), -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	node_id11_nodeinput_ce_pipereg1_inst_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id11_nodeinput_ce_pipereg1_inst_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => next_ce, -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	inst_ln61_alterasrldelay3 : SRLDelay_1x4_reg2
		port map (
			output => inst_ln61_alterasrldelay3_output(0), -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			ce => vec_to_bit(node_id11_nodeinput_ce_pipereg1_ce_pipereg_sig), -- 1 bits (in)
			input => vec_to_bit(inst_ln61_alterasrldelay3_input1) -- 1 bits (in)
		);
	node_id11_nodeinput_child_3child_3_data0_reg : InputRegisterEntity2013_32
		port map (
			signal_out => node_id11_nodeinput_child_3child_3_data0_reg_signal_out, -- 32 bits (out)
			clk => clk, -- 1 bits (in)
			ce => vec_to_bit(node_id11_nodeinput_ce_pipereg1_ce_pipereg_sig), -- 1 bits (in)
			en => vec_to_bit(inst_ln61_alterasrldelay3_output), -- 1 bits (in)
			rst => rst, -- 1 bits (in)
			signal_in => child_3_data -- 32 bits (in)
		);
	node_id38_nodeadd : MaxDCFixed_ADD_32_0_TWOSCOMPLEMENT_32_0_TWOSCOMPLEMENT_nogrowbits_pipe1
		port map (
			result => node_id38_nodeadd_result, -- 32 bits (out)
			clk => clk, -- 1 bits (in)
			ce => vec_to_bit(node_id38_nodeadd_ce_pipereg_ce_pipereg_sig), -- 1 bits (in)
			a => node_id8_nodeinput_child_2child_2_data0_reg_signal_out, -- 32 bits (in)
			b => node_id11_nodeinput_child_3child_3_data0_reg_signal_out -- 32 bits (in)
		);
	node_id38_nodeadd_ce_pipereg_inst_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id38_nodeadd_ce_pipereg_inst_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => next_ce, -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	node_id39_nodeadd : MaxDCFixed_ADD_32_0_TWOSCOMPLEMENT_32_0_TWOSCOMPLEMENT_nogrowbits_pipe1
		port map (
			result => node_id39_nodeadd_result, -- 32 bits (out)
			clk => clk, -- 1 bits (in)
			ce => vec_to_bit(node_id39_nodeadd_ce_pipereg_ce_pipereg_sig), -- 1 bits (in)
			a => node_id37_nodeadd_result, -- 32 bits (in)
			b => node_id38_nodeadd_result -- 32 bits (in)
		);
	node_id39_nodeadd_ce_pipereg_inst_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id39_nodeadd_ce_pipereg_inst_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => next_ce, -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	node_id35_nodecast : MaxDCFixedCast_32_n2_TWOSCOMPLEMENT_32_0_TWOSCOMPLEMENT_TONEAREVEN_pipe
		port map (
			o => node_id35_nodecast_o, -- 32 bits (out)
			clk => clk, -- 1 bits (in)
			ce => vec_to_bit(node_id35_nodecast_ce_pipereg_ce_pipereg_sig), -- 1 bits (in)
			i => node_id39_nodeadd_result -- 32 bits (in)
		);
	node_id35_nodecast_ce_pipereg_inst_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id35_nodecast_ce_pipereg_inst_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => next_ce, -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	node_id21_nodeoutput_ce_pipereg_inst_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id21_nodeoutput_ce_pipereg_inst_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => next_ce, -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	node_id21_NodeOutput_has_filled_reg_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id21_nodeoutput_has_filled_reg_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => enable_ce_fill_0_1, -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	node_id24_nodecounter : StateMachineEntity_CpuStreamKernel_Counter_48_NUMERIC_INCREMENTING_1_0_0_false_COUNT_LT_MAX_THEN_WRAP_49
		port map (
			count => node_id24_nodecounter_count, -- 48 bits (out)
			wrap => node_id24_nodecounter_wrap, -- 1 bits (out)
			enable => "1", -- 1 bits (in)
			max => "1000000000000000000000000000000000000000000000000", -- 49 bits (in)
			clk => clk, -- 1 bits (in)
			ce => vec_to_bit(node_id24_nodecounter_ce1), -- 1 bits (in)
			rst => rst -- 1 bits (in)
		);
	node_id24_nodecounter_ce_pipereg_inst_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id24_nodecounter_ce_pipereg_inst_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => next_ce, -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	node_id24_NodeCounter_has_filled_reg_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id24_nodecounter_has_filled_reg_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => vec_to_bit(node_id24_nodecounter_has_filled_reg_0_d1), -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	node_id27_nodeoutputmappedreg_ce_pipereg_inst_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id27_nodeoutputmappedreg_ce_pipereg_inst_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => next_ce, -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	node_id27_NodeOutputMappedReg_has_filled_reg_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id27_nodeoutputmappedreg_has_filled_reg_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => vec_to_bit(node_id27_nodeoutputmappedreg_has_filled_reg_0_d1), -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	node_id27current_run_cycle_count_reg : OutputRegisterEntity_48with_reset
		port map (
			signal_out => node_id27current_run_cycle_count_reg_signal_out, -- 48 bits (out)
			clk => clk, -- 1 bits (in)
			signal_in => node_id24_nodecounter_count, -- 48 bits (in)
			reg_ce => vec_to_bit(node_id27current_run_cycle_count_reg_reg_ce1), -- 1 bits (in)
			rst => rst -- 1 bits (in)
		);
	node_id30_nodecounter : StateMachineEntity_CpuStreamKernel_Counter_48_NUMERIC_INCREMENTING_1_0_0_false_COUNT_LT_MAX_THEN_WRAP_49
		port map (
			count => node_id30_nodecounter_count, -- 48 bits (out)
			wrap => node_id30_nodecounter_wrap, -- 1 bits (out)
			enable => "1", -- 1 bits (in)
			max => "1000000000000000000000000000000000000000000000000", -- 49 bits (in)
			clk => clk, -- 1 bits (in)
			ce => vec_to_bit(node_id30_nodecounter_ce1), -- 1 bits (in)
			rst => rst -- 1 bits (in)
		);
	node_id30_nodecounter_ce_pipereg_inst_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id30_nodecounter_ce_pipereg_inst_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => next_ce, -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	node_id30_NodeCounter_has_filled_reg_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id30_nodecounter_has_filled_reg_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => vec_to_bit(node_id30_nodecounter_has_filled_reg_0_d1), -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	node_id36_nodeeqinlined : MaxDCFixed_48_NodeEqInlined_pipe
		port map (
			result => node_id36_nodeeqinlined_result(0), -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			ce => vec_to_bit(node_id36_nodeeqinlined_ce_pipereg_ce_pipereg_sig), -- 1 bits (in)
			a => node_id30_nodecounter_count, -- 48 bits (in)
			b => mappedreg_sigfoo_run_cycle_count -- 48 bits (in)
		);
	node_id36_nodeeqinlined_ce_pipereg_inst_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id36_nodeeqinlined_ce_pipereg_inst_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => next_ce, -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	node_id31_nodeflush_ce_pipereg_inst_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id31_nodeflush_ce_pipereg_inst_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => next_ce, -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	node_id31_NodeFlush_has_filled_reg_0 : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => node_id31_nodeflush_has_filled_reg_0_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => vec_to_bit(node_id31_nodeflush_has_filled_reg_0_d1), -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
end MaxDC;
