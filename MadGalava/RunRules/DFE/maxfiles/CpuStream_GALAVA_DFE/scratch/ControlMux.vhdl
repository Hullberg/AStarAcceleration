library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity ControlMux is
	port (
		select_ea: in std_logic;
		FROM_SWITCH_SOP_N: in std_logic;
		FROM_SWITCH_EOP_N: in std_logic;
		FROM_SWITCH_SRC_RDY_N: in std_logic;
		FROM_SWITCH_DATA: in std_logic_vector(31 downto 0);
		TO_SWITCH_DST_RDY_N: in std_logic;
		FROM_CPP_SOP_N: in std_logic;
		FROM_CPP_EOP_N: in std_logic;
		FROM_CPP_SRC_RDY_N: in std_logic;
		FROM_CPP_DATA: in std_logic_vector(31 downto 0);
		TO_CPP_DST_RDY_N: in std_logic;
		FROM_EA_SOP_N: in std_logic;
		FROM_EA_EOP_N: in std_logic;
		FROM_EA_SRC_RDY_N: in std_logic;
		FROM_EA_DATA: in std_logic_vector(31 downto 0);
		TO_EA_DST_RDY_N: in std_logic;
		FROM_SWITCH_DST_RDY_N: out std_logic;
		TO_SWITCH_SOP_N: out std_logic;
		TO_SWITCH_EOP_N: out std_logic;
		TO_SWITCH_SRC_RDY_N: out std_logic;
		TO_SWITCH_DATA: out std_logic_vector(31 downto 0);
		FROM_CPP_DST_RDY_N: out std_logic;
		TO_CPP_SOP_N: out std_logic;
		TO_CPP_EOP_N: out std_logic;
		TO_CPP_SRC_RDY_N: out std_logic;
		TO_CPP_DATA: out std_logic_vector(31 downto 0);
		FROM_EA_DST_RDY_N: out std_logic;
		TO_EA_SOP_N: out std_logic;
		TO_EA_EOP_N: out std_logic;
		TO_EA_SRC_RDY_N: out std_logic;
		TO_EA_DATA: out std_logic_vector(31 downto 0)
	);
end ControlMux;

architecture MaxDC of ControlMux is
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
	
	signal muxsel_ln43_controlmux1 : std_logic_vector(0 downto 0);
	signal muxout_ln43_controlmux : std_logic_vector(0 downto 0);
	signal muxsel_ln43_controlmux2_1 : std_logic_vector(0 downto 0);
	signal muxout_ln43_controlmux1 : std_logic_vector(0 downto 0);
	signal muxsel_ln43_controlmux3_1 : std_logic_vector(0 downto 0);
	signal muxout_ln43_controlmux2 : std_logic_vector(0 downto 0);
	signal muxsel_ln43_controlmux4_1 : std_logic_vector(0 downto 0);
	signal muxout_ln43_controlmux3 : std_logic_vector(0 downto 0);
	signal muxsel_ln43_controlmux5_1 : std_logic_vector(0 downto 0);
	signal muxout_ln43_controlmux4 : std_logic_vector(31 downto 0);
	signal muxsel_ln51_controlmux1 : std_logic_vector(0 downto 0);
	signal muxout_ln51_controlmux : std_logic_vector(0 downto 0);
	signal muxsel_ln51_controlmux2_1 : std_logic_vector(0 downto 0);
	signal muxout_ln51_controlmux1 : std_logic_vector(0 downto 0);
	signal muxsel_ln51_controlmux3_1 : std_logic_vector(0 downto 0);
	signal muxout_ln51_controlmux2 : std_logic_vector(0 downto 0);
	signal muxsel_ln51_controlmux4_1 : std_logic_vector(0 downto 0);
	signal muxout_ln51_controlmux3 : std_logic_vector(0 downto 0);
	signal muxsel_ln52_controlmux1 : std_logic_vector(0 downto 0);
	signal muxout_ln52_controlmux : std_logic_vector(0 downto 0);
	signal muxsel_ln52_controlmux2_1 : std_logic_vector(0 downto 0);
	signal muxout_ln52_controlmux1 : std_logic_vector(0 downto 0);
	signal muxsel_ln52_controlmux3_1 : std_logic_vector(0 downto 0);
	signal muxout_ln52_controlmux2 : std_logic_vector(0 downto 0);
	signal muxsel_ln52_controlmux4_1 : std_logic_vector(0 downto 0);
	signal muxout_ln52_controlmux3 : std_logic_vector(0 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	muxsel_ln43_controlmux1 <= bit_to_vec(select_ea);
	muxproc_ln43_controlmux : process(TO_CPP_DST_RDY_N, TO_EA_DST_RDY_N, muxsel_ln43_controlmux1)
	begin
		case muxsel_ln43_controlmux1 is
			when "0" => muxout_ln43_controlmux <= bit_to_vec(TO_CPP_DST_RDY_N);
			when "1" => muxout_ln43_controlmux <= bit_to_vec(TO_EA_DST_RDY_N);
			when others => 
			muxout_ln43_controlmux <= (others => 'X');
		end case;
	end process;
	muxsel_ln43_controlmux2_1 <= bit_to_vec(select_ea);
	muxproc_ln43_controlmux1 : process(FROM_CPP_SOP_N, FROM_EA_SOP_N, muxsel_ln43_controlmux2_1)
	begin
		case muxsel_ln43_controlmux2_1 is
			when "0" => muxout_ln43_controlmux1 <= bit_to_vec(FROM_CPP_SOP_N);
			when "1" => muxout_ln43_controlmux1 <= bit_to_vec(FROM_EA_SOP_N);
			when others => 
			muxout_ln43_controlmux1 <= (others => 'X');
		end case;
	end process;
	muxsel_ln43_controlmux3_1 <= bit_to_vec(select_ea);
	muxproc_ln43_controlmux2 : process(FROM_CPP_EOP_N, FROM_EA_EOP_N, muxsel_ln43_controlmux3_1)
	begin
		case muxsel_ln43_controlmux3_1 is
			when "0" => muxout_ln43_controlmux2 <= bit_to_vec(FROM_CPP_EOP_N);
			when "1" => muxout_ln43_controlmux2 <= bit_to_vec(FROM_EA_EOP_N);
			when others => 
			muxout_ln43_controlmux2 <= (others => 'X');
		end case;
	end process;
	muxsel_ln43_controlmux4_1 <= bit_to_vec(select_ea);
	muxproc_ln43_controlmux3 : process(FROM_CPP_SRC_RDY_N, FROM_EA_SRC_RDY_N, muxsel_ln43_controlmux4_1)
	begin
		case muxsel_ln43_controlmux4_1 is
			when "0" => muxout_ln43_controlmux3 <= bit_to_vec(FROM_CPP_SRC_RDY_N);
			when "1" => muxout_ln43_controlmux3 <= bit_to_vec(FROM_EA_SRC_RDY_N);
			when others => 
			muxout_ln43_controlmux3 <= (others => 'X');
		end case;
	end process;
	muxsel_ln43_controlmux5_1 <= bit_to_vec(select_ea);
	muxproc_ln43_controlmux4 : process(FROM_CPP_DATA, FROM_EA_DATA, muxsel_ln43_controlmux5_1)
	begin
		case muxsel_ln43_controlmux5_1 is
			when "0" => muxout_ln43_controlmux4 <= FROM_CPP_DATA;
			when "1" => muxout_ln43_controlmux4 <= FROM_EA_DATA;
			when others => 
			muxout_ln43_controlmux4 <= (others => 'X');
		end case;
	end process;
	muxsel_ln51_controlmux1 <= bit_to_vec(select_ea);
	muxproc_ln51_controlmux : process(TO_SWITCH_DST_RDY_N, muxsel_ln51_controlmux1)
	begin
		case muxsel_ln51_controlmux1 is
			when "0" => muxout_ln51_controlmux <= bit_to_vec(TO_SWITCH_DST_RDY_N);
			when "1" => muxout_ln51_controlmux <= "1";
			when others => 
			muxout_ln51_controlmux <= (others => 'X');
		end case;
	end process;
	muxsel_ln51_controlmux2_1 <= bit_to_vec(select_ea);
	muxproc_ln51_controlmux1 : process(FROM_SWITCH_SOP_N, muxsel_ln51_controlmux2_1)
	begin
		case muxsel_ln51_controlmux2_1 is
			when "0" => muxout_ln51_controlmux1 <= bit_to_vec(FROM_SWITCH_SOP_N);
			when "1" => muxout_ln51_controlmux1 <= "1";
			when others => 
			muxout_ln51_controlmux1 <= (others => 'X');
		end case;
	end process;
	muxsel_ln51_controlmux3_1 <= bit_to_vec(select_ea);
	muxproc_ln51_controlmux2 : process(FROM_SWITCH_EOP_N, muxsel_ln51_controlmux3_1)
	begin
		case muxsel_ln51_controlmux3_1 is
			when "0" => muxout_ln51_controlmux2 <= bit_to_vec(FROM_SWITCH_EOP_N);
			when "1" => muxout_ln51_controlmux2 <= "1";
			when others => 
			muxout_ln51_controlmux2 <= (others => 'X');
		end case;
	end process;
	muxsel_ln51_controlmux4_1 <= bit_to_vec(select_ea);
	muxproc_ln51_controlmux3 : process(FROM_SWITCH_SRC_RDY_N, muxsel_ln51_controlmux4_1)
	begin
		case muxsel_ln51_controlmux4_1 is
			when "0" => muxout_ln51_controlmux3 <= bit_to_vec(FROM_SWITCH_SRC_RDY_N);
			when "1" => muxout_ln51_controlmux3 <= "1";
			when others => 
			muxout_ln51_controlmux3 <= (others => 'X');
		end case;
	end process;
	muxsel_ln52_controlmux1 <= bit_to_vec(select_ea);
	muxproc_ln52_controlmux : process(TO_SWITCH_DST_RDY_N, muxsel_ln52_controlmux1)
	begin
		case muxsel_ln52_controlmux1 is
			when "0" => muxout_ln52_controlmux <= "1";
			when "1" => muxout_ln52_controlmux <= bit_to_vec(TO_SWITCH_DST_RDY_N);
			when others => 
			muxout_ln52_controlmux <= (others => 'X');
		end case;
	end process;
	muxsel_ln52_controlmux2_1 <= bit_to_vec(select_ea);
	muxproc_ln52_controlmux1 : process(FROM_SWITCH_SOP_N, muxsel_ln52_controlmux2_1)
	begin
		case muxsel_ln52_controlmux2_1 is
			when "0" => muxout_ln52_controlmux1 <= "1";
			when "1" => muxout_ln52_controlmux1 <= bit_to_vec(FROM_SWITCH_SOP_N);
			when others => 
			muxout_ln52_controlmux1 <= (others => 'X');
		end case;
	end process;
	muxsel_ln52_controlmux3_1 <= bit_to_vec(select_ea);
	muxproc_ln52_controlmux2 : process(FROM_SWITCH_EOP_N, muxsel_ln52_controlmux3_1)
	begin
		case muxsel_ln52_controlmux3_1 is
			when "0" => muxout_ln52_controlmux2 <= "1";
			when "1" => muxout_ln52_controlmux2 <= bit_to_vec(FROM_SWITCH_EOP_N);
			when others => 
			muxout_ln52_controlmux2 <= (others => 'X');
		end case;
	end process;
	muxsel_ln52_controlmux4_1 <= bit_to_vec(select_ea);
	muxproc_ln52_controlmux3 : process(FROM_SWITCH_SRC_RDY_N, muxsel_ln52_controlmux4_1)
	begin
		case muxsel_ln52_controlmux4_1 is
			when "0" => muxout_ln52_controlmux3 <= "1";
			when "1" => muxout_ln52_controlmux3 <= bit_to_vec(FROM_SWITCH_SRC_RDY_N);
			when others => 
			muxout_ln52_controlmux3 <= (others => 'X');
		end case;
	end process;
	FROM_SWITCH_DST_RDY_N <= vec_to_bit(muxout_ln43_controlmux);
	TO_SWITCH_SOP_N <= vec_to_bit(muxout_ln43_controlmux1);
	TO_SWITCH_EOP_N <= vec_to_bit(muxout_ln43_controlmux2);
	TO_SWITCH_SRC_RDY_N <= vec_to_bit(muxout_ln43_controlmux3);
	TO_SWITCH_DATA <= muxout_ln43_controlmux4;
	FROM_CPP_DST_RDY_N <= vec_to_bit(muxout_ln51_controlmux);
	TO_CPP_SOP_N <= vec_to_bit(muxout_ln51_controlmux1);
	TO_CPP_EOP_N <= vec_to_bit(muxout_ln51_controlmux2);
	TO_CPP_SRC_RDY_N <= vec_to_bit(muxout_ln51_controlmux3);
	TO_CPP_DATA <= FROM_SWITCH_DATA;
	FROM_EA_DST_RDY_N <= vec_to_bit(muxout_ln52_controlmux);
	TO_EA_SOP_N <= vec_to_bit(muxout_ln52_controlmux1);
	TO_EA_EOP_N <= vec_to_bit(muxout_ln52_controlmux2);
	TO_EA_SRC_RDY_N <= vec_to_bit(muxout_ln52_controlmux3);
	TO_EA_DATA <= FROM_SWITCH_DATA;
	
	-- Register processes
	
	
	-- Entity instances
	
end MaxDC;
