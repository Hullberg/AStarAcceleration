library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity stream_clkprim_lock_count_32 is
	port (
		clkDst: in std_logic;
		lock: in std_logic;
		counter: out std_logic_vector(31 downto 0)
	);
end stream_clkprim_lock_count_32;

architecture MaxDC of stream_clkprim_lock_count_32 is
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
	component vhdl_bus_synchronizer is
		generic (
			width : integer
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			dat_i: in std_logic_vector(width-1 downto 0);
			dat_o: out std_logic_vector(width-1 downto 0)
		);
	end component;
	attribute box_type of vhdl_bus_synchronizer : component is "BLACK_BOX";
	
	-- Signal declarations
	
	signal inst_ln11_bussynchroniser_dat_o : std_logic_vector(0 downto 0);
	signal falling_edge_detect : std_logic_vector(0 downto 0) := "1";
	signal clkDst_locked_d1 : std_logic_vector(0 downto 0) := "1";
	signal edge_count : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	counter <= (unsigned(falling_edge_detect) + unsigned(edge_count));
	
	-- Register processes
	
	reg_process : process(clkDst)
	begin
		if rising_edge(clkDst) then
			if slv_to_slv("0") = "1" then
				falling_edge_detect <= "1";
			else
				if slv_to_slv("1") = "1" then
					falling_edge_detect <= (inst_ln11_bussynchroniser_dat_o and (not clkDst_locked_d1));
				end if;
			end if;
			if slv_to_slv("0") = "1" then
				clkDst_locked_d1 <= "1";
			else
				if slv_to_slv("1") = "1" then
					clkDst_locked_d1 <= inst_ln11_bussynchroniser_dat_o;
				end if;
			end if;
			if slv_to_slv("0") = "1" then
				edge_count <= "00000000000000000000000000000000";
			else
				if slv_to_slv(falling_edge_detect) = "1" then
					edge_count <= (unsigned(falling_edge_detect) + unsigned(edge_count));
				end if;
			end if;
		end if;
	end process;
	
	-- Entity instances
	
	inst_ln11_bussynchroniser : vhdl_bus_synchronizer
		generic map (
			width => 1
		)
		port map (
			dat_o => inst_ln11_bussynchroniser_dat_o, -- 1 bits (out)
			clk => clkDst, -- 1 bits (in)
			rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => bit_to_vec(lock) -- 1 bits (in)
		);
end MaxDC;
