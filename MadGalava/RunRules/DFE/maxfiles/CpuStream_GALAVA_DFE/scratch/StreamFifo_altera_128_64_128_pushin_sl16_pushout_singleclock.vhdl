library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity StreamFifo_altera_128_64_128_pushin_sl16_pushout_singleclock is
	port (
		clk: in std_logic;
		rst: in std_logic;
		rst_delayed: in std_logic;
		inputstream_push_valid: in std_logic;
		inputstream_push_done: in std_logic;
		inputstream_push_data: in std_logic_vector(127 downto 0);
		outputstream_push_stall: in std_logic;
		dbg_empty: out std_logic;
		dbg_stall: out std_logic;
		inputstream_push_stall: out std_logic;
		outputstream_push_valid: out std_logic;
		outputstream_push_done: out std_logic;
		outputstream_push_data: out std_logic_vector(63 downto 0)
	);
end StreamFifo_altera_128_64_128_pushin_sl16_pushout_singleclock;

architecture MaxDC of StreamFifo_altera_128_64_128_pushin_sl16_pushout_singleclock is
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
	component AlteraFifoEntity_128_128_64_dualclock_aclr_wrusedw_pfv78 is
		port (
			wr_clk: in std_logic;
			rd_clk: in std_logic;
			din: in std_logic_vector(127 downto 0);
			wr_en: in std_logic;
			rd_en: in std_logic;
			rst: in std_logic;
			dout: out std_logic_vector(63 downto 0);
			full: out std_logic;
			empty: out std_logic;
			wr_data_count: out std_logic_vector(6 downto 0);
			prog_full: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal inst_ln70_alterafifo_dout : std_logic_vector(63 downto 0);
	signal inst_ln70_alterafifo_full : std_logic_vector(0 downto 0);
	signal inst_ln70_alterafifo_empty : std_logic_vector(0 downto 0);
	signal inst_ln70_alterafifo_wr_data_count : std_logic_vector(6 downto 0);
	signal inst_ln70_alterafifo_prog_full : std_logic_vector(0 downto 0);
	signal sig : std_logic_vector(127 downto 0);
	signal sig3 : std_logic_vector(127 downto 0);
	signal cat_ln264_streamfifo : std_logic_vector(127 downto 0);
	signal sig1 : std_logic_vector(0 downto 0);
	signal sig2 : std_logic_vector(0 downto 0);
	signal reg_ln505_streamfifo : std_logic_vector(0 downto 0) := "0";
	signal reg_ln505_streamfifo1 : std_logic_vector(0 downto 0) := "0";
	signal reg_ln426_streamfifo : std_logic_vector(0 downto 0) := "0";
	signal sig4 : std_logic_vector(63 downto 0);
	signal cat_ln181_streamfifo : std_logic_vector(63 downto 0);
	signal cat_ln265_streamfifo : std_logic_vector(63 downto 0);
	
	-- Attribute type declarations
	
	attribute dont_merge : boolean;
	
	-- Attribute declarations
	
	attribute dont_merge of reg_ln505_streamfifo : signal is true;
	attribute dont_merge of reg_ln505_streamfifo1 : signal is true;
begin
	
	-- Assignments
	
	sig3 <= inputstream_push_data;
	cat_ln264_streamfifo<=(slice(sig3, 0, 1) & slice(sig3, 1, 1) & slice(sig3, 2, 1) & slice(sig3, 3, 1) & slice(sig3, 4, 1) & slice(sig3, 5, 1) & slice(sig3, 6, 1) & slice(sig3, 7, 1) & slice(sig3, 8, 1) & slice(sig3, 9, 1) & slice(sig3, 10, 1) & slice(sig3, 11, 1) & slice(sig3, 12, 1) & slice(sig3, 13, 1) & slice(sig3, 14, 1) & slice(sig3, 15, 1) & slice(sig3, 16, 1) & slice(sig3, 17, 1) & slice(sig3, 18, 1) & slice(sig3, 19, 1) & slice(sig3, 20, 1) & slice(sig3, 21, 1) & slice(sig3, 22, 1) & slice(sig3, 23, 1) & slice(sig3, 24, 1) & slice(sig3, 25, 1) & slice(sig3, 26, 1) & slice(sig3, 27, 1) & slice(sig3, 28, 1) & slice(sig3, 29, 1) & slice(sig3, 30, 1) & slice(sig3, 31, 1) & slice(sig3, 32, 1) & slice(sig3, 33, 1) & slice(sig3, 34, 1) & slice(sig3, 35, 1) & slice(sig3, 36, 1) & slice(sig3, 37, 1) & slice(sig3, 38, 1) & slice(sig3, 39, 1) & slice(sig3, 40, 1) & slice(sig3, 41, 1) & slice(sig3, 42, 1) & slice(sig3, 43, 1) & slice(sig3, 44, 1) & slice(sig3, 45, 1) & slice(sig3, 46, 1) & slice(sig3, 47, 1) & slice(sig3, 48, 1) & slice(sig3, 49, 1) & slice(sig3, 50, 1) & slice(sig3, 51, 1) & slice(sig3, 52, 1) & slice(sig3, 53, 1) & slice(sig3, 54, 1) & slice(sig3, 55, 1) & slice(sig3, 56, 1) & slice(sig3, 57, 1) & slice(sig3, 58, 1) & slice(sig3, 59, 1) & slice(sig3, 60, 1) & slice(sig3, 61, 1) & slice(sig3, 62, 1) & slice(sig3, 63, 1) & slice(sig3, 64, 1) & slice(sig3, 65, 1) & slice(sig3, 66, 1) & slice(sig3, 67, 1) & slice(sig3, 68, 1) & slice(sig3, 69, 1) & slice(sig3, 70, 1) & slice(sig3, 71, 1) & slice(sig3, 72, 1) & slice(sig3, 73, 1) & slice(sig3, 74, 1) & slice(sig3, 75, 1) & slice(sig3, 76, 1) & slice(sig3, 77, 1) & slice(sig3, 78, 1) & slice(sig3, 79, 1) & slice(sig3, 80, 1) & slice(sig3, 81, 1) & slice(sig3, 82, 1) & slice(sig3, 83, 1) & slice(sig3, 84, 1) & slice(sig3, 85, 1) & slice(sig3, 86, 1) & slice(sig3, 87, 1) & slice(sig3, 88, 1) & slice(sig3, 89, 1) & slice(sig3, 90, 1) & slice(sig3, 91, 1) & slice(sig3, 92, 1) & slice(sig3, 93, 1) & slice(sig3, 94, 1) & slice(sig3, 95, 1) & slice(sig3, 96, 1) & slice(sig3, 97, 1) & slice(sig3, 98, 1) & slice(sig3, 99, 1) & slice(sig3, 100, 1) & slice(sig3, 101, 1) & slice(sig3, 102, 1) & slice(sig3, 103, 1) & slice(sig3, 104, 1) & slice(sig3, 105, 1) & slice(sig3, 106, 1) & slice(sig3, 107, 1) & slice(sig3, 108, 1) & slice(sig3, 109, 1) & slice(sig3, 110, 1) & slice(sig3, 111, 1) & slice(sig3, 112, 1) & slice(sig3, 113, 1) & slice(sig3, 114, 1) & slice(sig3, 115, 1) & slice(sig3, 116, 1) & slice(sig3, 117, 1) & slice(sig3, 118, 1) & slice(sig3, 119, 1) & slice(sig3, 120, 1) & slice(sig3, 121, 1) & slice(sig3, 122, 1) & slice(sig3, 123, 1) & slice(sig3, 124, 1) & slice(sig3, 125, 1) & slice(sig3, 126, 1) & slice(sig3, 127, 1));
	sig <= cat_ln264_streamfifo;
	sig1 <= bit_to_vec(inputstream_push_valid);
	sig2 <= (not (bit_to_vec(outputstream_push_stall) or (inst_ln70_alterafifo_empty or reg_ln505_streamfifo)));
	cat_ln181_streamfifo<=inst_ln70_alterafifo_dout;
	cat_ln265_streamfifo<=(slice(cat_ln181_streamfifo, 0, 1) & slice(cat_ln181_streamfifo, 1, 1) & slice(cat_ln181_streamfifo, 2, 1) & slice(cat_ln181_streamfifo, 3, 1) & slice(cat_ln181_streamfifo, 4, 1) & slice(cat_ln181_streamfifo, 5, 1) & slice(cat_ln181_streamfifo, 6, 1) & slice(cat_ln181_streamfifo, 7, 1) & slice(cat_ln181_streamfifo, 8, 1) & slice(cat_ln181_streamfifo, 9, 1) & slice(cat_ln181_streamfifo, 10, 1) & slice(cat_ln181_streamfifo, 11, 1) & slice(cat_ln181_streamfifo, 12, 1) & slice(cat_ln181_streamfifo, 13, 1) & slice(cat_ln181_streamfifo, 14, 1) & slice(cat_ln181_streamfifo, 15, 1) & slice(cat_ln181_streamfifo, 16, 1) & slice(cat_ln181_streamfifo, 17, 1) & slice(cat_ln181_streamfifo, 18, 1) & slice(cat_ln181_streamfifo, 19, 1) & slice(cat_ln181_streamfifo, 20, 1) & slice(cat_ln181_streamfifo, 21, 1) & slice(cat_ln181_streamfifo, 22, 1) & slice(cat_ln181_streamfifo, 23, 1) & slice(cat_ln181_streamfifo, 24, 1) & slice(cat_ln181_streamfifo, 25, 1) & slice(cat_ln181_streamfifo, 26, 1) & slice(cat_ln181_streamfifo, 27, 1) & slice(cat_ln181_streamfifo, 28, 1) & slice(cat_ln181_streamfifo, 29, 1) & slice(cat_ln181_streamfifo, 30, 1) & slice(cat_ln181_streamfifo, 31, 1) & slice(cat_ln181_streamfifo, 32, 1) & slice(cat_ln181_streamfifo, 33, 1) & slice(cat_ln181_streamfifo, 34, 1) & slice(cat_ln181_streamfifo, 35, 1) & slice(cat_ln181_streamfifo, 36, 1) & slice(cat_ln181_streamfifo, 37, 1) & slice(cat_ln181_streamfifo, 38, 1) & slice(cat_ln181_streamfifo, 39, 1) & slice(cat_ln181_streamfifo, 40, 1) & slice(cat_ln181_streamfifo, 41, 1) & slice(cat_ln181_streamfifo, 42, 1) & slice(cat_ln181_streamfifo, 43, 1) & slice(cat_ln181_streamfifo, 44, 1) & slice(cat_ln181_streamfifo, 45, 1) & slice(cat_ln181_streamfifo, 46, 1) & slice(cat_ln181_streamfifo, 47, 1) & slice(cat_ln181_streamfifo, 48, 1) & slice(cat_ln181_streamfifo, 49, 1) & slice(cat_ln181_streamfifo, 50, 1) & slice(cat_ln181_streamfifo, 51, 1) & slice(cat_ln181_streamfifo, 52, 1) & slice(cat_ln181_streamfifo, 53, 1) & slice(cat_ln181_streamfifo, 54, 1) & slice(cat_ln181_streamfifo, 55, 1) & slice(cat_ln181_streamfifo, 56, 1) & slice(cat_ln181_streamfifo, 57, 1) & slice(cat_ln181_streamfifo, 58, 1) & slice(cat_ln181_streamfifo, 59, 1) & slice(cat_ln181_streamfifo, 60, 1) & slice(cat_ln181_streamfifo, 61, 1) & slice(cat_ln181_streamfifo, 62, 1) & slice(cat_ln181_streamfifo, 63, 1));
	sig4 <= cat_ln265_streamfifo;
	dbg_empty <= vec_to_bit((inst_ln70_alterafifo_empty or reg_ln505_streamfifo));
	dbg_stall <= vec_to_bit((reg_ln505_streamfifo1 or inst_ln70_alterafifo_prog_full));
	inputstream_push_stall <= vec_to_bit((reg_ln505_streamfifo1 or inst_ln70_alterafifo_prog_full));
	outputstream_push_valid <= vec_to_bit(reg_ln426_streamfifo);
	outputstream_push_done <= vec_to_bit("0");
	outputstream_push_data <= sig4;
	
	-- Register processes
	
	reg_process : process(clk)
	begin
		if rising_edge(clk) then
			reg_ln505_streamfifo <= bit_to_vec(rst);
			reg_ln505_streamfifo1 <= bit_to_vec(rst);
			reg_ln426_streamfifo <= (not (bit_to_vec(outputstream_push_stall) or (inst_ln70_alterafifo_empty or reg_ln505_streamfifo)));
		end if;
	end process;
	
	-- Entity instances
	
	inst_ln70_alterafifo : AlteraFifoEntity_128_128_64_dualclock_aclr_wrusedw_pfv78
		port map (
			dout => inst_ln70_alterafifo_dout, -- 64 bits (out)
			full => inst_ln70_alterafifo_full(0), -- 1 bits (out)
			empty => inst_ln70_alterafifo_empty(0), -- 1 bits (out)
			wr_data_count => inst_ln70_alterafifo_wr_data_count, -- 7 bits (out)
			prog_full => inst_ln70_alterafifo_prog_full(0), -- 1 bits (out)
			wr_clk => clk, -- 1 bits (in)
			rd_clk => clk, -- 1 bits (in)
			din => sig, -- 128 bits (in)
			wr_en => vec_to_bit(sig1), -- 1 bits (in)
			rd_en => vec_to_bit(sig2), -- 1 bits (in)
			rst => rst_delayed -- 1 bits (in)
		);
end MaxDC;
