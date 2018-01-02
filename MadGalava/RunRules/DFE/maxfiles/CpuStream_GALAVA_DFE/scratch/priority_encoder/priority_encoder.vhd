library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- synthesis translate_off
LIBRARY lpm;
USE lpm.all;
-- synthesis translate_on

entity priority_encoder is
  generic (
    NUM_REQUESTERS       : integer := 16;
    NUM_REQUESTERS_WIDTH : integer := 4
  );
  port (
      clk             : in std_logic;
      rst             : in std_logic;

      requests_valid    : in std_logic;
      requests         : in std_logic_vector(NUM_REQUESTERS-1 downto 0);
      priority_index    : in std_logic_vector(NUM_REQUESTERS_WIDTH-1 downto 0);

      results        : out std_logic_vector(NUM_REQUESTERS-1 downto 0);
    results_valid    : out std_logic
  );
end priority_encoder;

architecture rtl of priority_encoder is
  function rotate_right(x : std_logic_vector; index : integer) return std_logic_vector is
  variable v : std_logic_vector((x'length - 1) downto 0);
  variable m : integer;
    begin
    for i in 0 to (x'length - 1) loop
      m := index + i;
      if (m >= x'length) then
        m := m - x'length;
      end if;
      v(i) := x(m);
        end loop;
    return v;
    end;

  function rotate_left(x : std_logic_vector; index : integer) return std_logic_vector is
  variable v : std_logic_vector((x'length - 1) downto 0);
  variable m : integer;
    begin
    for i in 0 to (x'length - 1) loop
      m := index + i;
      if (m >= x'length) then
        m := m - x'length;
      end if;
      v(m) := x(i);
        end loop;
    return v;
    end;

    component lpm_clshift
    generic (
        lpm_shifttype  : STRING;
        lpm_type       : STRING;
        lpm_width      : NATURAL;
        lpm_widthdist  : NATURAL
    );
    port (
        data           : in  std_logic_vector(lpm_width-1 downto 0);
        direction      : in  std_logic;
        distance       : in  std_logic_vector(lpm_widthdist-1 downto 0);
        result         : out std_logic_vector(lpm_width-1 downto 0)
    );
    end component;

--  -- for 0 to 9 the obvious mapping is used, higher
--  -- values are mapped to the characters A-Z
--  -- (this is usefull for systems with base > 10)
--  -- (adapted from Steve Vogwell's posting in comp.lang.vhdl)
--
--  function chr(int: integer) return character is
--   variable c: character;
--  begin
--       case int is
--         when  0 => c := '0';
--         when  1 => c := '1';
--         when  2 => c := '2';
--         when  3 => c := '3';
--         when  4 => c := '4';
--         when  5 => c := '5';
--         when  6 => c := '6';
--         when  7 => c := '7';
--         when  8 => c := '8';
--         when  9 => c := '9';
--         when 10 => c := 'A';
--         when 11 => c := 'B';
--         when 12 => c := 'C';
--         when 13 => c := 'D';
--         when 14 => c := 'E';
--         when 15 => c := 'F';
--         when 16 => c := 'G';
--         when 17 => c := 'H';
--         when 18 => c := 'I';
--         when 19 => c := 'J';
--         when 20 => c := 'K';
--         when 21 => c := 'L';
--         when 22 => c := 'M';
--         when 23 => c := 'N';
--         when 24 => c := 'O';
--         when 25 => c := 'P';
--         when 26 => c := 'Q';
--         when 27 => c := 'R';
--         when 28 => c := 'S';
--         when 29 => c := 'T';
--         when 30 => c := 'U';
--         when 31 => c := 'V';
--         when 32 => c := 'W';
--         when 33 => c := 'X';
--         when 34 => c := 'Y';
--         when 35 => c := 'Z';
--         when others => c := '?';
--       end case;
--       return c;
--   end chr;
--  -- convert integer to string using specified base
--  -- (adapted from Steve Vogwell's posting in comp.lang.vhdl)
--
--  function str(int: integer; base: integer) return string is
--
--   variable temp:      string(1 to 10);
--   variable num:       integer;
--   variable abs_int:   integer;
--   variable len:       integer := 1;
--   variable power:     integer := 1;
--
--  begin
--
--   -- bug fix for negative numbers
--   abs_int := abs(int);
--
--   num     := abs_int;
--
--   while num >= base loop                     -- Determine how many
--     len := len + 1;                          -- characters required
--     num := num / base;                       -- to represent the
--   end loop ;                                 -- number.
--
--   for i in len downto 1 loop                 -- Convert the number to
--     temp(i) := chr(abs_int/power mod base);  -- a string starting
--     power := power * base;                   -- with the right hand
--   end loop ;                                 -- side.
--
--   -- return result and add sign if required
--   if int < 0 then
--      return '-'& temp(1 to len);
--    else
--      return temp(1 to len);
--   end if;
--
--  end str;
--   -- convert integer to string, using base 10
--   function str(int: integer) return string is
--
--   begin
--
--    return str(int, 10) ;
--
--    end str;

  signal requests_shifted_s        : std_logic_vector(NUM_REQUESTERS-1 downto 0);
  signal requests_shifted_n_inc    : std_logic_vector(NUM_REQUESTERS-1 downto 0);
  signal requests_shifted          : std_logic_vector(NUM_REQUESTERS-1 downto 0) := (others => '0');
  signal result                    : std_logic_vector(NUM_REQUESTERS-1 downto 0) := (others => '0');
  signal results_shifted_s         : std_logic_vector(NUM_REQUESTERS-1 downto 0);
  signal results_shifted           : std_logic_vector(NUM_REQUESTERS-1 downto 0) := (others => '0');
  signal priority_index_u          : unsigned(NUM_REQUESTERS_WIDTH-1 downto 0);
  signal priority_index_u_r        : unsigned(NUM_REQUESTERS_WIDTH-1 downto 0);
  signal priority_index_u_rr       : unsigned(NUM_REQUESTERS_WIDTH-1 downto 0);
  signal requests_valid_r          : std_logic := '0';
  signal requests_valid_rr         : std_logic := '0';

begin

    priority_index_u <= unsigned(priority_index);
    requests_shifted_n_inc <= std_logic_vector(unsigned(not(requests_shifted)) + 1);

    GEN_SHIFT_ALTERA : if (NUM_REQUESTERS>1) generate
    begin
      shift_req : lpm_clshift
      generic map (
        lpm_shifttype  => "ROTATE",
        lpm_type       => "LPM_CLSHIFT",
        lpm_width      => NUM_REQUESTERS,
        lpm_widthdist  => NUM_REQUESTERS_WIDTH
      ) port map (
        data           => requests,
        direction      => '1', -- right
        distance       => priority_index,
        result         => requests_shifted_s
      );

      shift_res : lpm_clshift
      generic map (
        lpm_shifttype  => "ROTATE",
        lpm_type       => "LPM_CLSHIFT",
        lpm_width      => NUM_REQUESTERS,
        lpm_widthdist  => NUM_REQUESTERS_WIDTH
      ) port map (
        data           => result,
        direction      => '0', -- left
        distance       => std_logic_vector(priority_index_u_rr),
        result         => results_shifted_s
      );
    end generate;
    
    GEN_SHIFT_CONST : if NUM_REQUESTERS=1 generate
      requests_shifted_s <= requests;
      results_shifted_s  <= result;
    end generate;

    process (clk)
    begin
    if rising_edge(clk) then
      priority_index_u_r  <= priority_index_u;
      priority_index_u_rr <= priority_index_u_r;

       requests_shifted   <= requests_shifted_s;
       results_shifted    <= results_shifted_s;
       result             <= requests_shifted_n_inc and requests_shifted;

      if rst = '1' then
        requests_valid_r  <= '0';
        requests_valid_rr <= '0';
        results_valid     <= '0';
      else
        requests_valid_r  <= requests_valid;
        requests_valid_rr <= requests_valid_r;
        results_valid     <= requests_valid_rr;
      end if;
    end if;
    end process;

    results <= results_shifted;

end rtl;
