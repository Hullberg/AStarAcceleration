library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity PCIeRingBufferBarParser is
	port (
		bar_parse_wr_addr_onehot: in std_logic_vector(255 downto 0);
		bar_parse_wr_data: in std_logic_vector(63 downto 0);
		bar_parse_wr_clk: in std_logic;
		bar_parse_wr_page_sel_onehot: in std_logic_vector(1 downto 0);
		ring_sg_buffer_entry: out std_logic_vector(71 downto 0);
		ring_vfifo_userspace_ptr: out std_logic_vector(63 downto 0);
		ring_last_entry_index: out std_logic_vector(31 downto 0);
		ring_current_entry_index: out std_logic_vector(31 downto 0);
		ring_stream_select_sfh: out std_logic_vector(15 downto 0);
		ring_stream_select_sth: out std_logic_vector(15 downto 0);
		ring_config_valid: out std_logic;
		ring_reset: out std_logic_vector(31 downto 0);
		ring_reset_valid: out std_logic;
		ring_driving_ptr_sfh0: out std_logic_vector(31 downto 0);
		ring_driving_ptr_sfh0_valid: out std_logic;
		ring_driving_ptr_sfh1: out std_logic_vector(31 downto 0);
		ring_driving_ptr_sfh1_valid: out std_logic;
		ring_driving_ptr_sfh2: out std_logic_vector(31 downto 0);
		ring_driving_ptr_sfh2_valid: out std_logic;
		ring_driving_ptr_sfh3: out std_logic_vector(31 downto 0);
		ring_driving_ptr_sfh3_valid: out std_logic;
		ring_driving_ptr_sfh4: out std_logic_vector(31 downto 0);
		ring_driving_ptr_sfh4_valid: out std_logic;
		ring_driving_ptr_sth0: out std_logic_vector(31 downto 0);
		ring_driving_ptr_sth0_valid: out std_logic;
		ring_driving_ptr_sth1: out std_logic_vector(31 downto 0);
		ring_driving_ptr_sth1_valid: out std_logic;
		bar_valid_sfh4: out std_logic
	);
end PCIeRingBufferBarParser;

architecture MaxDC of PCIeRingBufferBarParser is
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
	
	-- Signal declarations
	
	signal ring_sg_buffer_entry2_i : std_logic_vector(7 downto 0) := "00000000";
	signal ring_sg_buffer_entry1_i : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal ring_sg_buffer_entry0_i : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal cat_ln16_pcieringbufferbarparser : std_logic_vector(71 downto 0);
	signal ring_vfifo_userspace_ptr1_i : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal ring_vfifo_userspace_ptr0_i : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal cat_ln22_pcieringbufferbarparser : std_logic_vector(63 downto 0);
	signal ring_last_entry_index_i : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal ring_current_entry_index_i : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal ring_stream_select_i : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal cat_ln33_pcieringbufferbarparser : std_logic_vector(15 downto 0);
	signal cat_ln38_pcieringbufferbarparser : std_logic_vector(15 downto 0);
	signal ring_config_valid_strobe : std_logic_vector(0 downto 0) := "0";
	signal ring_reset_i : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal ring_reset_valid_strobe : std_logic_vector(0 downto 0) := "0";
	signal ring_driving_ptr_sfh0_i : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal ring_driving_ptr_sfh0_valid_strobe : std_logic_vector(0 downto 0) := "0";
	signal ring_driving_ptr_sfh1_i : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal ring_driving_ptr_sfh1_valid_strobe : std_logic_vector(0 downto 0) := "0";
	signal ring_driving_ptr_sfh2_i : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal ring_driving_ptr_sfh2_valid_strobe : std_logic_vector(0 downto 0) := "0";
	signal ring_driving_ptr_sfh3_i : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal ring_driving_ptr_sfh3_valid_strobe : std_logic_vector(0 downto 0) := "0";
	signal ring_driving_ptr_sfh4_i : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal ring_driving_ptr_sfh4_valid_strobe : std_logic_vector(0 downto 0) := "0";
	signal ring_driving_ptr_sth0_i : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal ring_driving_ptr_sth0_valid_strobe : std_logic_vector(0 downto 0) := "0";
	signal ring_driving_ptr_sth1_i : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal ring_driving_ptr_sth1_valid_strobe : std_logic_vector(0 downto 0) := "0";
	signal bar_valid_sfh4_i : std_logic_vector(0 downto 0) := "0";
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	cat_ln16_pcieringbufferbarparser<=(ring_sg_buffer_entry2_i & ring_sg_buffer_entry1_i & ring_sg_buffer_entry0_i);
	cat_ln22_pcieringbufferbarparser<=(ring_vfifo_userspace_ptr1_i & ring_vfifo_userspace_ptr0_i);
	cat_ln33_pcieringbufferbarparser<=("00000000000" & slice(ring_stream_select_i, 0, 5));
	cat_ln38_pcieringbufferbarparser<=("00000000000000" & slice(ring_stream_select_i, 16, 2));
	ring_sg_buffer_entry <= cat_ln16_pcieringbufferbarparser;
	ring_vfifo_userspace_ptr <= cat_ln22_pcieringbufferbarparser;
	ring_last_entry_index <= ring_last_entry_index_i;
	ring_current_entry_index <= ring_current_entry_index_i;
	ring_stream_select_sfh <= cat_ln33_pcieringbufferbarparser;
	ring_stream_select_sth <= cat_ln38_pcieringbufferbarparser;
	ring_config_valid <= vec_to_bit(ring_config_valid_strobe);
	ring_reset <= ring_reset_i;
	ring_reset_valid <= vec_to_bit(ring_reset_valid_strobe);
	ring_driving_ptr_sfh0 <= ring_driving_ptr_sfh0_i;
	ring_driving_ptr_sfh0_valid <= vec_to_bit(ring_driving_ptr_sfh0_valid_strobe);
	ring_driving_ptr_sfh1 <= ring_driving_ptr_sfh1_i;
	ring_driving_ptr_sfh1_valid <= vec_to_bit(ring_driving_ptr_sfh1_valid_strobe);
	ring_driving_ptr_sfh2 <= ring_driving_ptr_sfh2_i;
	ring_driving_ptr_sfh2_valid <= vec_to_bit(ring_driving_ptr_sfh2_valid_strobe);
	ring_driving_ptr_sfh3 <= ring_driving_ptr_sfh3_i;
	ring_driving_ptr_sfh3_valid <= vec_to_bit(ring_driving_ptr_sfh3_valid_strobe);
	ring_driving_ptr_sfh4 <= ring_driving_ptr_sfh4_i;
	ring_driving_ptr_sfh4_valid <= vec_to_bit(ring_driving_ptr_sfh4_valid_strobe);
	ring_driving_ptr_sth0 <= ring_driving_ptr_sth0_i;
	ring_driving_ptr_sth0_valid <= vec_to_bit(ring_driving_ptr_sth0_valid_strobe);
	ring_driving_ptr_sth1 <= ring_driving_ptr_sth1_i;
	ring_driving_ptr_sth1_valid <= vec_to_bit(ring_driving_ptr_sth1_valid_strobe);
	bar_valid_sfh4 <= vec_to_bit(bar_valid_sfh4_i);
	
	-- Register processes
	
	reg_process : process(bar_parse_wr_clk)
	begin
		if rising_edge(bar_parse_wr_clk) then
			if slv_to_slv((slice(bar_parse_wr_addr_onehot, 82, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1))) = "1" then
				ring_sg_buffer_entry2_i <= slice(bar_parse_wr_data, 0, 8);
			end if;
			if slv_to_slv((slice(bar_parse_wr_addr_onehot, 81, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1))) = "1" then
				ring_sg_buffer_entry1_i <= slice(bar_parse_wr_data, 32, 32);
			end if;
			if slv_to_slv((slice(bar_parse_wr_addr_onehot, 80, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1))) = "1" then
				ring_sg_buffer_entry0_i <= slice(bar_parse_wr_data, 0, 32);
			end if;
			if slv_to_slv((slice(bar_parse_wr_addr_onehot, 84, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1))) = "1" then
				ring_vfifo_userspace_ptr1_i <= slice(bar_parse_wr_data, 0, 32);
			end if;
			if slv_to_slv((slice(bar_parse_wr_addr_onehot, 83, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1))) = "1" then
				ring_vfifo_userspace_ptr0_i <= slice(bar_parse_wr_data, 32, 32);
			end if;
			if slv_to_slv((slice(bar_parse_wr_addr_onehot, 85, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1))) = "1" then
				ring_last_entry_index_i <= slice(bar_parse_wr_data, 32, 32);
			end if;
			if slv_to_slv((slice(bar_parse_wr_addr_onehot, 86, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1))) = "1" then
				ring_current_entry_index_i <= slice(bar_parse_wr_data, 0, 32);
			end if;
			if slv_to_slv((slice(bar_parse_wr_addr_onehot, 87, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1))) = "1" then
				ring_stream_select_i <= slice(bar_parse_wr_data, 32, 32);
			end if;
			ring_config_valid_strobe <= (slice(bar_parse_wr_addr_onehot, 87, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1));
			if slv_to_slv((slice(bar_parse_wr_addr_onehot, 94, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1))) = "1" then
				ring_reset_i <= slice(bar_parse_wr_data, 0, 32);
			end if;
			ring_reset_valid_strobe <= (slice(bar_parse_wr_addr_onehot, 94, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1));
			if slv_to_slv((slice(bar_parse_wr_addr_onehot, 96, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1))) = "1" then
				ring_driving_ptr_sfh0_i <= slice(bar_parse_wr_data, 0, 32);
			end if;
			ring_driving_ptr_sfh0_valid_strobe <= (slice(bar_parse_wr_addr_onehot, 96, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1));
			if slv_to_slv((slice(bar_parse_wr_addr_onehot, 97, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1))) = "1" then
				ring_driving_ptr_sfh1_i <= slice(bar_parse_wr_data, 32, 32);
			end if;
			ring_driving_ptr_sfh1_valid_strobe <= (slice(bar_parse_wr_addr_onehot, 97, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1));
			if slv_to_slv((slice(bar_parse_wr_addr_onehot, 98, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1))) = "1" then
				ring_driving_ptr_sfh2_i <= slice(bar_parse_wr_data, 0, 32);
			end if;
			ring_driving_ptr_sfh2_valid_strobe <= (slice(bar_parse_wr_addr_onehot, 98, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1));
			if slv_to_slv((slice(bar_parse_wr_addr_onehot, 99, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1))) = "1" then
				ring_driving_ptr_sfh3_i <= slice(bar_parse_wr_data, 32, 32);
			end if;
			ring_driving_ptr_sfh3_valid_strobe <= (slice(bar_parse_wr_addr_onehot, 99, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1));
			if slv_to_slv((slice(bar_parse_wr_addr_onehot, 100, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1))) = "1" then
				ring_driving_ptr_sfh4_i <= slice(bar_parse_wr_data, 0, 32);
			end if;
			ring_driving_ptr_sfh4_valid_strobe <= (slice(bar_parse_wr_addr_onehot, 100, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1));
			if slv_to_slv((slice(bar_parse_wr_addr_onehot, 112, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1))) = "1" then
				ring_driving_ptr_sth0_i <= slice(bar_parse_wr_data, 0, 32);
			end if;
			ring_driving_ptr_sth0_valid_strobe <= (slice(bar_parse_wr_addr_onehot, 112, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1));
			if slv_to_slv((slice(bar_parse_wr_addr_onehot, 113, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1))) = "1" then
				ring_driving_ptr_sth1_i <= slice(bar_parse_wr_data, 32, 32);
			end if;
			ring_driving_ptr_sth1_valid_strobe <= (slice(bar_parse_wr_addr_onehot, 113, 1) and slice(bar_parse_wr_page_sel_onehot, 1, 1));
			bar_valid_sfh4_i <= (ring_config_valid_strobe and slice(ring_stream_select_i, 4, 1));
		end if;
	end process;
	
	-- Entity instances
	
end MaxDC;
