library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity PerfMonitor is
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
end PerfMonitor;

architecture MaxDC of PerfMonitor is
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
	component perf_monitor is
		generic (
			SHORT_COUNTER_MAX : integer;
			SHORT_COUNTER_BITS : integer;
			LONG_COUNTER_MAX : integer;
			LONG_COUNTER_BITS : integer;
			MODULE_VERSION : integer
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			in_active: in std_logic;
			in_ecc_flags: in std_logic_vector(1 downto 0);
			in_ecc_parity: in std_logic_vector(31 downto 0);
			in_ecc_corrected: in std_logic_vector(31 downto 0);
			Mem_Data_time1: in std_logic_vector(31 downto 0);
			Mem_Data_time2: in std_logic_vector(31 downto 0);
			Mem_Idle_time1: in std_logic_vector(31 downto 0);
			Mem_Idle_time2: in std_logic_vector(31 downto 0);
			perf_update: in std_logic;
			mem_data_in: in std_logic_vector(35 downto 0);
			mem_addr: in std_logic_vector(13 downto 0);
			mem_addr_en: in std_logic;
			mem_wr_en: in std_logic;
			mem_rd_en: in std_logic;
			in_qdr_phy_init_done: in std_logic;
			in_ddr_phy_init_done: in std_logic;
			in_ifpga0_up: in std_logic;
			in_ifpga1_up: in std_logic;
			in_ifpga2_up: in std_logic;
			in_ifpga3_up: in std_logic;
			in_ifpga4_up: in std_logic;
			mem_data_out: out std_logic_vector(35 downto 0);
			mem_ack: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal inst_ln12_perfmonitorext_mem_data_out : std_logic_vector(35 downto 0);
	signal inst_ln12_perfmonitorext_mem_ack : std_logic_vector(0 downto 0);
	signal inst_ln12_perfmonitorext_mem_addr1 : std_logic_vector(13 downto 0);
	signal inst_ln12_perfmonitorext_mem_addr_en1 : std_logic_vector(0 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	inst_ln12_perfmonitorext_mem_addr1 <= slice(perf_memories_memaddr, 0, 14);
	inst_ln12_perfmonitorext_mem_addr_en1 <= bool_to_vec((perf_memories_memid) = ("0000000000111011"));
	perf_memories_data_out <= inst_ln12_perfmonitorext_mem_data_out;
	perf_memories_ack <= vec_to_bit(inst_ln12_perfmonitorext_mem_ack);
	
	-- Register processes
	
	
	-- Entity instances
	
	inst_ln12_perfmonitorext : perf_monitor
		generic map (
			SHORT_COUNTER_MAX => 9999999,
			SHORT_COUNTER_BITS => 24,
			LONG_COUNTER_MAX => 99999999,
			LONG_COUNTER_BITS => 27,
			MODULE_VERSION => 3
		)
		port map (
			mem_data_out => inst_ln12_perfmonitorext_mem_data_out, -- 36 bits (out)
			mem_ack => inst_ln12_perfmonitorext_mem_ack(0), -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			rst => rst, -- 1 bits (in)
			in_active => active, -- 1 bits (in)
			in_ecc_flags => ecc_flags, -- 2 bits (in)
			in_ecc_parity => ecc_parity, -- 32 bits (in)
			in_ecc_corrected => ecc_corrected, -- 32 bits (in)
			Mem_Data_time1 => Mem_Data_time1, -- 32 bits (in)
			Mem_Data_time2 => Mem_Data_time2, -- 32 bits (in)
			Mem_Idle_time1 => Mem_Idle_time1, -- 32 bits (in)
			Mem_Idle_time2 => Mem_Idle_time2, -- 32 bits (in)
			perf_update => perf_update, -- 1 bits (in)
			mem_data_in => perf_memories_data_in, -- 36 bits (in)
			mem_addr => inst_ln12_perfmonitorext_mem_addr1, -- 14 bits (in)
			mem_addr_en => vec_to_bit(inst_ln12_perfmonitorext_mem_addr_en1), -- 1 bits (in)
			mem_wr_en => perf_memories_wren, -- 1 bits (in)
			mem_rd_en => perf_memories_rden, -- 1 bits (in)
			in_qdr_phy_init_done => qdr_phy_init_done, -- 1 bits (in)
			in_ddr_phy_init_done => ddr_phy_init_done, -- 1 bits (in)
			in_ifpga0_up => ifpga0_up, -- 1 bits (in)
			in_ifpga1_up => ifpga1_up, -- 1 bits (in)
			in_ifpga2_up => ifpga2_up, -- 1 bits (in)
			in_ifpga3_up => ifpga3_up, -- 1 bits (in)
			in_ifpga4_up => ifpga4_up -- 1 bits (in)
		);
end MaxDC;
