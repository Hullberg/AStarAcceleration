library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity SanityBlock_cclk_STREAM_clk_pcie is
	port (
		register_clk: in std_logic;
		register_in: in std_logic_vector(7 downto 0);
		register_rotate: in std_logic;
		register_stop: in std_logic;
		register_switch: in std_logic;
		rst_async: in std_logic;
		reset_n: in std_logic;
		clk_reset_n: in std_logic;
		crash_input: in std_logic;
		clk_crash_input: in std_logic;
		cclk: in std_logic;
		STREAM: in std_logic;
		clk_pcie: in std_logic;
		STREAM_rst: in std_logic;
		clk_STREAM_rst: in std_logic;
		STREAM_rst_delay: in std_logic;
		clk_STREAM_rst_delay: in std_logic;
		PCIE_rst: in std_logic;
		clk_PCIE_rst: in std_logic;
		PCIE_rst_delay: in std_logic;
		clk_PCIE_rst_delay: in std_logic;
		register_out: out std_logic_vector(7 downto 0)
	);
end SanityBlock_cclk_STREAM_clk_pcie;

architecture MaxDC of SanityBlock_cclk_STREAM_clk_pcie is
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
	component MappedRegBlock_2bbdde8c924fe59e82043c5c8fb8266c is
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
	end component;
	
	-- Signal declarations
	
	signal mappedregblock_i_register_out : std_logic_vector(7 downto 0);
	signal cclk_clock_counter : std_logic_vector(10 downto 0) := "00000000000";
	signal freq_counter_stop : std_logic_vector(0 downto 0);
	signal reg_async_reset : std_logic_vector(0 downto 0);
	signal STREAM_clock_counter : std_logic_vector(15 downto 0) := "0000000000000000";
	signal clk_pcie_clock_counter : std_logic_vector(15 downto 0) := "0000000000000000";
	signal reset_n_seen_reg : std_logic_vector(0 downto 0) := "0";
	signal STREAM_rst_seen_reg : std_logic_vector(0 downto 0) := "0";
	signal STREAM_rst_delay_seen_reg : std_logic_vector(0 downto 0) := "0";
	signal PCIE_rst_seen_reg : std_logic_vector(0 downto 0) := "0";
	signal PCIE_rst_delay_seen_reg : std_logic_vector(0 downto 0) := "0";
	signal crash_input_toggle_reg : std_logic_vector(0 downto 0) := "0";
	
	-- Attribute type declarations
	
	attribute keep : boolean;
	
	-- Attribute declarations
	
	attribute keep of freq_counter_stop : signal is true;
begin
	
	-- Assignments
	
	freq_counter_stop <= slice(cclk_clock_counter, 10, 1);
	reg_async_reset <= bit_to_vec(rst_async);
	register_out <= mappedregblock_i_register_out;
	
	-- Register processes
	
	reg_process : process(clk_reset_n)
	begin
		if rising_edge(clk_reset_n) then
			if slv_to_slv(bit_to_vec(reset_n)) = "1" then
				reset_n_seen_reg <= "1";
			end if;
		end if;
	end process;
	reg_process1 : process(clk_STREAM_rst)
	begin
		if rising_edge(clk_STREAM_rst) then
			if slv_to_slv(bit_to_vec(STREAM_rst)) = "1" then
				STREAM_rst_seen_reg <= "1";
			end if;
		end if;
	end process;
	reg_process2 : process(clk_STREAM_rst_delay)
	begin
		if rising_edge(clk_STREAM_rst_delay) then
			if slv_to_slv(bit_to_vec(STREAM_rst_delay)) = "1" then
				STREAM_rst_delay_seen_reg <= "1";
			end if;
		end if;
	end process;
	reg_process3 : process(clk_PCIE_rst)
	begin
		if rising_edge(clk_PCIE_rst) then
			if slv_to_slv(bit_to_vec(PCIE_rst)) = "1" then
				PCIE_rst_seen_reg <= "1";
			end if;
		end if;
	end process;
	reg_process4 : process(clk_PCIE_rst_delay)
	begin
		if rising_edge(clk_PCIE_rst_delay) then
			if slv_to_slv(bit_to_vec(PCIE_rst_delay)) = "1" then
				PCIE_rst_delay_seen_reg <= "1";
			end if;
		end if;
	end process;
	regproc_ln89_sanityblock : process(cclk, reg_async_reset)
	begin
		if reg_async_reset = "1" then
			cclk_clock_counter <= "00000000000";
		elsif rising_edge(cclk) then
			if slv_to_slv((not (freq_counter_stop or bool_to_vec((cclk_clock_counter) = ("11111111111"))))) = "1" then
				cclk_clock_counter <= (unsigned(cclk_clock_counter) + unsigned(slv_to_slv("00000000001")));
			end if;
		end if;
	end process;
	regproc_ln89_sanityblock1 : process(STREAM, reg_async_reset)
	begin
		if reg_async_reset = "1" then
			STREAM_clock_counter <= "0000000000000000";
		elsif rising_edge(STREAM) then
			if slv_to_slv((not (freq_counter_stop or bool_to_vec((STREAM_clock_counter) = ("1111111111111111"))))) = "1" then
				STREAM_clock_counter <= (unsigned(STREAM_clock_counter) + unsigned(slv_to_slv("0000000000000001")));
			end if;
		end if;
	end process;
	regproc_ln89_sanityblock2 : process(clk_pcie, reg_async_reset)
	begin
		if reg_async_reset = "1" then
			clk_pcie_clock_counter <= "0000000000000000";
		elsif rising_edge(clk_pcie) then
			if slv_to_slv((not (freq_counter_stop or bool_to_vec((clk_pcie_clock_counter) = ("1111111111111111"))))) = "1" then
				clk_pcie_clock_counter <= (unsigned(clk_pcie_clock_counter) + unsigned(slv_to_slv("0000000000000001")));
			end if;
		end if;
	end process;
	regproc_ln118_sanityblock : process(clk_crash_input, reg_async_reset)
	begin
		if reg_async_reset = "1" then
			crash_input_toggle_reg <= "0";
		elsif rising_edge(clk_crash_input) then
			if slv_to_slv(bit_to_vec(crash_input)) = "1" then
				crash_input_toggle_reg <= "1";
			end if;
		end if;
	end process;
	
	-- Entity instances
	
	MappedRegBlock_i : MappedRegBlock_2bbdde8c924fe59e82043c5c8fb8266c
		port map (
			register_out => mappedregblock_i_register_out, -- 8 bits (out)
			register_clk => register_clk, -- 1 bits (in)
			register_in => register_in, -- 8 bits (in)
			register_rotate => register_rotate, -- 1 bits (in)
			register_stop => register_stop, -- 1 bits (in)
			register_switch => register_switch, -- 1 bits (in)
			reg_clock_counters_base_clock_cclk => cclk_clock_counter, -- 11 bits (in)
			reg_clock_counters_STREAM => STREAM_clock_counter, -- 16 bits (in)
			reg_clock_counters_clk_pcie => clk_pcie_clock_counter, -- 16 bits (in)
			reg_seen_reset_reset_n => vec_to_bit(reset_n_seen_reg), -- 1 bits (in)
			reg_seen_reset_STREAM_rst => vec_to_bit(STREAM_rst_seen_reg), -- 1 bits (in)
			reg_seen_reset_STREAM_rst_delay => vec_to_bit(STREAM_rst_delay_seen_reg), -- 1 bits (in)
			reg_seen_reset_PCIE_rst => vec_to_bit(PCIE_rst_seen_reg), -- 1 bits (in)
			reg_seen_reset_PCIE_rst_delay => vec_to_bit(PCIE_rst_delay_seen_reg), -- 1 bits (in)
			reg_seen_toggle_crash_input => vec_to_bit(crash_input_toggle_reg) -- 1 bits (in)
		);
end MaxDC;
