library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity SGGen2InputBuffer is
	port (
		clk: in std_logic;
		rst: in std_logic;
		response_data: in std_logic_vector(127 downto 0);
		response_metadata: in std_logic_vector(27 downto 0);
		response_valid: in std_logic_vector(1 downto 0);
		response_select: in std_logic;
		response_metadata_valid: in std_logic;
		response_word: out std_logic_vector(63 downto 0);
		response_sel_vld: out std_logic;
		response_metadata_out: out std_logic_vector(27 downto 0)
	);
end SGGen2InputBuffer;

architecture MaxDC of SGGen2InputBuffer is
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
	component AlteraFifoEntity_65_512_65 is
		port (
			clk: in std_logic;
			din: in std_logic_vector(64 downto 0);
			wr_en: in std_logic;
			rd_en: in std_logic;
			srst: in std_logic;
			dout: out std_logic_vector(64 downto 0);
			full: out std_logic;
			empty: out std_logic
		);
	end component;
	component AlteraFifoEntity_28_512_28 is
		port (
			clk: in std_logic;
			din: in std_logic_vector(27 downto 0);
			wr_en: in std_logic;
			rd_en: in std_logic;
			srst: in std_logic;
			dout: out std_logic_vector(27 downto 0);
			full: out std_logic;
			empty: out std_logic
		);
	end component;
	component DualAspectCounterPipelined_65_130 is
		port (
			clk: in std_logic;
			rst: in std_logic;
			input_empty: in std_logic;
			input_done: in std_logic;
			input_data: in std_logic_vector(129 downto 0);
			output_stall: in std_logic;
			input_read: out std_logic;
			output_valid: out std_logic;
			output_data: out std_logic_vector(64 downto 0);
			output_done: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal data_fifo_0_dout : std_logic_vector(64 downto 0);
	signal data_fifo_0_full : std_logic_vector(0 downto 0);
	signal data_fifo_0_empty : std_logic_vector(0 downto 0);
	signal data_fifo_1_dout : std_logic_vector(64 downto 0);
	signal data_fifo_1_full : std_logic_vector(0 downto 0);
	signal data_fifo_1_empty : std_logic_vector(0 downto 0);
	signal metadata_fifo_dout : std_logic_vector(27 downto 0);
	signal metadata_fifo_full : std_logic_vector(0 downto 0);
	signal metadata_fifo_empty : std_logic_vector(0 downto 0);
	signal inst_ln32_dualaspectcounterpipelined_input_read : std_logic_vector(0 downto 0);
	signal inst_ln32_dualaspectcounterpipelined_output_valid : std_logic_vector(0 downto 0);
	signal inst_ln32_dualaspectcounterpipelined_output_data : std_logic_vector(64 downto 0);
	signal inst_ln32_dualaspectcounterpipelined_output_done : std_logic_vector(0 downto 0);
	signal data_fifo_0_din1 : std_logic_vector(64 downto 0);
	signal response_data_r_ls : std_logic_vector(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
	signal rsp_vld_d_ls : std_logic_vector(0 downto 0) := "0";
	signal cat_ln66_sggen2inputbuffer : std_logic_vector(64 downto 0);
	signal rsp_sel_vld_r : std_logic_vector(0 downto 0) := "0";
	signal data_fifo_1_din1 : std_logic_vector(64 downto 0);
	signal response_data_r_ms : std_logic_vector(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";
	signal rsp_vld_d_ms : std_logic_vector(0 downto 0) := "0";
	signal cat_ln66_sggen2inputbuffer1 : std_logic_vector(64 downto 0);
	signal reg_ln76_sggen2inputbuffer : std_logic_vector(27 downto 0) := "0000000000000000000000000000";
	signal inst_ln32_dualaspectcounterpipelined_input_empty1 : std_logic_vector(0 downto 0);
	signal inst_ln32_dualaspectcounterpipelined_input_data1 : std_logic_vector(129 downto 0);
	signal cat_ln103_sggen2inputbuffer : std_logic_vector(129 downto 0);
	signal reg_ln117_sggen2inputbuffer : std_logic_vector(27 downto 0) := "0000000000000000000000000000";
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	cat_ln66_sggen2inputbuffer<=(response_data_r_ls & rsp_vld_d_ls);
	data_fifo_0_din1 <= cat_ln66_sggen2inputbuffer;
	cat_ln66_sggen2inputbuffer1<=(response_data_r_ms & rsp_vld_d_ms);
	data_fifo_1_din1 <= cat_ln66_sggen2inputbuffer1;
	inst_ln32_dualaspectcounterpipelined_input_empty1 <= (data_fifo_0_empty and data_fifo_1_empty and metadata_fifo_empty);
	cat_ln103_sggen2inputbuffer<=(data_fifo_1_dout & data_fifo_0_dout);
	inst_ln32_dualaspectcounterpipelined_input_data1 <= cat_ln103_sggen2inputbuffer;
	response_word <= slice(inst_ln32_dualaspectcounterpipelined_output_data, 1, 64);
	response_sel_vld <= vec_to_bit((slice(inst_ln32_dualaspectcounterpipelined_output_data, 0, 1) and inst_ln32_dualaspectcounterpipelined_output_valid));
	response_metadata_out <= reg_ln117_sggen2inputbuffer;
	
	-- Register processes
	
	reg_process : process(clk)
	begin
		if rising_edge(clk) then
			response_data_r_ls <= slice(response_data, 0, 64);
			rsp_vld_d_ls <= slice(response_valid, 0, 1);
			if slv_to_slv(bit_to_vec(rst)) = "1" then
				rsp_sel_vld_r <= "0";
			else
				rsp_sel_vld_r <= (bit_to_vec(response_select) and (slice(response_valid, 0, 1) or slice(response_valid, 1, 1)));
			end if;
			response_data_r_ms <= slice(response_data, 64, 64);
			rsp_vld_d_ms <= slice(response_valid, 1, 1);
			if slv_to_slv(bit_to_vec(rst)) = "1" then
				reg_ln76_sggen2inputbuffer <= "0000000000000000000000000000";
			else
				if slv_to_slv(bit_to_vec(response_metadata_valid)) = "1" then
					reg_ln76_sggen2inputbuffer <= response_metadata;
				end if;
			end if;
			if slv_to_slv(bit_to_vec(rst)) = "1" then
				reg_ln117_sggen2inputbuffer <= "0000000000000000000000000000";
			else
				reg_ln117_sggen2inputbuffer <= metadata_fifo_dout;
			end if;
		end if;
	end process;
	
	-- Entity instances
	
	data_fifo_0 : AlteraFifoEntity_65_512_65
		port map (
			dout => data_fifo_0_dout, -- 65 bits (out)
			full => data_fifo_0_full(0), -- 1 bits (out)
			empty => data_fifo_0_empty(0), -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			din => data_fifo_0_din1, -- 65 bits (in)
			wr_en => vec_to_bit(rsp_sel_vld_r), -- 1 bits (in)
			rd_en => vec_to_bit(inst_ln32_dualaspectcounterpipelined_input_read), -- 1 bits (in)
			srst => rst -- 1 bits (in)
		);
	data_fifo_1 : AlteraFifoEntity_65_512_65
		port map (
			dout => data_fifo_1_dout, -- 65 bits (out)
			full => data_fifo_1_full(0), -- 1 bits (out)
			empty => data_fifo_1_empty(0), -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			din => data_fifo_1_din1, -- 65 bits (in)
			wr_en => vec_to_bit(rsp_sel_vld_r), -- 1 bits (in)
			rd_en => vec_to_bit(inst_ln32_dualaspectcounterpipelined_input_read), -- 1 bits (in)
			srst => rst -- 1 bits (in)
		);
	metadata_fifo : AlteraFifoEntity_28_512_28
		port map (
			dout => metadata_fifo_dout, -- 28 bits (out)
			full => metadata_fifo_full(0), -- 1 bits (out)
			empty => metadata_fifo_empty(0), -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			din => reg_ln76_sggen2inputbuffer, -- 28 bits (in)
			wr_en => vec_to_bit(rsp_sel_vld_r), -- 1 bits (in)
			rd_en => vec_to_bit(inst_ln32_dualaspectcounterpipelined_input_read), -- 1 bits (in)
			srst => rst -- 1 bits (in)
		);
	inst_ln32_dualaspectcounterpipelined : DualAspectCounterPipelined_65_130
		port map (
			input_read => inst_ln32_dualaspectcounterpipelined_input_read(0), -- 1 bits (out)
			output_valid => inst_ln32_dualaspectcounterpipelined_output_valid(0), -- 1 bits (out)
			output_data => inst_ln32_dualaspectcounterpipelined_output_data, -- 65 bits (out)
			output_done => inst_ln32_dualaspectcounterpipelined_output_done(0), -- 1 bits (out)
			clk => clk, -- 1 bits (in)
			rst => rst, -- 1 bits (in)
			input_empty => vec_to_bit(inst_ln32_dualaspectcounterpipelined_input_empty1), -- 1 bits (in)
			input_done => vec_to_bit("0"), -- 1 bits (in)
			input_data => inst_ln32_dualaspectcounterpipelined_input_data1, -- 130 bits (in)
			output_stall => vec_to_bit("0") -- 1 bits (in)
		);
end MaxDC;
