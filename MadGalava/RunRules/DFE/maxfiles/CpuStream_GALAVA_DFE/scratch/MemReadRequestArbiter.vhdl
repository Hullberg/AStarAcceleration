library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity MemReadRequestArbiter is
	port (
		streamrst_pcie: in std_logic;
		clk_pcie: in std_logic;
		rst_pcie_n: in std_logic;
		output_done: in std_logic;
		port0_ready: in std_logic;
		port0_len: in std_logic_vector(6 downto 0);
		port0_addr: in std_logic_vector(60 downto 0);
		port0_metadata: in std_logic_vector(27 downto 0);
		port1_ready: in std_logic;
		port1_len: in std_logic_vector(6 downto 0);
		port1_addr: in std_logic_vector(60 downto 0);
		port1_metadata: in std_logic_vector(27 downto 0);
		port2_ready: in std_logic;
		port2_len: in std_logic_vector(6 downto 0);
		port2_addr: in std_logic_vector(60 downto 0);
		port2_metadata: in std_logic_vector(27 downto 0);
		port3_ready: in std_logic;
		port3_len: in std_logic_vector(6 downto 0);
		port3_addr: in std_logic_vector(60 downto 0);
		port3_metadata: in std_logic_vector(27 downto 0);
		port4_ready: in std_logic;
		port4_len: in std_logic_vector(6 downto 0);
		port4_addr: in std_logic_vector(60 downto 0);
		port4_metadata: in std_logic_vector(27 downto 0);
		port5_ready: in std_logic;
		port5_len: in std_logic_vector(6 downto 0);
		port5_addr: in std_logic_vector(60 downto 0);
		port5_metadata: in std_logic_vector(27 downto 0);
		output_ready: out std_logic;
		output_len: out std_logic_vector(6 downto 0);
		output_addr: out std_logic_vector(60 downto 0);
		output_metadata: out std_logic_vector(35 downto 0);
		port0_select: out std_logic;
		port1_select: out std_logic;
		port2_select: out std_logic;
		port3_select: out std_logic;
		port4_select: out std_logic;
		port5_select: out std_logic
	);
end MemReadRequestArbiter;

architecture MaxDC of MemReadRequestArbiter is
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
	component FastRequestArbiter_req6 is
		port (
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			requests: in std_logic_vector(5 downto 0);
			rst_sync: in std_logic;
			req_done: in std_logic;
			selects: out std_logic_vector(5 downto 0);
			ready: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal internal_arbiter_i_selects : std_logic_vector(5 downto 0);
	signal internal_arbiter_i_ready : std_logic_vector(0 downto 0);
	signal internal_arbiter_i_requests1 : std_logic_vector(5 downto 0);
	signal cat_ln63_memreadrequestarbiter : std_logic_vector(5 downto 0);
	signal reg_ln59_memreadrequestarbiter : std_logic_vector(6 downto 0) := "0000000";
	signal reg_ln60_memreadrequestarbiter : std_logic_vector(60 downto 0) := "0000000000000000000000000000000000000000000000000000000000000";
	signal reg_ln61_memreadrequestarbiter : std_logic_vector(35 downto 0) := "000000000000000000000000000000000000";
	signal muxsel_ln72_memreadrequestarbiter1 : std_logic_vector(0 downto 0);
	signal muxout_ln72_memreadrequestarbiter : std_logic_vector(7 downto 0);
	signal cat_ln72_memreadrequestarbiter : std_logic_vector(35 downto 0);
	signal muxsel_ln72_memreadrequestarbiter2_1 : std_logic_vector(0 downto 0);
	signal muxout_ln72_memreadrequestarbiter1 : std_logic_vector(7 downto 0);
	signal cat_ln72_memreadrequestarbiter1 : std_logic_vector(35 downto 0);
	signal muxsel_ln72_memreadrequestarbiter3_1 : std_logic_vector(0 downto 0);
	signal muxout_ln72_memreadrequestarbiter2 : std_logic_vector(7 downto 0);
	signal cat_ln72_memreadrequestarbiter2 : std_logic_vector(35 downto 0);
	signal muxsel_ln72_memreadrequestarbiter4_1 : std_logic_vector(0 downto 0);
	signal muxout_ln72_memreadrequestarbiter3 : std_logic_vector(7 downto 0);
	signal cat_ln72_memreadrequestarbiter3 : std_logic_vector(35 downto 0);
	signal muxsel_ln72_memreadrequestarbiter5_1 : std_logic_vector(0 downto 0);
	signal muxout_ln72_memreadrequestarbiter4 : std_logic_vector(7 downto 0);
	signal cat_ln72_memreadrequestarbiter4 : std_logic_vector(35 downto 0);
	signal muxsel_ln72_memreadrequestarbiter6_1 : std_logic_vector(0 downto 0);
	signal muxout_ln72_memreadrequestarbiter5 : std_logic_vector(7 downto 0);
	signal cat_ln72_memreadrequestarbiter5 : std_logic_vector(35 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	cat_ln63_memreadrequestarbiter<=(bit_to_vec(port5_ready) & bit_to_vec(port4_ready) & bit_to_vec(port3_ready) & bit_to_vec(port2_ready) & bit_to_vec(port1_ready) & bit_to_vec(port0_ready));
	internal_arbiter_i_requests1 <= cat_ln63_memreadrequestarbiter;
	muxsel_ln72_memreadrequestarbiter1 <= slice(internal_arbiter_i_selects, 0, 1);
	muxproc_ln72_memreadrequestarbiter : process(muxsel_ln72_memreadrequestarbiter1)
	begin
		case muxsel_ln72_memreadrequestarbiter1 is
			when "0" => muxout_ln72_memreadrequestarbiter <= "00000000";
			when "1" => muxout_ln72_memreadrequestarbiter <= "00000001";
			when others => 
			muxout_ln72_memreadrequestarbiter <= (others => 'X');
		end case;
	end process;
	cat_ln72_memreadrequestarbiter<=(muxout_ln72_memreadrequestarbiter & port0_metadata);
	muxsel_ln72_memreadrequestarbiter2_1 <= slice(internal_arbiter_i_selects, 1, 1);
	muxproc_ln72_memreadrequestarbiter1 : process(muxsel_ln72_memreadrequestarbiter2_1)
	begin
		case muxsel_ln72_memreadrequestarbiter2_1 is
			when "0" => muxout_ln72_memreadrequestarbiter1 <= "00000000";
			when "1" => muxout_ln72_memreadrequestarbiter1 <= "00000010";
			when others => 
			muxout_ln72_memreadrequestarbiter1 <= (others => 'X');
		end case;
	end process;
	cat_ln72_memreadrequestarbiter1<=(muxout_ln72_memreadrequestarbiter1 & port1_metadata);
	muxsel_ln72_memreadrequestarbiter3_1 <= slice(internal_arbiter_i_selects, 2, 1);
	muxproc_ln72_memreadrequestarbiter2 : process(muxsel_ln72_memreadrequestarbiter3_1)
	begin
		case muxsel_ln72_memreadrequestarbiter3_1 is
			when "0" => muxout_ln72_memreadrequestarbiter2 <= "00000000";
			when "1" => muxout_ln72_memreadrequestarbiter2 <= "00000011";
			when others => 
			muxout_ln72_memreadrequestarbiter2 <= (others => 'X');
		end case;
	end process;
	cat_ln72_memreadrequestarbiter2<=(muxout_ln72_memreadrequestarbiter2 & port2_metadata);
	muxsel_ln72_memreadrequestarbiter4_1 <= slice(internal_arbiter_i_selects, 3, 1);
	muxproc_ln72_memreadrequestarbiter3 : process(muxsel_ln72_memreadrequestarbiter4_1)
	begin
		case muxsel_ln72_memreadrequestarbiter4_1 is
			when "0" => muxout_ln72_memreadrequestarbiter3 <= "00000000";
			when "1" => muxout_ln72_memreadrequestarbiter3 <= "00000100";
			when others => 
			muxout_ln72_memreadrequestarbiter3 <= (others => 'X');
		end case;
	end process;
	cat_ln72_memreadrequestarbiter3<=(muxout_ln72_memreadrequestarbiter3 & port3_metadata);
	muxsel_ln72_memreadrequestarbiter5_1 <= slice(internal_arbiter_i_selects, 4, 1);
	muxproc_ln72_memreadrequestarbiter4 : process(muxsel_ln72_memreadrequestarbiter5_1)
	begin
		case muxsel_ln72_memreadrequestarbiter5_1 is
			when "0" => muxout_ln72_memreadrequestarbiter4 <= "00000000";
			when "1" => muxout_ln72_memreadrequestarbiter4 <= "00000101";
			when others => 
			muxout_ln72_memreadrequestarbiter4 <= (others => 'X');
		end case;
	end process;
	cat_ln72_memreadrequestarbiter4<=(muxout_ln72_memreadrequestarbiter4 & port4_metadata);
	muxsel_ln72_memreadrequestarbiter6_1 <= slice(internal_arbiter_i_selects, 5, 1);
	muxproc_ln72_memreadrequestarbiter5 : process(muxsel_ln72_memreadrequestarbiter6_1)
	begin
		case muxsel_ln72_memreadrequestarbiter6_1 is
			when "0" => muxout_ln72_memreadrequestarbiter5 <= "00000000";
			when "1" => muxout_ln72_memreadrequestarbiter5 <= "00000110";
			when others => 
			muxout_ln72_memreadrequestarbiter5 <= (others => 'X');
		end case;
	end process;
	cat_ln72_memreadrequestarbiter5<=(muxout_ln72_memreadrequestarbiter5 & port5_metadata);
	output_ready <= vec_to_bit(internal_arbiter_i_ready);
	output_len <= reg_ln59_memreadrequestarbiter;
	output_addr <= reg_ln60_memreadrequestarbiter;
	output_metadata <= reg_ln61_memreadrequestarbiter;
	port0_select <= vec_to_bit(slice(internal_arbiter_i_selects, 0, 1));
	port1_select <= vec_to_bit(slice(internal_arbiter_i_selects, 1, 1));
	port2_select <= vec_to_bit(slice(internal_arbiter_i_selects, 2, 1));
	port3_select <= vec_to_bit(slice(internal_arbiter_i_selects, 3, 1));
	port4_select <= vec_to_bit(slice(internal_arbiter_i_selects, 4, 1));
	port5_select <= vec_to_bit(slice(internal_arbiter_i_selects, 5, 1));
	
	-- Register processes
	
	reg_process : process(clk_pcie)
	begin
		if rising_edge(clk_pcie) then
			reg_ln59_memreadrequestarbiter <= (port0_len or port1_len or port2_len or port3_len or port4_len or port5_len);
			reg_ln60_memreadrequestarbiter <= (port0_addr or port1_addr or port2_addr or port3_addr or port4_addr or port5_addr);
			reg_ln61_memreadrequestarbiter <= (cat_ln72_memreadrequestarbiter or cat_ln72_memreadrequestarbiter1 or cat_ln72_memreadrequestarbiter2 or cat_ln72_memreadrequestarbiter3 or cat_ln72_memreadrequestarbiter4 or cat_ln72_memreadrequestarbiter5);
		end if;
	end process;
	
	-- Entity instances
	
	internal_arbiter_i : FastRequestArbiter_req6
		port map (
			selects => internal_arbiter_i_selects, -- 6 bits (out)
			ready => internal_arbiter_i_ready(0), -- 1 bits (out)
			clk_pcie => clk_pcie, -- 1 bits (in)
			rst_pcie_n => rst_pcie_n, -- 1 bits (in)
			requests => internal_arbiter_i_requests1, -- 6 bits (in)
			rst_sync => streamrst_pcie, -- 1 bits (in)
			req_done => output_done -- 1 bits (in)
		);
end MaxDC;
