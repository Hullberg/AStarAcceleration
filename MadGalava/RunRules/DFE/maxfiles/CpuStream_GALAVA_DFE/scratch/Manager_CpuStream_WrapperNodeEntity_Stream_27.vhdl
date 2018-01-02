library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity Manager_CpuStream_WrapperNodeEntity_Stream_27 is
	port (
		input_valid: in std_logic;
		input_done: in std_logic;
		input_data: in std_logic_vector(31 downto 0);
		output_read: in std_logic;
		input_clk: in std_logic;
		input_clk_nobuf: in std_logic;
		input_clk_rst: in std_logic;
		output_clk: in std_logic;
		output_clk_nobuf: in std_logic;
		output_clk_rst: in std_logic;
		output_clk_rst_delay: in std_logic;
		input_stall: out std_logic;
		output_almost_empty: out std_logic;
		output_empty: out std_logic;
		output_done: out std_logic;
		output_data: out std_logic_vector(31 downto 0)
	);
end Manager_CpuStream_WrapperNodeEntity_Stream_27;

architecture MaxDC of Manager_CpuStream_WrapperNodeEntity_Stream_27 is
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
	component StreamFifo_altera_32_32_512_pushin_sl2_pullout_el1_ael2_dualclock_errflgs is
		port (
			input_clk: in std_logic;
			output_clk: in std_logic;
			rst: in std_logic;
			rst_wr: in std_logic;
			rst_rd: in std_logic;
			rst_delayed: in std_logic;
			inputstream_push_valid: in std_logic;
			inputstream_push_done: in std_logic;
			inputstream_push_data: in std_logic_vector(31 downto 0);
			outputstream_pull_read: in std_logic;
			underflow: out std_logic;
			overflow: out std_logic;
			dbg_empty: out std_logic;
			dbg_stall: out std_logic;
			inputstream_push_stall: out std_logic;
			outputstream_pull_empty: out std_logic;
			outputstream_pull_done: out std_logic;
			outputstream_pull_data: out std_logic_vector(31 downto 0);
			outputstream_pull_almost_empty: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal inst_ln31_streamingblock_underflow : std_logic_vector(0 downto 0);
	signal inst_ln31_streamingblock_overflow : std_logic_vector(0 downto 0);
	signal inst_ln31_streamingblock_dbg_empty : std_logic_vector(0 downto 0);
	signal inst_ln31_streamingblock_dbg_stall : std_logic_vector(0 downto 0);
	signal inst_ln31_streamingblock_inputstream_push_stall : std_logic_vector(0 downto 0);
	signal inst_ln31_streamingblock_outputstream_pull_empty : std_logic_vector(0 downto 0);
	signal inst_ln31_streamingblock_outputstream_pull_done : std_logic_vector(0 downto 0);
	signal inst_ln31_streamingblock_outputstream_pull_data : std_logic_vector(31 downto 0);
	signal inst_ln31_streamingblock_outputstream_pull_almost_empty : std_logic_vector(0 downto 0);
	signal inst_ln31_streamingblock_inputstream_push_data1 : std_logic_vector(31 downto 0);
	signal cat_ln31_streamiogrouputils : std_logic_vector(31 downto 0);
	signal cat_ln31_streamiogrouputils1 : std_logic_vector(31 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	cat_ln31_streamiogrouputils<=input_data;
	inst_ln31_streamingblock_inputstream_push_data1 <= cat_ln31_streamiogrouputils;
	cat_ln31_streamiogrouputils1<=inst_ln31_streamingblock_outputstream_pull_data;
	input_stall <= vec_to_bit(inst_ln31_streamingblock_inputstream_push_stall);
	output_almost_empty <= vec_to_bit(inst_ln31_streamingblock_outputstream_pull_almost_empty);
	output_empty <= vec_to_bit(inst_ln31_streamingblock_outputstream_pull_empty);
	output_done <= vec_to_bit(inst_ln31_streamingblock_outputstream_pull_done);
	output_data <= cat_ln31_streamiogrouputils1;
	
	-- Register processes
	
	
	-- Entity instances
	
	inst_ln31_streamingblock : StreamFifo_altera_32_32_512_pushin_sl2_pullout_el1_ael2_dualclock_errflgs
		port map (
			underflow => inst_ln31_streamingblock_underflow(0), -- 1 bits (out)
			overflow => inst_ln31_streamingblock_overflow(0), -- 1 bits (out)
			dbg_empty => inst_ln31_streamingblock_dbg_empty(0), -- 1 bits (out)
			dbg_stall => inst_ln31_streamingblock_dbg_stall(0), -- 1 bits (out)
			inputstream_push_stall => inst_ln31_streamingblock_inputstream_push_stall(0), -- 1 bits (out)
			outputstream_pull_empty => inst_ln31_streamingblock_outputstream_pull_empty(0), -- 1 bits (out)
			outputstream_pull_done => inst_ln31_streamingblock_outputstream_pull_done(0), -- 1 bits (out)
			outputstream_pull_data => inst_ln31_streamingblock_outputstream_pull_data, -- 32 bits (out)
			outputstream_pull_almost_empty => inst_ln31_streamingblock_outputstream_pull_almost_empty(0), -- 1 bits (out)
			input_clk => input_clk, -- 1 bits (in)
			output_clk => output_clk, -- 1 bits (in)
			rst => output_clk_rst, -- 1 bits (in)
			rst_wr => input_clk_rst, -- 1 bits (in)
			rst_rd => output_clk_rst, -- 1 bits (in)
			rst_delayed => output_clk_rst_delay, -- 1 bits (in)
			inputstream_push_valid => input_valid, -- 1 bits (in)
			inputstream_push_done => input_done, -- 1 bits (in)
			inputstream_push_data => inst_ln31_streamingblock_inputstream_push_data1, -- 32 bits (in)
			outputstream_pull_read => output_read -- 1 bits (in)
		);
end MaxDC;
