library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity CpuStreamKernel_streamwrapper is
	port (
		clk: in std_logic;
		rst: in std_logic;
		child_0_empty: in std_logic;
		child_0_done: in std_logic;
		child_0_almost_empty: in std_logic;
		child_0_data: in std_logic_vector(31 downto 0);
		child_1_empty: in std_logic;
		child_1_done: in std_logic;
		child_1_almost_empty: in std_logic;
		child_1_data: in std_logic_vector(31 downto 0);
		child_2_empty: in std_logic;
		child_2_done: in std_logic;
		child_2_almost_empty: in std_logic;
		child_2_data: in std_logic_vector(31 downto 0);
		child_3_empty: in std_logic;
		child_3_done: in std_logic;
		child_3_almost_empty: in std_logic;
		child_3_data: in std_logic_vector(31 downto 0);
		data_w_stall: in std_logic;
		register_clk: in std_logic;
		register_in: in std_logic_vector(7 downto 0);
		register_rotate: in std_logic;
		register_stop: in std_logic;
		register_switch: in std_logic;
		child_0_read: out std_logic;
		child_1_read: out std_logic;
		child_2_read: out std_logic;
		child_3_read: out std_logic;
		data_w_valid: out std_logic;
		data_w_done: out std_logic;
		data_w_data: out std_logic_vector(31 downto 0);
		register_out: out std_logic_vector(7 downto 0);
		active: out std_logic
	);
end CpuStreamKernel_streamwrapper;

architecture MaxDC of CpuStreamKernel_streamwrapper is
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
	component CpuStreamKernel is
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
	end component;
	component MappedRegBlock_e8cba5601e8a42a294dafc2aba54dbf4 is
		port (
			register_clk: in std_logic;
			register_in: in std_logic_vector(7 downto 0);
			register_rotate: in std_logic;
			register_stop: in std_logic;
			register_switch: in std_logic;
			reg_dbg_stall_vector: in std_logic;
			reg_current_run_cycle_count: in std_logic_vector(47 downto 0);
			reg_dbg_ctld_empty: in std_logic_vector(3 downto 0);
			reg_dbg_ctld_almost_empty: in std_logic_vector(3 downto 0);
			reg_dbg_ctld_done: in std_logic_vector(3 downto 0);
			reg_dbg_ctld_read: in std_logic_vector(3 downto 0);
			reg_dbg_ctld_request: in std_logic_vector(3 downto 0);
			reg_dbg_flush_start: in std_logic;
			reg_dbg_full_level: in std_logic_vector(3 downto 0);
			reg_dbg_flush_start_level: in std_logic_vector(3 downto 0);
			reg_dbg_done_out: in std_logic;
			reg_dbg_flushing: in std_logic;
			reg_dbg_fill_level: in std_logic_vector(3 downto 0);
			reg_dbg_flush_level: in std_logic_vector(3 downto 0);
			reg_dbg_ctld_read_pipe_dbg: in std_logic_vector(11 downto 0);
			reg_dbg_out_valid: in std_logic;
			reg_dbg_out_stall: in std_logic;
			register_out: out std_logic_vector(7 downto 0);
			reg_io_data_w_force_disabled: out std_logic;
			reg_io_child_0_force_disabled: out std_logic;
			reg_io_child_1_force_disabled: out std_logic;
			reg_io_child_2_force_disabled: out std_logic;
			reg_io_child_3_force_disabled: out std_logic;
			reg_run_cycle_count: out std_logic_vector(47 downto 0)
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
	component dff_ce_syncsr_ne is
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
	component PhotonDesignControl is
		generic (
			STREAM_LEVEL_WIDTH : integer;
			CTL_PIPELINING : integer;
			CTL_PIPELINING_BITS : integer;
			CTL_REPLICATION_PHASE0_NEXT_CE : integer;
			CTL_REPLICATION_PHASE1_NEXT_CE : integer;
			NUM_INPUTS : integer;
			DESIGN_NAME : string;
			VERBOSE : boolean;
			RESET_CYCLE_COUNTER_WIDTH : integer
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			pcc_start: in std_logic;
			mapped_reg_stop: in std_logic;
			ctld_empty: in std_logic_vector(NUM_INPUTS - 1 downto 0);
			ctld_almost_empty: in std_logic_vector(NUM_INPUTS - 1 downto 0);
			ctld_done: in std_logic_vector(NUM_INPUTS - 1 downto 0);
			stall: in std_logic;
			full_level: in std_logic_vector(STREAM_LEVEL_WIDTH - 1 downto 0);
			flush_start_level: in std_logic_vector(STREAM_LEVEL_WIDTH - 1 downto 0);
			ctld_request: in std_logic_vector(NUM_INPUTS - 1 downto 0);
			flush_start: in std_logic;
			pcc_finished: out std_logic;
			pcc_rst: out std_logic;
			ctld_read: out std_logic_vector(NUM_INPUTS - 1 downto 0);
			done_out: out std_logic;
			stream_ce: out std_logic;
			flushing: out std_logic;
			fill_level: out std_logic_vector(STREAM_LEVEL_WIDTH - 1 downto 0);
			flush_level: out std_logic_vector(STREAM_LEVEL_WIDTH - 1 downto 0);
			next_ce: out std_logic_vector(CTL_REPLICATION_PHASE0_NEXT_CE - 1 downto 0);
			next_ce_phase1: out std_logic_vector(CTL_REPLICATION_PHASE1_NEXT_CE - 1 downto 0);
			ctld_read_pipe_dbg: out std_logic_vector(NUM_INPUTS * (1 + CTL_PIPELINING) - 1 downto 0);
			next_fill_level: out std_logic_vector(STREAM_LEVEL_WIDTH - 1 downto 0);
			next_flush_level: out std_logic_vector(STREAM_LEVEL_WIDTH - 1 downto 0);
			next_flushing: out std_logic;
			next_done_out: out std_logic
		);
	end component;
	component FillLevelCounter_0 is
		port (
			clk: in std_logic;
			rst: in std_logic;
			ce: in std_logic;
			next_ce: in std_logic;
			target_level: in std_logic_vector(3 downto 0);
			flushing: in std_logic;
			flush_start_level: in std_logic_vector(3 downto 0);
			enable: out std_logic_vector(3 downto 0)
		);
	end component;
	component FillLevelCounter_1 is
		port (
			clk: in std_logic;
			rst: in std_logic;
			ce: in std_logic;
			next_ce: in std_logic;
			target_level: in std_logic_vector(3 downto 0);
			flushing: in std_logic;
			flush_start_level: in std_logic_vector(3 downto 0);
			enable: out std_logic
		);
	end component;
	component FlushLevelCounter_2 is
		port (
			clk: in std_logic;
			rst: in std_logic;
			ce: in std_logic;
			next_ce: in std_logic;
			target_level: in std_logic_vector(3 downto 0);
			flushing: in std_logic;
			flush_start_level: in std_logic_vector(3 downto 0);
			enable: out std_logic
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
	
	-- Signal declarations
	
	signal cpustreamkernel_core_child_0_en : std_logic_vector(0 downto 0);
	signal cpustreamkernel_core_child_1_en : std_logic_vector(0 downto 0);
	signal cpustreamkernel_core_child_2_en : std_logic_vector(0 downto 0);
	signal cpustreamkernel_core_child_3_en : std_logic_vector(0 downto 0);
	signal cpustreamkernel_core_data_w_output_control : std_logic_vector(0 downto 0);
	signal cpustreamkernel_core_data_w_data : std_logic_vector(31 downto 0);
	signal cpustreamkernel_core_data_w_valid : std_logic_vector(0 downto 0);
	signal cpustreamkernel_core_mappedreg_current_run_cycle_count : std_logic_vector(47 downto 0);
	signal cpustreamkernel_core_flush_start_output : std_logic_vector(0 downto 0);
	signal mapped_reg_block_register_out : std_logic_vector(7 downto 0);
	signal mapped_reg_block_reg_io_data_w_force_disabled : std_logic_vector(0 downto 0);
	signal mapped_reg_block_reg_io_child_0_force_disabled : std_logic_vector(0 downto 0);
	signal mapped_reg_block_reg_io_child_1_force_disabled : std_logic_vector(0 downto 0);
	signal mapped_reg_block_reg_io_child_2_force_disabled : std_logic_vector(0 downto 0);
	signal mapped_reg_block_reg_io_child_3_force_disabled : std_logic_vector(0 downto 0);
	signal mapped_reg_block_reg_run_cycle_count : std_logic_vector(47 downto 0);
	signal inst_ln14_alteraflipflops_q : std_logic_vector(0 downto 0);
	signal inst_ln44_alteraflipflops_q : std_logic_vector(0 downto 0);
	signal control_sm_pcc_finished : std_logic_vector(0 downto 0);
	signal control_sm_pcc_rst : std_logic_vector(0 downto 0);
	signal control_sm_ctld_read : std_logic_vector(3 downto 0);
	signal control_sm_done_out : std_logic_vector(0 downto 0);
	signal control_sm_stream_ce : std_logic_vector(0 downto 0);
	signal control_sm_flushing : std_logic_vector(0 downto 0);
	signal control_sm_fill_level : std_logic_vector(3 downto 0);
	signal control_sm_flush_level : std_logic_vector(3 downto 0);
	signal control_sm_next_ce : std_logic_vector(0 downto 0);
	signal control_sm_next_ce_phase1 : std_logic_vector(0 downto 0);
	signal control_sm_ctld_read_pipe_dbg : std_logic_vector(11 downto 0);
	signal control_sm_next_fill_level : std_logic_vector(3 downto 0);
	signal control_sm_next_flush_level : std_logic_vector(3 downto 0);
	signal control_sm_next_flushing : std_logic_vector(0 downto 0);
	signal control_sm_next_done_out : std_logic_vector(0 downto 0);
	signal ce_fill_0_0_pdc0_enable : std_logic_vector(3 downto 0);
	signal ce_fill_0_1_pdc0_enable : std_logic_vector(0 downto 0);
	signal ce_flush_0_2_pdc0_enable : std_logic_vector(0 downto 0);
	signal inst_ln12_inputsynchronisedsynchroniser_dat_o : std_logic_vector(0 downto 0);
	signal cpustreamkernel_core_rst1 : std_logic_vector(0 downto 0);
	signal sig : std_logic_vector(0 downto 0);
	signal cat_ln239_photonstreamingblockadapter : std_logic_vector(0 downto 0);
	signal cpustreamkernel_core_enable_ce_fill_0_0_1 : std_logic_vector(3 downto 0);
	signal cat_ln1284_photonstreamingblockadapterwithsm : std_logic_vector(3 downto 0);
	signal cpustreamkernel_core_enable_ce_fill_0_1_1 : std_logic_vector(0 downto 0);
	signal cat_ln1284_photonstreamingblockadapterwithsm1 : std_logic_vector(0 downto 0);
	signal cpustreamkernel_core_enable_ce_flush_0_2_1 : std_logic_vector(0 downto 0);
	signal cat_ln1284_photonstreamingblockadapterwithsm2 : std_logic_vector(0 downto 0);
	signal io_data_w_force_disabled_int : std_logic_vector(0 downto 0);
	signal io_child_0_force_disabled_int : std_logic_vector(0 downto 0);
	signal io_child_1_force_disabled_int : std_logic_vector(0 downto 0);
	signal io_child_2_force_disabled_int : std_logic_vector(0 downto 0);
	signal io_child_3_force_disabled_int : std_logic_vector(0 downto 0);
	signal run_cycle_count_int : std_logic_vector(47 downto 0);
	signal mapped_reg_block_reg_dbg_stall_vector1 : std_logic_vector(0 downto 0);
	signal node_id21_NodeOutput_stall_in_pipe_data_w : std_logic_vector(0 downto 0) := "0";
	signal reg_ln270_photonstreamingblockadapter : std_logic_vector(0 downto 0) := "0";
	signal pcc_rst : std_logic_vector(0 downto 0);
	signal cat_ln711_photonstreamingblockadapterwithsm : std_logic_vector(0 downto 0);
	signal current_run_cycle_count_int : std_logic_vector(47 downto 0);
	signal dbg_ctld_empty_int : std_logic_vector(3 downto 0);
	signal cat_ln376_photonstreamingblockadapterwithsm : std_logic_vector(3 downto 0);
	signal dbg_ctld_almost_empty_int : std_logic_vector(3 downto 0);
	signal cat_ln377_photonstreamingblockadapterwithsm : std_logic_vector(3 downto 0);
	signal dbg_ctld_done_int : std_logic_vector(3 downto 0);
	signal dbg_ctld_read_int : std_logic_vector(3 downto 0);
	signal dbg_ctld_request_int : std_logic_vector(3 downto 0);
	signal cat_ln379_photonstreamingblockadapterwithsm : std_logic_vector(3 downto 0);
	signal dbg_flush_start_int : std_logic_vector(0 downto 0);
	signal dbg_full_level_int : std_logic_vector(3 downto 0);
	signal dbg_flush_start_level_int : std_logic_vector(3 downto 0);
	signal dbg_done_out_int : std_logic_vector(0 downto 0);
	signal dbg_flushing_int : std_logic_vector(0 downto 0);
	signal dbg_fill_level_int : std_logic_vector(3 downto 0);
	signal dbg_flush_level_int : std_logic_vector(3 downto 0);
	signal dbg_ctld_read_pipe_dbg_int : std_logic_vector(11 downto 0);
	signal dbg_out_valid_int : std_logic_vector(0 downto 0);
	signal node_id21_NodeOutput_valid_pipe_data_w : std_logic_vector(0 downto 0) := "0";
	signal cat_ln710_photonstreamingblockadapterwithsm : std_logic_vector(0 downto 0);
	signal dbg_out_stall_int : std_logic_vector(0 downto 0);
	signal inst_ln14_alteraflipflops_d1 : std_logic_vector(0 downto 0);
	signal inst_ln44_alteraflipflops_d1 : std_logic_vector(0 downto 0);
	signal control_sm_mapped_reg_stop1 : std_logic_vector(0 downto 0);
	signal control_sm_ctld_empty1 : std_logic_vector(3 downto 0);
	signal control_sm_ctld_almost_empty1 : std_logic_vector(3 downto 0);
	signal control_sm_stall1 : std_logic_vector(0 downto 0);
	signal control_sm_ctld_request1 : std_logic_vector(3 downto 0);
	signal ce_fill_0_0_pdc0_rst1 : std_logic_vector(0 downto 0);
	signal sig2 : std_logic_vector(3 downto 0);
	signal ce_fill_0_1_pdc0_rst1 : std_logic_vector(0 downto 0);
	signal ce_flush_0_2_pdc0_rst1 : std_logic_vector(0 downto 0);
	signal node_id21_NodeOutput_done_out_pipe_data_w : std_logic_vector(0 downto 0) := "0";
	signal node_id21_NodeOutput_outpipereg_data_w_data : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal reg_ln339_photonstreamingblockadapterwithsm : std_logic_vector(0 downto 0) := "0";
	
	-- Attribute type declarations
	
	attribute dont_merge : boolean;
	
	-- Attribute declarations
	
	attribute dont_merge of node_id21_NodeOutput_outpipereg_data_w_data : signal is true;
begin
	
	-- Assignments
	
	sig <= inst_ln14_alteraflipflops_q;
	cat_ln239_photonstreamingblockadapter<=sig;
	cpustreamkernel_core_rst1 <= cat_ln239_photonstreamingblockadapter;
	cat_ln1284_photonstreamingblockadapterwithsm<=ce_fill_0_0_pdc0_enable;
	cpustreamkernel_core_enable_ce_fill_0_0_1 <= cat_ln1284_photonstreamingblockadapterwithsm;
	cat_ln1284_photonstreamingblockadapterwithsm1<=ce_fill_0_1_pdc0_enable;
	cpustreamkernel_core_enable_ce_fill_0_1_1 <= cat_ln1284_photonstreamingblockadapterwithsm1;
	cat_ln1284_photonstreamingblockadapterwithsm2<=ce_flush_0_2_pdc0_enable;
	cpustreamkernel_core_enable_ce_flush_0_2_1 <= cat_ln1284_photonstreamingblockadapterwithsm2;
	io_data_w_force_disabled_int <= mapped_reg_block_reg_io_data_w_force_disabled;
	io_child_0_force_disabled_int <= mapped_reg_block_reg_io_child_0_force_disabled;
	io_child_1_force_disabled_int <= mapped_reg_block_reg_io_child_1_force_disabled;
	io_child_2_force_disabled_int <= mapped_reg_block_reg_io_child_2_force_disabled;
	io_child_3_force_disabled_int <= mapped_reg_block_reg_io_child_3_force_disabled;
	run_cycle_count_int <= mapped_reg_block_reg_run_cycle_count;
	pcc_rst <= control_sm_pcc_rst;
	cat_ln711_photonstreamingblockadapterwithsm<=node_id21_NodeOutput_stall_in_pipe_data_w;
	mapped_reg_block_reg_dbg_stall_vector1 <= cat_ln711_photonstreamingblockadapterwithsm;
	current_run_cycle_count_int <= cpustreamkernel_core_mappedreg_current_run_cycle_count;
	cat_ln376_photonstreamingblockadapterwithsm<=(bit_to_vec(child_3_empty) & bit_to_vec(child_2_empty) & bit_to_vec(child_1_empty) & bit_to_vec(child_0_empty));
	dbg_ctld_empty_int <= cat_ln376_photonstreamingblockadapterwithsm;
	cat_ln377_photonstreamingblockadapterwithsm<=(bit_to_vec(child_3_almost_empty) & bit_to_vec(child_2_almost_empty) & bit_to_vec(child_1_almost_empty) & bit_to_vec(child_0_almost_empty));
	dbg_ctld_almost_empty_int <= cat_ln377_photonstreamingblockadapterwithsm;
	dbg_ctld_done_int <= "0000";
	dbg_ctld_read_int <= control_sm_ctld_read;
	cat_ln379_photonstreamingblockadapterwithsm<=(cpustreamkernel_core_child_3_en & cpustreamkernel_core_child_2_en & cpustreamkernel_core_child_1_en & cpustreamkernel_core_child_0_en);
	dbg_ctld_request_int <= cat_ln379_photonstreamingblockadapterwithsm;
	dbg_flush_start_int <= cpustreamkernel_core_flush_start_output;
	dbg_full_level_int <= "1100";
	dbg_flush_start_level_int <= "0100";
	dbg_done_out_int <= control_sm_done_out;
	dbg_flushing_int <= control_sm_flushing;
	dbg_fill_level_int <= control_sm_fill_level;
	dbg_flush_level_int <= control_sm_flush_level;
	dbg_ctld_read_pipe_dbg_int <= control_sm_ctld_read_pipe_dbg;
	cat_ln710_photonstreamingblockadapterwithsm<=node_id21_NodeOutput_valid_pipe_data_w;
	dbg_out_valid_int <= cat_ln710_photonstreamingblockadapterwithsm;
	dbg_out_stall_int <= cat_ln711_photonstreamingblockadapterwithsm;
	inst_ln14_alteraflipflops_d1 <= (bit_to_vec(rst) or pcc_rst);
	inst_ln44_alteraflipflops_d1 <= (bit_to_vec(rst) or pcc_rst);
	control_sm_mapped_reg_stop1 <= (inst_ln12_inputsynchronisedsynchroniser_dat_o or "0");
	control_sm_ctld_empty1 <= cat_ln376_photonstreamingblockadapterwithsm;
	control_sm_ctld_almost_empty1 <= cat_ln377_photonstreamingblockadapterwithsm;
	control_sm_stall1 <= (node_id21_NodeOutput_stall_in_pipe_data_w);
	control_sm_ctld_request1 <= cat_ln379_photonstreamingblockadapterwithsm;
	ce_fill_0_0_pdc0_rst1 <= cat_ln239_photonstreamingblockadapter;
	sig2 <= "0100";
	ce_fill_0_1_pdc0_rst1 <= cat_ln239_photonstreamingblockadapter;
	ce_flush_0_2_pdc0_rst1 <= cat_ln239_photonstreamingblockadapter;
	child_0_read <= vec_to_bit(slice(control_sm_ctld_read, 0, 1));
	child_1_read <= vec_to_bit(slice(control_sm_ctld_read, 1, 1));
	child_2_read <= vec_to_bit(slice(control_sm_ctld_read, 2, 1));
	child_3_read <= vec_to_bit(slice(control_sm_ctld_read, 3, 1));
	data_w_valid <= vec_to_bit(node_id21_NodeOutput_valid_pipe_data_w);
	data_w_done <= vec_to_bit(node_id21_NodeOutput_done_out_pipe_data_w);
	data_w_data <= node_id21_NodeOutput_outpipereg_data_w_data;
	register_out <= mapped_reg_block_register_out;
	active <= vec_to_bit(reg_ln339_photonstreamingblockadapterwithsm);
	
	-- Register processes
	
	reg_process : process(clk)
	begin
		if rising_edge(clk) then
			if slv_to_slv(reg_ln270_photonstreamingblockadapter) = "1" then
				node_id21_NodeOutput_stall_in_pipe_data_w <= "0";
			else
				node_id21_NodeOutput_stall_in_pipe_data_w <= bit_to_vec(data_w_stall);
			end if;
			reg_ln270_photonstreamingblockadapter <= (bit_to_vec(rst) or pcc_rst);
			if slv_to_slv(reg_ln270_photonstreamingblockadapter) = "1" then
				node_id21_NodeOutput_valid_pipe_data_w <= "0";
			else
				node_id21_NodeOutput_valid_pipe_data_w <= cpustreamkernel_core_data_w_valid;
			end if;
			if slv_to_slv(reg_ln270_photonstreamingblockadapter) = "1" then
				node_id21_NodeOutput_done_out_pipe_data_w <= "0";
			else
				node_id21_NodeOutput_done_out_pipe_data_w <= control_sm_done_out;
			end if;
			node_id21_NodeOutput_outpipereg_data_w_data <= cpustreamkernel_core_data_w_data;
			if slv_to_slv(reg_ln270_photonstreamingblockadapter) = "1" then
				reg_ln339_photonstreamingblockadapterwithsm <= "0";
			else
				reg_ln339_photonstreamingblockadapterwithsm <= (control_sm_next_ce);
			end if;
		end if;
	end process;
	
	-- Entity instances
	
	CpuStreamKernel_core : CpuStreamKernel
		port map (
			child_0_en => cpustreamkernel_core_child_0_en(0), -- 1 bits (out)
			child_1_en => cpustreamkernel_core_child_1_en(0), -- 1 bits (out)
			child_2_en => cpustreamkernel_core_child_2_en(0), -- 1 bits (out)
			child_3_en => cpustreamkernel_core_child_3_en(0), -- 1 bits (out)
			data_w_output_control => cpustreamkernel_core_data_w_output_control(0), -- 1 bits (out)
			data_w_data => cpustreamkernel_core_data_w_data, -- 32 bits (out)
			data_w_valid => cpustreamkernel_core_data_w_valid(0), -- 1 bits (out)
			mappedreg_current_run_cycle_count => cpustreamkernel_core_mappedreg_current_run_cycle_count, -- 48 bits (out)
			flush_start_output => cpustreamkernel_core_flush_start_output(0), -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			rst => vec_to_bit(cpustreamkernel_core_rst1), -- 1 bits (in)
			ce => vec_to_bit(control_sm_stream_ce), -- 1 bits (in)
			fill_level => control_sm_fill_level, -- 4 bits (in)
			flush_level => control_sm_flush_level, -- 4 bits (in)
			flushing => vec_to_bit(control_sm_flushing), -- 1 bits (in)
			done => vec_to_bit(control_sm_done_out), -- 1 bits (in)
			next_ce => vec_to_bit(control_sm_next_ce), -- 1 bits (in)
			next_fill_level => control_sm_next_fill_level, -- 4 bits (in)
			enable_ce_fill_0_0 => cpustreamkernel_core_enable_ce_fill_0_0_1, -- 4 bits (in)
			enable_ce_fill_0_1 => vec_to_bit(cpustreamkernel_core_enable_ce_fill_0_1_1), -- 1 bits (in)
			enable_ce_flush_0_2 => vec_to_bit(cpustreamkernel_core_enable_ce_flush_0_2_1), -- 1 bits (in)
			mappedreg_io_data_w_force_disabled => vec_to_bit(io_data_w_force_disabled_int), -- 1 bits (in)
			mappedreg_io_child_0_force_disabled => vec_to_bit(io_child_0_force_disabled_int), -- 1 bits (in)
			child_0_data => child_0_data, -- 32 bits (in)
			mappedreg_io_child_1_force_disabled => vec_to_bit(io_child_1_force_disabled_int), -- 1 bits (in)
			child_1_data => child_1_data, -- 32 bits (in)
			mappedreg_io_child_2_force_disabled => vec_to_bit(io_child_2_force_disabled_int), -- 1 bits (in)
			child_2_data => child_2_data, -- 32 bits (in)
			mappedreg_io_child_3_force_disabled => vec_to_bit(io_child_3_force_disabled_int), -- 1 bits (in)
			child_3_data => child_3_data, -- 32 bits (in)
			mappedreg_run_cycle_count => run_cycle_count_int -- 48 bits (in)
		);
	mapped_reg_block : MappedRegBlock_e8cba5601e8a42a294dafc2aba54dbf4
		port map (
			register_out => mapped_reg_block_register_out, -- 8 bits (out)
			reg_io_data_w_force_disabled => mapped_reg_block_reg_io_data_w_force_disabled(0), -- 1 bits (out)
			reg_io_child_0_force_disabled => mapped_reg_block_reg_io_child_0_force_disabled(0), -- 1 bits (out)
			reg_io_child_1_force_disabled => mapped_reg_block_reg_io_child_1_force_disabled(0), -- 1 bits (out)
			reg_io_child_2_force_disabled => mapped_reg_block_reg_io_child_2_force_disabled(0), -- 1 bits (out)
			reg_io_child_3_force_disabled => mapped_reg_block_reg_io_child_3_force_disabled(0), -- 1 bits (out)
			reg_run_cycle_count => mapped_reg_block_reg_run_cycle_count, -- 48 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => register_in, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_dbg_stall_vector => vec_to_bit(mapped_reg_block_reg_dbg_stall_vector1), -- 1 bits (in)
			reg_current_run_cycle_count => current_run_cycle_count_int, -- 48 bits (in)
			reg_dbg_ctld_empty => dbg_ctld_empty_int, -- 4 bits (in)
			reg_dbg_ctld_almost_empty => dbg_ctld_almost_empty_int, -- 4 bits (in)
			reg_dbg_ctld_done => dbg_ctld_done_int, -- 4 bits (in)
			reg_dbg_ctld_read => dbg_ctld_read_int, -- 4 bits (in)
			reg_dbg_ctld_request => dbg_ctld_request_int, -- 4 bits (in)
			reg_dbg_flush_start => vec_to_bit(dbg_flush_start_int), -- 1 bits (in)
			reg_dbg_full_level => dbg_full_level_int, -- 4 bits (in)
			reg_dbg_flush_start_level => dbg_flush_start_level_int, -- 4 bits (in)
			reg_dbg_done_out => vec_to_bit(dbg_done_out_int), -- 1 bits (in)
			reg_dbg_flushing => vec_to_bit(dbg_flushing_int), -- 1 bits (in)
			reg_dbg_fill_level => dbg_fill_level_int, -- 4 bits (in)
			reg_dbg_flush_level => dbg_flush_level_int, -- 4 bits (in)
			reg_dbg_ctld_read_pipe_dbg => dbg_ctld_read_pipe_dbg_int, -- 12 bits (in)
			reg_dbg_out_valid => vec_to_bit(dbg_out_valid_int), -- 1 bits (in)
			reg_dbg_out_stall => vec_to_bit(dbg_out_stall_int) -- 1 bits (in)
		);
	inst_ln14_alteraflipflops : dff_ce_syncsr
		generic map (
			INIT => '0'
		)
		port map (
			Q => inst_ln14_alteraflipflops_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => vec_to_bit(inst_ln14_alteraflipflops_d1), -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	inst_ln44_alteraflipflops : dff_ce_syncsr_ne
		generic map (
			INIT => '0'
		)
		port map (
			Q => inst_ln44_alteraflipflops_q(0), -- 1 bits (out)
			C => clk, -- 1 bits (in)
			CE => vec_to_bit("1"), -- 1 bits (in)
			D => vec_to_bit(inst_ln44_alteraflipflops_d1), -- 1 bits (in)
			R => vec_to_bit("0"), -- 1 bits (in)
			S => vec_to_bit("0") -- 1 bits (in)
		);
	control_sm : PhotonDesignControl
		generic map (
			STREAM_LEVEL_WIDTH => 4,
			CTL_PIPELINING => 2,
			CTL_PIPELINING_BITS => 2,
			CTL_REPLICATION_PHASE0_NEXT_CE => 1,
			CTL_REPLICATION_PHASE1_NEXT_CE => 1,
			NUM_INPUTS => 4,
			DESIGN_NAME => "CpuStreamKernel",
			VERBOSE => true,
			RESET_CYCLE_COUNTER_WIDTH => 5
		)
		port map (
			pcc_finished => control_sm_pcc_finished(0), -- 1 bits (out)
			pcc_rst => control_sm_pcc_rst(0), -- 1 bits (out)
			ctld_read => control_sm_ctld_read, -- 4 bits (out)
			done_out => control_sm_done_out(0), -- 1 bits (out)
			stream_ce => control_sm_stream_ce(0), -- 1 bits (out)
			flushing => control_sm_flushing(0), -- 1 bits (out)
			fill_level => control_sm_fill_level, -- 4 bits (out)
			flush_level => control_sm_flush_level, -- 4 bits (out)
			next_ce => control_sm_next_ce, -- 1 bits (out)
			next_ce_phase1 => control_sm_next_ce_phase1, -- 1 bits (out)
			ctld_read_pipe_dbg => control_sm_ctld_read_pipe_dbg, -- 12 bits (out)
			next_fill_level => control_sm_next_fill_level, -- 4 bits (out)
			next_flush_level => control_sm_next_flush_level, -- 4 bits (out)
			next_flushing => control_sm_next_flushing(0), -- 1 bits (out)
			next_done_out => control_sm_next_done_out(0), -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			rst => vec_to_bit(reg_ln270_photonstreamingblockadapter), -- 1 bits (in)
			pcc_start => vec_to_bit("0"), -- 1 bits (in)
			mapped_reg_stop => vec_to_bit(control_sm_mapped_reg_stop1), -- 1 bits (in)
			ctld_empty => control_sm_ctld_empty1, -- 4 bits (in)
			ctld_almost_empty => control_sm_ctld_almost_empty1, -- 4 bits (in)
			ctld_done => "0000", -- 4 bits (in)
			stall => vec_to_bit(control_sm_stall1), -- 1 bits (in)
			full_level => "1100", -- 4 bits (in)
			flush_start_level => "0100", -- 4 bits (in)
			ctld_request => control_sm_ctld_request1, -- 4 bits (in)
			flush_start => vec_to_bit(cpustreamkernel_core_flush_start_output) -- 1 bits (in)
		);
	ce_fill_0_0_pdc0 : FillLevelCounter_0
		port map (
			enable => ce_fill_0_0_pdc0_enable, -- 4 bits (out)
			clk => clk, -- 1 bits (in)
			rst => vec_to_bit(ce_fill_0_0_pdc0_rst1), -- 1 bits (in)
			ce => vec_to_bit(control_sm_stream_ce), -- 1 bits (in)
			next_ce => vec_to_bit(control_sm_next_ce), -- 1 bits (in)
			target_level => "0000", -- 4 bits (in)
			flushing => vec_to_bit(control_sm_flushing), -- 1 bits (in)
			flush_start_level => sig2 -- 4 bits (in)
		);
	ce_fill_0_1_pdc0 : FillLevelCounter_1
		port map (
			enable => ce_fill_0_1_pdc0_enable(0), -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			rst => vec_to_bit(ce_fill_0_1_pdc0_rst1), -- 1 bits (in)
			ce => vec_to_bit(control_sm_stream_ce), -- 1 bits (in)
			next_ce => vec_to_bit(control_sm_next_ce), -- 1 bits (in)
			target_level => "1100", -- 4 bits (in)
			flushing => vec_to_bit(control_sm_flushing), -- 1 bits (in)
			flush_start_level => sig2 -- 4 bits (in)
		);
	ce_flush_0_2_pdc0 : FlushLevelCounter_2
		port map (
			enable => ce_flush_0_2_pdc0_enable(0), -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			rst => vec_to_bit(ce_flush_0_2_pdc0_rst1), -- 1 bits (in)
			ce => vec_to_bit(control_sm_stream_ce), -- 1 bits (in)
			next_ce => vec_to_bit(control_sm_next_ce), -- 1 bits (in)
			target_level => "1000", -- 4 bits (in)
			flushing => vec_to_bit(control_sm_flushing), -- 1 bits (in)
			flush_start_level => "0000" -- 4 bits (in)
		);
	inst_ln12_inputsynchronisedsynchroniser : vhdl_input_synchronized_bus_synchronizer
		generic map (
			width => 1,
			reset_value => 0,
			IS_VIRTEX6 => false
		)
		port map (
			dat_o => inst_ln12_inputsynchronisedsynchroniser_dat_o, -- 1 bits (out)
			in_clk => register_clk, -- 1 bits (in)
			in_rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => bit_to_vec(register_stop), -- 1 bits (in)
			out_clk => clk, -- 1 bits (in)
			out_rst => vec_to_bit("0") -- 1 bits (in)
		);
end MaxDC;
