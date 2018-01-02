library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity MemWriteRequestArbiter is
	port (
		streamrst_pcie: in std_logic;
		clk_pcie: in std_logic;
		rst_pcie_n: in std_logic;
		output_done: in std_logic;
		output_data_read: in std_logic;
		port0_ready: in std_logic;
		port0_last: in std_logic;
		port0_len: in std_logic_vector(8 downto 0);
		port0_addr: in std_logic_vector(60 downto 0);
		port0_data: in std_logic_vector(127 downto 0);
		port0_data_valid: in std_logic;
		port1_ready: in std_logic;
		port1_last: in std_logic;
		port1_len: in std_logic_vector(8 downto 0);
		port1_addr: in std_logic_vector(60 downto 0);
		port1_data: in std_logic_vector(127 downto 0);
		port1_data_valid: in std_logic;
		port2_ready: in std_logic;
		port2_last: in std_logic;
		port2_len: in std_logic_vector(8 downto 0);
		port2_addr: in std_logic_vector(60 downto 0);
		port2_data: in std_logic_vector(127 downto 0);
		port2_data_valid: in std_logic;
		output_ready: out std_logic;
		output_last: out std_logic;
		output_id: out std_logic_vector(31 downto 0);
		output_len: out std_logic_vector(8 downto 0);
		output_addr: out std_logic_vector(60 downto 0);
		output_data: out std_logic_vector(127 downto 0);
		output_data_valid: out std_logic;
		port0_select: out std_logic;
		port0_data_read: out std_logic;
		port1_select: out std_logic;
		port1_data_read: out std_logic;
		port2_select: out std_logic;
		port2_data_read: out std_logic
	);
end MemWriteRequestArbiter;

architecture MaxDC of MemWriteRequestArbiter is
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
	component FastRequestArbiter_req3 is
		port (
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			requests: in std_logic_vector(2 downto 0);
			rst_sync: in std_logic;
			req_done: in std_logic;
			selects: out std_logic_vector(2 downto 0);
			ready: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal internal_arbiter_i_selects : std_logic_vector(2 downto 0);
	signal internal_arbiter_i_ready : std_logic_vector(0 downto 0);
	signal internal_arbiter_i_requests1 : std_logic_vector(2 downto 0);
	signal cat_ln69_memwriterequestarbiter : std_logic_vector(2 downto 0);
	signal cat_ln90_memwriterequestarbiter : std_logic_vector(31 downto 0);
	signal data_read : std_logic_vector(0 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	cat_ln69_memwriterequestarbiter<=(bit_to_vec(port2_ready) & bit_to_vec(port1_ready) & bit_to_vec(port0_ready));
	internal_arbiter_i_requests1 <= cat_ln69_memwriterequestarbiter;
	cat_ln90_memwriterequestarbiter<=("000000000000000000000000000000" & slice(internal_arbiter_i_selects, 2, 1) & slice(internal_arbiter_i_selects, 1, 1));
	data_read <= bit_to_vec(output_data_read);
	output_ready <= vec_to_bit(internal_arbiter_i_ready);
	output_last <= vec_to_bit((bit_to_vec(port0_last) or bit_to_vec(port1_last) or bit_to_vec(port2_last)));
	output_id <= cat_ln90_memwriterequestarbiter;
	output_len <= (port0_len or port1_len or port2_len);
	output_addr <= (port0_addr or port1_addr or port2_addr);
	output_data <= (port0_data or port1_data or port2_data);
	output_data_valid <= vec_to_bit((bit_to_vec(port0_data_valid) or bit_to_vec(port1_data_valid) or bit_to_vec(port2_data_valid)));
	port0_select <= vec_to_bit(slice(internal_arbiter_i_selects, 0, 1));
	port0_data_read <= vec_to_bit(data_read);
	port1_select <= vec_to_bit(slice(internal_arbiter_i_selects, 1, 1));
	port1_data_read <= vec_to_bit(data_read);
	port2_select <= vec_to_bit(slice(internal_arbiter_i_selects, 2, 1));
	port2_data_read <= vec_to_bit(data_read);
	
	-- Register processes
	
	
	-- Entity instances
	
	internal_arbiter_i : FastRequestArbiter_req3
		port map (
			selects => internal_arbiter_i_selects, -- 3 bits (out)
			ready => internal_arbiter_i_ready(0), -- 1 bits (out)
			clk_pcie => clk_pcie, -- 1 bits (in)
			rst_pcie_n => rst_pcie_n, -- 1 bits (in)
			requests => internal_arbiter_i_requests1, -- 3 bits (in)
			rst_sync => streamrst_pcie, -- 1 bits (in)
			req_done => output_done -- 1 bits (in)
		);
end MaxDC;
