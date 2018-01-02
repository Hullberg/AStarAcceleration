--------------------------------------------------------------
-- Assert a reset for a number of cycles. Also assert
-- a delayed reset pulse of 4 cycles
--------------------------------------------------------------
--                  _____________________________________
-- reset_out : ____|                                     |____
--                                            ____
-- reset_late: ______________________________|    |___________
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reset_control is
  generic (
    LOG2_RESET_CYCLES : integer := 5    -- MUST be >= 4
    );
  port (
    rst_n            : in  std_logic;
    reset_clk        : in  std_logic;
    reset_toggle     : in  std_logic;
    reset_out        : out std_logic;
    reset_late_pulse : out std_logic
    ); 
end reset_control;

architecture rtl of reset_control is

  attribute altera_attribute : string;
  attribute dont_merge: boolean;
  attribute KEEP : string;
  
  signal reset_count         : std_logic_vector(LOG2_RESET_CYCLES-1 downto 0) := (others => '0');
  --signal reset_toggle_sync   : std_logic_vector(2 downto 0)                   := (others => '0');
  --signal rst_n_sync        : std_logic_vector(1 downto 0) := (others => '0');
  signal reset_toggle_sync_2 : std_logic                                      := '0';
  signal reset_toggle_sync_1 : std_logic                                      := '0';
  signal reset_toggle_sync_0 : std_logic                                      := '0';

  attribute altera_attribute of reset_toggle_sync_0 : signal is "-name SYNCHRONIZER_IDENTIFICATION ""FORCED IF ASYNCHRONOUS""; -name SDC_STATEMENT ""set_false_path -to [get_registers {*reset_toggle_sync_0}]""";
  attribute dont_merge of reset_toggle_sync_0       : signal is true;
  attribute KEEP of reset_toggle_sync_0             : signal is "true";

  --attribute shreg_extract                      : string;
  --attribute shreg_extract of reset_toggle_sync : signal is "no";

  type   state_t is (RESET_STATE, RUN_STATE);
  signal state : state_t := RESET_STATE;

  signal reset_toggle_sm : std_logic;

  constant all_ones : std_logic_vector(LOG2_RESET_CYCLES-1 downto 0) := (others => '1');
  
begin
  
  SYNC_TOGGLE :
  process(rst_n, reset_clk)
  begin
    if (rst_n = '0') then
      -- reset_toggle_sync <= (others => '0');

      reset_toggle_sync_0 <= '0';
      reset_toggle_sync_1 <= '0';
      reset_toggle_sync_2 <= '0';
      
    elsif rising_edge(reset_clk) then
      
      --reset_toggle_sync(0) <= reset_toggle;
      --reset_toggle_sync(1) <= reset_toggle_sync(0);
      --reset_toggle_sync(2) <= reset_toggle_sync(1);

      reset_toggle_sync_0 <= reset_toggle;
      reset_toggle_sync_1 <= reset_toggle_sync_0;
      reset_toggle_sync_2 <= reset_toggle_sync_1;
      
    end if;
  end process;

  -- reset_toggle_sm <= reset_toggle_sync(2) xor reset_toggle_sync(1);
  reset_toggle_sm <= reset_toggle_sync_2 xor reset_toggle_sync_1;
  
  GENRESET :
  process(rst_n, reset_clk)
  begin
    if (rst_n = '0') then
      state            <= RESET_STATE;
      reset_count      <= (others => '0');
      reset_out        <= '1';
      reset_late_pulse <= '0';
    elsif rising_edge(reset_clk) then
      case state is
        when RESET_STATE =>
          reset_out   <= '1';
          reset_count <= std_logic_vector(unsigned(reset_count) + 1);
          if (reset_count = all_ones) then
            state <= RUN_STATE;
          end if;
          if reset_count(reset_count'high downto 3) = all_ones(reset_count'high downto 3) and reset_count(2) = '0' then
            reset_late_pulse <= '1';
          else
            reset_late_pulse <= '0';
          end if;
        when RUN_STATE =>
          reset_out        <= '0';
          reset_late_pulse <= '0';
          reset_count      <= (others => '0');
          if (reset_toggle_sm = '1') then
            state <= RESET_STATE;
          end if;
      end case;
    end if;
  end process;
  
end rtl;
