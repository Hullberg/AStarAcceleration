library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
library altera_mf;
use altera_mf.all;

entity AlteraFifoEntity_34_512_34_dualclock_aclr_wrusedw_fwft_pfv495 is
	port (
		wr_clk: in std_logic;
		rd_clk: in std_logic;
		din: in std_logic_vector(33 downto 0);
		wr_en: in std_logic;
		rd_en: in std_logic;
		rst: in std_logic;
		dout: out std_logic_vector(33 downto 0);
		full: out std_logic;
		empty: out std_logic;
		wr_data_count: out std_logic_vector(8 downto 0);
		prog_full: out std_logic
	);
end AlteraFifoEntity_34_512_34_dualclock_aclr_wrusedw_fwft_pfv495;

architecture MaxDC of AlteraFifoEntity_34_512_34_dualclock_aclr_wrusedw_fwft_pfv495 is
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
	component dcfifo is
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
			clocks_are_synchronized : string
		);
		port (
			data: in std_logic_vector(33 downto 0);
			wrreq: in std_logic;
			rdreq: in std_logic;
			rdclk: in std_logic;
			wrclk: in std_logic;
			aclr: in std_logic;
			q: out std_logic_vector(33 downto 0);
			wrfull: out std_logic;
			rdempty: out std_logic;
			wrusedw: out std_logic_vector(9 downto 0)
		);
	end component;
	attribute box_type of dcfifo : component is "BLACK_BOX";
	
	-- Signal declarations
	
	signal inst_ln44_mwfifo_q : std_logic_vector(33 downto 0);
	signal inst_ln44_mwfifo_wrfull : std_logic_vector(0 downto 0);
	signal inst_ln44_mwfifo_rdempty : std_logic_vector(0 downto 0);
	signal inst_ln44_mwfifo_wrusedw : std_logic_vector(9 downto 0);
	signal sig : std_logic_vector(0 downto 0);
	signal sig1 : std_logic_vector(0 downto 0);
	signal sig2 : std_logic_vector(0 downto 0);
	signal sig3 : std_logic_vector(0 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	sig <= bit_to_vec(wr_en);
	sig1 <= bit_to_vec(rd_en);
	sig2 <= inst_ln44_mwfifo_wrfull;
	sig3 <= inst_ln44_mwfifo_rdempty;
	dout <= inst_ln44_mwfifo_q;
	full <= vec_to_bit(sig2);
	empty <= vec_to_bit(sig3);
	wr_data_count <= slice(inst_ln44_mwfifo_wrusedw, 0, 9);
	prog_full <= vec_to_bit(bool_to_vec((unsigned(inst_ln44_mwfifo_wrusedw)) >= (unsigned(slv_to_slv("0111101111")))));
	
	-- Register processes
	
	
	-- Entity instances
	
	inst_ln44_mwfifo : dcfifo
		generic map (
			lpm_width => 34,
			lpm_widthu => 10,
			lpm_numwords => 512,
			lpm_showahead => "ON",
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
			clocks_are_synchronized => "FALSE"
		)
		port map (
			q => inst_ln44_mwfifo_q, -- 34 bits (out)
			wrfull => inst_ln44_mwfifo_wrfull(0), -- 1 bits (out)
			rdempty => inst_ln44_mwfifo_rdempty(0), -- 1 bits (out)
			wrusedw => inst_ln44_mwfifo_wrusedw, -- 10 bits (out)
			data => din, -- 34 bits (in)
			wrreq => vec_to_bit(sig), -- 1 bits (in)
			rdreq => vec_to_bit(sig1), -- 1 bits (in)
			rdclk => rd_clk, -- 1 bits (in)
			wrclk => wr_clk, -- 1 bits (in)
			aclr => rst -- 1 bits (in)
		);
end MaxDC;
