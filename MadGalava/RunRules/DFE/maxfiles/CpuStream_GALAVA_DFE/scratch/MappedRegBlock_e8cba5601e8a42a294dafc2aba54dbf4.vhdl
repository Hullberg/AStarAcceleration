library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity MappedRegBlock_e8cba5601e8a42a294dafc2aba54dbf4 is
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
end MappedRegBlock_e8cba5601e8a42a294dafc2aba54dbf4;

architecture MaxDC of MappedRegBlock_e8cba5601e8a42a294dafc2aba54dbf4 is
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
	component mapped_register_readable is
		generic (
			BYTE_WIDTH : integer;
			SWITCHABLE : boolean;
			BIG_ENDIAN : boolean
		);
		port (
			register_clk: in std_logic;
			register_in: in std_logic_vector(7 downto 0);
			register_rotate: in std_logic;
			register_stop: in std_logic;
			register_switch: in std_logic;
			reg_in: in std_logic_vector(BYTE_WIDTH*8-1 downto 0);
			register_out: out std_logic_vector(7 downto 0)
		);
	end component;
	component mapped_register is
		generic (
			BYTE_WIDTH : integer;
			SHADOW_REGISTER : boolean;
			SWITCHABLE : boolean;
			BIG_ENDIAN : boolean
		);
		port (
			register_clk: in std_logic;
			register_in: in std_logic_vector(7 downto 0);
			register_rotate: in std_logic;
			register_stop: in std_logic;
			register_switch: in std_logic;
			register_out: out std_logic_vector(7 downto 0);
			reg_out: out std_logic_vector(BYTE_WIDTH*8-1 downto 0)
		);
	end component;
	
	-- Signal declarations
	
	signal inst_ln505_mappedregblock_register_out : std_logic_vector(7 downto 0);
	signal inst_ln525_mappedregblock_register_out : std_logic_vector(7 downto 0);
	signal inst_ln525_mappedregblock_reg_out : std_logic_vector(7 downto 0);
	signal inst_ln525_mappedregblock1_register_out : std_logic_vector(7 downto 0);
	signal inst_ln525_mappedregblock1_reg_out : std_logic_vector(7 downto 0);
	signal inst_ln525_mappedregblock2_register_out : std_logic_vector(7 downto 0);
	signal inst_ln525_mappedregblock2_reg_out : std_logic_vector(7 downto 0);
	signal inst_ln525_mappedregblock3_register_out : std_logic_vector(7 downto 0);
	signal inst_ln525_mappedregblock3_reg_out : std_logic_vector(7 downto 0);
	signal inst_ln525_mappedregblock4_register_out : std_logic_vector(7 downto 0);
	signal inst_ln525_mappedregblock4_reg_out : std_logic_vector(7 downto 0);
	signal inst_ln525_mappedregblock5_register_out : std_logic_vector(7 downto 0);
	signal inst_ln525_mappedregblock5_reg_out : std_logic_vector(47 downto 0);
	signal inst_ln505_mappedregblock1_register_out : std_logic_vector(7 downto 0);
	signal inst_ln505_mappedregblock2_register_out : std_logic_vector(7 downto 0);
	signal inst_ln505_mappedregblock3_register_out : std_logic_vector(7 downto 0);
	signal inst_ln505_mappedregblock4_register_out : std_logic_vector(7 downto 0);
	signal inst_ln505_mappedregblock5_register_out : std_logic_vector(7 downto 0);
	signal inst_ln505_mappedregblock6_register_out : std_logic_vector(7 downto 0);
	signal inst_ln505_mappedregblock7_register_out : std_logic_vector(7 downto 0);
	signal inst_ln505_mappedregblock8_register_out : std_logic_vector(7 downto 0);
	signal inst_ln505_mappedregblock9_register_out : std_logic_vector(7 downto 0);
	signal inst_ln505_mappedregblock10_register_out : std_logic_vector(7 downto 0);
	signal inst_ln505_mappedregblock11_register_out : std_logic_vector(7 downto 0);
	signal inst_ln505_mappedregblock12_register_out : std_logic_vector(7 downto 0);
	signal inst_ln505_mappedregblock13_register_out : std_logic_vector(7 downto 0);
	signal inst_ln505_mappedregblock14_register_out : std_logic_vector(7 downto 0);
	signal inst_ln505_mappedregblock15_register_out : std_logic_vector(7 downto 0);
	signal inst_ln505_mappedregblock16_register_out : std_logic_vector(7 downto 0);
	signal sig1 : std_logic_vector(7 downto 0);
	signal reg_dbg_stall_vector_in_int : std_logic_vector(7 downto 0);
	signal cat_ln283_mappedregblock : std_logic_vector(7 downto 0);
	signal sig2 : std_logic_vector(7 downto 0);
	signal sig3 : std_logic_vector(7 downto 0);
	signal sig4 : std_logic_vector(7 downto 0);
	signal sig5 : std_logic_vector(7 downto 0);
	signal sig6 : std_logic_vector(7 downto 0);
	signal sig7 : std_logic_vector(7 downto 0);
	signal sig8 : std_logic_vector(7 downto 0);
	signal reg_current_run_cycle_count_in_int : std_logic_vector(47 downto 0);
	signal cat_ln283_mappedregblock1 : std_logic_vector(47 downto 0);
	signal sig9 : std_logic_vector(7 downto 0);
	signal reg_dbg_ctld_empty_in_int : std_logic_vector(7 downto 0);
	signal cat_ln283_mappedregblock2 : std_logic_vector(7 downto 0);
	signal sig10 : std_logic_vector(7 downto 0);
	signal reg_dbg_ctld_almost_empty_in_int : std_logic_vector(7 downto 0);
	signal cat_ln283_mappedregblock3 : std_logic_vector(7 downto 0);
	signal sig11 : std_logic_vector(7 downto 0);
	signal reg_dbg_ctld_done_in_int : std_logic_vector(7 downto 0);
	signal cat_ln283_mappedregblock4 : std_logic_vector(7 downto 0);
	signal sig12 : std_logic_vector(7 downto 0);
	signal reg_dbg_ctld_read_in_int : std_logic_vector(7 downto 0);
	signal cat_ln283_mappedregblock5 : std_logic_vector(7 downto 0);
	signal sig13 : std_logic_vector(7 downto 0);
	signal reg_dbg_ctld_request_in_int : std_logic_vector(7 downto 0);
	signal cat_ln283_mappedregblock6 : std_logic_vector(7 downto 0);
	signal sig14 : std_logic_vector(7 downto 0);
	signal reg_dbg_flush_start_in_int : std_logic_vector(7 downto 0);
	signal cat_ln283_mappedregblock7 : std_logic_vector(7 downto 0);
	signal sig15 : std_logic_vector(7 downto 0);
	signal reg_dbg_full_level_in_int : std_logic_vector(7 downto 0);
	signal cat_ln283_mappedregblock8 : std_logic_vector(7 downto 0);
	signal sig16 : std_logic_vector(7 downto 0);
	signal reg_dbg_flush_start_level_in_int : std_logic_vector(7 downto 0);
	signal cat_ln283_mappedregblock9 : std_logic_vector(7 downto 0);
	signal sig17 : std_logic_vector(7 downto 0);
	signal reg_dbg_done_out_in_int : std_logic_vector(7 downto 0);
	signal cat_ln283_mappedregblock10 : std_logic_vector(7 downto 0);
	signal sig18 : std_logic_vector(7 downto 0);
	signal reg_dbg_flushing_in_int : std_logic_vector(7 downto 0);
	signal cat_ln283_mappedregblock11 : std_logic_vector(7 downto 0);
	signal sig19 : std_logic_vector(7 downto 0);
	signal reg_dbg_fill_level_in_int : std_logic_vector(7 downto 0);
	signal cat_ln283_mappedregblock12 : std_logic_vector(7 downto 0);
	signal sig20 : std_logic_vector(7 downto 0);
	signal reg_dbg_flush_level_in_int : std_logic_vector(7 downto 0);
	signal cat_ln283_mappedregblock13 : std_logic_vector(7 downto 0);
	signal sig21 : std_logic_vector(7 downto 0);
	signal reg_dbg_ctld_read_pipe_dbg_in_int : std_logic_vector(15 downto 0);
	signal cat_ln283_mappedregblock14 : std_logic_vector(15 downto 0);
	signal sig22 : std_logic_vector(7 downto 0);
	signal reg_dbg_out_valid_in_int : std_logic_vector(7 downto 0);
	signal cat_ln283_mappedregblock15 : std_logic_vector(7 downto 0);
	signal sig23 : std_logic_vector(7 downto 0);
	signal reg_dbg_out_stall_in_int : std_logic_vector(7 downto 0);
	signal cat_ln283_mappedregblock16 : std_logic_vector(7 downto 0);
	signal sig : std_logic_vector(7 downto 0);
	signal reg_io_data_w_force_disabled_out_int : std_logic_vector(0 downto 0);
	signal reg_io_child_0_force_disabled_out_int : std_logic_vector(0 downto 0);
	signal reg_io_child_1_force_disabled_out_int : std_logic_vector(0 downto 0);
	signal reg_io_child_2_force_disabled_out_int : std_logic_vector(0 downto 0);
	signal reg_io_child_3_force_disabled_out_int : std_logic_vector(0 downto 0);
	signal reg_run_cycle_count_out_int : std_logic_vector(47 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	sig1 <= inst_ln525_mappedregblock_register_out;
	cat_ln283_mappedregblock<=("0000000" & bit_to_vec(reg_dbg_stall_vector));
	reg_dbg_stall_vector_in_int <= cat_ln283_mappedregblock;
	sig2 <= inst_ln525_mappedregblock1_register_out;
	sig3 <= inst_ln525_mappedregblock2_register_out;
	sig4 <= inst_ln525_mappedregblock3_register_out;
	sig5 <= inst_ln525_mappedregblock4_register_out;
	sig6 <= inst_ln525_mappedregblock5_register_out;
	sig7 <= inst_ln505_mappedregblock1_register_out;
	sig8 <= inst_ln505_mappedregblock2_register_out;
	cat_ln283_mappedregblock1<=reg_current_run_cycle_count;
	reg_current_run_cycle_count_in_int <= cat_ln283_mappedregblock1;
	sig9 <= inst_ln505_mappedregblock3_register_out;
	cat_ln283_mappedregblock2<=("0000" & reg_dbg_ctld_empty);
	reg_dbg_ctld_empty_in_int <= cat_ln283_mappedregblock2;
	sig10 <= inst_ln505_mappedregblock4_register_out;
	cat_ln283_mappedregblock3<=("0000" & reg_dbg_ctld_almost_empty);
	reg_dbg_ctld_almost_empty_in_int <= cat_ln283_mappedregblock3;
	sig11 <= inst_ln505_mappedregblock5_register_out;
	cat_ln283_mappedregblock4<=("0000" & reg_dbg_ctld_done);
	reg_dbg_ctld_done_in_int <= cat_ln283_mappedregblock4;
	sig12 <= inst_ln505_mappedregblock6_register_out;
	cat_ln283_mappedregblock5<=("0000" & reg_dbg_ctld_read);
	reg_dbg_ctld_read_in_int <= cat_ln283_mappedregblock5;
	sig13 <= inst_ln505_mappedregblock7_register_out;
	cat_ln283_mappedregblock6<=("0000" & reg_dbg_ctld_request);
	reg_dbg_ctld_request_in_int <= cat_ln283_mappedregblock6;
	sig14 <= inst_ln505_mappedregblock8_register_out;
	cat_ln283_mappedregblock7<=("0000000" & bit_to_vec(reg_dbg_flush_start));
	reg_dbg_flush_start_in_int <= cat_ln283_mappedregblock7;
	sig15 <= inst_ln505_mappedregblock9_register_out;
	cat_ln283_mappedregblock8<=("0000" & reg_dbg_full_level);
	reg_dbg_full_level_in_int <= cat_ln283_mappedregblock8;
	sig16 <= inst_ln505_mappedregblock10_register_out;
	cat_ln283_mappedregblock9<=("0000" & reg_dbg_flush_start_level);
	reg_dbg_flush_start_level_in_int <= cat_ln283_mappedregblock9;
	sig17 <= inst_ln505_mappedregblock11_register_out;
	cat_ln283_mappedregblock10<=("0000000" & bit_to_vec(reg_dbg_done_out));
	reg_dbg_done_out_in_int <= cat_ln283_mappedregblock10;
	sig18 <= inst_ln505_mappedregblock12_register_out;
	cat_ln283_mappedregblock11<=("0000000" & bit_to_vec(reg_dbg_flushing));
	reg_dbg_flushing_in_int <= cat_ln283_mappedregblock11;
	sig19 <= inst_ln505_mappedregblock13_register_out;
	cat_ln283_mappedregblock12<=("0000" & reg_dbg_fill_level);
	reg_dbg_fill_level_in_int <= cat_ln283_mappedregblock12;
	sig20 <= inst_ln505_mappedregblock14_register_out;
	cat_ln283_mappedregblock13<=("0000" & reg_dbg_flush_level);
	reg_dbg_flush_level_in_int <= cat_ln283_mappedregblock13;
	sig21 <= inst_ln505_mappedregblock15_register_out;
	cat_ln283_mappedregblock14<=("0000" & reg_dbg_ctld_read_pipe_dbg);
	reg_dbg_ctld_read_pipe_dbg_in_int <= cat_ln283_mappedregblock14;
	sig22 <= inst_ln505_mappedregblock16_register_out;
	cat_ln283_mappedregblock15<=("0000000" & bit_to_vec(reg_dbg_out_valid));
	reg_dbg_out_valid_in_int <= cat_ln283_mappedregblock15;
	sig23 <= register_in;
	cat_ln283_mappedregblock16<=("0000000" & bit_to_vec(reg_dbg_out_stall));
	reg_dbg_out_stall_in_int <= cat_ln283_mappedregblock16;
	sig <= inst_ln505_mappedregblock_register_out;
	reg_io_data_w_force_disabled_out_int <= slice(inst_ln525_mappedregblock_reg_out, 0, 1);
	reg_io_child_0_force_disabled_out_int <= slice(inst_ln525_mappedregblock1_reg_out, 0, 1);
	reg_io_child_1_force_disabled_out_int <= slice(inst_ln525_mappedregblock2_reg_out, 0, 1);
	reg_io_child_2_force_disabled_out_int <= slice(inst_ln525_mappedregblock3_reg_out, 0, 1);
	reg_io_child_3_force_disabled_out_int <= slice(inst_ln525_mappedregblock4_reg_out, 0, 1);
	reg_run_cycle_count_out_int <= inst_ln525_mappedregblock5_reg_out;
	register_out <= sig;
	reg_io_data_w_force_disabled <= vec_to_bit(reg_io_data_w_force_disabled_out_int);
	reg_io_child_0_force_disabled <= vec_to_bit(reg_io_child_0_force_disabled_out_int);
	reg_io_child_1_force_disabled <= vec_to_bit(reg_io_child_1_force_disabled_out_int);
	reg_io_child_2_force_disabled <= vec_to_bit(reg_io_child_2_force_disabled_out_int);
	reg_io_child_3_force_disabled <= vec_to_bit(reg_io_child_3_force_disabled_out_int);
	reg_run_cycle_count <= reg_run_cycle_count_out_int;
	
	-- Register processes
	
	
	-- Entity instances
	
	inst_ln505_mappedregblock : mapped_register_readable
		generic map (
			BYTE_WIDTH => 1,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln505_mappedregblock_register_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig1, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_dbg_stall_vector_in_int -- 8 bits (in)
		);
	inst_ln525_mappedregblock : mapped_register
		generic map (
			BYTE_WIDTH => 1,
			SHADOW_REGISTER => false,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln525_mappedregblock_register_out, -- 8 bits (out)
			reg_out => inst_ln525_mappedregblock_reg_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig2, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch -- 1 bits (in)
		);
	inst_ln525_mappedregblock1 : mapped_register
		generic map (
			BYTE_WIDTH => 1,
			SHADOW_REGISTER => false,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln525_mappedregblock1_register_out, -- 8 bits (out)
			reg_out => inst_ln525_mappedregblock1_reg_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig3, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch -- 1 bits (in)
		);
	inst_ln525_mappedregblock2 : mapped_register
		generic map (
			BYTE_WIDTH => 1,
			SHADOW_REGISTER => false,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln525_mappedregblock2_register_out, -- 8 bits (out)
			reg_out => inst_ln525_mappedregblock2_reg_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig4, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch -- 1 bits (in)
		);
	inst_ln525_mappedregblock3 : mapped_register
		generic map (
			BYTE_WIDTH => 1,
			SHADOW_REGISTER => false,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln525_mappedregblock3_register_out, -- 8 bits (out)
			reg_out => inst_ln525_mappedregblock3_reg_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig5, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch -- 1 bits (in)
		);
	inst_ln525_mappedregblock4 : mapped_register
		generic map (
			BYTE_WIDTH => 1,
			SHADOW_REGISTER => false,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln525_mappedregblock4_register_out, -- 8 bits (out)
			reg_out => inst_ln525_mappedregblock4_reg_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig6, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch -- 1 bits (in)
		);
	inst_ln525_mappedregblock5 : mapped_register
		generic map (
			BYTE_WIDTH => 6,
			SHADOW_REGISTER => false,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln525_mappedregblock5_register_out, -- 8 bits (out)
			reg_out => inst_ln525_mappedregblock5_reg_out, -- 48 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig7, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch -- 1 bits (in)
		);
	inst_ln505_mappedregblock1 : mapped_register_readable
		generic map (
			BYTE_WIDTH => 6,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln505_mappedregblock1_register_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig8, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_current_run_cycle_count_in_int -- 48 bits (in)
		);
	inst_ln505_mappedregblock2 : mapped_register_readable
		generic map (
			BYTE_WIDTH => 1,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln505_mappedregblock2_register_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig9, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_dbg_ctld_empty_in_int -- 8 bits (in)
		);
	inst_ln505_mappedregblock3 : mapped_register_readable
		generic map (
			BYTE_WIDTH => 1,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln505_mappedregblock3_register_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig10, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_dbg_ctld_almost_empty_in_int -- 8 bits (in)
		);
	inst_ln505_mappedregblock4 : mapped_register_readable
		generic map (
			BYTE_WIDTH => 1,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln505_mappedregblock4_register_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig11, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_dbg_ctld_done_in_int -- 8 bits (in)
		);
	inst_ln505_mappedregblock5 : mapped_register_readable
		generic map (
			BYTE_WIDTH => 1,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln505_mappedregblock5_register_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig12, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_dbg_ctld_read_in_int -- 8 bits (in)
		);
	inst_ln505_mappedregblock6 : mapped_register_readable
		generic map (
			BYTE_WIDTH => 1,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln505_mappedregblock6_register_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig13, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_dbg_ctld_request_in_int -- 8 bits (in)
		);
	inst_ln505_mappedregblock7 : mapped_register_readable
		generic map (
			BYTE_WIDTH => 1,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln505_mappedregblock7_register_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig14, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_dbg_flush_start_in_int -- 8 bits (in)
		);
	inst_ln505_mappedregblock8 : mapped_register_readable
		generic map (
			BYTE_WIDTH => 1,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln505_mappedregblock8_register_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig15, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_dbg_full_level_in_int -- 8 bits (in)
		);
	inst_ln505_mappedregblock9 : mapped_register_readable
		generic map (
			BYTE_WIDTH => 1,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln505_mappedregblock9_register_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig16, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_dbg_flush_start_level_in_int -- 8 bits (in)
		);
	inst_ln505_mappedregblock10 : mapped_register_readable
		generic map (
			BYTE_WIDTH => 1,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln505_mappedregblock10_register_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig17, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_dbg_done_out_in_int -- 8 bits (in)
		);
	inst_ln505_mappedregblock11 : mapped_register_readable
		generic map (
			BYTE_WIDTH => 1,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln505_mappedregblock11_register_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig18, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_dbg_flushing_in_int -- 8 bits (in)
		);
	inst_ln505_mappedregblock12 : mapped_register_readable
		generic map (
			BYTE_WIDTH => 1,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln505_mappedregblock12_register_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig19, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_dbg_fill_level_in_int -- 8 bits (in)
		);
	inst_ln505_mappedregblock13 : mapped_register_readable
		generic map (
			BYTE_WIDTH => 1,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln505_mappedregblock13_register_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig20, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_dbg_flush_level_in_int -- 8 bits (in)
		);
	inst_ln505_mappedregblock14 : mapped_register_readable
		generic map (
			BYTE_WIDTH => 2,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln505_mappedregblock14_register_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig21, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_dbg_ctld_read_pipe_dbg_in_int -- 16 bits (in)
		);
	inst_ln505_mappedregblock15 : mapped_register_readable
		generic map (
			BYTE_WIDTH => 1,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln505_mappedregblock15_register_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig22, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_dbg_out_valid_in_int -- 8 bits (in)
		);
	inst_ln505_mappedregblock16 : mapped_register_readable
		generic map (
			BYTE_WIDTH => 1,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln505_mappedregblock16_register_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig23, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_dbg_out_stall_in_int -- 8 bits (in)
		);
end MaxDC;
