library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
library altera_mf;
use altera_mf.altera_mf_components.all;

entity AlteraBlockMem_RAM_TWO_PORT_36x512_RAM_TWO_PORT_ireg is
	port (
		wea: in std_logic_vector(0 downto 0);
		addra: in std_logic_vector(8 downto 0);
		dina: in std_logic_vector(35 downto 0);
		clka: in std_logic;
		addrb: in std_logic_vector(8 downto 0);
		doutb: out std_logic_vector(35 downto 0)
	);
end AlteraBlockMem_RAM_TWO_PORT_36x512_RAM_TWO_PORT_ireg;

architecture MaxDC of AlteraBlockMem_RAM_TWO_PORT_36x512_RAM_TWO_PORT_ireg is
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
	
	signal inst_ln101_mwblockmem_q_b : std_logic_vector(35 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	doutb <= inst_ln101_mwblockmem_q_b;
	
	-- Register processes
	
	
	-- Entity instances
	
	inst_ln101_mwblockmem : altsyncram
		generic map (
			ADDRESS_ACLR_A => "UNUSED",
			ADDRESS_ACLR_B => "NONE",
			ADDRESS_REG_B => "CLOCK0",
			BYTE_SIZE => 8,
			BYTEENA_ACLR_A => "UNUSED",
			BYTEENA_ACLR_B => "NONE",
			BYTEENA_REG_B => "CLOCK1",
			CLOCK_ENABLE_CORE_A => "USE_INPUT_CLKEN",
			CLOCK_ENABLE_CORE_B => "USE_INPUT_CLKEN",
			CLOCK_ENABLE_INPUT_A => "BYPASS",
			CLOCK_ENABLE_INPUT_B => "BYPASS",
			CLOCK_ENABLE_OUTPUT_A => "BYPASS",
			CLOCK_ENABLE_OUTPUT_B => "BYPASS",
			INTENDED_DEVICE_FAMILY => "stratixv",
			ENABLE_ECC => "FALSE",
			IMPLEMENT_IN_LES => "OFF",
			INDATA_ACLR_A => "UNUSED",
			INDATA_ACLR_B => "NONE",
			INDATA_REG_B => "CLOCK0",
			INIT_FILE => "UNUSED",
			INIT_FILE_LAYOUT => "PORT_A",
			MAXIMUM_DEPTH => 0,
			NUMWORDS_A => 512,
			NUMWORDS_B => 512,
			OPERATION_MODE => "DUAL_PORT",
			OUTDATA_ACLR_A => "NONE",
			OUTDATA_ACLR_B => "NONE",
			OUTDATA_REG_A => "UNREGISTERED",
			OUTDATA_REG_B => "UNREGISTERED",
			POWER_UP_UNINITIALIZED => "FALSE",
			RAM_BLOCK_TYPE => "AUTO",
			RDCONTROL_ACLR_B => "NONE",
			RDCONTROL_REG_B => "CLOCK1",
			READ_DURING_WRITE_MODE_MIXED_PORTS => "DONT_CARE",
			READ_DURING_WRITE_MODE_PORT_A => "NEW_DATA_NO_NBE_READ",
			READ_DURING_WRITE_MODE_PORT_B => "NEW_DATA_NO_NBE_READ",
			WIDTH_A => 36,
			WIDTH_B => 36,
			WIDTH_BYTEENA_A => 1,
			WIDTH_BYTEENA_B => 1,
			WIDTHAD_A => 9,
			WIDTHAD_B => 9,
			WRCONTROL_ACLR_A => "UNUSED",
			WRCONTROL_ACLR_B => "NONE",
			WRCONTROL_WRADDRESS_REG_B => "CLOCK0",
			LPM_HINT => "UNUSED",
			LPM_TYPE => "altsyncram"
		)
		port map (
			q_b => inst_ln101_mwblockmem_q_b, -- 36 bits (out)
			clock0 => clka, -- 1 bits (in)
			address_a => addra, -- 9 bits (in)
			data_a => dina, -- 36 bits (in)
			wren_a => vec_to_bit(wea), -- 1 bits (in)
			address_b => addrb -- 9 bits (in)
		);
end MaxDC;
