library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
library altera_mf;
use altera_mf.all;

entity AlteraFifoEntity_128_128_64_dualclock_aclr_wrusedw_pfv78 is
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
end AlteraFifoEntity_128_128_64_dualclock_aclr_wrusedw_pfv78;

architecture MaxDC of AlteraFifoEntity_128_128_64_dualclock_aclr_wrusedw_pfv78 is
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
	component dcfifo_mixed_widths is
		generic (
			lpm_width : integer;
			lpm_widthu : integer;
			lpm_numwords : integer;
			lpm_showahead : string;
			lpm_type : string;
			overflow_checking : string;
			underflow_checking : string;
			use_eab : string;
			intended_device_family : string;
			delay_rdusedw : integer;
			delay_wrusedw : integer;
			add_usedw_msb_bit : string;
			rdsync_delaypipe : integer;
			wrsync_delaypipe : integer;
			write_aclr_synch : string;
			read_aclr_synch : string;
			clocks_are_synchronized : string;
			lpm_width_r : integer;
			lpm_widthu_r : integer
		);
		port (
			data: in std_logic_vector(127 downto 0);
			wrreq: in std_logic;
			rdreq: in std_logic;
			rdclk: in std_logic;
			wrclk: in std_logic;
			aclr: in std_logic;
			q: out std_logic_vector(63 downto 0);
			wrfull: out std_logic;
			rdempty: out std_logic;
			wrusedw: out std_logic_vector(7 downto 0)
		);
	end component;
	attribute box_type of dcfifo_mixed_widths : component is "BLACK_BOX";
	
	-- Signal declarations
	
	signal inst_ln44_mwfifo_q : std_logic_vector(63 downto 0);
	signal inst_ln44_mwfifo_wrfull : std_logic_vector(0 downto 0);
	signal inst_ln44_mwfifo_rdempty : std_logic_vector(0 downto 0);
	signal inst_ln44_mwfifo_wrusedw : std_logic_vector(7 downto 0);
	signal inst_ln44_mwfifo_data1 : std_logic_vector(127 downto 0);
	signal cat_ln90_alterafifo : std_logic_vector(127 downto 0);
	signal sig : std_logic_vector(0 downto 0);
	signal sig1 : std_logic_vector(0 downto 0);
	signal cat_ln91_alterafifo : std_logic_vector(63 downto 0);
	signal sig2 : std_logic_vector(0 downto 0);
	signal sig3 : std_logic_vector(0 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	cat_ln90_alterafifo<=(slice(din, 0, 1) & slice(din, 1, 1) & slice(din, 2, 1) & slice(din, 3, 1) & slice(din, 4, 1) & slice(din, 5, 1) & slice(din, 6, 1) & slice(din, 7, 1) & slice(din, 8, 1) & slice(din, 9, 1) & slice(din, 10, 1) & slice(din, 11, 1) & slice(din, 12, 1) & slice(din, 13, 1) & slice(din, 14, 1) & slice(din, 15, 1) & slice(din, 16, 1) & slice(din, 17, 1) & slice(din, 18, 1) & slice(din, 19, 1) & slice(din, 20, 1) & slice(din, 21, 1) & slice(din, 22, 1) & slice(din, 23, 1) & slice(din, 24, 1) & slice(din, 25, 1) & slice(din, 26, 1) & slice(din, 27, 1) & slice(din, 28, 1) & slice(din, 29, 1) & slice(din, 30, 1) & slice(din, 31, 1) & slice(din, 32, 1) & slice(din, 33, 1) & slice(din, 34, 1) & slice(din, 35, 1) & slice(din, 36, 1) & slice(din, 37, 1) & slice(din, 38, 1) & slice(din, 39, 1) & slice(din, 40, 1) & slice(din, 41, 1) & slice(din, 42, 1) & slice(din, 43, 1) & slice(din, 44, 1) & slice(din, 45, 1) & slice(din, 46, 1) & slice(din, 47, 1) & slice(din, 48, 1) & slice(din, 49, 1) & slice(din, 50, 1) & slice(din, 51, 1) & slice(din, 52, 1) & slice(din, 53, 1) & slice(din, 54, 1) & slice(din, 55, 1) & slice(din, 56, 1) & slice(din, 57, 1) & slice(din, 58, 1) & slice(din, 59, 1) & slice(din, 60, 1) & slice(din, 61, 1) & slice(din, 62, 1) & slice(din, 63, 1) & slice(din, 64, 1) & slice(din, 65, 1) & slice(din, 66, 1) & slice(din, 67, 1) & slice(din, 68, 1) & slice(din, 69, 1) & slice(din, 70, 1) & slice(din, 71, 1) & slice(din, 72, 1) & slice(din, 73, 1) & slice(din, 74, 1) & slice(din, 75, 1) & slice(din, 76, 1) & slice(din, 77, 1) & slice(din, 78, 1) & slice(din, 79, 1) & slice(din, 80, 1) & slice(din, 81, 1) & slice(din, 82, 1) & slice(din, 83, 1) & slice(din, 84, 1) & slice(din, 85, 1) & slice(din, 86, 1) & slice(din, 87, 1) & slice(din, 88, 1) & slice(din, 89, 1) & slice(din, 90, 1) & slice(din, 91, 1) & slice(din, 92, 1) & slice(din, 93, 1) & slice(din, 94, 1) & slice(din, 95, 1) & slice(din, 96, 1) & slice(din, 97, 1) & slice(din, 98, 1) & slice(din, 99, 1) & slice(din, 100, 1) & slice(din, 101, 1) & slice(din, 102, 1) & slice(din, 103, 1) & slice(din, 104, 1) & slice(din, 105, 1) & slice(din, 106, 1) & slice(din, 107, 1) & slice(din, 108, 1) & slice(din, 109, 1) & slice(din, 110, 1) & slice(din, 111, 1) & slice(din, 112, 1) & slice(din, 113, 1) & slice(din, 114, 1) & slice(din, 115, 1) & slice(din, 116, 1) & slice(din, 117, 1) & slice(din, 118, 1) & slice(din, 119, 1) & slice(din, 120, 1) & slice(din, 121, 1) & slice(din, 122, 1) & slice(din, 123, 1) & slice(din, 124, 1) & slice(din, 125, 1) & slice(din, 126, 1) & slice(din, 127, 1));
	inst_ln44_mwfifo_data1 <= cat_ln90_alterafifo;
	sig <= bit_to_vec(wr_en);
	sig1 <= bit_to_vec(rd_en);
	cat_ln91_alterafifo<=(slice(inst_ln44_mwfifo_q, 0, 1) & slice(inst_ln44_mwfifo_q, 1, 1) & slice(inst_ln44_mwfifo_q, 2, 1) & slice(inst_ln44_mwfifo_q, 3, 1) & slice(inst_ln44_mwfifo_q, 4, 1) & slice(inst_ln44_mwfifo_q, 5, 1) & slice(inst_ln44_mwfifo_q, 6, 1) & slice(inst_ln44_mwfifo_q, 7, 1) & slice(inst_ln44_mwfifo_q, 8, 1) & slice(inst_ln44_mwfifo_q, 9, 1) & slice(inst_ln44_mwfifo_q, 10, 1) & slice(inst_ln44_mwfifo_q, 11, 1) & slice(inst_ln44_mwfifo_q, 12, 1) & slice(inst_ln44_mwfifo_q, 13, 1) & slice(inst_ln44_mwfifo_q, 14, 1) & slice(inst_ln44_mwfifo_q, 15, 1) & slice(inst_ln44_mwfifo_q, 16, 1) & slice(inst_ln44_mwfifo_q, 17, 1) & slice(inst_ln44_mwfifo_q, 18, 1) & slice(inst_ln44_mwfifo_q, 19, 1) & slice(inst_ln44_mwfifo_q, 20, 1) & slice(inst_ln44_mwfifo_q, 21, 1) & slice(inst_ln44_mwfifo_q, 22, 1) & slice(inst_ln44_mwfifo_q, 23, 1) & slice(inst_ln44_mwfifo_q, 24, 1) & slice(inst_ln44_mwfifo_q, 25, 1) & slice(inst_ln44_mwfifo_q, 26, 1) & slice(inst_ln44_mwfifo_q, 27, 1) & slice(inst_ln44_mwfifo_q, 28, 1) & slice(inst_ln44_mwfifo_q, 29, 1) & slice(inst_ln44_mwfifo_q, 30, 1) & slice(inst_ln44_mwfifo_q, 31, 1) & slice(inst_ln44_mwfifo_q, 32, 1) & slice(inst_ln44_mwfifo_q, 33, 1) & slice(inst_ln44_mwfifo_q, 34, 1) & slice(inst_ln44_mwfifo_q, 35, 1) & slice(inst_ln44_mwfifo_q, 36, 1) & slice(inst_ln44_mwfifo_q, 37, 1) & slice(inst_ln44_mwfifo_q, 38, 1) & slice(inst_ln44_mwfifo_q, 39, 1) & slice(inst_ln44_mwfifo_q, 40, 1) & slice(inst_ln44_mwfifo_q, 41, 1) & slice(inst_ln44_mwfifo_q, 42, 1) & slice(inst_ln44_mwfifo_q, 43, 1) & slice(inst_ln44_mwfifo_q, 44, 1) & slice(inst_ln44_mwfifo_q, 45, 1) & slice(inst_ln44_mwfifo_q, 46, 1) & slice(inst_ln44_mwfifo_q, 47, 1) & slice(inst_ln44_mwfifo_q, 48, 1) & slice(inst_ln44_mwfifo_q, 49, 1) & slice(inst_ln44_mwfifo_q, 50, 1) & slice(inst_ln44_mwfifo_q, 51, 1) & slice(inst_ln44_mwfifo_q, 52, 1) & slice(inst_ln44_mwfifo_q, 53, 1) & slice(inst_ln44_mwfifo_q, 54, 1) & slice(inst_ln44_mwfifo_q, 55, 1) & slice(inst_ln44_mwfifo_q, 56, 1) & slice(inst_ln44_mwfifo_q, 57, 1) & slice(inst_ln44_mwfifo_q, 58, 1) & slice(inst_ln44_mwfifo_q, 59, 1) & slice(inst_ln44_mwfifo_q, 60, 1) & slice(inst_ln44_mwfifo_q, 61, 1) & slice(inst_ln44_mwfifo_q, 62, 1) & slice(inst_ln44_mwfifo_q, 63, 1));
	sig2 <= inst_ln44_mwfifo_wrfull;
	sig3 <= inst_ln44_mwfifo_rdempty;
	dout <= cat_ln91_alterafifo;
	full <= vec_to_bit(sig2);
	empty <= vec_to_bit(sig3);
	wr_data_count <= slice(inst_ln44_mwfifo_wrusedw, 0, 7);
	prog_full <= vec_to_bit(bool_to_vec((unsigned(inst_ln44_mwfifo_wrusedw)) >= (unsigned(slv_to_slv("01001110")))));
	
	-- Register processes
	
	
	-- Entity instances
	
	inst_ln44_mwfifo : dcfifo_mixed_widths
		generic map (
			lpm_width => 128,
			lpm_widthu => 8,
			lpm_numwords => 128,
			lpm_showahead => "OFF",
			lpm_type => "DCFIFO",
			overflow_checking => "ON",
			underflow_checking => "ON",
			use_eab => "ON",
			intended_device_family => "Stratix V",
			delay_rdusedw => 1,
			delay_wrusedw => 1,
			add_usedw_msb_bit => "ON",
			rdsync_delaypipe => 4,
			wrsync_delaypipe => 4,
			write_aclr_synch => "ON",
			read_aclr_synch => "ON",
			clocks_are_synchronized => "FALSE",
			lpm_width_r => 64,
			lpm_widthu_r => 9
		)
		port map (
			q => inst_ln44_mwfifo_q, -- 64 bits (out)
			wrfull => inst_ln44_mwfifo_wrfull(0), -- 1 bits (out)
			rdempty => inst_ln44_mwfifo_rdempty(0), -- 1 bits (out)
			wrusedw => inst_ln44_mwfifo_wrusedw, -- 8 bits (out)
			data => inst_ln44_mwfifo_data1, -- 128 bits (in)
			wrreq => vec_to_bit(sig), -- 1 bits (in)
			rdreq => vec_to_bit(sig1), -- 1 bits (in)
			rdclk => rd_clk, -- 1 bits (in)
			wrclk => wr_clk, -- 1 bits (in)
			aclr => rst -- 1 bits (in)
		);
end MaxDC;
