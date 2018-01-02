library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity dualaspectreg_int is
  generic (
    INPUT_WIDTH : integer := 0;
    COUNT_MAX : integer := 0;
    COUNT_BITS : integer :=0    
  );
  port (
    clk : in std_logic;
    rst : in std_logic;
    input_empty : in std_logic;
    input_read : out std_logic;
    input_data : in std_logic_vector(INPUT_WIDTH-1 downto 0);
    output_empty : out std_logic;
    output_read : in std_logic;
    output_data : out std_logic_vector(INPUT_WIDTH*(COUNT_MAX+1)-1 downto 0)
  );

  attribute keep_hierarchy : string;
end dualaspectreg_int;

architecture rtl of dualaspectreg_int is

  attribute keep_hierarchy of rtl : architecture is "false";

  signal data_reg : std_logic_vector(INPUT_WIDTH*(COUNT_MAX+1)-1 downto 0) := (others => '0');

  signal count_int, count_next : std_logic_vector(COUNT_BITS-1 downto 0) := conv_std_logic_vector(COUNT_MAX, COUNT_BITS);
  signal count_en, count_wrap : std_logic := '0';

  signal input_read_r, input_read_int : std_logic := '0';
 
  attribute max_fanout : string;
  attribute max_fanout of input_read_r : signal is "10";

begin


  -- Outputs
  input_read <= input_read_int;
  output_data <= data_reg;

  -- We are empty, unless we have an almost full register, and the input is not
  -- empty
  output_empty <= input_empty when count_int = conv_std_logic_vector(COUNT_MAX-1, COUNT_BITS) else
                  '1';

  -- Read until we have a mostly full register, then let the output take control
  input_read_int <= output_read when count_int = conv_std_logic_vector(COUNT_MAX-1, COUNT_BITS) else
                    not input_empty;

  -- Count every time we read
  count_en <= input_read_int;

  -- The data reg actually contains the output from the input stream, not
  -- registered here to maintain efficiency (100% utilisation)
  data_reg(data_reg'left downto 1+data_reg'left-INPUT_WIDTH) <= input_data;


  -- Register the remaining bits of the data, in a shift-right fashion to make
  -- sure the word alignment is correct
  reginput : process(clk)
  variable i : integer;
  begin
    if rising_edge(clk) then
      input_read_r <= input_read_int;
      if input_read_r = '1' then
        data_reg(data_reg'left-INPUT_WIDTH downto data_reg'right)
          <= data_reg(data_reg'left downto data_reg'right+INPUT_WIDTH);
      end if;
    end if;
  end process;

  -- This counter tells us how many of the words in the output word are valid
  counter : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        count_int <= conv_std_logic_vector(COUNT_MAX, COUNT_BITS);
      elsif count_en = '1' then
      	count_int <= count_next;
      end if;
    end if;
  end process; 

  -- Try to infer a MUX and leave rst as the R input on the counter flop (streamrst is routed on a global net)
  count_next <= (others => '0') when count_int = conv_std_logic_vector(COUNT_MAX, COUNT_BITS) else 
  		unsigned(count_int) + 1;

end rtl;
