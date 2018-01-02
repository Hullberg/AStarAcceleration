library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mapped_clock_control is
generic (
	VERSION      : integer;
	RECONFIG	 : boolean;
	PLL_CONF_N   : integer;
	PLL_CONF_M   : integer;
	PLL_CONF_C0  : integer;
	PLL_CONF_C1  : integer;
	PLL_CONF_C2  : integer;
	PLL_CONF_C3  : integer;
	CLOCK_SELECT : integer;
	NUM_CLOCKS   : integer;
	CLOCK_ID     : integer
);
port (
	-- Common clock
	clk : in std_logic;
	rst : in std_logic;

	-- Mapped Memories Interface
	mm_memaddr  : in  std_logic_vector(15 downto 0);
	mm_data_in  : in  std_logic_vector(35 downto 0);
	mm_data_out : out std_logic_vector(35 downto 0);
	mm_wren     : in  std_logic;
	mm_rden     : in  std_logic;
	mm_ack      : out std_logic;
	
    -- Avalon MM Slave Interface 
    address		: out std_logic_vector(15 downto 0);
    read		: out std_logic;
    readdata	: in std_logic_vector(31 downto 0);
    write		: out std_logic;
    writedata	: out std_logic_vector(31 downto 0);
    waitrequest	: in std_logic;

	-- Clock control registers
	cc_reg_pll_rst      : out std_logic;
	cc_reg_pll_ce       : out std_logic;
	cc_reg_clken        : out std_logic;
	cc_reg_clksel       : out std_logic_vector(1 downto 0);
	cc_reg_locked       : in  std_logic;
	cc_reg_locked_count : in std_logic_vector(31 downto 0)
);
end mapped_clock_control;

architecture rtl of mapped_clock_control is

	signal cc_reg_pll_rst_i : std_logic;
	signal cc_reg_pll_ce_i  : std_logic;
	signal cc_reg_clken_i   : std_logic;
	signal cc_reg_clksel_i  : std_logic_vector(1 downto 0);

	signal write_i     : std_logic;
	signal read_i      : std_logic;
	signal read_data_i : std_logic_vector(31 downto 0);
	
	signal pll_write   : std_logic;
	signal pll_read    : std_logic;
	signal pll_done    : std_logic;

begin

	cc_reg_pll_rst <= cc_reg_pll_rst_i;
	cc_reg_pll_ce  <= cc_reg_pll_ce_i;
	cc_reg_clken   <= cc_reg_clken_i;
	cc_reg_clksel  <= cc_reg_clksel_i;
	
	address <= mm_memaddr;
	writedata <= mm_data_in(31 downto 0);
	write <= pll_write;
	read <= pll_read;

	NONRECONFIG_READ: if (RECONFIG = false) generate 
	begin
		-- Write
		p_write: process(clk)
		begin
			if rising_edge(clk) then
				pll_write <= '0';
				if rst = '1' then
					write_i <= '0';
					cc_reg_pll_rst_i <= '0';
					cc_reg_pll_ce_i  <= '0';
					cc_reg_clken_i   <= '1';
					cc_reg_clksel_i  <= std_logic_vector(to_unsigned(CLOCK_SELECT, 2));
				elsif mm_wren = '1' then
					write_i <= '1';
					case mm_memaddr(6 downto 0) is
					when "1000000" =>
						cc_reg_pll_rst_i <= mm_data_in(0);
					when "1000001" =>
						cc_reg_pll_ce_i <= mm_data_in(0);
					when "1000010" =>
						cc_reg_clken_i <= mm_data_in(0);
					when "1000011" =>
						cc_reg_clksel_i <= mm_data_in(1 downto 0);
					when others =>
						null;
					end case;
				else
					write_i <= '0';
				end if;
			end if;
		end process;
	
		-- Read
		p_read: process(clk)
		begin
			if rising_edge(clk) then
				pll_read <= '0';
				if rst = '1' then
					read_i <= '0';
					read_data_i <= (others => '0');
				elsif mm_rden = '1' then
					read_i <= '1';
					case mm_memaddr(6 downto 0) is
					-- PLL configuation (read-only)
					when "0000000" =>
						read_data_i <= std_logic_vector(to_unsigned(VERSION, 32));
					when "0000001" =>
						read_data_i <= std_logic_vector(to_unsigned(PLL_CONF_N, 32));
					when "0000010" =>
						read_data_i <= std_logic_vector(to_unsigned(PLL_CONF_M, 32));
					when "0000011" =>
						read_data_i <= std_logic_vector(to_unsigned(PLL_CONF_C0, 32));
					when "0000100" =>
						read_data_i <= std_logic_vector(to_unsigned(PLL_CONF_C1, 32));
					when "0000101" =>
						read_data_i <= std_logic_vector(to_unsigned(PLL_CONF_C2, 32));
					when "0000110" =>
						read_data_i <= std_logic_vector(to_unsigned(PLL_CONF_C3, 32));
					when "0000111" =>
						read_data_i <= std_logic_vector(to_unsigned(CLOCK_SELECT, 32));
					when "0010000" =>
						read_data_i <= std_logic_vector(to_unsigned(0, 32));	-- dynamic reconfig pll is disabled
					when "0010001" =>
						read_data_i <= std_logic_vector(to_unsigned(NUM_CLOCKS, 32));
					when "0010010" =>
						read_data_i <= std_logic_vector(to_unsigned(CLOCK_ID, 32));
					-- Clock control registers
					when "1000000" =>
						read_data_i <= "000" & x"0000000" & cc_reg_pll_rst_i;
					when "1000001" =>
						read_data_i <= "000" & x"0000000" & cc_reg_pll_ce_i;
					when "1000010" =>
						read_data_i <= "000" & x"0000000" & cc_reg_clken_i;
					when "1000011" =>
						read_data_i <= "00" & x"0000000" & cc_reg_clksel_i;
					when "1000100" =>
						read_data_i <= "000" & x"0000000" & cc_reg_locked;
					when "1000101" =>
						read_data_i <= cc_reg_locked_count;
					when others =>
						read_data_i <= (others => '0');
						null;
					end case;
				else
					read_i <= '0';
					read_data_i <= (others => '0');
				end if;
			end if;
		end process;
	end generate;
	
	RECONFIG_READ: if (RECONFIG = true) generate 
	begin
		-- Write
		p_write: process(clk)
		begin
			if rising_edge(clk) then
				if rst = '1' then
					pll_write <= '0';
					write_i <= '0';
					cc_reg_pll_rst_i <= '0';
					cc_reg_pll_ce_i  <= '0';
					cc_reg_clken_i   <= '1';
					cc_reg_clksel_i  <= std_logic_vector(to_unsigned(CLOCK_SELECT, 2));
				elsif mm_wren = '1' then
					if mm_memaddr(7) = '1' then
						if (cc_reg_pll_ce_i = '1' and cc_reg_clken_i = '0') then
							pll_write <= '1';
						else
							pll_write <= '0';
						end if;
						write_i <= '0';
					else
						pll_write <= '0';
						write_i <= '1';
						case mm_memaddr(6 downto 0) is
						when "1000000" =>
							cc_reg_pll_rst_i <= mm_data_in(0);
						when "1000001" =>
							cc_reg_pll_ce_i <= mm_data_in(0);
						when "1000010" =>
							cc_reg_clken_i <= mm_data_in(0);
						when "1000011" =>
							cc_reg_clksel_i <= mm_data_in(1 downto 0);
						when others =>
							null;
						end case;
					end if;
				elsif (pll_write = '1' and waitrequest = '0') then
					pll_write <= '0';
				else
					write_i <= '0';
				end if;
			end if;
		end process;
		
		-- Read
		p_read: process(clk)
		begin
			if rising_edge(clk) then
				if rst = '1' then
					pll_read <= '0';
					read_i <= '0';
					read_data_i <= (others => '0');
				elsif mm_rden = '1' then
					if mm_memaddr(7) = '1' then
						pll_read <= '1';
					else
						read_i <= '1';
						case mm_memaddr(6 downto 0) is
						-- PLL configuation (read-only)
						when "0000000" =>
							read_data_i <= std_logic_vector(to_unsigned(VERSION, 32));
						when "0000001" =>
							read_data_i <= std_logic_vector(to_unsigned(PLL_CONF_N, 32));
						when "0000010" =>
							read_data_i <= std_logic_vector(to_unsigned(PLL_CONF_M, 32));
						when "0000011" =>
							read_data_i <= std_logic_vector(to_unsigned(PLL_CONF_C0, 32));
						when "0000100" =>
							read_data_i <= std_logic_vector(to_unsigned(PLL_CONF_C1, 32));
						when "0000101" =>
							read_data_i <= std_logic_vector(to_unsigned(PLL_CONF_C2, 32));
						when "0000110" =>
							read_data_i <= std_logic_vector(to_unsigned(PLL_CONF_C3, 32));
						when "0000111" =>
							read_data_i <= std_logic_vector(to_unsigned(CLOCK_SELECT, 32));
						when "0010000" =>
							read_data_i <= std_logic_vector(to_unsigned(1, 32));	-- dynamic reconfig pll is enabled
						when "0010001" =>
							read_data_i <= std_logic_vector(to_unsigned(NUM_CLOCKS, 32));
						when "0010010" =>
							read_data_i <= std_logic_vector(to_unsigned(CLOCK_ID, 32));
						-- Clock control registers
						when "1000000" =>
							read_data_i <= "000" & x"0000000" & cc_reg_pll_rst_i;
						when "1000001" =>
							read_data_i <= "000" & x"0000000" & cc_reg_pll_ce_i;
						when "1000010" =>
							read_data_i <= "000" & x"0000000" & cc_reg_clken_i;
						when "1000011" =>
							read_data_i <= "00" & x"0000000" & cc_reg_clksel_i;
						when "1000100" =>
							read_data_i <= "000" & x"0000000" & cc_reg_locked;
						when "1000101" =>
							read_data_i <= cc_reg_locked_count;
						when others =>
							read_data_i <= (others => '0');
						end case;
					end if;
				elsif (pll_read = '1' and waitrequest = '0') then
					pll_read <= '0';
				else
					read_i <= '0';
					read_data_i <= (others => '0');
				end if;
			end if;
		end process;
	end generate;
	
	-- Ack
	p_mm_ack: process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				pll_done <= '0';
				mm_ack <= '0';
				mm_data_out <= (others => '0');
			elsif pll_done = '1' then
				pll_done <= '0';
				mm_ack <= '1';
				mm_data_out <= "0000" & readdata;
			elsif (pll_write='1' or pll_read='1') and waitrequest='0' then
				pll_done <= '1';
				mm_ack <= '0';
			else
				mm_ack <= read_i or write_i;
				mm_data_out <= "0000" & read_data_i;
			end if;
		end if;
	end process;

end rtl;
