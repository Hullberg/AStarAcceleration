library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity RequestEncoder is
	port (
		clk_pcie: in std_logic;
		rst_pcie_n: in std_logic;
		streamrst_pcie: in std_logic;
		read_ready: in std_logic;
		read_len: in std_logic_vector(6 downto 0);
		read_addr: in std_logic_vector(60 downto 0);
		read_tag: in std_logic_vector(7 downto 0);
		dma_read_ack: in std_logic;
		write_ready: in std_logic;
		write_last: in std_logic;
		write_id: in std_logic_vector(31 downto 0);
		write_len: in std_logic_vector(8 downto 0);
		write_addr: in std_logic_vector(60 downto 0);
		write_tag: in std_logic_vector(7 downto 0);
		write_data: in std_logic_vector(127 downto 0);
		write_data_valid: in std_logic;
		tx_dma_write_ack: in std_logic;
		tx_dma_write_done: in std_logic;
		tx_dma_write_busy: in std_logic;
		tx_dma_write_rden: in std_logic;
		tx_stop: in std_logic;
		read_done: out std_logic;
		dma_read_req: out std_logic;
		dma_read_addr: out std_logic_vector(63 downto 0);
		dma_read_len: out std_logic_vector(9 downto 0);
		dma_read_be: out std_logic_vector(3 downto 0);
		dma_read_tag: out std_logic_vector(7 downto 0);
		dma_read_wide_addr: out std_logic;
		write_done: out std_logic;
		write_data_read: out std_logic;
		tx_dma_write_req: out std_logic;
		tx_dma_write_addr: out std_logic_vector(63 downto 0);
		tx_dma_write_tag: out std_logic_vector(7 downto 0);
		tx_dma_write_len: out std_logic_vector(8 downto 0);
		tx_dma_write_wide_addr: out std_logic;
		tx_dma_write_rddata: out std_logic_vector(127 downto 0);
		interrupt_ctl_valid: out std_logic;
		interrupt_ctl_enable_id: out std_logic_vector(31 downto 0);
		tx_fifo_empty: out std_logic
	);
end RequestEncoder;

architecture MaxDC of RequestEncoder is
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
	component write_request_encoder is
		generic (
			DATA_WIDTH_QUADS : integer
		);
		port (
			clk_pcie: in std_logic;
			rst_pcie: in std_logic;
			arb_ready: in std_logic;
			stream_data_valid: in std_logic;
			req_fifo_full: in std_logic;
			req_len: in std_logic_vector(8 downto 0);
			tx_ack: in std_logic;
			tx_done: in std_logic;
			req_empty: in std_logic;
			req_last: in std_logic;
			arb_eval: out std_logic;
			stream_data_rd: out std_logic;
			req_store: out std_logic;
			tx_req: out std_logic;
			req_rd_en: out std_logic;
			sample_req: out std_logic;
			interrupt_enable: out std_logic
		);
	end component;
	component AlteraFifoEntity_115_512_115_fwft is
		port (
			clk: in std_logic;
			din: in std_logic_vector(114 downto 0);
			wr_en: in std_logic;
			rd_en: in std_logic;
			srst: in std_logic;
			dout: out std_logic_vector(114 downto 0);
			full: out std_logic;
			empty: out std_logic
		);
	end component;
	component AlteraFifoEntity_128_512_128_afv448 is
		port (
			clk: in std_logic;
			din: in std_logic_vector(127 downto 0);
			wr_en: in std_logic;
			rd_en: in std_logic;
			srst: in std_logic;
			dout: out std_logic_vector(127 downto 0);
			full: out std_logic;
			empty: out std_logic;
			prog_full: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal inst_ln10_writerequestencoderexternal_arb_eval : std_logic_vector(0 downto 0);
	signal inst_ln10_writerequestencoderexternal_stream_data_rd : std_logic_vector(0 downto 0);
	signal inst_ln10_writerequestencoderexternal_req_store : std_logic_vector(0 downto 0);
	signal inst_ln10_writerequestencoderexternal_tx_req : std_logic_vector(0 downto 0);
	signal inst_ln10_writerequestencoderexternal_req_rd_en : std_logic_vector(0 downto 0);
	signal inst_ln10_writerequestencoderexternal_sample_req : std_logic_vector(0 downto 0);
	signal inst_ln10_writerequestencoderexternal_interrupt_enable : std_logic_vector(0 downto 0);
	signal wr_req_buffer_i_dout : std_logic_vector(114 downto 0);
	signal wr_req_buffer_i_full : std_logic_vector(0 downto 0);
	signal wr_req_buffer_i_empty : std_logic_vector(0 downto 0);
	signal wr_req_data_buffer_i_dout : std_logic_vector(127 downto 0);
	signal wr_req_data_buffer_i_full : std_logic_vector(0 downto 0);
	signal wr_req_data_buffer_i_empty : std_logic_vector(0 downto 0);
	signal wr_req_data_buffer_i_prog_full : std_logic_vector(0 downto 0);
	signal wr_req_data_buffer_full_or_stop_reg : std_logic_vector(0 downto 0) := "0";
	signal req_last_reg : std_logic_vector(0 downto 0) := "0";
	signal wr_req_din_rr : std_logic_vector(114 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
	signal wr_req_din_r : std_logic_vector(114 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
	signal cat_ln121_requestencoder : std_logic_vector(63 downto 0);
	signal cat_ln120_requestencoder : std_logic_vector(114 downto 0);
	signal wr_req_store_not_stop : std_logic_vector(0 downto 0) := "0";
	signal write_data_r : std_logic_vector(127 downto 0) := "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
	signal write_data_valid_r : std_logic_vector(0 downto 0) := "0";
	signal reg_ln48_requestencoder : std_logic_vector(0 downto 0) := "0";
	signal reg_ln51_requestencoder : std_logic_vector(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
	signal cat_ln51_requestencoder : std_logic_vector(63 downto 0);
	signal reg_ln52_requestencoder : std_logic_vector(9 downto 0) := "0000000000";
	signal cat_ln52_requestencoder : std_logic_vector(9 downto 0);
	signal reg_ln54_requestencoder : std_logic_vector(7 downto 0) := "00000000";
	signal reg_ln60_requestencoder : std_logic_vector(0 downto 0) := "0";
	signal reg_ln191_requestencoder : std_logic_vector(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
	signal reg_ln193_requestencoder : std_logic_vector(7 downto 0) := "00000000";
	signal tx_write_len_reg : std_logic_vector(8 downto 0) := "000000000";
	signal reg_ln198_requestencoder : std_logic_vector(0 downto 0) := "0";
	signal reg_ln210_requestencoder : std_logic_vector(0 downto 0) := "0";
	signal req_id_rr : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal req_id_r : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal req_id_reg : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	signal wr_req_empty_r : std_logic_vector(0 downto 0) := "0";
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	cat_ln121_requestencoder<=(write_addr & "000");
	cat_ln120_requestencoder<=(bit_to_vec(write_last) & write_id & bool_to_vec((slice(write_addr, 29, 32)) /= ("00000000000000000000000000000000")) & write_len & write_tag & cat_ln121_requestencoder);
	cat_ln51_requestencoder<=(read_addr & "000");
	cat_ln52_requestencoder<=("00" & read_len & "0");
	read_done <= vec_to_bit(bit_to_vec(dma_read_ack));
	dma_read_req <= vec_to_bit(reg_ln48_requestencoder);
	dma_read_addr <= reg_ln51_requestencoder;
	dma_read_len <= reg_ln52_requestencoder;
	dma_read_be <= "1111";
	dma_read_tag <= reg_ln54_requestencoder;
	dma_read_wide_addr <= vec_to_bit(reg_ln60_requestencoder);
	write_done <= vec_to_bit(inst_ln10_writerequestencoderexternal_arb_eval);
	write_data_read <= vec_to_bit(inst_ln10_writerequestencoderexternal_stream_data_rd);
	tx_dma_write_req <= vec_to_bit(inst_ln10_writerequestencoderexternal_tx_req);
	tx_dma_write_addr <= reg_ln191_requestencoder;
	tx_dma_write_tag <= reg_ln193_requestencoder;
	tx_dma_write_len <= tx_write_len_reg;
	tx_dma_write_wide_addr <= vec_to_bit(reg_ln198_requestencoder);
	tx_dma_write_rddata <= wr_req_data_buffer_i_dout;
	interrupt_ctl_valid <= vec_to_bit(reg_ln210_requestencoder);
	interrupt_ctl_enable_id <= req_id_rr;
	tx_fifo_empty <= vec_to_bit(wr_req_empty_r);
	
	-- Register processes
	
	reg_process : process(clk_pcie)
	begin
		if rising_edge(clk_pcie) then
			wr_req_data_buffer_full_or_stop_reg <= (bit_to_vec(tx_stop) or wr_req_data_buffer_i_prog_full);
			if slv_to_slv(inst_ln10_writerequestencoderexternal_sample_req) = "1" then
				req_last_reg <= slice(wr_req_buffer_i_dout, 114, 1);
			end if;
			wr_req_din_rr <= wr_req_din_r;
			if slv_to_slv(bit_to_vec(write_data_valid)) = "1" then
				wr_req_din_r <= cat_ln120_requestencoder;
			end if;
			wr_req_store_not_stop <= ((not bit_to_vec(tx_stop)) and inst_ln10_writerequestencoderexternal_req_store);
			write_data_r <= write_data;
			write_data_valid_r <= bit_to_vec(write_data_valid);
			if slv_to_slv(bit_to_vec(dma_read_ack)) = "1" then
				reg_ln48_requestencoder <= "0";
			else
				reg_ln48_requestencoder <= bit_to_vec(read_ready);
			end if;
			reg_ln51_requestencoder <= cat_ln51_requestencoder;
			reg_ln52_requestencoder <= cat_ln52_requestencoder;
			reg_ln54_requestencoder <= read_tag;
			reg_ln60_requestencoder <= bool_to_vec((slice(read_addr, 29, 32)) /= ("00000000000000000000000000000000"));
			if slv_to_slv(inst_ln10_writerequestencoderexternal_sample_req) = "1" then
				reg_ln191_requestencoder <= slice(wr_req_buffer_i_dout, 0, 64);
			end if;
			if slv_to_slv(inst_ln10_writerequestencoderexternal_sample_req) = "1" then
				reg_ln193_requestencoder <= slice(wr_req_buffer_i_dout, 64, 8);
			end if;
			if slv_to_slv(inst_ln10_writerequestencoderexternal_sample_req) = "1" then
				tx_write_len_reg <= slice(wr_req_buffer_i_dout, 72, 9);
			end if;
			if slv_to_slv(inst_ln10_writerequestencoderexternal_sample_req) = "1" then
				reg_ln198_requestencoder <= slice(wr_req_buffer_i_dout, 81, 1);
			end if;
			reg_ln210_requestencoder <= inst_ln10_writerequestencoderexternal_interrupt_enable;
			if slv_to_slv(inst_ln10_writerequestencoderexternal_interrupt_enable) = "1" then
				req_id_rr <= req_id_r;
			end if;
			req_id_r <= req_id_reg;
			if slv_to_slv(inst_ln10_writerequestencoderexternal_sample_req) = "1" then
				req_id_reg <= slice(wr_req_buffer_i_dout, 82, 32);
			end if;
			wr_req_empty_r <= wr_req_buffer_i_empty;
		end if;
	end process;
	
	-- Entity instances
	
	inst_ln10_writerequestencoderexternal : write_request_encoder
		generic map (
			DATA_WIDTH_QUADS => 2
		)
		port map (
			arb_eval => inst_ln10_writerequestencoderexternal_arb_eval(0), -- 1 bits (out)
			stream_data_rd => inst_ln10_writerequestencoderexternal_stream_data_rd(0), -- 1 bits (out)
			req_store => inst_ln10_writerequestencoderexternal_req_store(0), -- 1 bits (out)
			tx_req => inst_ln10_writerequestencoderexternal_tx_req(0), -- 1 bits (out)
			req_rd_en => inst_ln10_writerequestencoderexternal_req_rd_en(0), -- 1 bits (out)
			sample_req => inst_ln10_writerequestencoderexternal_sample_req(0), -- 1 bits (out)
			interrupt_enable => inst_ln10_writerequestencoderexternal_interrupt_enable(0), -- 1 bits (out)
			clk_pcie => clk_pcie, -- 1 bits (in)
			rst_pcie => streamrst_pcie, -- 1 bits (in)
			arb_ready => write_ready, -- 1 bits (in)
			stream_data_valid => write_data_valid, -- 1 bits (in)
			req_fifo_full => vec_to_bit(wr_req_data_buffer_full_or_stop_reg), -- 1 bits (in)
			req_len => write_len, -- 9 bits (in)
			tx_ack => tx_dma_write_ack, -- 1 bits (in)
			tx_done => tx_dma_write_done, -- 1 bits (in)
			req_empty => vec_to_bit(wr_req_buffer_i_empty), -- 1 bits (in)
			req_last => vec_to_bit(req_last_reg) -- 1 bits (in)
		);
	wr_req_buffer_i : AlteraFifoEntity_115_512_115_fwft
		port map (
			dout => wr_req_buffer_i_dout, -- 115 bits (out)
			full => wr_req_buffer_i_full(0), -- 1 bits (out)
			empty => wr_req_buffer_i_empty(0), -- 1 bits (out)
			clk => clk_pcie, -- 1 bits (in)
			din => wr_req_din_rr, -- 115 bits (in)
			wr_en => vec_to_bit(wr_req_store_not_stop), -- 1 bits (in)
			rd_en => vec_to_bit(inst_ln10_writerequestencoderexternal_req_rd_en), -- 1 bits (in)
			srst => streamrst_pcie -- 1 bits (in)
		);
	wr_req_data_buffer_i : AlteraFifoEntity_128_512_128_afv448
		port map (
			dout => wr_req_data_buffer_i_dout, -- 128 bits (out)
			full => wr_req_data_buffer_i_full(0), -- 1 bits (out)
			empty => wr_req_data_buffer_i_empty(0), -- 1 bits (out)
			prog_full => wr_req_data_buffer_i_prog_full(0), -- 1 bits (out)
			clk => clk_pcie, -- 1 bits (in)
			din => write_data_r, -- 128 bits (in)
			wr_en => vec_to_bit(write_data_valid_r), -- 1 bits (in)
			rd_en => tx_dma_write_rden, -- 1 bits (in)
			srst => streamrst_pcie -- 1 bits (in)
		);
end MaxDC;
