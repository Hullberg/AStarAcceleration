------------------------------------------------------------------
-- PCIE SLAVE for Altera PCIe
-- Copyright 2007 Maxeler Technologies Inc. All Rights Reserved
-- Author : rob
-- modified by wei
------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity max_SV_pcie_slave is
  generic (
    G_DEBUG		    : boolean := false;
    NUM_STREAMS_TO_HOST	    : integer := 1;
    NUM_STREAMS_FROM_HOST   : integer := 1;
    BAR_MAX_DWORD_ADDR	    : integer := 256;
    BAR_MAX_PAGES           : integer := 2;
    NUM_EVENTS				: integer := 7;
    NUM_MAX4N_EVENTS		: integer := 0;
    IS_MAX4N				: boolean := false;
    SLAVE_RB_CREDITS_WIDTH  : integer := 3	-- Does *not* include the wrap bit
  );
  port (
    clk_pcie : in std_logic;
    rst_pcie_n : in std_logic;
    -- mapped register interface
    register_in : out std_logic_vector(31 downto 0);
    register_out : in std_logic_vector(31 downto 0);
    register_addr : out std_logic_vector(31 downto 0);
    register_completion_toggle : in std_logic;
    dcm_multdiv : out std_logic_vector(15 downto 0);
    control_toggle : out std_logic_vector(4 downto 0);
    capabilities : in std_logic_vector(31 downto 0);
    
	pcie_capabilities     : in  std_logic_vector(15 downto 0);
    slave_streaming_buf_cap : in std_logic_vector(31 downto 0);
    
    -- dma interface
    dma_complete_sfh	    : in std_logic_vector(31 downto 0); -- indicate which SFH streams have finished
    dma_complete_sth        : in std_logic_vector(31 downto 0); -- indicate which STH streams have finished
    dma_abort_sfh           : out std_logic_vector(31 downto 0);
    dma_abort_sth           : out std_logic_vector(31 downto 0);
    dma_ctl_address	    : out std_logic_vector(8 downto 0);
    dma_ctl_data	    : out std_logic_vector(63 downto 0);
    dma_ctl_write	    : out std_logic;
    dma_ctl_byte_en         : out std_logic_vector(7 downto 0);
    dma_ctl_read_data	    : in  std_logic_vector(63 downto 0);

    req_interrupt_ctl_valid	: in std_logic; -- Interrupts asserted at TX FSM level, when actual buffer has been transmitted
    req_interrupt_ctl_enable_id : in std_logic_vector(31 downto 0);

    -- rx interface
    --  writes
    reg_data_out : in std_logic_vector(63 downto 0);
    reg_data_wren : in std_logic_vector(7 downto 0);
    reg_data_addr : in std_logic_vector(63 downto 0);
    reg_data_bar0 : in std_logic;  
    reg_data_bar2 : in std_logic;
    --  reads, completion information associated with a read request (needed to construct response)
    rx_reg_read_compl_bar2  : in std_logic;
    rx_reg_read_compl_tc   : in std_logic_vector(2 downto 0); -- read TC
    rx_reg_read_compl_td   : in std_logic; -- read TD
    rx_reg_read_compl_ep   : in std_logic; -- read EP
    rx_reg_read_compl_attr : in std_logic_vector(1 downto 0); -- read attribute
    rx_reg_read_compl_rid  : in std_logic_vector(15 downto 0); -- read requestor ID
    rx_reg_read_compl_tag  : in std_logic_vector(7 downto 0); -- read tag
    rx_reg_read_compl_addr : in std_logic_vector(63 downto 0); -- read address
    rx_reg_read_compl_req  : in std_logic;
    rx_reg_read_compl_size  : in std_logic_vector(9 downto 0); -- not used, size must always be 1
    rx_reg_read_compl_full : out std_logic;
    rx_reg_read_compl_overflow : out std_logic;
    rx_reg_read_compl_underflow : out std_logic;
    -- tx interface
    tx_reg_compl_req  : out std_logic;
    tx_reg_compl_tc   : out std_logic_vector(2 downto 0);
    tx_reg_compl_td   : out std_logic;
    tx_reg_compl_ep   : out std_logic;
    tx_reg_compl_attr : out std_logic_vector(1 downto 0);
    tx_reg_compl_rid  : out std_logic_vector(15 downto 0);
    tx_reg_compl_tag  : out std_logic_vector(7 downto 0);
    tx_reg_compl_addr : out std_logic_vector(12 downto 0);
    tx_reg_compl_size : out std_logic_vector(9 downto 0);
    tx_reg_compl_ack  : in std_logic;
    -- tx data
    tx_reg_compl_data : out std_logic_vector(63 downto 0);
    tx_reg_compl_rden : in std_logic;
    -- config interface
    ltssmstate : in std_logic_vector(4 downto 0);
    leds : out std_logic_vector(1 downto 0);
    -- config space register
    tl_cfg_ctl        : in std_logic_vector(31 downto 0);
    tl_cfg_add        : in std_logic_vector(3 downto 0);
    cfg_completer_id  : out std_logic_vector(15 downto 0);
    -- interrupts
    app_int_sts	      : out std_logic;
    app_int_ack       : in std_logic;
    app_msi_num       : out std_logic_vector(4 downto 0);
    app_msi_req       : out std_logic;
    app_msi_tc        : out std_logic_vector(2 downto 0);
    app_msi_ack       : in std_logic;

    throttle_limit : out std_logic_vector(10 downto 0);
    soft_reset : out std_logic;
    -- MaxRing
    maxring_s_set_highZ_n       : out std_logic_vector(3 downto 0);
    maxring_s_fh                : out std_logic_vector(3 downto 0);
    maxring_s_th                : in  std_logic_vector(3 downto 0);
    maxring_id_set_highZ_n       : out std_logic_vector(3 downto 0);
    maxring_id_fh                : out std_logic_vector(3 downto 0);
    maxring_id_th               : in  std_logic_vector(3 downto 0);
    maxring_prsn_th             : in  std_logic;
    maxring_type_th             : in  std_logic_vector(1 downto 0);
    
    -- Left DIMM I2C
    i2c_left_dimm_scl_fb   : in  std_logic;
    i2c_left_dimm_sda_fb   : in  std_logic;
    i2c_left_dimm_scl_drv : out std_logic;
    i2c_left_dimm_sda_drv : out std_logic;
    -- Right DIMM I2C
    i2c_right_dimm_scl_fb   : in  std_logic;
    i2c_right_dimm_sda_fb   : in  std_logic;
    i2c_right_dimm_scl_drv : out std_logic;
    i2c_right_dimm_sda_drv : out std_logic;
    
    i2c_dimm_alert : in  std_logic; -- common alert for DIMM I2C buses
        
    -- AUX I2C: Temp Sensor, Optical, & EEPROM
    i2c_aux_scl_fb   : in  std_logic;
    i2c_aux_sda_fb   : in  std_logic;
    i2c_aux_alert : in  std_logic;
    i2c_aux_scl_drv : out std_logic;
    i2c_aux_sda_drv : out std_logic;
    -- PSU
    pmbus_scl_fb   : in  std_logic;
    pmbus_sda_fb   : in  std_logic;
    pmbus_alert : in  std_logic;
    pmbus_scl_drv : out std_logic;
    pmbus_sda_drv : out std_logic;
    
    -- QSFP I2C
    qsfp0_i2c_scl_fb   : in  std_logic;
    qsfp0_i2c_sda_fb   : in  std_logic;
    qsfp0_i2c_alert : in  std_logic;
    qsfp0_i2c_scl_drv : out std_logic;
    qsfp0_i2c_sda_drv : out std_logic;
    qsfp0_i2c_modprsl : in  std_logic;
    qsfp0_i2c_lpmode  : out std_logic;
    qsfp0_i2c_modsell: out std_logic;
    qsfp0_i2c_resetl  : out std_logic;
    
    qsfp1_i2c_scl_fb   : in  std_logic;
    qsfp1_i2c_sda_fb   : in  std_logic;
    qsfp1_i2c_alert : in  std_logic;
    qsfp1_i2c_scl_drv : out std_logic;
    qsfp1_i2c_sda_drv : out std_logic;
    qsfp1_i2c_modprsl : in  std_logic;
    qsfp1_i2c_lpmode  : out std_logic;
    qsfp1_i2c_modsell: out std_logic;
    qsfp1_i2c_resetl  : out std_logic;
    
    qsfp2_i2c_scl_fb   : in  std_logic;
    qsfp2_i2c_sda_fb   : in  std_logic;
    qsfp2_i2c_alert : in  std_logic;
    qsfp2_i2c_scl_drv : out std_logic;
    qsfp2_i2c_sda_drv : out std_logic;
    qsfp2_i2c_modprsl : in  std_logic;
    qsfp2_i2c_lpmode  : out std_logic;
    qsfp2_i2c_modsell: out std_logic;
    qsfp2_i2c_resetl  : out std_logic;

    qsfp3_i2c_scl_fb   : in  std_logic;
    qsfp3_i2c_sda_fb   : in  std_logic;
    qsfp3_i2c_alert : in  std_logic;
    qsfp3_i2c_scl_drv : out std_logic;
    qsfp3_i2c_sda_drv : out std_logic;
    qsfp3_i2c_modprsl : in  std_logic;
    qsfp3_i2c_lpmode  : out std_logic;
    qsfp3_i2c_modsell: out std_logic;
    qsfp3_i2c_resetl  : out std_logic;

    qsfp4_i2c_scl_fb   : in  std_logic;
    qsfp4_i2c_sda_fb   : in  std_logic;
    qsfp4_i2c_alert : in  std_logic;
    qsfp4_i2c_scl_drv : out std_logic;
    qsfp4_i2c_sda_drv : out std_logic;
    qsfp4_i2c_modprsl : in  std_logic;
    qsfp4_i2c_lpmode  : out std_logic;
    qsfp4_i2c_modsell: out std_logic;
    qsfp4_i2c_resetl  : out std_logic;

    qsfp5_i2c_scl_fb   : in  std_logic;
    qsfp5_i2c_sda_fb   : in  std_logic;
    qsfp5_i2c_alert : in  std_logic;
    qsfp5_i2c_scl_drv : out std_logic;
    qsfp5_i2c_sda_drv : out std_logic;
    qsfp5_i2c_modprsl : in  std_logic;
    qsfp5_i2c_lpmode  : out std_logic;
    qsfp5_i2c_modsell: out std_logic;
    qsfp5_i2c_resetl  : out std_logic;

    qsfp6_i2c_scl_fb   : in  std_logic;
    qsfp6_i2c_sda_fb   : in  std_logic;
    qsfp6_i2c_alert : in  std_logic;
    qsfp6_i2c_scl_drv : out std_logic;
    qsfp6_i2c_sda_drv : out std_logic;
    qsfp6_i2c_modprsl : in  std_logic;
    qsfp6_i2c_lpmode  : out std_logic;
    qsfp6_i2c_modsell: out std_logic;
    qsfp6_i2c_resetl  : out std_logic;

    qsfp7_i2c_scl_fb   : in  std_logic;
    qsfp7_i2c_sda_fb   : in  std_logic;
    qsfp7_i2c_alert : in  std_logic;
    qsfp7_i2c_scl_drv : out std_logic;
    qsfp7_i2c_sda_drv : out std_logic;
    qsfp7_i2c_modprsl : in  std_logic;
    qsfp7_i2c_lpmode  : out std_logic;
    qsfp7_i2c_modsell: out std_logic;
    qsfp7_i2c_resetl  : out std_logic;
    
    -- PTP PHY MDIO
    ptp_phy_mdio_scl_to_host   : in  std_logic;
    ptp_phy_mdio_sda_to_host   : in  std_logic;
    ptp_phy_mdio_event_to_host : in  std_logic;
    ptp_phy_mdio_scl_from_host : out std_logic;
    ptp_phy_mdio_sda_from_host : out std_logic;
    
    ptp_phy_sresetn   : out std_logic;

    -- Power events monitoring
    host_event_status     : in  std_logic_vector(NUM_MAX4N_EVENTS + NUM_EVENTS-1 downto 0);
    host_event_ack        : out std_logic_vector(NUM_MAX4N_EVENTS + NUM_EVENTS-1 downto 0);

	-- CvP Flags
	config_fpga_init_done : in std_logic;
	config_fpga_crc_error : in std_logic;
	config_fpga_cvp_confdone : in std_logic;
	
	-- Revision & Dip Switches
	rev_dipsw : in std_logic_vector(3 downto 0);
	rev_pcb_rev : in std_logic_vector(1 downto 0);
	rev_assy_rev : in std_logic_vector(1 downto 0);
	rev_cpld_version : in std_logic_vector(7 downto 0);
	rev_build_rev		: in  std_logic_vector(1 downto 0);	-- MAX4N build rev (1, 2 or 3 QSFPs)
	 
    -- Flash interface
    flash_rx_d : in std_logic_vector(63 downto 0);
    flash_tx_d : out std_logic_vector(63 downto 0);
    flash_rx_addr : out std_logic;
    flash_tx_addr : out std_logic;
    flash_tx_we : out std_logic;
    -- Reconfiguration interface
    config_reconfig_trigger  : out std_logic;
    -- control streams
    control_streams_select : out std_logic_vector(3 downto 0);
    control_streams_reset_toggle : out std_logic;
    -- stream interrupt (notify CPU that operation has finished)
    stream_interrupt_toggle : in std_logic_vector(15 downto 0);
   
    compute_reset_n	    : out std_logic;

    mapped_elements_select_dma	    : out std_logic;
    mapped_elements_reset	    : out std_logic;
    mapped_elements_version	    : in  std_logic_vector(31 downto 0);
    mapped_elements_empty	    : in  std_logic;
    mapped_elements_fc_type	    : in  std_logic_vector(1 downto 0);
    mapped_elements_toggle	    : in  std_logic; -- toggles when read has been seen and new data is in the data register
    mapped_elements_data	    : in  std_logic_vector(31 downto 0);
    mapped_elements_read	    : out std_logic; -- strobe when to read the next data item from the fifo

    mapped_elements_data_in	    : out std_logic_vector(31 downto 0);
    mapped_elements_fc_in	    : out std_logic_vector(1 downto 0);
    mapped_elements_fill	    : in  std_logic_vector(9 downto 0);
    mapped_elements_write	    : out std_logic;

    local_ifpga_session_key	    : out std_logic_vector(1 downto 0);

    sfa_user_toggle           : out std_logic;
    sfa_user_toggle_ack       : in  std_logic;

    -- Slave Streaming Credits, in interfaces
    -- We add capabilities for a SFH control stream in addition to NUM_STREAMS_FROM_HOST
    slave_sfh_card_credits_index  : in  std_logic_vector((SLAVE_RB_CREDITS_WIDTH * (NUM_STREAMS_FROM_HOST+1))-1 downto 0);
    slave_sfh_card_credits_wrap   : in  std_logic_vector(NUM_STREAMS_FROM_HOST downto 0);
    slave_sfh_card_credits_update : in  std_logic_vector(NUM_STREAMS_FROM_HOST downto 0);
   
    slave_sth_card_credits_index  : in  std_logic_vector((SLAVE_RB_CREDITS_WIDTH * (NUM_STREAMS_TO_HOST+1))-1 downto 0);
    slave_sth_card_credits_wrap   : in  std_logic_vector(NUM_STREAMS_TO_HOST downto 0);
    slave_sth_card_credits_update : in  std_logic_vector(NUM_STREAMS_TO_HOST downto 0);

    -- Stream capabilities
    sfh_cap : in std_logic_vector(127 downto 0);
    sth_cap : in std_logic_vector(127 downto 0);
    sfh_cap_ctrl_0 : in std_logic_vector(7 downto 0);
    sth_cap_ctrl_0 : in std_logic_vector(7 downto 0);
    
	--
	-- Bar Space Parsing by external entity (writes only)
	--
	bar_parse_wr_addr_onehot	: out std_logic_vector(BAR_MAX_DWORD_ADDR-1 downto 0);
	bar_parse_wr_data		: out std_logic_vector(63 downto 0);
	bar_parse_wr_clk		: out std_logic;
	bar_parse_wr_page_sel_onehot	: out std_logic_vector(BAR_MAX_PAGES-1 downto 0);

    -- 
    -- Bar space external readable registers, driven by PCIeBarReadableStatusRegisters IOGroup 
    --
    bar_status_tx_fifo_empty	    : in  std_logic


  );

 attribute keep_hierarchy : string;
end max_SV_pcie_slave;

  --------------------------------------------------------------------------
  -- Register Assignment when a write transaction is targeting BAR0
  --------------------------------------------------------------------------
  --- See Google Doc                                                     ---
  --------------------------------------------------------------------------
  

architecture rtl of max_SV_pcie_slave is

  attribute keep_hierarchy of rtl: architecture is "soft";

  component compl_fifo
    port (
      clock : in std_logic;
      data : in std_logic_vector(44 downto 0);
      rdreq : in std_logic;
      aclr : in std_logic;
      wrreq : in std_logic;
      almost_full : out std_logic;
      q : out std_logic_vector(44 downto 0);
      empty : out std_logic;
      full : out std_logic);
  end component;

  constant TC_MSI_INT : std_logic_vector(2 downto 0) := "000";
  constant MSI_INT_NUM : std_logic_vector(4 downto 0) := "00000";
  constant LTSSM_L0_STATE : std_logic_vector(4 downto 0) := "01111";
  constant LTSSM_DIS_STATE : std_logic_vector(4 downto 0) := "10000";
  constant LTSSM_DET_ACTIVE_STATE : std_logic_vector(4 downto 0) := "00001";
  constant CFG_MSICSR_ADDR : std_logic_vector(3 downto 0) := X"D";
  constant CFG_BUSDEV_ADDR : std_logic_vector(3 downto 0) := X"F";

  type slave_state_t is (START, WAIT_READ, WAIT_READ_2, WAIT_READ_3, WAIT_READ_4, WAIT_ACK);
  
  signal slave_state : slave_state_t := START;

  signal register_dword_addr : std_logic_vector(12 downto 0);

	signal compl_fifo_in, compl_fifo_out		: std_logic_vector(44 downto 0) := (others => '0');
	signal compl_fifo_empty, compl_fifo_read, compl_fifo_read_r		: std_logic;
	signal rst			: std_logic;
	signal read_addr, read_addr_r	: std_logic_vector(12 downto 0);
	signal write_reg_r		: std_logic_vector(BAR_MAX_DWORD_ADDR-1 downto 0);
	signal write_reg_page_sel_r	: std_logic_vector(BAR_MAX_PAGES-1 downto 0);
	signal reg_data_out_r		: std_logic_vector(63 downto 0);
	signal reg_data_addr_qword	: std_logic_vector(9 downto 0);
	signal reg_data_addr_r		: std_logic_vector(9 downto 0);
	signal reg_data_wren_r		: std_logic_vector(7 downto 0);
	signal reg_data_addr_high	: std_logic;
	signal compl_src_bar2		: std_logic;
	signal dma_ctl_addr_write_en	: std_logic := '0';

  -- registers
  signal mailbox : std_logic_vector(31 downto 0) := X"00000000";
  signal retrain_count : std_logic_vector(7 downto 0) := X"00";
  signal irq_state : std_logic_vector(31 downto 0) := (others => '0');
  signal irq_state_cleared: std_logic := '1';
  signal app_int_ack_r    : std_logic := '0';
  signal control_toggle_int : std_logic_vector(4 downto 0) := (others => '0');

  signal wr_inram : std_logic := '0';

  signal cfg_msicsr : std_logic_vector(15 downto 0) := X"0000";

  signal compl_data : std_logic_vector(31 downto 0) := X"00000000";
  signal compl_data_bar0 : std_logic_vector(31 downto 0) := X"00000000";
  signal compl_data_bar2 : std_logic_vector(31 downto 0) := X"00000000";
 
  signal link_state_n_r, link_state_n_r2 : std_logic_vector(4 downto 0) := "00000";
  signal retrain_inc : std_logic := '0';

  signal stop_interrupt : std_logic_vector(1 downto 0) := "00";

  type int_state_t is (RST_STATE, INT_ASSERT, INT_WAIT_DEASSERT, INT_DEASSERT);
  signal int_state : int_state_t := RST_STATE;

  signal stream_interrupt_toggle_sync0 : std_logic_vector(15 downto 0) := (others => '0');
  signal stream_interrupt_toggle_sync1 : std_logic_vector(15 downto 0) := (others => '0');
  signal stream_interrupt_toggle_sync2 : std_logic_vector(15 downto 0) := (others => '0');

  signal stream_interrupt : std_logic_vector(15 downto 0);

  signal power_interrupts     : std_logic_vector(NUM_EVENTS-1 downto 0) := (others => '0');
  signal power_interrupts_r   : std_logic_vector(NUM_EVENTS-1 downto 0) := (others => '0');
  signal power_interrupt_flag : std_logic := '0';
  signal power_interrupt_en   : std_logic := '0';
  signal power_do_interrupt   : std_logic := '0';
  signal max4n_interrupts     : std_logic_vector(NUM_MAX4N_EVENTS-1 downto 0) := (others => '0');
  signal max4n_interrupts_r   : std_logic_vector(NUM_MAX4N_EVENTS-1 downto 0) := (others => '0');
  signal max4n_interrupt_flag : std_logic := '0';
  signal max4n_interrupt_en   : std_logic := '0';
  signal max4n_do_interrupt   : std_logic := '0';
  signal host_event_ack_int   : std_logic_vector(NUM_MAX4N_EVENTS + NUM_EVENTS-1 downto 0) := (others => '0');

  signal link_active, link_active_r : std_logic := '0';

	--signal error_counter_int		: std_logic_vector(31 downto 0) := (others =>	'0');
	signal dma_interrupt_send		: std_logic := '0';
	
	signal sfh_do_interrupt			: std_logic := '0';
	signal sfh_interrupt_flag		: std_logic := '0';
	signal sfh_streams_finished		: std_logic_vector(31 downto 0) := (others => '0');
	signal sfh_streams_finished_r		: std_logic_vector(31 downto 0) := (others => '0');

  signal sth_do_interrupt     : std_logic := '0';
  signal sth_interrupt_flag   : std_logic := '0';
  signal sth_streams_finished : std_logic_vector(31 downto 0) := (others => '0');
  signal sth_streams_finished_r : std_logic_vector(31 downto 0) := (others => '0');

  signal dma_complete_sth_store : std_logic_vector(31 downto 0) := (others => '0');
  signal dma_complete_sth_store_r : std_logic_vector(31 downto 0) := (others => '0');
  signal dma_complete_sth_real : std_logic_vector(31 downto 0) := (others => '0');

  signal mem_do_interrupt     : std_logic := '0';
  signal mem_interrupt_flag   : std_logic := '0';  
  signal mem_interrupts	      : std_logic_vector(15 downto 0) := (others => '0');
  signal mem_interrupts_r     : std_logic_vector(15 downto 0) := (others => '0');

  signal eir_req_interrupt : std_logic := '0';
    
  signal control_streams_select_i : std_logic_vector(3 downto 0) := (others => '0');
  signal control_streams_reset_toggle_i : std_logic := '0';
  signal sfa_do_toggle          : std_logic_vector(7 downto 0) := (others => '0');
  signal host_sfa_toggle_i      : std_logic_vector(7 downto 0) := (others => '0');
  signal host_sfa_toggle_acked  : std_logic_vector(7 downto 0) := (others => '0');
  signal sfa_user_toggle_ack_i  : std_logic_vector(7 downto 0);
  signal sfa_user_toggle_ack_r  : std_logic_vector(7 downto 0);
  signal sfa_user_toggle_ack_x  : std_logic_vector(7 downto 0);

  signal i2c_left_dimm_scl_from_host_int : std_logic := '0';
  signal i2c_left_dimm_sda_from_host_int : std_logic := '0';
  signal i2c_right_dimm_scl_from_host_int : std_logic := '0';
  signal i2c_right_dimm_sda_from_host_int : std_logic := '0';
  signal i2c_aux_scl_from_host_int : std_logic := '0';
  signal i2c_aux_sda_from_host_int : std_logic := '0';
  signal pmbus_scl_from_host_int : std_logic := '0';
  signal pmbus_sda_from_host_int : std_logic := '0';
  signal qsfp0_i2c_scl_from_host_int : std_logic := '0';
  signal qsfp0_i2c_sda_from_host_int : std_logic := '0';
  signal qsfp0_i2c_lpmode_int : std_logic := '0';
  signal qsfp1_i2c_scl_from_host_int : std_logic := '0';
  signal qsfp1_i2c_sda_from_host_int : std_logic := '0';
  signal qsfp1_i2c_lpmode_int : std_logic := '0';
  signal qsfp2_i2c_scl_from_host_int : std_logic := '0';
  signal qsfp2_i2c_sda_from_host_int : std_logic := '0';
  signal qsfp2_i2c_lpmode_int : std_logic := '0';
  signal qsfp3_i2c_scl_from_host_int : std_logic := '0';
  signal qsfp3_i2c_sda_from_host_int : std_logic := '0';
  signal qsfp3_i2c_lpmode_int : std_logic := '0';
  signal qsfp4_i2c_scl_from_host_int : std_logic := '0';
  signal qsfp4_i2c_sda_from_host_int : std_logic := '0';
  signal qsfp4_i2c_lpmode_int : std_logic := '0';
  signal qsfp5_i2c_scl_from_host_int : std_logic := '0';
  signal qsfp5_i2c_sda_from_host_int : std_logic := '0';
  signal qsfp5_i2c_lpmode_int : std_logic := '0';
  signal qsfp6_i2c_scl_from_host_int : std_logic := '0';
  signal qsfp6_i2c_sda_from_host_int : std_logic := '0';
  signal qsfp6_i2c_lpmode_int : std_logic := '0';
  signal qsfp7_i2c_scl_from_host_int : std_logic := '0';
  signal qsfp7_i2c_sda_from_host_int : std_logic := '0';
  signal qsfp7_i2c_lpmode_int : std_logic := '0';
  signal ptp_phy_mdio_scl_from_host_int : std_logic := '1';
  signal ptp_phy_mdio_sda_from_host_int : std_logic := '1';
  signal ptp_phy_sresetn_int : std_logic := '1';
  signal maxring_s_set_highZ_n_int : std_logic_vector(maxring_s_set_highZ_n'high downto 0) := (others => '0');
  signal maxring_id_set_highZ_n_int : std_logic_vector(maxring_id_set_highZ_n'high downto 0) := (others => '0');
  signal maxring_bus_select     : std_logic := '0';
  signal maxring_bus_highZ      : std_logic_vector(3 downto 0);

  signal led_identify_toggle : std_logic := '0';
  signal compute_reset_n_i : std_logic := '1';

  signal mapped_elements_reset_i : std_logic := '1'; 

  signal sfh_enable_interrupts_reg : std_logic_vector(dma_complete_sfh'range) := (others => '1');
  signal sth_enable_interrupts_reg : std_logic_vector(dma_complete_sth'range) := (others => '1');
  signal dma_sfh_finished_masked : std_logic_vector(dma_complete_sfh'range) := (others => '0');
  signal dma_sth_finished_masked : std_logic_vector(dma_complete_sth'range) := (others => '0');
  signal sfh_complete_masked	 : std_logic_vector(dma_complete_sfh'range) := (others => '0');
  signal sth_complete_masked	 : std_logic_vector(dma_complete_sth'range) := (others => '0');
   
  signal bar_status_tx_fifo_empty_r : std_logic := '0';
  
  signal pcie_sync_rst_n : std_logic;
  signal reset_pcie_n_r			: std_logic_vector(2 downto 0) := (others => '0');
  
  signal reconfig_trigger_mode : std_logic_vector(31 downto 0) := (others => '0');
  signal reconfig_trigger_i, reconfig_trigger_r, reconfig_trigger_d, reconfig_trigger_toggle : std_logic := '0';
  type reconfig_trig_fsm_t is (TRIG_IDLE, TRIG_MODE, TRIG_PCIE, TRIG_IMM);
  signal trig_st : reconfig_trig_fsm_t := TRIG_IDLE;
  signal trigger_pulse_cnt : unsigned(15 downto 0); -- 175 * 4ns = 7us 
  constant RECONFIG_MODE : natural := 0; 
  constant RECONFIG_PCIE : std_logic := '1';
  
  signal tl_cfg_ctl_reg : std_logic_vector(31 downto 0);
  signal tl_cfg_add_reg : std_logic_vector(3 downto 0);
    
begin

  

    i2c_left_dimm_scl_drv <= i2c_left_dimm_scl_from_host_int;
    i2c_left_dimm_sda_drv <= i2c_left_dimm_sda_from_host_int;
    i2c_right_dimm_scl_drv <= i2c_right_dimm_scl_from_host_int;
    i2c_right_dimm_sda_drv <= i2c_right_dimm_sda_from_host_int;
    i2c_aux_scl_drv <= i2c_aux_scl_from_host_int;
    i2c_aux_sda_drv <= i2c_aux_sda_from_host_int;
    pmbus_scl_drv <= pmbus_scl_from_host_int;
    pmbus_sda_drv <= pmbus_sda_from_host_int;
    qsfp0_i2c_scl_drv <= qsfp0_i2c_scl_from_host_int;
    qsfp0_i2c_sda_drv <= qsfp0_i2c_sda_from_host_int;
    qsfp0_i2c_lpmode  <= qsfp0_i2c_lpmode_int;
    qsfp0_i2c_modsell <= '0';
    qsfp0_i2c_resetl <= '1';
    qsfp1_i2c_scl_drv <= qsfp1_i2c_scl_from_host_int;
    qsfp1_i2c_sda_drv <= qsfp1_i2c_sda_from_host_int;
    qsfp1_i2c_lpmode  <= qsfp1_i2c_lpmode_int;
    qsfp1_i2c_modsell <= '0';
    qsfp1_i2c_resetl <= '1';
    qsfp2_i2c_scl_drv <= qsfp2_i2c_scl_from_host_int;
    qsfp2_i2c_sda_drv <= qsfp2_i2c_sda_from_host_int;
    qsfp2_i2c_lpmode  <= qsfp2_i2c_lpmode_int;
    qsfp2_i2c_modsell <= '0';
    qsfp2_i2c_resetl <= '1';
    qsfp3_i2c_scl_drv <= qsfp3_i2c_scl_from_host_int;
    qsfp3_i2c_sda_drv <= qsfp3_i2c_sda_from_host_int;
    qsfp3_i2c_lpmode  <= qsfp3_i2c_lpmode_int;
    qsfp3_i2c_modsell <= '0';
    qsfp3_i2c_resetl <= '1';
    qsfp4_i2c_scl_drv <= qsfp4_i2c_scl_from_host_int;
    qsfp4_i2c_sda_drv <= qsfp4_i2c_sda_from_host_int;
    qsfp4_i2c_lpmode  <= qsfp4_i2c_lpmode_int;
    qsfp4_i2c_modsell <= '0';
    qsfp4_i2c_resetl <= '1';
    qsfp5_i2c_scl_drv <= qsfp5_i2c_scl_from_host_int;
    qsfp5_i2c_sda_drv <= qsfp5_i2c_sda_from_host_int;
    qsfp5_i2c_lpmode  <= qsfp5_i2c_lpmode_int;
    qsfp5_i2c_modsell <= '0';
    qsfp5_i2c_resetl <= '1';
    qsfp6_i2c_scl_drv <= qsfp6_i2c_scl_from_host_int;
    qsfp6_i2c_sda_drv <= qsfp6_i2c_sda_from_host_int;
    qsfp6_i2c_lpmode  <= qsfp6_i2c_lpmode_int;
    qsfp6_i2c_modsell <= '0';
    qsfp6_i2c_resetl <= '1';
    qsfp7_i2c_scl_drv <= qsfp7_i2c_scl_from_host_int;
    qsfp7_i2c_sda_drv <= qsfp7_i2c_sda_from_host_int;
    qsfp7_i2c_lpmode  <= qsfp7_i2c_lpmode_int;
    qsfp7_i2c_modsell <= '0';
    qsfp7_i2c_resetl <= '1';
    ptp_phy_mdio_scl_from_host <= ptp_phy_mdio_scl_from_host_int;
    ptp_phy_mdio_sda_from_host <= ptp_phy_mdio_sda_from_host_int;
    ptp_phy_sresetn <= ptp_phy_sresetn_int;
    host_event_ack <= host_event_ack_int;
    maxring_s_set_highZ_n <= maxring_s_set_highZ_n_int;
    maxring_id_set_highZ_n <= maxring_id_set_highZ_n_int;
    with maxring_bus_select select
    maxring_bus_highZ <= maxring_id_set_highZ_n_int when '1', maxring_s_set_highZ_n_int when others;


    control_streams_select <= control_streams_select_i;
    control_streams_reset_toggle <= control_streams_reset_toggle_i;

    compute_reset_n <= compute_reset_n_i;

    --error_counter <= (others => '0'); --error_counter_int;
    reg_data_addr_qword <= reg_data_addr(12 downto 3) when (reg_data_wren /= (reg_data_wren'range => '0')) else read_addr(10 downto 1);

    -- synchronize stream_interrupt_toggle
    process(clk_pcie)
    begin
        if rising_edge(clk_pcie) then
            stream_interrupt_toggle_sync0 <= stream_interrupt_toggle;
            stream_interrupt_toggle_sync1 <= stream_interrupt_toggle_sync0;
            stream_interrupt_toggle_sync2 <= stream_interrupt_toggle_sync1;

            stream_interrupt <= stream_interrupt_toggle_sync2 xor stream_interrupt_toggle_sync1;
        end if;
    end process;
  
    --   process (clk_pcie)
    --   begin
    --       if rising_edge(clk_pcie) then
    --   	    reset_pcie_n_r(2 downto 0) <= reset_pcie_n_r(1 downto 0) & rst_pcie_n;
    --       end if;
    --   end process;
    --   pcie_sync_rst_n <= reset_pcie_n_r(2);
    pcie_sync_rst_n <= rst_pcie_n;
 

    process (clk_pcie)
    begin
        if rising_edge(clk_pcie) then
            sfh_streams_finished_r <= sfh_streams_finished;
            if sfh_streams_finished_r /= X"00000000" then
                sfh_interrupt_flag <= '1';
            else
                sfh_interrupt_flag <= '0';
            end if;
   
            if ((not sfh_streams_finished_r) and sfh_streams_finished) /= X"00000000" then
                sfh_do_interrupt <= '1';
            else
                sfh_do_interrupt <= '0';
            end if; 

            sth_streams_finished_r <= sth_streams_finished;
            if sth_streams_finished_r /= X"00000000" then
                sth_interrupt_flag <= '1';
            else
                sth_interrupt_flag <= '0';
            end if;

            if ((not sth_streams_finished_r) and sth_streams_finished) /= X"00000000" then
                sth_do_interrupt <= '1';
            else
                sth_do_interrupt <= '0';
            end if; 

            mem_interrupts_r <= mem_interrupts;
            if mem_interrupts_r /= X"0000" then
                mem_interrupt_flag <= '1';
            else
                mem_interrupt_flag <= '0';
            end if;

            if ((not mem_interrupts_r) and mem_interrupts) /= X"0000" then
                mem_do_interrupt <= '1';
            else
                mem_do_interrupt <= '0';
            end if; 

            power_interrupts_r <= power_interrupts;
            if power_interrupts_r /= CONV_STD_LOGIC_VECTOR(0, NUM_EVENTS) then
                power_interrupt_flag <= power_interrupt_en;
            else
                power_interrupt_flag <= '0';
            end if;

            if ((not power_interrupts_r) and power_interrupts) /= CONV_STD_LOGIC_VECTOR(0, NUM_EVENTS) then
                power_do_interrupt <= power_interrupt_en;
            else
                power_do_interrupt <= '0';
            end if;
      
            max4n_interrupts_r <= max4n_interrupts;
            if IS_MAX4N = true and max4n_interrupts_r /= CONV_STD_LOGIC_VECTOR(0, NUM_MAX4N_EVENTS) then
                max4n_interrupt_flag <= max4n_interrupt_en;
            else
                max4n_interrupt_flag <= '0';
            end if;

            if IS_MAX4N = true and ((not max4n_interrupts_r) and max4n_interrupts) /= CONV_STD_LOGIC_VECTOR(0, NUM_MAX4N_EVENTS) then
                max4n_do_interrupt <= max4n_interrupt_en;
            else
                max4n_do_interrupt <= '0';
            end if;
       
            eir_req_interrupt <= mem_do_interrupt or sth_do_interrupt or sfh_do_interrupt or power_do_interrupt or max4n_do_interrupt;
        end if;
    end process;


    -- update retrain counter
    process(clk_pcie)
    begin
        if rising_edge(clk_pcie) then
            link_state_n_r <= ltssmstate;
            link_state_n_r2 <= link_state_n_r;
            if link_state_n_r2 = LTSSM_L0_STATE and
                link_state_n_r /= LTSSM_L0_STATE then
                retrain_inc <= '1';
            else
                retrain_inc <= '0';
            end if;

            retrain_count <= unsigned(retrain_count) + retrain_inc; 
        end if;
    end process;


    leds <= led_identify_toggle & link_active_r;
    control_toggle <= control_toggle_int;
  
    rst <= not pcie_sync_rst_n;
	
    process(clk_pcie)
    begin
        if rising_edge(clk_pcie) then
            if pcie_sync_rst_n = '0' then
                link_active_r <= '0';
            else
                if ltssmstate = LTSSM_L0_STATE then
                    link_active_r <= '1';
                else
                    link_active_r <= '0';
                end if;
            end if;
        end if;
    end process;



    process(clk_pcie)
    begin
        if rising_edge(clk_pcie) then
            for i in 0 to host_sfa_toggle_i'left loop
                if pcie_sync_rst_n = '0' then
                    host_sfa_toggle_i(i) <= '0';
                    host_sfa_toggle_acked(i) <= '0';
                elsif sfa_do_toggle(i) = '1' then
                    host_sfa_toggle_i(i) <= not host_sfa_toggle_i(i);
                    host_sfa_toggle_acked(i) <= '0';
                elsif sfa_user_toggle_ack_x(i) = '1' then
                    host_sfa_toggle_acked(i) <= '1';
                end if;
            end loop;
        end if;
    end process;

    sfa_user_toggle <= host_sfa_toggle_i(2);
    sfa_user_toggle_ack_i <= (sfa_user_toggle_ack_i'high downto 3 => '0') & sfa_user_toggle_ack & "00";

    process(clk_pcie)
    begin
        if rising_edge(clk_pcie) then
            if pcie_sync_rst_n = '0' then
                sfa_user_toggle_ack_r <= (others => '0');
            else 
                sfa_user_toggle_ack_r <= sfa_user_toggle_ack_i;
            end if;
        end if;
    end process;
    sfa_user_toggle_ack_x <= sfa_user_toggle_ack_r xor sfa_user_toggle_ack_i;


    -- throw away byte address (always zero) and upper bits (already decoded by the core)
    register_dword_addr <= rx_reg_read_compl_addr(14 downto 2);

	
    compl_fifo_in <= rx_reg_read_compl_bar2 & rx_reg_read_compl_tc & rx_reg_read_compl_td & rx_reg_read_compl_ep &
    rx_reg_read_compl_attr & rx_reg_read_compl_rid & rx_reg_read_compl_tag &
    register_dword_addr; 

    process(clk_pcie)
    begin
        if rising_edge(clk_pcie) then
            tx_reg_compl_tc <= compl_fifo_out(43 downto 41);
            tx_reg_compl_td <= compl_fifo_out(40);
            tx_reg_compl_ep <= compl_fifo_out(39);
            tx_reg_compl_attr <= compl_fifo_out(38 downto 37);
            tx_reg_compl_rid <= compl_fifo_out(36 downto 21);
            tx_reg_compl_tag <= compl_fifo_out(20 downto 13);
            tx_reg_compl_addr <= read_addr_r;
        end if;
    end process;

    read_addr <= compl_fifo_out(12 downto 0);
    reg_data_addr_high <= compl_fifo_out(0);
    compl_src_bar2 <= compl_fifo_out(44);

    -- completion fifo
    cfifo : compl_fifo
    port map(
    clock => clk_pcie,
    aclr => rst,
    data => compl_fifo_in,
    rdreq => compl_fifo_read,
    wrreq => rx_reg_read_compl_req,
    almost_full => rx_reg_read_compl_full,
    q => compl_fifo_out,
    empty => compl_fifo_empty,
    full => open);

    rx_reg_read_compl_underflow <= '0';
    rx_reg_read_compl_overflow <= '0';

    process(clk_pcie)
    begin
        if rising_edge(clk_pcie) then
            if pcie_sync_rst_n = '0' then
                dma_interrupt_send <= '0';
            elsif eir_req_interrupt = '1' and link_active_r = '1' then
                dma_interrupt_send <= '1';
            else
                dma_interrupt_send <= '0';
            end if;
        end if;
    end process;

    process(clk_pcie)
    begin
        if rising_edge(clk_pcie) then
            app_msi_req <= '0';
            app_int_sts <= '0';
            app_int_ack_r <= app_int_ack;
            if pcie_sync_rst_n = '0' then
                int_state <= RST_STATE;
            else
                case int_state is
                    when RST_STATE =>
                        if dma_interrupt_send = '1' then
                            int_state <= INT_ASSERT;
                        end if;
                    when INT_ASSERT =>
                        if cfg_msicsr(0) = '1' then
                            if app_msi_ack = '1' then
                                int_state <= RST_STATE;
                            else
                                app_msi_req <= '1';
                            end if;
                        else
                            app_int_sts <= '1';
                            if app_int_ack_r = '1' then
                                int_state <= INT_WAIT_DEASSERT; 
                            end if;
                        end if;
                    when INT_WAIT_DEASSERT =>
                        if irq_state_cleared = '1' then
                            int_state <= INT_DEASSERT;
                        else
                            app_int_sts <= '1';
                        end if;
                    when INT_DEASSERT =>
                        if app_int_ack_r = '1' then
                            int_state <= RST_STATE;
                        end if;
                    when others => 
                        int_state <= RST_STATE;
                end case;
            end if;
        end if;
    end process;

    -- TODO: multi message
    app_msi_tc <= TC_MSI_INT;
    app_msi_num <= MSI_INT_NUM;

    process(clk_pcie)
    begin
        if rising_edge(clk_pcie) then
            tl_cfg_add_reg <= tl_cfg_add;
            tl_cfg_ctl_reg <= tl_cfg_ctl;
        end if;
    end process;

    process(clk_pcie)
    begin
        if rising_edge(clk_pcie) then
            if tl_cfg_add_reg = CFG_MSICSR_ADDR then
                cfg_msicsr <= tl_cfg_ctl_reg(15 downto 0);
            elsif tl_cfg_add_reg = CFG_BUSDEV_ADDR then
                cfg_completer_id <= tl_cfg_ctl_reg(12 downto 0) & "000";
            end if;
        end if;
    end process;

    p_fsm_reconfig : process(clk_pcie) -- reconfig fsm
    -- do not initialize this on pcie reset because during the disable state of ltssm the
    -- hard macro generates and forwards a pcie rst
    begin
        if rising_edge(clk_pcie) then
            reconfig_trigger_d <= reconfig_trigger_r;
    
            if reconfig_trigger_r = '1' and reconfig_trigger_d = '0' then
                reconfig_trigger_i <= '1';
            else
                reconfig_trigger_i <= '0';
            end if;


            case trig_st is
                when TRIG_IDLE =>
                    if reconfig_trigger_i = '1' then
                        if reconfig_trigger_mode(RECONFIG_MODE) = RECONFIG_PCIE then
                            trig_st <= TRIG_PCIE;
                        else
                            trig_st <= TRIG_IMM;
                        end if;
                    end if;
                when TRIG_PCIE =>
                    if ltssmstate = LTSSM_DET_ACTIVE_STATE then -- wait for link to be disabled before toggling trigger
                        trig_st <= TRIG_IMM;
                    end if;
                when TRIG_IMM =>
                    if (trigger_pulse_cnt = 0) then
                        trig_st <= TRIG_IDLE;
                    else 
                        trig_st <= TRIG_IMM;
                    end if;
                when others => 
                    trig_st <= TRIG_IDLE;
            end case;
        end if;  
    end process;
  
    p_reconfig_trig_gen : process(clk_pcie)
    begin
        if rising_edge(clk_pcie) then
            -- counter
            if (trig_st = TRIG_IDLE) then
                trigger_pulse_cnt <= X"FFFF";
            elsif (trig_st = TRIG_IMM and pcie_sync_rst_n = '1') then
                trigger_pulse_cnt <= trigger_pulse_cnt - 1;
            end if;
    
            if (trig_st = TRIG_IMM) then
                reconfig_trigger_toggle <= '1';
            else
                reconfig_trigger_toggle <= '0';
            end if;
        end if;
    end process;
    config_reconfig_trigger <= reconfig_trigger_toggle;

    -- completion FSM
    process(clk_pcie)
    variable compl_fifo_read_v, compl_req_o_v : std_logic := '0';
    begin
        if rising_edge(clk_pcie) then
            if pcie_sync_rst_n = '0' then
                slave_state <= START;
                compl_fifo_read <= '0';
                tx_reg_compl_req <= '0';
            else
                compl_fifo_read_v := '0';
                compl_req_o_v := '0';


                -- read completion fifo
                case slave_state is
                    when START =>
                        if compl_fifo_empty = '0' then
                            compl_fifo_read_v := '1';
                            slave_state <= WAIT_READ; 
                        end if;
                    when WAIT_READ =>
                        slave_state <= WAIT_READ_2;   
                    when WAIT_READ_2 =>
                        slave_state <= WAIT_READ_3;
                    when WAIT_READ_3 =>
                        if (compl_src_bar2 = '1') then
                            slave_state <= WAIT_READ_4;
                        else
                            slave_state <= WAIT_ACK;
                        end if;
                    when WAIT_READ_4 =>
                        slave_state <= WAIT_ACK;
                    when WAIT_ACK =>
                        if tx_reg_compl_ack = '1' then
                            slave_state <= START;
                        else
                            compl_req_o_v := '1';
                        end if;
                    when others =>
                        slave_state <= START;
                end case;

                compl_fifo_read <= compl_fifo_read_v;
                tx_reg_compl_req <= compl_req_o_v;
            end if;
        end if;
    end process;

    process(clk_pcie)
    begin
        if rising_edge(clk_pcie) then
            if (mapped_elements_reset_i = '1' or pcie_sync_rst_n = '0') then
                mapped_elements_reset <= '1';
            else
                mapped_elements_reset <= '0';
            end if;
        end if;
    end process;


    process (clk_pcie)
    begin
        if rising_edge(clk_pcie) then
            bar_status_tx_fifo_empty_r <= bar_status_tx_fifo_empty;

            dma_complete_sth_real <= (others => '0');
            if req_interrupt_ctl_valid = '1' then
                dma_complete_sth_real <= req_interrupt_ctl_enable_id;
            end if;
        end if;
    end process;

    bar_parse_wr_addr_onehot <= write_reg_r;
    bar_parse_wr_data <= reg_data_out_r;
    bar_parse_wr_clk <= clk_pcie;
    bar_parse_wr_page_sel_onehot <= write_reg_page_sel_r;

    -- manage read/write data
    process(clk_pcie) 

    begin
        if rising_edge(clk_pcie) then
            if pcie_sync_rst_n = '0' then
                write_reg_r <= (others => '0');
                write_reg_page_sel_r <= (others => '0'); 
                write_reg_page_sel_r(0) <= '1';
                reg_data_addr_r <= (others => '0');
                reg_data_wren_r <= (others => '0');
                wr_inram <= '0';
                reg_data_out_r <= (others => '0');
                dma_abort_sfh <= (others => '0');
                dma_abort_sth <= (others => '0');
                control_toggle_int <= (others => '0');
                irq_state <= (others => '0');
                irq_state_cleared <= '1';
                compl_data_bar2 <= (others => '0');
                compl_data_bar0 <= (others => '0');
                --error_counter_int <= (others => '0');
                flash_tx_d <= (others => '0');
                flash_tx_addr <= '0';
                flash_tx_we <= '0';

                reconfig_trigger_r <= '0';
      
                dcm_multdiv <= (others => '0');
                soft_reset <= '0';
                read_addr_r <= (others => '0');

                register_in <= (others => '0');
                register_addr <= (others => '0');	
                flash_tx_d <= (others => '0');

                sfa_do_toggle <= (others => '0');
     
                -- Extended Interrupt Registers
                sfh_streams_finished <= (others => '0');
                sth_streams_finished <= (others => '0');
                mem_interrupts <= (others => '0');
                power_interrupts <= (others => '0');
                power_interrupt_en <= '0';
                max4n_interrupt_en <= '0';
                host_event_ack_int <= (others => '0');

                i2c_left_dimm_scl_from_host_int  <= '0';
                i2c_left_dimm_sda_from_host_int  <= '0';
                i2c_right_dimm_scl_from_host_int <= '0';
                i2c_right_dimm_sda_from_host_int <= '0';
                i2c_aux_scl_from_host_int     <= '0';
                i2c_aux_sda_from_host_int     <= '0';
                pmbus_scl_from_host_int          <= '0';
                pmbus_sda_from_host_int          <= '0';
                qsfp0_i2c_scl_from_host_int <= '0';
                qsfp0_i2c_sda_from_host_int <= '0';
                qsfp0_i2c_lpmode_int <= '0';
                qsfp1_i2c_scl_from_host_int <= '0';
                qsfp1_i2c_sda_from_host_int <= '0';
                qsfp1_i2c_lpmode_int <= '0';
                qsfp2_i2c_scl_from_host_int <= '0';
                qsfp2_i2c_sda_from_host_int <= '0';
                qsfp2_i2c_lpmode_int <= '0';
                qsfp3_i2c_scl_from_host_int <= '0';
                qsfp3_i2c_sda_from_host_int <= '0';
                qsfp3_i2c_lpmode_int <= '0';
                qsfp4_i2c_scl_from_host_int <= '0';
                qsfp4_i2c_sda_from_host_int <= '0';
                qsfp4_i2c_lpmode_int <= '0';
                qsfp5_i2c_scl_from_host_int <= '0';
                qsfp5_i2c_sda_from_host_int <= '0';
                qsfp5_i2c_lpmode_int <= '0';
                qsfp6_i2c_scl_from_host_int <= '0';
                qsfp6_i2c_sda_from_host_int <= '0';
                qsfp6_i2c_lpmode_int <= '0';
                qsfp7_i2c_scl_from_host_int <= '0';
                qsfp7_i2c_sda_from_host_int <= '0';
                qsfp7_i2c_lpmode_int <= '0';
                ptp_phy_mdio_scl_from_host_int  <= '1';
                ptp_phy_mdio_sda_from_host_int  <= '1';
                ptp_phy_sresetn_int <= '1';
      
                compute_reset_n_i		       <= '1';
                maxring_s_set_highZ_n_int <= (others => '0');
                maxring_id_set_highZ_n_int <= (others => '0');
                maxring_s_fh <= (others => '0');
                maxring_id_fh <= (others => '0');
                maxring_bus_select <= '0';

                mapped_elements_reset_i <= '0';
                mapped_elements_read <= '0';
                local_ifpga_session_key <= (others => '0');

                mapped_elements_reset_i <= '0';
                mapped_elements_select_dma <= '0';
                mapped_elements_data_in <= (others => '0');
                mapped_elements_fc_in  <= (others => '0');

                led_identify_toggle <= '0';
                sth_enable_interrupts_reg <= (others => '1');
                sfh_enable_interrupts_reg <= (others => '1');
                sfh_complete_masked <= (others => '0');
                sth_complete_masked <= (others => '0');

            else	
    
                host_event_ack_int <= (others => '0');
    
                -- mux input data for writing
                for page in 0 to BAR_MAX_PAGES-1 loop
                    if reg_data_bar0 = '1' and unsigned(reg_data_addr_qword(9 downto 9)) = page then
                        write_reg_page_sel_r(page) <= '1';
                    else
                        write_reg_page_sel_r(page) <= '0';
                    end if;
                end loop;
                for i in 0 to (BAR_MAX_DWORD_ADDR/2)-1 loop
                    if reg_data_bar0 = '1' and unsigned(reg_data_addr_qword(7 downto 0))=i then
                        write_reg_r(2*i) <= reg_data_wren(0);
                        write_reg_r((2*i)+1) <= reg_data_wren(4);
                    else
                        write_reg_r(2*i) <= '0';
                        write_reg_r((2*i)+1) <= '0';
                    end if;
                end loop;

                -- register address for sg ram
                reg_data_addr_r <= reg_data_addr_qword;
                reg_data_wren_r <= reg_data_wren;
                wr_inram <= reg_data_bar2;
  
                -- convert to big-endian
                reg_data_out_r <= reg_data_out;
                --reg_data_out_r(7 downto 0) <= reg_data_out(31 downto 24);
                --reg_data_out_r(15 downto 8) <= reg_data_out(23 downto 16);
                --reg_data_out_r(23 downto 16) <= reg_data_out(15 downto 8);
                --reg_data_out_r(31 downto 24) <= reg_data_out(7 downto 0);
                --reg_data_out_r(39 downto 32) <= reg_data_out(63 downto 56);
                --reg_data_out_r(47 downto 40) <= reg_data_out(55 downto 48);
                --reg_data_out_r(55 downto 48) <= reg_data_out(47 downto 40);
                --reg_data_out_r(63 downto 56) <= reg_data_out(39 downto 32);
     
                -- 08h: DDMA abort register
                if write_reg_page_sel_r(0) = '1' and write_reg_r(2) = '1' then
                    dma_abort_sfh <= reg_data_out_r(31 downto 0);
                else
                    dma_abort_sfh <= (others => '0');
                end if;

                -- 0ch: DDMA abort register
                if write_reg_page_sel_r(0) = '1' and write_reg_r(3) = '1' then
                    dma_abort_sth <= reg_data_out_r(63 downto 32);
                else
                    dma_abort_sth <= (others => '0');
                end if;

                -- Mapped Elements Controller Async reset
                if write_reg_page_sel_r(0) = '1' and write_reg_r(4) = '1' then
                    mapped_elements_reset_i <= reg_data_out_r(0);
                    mapped_elements_select_dma <= reg_data_out_r(1);
                end if;

                -- 0x14: MEC: Read from "To Host" FIFO
                mapped_elements_read <= write_reg_r(5);

                if write_reg_page_sel_r(0) = '1' and write_reg_r(6) = '1' then
                    mapped_elements_data_in <= reg_data_out_r(31 downto 0);
                end if;
      
                if write_reg_page_sel_r(0) = '1' and write_reg_r(7) = '1' then
                    mapped_elements_fc_in  <= reg_data_out_r(33 downto 32);
                end if;
      
                mapped_elements_write <= write_reg_r(7); 

                -- 20h: compute FPGA reset
                if write_reg_page_sel_r(0) = '1' and write_reg_r(8) = '1' then
                    compute_reset_n_i <= reg_data_out_r(0);
                end if; 

                -- 24h: mailbox register
                if write_reg_page_sel_r(0) = '1' and write_reg_r(9) = '1' then
                    mailbox <= reg_data_out_r(63 downto 32);
                end if;

                -- 28h: stream control register
                if write_reg_page_sel_r(0) = '1' and write_reg_r(10) = '1' then
                    control_toggle_int <= control_toggle_int xor reg_data_out_r(4 downto 0);
                    soft_reset <= reg_data_out_r(5);
                    dcm_multdiv <= reg_data_out_r(31 downto 16);
                else
                    soft_reset <= '0';
                end if;

                -- 0x2c: Identify LED toggle
                if write_reg_page_sel_r(0) = '1' and write_reg_r(11) = '1' then
                    led_identify_toggle <= not led_identify_toggle;
                end if;

                -- 3ch: IFPGA Link Local Session Key
                if write_reg_page_sel_r(0) = '1' and write_reg_r(15) = '1' then
                    local_ifpga_session_key <= reg_data_out_r(33 downto 32);
                end if;

                -- 34h: interrupt register
                irq_state <= (31 downto 5 => '0') & (max4n_interrupt_flag & power_interrupt_flag & mem_interrupt_flag & sth_interrupt_flag & sfh_interrupt_flag);
                if (irq_state = X"00000000")  then
                    irq_state_cleared <= '1';
                else
                    irq_state_cleared <= '0';
                end if;

                -- 44h: throttle limit
                if write_reg_page_sel_r(0) = '1' and write_reg_r(17) = '1' then
                    throttle_limit <= reg_data_out_r(42 downto 32);
                end if;

                -- 48h: mapped register data
                if write_reg_page_sel_r(0) = '1' and write_reg_r(18) = '1' then
                    register_in <= reg_data_out_r(31 downto 0);
                end if;

                -- 4ch: mapped register address
                if write_reg_page_sel_r(0) = '1' and write_reg_r(19) = '1' then
                    register_addr <= reg_data_out_r(63 downto 32);
                end if;

                -- 50h / 58h: Flash interface lsb
                if write_reg_page_sel_r(0) = '1' and write_reg_r(20) = '1' then
                    flash_tx_d(31 downto 0) <= reg_data_out_r(31 downto 0);  
                    flash_tx_we <= '1';
                    flash_tx_addr <= write_reg_r(22);
                else
                    flash_tx_we <= '0';
                end if;

                -- 54h / 5ch: Flash interface msb
                if write_reg_page_sel_r(0) = '1' and write_reg_r(21) = '1' then
                    flash_tx_d(63 downto 32) <= reg_data_out_r(63 downto 32);
                end if;
      
                -- 60h: CompFPGA config LSB
                if write_reg_page_sel_r(0) = '1' and write_reg_r(24) = '1' then
                    reconfig_trigger_mode(31 downto 0) <= reg_data_out_r(31 downto 0);
                end if;
                -- 64h: CompFPGA config MSB
                if write_reg_page_sel_r(0) = '1' and write_reg_r(25) = '1' then
                    if reg_data_out_r(63 downto 32) = X"FEEDBABA" then
                        reconfig_trigger_r <= '1';
                    end if;
                else
                    reconfig_trigger_r <= '0';
                end if;

                -- 0x70: Control streams select 
                if write_reg_page_sel_r(0) = '1' and write_reg_r(28) = '1' then
                    control_streams_select_i <= reg_data_out_r(3 downto 0);
                end if;

                -- 0x74: Control streams reset toggle
                if write_reg_page_sel_r(0) = '1' and write_reg_r(29) = '1' then
                    control_streams_reset_toggle_i <= not control_streams_reset_toggle_i;
                end if;

                -- 0x78: SFA toggle
                for i in 0 to sfa_do_toggle'left loop
                    sfa_do_toggle(i) <= write_reg_page_sel_r(0) and write_reg_r(30) and reg_data_out_r(i);
                end loop;

                -- 0x80 : Extended Interrupt register 0: finished streams from host
                sfh_complete_masked <= sfh_enable_interrupts_reg and dma_complete_sfh;
                if write_reg_page_sel_r(0) = '1' and write_reg_r(32) = '1' then
                    sfh_streams_finished <= (sfh_streams_finished xor reg_data_out_r(31 downto 0)) or sfh_complete_masked;
                else
                    sfh_streams_finished <= sfh_streams_finished or sfh_complete_masked;
                end if;
      
      
                -- 0x84 : Extended Interrupt register 1: finished streams to host
                sth_complete_masked <= sth_enable_interrupts_reg and dma_complete_sth_real;
                if write_reg_page_sel_r(0) = '1' and write_reg_r(33) = '1' then
                    sth_streams_finished <= (sth_streams_finished xor reg_data_out_r(63 downto 32)) or sth_complete_masked;
                else
                    sth_streams_finished <= sth_streams_finished or sth_complete_masked;
                end if;

                -- 0x88 : Extended Interrupt register 2: Memory Controller Interrupts
                if write_reg_page_sel_r(0) = '1' and write_reg_r(34) = '1' then
                    mem_interrupts <= (mem_interrupts xor reg_data_out_r(15 downto 0)) or stream_interrupt;
                else
                    mem_interrupts <= mem_interrupts or stream_interrupt;
                end if;
      
                -- 0xC0 : QSFP0 I2C
                if write_reg_page_sel_r(0) = '1' and write_reg_r(48) = '1' then
                    if reg_data_out_r(6) = '1' then
                        qsfp0_i2c_scl_from_host_int <= reg_data_out_r(4);
                    end if;
                    if reg_data_out_r(7) = '1' then
                        qsfp0_i2c_sda_from_host_int <= reg_data_out_r(5);
                    end if;
                    if reg_data_out_r(9) = '1' then
                        qsfp0_i2c_lpmode_int <= reg_data_out_r(8);
                    end if;
                end if;
                -- 0xC4 : QSFP1 I2C
                if write_reg_page_sel_r(0) = '1' and write_reg_r(49) = '1' then
                    if reg_data_out_r(6 + 32) = '1' then
                        qsfp1_i2c_scl_from_host_int <= reg_data_out_r(4 + 32);
                    end if;
                    if reg_data_out_r(7 + 32) = '1' then
                        qsfp1_i2c_sda_from_host_int <= reg_data_out_r(5 + 32);
                    end if;
                    if reg_data_out_r(9 + 32) = '1' then
                        qsfp1_i2c_lpmode_int <= reg_data_out_r(8 + 32);
                    end if;
                end if;
                -- 0xC8 : QSFP2 I2C
                if write_reg_page_sel_r(0) = '1' and write_reg_r(50) = '1' then
                    if reg_data_out_r(6) = '1' then
                        qsfp2_i2c_scl_from_host_int <= reg_data_out_r(4);
                    end if;
                    if reg_data_out_r(7) = '1' then
                        qsfp2_i2c_sda_from_host_int <= reg_data_out_r(5);
                    end if;
                    if reg_data_out_r(9) = '1' then
                        qsfp2_i2c_lpmode_int <= reg_data_out_r(8);
                    end if;
                end if;
                -- 0xCC : PTP PHY MDIO
                if write_reg_page_sel_r(0) = '1' and write_reg_r(51) = '1' then
                    if reg_data_out_r(6 + 32) = '1' then
                        ptp_phy_mdio_scl_from_host_int <= reg_data_out_r(4 + 32);
                    end if;
                    if reg_data_out_r(7 + 32) = '1' then
                        ptp_phy_mdio_sda_from_host_int <= reg_data_out_r(5 + 32);
                    end if;
                    if reg_data_out_r(9 + 32) = '1' then
                        ptp_phy_sresetn_int <= reg_data_out_r(8 + 32);
                    end if;
                end if;

                -- 0x8C : Extended Interrupt register 3: Power Events Interrupts
                if write_reg_page_sel_r(0) = '1' and write_reg_r(35) = '1' then
                    host_event_ack_int(NUM_EVENTS-1 downto 0) <= reg_data_out_r((NUM_EVENTS-1)+32 downto 32);
                    power_interrupts <= (power_interrupts xor reg_data_out_r((NUM_EVENTS-1)+32 downto 32));
                else
                    power_interrupts <= (power_interrupts or host_event_status(NUM_EVENTS-1 downto 0))
                    xor host_event_ack_int(NUM_EVENTS-1 downto 0);	-- do not re-enable IRQ if it has just been cleared
                end if;
                --power_interrupts(1) <= '0';	-- FIXME! Temporary hack to avoid DDR EVENT interrupts
                --power_interrupts(7) <= '0';	-- FIXME! Temporary hack to avoid AUX EVENT interrupts  

                -- 0x90 - 0x98: Extended Interrupt registers 4 - 6: MAX4N Events Interrupts (words 0 - 3)
                for i in 0 to NUM_MAX4N_EVENTS-1 loop
                    if IS_MAX4N = true and write_reg_page_sel_r(0) = '1' and write_reg_r((i / 32) + 36) = '1' then
                        host_event_ack_int(i + NUM_EVENTS) <= reg_data_out_r(i mod 64);
                        max4n_interrupts(i) <= max4n_interrupts(i) xor reg_data_out_r(i mod 64);
                    else
                        max4n_interrupts(i) <=
                        (max4n_interrupts(i) or host_event_status(i + NUM_EVENTS)) xor
                        host_event_ack_int(NUM_EVENTS + i); -- do not re-enable IRQ if it has just been cleared
                    end if;
                end loop;

                -- 0x100 : Left DIMM I2C
                if write_reg_page_sel_r(0) = '1' and write_reg_r(64) = '1' then
                    if reg_data_out_r(6) = '1' then
                        i2c_left_dimm_scl_from_host_int <= not(reg_data_out_r(4)); -- do polarity inversion here
                    end if;
                    if reg_data_out_r(7) = '1' then
                        i2c_left_dimm_sda_from_host_int <= not(reg_data_out_r(5)); -- do polarity inversion here
                    end if;
                end if;
                -- 0x104 : Right DIMM I2C
                if write_reg_page_sel_r(0) = '1' and write_reg_r(65) = '1' then
                    if reg_data_out_r(6 + 32) = '1' then
                        i2c_right_dimm_scl_from_host_int <= not(reg_data_out_r(4 + 32)); -- do polarity inversion here
                    end if;
                    if reg_data_out_r(7 + 32) = '1' then
                        i2c_right_dimm_sda_from_host_int <= not(reg_data_out_r(5 + 32)); -- do polarity inversion here
                    end if;
                end if;
                -- 0x108 : AUX I2C: Optical, EEPROM, Temp Sensor
                if write_reg_page_sel_r(0) = '1' and write_reg_r(66) = '1' then
                    if reg_data_out_r(6) = '1' then
                        i2c_aux_scl_from_host_int <= not(reg_data_out_r(4)); -- do polarity inversion here
                    end if;
                    if reg_data_out_r(7) = '1' then
                        i2c_aux_sda_from_host_int <= not(reg_data_out_r(5)); -- do polarity inversion here
                    end if;
                end if;
                -- 0x10C : PSU I2C
                if write_reg_page_sel_r(0) = '1' and write_reg_r(67) = '1' then
                    if reg_data_out_r(6 + 32) = '1' then
                        pmbus_scl_from_host_int <= not(reg_data_out_r(4 + 32)); -- do polarity inversion here
                    end if;
                    if reg_data_out_r(7 + 32) = '1' then
                        pmbus_sda_from_host_int <= not(reg_data_out_r(5 + 32)); -- do polarity inversion here
                    end if;
                end if;
                if write_reg_page_sel_r(0) = '1' and write_reg_r(68) = '1' then
                    power_interrupt_en <= reg_data_out_r(0);
                    max4n_interrupt_en <= reg_data_out_r(1);
                end if;
                -- 0x114: MaxRing
                if write_reg_page_sel_r(0) = '1' and write_reg_r(69) = '1' then
                    maxring_bus_select <= reg_data_out_r(23 + 32);
                    for i in 0 to 3 loop
                        if reg_data_out_r(4 + i + 32) = '1' then
                            if reg_data_out_r(23 + 32) = '1' then
                                maxring_id_set_highZ_n_int(i) <= reg_data_out_r(i + 32);
                            else
                                maxring_s_set_highZ_n_int(i) <= reg_data_out_r(i + 32);
                            end if;
                        end if;
                        if reg_data_out_r(12 + i + 32) = '1' then
                            if reg_data_out_r(23 + 32) = '1' then
                                maxring_id_fh(i) <= reg_data_out_r(i + 16 + 32);
                            else
                                maxring_s_fh(i) <= reg_data_out_r(i + 8 + 32);
                            end if;
                        end if;
                    end loop;
                end if;

                if write_reg_page_sel_r(0) = '1' and write_reg_r(78) = '1' then
                    sfh_enable_interrupts_reg <= reg_data_out_r(31 downto 0);
                end if;

                if write_reg_page_sel_r(0) = '1' and write_reg_r(79) = '1' then
                    sth_enable_interrupts_reg <= reg_data_out_r(63 downto 32);
                end if;

                -- 0x140 : QSFP3 I2C
                if write_reg_page_sel_r(0) = '1' and write_reg_r(80) = '1' then
                    if reg_data_out_r(6) = '1' then
                        qsfp3_i2c_scl_from_host_int <= reg_data_out_r(4);
                    end if;
                    if reg_data_out_r(7) = '1' then
                        qsfp3_i2c_sda_from_host_int <= reg_data_out_r(5);
                    end if;
                    if reg_data_out_r(9) = '1' then
                        qsfp3_i2c_lpmode_int <= reg_data_out_r(8);
                    end if;
                end if;
                -- 0x144 : QSFP4 I2C
                if write_reg_page_sel_r(0) = '1' and write_reg_r(81) = '1' then
                    if reg_data_out_r(6 + 32) = '1' then
                        qsfp4_i2c_scl_from_host_int <= reg_data_out_r(4 + 32);
                    end if;
                    if reg_data_out_r(7 + 32) = '1' then
                        qsfp4_i2c_sda_from_host_int <= reg_data_out_r(5 + 32);
                    end if;
                    if reg_data_out_r(9 + 32) = '1' then
                        qsfp4_i2c_lpmode_int <= reg_data_out_r(8 + 32);
                    end if;
                end if;
                -- 0x148 : QSFP5 I2C
                if write_reg_page_sel_r(0) = '1' and write_reg_r(82) = '1' then
                    if reg_data_out_r(6) = '1' then
                        qsfp5_i2c_scl_from_host_int <= reg_data_out_r(4);
                    end if;
                    if reg_data_out_r(7) = '1' then
                        qsfp5_i2c_sda_from_host_int <= reg_data_out_r(5);
                    end if;
                    if reg_data_out_r(9) = '1' then
                        qsfp5_i2c_lpmode_int <= reg_data_out_r(8);
                    end if;
                end if;
                -- 0x14C : QSFP6 I2C
                if write_reg_page_sel_r(0) = '1' and write_reg_r(83) = '1' then
                    if reg_data_out_r(6 + 32) = '1' then
                        qsfp6_i2c_scl_from_host_int <= reg_data_out_r(4 + 32);
                    end if;
                    if reg_data_out_r(7 + 32) = '1' then
                        qsfp6_i2c_sda_from_host_int <= reg_data_out_r(5 + 32);
                    end if;
                    if reg_data_out_r(9 + 32) = '1' then
                        qsfp6_i2c_lpmode_int <= reg_data_out_r(8 + 32);
                    end if;
                end if;
                -- 0x150 : QSFP7 I2C
                if write_reg_page_sel_r(0) = '1' and write_reg_r(84) = '1' then
                    if reg_data_out_r(6) = '1' then
                        qsfp7_i2c_scl_from_host_int <= reg_data_out_r(4);
                    end if;
                    if reg_data_out_r(7) = '1' then
                        qsfp7_i2c_sda_from_host_int <= reg_data_out_r(5);
                    end if;
                    if reg_data_out_r(9) = '1' then
                        qsfp7_i2c_lpmode_int <= reg_data_out_r(8);
                    end if;
                end if;


                -- register read_addr out of fifo
                read_addr_r <= read_addr;


                if read_addr_r(10) = '0' then
                    -- Page 0 register reads
                    -- mux output data for completion
                    case read_addr_r(7 downto 0) is
                        when X"00" =>
                            compl_data_bar0 <= X"A61C" & X"0003"; -- Magic Number & Bar Space Version 3
                        when X"01" =>
                            compl_data_bar0 <= conv_std_logic_vector(NUM_STREAMS_TO_HOST, 16) & conv_std_logic_vector(NUM_STREAMS_FROM_HOST, 16);
                        when X"04" =>
                            compl_data_bar0 <= mapped_elements_version;
                        when X"05" =>
                            compl_data_bar0 <= mapped_elements_empty & mapped_elements_fc_type & (28 downto 1 => '0') & mapped_elements_toggle;
                        when X"06" =>
                            compl_data_bar0 <= mapped_elements_data;
                        when X"07" =>
                            compl_data_bar0 <= (31 downto mapped_elements_fill'length => '0') & mapped_elements_fill;
                        when X"09" => -- mailbox(31 downto 0);
                            compl_data_bar0 <= mailbox(31 downto 0);
                        when X"0a" => -- stream control
                            compl_data_bar0 <= '0' & capabilities(30 downto 0); -- FIXME capabilities;
                        when X"0c" => -- retraining
                            compl_data_bar0 <= X"000000" & retrain_count;
                        when X"0d" => -- interrupt
                            compl_data_bar0 <= irq_state;
                        when X"10" => -- PCIe capabilities
                            compl_data_bar0 <= X"B61C" & pcie_capabilities;
                        when X"12" => -- mapped reg data
                            compl_data_bar0 <= register_out;
                        when X"13" => -- mapped reg completeion toggle
                            compl_data_bar0 <= X"0000000" & "000" & register_completion_toggle;
                        when X"14" => -- Flash interface low
                            compl_data_bar0 <= flash_rx_d(31 downto 0);
                        when X"15" => -- Flash interface high
                            compl_data_bar0 <= flash_rx_d(63 downto 32);
                        when X"16" => -- Flash interface levels low
                            compl_data_bar0 <= flash_rx_d(31 downto 0);
                        when X"17" => -- Flash interface levels high
                            compl_data_bar0 <= flash_rx_d(63 downto 32);         
                        when X"18" => -- CompFPGA config status LSB
                            compl_data_bar0 <= reconfig_trigger_mode(31 downto 0);
                        when X"19" => -- CompFPGA config status MSB
                            compl_data_bar0 <= (others => '0');
                        when X"1B" =>
                            compl_data_bar0 <= (31 downto 24 => '0') & sfh_cap_ctrl_0 & (15 downto 8 => '0') & sth_cap_ctrl_0;
                        when X"1C" =>
                            compl_data_bar0 <= (31 downto 1 => '0') & '1'; -- Control Streams Presence Register: CI
                        when X"1E" =>
                            compl_data_bar0 <= '1' & (30 downto host_sfa_toggle_acked'length => '0') & host_sfa_toggle_acked;
                        when X"1F" =>
                            compl_data_bar0 <= (31 downto 1 => '0') & bar_status_tx_fifo_empty_r; 
                        when X"20" =>  -- Extended Interrupt register 0
                            compl_data_bar0 <= sfh_streams_finished;
                        when X"21" =>  -- Extended Interrupt register 1
                            compl_data_bar0 <= sth_streams_finished;
                        when X"22" =>  -- Extended Interrupt register 2
                            compl_data_bar0 <= (31 downto 16 => '0') & mem_interrupts;
                        when X"23" =>  -- Extended Interrupt register 3
                            compl_data_bar0 <= (31 downto NUM_EVENTS => '0') & power_interrupts;
                        when X"24" => -- Extended Interrupt register 4
                            if IS_MAX4N = true then
                                compl_data_bar0 <= max4n_interrupts(31 downto 0);
                            else
                                compl_data_bar0 <= (others => '0');
                            end if;
                        when X"25" => -- Extended Interrupt register 5
                            if IS_MAX4N = true then
                                compl_data_bar0 <= max4n_interrupts(63 downto 32);
                            else
                                compl_data_bar0 <= (others => '0');
                            end if;
                        when X"26" => -- Extended Interrupt register 6
                            if IS_MAX4N = true then
                                compl_data_bar0 <= (31 downto (NUM_MAX4N_EVENTS-64) => '0') & max4n_interrupts(NUM_MAX4N_EVENTS-1 downto 64);
                            else
                                compl_data_bar0 <= (others => '0');
                            end if;
                        when X"30" => -- QSFP0 I2C
                            compl_data_bar0 <=  (31 downto 11 => '0') & qsfp0_i2c_modprsl
                            & '0'  & qsfp0_i2c_alert
                            & "00" & qsfp0_i2c_sda_from_host_int
                            & qsfp0_i2c_scl_from_host_int
                            & "00" & qsfp0_i2c_sda_fb
                            & qsfp0_i2c_scl_fb;
                        when X"31" => -- QSFP1 I2C
                            compl_data_bar0 <=  (31 downto 11 => '0') & qsfp1_i2c_modprsl
                            & '0'  & qsfp1_i2c_alert
                            & "00" & qsfp1_i2c_sda_from_host_int
                            & qsfp1_i2c_scl_from_host_int
                            & "00"
                            & qsfp1_i2c_sda_fb
                            & qsfp1_i2c_scl_fb;
                        when X"32" => -- QSFP2 I2C
                            compl_data_bar0 <=  (31 downto 11 => '0') & qsfp2_i2c_modprsl
                            & '0'  & qsfp2_i2c_alert
                            & "00" & qsfp2_i2c_sda_from_host_int
                            & qsfp2_i2c_scl_from_host_int
                            & "00" & qsfp2_i2c_sda_fb
                            & qsfp2_i2c_scl_fb;
                                
                        when X"33" => -- PTP PHY MDIO
                            compl_data_bar0 <=  (31 downto 9 => '0') & ptp_phy_mdio_event_to_host
                            & "00" & ptp_phy_mdio_sda_from_host_int & ptp_phy_mdio_scl_from_host_int
                            & "00" & ptp_phy_mdio_sda_to_host       & ptp_phy_mdio_scl_to_host;
                        when X"34" =>
                            compl_data_bar0 <= sfh_cap(31+00 downto 0+00);
                        when X"35" =>
                            compl_data_bar0 <= sfh_cap(31+32 downto 0+32);
                        when X"36" =>
                            compl_data_bar0 <= sfh_cap(31+64 downto 0+64);
                        when X"37" =>
                            compl_data_bar0 <= sfh_cap(31+96 downto 0+96);
                        when X"3A" =>
                            compl_data_bar0 <= sth_cap(31+00 downto 0+00);
                        when X"3B" =>
                            compl_data_bar0 <= sth_cap(31+32 downto 0+32);
                        when X"3C" =>
                            compl_data_bar0 <= sth_cap(31+64 downto 0+64);
                        when X"3D" =>
                            compl_data_bar0 <= sth_cap(31+96 downto 0+96);
                        when X"40" => -- Left DIMM I2C
                            compl_data_bar0 <=  (31 downto 9 => '0') & i2c_dimm_alert
                            & "00" & i2c_left_dimm_sda_from_host_int  & i2c_left_dimm_scl_from_host_int
                            & "00" & i2c_left_dimm_sda_fb        & i2c_left_dimm_scl_fb;
                        when X"41" => -- Right DIMM I2C
                            compl_data_bar0 <=  (31 downto 8 => '0')
                            & "00" & i2c_right_dimm_sda_from_host_int & i2c_right_dimm_scl_from_host_int
                            & "00" & i2c_right_dimm_sda_fb       & i2c_right_dimm_scl_fb;
                        when X"42" => -- AUX I2C: Optical, EEPROM, Temp Sensor
                            compl_data_bar0 <=  (31 downto 9 => '0') & i2c_aux_alert
                            & "00" & i2c_aux_sda_from_host_int & i2c_aux_scl_from_host_int
                            & "00" & i2c_aux_sda_fb       & i2c_aux_scl_fb;
                        when X"43" => -- PSU I2C
                            compl_data_bar0 <=  (31 downto 9 => '0') & pmbus_alert
                            & "00" & pmbus_sda_from_host_int & pmbus_scl_from_host_int
                            & "00" & pmbus_sda_fb       & pmbus_scl_fb;
                        when X"44" =>
                            compl_data_bar0 <= (31 downto 2 => '0') & max4n_interrupt_en & power_interrupt_en;
                        when X"45" =>
                            compl_data_bar0 <=  (31 downto 24 => '0') & maxring_bus_select & maxring_prsn_th
                            & maxring_type_th & maxring_id_th
                            & "0000" & maxring_s_th
                            & "0000" & maxring_bus_highZ;
                        when X"46" =>  -- CvP Config Info
                            compl_data_bar0 <= (31 downto 3 => '0') & config_fpga_init_done 
                            & config_fpga_crc_error & config_fpga_cvp_confdone;
                        when X"47" =>  -- DIP Switches, PCB & Assy Rev
                            compl_data_bar0 <= (31 downto 18 => '0') & rev_build_rev & rev_cpld_version & rev_dipsw 
                            & rev_pcb_rev & rev_assy_rev;
          
                        when X"4E" => -- Interrupt enable register
                            compl_data_bar0 <= sfh_enable_interrupts_reg;
                        when X"4F" => -- Interrupt enable register
                            compl_data_bar0 <= sth_enable_interrupts_reg;
                        when X"50" => -- QSFP3 I2C
                            compl_data_bar0 <=  (31 downto 11 => '0') & qsfp3_i2c_modprsl
                            & '0'  & qsfp3_i2c_alert
                            & "00" & qsfp3_i2c_sda_from_host_int
                            & qsfp3_i2c_scl_from_host_int
                            & "00" & qsfp3_i2c_sda_fb
                            & qsfp3_i2c_scl_fb;
                        when X"51" => -- QSFP4 I2C
                            compl_data_bar0 <=  (31 downto 11 => '0') & qsfp4_i2c_modprsl
                            & '0'  & qsfp4_i2c_alert
                            & "00" & qsfp4_i2c_sda_from_host_int
                            & qsfp4_i2c_scl_from_host_int
                            & "00"
                            & qsfp4_i2c_sda_fb
                            & qsfp4_i2c_scl_fb;
                        when X"52" => -- QSFP5 I2C
                            compl_data_bar0 <=  (31 downto 11 => '0') & qsfp5_i2c_modprsl
                            & '0'  & qsfp5_i2c_alert
                            & "00" & qsfp5_i2c_sda_from_host_int
                            & qsfp5_i2c_scl_from_host_int
                            & "00" & qsfp5_i2c_sda_fb
                            & qsfp5_i2c_scl_fb;
                        when X"53" => -- QSFP6 I2C
                            compl_data_bar0 <=  (31 downto 11 => '0') & qsfp6_i2c_modprsl
                            & '0'  & qsfp6_i2c_alert
                            & "00" & qsfp6_i2c_sda_from_host_int
                            & qsfp6_i2c_scl_from_host_int
                            & "00"
                            & qsfp6_i2c_sda_fb
                            & qsfp6_i2c_scl_fb;
                        when X"54" => -- QSFP7 I2C
                            compl_data_bar0 <=  (31 downto 11 => '0') & qsfp7_i2c_modprsl
                            & '0'  & qsfp7_i2c_alert
                            & "00" & qsfp7_i2c_sda_from_host_int
                            & qsfp7_i2c_scl_from_host_int
                            & "00" & qsfp7_i2c_sda_fb
                            & qsfp7_i2c_scl_fb;
                      when others =>
                            compl_data_bar0 <= X"00000000";
                    end case;
      
                    -- Page1 register reads
                else
                    if read_addr_r(9 downto 0) = "00" & X"C2" then
                        compl_data_bar0 <= slave_streaming_buf_cap;
                        -- Addresses 0xA0 to (max) 0xAF
                    elsif read_addr_r(9 downto 4) = "00" & X"A" then
                        compl_data_bar0 <= X"00000000"; 	-- default assignment
                        for i in 0 to NUM_STREAMS_FROM_HOST loop
                            if i = conv_integer(unsigned(read_addr_r(3 downto 0))) then
                                compl_data_bar0 <= (others => '0');
                                compl_data_bar0(SLAVE_RB_CREDITS_WIDTH downto 0) <= slave_sfh_card_credits_wrap(i) & slave_sfh_card_credits_index(SLAVE_RB_CREDITS_WIDTH*(i+1)-1 downto (SLAVE_RB_CREDITS_WIDTH*i));
                            end if;
                        end loop;
                        -- Addresses 0xB0 to (max) 0xBF
                    elsif read_addr_r(9 downto 4) = "00" & X"B" then
                        compl_data_bar0 <= X"00000000"; 	-- default assignment
                        for i in 0 to NUM_STREAMS_TO_HOST loop
                            if i = conv_integer(unsigned(read_addr_r(3 downto 0))) then
                                compl_data_bar0 <= (others => '0');
                                compl_data_bar0(SLAVE_RB_CREDITS_WIDTH downto 0) <= slave_sth_card_credits_wrap(i) & slave_sth_card_credits_index(SLAVE_RB_CREDITS_WIDTH*(i+1)-1 downto (SLAVE_RB_CREDITS_WIDTH*i));
                            end if;
                        end loop;
                    else
                        compl_data_bar0 <= X"00000000";
                    end if;
                end if;
  

                if (reg_data_addr_high = '1') then
                    compl_data_bar2 <= dma_ctl_read_data(63 downto 32);
                else
                    compl_data_bar2 <= dma_ctl_read_data(31 downto 0);
                end if;
	
                if compl_src_bar2 = '1' then
                    compl_data <= compl_data_bar2;
                else
                    compl_data <= compl_data_bar0;
                end if;

            end if;
        end if;
    end process;


    flash_rx_addr <= read_addr(1);

    tx_reg_compl_data(31 downto 0) <= compl_data(31 downto 0);
    --tx_reg_compl_data(31 downto 24) <= compl_data(7 downto 0);
    --tx_reg_compl_data(23 downto 16) <= compl_data(15 downto 8);
    --tx_reg_compl_data(15 downto 8) <= compl_data(23 downto 16);
    --tx_reg_compl_data(7 downto 0) <= compl_data(31 downto 24);
    tx_reg_compl_size <= "0000000001"; -- always 1-dword completions

    dma_ctl_address <= reg_data_addr_r(8 downto 0);
    dma_ctl_data <= reg_data_out_r;
    dma_ctl_write <= wr_inram;
    dma_ctl_byte_en <= reg_data_wren_r;

end rtl;
