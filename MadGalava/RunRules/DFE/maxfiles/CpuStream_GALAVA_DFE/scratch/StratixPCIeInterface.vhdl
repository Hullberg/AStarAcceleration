library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity StratixPCIeInterface is
	port (
		clk_pcie: in std_logic;
		rst_pcie_n: in std_logic;
		tx_st_ready: in std_logic;
		cfg_completer_id: in std_logic_vector(15 downto 0);
		tx_dma_write_req: in std_logic;
		tx_dma_write_addr: in std_logic_vector(63 downto 0);
		tx_dma_write_tag: in std_logic_vector(7 downto 0);
		tx_dma_write_len: in std_logic_vector(8 downto 0);
		tx_dma_write_wide_addr: in std_logic;
		tx_dma_write_rddata: in std_logic_vector(127 downto 0);
		tx_dma_read_dma_read_req: in std_logic;
		tx_dma_read_dma_read_addr: in std_logic_vector(63 downto 0);
		tx_dma_read_dma_read_len: in std_logic_vector(9 downto 0);
		tx_dma_read_dma_read_be: in std_logic_vector(3 downto 0);
		tx_dma_read_dma_read_tag: in std_logic_vector(7 downto 0);
		tx_dma_read_dma_read_wide_addr: in std_logic;
		tx_reg_compl_req: in std_logic;
		tx_reg_compl_tc: in std_logic_vector(2 downto 0);
		tx_reg_compl_td: in std_logic;
		tx_reg_compl_ep: in std_logic;
		tx_reg_compl_attr: in std_logic_vector(1 downto 0);
		tx_reg_compl_rid: in std_logic_vector(15 downto 0);
		tx_reg_compl_tag: in std_logic_vector(7 downto 0);
		tx_reg_compl_addr: in std_logic_vector(12 downto 0);
		tx_reg_compl_data: in std_logic_vector(63 downto 0);
		tx_reg_compl_size: in std_logic_vector(9 downto 0);
		tx_slave_stream_compl_req: in std_logic;
		tx_slave_stream_compl_tc: in std_logic_vector(2 downto 0);
		tx_slave_stream_compl_td: in std_logic;
		tx_slave_stream_compl_ep: in std_logic;
		tx_slave_stream_compl_attr: in std_logic_vector(1 downto 0);
		tx_slave_stream_compl_rid: in std_logic_vector(15 downto 0);
		tx_slave_stream_compl_tag: in std_logic_vector(7 downto 0);
		tx_slave_stream_compl_addr: in std_logic_vector(6 downto 0);
		tx_slave_stream_compl_size: in std_logic_vector(11 downto 0);
		tx_slave_stream_compl_rem_size: in std_logic_vector(11 downto 0);
		tx_slave_stream_compl_data: in std_logic_vector(127 downto 0);
		rx_st_valid: in std_logic;
		rx_st_sop: in std_logic;
		rx_st_eop: in std_logic;
		rx_st_empty: in std_logic_vector(1 downto 0);
		rx_st_err: in std_logic;
		rx_st_bar: in std_logic_vector(7 downto 0);
		rx_st_data: in std_logic_vector(127 downto 0);
		rx_reg_read_compl_full: in std_logic;
		tx_st_valid: out std_logic;
		tx_st_sop: out std_logic;
		tx_st_eop: out std_logic;
		tx_st_empty: out std_logic_vector(1 downto 0);
		tx_st_err: out std_logic;
		tx_st_data: out std_logic_vector(127 downto 0);
		tx_dma_write_ack: out std_logic;
		tx_dma_write_done: out std_logic;
		tx_dma_write_busy: out std_logic;
		tx_dma_write_rden: out std_logic;
		tx_dma_read_dma_read_ack: out std_logic;
		tx_reg_compl_rden: out std_logic;
		tx_reg_compl_ack: out std_logic;
		tx_slave_stream_compl_ack: out std_logic;
		tx_slave_stream_compl_rden: out std_logic;
		tx_slave_stream_compl_done: out std_logic;
		rx_st_ready: out std_logic;
		rx_st_mask: out std_logic;
		cpl_err: out std_logic_vector(6 downto 0);
		cpl_pending: out std_logic;
		rx_dma_response_dma_response_data: out std_logic_vector(127 downto 0);
		rx_dma_response_dma_response_valid: out std_logic_vector(1 downto 0);
		rx_dma_response_dma_response_len: out std_logic_vector(9 downto 0);
		rx_dma_response_dma_response_tag: out std_logic_vector(7 downto 0);
		rx_dma_response_dma_response_complete: out std_logic;
		rx_dma_response_dma_response_ready: out std_logic;
		rx_reg_write_reg_data_out: out std_logic_vector(63 downto 0);
		rx_reg_write_reg_data_wren: out std_logic_vector(7 downto 0);
		rx_reg_write_reg_data_addr: out std_logic_vector(63 downto 0);
		rx_reg_write_reg_data_bar0: out std_logic;
		rx_reg_write_reg_data_bar2: out std_logic;
		rx_reg_read_compl_tc: out std_logic_vector(2 downto 0);
		rx_reg_read_compl_td: out std_logic;
		rx_reg_read_compl_ep: out std_logic;
		rx_reg_read_compl_attr: out std_logic_vector(1 downto 0);
		rx_reg_read_compl_rid: out std_logic_vector(15 downto 0);
		rx_reg_read_compl_tag: out std_logic_vector(7 downto 0);
		rx_reg_read_compl_addr: out std_logic_vector(63 downto 0);
		rx_reg_read_compl_bar2: out std_logic;
		rx_reg_read_compl_req: out std_logic;
		rx_reg_read_compl_size: out std_logic_vector(9 downto 0);
		rx_slave_stream_req_sl_en: out std_logic;
		rx_slave_stream_req_sl_wr_en: out std_logic;
		rx_slave_stream_req_sl_wr_addr: out std_logic_vector(63 downto 0);
		rx_slave_stream_req_sl_wr_size: out std_logic_vector(9 downto 0);
		rx_slave_stream_req_sl_wr_data: out std_logic_vector(127 downto 0);
		rx_slave_stream_req_sl_wr_be: out std_logic_vector(15 downto 0);
		rx_slave_stream_req_sl_wr_last: out std_logic;
		rx_slave_stream_req_sl_rd_en: out std_logic;
		rx_slave_stream_req_sl_rd_tc: out std_logic_vector(2 downto 0);
		rx_slave_stream_req_sl_rd_td: out std_logic;
		rx_slave_stream_req_sl_rd_ep: out std_logic;
		rx_slave_stream_req_sl_rd_attr: out std_logic_vector(1 downto 0);
		rx_slave_stream_req_sl_rd_rid: out std_logic_vector(15 downto 0);
		rx_slave_stream_req_sl_rd_tag: out std_logic_vector(7 downto 0);
		rx_slave_stream_req_sl_rd_be: out std_logic_vector(7 downto 0);
		rx_slave_stream_req_sl_rd_addr: out std_logic_vector(63 downto 0);
		rx_slave_stream_req_sl_rd_size: out std_logic_vector(9 downto 0)
	);
end StratixPCIeInterface;

architecture MaxDC of StratixPCIeInterface is
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
	component max_SV_pcie_tx is
		port (
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			tx_st_ready: in std_logic;
			cfg_completer_id: in std_logic_vector(15 downto 0);
			dma_write_req: in std_logic;
			dma_write_addr: in std_logic_vector(63 downto 0);
			dma_write_tag: in std_logic_vector(7 downto 0);
			dma_write_len: in std_logic_vector(8 downto 0);
			dma_write_wide_addr: in std_logic;
			dma_write_rddata: in std_logic_vector(127 downto 0);
			dma_read_req: in std_logic;
			dma_read_addr: in std_logic_vector(63 downto 0);
			dma_read_len: in std_logic_vector(9 downto 0);
			dma_read_be: in std_logic_vector(3 downto 0);
			dma_read_tag: in std_logic_vector(7 downto 0);
			dma_read_wide_addr: in std_logic;
			compl_req: in std_logic;
			compl_tc: in std_logic_vector(2 downto 0);
			compl_td: in std_logic;
			compl_ep: in std_logic;
			compl_attr: in std_logic_vector(1 downto 0);
			compl_rid: in std_logic_vector(15 downto 0);
			compl_tag: in std_logic_vector(7 downto 0);
			compl_addr: in std_logic_vector(12 downto 0);
			compl_data: in std_logic_vector(63 downto 0);
			compl_size: in std_logic_vector(9 downto 0);
			sl_rd_compl_req: in std_logic;
			sl_rd_compl_tc: in std_logic_vector(2 downto 0);
			sl_rd_compl_td: in std_logic;
			sl_rd_compl_ep: in std_logic;
			sl_rd_compl_attr: in std_logic_vector(1 downto 0);
			sl_rd_compl_rid: in std_logic_vector(15 downto 0);
			sl_rd_compl_tag: in std_logic_vector(7 downto 0);
			sl_rd_compl_addr: in std_logic_vector(6 downto 0);
			sl_rd_compl_size: in std_logic_vector(11 downto 0);
			sl_rd_compl_rem_size: in std_logic_vector(11 downto 0);
			sl_rd_compl_data: in std_logic_vector(127 downto 0);
			tx_st_valid: out std_logic;
			tx_st_sop: out std_logic;
			tx_st_eop: out std_logic;
			tx_st_empty: out std_logic_vector(1 downto 0);
			tx_st_err: out std_logic;
			tx_st_data: out std_logic_vector(127 downto 0);
			dma_write_ack: out std_logic;
			dma_write_done: out std_logic;
			dma_write_busy: out std_logic;
			dma_write_rden: out std_logic;
			dma_read_ack: out std_logic;
			compl_rden: out std_logic;
			compl_ack: out std_logic;
			sl_rd_compl_ack: out std_logic;
			sl_rd_compl_rden: out std_logic;
			sl_rd_compl_done: out std_logic
		);
	end component;
	component max_SV_pcie_rx is
		generic (
			SIM_RX : boolean
		);
		port (
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			rx_st_valid: in std_logic;
			rx_st_sop: in std_logic;
			rx_st_eop: in std_logic;
			rx_st_empty: in std_logic_vector(1 downto 0);
			rx_st_err: in std_logic;
			rx_st_bar: in std_logic_vector(7 downto 0);
			rx_st_data: in std_logic_vector(127 downto 0);
			compl_full: in std_logic;
			rx_st_ready: out std_logic;
			rx_st_mask: out std_logic;
			cpl_err: out std_logic_vector(6 downto 0);
			cpl_pending: out std_logic;
			dma_response_data: out std_logic_vector(127 downto 0);
			dma_response_valid: out std_logic_vector(1 downto 0);
			dma_response_len: out std_logic_vector(9 downto 0);
			dma_response_tag: out std_logic_vector(7 downto 0);
			dma_response_complete: out std_logic;
			dma_response_ready: out std_logic;
			reg_data_out: out std_logic_vector(63 downto 0);
			reg_data_wren: out std_logic_vector(7 downto 0);
			reg_data_addr: out std_logic_vector(63 downto 0);
			reg_data_bar0: out std_logic;
			reg_data_bar2: out std_logic;
			compl_tc: out std_logic_vector(2 downto 0);
			compl_td: out std_logic;
			compl_ep: out std_logic;
			compl_attr: out std_logic_vector(1 downto 0);
			compl_rid: out std_logic_vector(15 downto 0);
			compl_tag: out std_logic_vector(7 downto 0);
			compl_addr: out std_logic_vector(63 downto 0);
			compl_bar2: out std_logic;
			compl_req: out std_logic;
			compl_size: out std_logic_vector(9 downto 0);
			sl_en: out std_logic;
			sl_wr_en: out std_logic;
			sl_wr_addr: out std_logic_vector(63 downto 0);
			sl_wr_size: out std_logic_vector(9 downto 0);
			sl_wr_data: out std_logic_vector(127 downto 0);
			sl_wr_be: out std_logic_vector(15 downto 0);
			sl_wr_last: out std_logic;
			sl_rd_en: out std_logic;
			sl_rd_tc: out std_logic_vector(2 downto 0);
			sl_rd_td: out std_logic;
			sl_rd_ep: out std_logic;
			sl_rd_attr: out std_logic_vector(1 downto 0);
			sl_rd_rid: out std_logic_vector(15 downto 0);
			sl_rd_tag: out std_logic_vector(7 downto 0);
			sl_rd_be: out std_logic_vector(7 downto 0);
			sl_rd_addr: out std_logic_vector(63 downto 0);
			sl_rd_size: out std_logic_vector(9 downto 0)
		);
	end component;
	
	-- Signal declarations
	
	signal stratixvpcietx_i_tx_st_valid : std_logic_vector(0 downto 0);
	signal stratixvpcietx_i_tx_st_sop : std_logic_vector(0 downto 0);
	signal stratixvpcietx_i_tx_st_eop : std_logic_vector(0 downto 0);
	signal stratixvpcietx_i_tx_st_empty : std_logic_vector(1 downto 0);
	signal stratixvpcietx_i_tx_st_err : std_logic_vector(0 downto 0);
	signal stratixvpcietx_i_tx_st_data : std_logic_vector(127 downto 0);
	signal stratixvpcietx_i_dma_write_ack : std_logic_vector(0 downto 0);
	signal stratixvpcietx_i_dma_write_done : std_logic_vector(0 downto 0);
	signal stratixvpcietx_i_dma_write_busy : std_logic_vector(0 downto 0);
	signal stratixvpcietx_i_dma_write_rden : std_logic_vector(0 downto 0);
	signal stratixvpcietx_i_dma_read_ack : std_logic_vector(0 downto 0);
	signal stratixvpcietx_i_compl_rden : std_logic_vector(0 downto 0);
	signal stratixvpcietx_i_compl_ack : std_logic_vector(0 downto 0);
	signal stratixvpcietx_i_sl_rd_compl_ack : std_logic_vector(0 downto 0);
	signal stratixvpcietx_i_sl_rd_compl_rden : std_logic_vector(0 downto 0);
	signal stratixvpcietx_i_sl_rd_compl_done : std_logic_vector(0 downto 0);
	signal stratixvpcierx_i_rx_st_ready : std_logic_vector(0 downto 0);
	signal stratixvpcierx_i_rx_st_mask : std_logic_vector(0 downto 0);
	signal stratixvpcierx_i_cpl_err : std_logic_vector(6 downto 0);
	signal stratixvpcierx_i_cpl_pending : std_logic_vector(0 downto 0);
	signal stratixvpcierx_i_dma_response_data : std_logic_vector(127 downto 0);
	signal stratixvpcierx_i_dma_response_valid : std_logic_vector(1 downto 0);
	signal stratixvpcierx_i_dma_response_len : std_logic_vector(9 downto 0);
	signal stratixvpcierx_i_dma_response_tag : std_logic_vector(7 downto 0);
	signal stratixvpcierx_i_dma_response_complete : std_logic_vector(0 downto 0);
	signal stratixvpcierx_i_dma_response_ready : std_logic_vector(0 downto 0);
	signal stratixvpcierx_i_reg_data_out : std_logic_vector(63 downto 0);
	signal stratixvpcierx_i_reg_data_wren : std_logic_vector(7 downto 0);
	signal stratixvpcierx_i_reg_data_addr : std_logic_vector(63 downto 0);
	signal stratixvpcierx_i_reg_data_bar0 : std_logic_vector(0 downto 0);
	signal stratixvpcierx_i_reg_data_bar2 : std_logic_vector(0 downto 0);
	signal stratixvpcierx_i_compl_tc : std_logic_vector(2 downto 0);
	signal stratixvpcierx_i_compl_td : std_logic_vector(0 downto 0);
	signal stratixvpcierx_i_compl_ep : std_logic_vector(0 downto 0);
	signal stratixvpcierx_i_compl_attr : std_logic_vector(1 downto 0);
	signal stratixvpcierx_i_compl_rid : std_logic_vector(15 downto 0);
	signal stratixvpcierx_i_compl_tag : std_logic_vector(7 downto 0);
	signal stratixvpcierx_i_compl_addr : std_logic_vector(63 downto 0);
	signal stratixvpcierx_i_compl_bar2 : std_logic_vector(0 downto 0);
	signal stratixvpcierx_i_compl_req : std_logic_vector(0 downto 0);
	signal stratixvpcierx_i_compl_size : std_logic_vector(9 downto 0);
	signal stratixvpcierx_i_sl_en : std_logic_vector(0 downto 0);
	signal stratixvpcierx_i_sl_wr_en : std_logic_vector(0 downto 0);
	signal stratixvpcierx_i_sl_wr_addr : std_logic_vector(63 downto 0);
	signal stratixvpcierx_i_sl_wr_size : std_logic_vector(9 downto 0);
	signal stratixvpcierx_i_sl_wr_data : std_logic_vector(127 downto 0);
	signal stratixvpcierx_i_sl_wr_be : std_logic_vector(15 downto 0);
	signal stratixvpcierx_i_sl_wr_last : std_logic_vector(0 downto 0);
	signal stratixvpcierx_i_sl_rd_en : std_logic_vector(0 downto 0);
	signal stratixvpcierx_i_sl_rd_tc : std_logic_vector(2 downto 0);
	signal stratixvpcierx_i_sl_rd_td : std_logic_vector(0 downto 0);
	signal stratixvpcierx_i_sl_rd_ep : std_logic_vector(0 downto 0);
	signal stratixvpcierx_i_sl_rd_attr : std_logic_vector(1 downto 0);
	signal stratixvpcierx_i_sl_rd_rid : std_logic_vector(15 downto 0);
	signal stratixvpcierx_i_sl_rd_tag : std_logic_vector(7 downto 0);
	signal stratixvpcierx_i_sl_rd_be : std_logic_vector(7 downto 0);
	signal stratixvpcierx_i_sl_rd_addr : std_logic_vector(63 downto 0);
	signal stratixvpcierx_i_sl_rd_size : std_logic_vector(9 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	tx_st_valid <= vec_to_bit(stratixvpcietx_i_tx_st_valid);
	tx_st_sop <= vec_to_bit(stratixvpcietx_i_tx_st_sop);
	tx_st_eop <= vec_to_bit(stratixvpcietx_i_tx_st_eop);
	tx_st_empty <= stratixvpcietx_i_tx_st_empty;
	tx_st_err <= vec_to_bit(stratixvpcietx_i_tx_st_err);
	tx_st_data <= stratixvpcietx_i_tx_st_data;
	tx_dma_write_ack <= vec_to_bit(stratixvpcietx_i_dma_write_ack);
	tx_dma_write_done <= vec_to_bit(stratixvpcietx_i_dma_write_done);
	tx_dma_write_busy <= vec_to_bit(stratixvpcietx_i_dma_write_busy);
	tx_dma_write_rden <= vec_to_bit(stratixvpcietx_i_dma_write_rden);
	tx_dma_read_dma_read_ack <= vec_to_bit(stratixvpcietx_i_dma_read_ack);
	tx_reg_compl_rden <= vec_to_bit(stratixvpcietx_i_compl_rden);
	tx_reg_compl_ack <= vec_to_bit(stratixvpcietx_i_compl_ack);
	tx_slave_stream_compl_ack <= vec_to_bit(stratixvpcietx_i_sl_rd_compl_ack);
	tx_slave_stream_compl_rden <= vec_to_bit(stratixvpcietx_i_sl_rd_compl_rden);
	tx_slave_stream_compl_done <= vec_to_bit(stratixvpcietx_i_sl_rd_compl_done);
	rx_st_ready <= vec_to_bit(stratixvpcierx_i_rx_st_ready);
	rx_st_mask <= vec_to_bit(stratixvpcierx_i_rx_st_mask);
	cpl_err <= stratixvpcierx_i_cpl_err;
	cpl_pending <= vec_to_bit(stratixvpcierx_i_cpl_pending);
	rx_dma_response_dma_response_data <= stratixvpcierx_i_dma_response_data;
	rx_dma_response_dma_response_valid <= stratixvpcierx_i_dma_response_valid;
	rx_dma_response_dma_response_len <= stratixvpcierx_i_dma_response_len;
	rx_dma_response_dma_response_tag <= stratixvpcierx_i_dma_response_tag;
	rx_dma_response_dma_response_complete <= vec_to_bit(stratixvpcierx_i_dma_response_complete);
	rx_dma_response_dma_response_ready <= vec_to_bit(stratixvpcierx_i_dma_response_ready);
	rx_reg_write_reg_data_out <= stratixvpcierx_i_reg_data_out;
	rx_reg_write_reg_data_wren <= stratixvpcierx_i_reg_data_wren;
	rx_reg_write_reg_data_addr <= stratixvpcierx_i_reg_data_addr;
	rx_reg_write_reg_data_bar0 <= vec_to_bit(stratixvpcierx_i_reg_data_bar0);
	rx_reg_write_reg_data_bar2 <= vec_to_bit(stratixvpcierx_i_reg_data_bar2);
	rx_reg_read_compl_tc <= stratixvpcierx_i_compl_tc;
	rx_reg_read_compl_td <= vec_to_bit(stratixvpcierx_i_compl_td);
	rx_reg_read_compl_ep <= vec_to_bit(stratixvpcierx_i_compl_ep);
	rx_reg_read_compl_attr <= stratixvpcierx_i_compl_attr;
	rx_reg_read_compl_rid <= stratixvpcierx_i_compl_rid;
	rx_reg_read_compl_tag <= stratixvpcierx_i_compl_tag;
	rx_reg_read_compl_addr <= stratixvpcierx_i_compl_addr;
	rx_reg_read_compl_bar2 <= vec_to_bit(stratixvpcierx_i_compl_bar2);
	rx_reg_read_compl_req <= vec_to_bit(stratixvpcierx_i_compl_req);
	rx_reg_read_compl_size <= stratixvpcierx_i_compl_size;
	rx_slave_stream_req_sl_en <= vec_to_bit(stratixvpcierx_i_sl_en);
	rx_slave_stream_req_sl_wr_en <= vec_to_bit(stratixvpcierx_i_sl_wr_en);
	rx_slave_stream_req_sl_wr_addr <= stratixvpcierx_i_sl_wr_addr;
	rx_slave_stream_req_sl_wr_size <= stratixvpcierx_i_sl_wr_size;
	rx_slave_stream_req_sl_wr_data <= stratixvpcierx_i_sl_wr_data;
	rx_slave_stream_req_sl_wr_be <= stratixvpcierx_i_sl_wr_be;
	rx_slave_stream_req_sl_wr_last <= vec_to_bit(stratixvpcierx_i_sl_wr_last);
	rx_slave_stream_req_sl_rd_en <= vec_to_bit(stratixvpcierx_i_sl_rd_en);
	rx_slave_stream_req_sl_rd_tc <= stratixvpcierx_i_sl_rd_tc;
	rx_slave_stream_req_sl_rd_td <= vec_to_bit(stratixvpcierx_i_sl_rd_td);
	rx_slave_stream_req_sl_rd_ep <= vec_to_bit(stratixvpcierx_i_sl_rd_ep);
	rx_slave_stream_req_sl_rd_attr <= stratixvpcierx_i_sl_rd_attr;
	rx_slave_stream_req_sl_rd_rid <= stratixvpcierx_i_sl_rd_rid;
	rx_slave_stream_req_sl_rd_tag <= stratixvpcierx_i_sl_rd_tag;
	rx_slave_stream_req_sl_rd_be <= stratixvpcierx_i_sl_rd_be;
	rx_slave_stream_req_sl_rd_addr <= stratixvpcierx_i_sl_rd_addr;
	rx_slave_stream_req_sl_rd_size <= stratixvpcierx_i_sl_rd_size;
	
	-- Register processes
	
	
	-- Entity instances
	
	StratixVPCIeTX_i : max_SV_pcie_tx
		port map (
			tx_st_valid => stratixvpcietx_i_tx_st_valid(0), -- 1 bits (out)
			tx_st_sop => stratixvpcietx_i_tx_st_sop(0), -- 1 bits (out)
			tx_st_eop => stratixvpcietx_i_tx_st_eop(0), -- 1 bits (out)
			tx_st_empty => stratixvpcietx_i_tx_st_empty, -- 2 bits (out)
			tx_st_err => stratixvpcietx_i_tx_st_err(0), -- 1 bits (out)
			tx_st_data => stratixvpcietx_i_tx_st_data, -- 128 bits (out)
			dma_write_ack => stratixvpcietx_i_dma_write_ack(0), -- 1 bits (out)
			dma_write_done => stratixvpcietx_i_dma_write_done(0), -- 1 bits (out)
			dma_write_busy => stratixvpcietx_i_dma_write_busy(0), -- 1 bits (out)
			dma_write_rden => stratixvpcietx_i_dma_write_rden(0), -- 1 bits (out)
			dma_read_ack => stratixvpcietx_i_dma_read_ack(0), -- 1 bits (out)
			compl_rden => stratixvpcietx_i_compl_rden(0), -- 1 bits (out)
			compl_ack => stratixvpcietx_i_compl_ack(0), -- 1 bits (out)
			sl_rd_compl_ack => stratixvpcietx_i_sl_rd_compl_ack(0), -- 1 bits (out)
			sl_rd_compl_rden => stratixvpcietx_i_sl_rd_compl_rden(0), -- 1 bits (out)
			sl_rd_compl_done => stratixvpcietx_i_sl_rd_compl_done(0), -- 1 bits (out)
			clk_pcie => clk_pcie, -- 1 bits (in)
			rst_pcie_n => rst_pcie_n, -- 1 bits (in)
			tx_st_ready => tx_st_ready, -- 1 bits (in)
			cfg_completer_id => cfg_completer_id, -- 16 bits (in)
			dma_write_req => tx_dma_write_req, -- 1 bits (in)
			dma_write_addr => tx_dma_write_addr, -- 64 bits (in)
			dma_write_tag => tx_dma_write_tag, -- 8 bits (in)
			dma_write_len => tx_dma_write_len, -- 9 bits (in)
			dma_write_wide_addr => tx_dma_write_wide_addr, -- 1 bits (in)
			dma_write_rddata => tx_dma_write_rddata, -- 128 bits (in)
			dma_read_req => tx_dma_read_dma_read_req, -- 1 bits (in)
			dma_read_addr => tx_dma_read_dma_read_addr, -- 64 bits (in)
			dma_read_len => tx_dma_read_dma_read_len, -- 10 bits (in)
			dma_read_be => tx_dma_read_dma_read_be, -- 4 bits (in)
			dma_read_tag => tx_dma_read_dma_read_tag, -- 8 bits (in)
			dma_read_wide_addr => tx_dma_read_dma_read_wide_addr, -- 1 bits (in)
			compl_req => tx_reg_compl_req, -- 1 bits (in)
			compl_tc => tx_reg_compl_tc, -- 3 bits (in)
			compl_td => tx_reg_compl_td, -- 1 bits (in)
			compl_ep => tx_reg_compl_ep, -- 1 bits (in)
			compl_attr => tx_reg_compl_attr, -- 2 bits (in)
			compl_rid => tx_reg_compl_rid, -- 16 bits (in)
			compl_tag => tx_reg_compl_tag, -- 8 bits (in)
			compl_addr => tx_reg_compl_addr, -- 13 bits (in)
			compl_data => tx_reg_compl_data, -- 64 bits (in)
			compl_size => tx_reg_compl_size, -- 10 bits (in)
			sl_rd_compl_req => tx_slave_stream_compl_req, -- 1 bits (in)
			sl_rd_compl_tc => tx_slave_stream_compl_tc, -- 3 bits (in)
			sl_rd_compl_td => tx_slave_stream_compl_td, -- 1 bits (in)
			sl_rd_compl_ep => tx_slave_stream_compl_ep, -- 1 bits (in)
			sl_rd_compl_attr => tx_slave_stream_compl_attr, -- 2 bits (in)
			sl_rd_compl_rid => tx_slave_stream_compl_rid, -- 16 bits (in)
			sl_rd_compl_tag => tx_slave_stream_compl_tag, -- 8 bits (in)
			sl_rd_compl_addr => tx_slave_stream_compl_addr, -- 7 bits (in)
			sl_rd_compl_size => tx_slave_stream_compl_size, -- 12 bits (in)
			sl_rd_compl_rem_size => tx_slave_stream_compl_rem_size, -- 12 bits (in)
			sl_rd_compl_data => tx_slave_stream_compl_data -- 128 bits (in)
		);
	StratixVPCIeRX_i : max_SV_pcie_rx
		generic map (
			SIM_RX => false
		)
		port map (
			rx_st_ready => stratixvpcierx_i_rx_st_ready(0), -- 1 bits (out)
			rx_st_mask => stratixvpcierx_i_rx_st_mask(0), -- 1 bits (out)
			cpl_err => stratixvpcierx_i_cpl_err, -- 7 bits (out)
			cpl_pending => stratixvpcierx_i_cpl_pending(0), -- 1 bits (out)
			dma_response_data => stratixvpcierx_i_dma_response_data, -- 128 bits (out)
			dma_response_valid => stratixvpcierx_i_dma_response_valid, -- 2 bits (out)
			dma_response_len => stratixvpcierx_i_dma_response_len, -- 10 bits (out)
			dma_response_tag => stratixvpcierx_i_dma_response_tag, -- 8 bits (out)
			dma_response_complete => stratixvpcierx_i_dma_response_complete(0), -- 1 bits (out)
			dma_response_ready => stratixvpcierx_i_dma_response_ready(0), -- 1 bits (out)
			reg_data_out => stratixvpcierx_i_reg_data_out, -- 64 bits (out)
			reg_data_wren => stratixvpcierx_i_reg_data_wren, -- 8 bits (out)
			reg_data_addr => stratixvpcierx_i_reg_data_addr, -- 64 bits (out)
			reg_data_bar0 => stratixvpcierx_i_reg_data_bar0(0), -- 1 bits (out)
			reg_data_bar2 => stratixvpcierx_i_reg_data_bar2(0), -- 1 bits (out)
			compl_tc => stratixvpcierx_i_compl_tc, -- 3 bits (out)
			compl_td => stratixvpcierx_i_compl_td(0), -- 1 bits (out)
			compl_ep => stratixvpcierx_i_compl_ep(0), -- 1 bits (out)
			compl_attr => stratixvpcierx_i_compl_attr, -- 2 bits (out)
			compl_rid => stratixvpcierx_i_compl_rid, -- 16 bits (out)
			compl_tag => stratixvpcierx_i_compl_tag, -- 8 bits (out)
			compl_addr => stratixvpcierx_i_compl_addr, -- 64 bits (out)
			compl_bar2 => stratixvpcierx_i_compl_bar2(0), -- 1 bits (out)
			compl_req => stratixvpcierx_i_compl_req(0), -- 1 bits (out)
			compl_size => stratixvpcierx_i_compl_size, -- 10 bits (out)
			sl_en => stratixvpcierx_i_sl_en(0), -- 1 bits (out)
			sl_wr_en => stratixvpcierx_i_sl_wr_en(0), -- 1 bits (out)
			sl_wr_addr => stratixvpcierx_i_sl_wr_addr, -- 64 bits (out)
			sl_wr_size => stratixvpcierx_i_sl_wr_size, -- 10 bits (out)
			sl_wr_data => stratixvpcierx_i_sl_wr_data, -- 128 bits (out)
			sl_wr_be => stratixvpcierx_i_sl_wr_be, -- 16 bits (out)
			sl_wr_last => stratixvpcierx_i_sl_wr_last(0), -- 1 bits (out)
			sl_rd_en => stratixvpcierx_i_sl_rd_en(0), -- 1 bits (out)
			sl_rd_tc => stratixvpcierx_i_sl_rd_tc, -- 3 bits (out)
			sl_rd_td => stratixvpcierx_i_sl_rd_td(0), -- 1 bits (out)
			sl_rd_ep => stratixvpcierx_i_sl_rd_ep(0), -- 1 bits (out)
			sl_rd_attr => stratixvpcierx_i_sl_rd_attr, -- 2 bits (out)
			sl_rd_rid => stratixvpcierx_i_sl_rd_rid, -- 16 bits (out)
			sl_rd_tag => stratixvpcierx_i_sl_rd_tag, -- 8 bits (out)
			sl_rd_be => stratixvpcierx_i_sl_rd_be, -- 8 bits (out)
			sl_rd_addr => stratixvpcierx_i_sl_rd_addr, -- 64 bits (out)
			sl_rd_size => stratixvpcierx_i_sl_rd_size, -- 10 bits (out)
			clk_pcie => clk_pcie, -- 1 bits (in)
			rst_pcie_n => rst_pcie_n, -- 1 bits (in)
			rx_st_valid => rx_st_valid, -- 1 bits (in)
			rx_st_sop => rx_st_sop, -- 1 bits (in)
			rx_st_eop => rx_st_eop, -- 1 bits (in)
			rx_st_empty => rx_st_empty, -- 2 bits (in)
			rx_st_err => rx_st_err, -- 1 bits (in)
			rx_st_bar => rx_st_bar, -- 8 bits (in)
			rx_st_data => rx_st_data, -- 128 bits (in)
			compl_full => rx_reg_read_compl_full -- 1 bits (in)
		);
end MaxDC;
