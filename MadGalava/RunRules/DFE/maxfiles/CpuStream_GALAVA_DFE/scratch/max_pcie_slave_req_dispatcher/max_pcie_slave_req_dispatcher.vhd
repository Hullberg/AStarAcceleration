------------------------------------------------------------------
-- Slave PCIe request interface for streaming (existing alongside max_pcie_slave.vhd)
-- Copyright 2011 Maxeler Technologies Inc. All Rights Reserved
-- Author : thibaut
------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity max_pcie_slave_req_dispatcher is
  generic (
    NUM_STREAMS_TO_HOST	    : integer := 1;
    NUM_STREAMS_FROM_HOST   : integer := 1;
    NUM_STREAM_BIT_WIDTH       : integer := 1;     -- ceiling(log2(NUM_STREAMS_TO_HOST+NUM_STREAMS_FROM_HOST))
    STREAM_ADDR_SEGMENT_BIT_WIDTH : integer := 13  -- Max address segment bit width for streams in this BA space (for spacing the mappin of the buffers)
  );
  port (
    clk_pcie : in std_logic;
    rst_pcie_n : in std_logic;

    sl_en : in std_logic;	-- Asserted when this Base Address space is hit for read or write

    -- Slave RX interface (coming from DMA RX Unit)
    -- Write requests
    sl_wr_en : in std_logic;
    sl_wr_addr  : in std_logic_vector(63 downto 0); -- read/write address, dword aligned - For writes, will increase during the transfer
    sl_wr_size  : in std_logic_vector(9 downto 0);  -- size of read or write, in multiples of dword - For writes, will not decrease during the xfer
    sl_wr_data : in std_logic_vector(127 downto 0); -- data (write case only)
    sl_wr_be   : in std_logic_vector(15 downto 0);  -- dword byte enable
    sl_wr_last : in std_logic;                      -- aserted when the last octaword of data is transmitted
    -- Read requests
    sl_rd_en    : in std_logic;
    sl_rd_tc    : in std_logic_vector(2 downto 0); -- TC
    sl_rd_td    : in std_logic; -- TD
    sl_rd_ep    : in std_logic; -- EP
    sl_rd_attr  : in std_logic_vector(1 downto 0); -- attribute
    sl_rd_rid   : in std_logic_vector(15 downto 0); -- requestor ID
    sl_rd_tag   : in std_logic_vector(7 downto 0); -- tag
    sl_rd_be    : in std_logic_vector(7 downto 0); -- Byte enables (7 downto 4: Last dword BE, 3 downto 0: First dword BE)
    sl_rd_addr  : in std_logic_vector(63 downto 0);
    sl_rd_size  : in std_logic_vector(9 downto 0);

    -- Interface to SFH slave streaming managers. SFH manager can't push back
    sfh_wren        : out std_logic_vector(NUM_STREAMS_FROM_HOST-1 downto 0);	-- Asserted during the whole length of the transfer
    sfh_write_addr  : out std_logic_vector(STREAM_ADDR_SEGMENT_BIT_WIDTH-1 downto 0); -- Write address, dword aligned, will increase during the transfer
    sfh_write_size  : out std_logic_vector(9 downto 0);   -- size of write, in multiples of dword (will not decrease during the xfer)
    sfh_write_data  : out std_logic_vector(127 downto 0); -- write data, valid each time sfh_wren is asserted
    sfh_write_be    : out std_logic_vector(15 downto 0);  -- byte enable for write_data
    sfh_write_last  : out std_logic;                      -- asserted for the last octaword of data

    -- Interface to STH slave streaming managers.
    sth_rden         : out std_logic_vector(NUM_STREAMS_TO_HOST-1 downto 0); -- Asserted for one cycle alongside the following signals
    sth_read_addr    : out std_logic_vector(STREAM_ADDR_SEGMENT_BIT_WIDTH-1 downto 0); -- read address within the STH memory segment (dword aligned)
    sth_read_size    : out std_logic_vector(9 downto 0);  -- size of read
    sth_read_metadata: out std_logic_vector(30 downto 0); -- metadata needed to send the completion to host
    sth_read_be      : out std_logic_vector(7 downto 0)   -- lastbe & firstbe for this read request
  );

 attribute keep_hierarchy : string;
end max_pcie_slave_req_dispatcher;

architecture rtl of max_pcie_slave_req_dispatcher is

  attribute keep_hierarchy of rtl: architecture is "soft";

begin

  -- Generate signals for interface to SFH slave manager (write requests)
  process(clk_pcie, rst_pcie_n)
  begin
    if rst_pcie_n = '0' then
      sfh_wren <= (others => '0');
      sfh_write_be <= (others => '0');
      sfh_write_addr <= (others => '0');
      sfh_write_last <= '0';
    elsif rising_edge(clk_pcie) then
	if (sl_en = '1') then
          -- SFH buffers are mapped in the bottom of the BAR (4) space
          -- Only need to select the lowest bits
    	  sfh_write_addr <= sl_wr_addr(STREAM_ADDR_SEGMENT_BIT_WIDTH-1 downto 0);
          sfh_write_size <= sl_wr_size;
          sfh_write_data <= sl_wr_data;	-- data and be are flipped outside this bloc
          sfh_write_be   <= sl_wr_be;
          sfh_write_last <= sl_wr_last;
          -- wren signal for each SFH slave manager bloc
          for sel in 0 to (NUM_STREAMS_FROM_HOST-1) loop
            if (unsigned(sl_wr_addr(STREAM_ADDR_SEGMENT_BIT_WIDTH+NUM_STREAM_BIT_WIDTH-1 downto STREAM_ADDR_SEGMENT_BIT_WIDTH)) = sel) then
              sfh_wren(sel) <= sl_wr_en;
            else
              sfh_wren(sel) <= '0';
            end if;
          end loop;
	else
	  sfh_wren <= (others => '0');
        end if;
      end if;
  end process;

  -- Generate signals for interface to STH slave manager (read requests)
  process(clk_pcie, rst_pcie_n)
  begin
    if rst_pcie_n = '0' then
      sth_rden <= (others => '0');
    elsif rising_edge(clk_pcie) then
	if (sl_en = '1') then
    	  sth_read_addr <= sl_rd_addr(STREAM_ADDR_SEGMENT_BIT_WIDTH-1 downto 0);
          sth_read_size <= sl_rd_size;
          sth_read_metadata <= sl_rd_tag & sl_rd_rid & sl_rd_attr & sl_rd_ep & sl_rd_td & sl_rd_tc;
          sth_read_be <= sl_rd_be;
          -- rden signal for each STH slave manager bloc
          -- STH buffers are mapped in the BAR (4) space after 16 SFH buffers
          for sel in 0 to (NUM_STREAMS_TO_HOST-1) loop
            if (unsigned(sl_rd_addr(STREAM_ADDR_SEGMENT_BIT_WIDTH+NUM_STREAM_BIT_WIDTH-1 downto STREAM_ADDR_SEGMENT_BIT_WIDTH)) = (sel + 16)) then
              sth_rden(sel) <= sl_rd_en;
            else
              sth_rden(sel) <= '0';
            end if;
          end loop;
	else
	  sth_rden <= (others => '0');
        end if;
      end if;
  end process;
 
end rtl;
