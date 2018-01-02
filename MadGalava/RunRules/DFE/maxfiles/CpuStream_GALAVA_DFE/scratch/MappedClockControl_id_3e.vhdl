library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity MappedClockControl_id_3e is
	port (
		cclk: in std_logic;
		rst: in std_logic;
		memories_data_in: in std_logic_vector(35 downto 0);
		memories_memid: in std_logic_vector(15 downto 0);
		memories_memaddr: in std_logic_vector(15 downto 0);
		memories_wren: in std_logic;
		memories_rden: in std_logic;
		memories_stop: in std_logic;
		pll_mgmt_readdata0: in std_logic_vector(31 downto 0);
		pll_mgmt_waitrequest0: in std_logic;
		pll_inst_locked0: in std_logic;
		memories_data_out: out std_logic_vector(35 downto 0);
		memories_ack: out std_logic;
		pll_mgmt_clk0: out std_logic;
		pll_mgmt_rst0: out std_logic;
		pll_mgmt_address0: out std_logic_vector(5 downto 0);
		pll_mgmt_read0: out std_logic;
		pll_mgmt_write0: out std_logic;
		pll_mgmt_writedata0: out std_logic_vector(31 downto 0);
		pll_rst0: out std_logic;
		clkbuf_clken0: out std_logic;
		clkbuf_clksel0: out std_logic_vector(1 downto 0)
	);
end MappedClockControl_id_3e;

architecture MaxDC of MappedClockControl_id_3e is
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
	component stream_clkprim_lock_count_32 is
		port (
			clkDst: in std_logic;
			lock: in std_logic;
			counter: out std_logic_vector(31 downto 0)
		);
	end component;
	component mapped_clock_control is
		generic (
			VERSION : integer;
			RECONFIG : boolean;
			PLL_CONF_N : integer;
			PLL_CONF_M : integer;
			PLL_CONF_C0 : integer;
			PLL_CONF_C1 : integer;
			PLL_CONF_C2 : integer;
			PLL_CONF_C3 : integer;
			CLOCK_SELECT : integer;
			NUM_CLOCKS : integer;
			CLOCK_ID : integer
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			mm_memaddr: in std_logic_vector(15 downto 0);
			mm_data_in: in std_logic_vector(35 downto 0);
			mm_wren: in std_logic;
			mm_rden: in std_logic;
			readdata: in std_logic_vector(31 downto 0);
			waitrequest: in std_logic;
			cc_reg_locked: in std_logic;
			cc_reg_locked_count: in std_logic_vector(31 downto 0);
			mm_data_out: out std_logic_vector(35 downto 0);
			mm_ack: out std_logic;
			address: out std_logic_vector(15 downto 0);
			read: out std_logic;
			write: out std_logic;
			writedata: out std_logic_vector(31 downto 0);
			cc_reg_pll_rst: out std_logic;
			cc_reg_pll_ce: out std_logic;
			cc_reg_clken: out std_logic;
			cc_reg_clksel: out std_logic_vector(1 downto 0)
		);
	end component;
	
	-- Signal declarations
	
	signal inst_ln15_plllockinstrumentation_counter : std_logic_vector(31 downto 0);
	signal inst_ln202_mappedclockcontrol_mm_data_out : std_logic_vector(35 downto 0);
	signal inst_ln202_mappedclockcontrol_mm_ack : std_logic_vector(0 downto 0);
	signal inst_ln202_mappedclockcontrol_address : std_logic_vector(15 downto 0);
	signal inst_ln202_mappedclockcontrol_read : std_logic_vector(0 downto 0);
	signal inst_ln202_mappedclockcontrol_write : std_logic_vector(0 downto 0);
	signal inst_ln202_mappedclockcontrol_writedata : std_logic_vector(31 downto 0);
	signal inst_ln202_mappedclockcontrol_cc_reg_pll_rst : std_logic_vector(0 downto 0);
	signal inst_ln202_mappedclockcontrol_cc_reg_pll_ce : std_logic_vector(0 downto 0);
	signal inst_ln202_mappedclockcontrol_cc_reg_clken : std_logic_vector(0 downto 0);
	signal inst_ln202_mappedclockcontrol_cc_reg_clksel : std_logic_vector(1 downto 0);
	signal inst_ln202_mappedclockcontrol_mm_wren1 : std_logic_vector(0 downto 0);
	signal inst_ln202_mappedclockcontrol_mm_rden1 : std_logic_vector(0 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	inst_ln202_mappedclockcontrol_mm_wren1 <= (bit_to_vec(memories_wren) and bool_to_vec((memories_memid) = ("0000000000111110")) and "1");
	inst_ln202_mappedclockcontrol_mm_rden1 <= (bit_to_vec(memories_rden) and bool_to_vec((memories_memid) = ("0000000000111110")) and "1");
	memories_data_out <= (inst_ln202_mappedclockcontrol_mm_data_out);
	memories_ack <= vec_to_bit((inst_ln202_mappedclockcontrol_mm_ack));
	pll_mgmt_clk0 <= vec_to_bit(bit_to_vec(cclk));
	pll_mgmt_rst0 <= vec_to_bit(bit_to_vec(rst));
	pll_mgmt_address0 <= slice(inst_ln202_mappedclockcontrol_address, 0, 6);
	pll_mgmt_read0 <= vec_to_bit(inst_ln202_mappedclockcontrol_read);
	pll_mgmt_write0 <= vec_to_bit(inst_ln202_mappedclockcontrol_write);
	pll_mgmt_writedata0 <= inst_ln202_mappedclockcontrol_writedata;
	pll_rst0 <= vec_to_bit(inst_ln202_mappedclockcontrol_cc_reg_pll_rst);
	clkbuf_clken0 <= vec_to_bit(inst_ln202_mappedclockcontrol_cc_reg_clken);
	clkbuf_clksel0 <= inst_ln202_mappedclockcontrol_cc_reg_clksel;
	
	-- Register processes
	
	
	-- Entity instances
	
	inst_ln15_plllockinstrumentation : stream_clkprim_lock_count_32
		port map (
			counter => inst_ln15_plllockinstrumentation_counter, -- 32 bits (out)
			clkDst => cclk, -- 1 bits (in)
			lock => pll_inst_locked0 -- 1 bits (in)
		);
	inst_ln202_mappedclockcontrol : mapped_clock_control
		generic map (
			VERSION => 1,
			RECONFIG => false,
			PLL_CONF_N => 1,
			PLL_CONF_M => 4,
			PLL_CONF_C0 => 10,
			PLL_CONF_C1 => 0,
			PLL_CONF_C2 => 0,
			PLL_CONF_C3 => 0,
			CLOCK_SELECT => 2,
			NUM_CLOCKS => 1,
			CLOCK_ID => 0
		)
		port map (
			mm_data_out => inst_ln202_mappedclockcontrol_mm_data_out, -- 36 bits (out)
			mm_ack => inst_ln202_mappedclockcontrol_mm_ack(0), -- 1 bits (out)
			address => inst_ln202_mappedclockcontrol_address, -- 16 bits (out)
			read => inst_ln202_mappedclockcontrol_read(0), -- 1 bits (out)
			write => inst_ln202_mappedclockcontrol_write(0), -- 1 bits (out)
			writedata => inst_ln202_mappedclockcontrol_writedata, -- 32 bits (out)
			cc_reg_pll_rst => inst_ln202_mappedclockcontrol_cc_reg_pll_rst(0), -- 1 bits (out)
			cc_reg_pll_ce => inst_ln202_mappedclockcontrol_cc_reg_pll_ce(0), -- 1 bits (out)
			cc_reg_clken => inst_ln202_mappedclockcontrol_cc_reg_clken(0), -- 1 bits (out)
			cc_reg_clksel => inst_ln202_mappedclockcontrol_cc_reg_clksel, -- 2 bits (out)
			clk => cclk, -- 1 bits (in)
			rst => rst, -- 1 bits (in)
			mm_memaddr => memories_memaddr, -- 16 bits (in)
			mm_data_in => memories_data_in, -- 36 bits (in)
			mm_wren => vec_to_bit(inst_ln202_mappedclockcontrol_mm_wren1), -- 1 bits (in)
			mm_rden => vec_to_bit(inst_ln202_mappedclockcontrol_mm_rden1), -- 1 bits (in)
			readdata => pll_mgmt_readdata0, -- 32 bits (in)
			waitrequest => pll_mgmt_waitrequest0, -- 1 bits (in)
			cc_reg_locked => pll_inst_locked0, -- 1 bits (in)
			cc_reg_locked_count => inst_ln15_plllockinstrumentation_counter -- 32 bits (in)
		);
end MaxDC;
