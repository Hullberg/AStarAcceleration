--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Dual Aspect Mux Counter with Pipelined Output
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Maxeler Technologies Inc
--   Copyright 2009. All rights reserved.
--   Author: C.E.D.
--   Date Originated: Nov 23, 2009
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Description:
--   Slices input data of vector length N in time into
-- output data of size M where N > M and N is an integer
-- multiple of M, this is the aspect ratio K. It takes
-- K cycles + pipeline latency to produce the entire
-- length N on the output. Pipeline latency is added
-- to improve timing.
--
-- Limitations:
--    This design currently only supports aspect ratios
-- that are power of 2.
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.textio.all;

entity dualaspectmuxpipe_counter is
  generic (
    G_CNT_THRESHOLD : integer := 1;
    G_NUM_STAGES   : integer := 1;
    G_ASPECT_LOG2  : integer := 1
  );
  port (
    clk : in std_logic;
    rst : in std_logic;

    input_empty : in std_logic;
    input_read : out std_logic;
    input_done  : in std_logic;

    count : out std_logic_vector(G_ASPECT_LOG2-1 downto 0);

    output_stall : in std_logic;
    output_valid : out std_logic;
    output_done  : out std_logic

  );

  attribute keep_hierarchy : string;
end dualaspectmuxpipe_counter;

architecture rtl of dualaspectmuxpipe_counter is

  attribute keep_hierarchy of rtl : architecture is "false";

  signal count_int : std_logic_vector(G_ASPECT_LOG2-1 downto 0) := (others => '0');

  -- FIXME!! This blanket fanout constraint may bite us in the backside for most designs as it will burn more logic. It's implemented here
  -- to target the designs that max out logic already in the FPGA as part of a general strategy to improve timing by targeting all paths with
  -- high fanout. An idea here would be to make two architectures, one for the default normal case and one for the fanout constrained case.
  -- A generic could select the right architecture to use via a configuration declaration that is enabled from the parent Java class.
  attribute max_fanout : string;
  attribute max_fanout of count_int : signal is "100";

  type state_t is (RESET_STATE, INPUT_READ_STATE); 

  signal state : state_t := RESET_STATE;

  signal read_ok : std_logic := '0';
  signal count_wrap : std_logic := '0';
  signal count_en : std_logic := '0';
  signal count_done : std_logic := '0';

  type mux_stages is record
    mux4 : natural;
    mux2 : natural;
  end record;
 
  signal rd_vld : std_logic;
  signal reg_vld : std_logic_vector(G_NUM_STAGES-1 downto 0);

begin

  read_ok <= not (input_empty or output_stall); 

  -- state machine next state
  next_state : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        state <= RESET_STATE;
      else
        case state is
          when RESET_STATE =>
            if read_ok = '1' then
              state <= INPUT_READ_STATE;
            end if;
          when INPUT_READ_STATE =>
            if count_wrap = '1' then
              if read_ok = '1' then
                state <= INPUT_READ_STATE;
              else
                state <= RESET_STATE;
              end if;
            end if;  
        end case; 
      end if;
    end if;
  end process;

  -- state machine outputs
  outputs : process(state, output_stall, read_ok, count_wrap)
  begin
    case state is
      when RESET_STATE =>
        count_en <= count_wrap and (not output_stall); 
        input_read <= read_ok;
        rd_vld <= count_wrap and (not output_stall);
        count_done <= '1';
      when INPUT_READ_STATE =>
        input_read <= read_ok and count_wrap;
        count_en <= not output_stall;
        rd_vld <= not output_stall;
	    count_done <= '0';
    end case; 
  end process;
 
  -- counter
  counter : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        count_int <= (others => '0');  
      elsif count_en = '1' then
        if count_wrap = '1' then
          count_int <= (others => '0');
        else
          count_int <= std_logic_vector(unsigned(count_int) + 1);
        end if;
      end if;
    end if;
  end process; 

  gen_done : process(clk)
  begin
    if rising_edge(clk) then
       if count_done = '1' and unsigned(reg_vld) = 0 and input_done = '1' then
         output_done <= '1';
       else
         output_done <= '0';
       end if;
    end if;
  end process;

  count_wrap <= '1' when unsigned(count_int) = G_CNT_THRESHOLD-1 else '0';

  count <= count_int;
  reg_vld(0) <= rd_vld;

  g_reg_dly : if G_NUM_STAGES > 1 generate
  begin
    g_pipe_stages : for i in 1 to G_NUM_STAGES-1 generate
    begin
        p_vld : process(clk)
        begin
          if rising_edge(clk) then
            if rst = '1' then
              reg_vld(i) <= '0';
            else
              if output_stall = '0' then
                reg_vld(i) <= reg_vld(i-1);
              end if;
            end if;
          end if;
       end process;
    end generate;
  end generate;

  p_vld_out : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        output_valid <= '0';
      else
        output_valid <= reg_vld(G_NUM_STAGES-1) and not(output_stall); --workaround Xilinx inferring SR of FF should be OR of rst
	-- and output_stall
      end if;
    end if;
  end process;

end rtl;
