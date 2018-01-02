library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity TXStopBarParser is
	port (
		bar_parse_wr_addr_onehot: in std_logic_vector(255 downto 0);
		bar_parse_wr_data: in std_logic_vector(63 downto 0);
		bar_parse_wr_clk: in std_logic;
		bar_parse_wr_page_sel_onehot: in std_logic_vector(1 downto 0);
		rst_sync: in std_logic;
		tx_stop: out std_logic
	);
end TXStopBarParser;

architecture MaxDC of TXStopBarParser is
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
	
	-- Signal declarations
	
	signal tx_stop_i : std_logic_vector(0 downto 0) := "0";
	signal rst_falling_edge : std_logic_vector(0 downto 0) := "0";
	signal rst_sync_r : std_logic_vector(0 downto 0) := "0";
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	tx_stop <= vec_to_bit(tx_stop_i);
	
	-- Register processes
	
	reg_process : process(bar_parse_wr_clk)
	begin
		if rising_edge(bar_parse_wr_clk) then
			if slv_to_slv(rst_falling_edge) = "1" then
				tx_stop_i <= "0";
			else
				if slv_to_slv((slice(bar_parse_wr_addr_onehot, 31, 1) and slice(bar_parse_wr_page_sel_onehot, 0, 1))) = "1" then
					tx_stop_i <= slice(bar_parse_wr_data, 32, 1);
				end if;
			end if;
			rst_falling_edge <= ((not bit_to_vec(rst_sync)) and rst_sync_r);
			rst_sync_r <= bit_to_vec(rst_sync);
		end if;
	end process;
	
	-- Entity instances
	
end MaxDC;
