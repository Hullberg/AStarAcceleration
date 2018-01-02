library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity MappedRegBlock_2bbdde8c924fe59e82043c5c8fb8266c is
	port (
		register_clk: in std_logic;
		register_in: in std_logic_vector(7 downto 0);
		register_rotate: in std_logic;
		register_stop: in std_logic;
		register_switch: in std_logic;
		reg_clock_counters_base_clock_cclk: in std_logic_vector(10 downto 0);
		reg_clock_counters_STREAM: in std_logic_vector(15 downto 0);
		reg_clock_counters_clk_pcie: in std_logic_vector(15 downto 0);
		reg_seen_reset_reset_n: in std_logic;
		reg_seen_reset_STREAM_rst: in std_logic;
		reg_seen_reset_STREAM_rst_delay: in std_logic;
		reg_seen_reset_PCIE_rst: in std_logic;
		reg_seen_reset_PCIE_rst_delay: in std_logic;
		reg_seen_toggle_crash_input: in std_logic;
		register_out: out std_logic_vector(7 downto 0)
	);
end MappedRegBlock_2bbdde8c924fe59e82043c5c8fb8266c;

architecture MaxDC of MappedRegBlock_2bbdde8c924fe59e82043c5c8fb8266c is
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
	
	-- Signal declarations
	
	signal inst_ln505_mappedregblock_register_out : std_logic_vector(7 downto 0);
	signal inst_ln505_mappedregblock1_register_out : std_logic_vector(7 downto 0);
	signal inst_ln505_mappedregblock2_register_out : std_logic_vector(7 downto 0);
	signal inst_ln505_mappedregblock3_register_out : std_logic_vector(7 downto 0);
	signal inst_ln505_mappedregblock4_register_out : std_logic_vector(7 downto 0);
	signal inst_ln505_mappedregblock5_register_out : std_logic_vector(7 downto 0);
	signal inst_ln505_mappedregblock6_register_out : std_logic_vector(7 downto 0);
	signal inst_ln505_mappedregblock7_register_out : std_logic_vector(7 downto 0);
	signal inst_ln505_mappedregblock8_register_out : std_logic_vector(7 downto 0);
	signal sig1 : std_logic_vector(7 downto 0);
	signal reg_clock_counters_base_clock_cclk_in_int : std_logic_vector(15 downto 0);
	signal cat_ln283_mappedregblock : std_logic_vector(15 downto 0);
	signal sig2 : std_logic_vector(7 downto 0);
	signal reg_clock_counters_STREAM_in_int : std_logic_vector(15 downto 0);
	signal cat_ln283_mappedregblock1 : std_logic_vector(15 downto 0);
	signal sig3 : std_logic_vector(7 downto 0);
	signal reg_clock_counters_clk_pcie_in_int : std_logic_vector(15 downto 0);
	signal cat_ln283_mappedregblock2 : std_logic_vector(15 downto 0);
	signal sig4 : std_logic_vector(7 downto 0);
	signal reg_seen_reset_reset_n_in_int : std_logic_vector(7 downto 0);
	signal cat_ln283_mappedregblock3 : std_logic_vector(7 downto 0);
	signal sig5 : std_logic_vector(7 downto 0);
	signal reg_seen_reset_STREAM_rst_in_int : std_logic_vector(7 downto 0);
	signal cat_ln283_mappedregblock4 : std_logic_vector(7 downto 0);
	signal sig6 : std_logic_vector(7 downto 0);
	signal reg_seen_reset_STREAM_rst_delay_in_int : std_logic_vector(7 downto 0);
	signal cat_ln283_mappedregblock5 : std_logic_vector(7 downto 0);
	signal sig7 : std_logic_vector(7 downto 0);
	signal reg_seen_reset_PCIE_rst_in_int : std_logic_vector(7 downto 0);
	signal cat_ln283_mappedregblock6 : std_logic_vector(7 downto 0);
	signal sig8 : std_logic_vector(7 downto 0);
	signal reg_seen_reset_PCIE_rst_delay_in_int : std_logic_vector(7 downto 0);
	signal cat_ln283_mappedregblock7 : std_logic_vector(7 downto 0);
	signal sig9 : std_logic_vector(7 downto 0);
	signal reg_seen_toggle_crash_input_in_int : std_logic_vector(7 downto 0);
	signal cat_ln283_mappedregblock8 : std_logic_vector(7 downto 0);
	signal sig : std_logic_vector(7 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	sig1 <= inst_ln505_mappedregblock1_register_out;
	cat_ln283_mappedregblock<=("00000" & reg_clock_counters_base_clock_cclk);
	reg_clock_counters_base_clock_cclk_in_int <= cat_ln283_mappedregblock;
	sig2 <= inst_ln505_mappedregblock2_register_out;
	cat_ln283_mappedregblock1<=reg_clock_counters_STREAM;
	reg_clock_counters_STREAM_in_int <= cat_ln283_mappedregblock1;
	sig3 <= inst_ln505_mappedregblock3_register_out;
	cat_ln283_mappedregblock2<=reg_clock_counters_clk_pcie;
	reg_clock_counters_clk_pcie_in_int <= cat_ln283_mappedregblock2;
	sig4 <= inst_ln505_mappedregblock4_register_out;
	cat_ln283_mappedregblock3<=("0000000" & bit_to_vec(reg_seen_reset_reset_n));
	reg_seen_reset_reset_n_in_int <= cat_ln283_mappedregblock3;
	sig5 <= inst_ln505_mappedregblock5_register_out;
	cat_ln283_mappedregblock4<=("0000000" & bit_to_vec(reg_seen_reset_STREAM_rst));
	reg_seen_reset_STREAM_rst_in_int <= cat_ln283_mappedregblock4;
	sig6 <= inst_ln505_mappedregblock6_register_out;
	cat_ln283_mappedregblock5<=("0000000" & bit_to_vec(reg_seen_reset_STREAM_rst_delay));
	reg_seen_reset_STREAM_rst_delay_in_int <= cat_ln283_mappedregblock5;
	sig7 <= inst_ln505_mappedregblock7_register_out;
	cat_ln283_mappedregblock6<=("0000000" & bit_to_vec(reg_seen_reset_PCIE_rst));
	reg_seen_reset_PCIE_rst_in_int <= cat_ln283_mappedregblock6;
	sig8 <= inst_ln505_mappedregblock8_register_out;
	cat_ln283_mappedregblock7<=("0000000" & bit_to_vec(reg_seen_reset_PCIE_rst_delay));
	reg_seen_reset_PCIE_rst_delay_in_int <= cat_ln283_mappedregblock7;
	sig9 <= register_in;
	cat_ln283_mappedregblock8<=("0000000" & bit_to_vec(reg_seen_toggle_crash_input));
	reg_seen_toggle_crash_input_in_int <= cat_ln283_mappedregblock8;
	sig <= inst_ln505_mappedregblock_register_out;
	register_out <= sig;
	
	-- Register processes
	
	
	-- Entity instances
	
	inst_ln505_mappedregblock : mapped_register_readable
		generic map (
			BYTE_WIDTH => 2,
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
			reg_in => reg_clock_counters_base_clock_cclk_in_int -- 16 bits (in)
		);
	inst_ln505_mappedregblock1 : mapped_register_readable
		generic map (
			BYTE_WIDTH => 2,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln505_mappedregblock1_register_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig2, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_clock_counters_STREAM_in_int -- 16 bits (in)
		);
	inst_ln505_mappedregblock2 : mapped_register_readable
		generic map (
			BYTE_WIDTH => 2,
			SWITCHABLE => false,
			BIG_ENDIAN => false
		)
		port map (
			register_out => inst_ln505_mappedregblock2_register_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => sig3, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_clock_counters_clk_pcie_in_int -- 16 bits (in)
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
			register_in => sig4, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_seen_reset_reset_n_in_int -- 8 bits (in)
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
			register_in => sig5, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_seen_reset_STREAM_rst_in_int -- 8 bits (in)
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
			register_in => sig6, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_seen_reset_STREAM_rst_delay_in_int -- 8 bits (in)
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
			register_in => sig7, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_seen_reset_PCIE_rst_in_int -- 8 bits (in)
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
			register_in => sig8, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_seen_reset_PCIE_rst_delay_in_int -- 8 bits (in)
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
			register_in => sig9, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_in => reg_seen_toggle_crash_input_in_int -- 8 bits (in)
		);
end MaxDC;
