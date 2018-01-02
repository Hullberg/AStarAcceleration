library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity MemReadResponseDispatcher is
	port (
		clk_pcie: in std_logic;
		rst_pcie_n: in std_logic;
		decoder_data_valid: in std_logic_vector(1 downto 0);
		decoder_data: in std_logic_vector(127 downto 0);
		decoder_metadata: in std_logic_vector(35 downto 0);
		decoder_metadata_valid: in std_logic;
		receiver0_metadata_free: in std_logic;
		receiver1_metadata_free: in std_logic;
		receiver2_metadata_free: in std_logic;
		receiver3_metadata_free: in std_logic;
		receiver4_metadata_free: in std_logic;
		receiver5_metadata_free: in std_logic;
		decoder_metadata_free: out std_logic;
		receiver0_valid: out std_logic_vector(1 downto 0);
		receiver0_data: out std_logic_vector(127 downto 0);
		receiver0_select: out std_logic;
		receiver0_metadata: out std_logic_vector(27 downto 0);
		receiver0_metadata_valid: out std_logic;
		receiver1_valid: out std_logic_vector(1 downto 0);
		receiver1_data: out std_logic_vector(127 downto 0);
		receiver1_select: out std_logic;
		receiver1_metadata: out std_logic_vector(27 downto 0);
		receiver1_metadata_valid: out std_logic;
		receiver2_valid: out std_logic_vector(1 downto 0);
		receiver2_data: out std_logic_vector(127 downto 0);
		receiver2_select: out std_logic;
		receiver2_metadata: out std_logic_vector(27 downto 0);
		receiver2_metadata_valid: out std_logic;
		receiver3_valid: out std_logic_vector(1 downto 0);
		receiver3_data: out std_logic_vector(127 downto 0);
		receiver3_select: out std_logic;
		receiver3_metadata: out std_logic_vector(27 downto 0);
		receiver3_metadata_valid: out std_logic;
		receiver4_valid: out std_logic_vector(1 downto 0);
		receiver4_data: out std_logic_vector(127 downto 0);
		receiver4_select: out std_logic;
		receiver4_metadata: out std_logic_vector(27 downto 0);
		receiver4_metadata_valid: out std_logic;
		receiver5_valid: out std_logic_vector(1 downto 0);
		receiver5_data: out std_logic_vector(127 downto 0);
		receiver5_select: out std_logic;
		receiver5_metadata: out std_logic_vector(27 downto 0);
		receiver5_metadata_valid: out std_logic
	);
end MemReadResponseDispatcher;

architecture MaxDC of MemReadResponseDispatcher is
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
	
	signal reg_ln57_memreadresponsedispatcher : std_logic_vector(0 downto 0) := "0";
	signal data_valid_rr : std_logic_vector(1 downto 0) := "00";
	signal data_valid_r : std_logic_vector(1 downto 0) := "00";
	signal data_rr : std_logic_vector(127 downto 0) := "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
	signal data_r : std_logic_vector(127 downto 0) := "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
	signal selected_rec0 : std_logic_vector(0 downto 0) := "0";
	signal target_r : std_logic_vector(7 downto 0) := "00000000";
	signal metadata_rr : std_logic_vector(27 downto 0) := "0000000000000000000000000000";
	signal metadata_r : std_logic_vector(27 downto 0) := "0000000000000000000000000000";
	signal selected_rec1 : std_logic_vector(0 downto 0) := "0";
	signal selected_rec2 : std_logic_vector(0 downto 0) := "0";
	signal selected_rec3 : std_logic_vector(0 downto 0) := "0";
	signal selected_rec4 : std_logic_vector(0 downto 0) := "0";
	signal selected_rec5 : std_logic_vector(0 downto 0) := "0";
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	decoder_metadata_free <= vec_to_bit(reg_ln57_memreadresponsedispatcher);
	receiver0_valid <= data_valid_rr;
	receiver0_data <= data_rr;
	receiver0_select <= vec_to_bit(selected_rec0);
	receiver0_metadata <= metadata_rr;
	receiver0_metadata_valid <= vec_to_bit(selected_rec0);
	receiver1_valid <= data_valid_rr;
	receiver1_data <= data_rr;
	receiver1_select <= vec_to_bit(selected_rec1);
	receiver1_metadata <= metadata_rr;
	receiver1_metadata_valid <= vec_to_bit(selected_rec1);
	receiver2_valid <= data_valid_rr;
	receiver2_data <= data_rr;
	receiver2_select <= vec_to_bit(selected_rec2);
	receiver2_metadata <= metadata_rr;
	receiver2_metadata_valid <= vec_to_bit(selected_rec2);
	receiver3_valid <= data_valid_rr;
	receiver3_data <= data_rr;
	receiver3_select <= vec_to_bit(selected_rec3);
	receiver3_metadata <= metadata_rr;
	receiver3_metadata_valid <= vec_to_bit(selected_rec3);
	receiver4_valid <= data_valid_rr;
	receiver4_data <= data_rr;
	receiver4_select <= vec_to_bit(selected_rec4);
	receiver4_metadata <= metadata_rr;
	receiver4_metadata_valid <= vec_to_bit(selected_rec4);
	receiver5_valid <= data_valid_rr;
	receiver5_data <= data_rr;
	receiver5_select <= vec_to_bit(selected_rec5);
	receiver5_metadata <= metadata_rr;
	receiver5_metadata_valid <= vec_to_bit(selected_rec5);
	
	-- Register processes
	
	reg_process : process(clk_pcie)
	begin
		if rising_edge(clk_pcie) then
			reg_ln57_memreadresponsedispatcher <= (bit_to_vec(receiver0_metadata_free) or bit_to_vec(receiver1_metadata_free) or bit_to_vec(receiver2_metadata_free) or bit_to_vec(receiver3_metadata_free) or bit_to_vec(receiver4_metadata_free) or bit_to_vec(receiver5_metadata_free));
			data_valid_rr <= data_valid_r;
			data_valid_r <= decoder_data_valid;
			data_rr <= data_r;
			data_r <= decoder_data;
			selected_rec0 <= bool_to_vec((target_r) = ("00000001"));
			if slv_to_slv(bit_to_vec(decoder_metadata_valid)) = "1" then
				target_r <= slice(decoder_metadata, 28, 8);
			end if;
			metadata_rr <= metadata_r;
			if slv_to_slv(bit_to_vec(decoder_metadata_valid)) = "1" then
				metadata_r <= slice(decoder_metadata, 0, 28);
			end if;
			selected_rec1 <= bool_to_vec((target_r) = ("00000010"));
			selected_rec2 <= bool_to_vec((target_r) = ("00000011"));
			selected_rec3 <= bool_to_vec((target_r) = ("00000100"));
			selected_rec4 <= bool_to_vec((target_r) = ("00000101"));
			selected_rec5 <= bool_to_vec((target_r) = ("00000110"));
		end if;
	end process;
	
	-- Entity instances
	
end MaxDC;
