library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity MappedDRP_Addr_3c0000_ChecksumMappedDRP is
	port (
		memories_data_in: in std_logic_vector(35 downto 0);
		memories_memid: in std_logic_vector(15 downto 0);
		memories_memaddr: in std_logic_vector(15 downto 0);
		memories_wren: in std_logic;
		memories_rden: in std_logic;
		memories_stop: in std_logic;
		clk: in std_logic;
		memories_data_out: out std_logic_vector(35 downto 0);
		memories_ack: out std_logic
	);
end MappedDRP_Addr_3c0000_ChecksumMappedDRP;

architecture MaxDC of MappedDRP_Addr_3c0000_ChecksumMappedDRP is
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
	component ChecksumMappedDRP_RAM is
		port (
			DCLK: in std_logic;
			DEN: in std_logic;
			DADDR: in std_logic_vector(8 downto 0);
			DWE: in std_logic;
			DI: in std_logic_vector(31 downto 0);
			DO: out std_logic_vector(31 downto 0);
			DRDY: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal mappeddrp_addr_3c0000_checksummappeddrp_i_do : std_logic_vector(31 downto 0);
	signal mappeddrp_addr_3c0000_checksummappeddrp_i_drdy : std_logic_vector(0 downto 0);
	signal mappeddrp_addr_3c0000_checksummappeddrp_i_den1 : std_logic_vector(0 downto 0);
	signal mappeddrp_addr_3c0000_checksummappeddrp_i_daddr1 : std_logic_vector(8 downto 0);
	signal mappeddrp_addr_3c0000_checksummappeddrp_i_di1 : std_logic_vector(31 downto 0);
	signal reg_ln90_mappeddrp : std_logic_vector(35 downto 0) := "000000000000000000000000000000000000";
	signal reg_ln52_mappeddrp : std_logic_vector(0 downto 0) := "0";
	signal cat_ln73_mappeddrp : std_logic_vector(35 downto 0);
	signal cat_ln72_mappeddrp : std_logic_vector(35 downto 0);
	signal reg_ln94_mappeddrp : std_logic_vector(0 downto 0) := "0";
	signal reg_ln84_mappeddrp : std_logic_vector(0 downto 0) := "0";
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	mappeddrp_addr_3c0000_checksummappeddrp_i_den1 <= ((bool_to_vec((memories_memid) = ("0000000000111100")) and "1") and (bit_to_vec(memories_rden) or bit_to_vec(memories_wren)));
	mappeddrp_addr_3c0000_checksummappeddrp_i_daddr1 <= slice(memories_memaddr, 0, 9);
	mappeddrp_addr_3c0000_checksummappeddrp_i_di1 <= slice(memories_data_in, 0, 32);
	cat_ln73_mappeddrp<=(reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp & reg_ln52_mappeddrp);
	cat_ln72_mappeddrp<=("0000" & mappeddrp_addr_3c0000_checksummappeddrp_i_do);
	memories_data_out <= reg_ln90_mappeddrp;
	memories_ack <= vec_to_bit(reg_ln94_mappeddrp);
	
	-- Register processes
	
	reg_process : process(clk)
	begin
		if rising_edge(clk) then
			reg_ln90_mappeddrp <= (cat_ln73_mappeddrp and cat_ln72_mappeddrp);
			reg_ln52_mappeddrp <= (bool_to_vec((memories_memid) = ("0000000000111100")) and "1");
			reg_ln94_mappeddrp <= ((reg_ln52_mappeddrp and mappeddrp_addr_3c0000_checksummappeddrp_i_drdy) and (not reg_ln84_mappeddrp));
			reg_ln84_mappeddrp <= (reg_ln52_mappeddrp and mappeddrp_addr_3c0000_checksummappeddrp_i_drdy);
		end if;
	end process;
	
	-- Entity instances
	
	mappeddrp_addr_3c0000_checksummappeddrp_i : ChecksumMappedDRP_RAM
		port map (
			DO => mappeddrp_addr_3c0000_checksummappeddrp_i_do, -- 32 bits (out)
			DRDY => mappeddrp_addr_3c0000_checksummappeddrp_i_drdy(0), -- 1 bits (out)
			DCLK => clk, -- 1 bits (in)
			DEN => vec_to_bit(mappeddrp_addr_3c0000_checksummappeddrp_i_den1), -- 1 bits (in)
			DADDR => mappeddrp_addr_3c0000_checksummappeddrp_i_daddr1, -- 9 bits (in)
			DWE => memories_wren, -- 1 bits (in)
			DI => mappeddrp_addr_3c0000_checksummappeddrp_i_di1 -- 32 bits (in)
		);
end MaxDC;
