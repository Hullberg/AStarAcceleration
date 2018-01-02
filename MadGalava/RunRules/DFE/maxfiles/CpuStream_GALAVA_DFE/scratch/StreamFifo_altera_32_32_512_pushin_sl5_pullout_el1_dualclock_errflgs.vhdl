library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity StreamFifo_altera_32_32_512_pushin_sl5_pullout_el1_dualclock_errflgs is
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
		outputstream_pull_data: out std_logic_vector(31 downto 0)
	);
end StreamFifo_altera_32_32_512_pushin_sl5_pullout_el1_dualclock_errflgs;

architecture MaxDC of StreamFifo_altera_32_32_512_pushin_sl5_pullout_el1_dualclock_errflgs is
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
	component AlteraFifoEntity_32_512_32_dualclock_aclr_wrusedw_of_uf_pfv473 is
		port (
			wr_clk: in std_logic;
			rd_clk: in std_logic;
			din: in std_logic_vector(31 downto 0);
			wr_en: in std_logic;
			rd_en: in std_logic;
			rst: in std_logic;
			dout: out std_logic_vector(31 downto 0);
			full: out std_logic;
			empty: out std_logic;
			overflow: out std_logic;
			underflow: out std_logic;
			wr_data_count: out std_logic_vector(8 downto 0);
			prog_full: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal inst_ln47_alterafifo_dout : std_logic_vector(31 downto 0);
	signal inst_ln47_alterafifo_full : std_logic_vector(0 downto 0);
	signal inst_ln47_alterafifo_empty : std_logic_vector(0 downto 0);
	signal inst_ln47_alterafifo_overflow : std_logic_vector(0 downto 0);
	signal inst_ln47_alterafifo_underflow : std_logic_vector(0 downto 0);
	signal inst_ln47_alterafifo_wr_data_count : std_logic_vector(8 downto 0);
	signal inst_ln47_alterafifo_prog_full : std_logic_vector(0 downto 0);
	signal sig : std_logic_vector(31 downto 0);
	signal sig3 : std_logic_vector(31 downto 0);
	signal cat_ln264_streamfifo : std_logic_vector(31 downto 0);
	signal sig1 : std_logic_vector(0 downto 0);
	signal sig2 : std_logic_vector(0 downto 0);
	signal reg_ln505_streamfifo : std_logic_vector(0 downto 0) := "0";
	signal reg_ln505_streamfifo1 : std_logic_vector(0 downto 0) := "0";
	signal sig4 : std_logic_vector(31 downto 0);
	signal cat_ln181_streamfifo : std_logic_vector(31 downto 0);
	signal cat_ln265_streamfifo : std_logic_vector(31 downto 0);
	
	-- Attribute type declarations
	
	attribute dont_merge : boolean;
	
	-- Attribute declarations
	
	attribute dont_merge of reg_ln505_streamfifo : signal is true;
	attribute dont_merge of reg_ln505_streamfifo1 : signal is true;
begin
	
	-- Assignments
	
	sig3 <= inputstream_push_data;
	cat_ln264_streamfifo<=(slice(sig3, 0, 1) & slice(sig3, 1, 1) & slice(sig3, 2, 1) & slice(sig3, 3, 1) & slice(sig3, 4, 1) & slice(sig3, 5, 1) & slice(sig3, 6, 1) & slice(sig3, 7, 1) & slice(sig3, 8, 1) & slice(sig3, 9, 1) & slice(sig3, 10, 1) & slice(sig3, 11, 1) & slice(sig3, 12, 1) & slice(sig3, 13, 1) & slice(sig3, 14, 1) & slice(sig3, 15, 1) & slice(sig3, 16, 1) & slice(sig3, 17, 1) & slice(sig3, 18, 1) & slice(sig3, 19, 1) & slice(sig3, 20, 1) & slice(sig3, 21, 1) & slice(sig3, 22, 1) & slice(sig3, 23, 1) & slice(sig3, 24, 1) & slice(sig3, 25, 1) & slice(sig3, 26, 1) & slice(sig3, 27, 1) & slice(sig3, 28, 1) & slice(sig3, 29, 1) & slice(sig3, 30, 1) & slice(sig3, 31, 1));
	sig <= cat_ln264_streamfifo;
	sig1 <= bit_to_vec(inputstream_push_valid);
	sig2 <= bit_to_vec(outputstream_pull_read);
	cat_ln181_streamfifo<=inst_ln47_alterafifo_dout;
	cat_ln265_streamfifo<=(slice(cat_ln181_streamfifo, 0, 1) & slice(cat_ln181_streamfifo, 1, 1) & slice(cat_ln181_streamfifo, 2, 1) & slice(cat_ln181_streamfifo, 3, 1) & slice(cat_ln181_streamfifo, 4, 1) & slice(cat_ln181_streamfifo, 5, 1) & slice(cat_ln181_streamfifo, 6, 1) & slice(cat_ln181_streamfifo, 7, 1) & slice(cat_ln181_streamfifo, 8, 1) & slice(cat_ln181_streamfifo, 9, 1) & slice(cat_ln181_streamfifo, 10, 1) & slice(cat_ln181_streamfifo, 11, 1) & slice(cat_ln181_streamfifo, 12, 1) & slice(cat_ln181_streamfifo, 13, 1) & slice(cat_ln181_streamfifo, 14, 1) & slice(cat_ln181_streamfifo, 15, 1) & slice(cat_ln181_streamfifo, 16, 1) & slice(cat_ln181_streamfifo, 17, 1) & slice(cat_ln181_streamfifo, 18, 1) & slice(cat_ln181_streamfifo, 19, 1) & slice(cat_ln181_streamfifo, 20, 1) & slice(cat_ln181_streamfifo, 21, 1) & slice(cat_ln181_streamfifo, 22, 1) & slice(cat_ln181_streamfifo, 23, 1) & slice(cat_ln181_streamfifo, 24, 1) & slice(cat_ln181_streamfifo, 25, 1) & slice(cat_ln181_streamfifo, 26, 1) & slice(cat_ln181_streamfifo, 27, 1) & slice(cat_ln181_streamfifo, 28, 1) & slice(cat_ln181_streamfifo, 29, 1) & slice(cat_ln181_streamfifo, 30, 1) & slice(cat_ln181_streamfifo, 31, 1));
	sig4 <= cat_ln265_streamfifo;
	underflow <= vec_to_bit(inst_ln47_alterafifo_underflow);
	overflow <= vec_to_bit(inst_ln47_alterafifo_overflow);
	dbg_empty <= vec_to_bit((inst_ln47_alterafifo_empty or reg_ln505_streamfifo));
	dbg_stall <= vec_to_bit((reg_ln505_streamfifo1 or inst_ln47_alterafifo_prog_full));
	inputstream_push_stall <= vec_to_bit((reg_ln505_streamfifo1 or inst_ln47_alterafifo_prog_full));
	outputstream_pull_empty <= vec_to_bit((inst_ln47_alterafifo_empty or reg_ln505_streamfifo));
	outputstream_pull_done <= vec_to_bit("0");
	outputstream_pull_data <= sig4;
	
	-- Register processes
	
	reg_process : process(output_clk)
	begin
		if rising_edge(output_clk) then
			reg_ln505_streamfifo <= bit_to_vec(rst_rd);
		end if;
	end process;
	reg_process1 : process(input_clk)
	begin
		if rising_edge(input_clk) then
			reg_ln505_streamfifo1 <= bit_to_vec(rst_wr);
		end if;
	end process;
	
	-- Entity instances
	
	inst_ln47_alterafifo : AlteraFifoEntity_32_512_32_dualclock_aclr_wrusedw_of_uf_pfv473
		port map (
			dout => inst_ln47_alterafifo_dout, -- 32 bits (out)
			full => inst_ln47_alterafifo_full(0), -- 1 bits (out)
			empty => inst_ln47_alterafifo_empty(0), -- 1 bits (out)
			overflow => inst_ln47_alterafifo_overflow(0), -- 1 bits (out)
			underflow => inst_ln47_alterafifo_underflow(0), -- 1 bits (out)
			wr_data_count => inst_ln47_alterafifo_wr_data_count, -- 9 bits (out)
			prog_full => inst_ln47_alterafifo_prog_full(0), -- 1 bits (out)
			wr_clk => input_clk, -- 1 bits (in)
			rd_clk => output_clk, -- 1 bits (in)
			din => sig, -- 32 bits (in)
			wr_en => vec_to_bit(sig1), -- 1 bits (in)
			rd_en => vec_to_bit(sig2), -- 1 bits (in)
			rst => rst_delayed -- 1 bits (in)
		);
end MaxDC;
