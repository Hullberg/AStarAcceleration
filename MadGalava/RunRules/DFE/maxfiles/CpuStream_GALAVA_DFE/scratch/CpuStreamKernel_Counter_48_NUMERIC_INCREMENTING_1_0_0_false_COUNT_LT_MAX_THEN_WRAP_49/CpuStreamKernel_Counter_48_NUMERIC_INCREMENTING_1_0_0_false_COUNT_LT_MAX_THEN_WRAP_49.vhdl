library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CpuStreamKernel_Counter_48_NUMERIC_INCREMENTING_1_0_0_false_COUNT_LT_MAX_THEN_WRAP_49 is
	port (
		inputdata_enable : in std_logic_vector(0 downto 0);
		inputdata_max : in std_logic_vector(48 downto 0);
		outputdata_count : out std_logic_vector(47 downto 0);
		outputdata_wrap : out std_logic_vector(0 downto 0);
		ce : in std_logic;
		clk : in std_logic;
		rst : in std_logic
	);
end CpuStreamKernel_Counter_48_NUMERIC_INCREMENTING_1_0_0_false_COUNT_LT_MAX_THEN_WRAP_49;

architecture StateMachine of CpuStreamKernel_Counter_48_NUMERIC_INCREMENTING_1_0_0_false_COUNT_LT_MAX_THEN_WRAP_49 is
	-- Utility functions
	function slice(i : signed; base : natural; size : positive) return signed is
		variable v : signed(size - 1 downto 0);
	begin
		v(v'high downto v'low) := i(base + size - 1 downto base);
		return v;
	end function;
	
	function slice(i : unsigned; base : natural; size : positive) return unsigned is
		variable v : unsigned(size - 1 downto 0);
	begin
		v(v'high downto v'low) := i(base + size - 1 downto base);
		return v;
	end function;
	
	function leading1detect(v : unsigned) return unsigned is
		variable index : unsigned(v'high downto v'low) := to_unsigned(0, v'length);
	begin
		for i in v'high downto v'low loop
			if v(i) = '1' then
				index(i) := '1';
				return index;
			end if;
		end loop;
		
		return index;
	end function;
	
	function leading1detect(v : signed) return signed is
		variable index : signed(v'high downto v'low) := to_signed(0, v'length);
	begin
		for i in v'high downto v'low loop
			if v(i) = '1' then
				index(i) := '1';
				return index;
			end if;
		end loop;
		
		return index;
	end function;
	
	function trailing1detect(v : unsigned) return unsigned is
		variable index : unsigned(v'high downto v'low) := to_unsigned(0, v'length);
	begin
		for i in v'low to v'high loop
			if v(i) = '1' then
				index(i) := '1';
				return index;
			end if;
		end loop;
		
		return index;
	end function;
	
	function trailing1detect(v : signed) return signed is
		variable index : signed(v'high downto v'low) := to_signed(0, v'length);
	begin
		for i in v'low to v'high loop
			if v(i) = '1' then
				index(i) := '1';
				return index;
			end if;
		end loop;
		
		return index;
	end function;
	
	function one_hot_decode(v : unsigned; size : positive) return unsigned is
		variable result : unsigned(size - 1 downto 0);
	begin
		result := to_unsigned(0, size);
		
		for i in v'low to v'high loop
			if v(i) = '1' then
				result := result or to_unsigned(i, size);
			end if;
		end loop;
		
		return result;
	end function;
	
	function one_hot_encode(index : unsigned) return unsigned is
		variable result : unsigned(2 ** index'length - 1 downto 0) := (others => '0');
	begin
		for i in result'high downto result'low loop
			if i = index then
				result(i) := '1';
				return result;
			end if;
		end loop;
		
		return result;
	end function;
	
	function bool_to_unsigned(b : boolean) return unsigned is
	begin
		if b then
			return to_unsigned(1, 1);
		else
			return to_unsigned(0, 1);
		end if;
	end function;
	
	function reverse(v : unsigned) return unsigned is
		variable result : unsigned(v'length - 1 downto 0);
	begin
		for i in 0 to v'length - 1 loop
			result(i) := v(v'length - 1 - i);
		end loop;
		
		return result;
	end function;
	
	function reverse(v : signed) return signed is
		variable result : signed(v'length - 1 downto 0);
	begin
		for i in 0 to v'length - 1 loop
			result(i) := v(v'length - 1 - i);
		end loop;
		
		return result;
	end function;
	
	function concat(msb : unsigned; lsb : unsigned) return unsigned is
		variable result : unsigned(msb'length + lsb'length - 1 downto 0);
	begin
		for i in 0 to lsb'length - 1 loop
			result(i) := lsb(i);
		end loop;
		for i in 0 to msb'length - 1 loop
			result(i + lsb'length) := msb(i);
		end loop;
		return result;
	end function;
	
	function concat(msb : unsigned; lsb : signed) return unsigned is
	begin
		return concat(msb, unsigned(lsb));
	end function;
	
	function concat(msb : signed; lsb : unsigned) return unsigned is
	begin
		return concat(unsigned(msb), lsb);
	end function;
	
	function not_u(v : unsigned) return unsigned is
		variable result : unsigned(v'length - 1 downto 0);
	begin
		for i in 0 to v'length - 1 loop
			result(i) := not v(i);
		end loop;
		return result;
	end function;
	
	function not_s(v : signed) return signed is
		variable result : signed(v'length - 1 downto 0);
	begin
		for i in 0 to v'length - 1 loop
			result(i) := not v(i);
		end loop;
		return result;
	end function;
	
	function and_u(a, b : unsigned) return unsigned is
		variable result : unsigned(a'length - 1 downto 0);
	begin
		for i in 0 to a'length - 1 loop
			result(i) := a(i) and b(i);
		end loop;
		return result;
	end function;
	
	function and_s(a, b : signed) return signed is
		variable result : signed(a'length - 1 downto 0);
	begin
		for i in 0 to a'length - 1 loop
			result(i) := a(i) and b(i);
		end loop;
		return result;
	end function;
	
	function or_u(a, b : unsigned) return unsigned is
		variable result : unsigned(a'length - 1 downto 0);
	begin
		for i in 0 to a'length - 1 loop
			result(i) := a(i) or b(i);
		end loop;
		return result;
	end function;
	
	function or_s(a, b : signed) return signed is
		variable result : signed(a'length - 1 downto 0);
	begin
		for i in 0 to a'length - 1 loop
			result(i) := a(i) or b(i);
		end loop;
		return result;
	end function;
	
	function xor_u(a, b : unsigned) return unsigned is
		variable result : unsigned(a'length - 1 downto 0);
	begin
		for i in 0 to a'length - 1 loop
			result(i) := a(i) xor b(i);
		end loop;
		return result;
	end function;
	
	function xor_s(a, b : signed) return signed is
		variable result : signed(a'length - 1 downto 0);
	begin
		for i in 0 to a'length - 1 loop
			result(i) := a(i) xor b(i);
		end loop;
		return result;
	end function;
	
	-- Enumerated types
	
	
	-- State
	signal state1 : unsigned(48 downto 0) := to_unsigned(0, 49);
	signal next_state1 : unsigned(48 downto 0);
	signal ce_state1 : std_logic := '0';
	signal state2 : unsigned(48 downto 0) := to_unsigned(1, 49);
	signal next_state2 : unsigned(48 downto 0);
	signal ce_state2 : std_logic := '0';
	signal state3 : unsigned(48 downto 0) := to_unsigned(2, 49);
	signal next_state3 : unsigned(48 downto 0);
	signal ce_state3 : std_logic := '0';
	signal state4 : unsigned(0 downto 0) := to_unsigned(0, 1);
	signal next_state4 : unsigned(0 downto 0);
	signal ce_state4 : std_logic := '0';
	
	
	-- Attribute type declarations
	
	-- Attribute declarations
	
	-- Dummy signals, so the sensitiviy list is never empty
	signal dummy_sensitivity_signal_output_function : std_logic;
	signal dummy_sensitivity_signal_nextstate_function : std_logic;
begin
	
	-- Assign dummy signals
	dummy_sensitivity_signal_output_function <= '0';
	dummy_sensitivity_signal_nextstate_function <= '0';
	
	-- Combinatorial process
	
	combi_proc: process(inputdata_enable, inputdata_max, state1, state2, state3, state4)
	begin
		ce_state1 <= '0';
		next_state1 <= state1;
		ce_state2 <= '0';
		next_state2 <= state2;
		ce_state3 <= '0';
		next_state3 <= state3;
		ce_state4 <= '0';
		next_state4 <= state4;
		if unsigned(inputdata_enable) = "1" then
			next_state3 <= state2 + to_unsigned(2, 49);
			ce_state3 <= '1';
			if (bool_to_unsigned(state2 >= unsigned(inputdata_max))) = "1" then
				next_state4 <= to_unsigned(1, 1);
				ce_state4 <= '1';
				next_state1 <= to_unsigned(0, 49);
				ce_state1 <= '1';
				next_state2 <= to_unsigned(1, 49);
				ce_state2 <= '1';
			else
				if state4 = "1" then
					next_state4 <= to_unsigned(0, 1);
					ce_state4 <= '1';
					next_state1 <= state2;
					ce_state1 <= '1';
					next_state2 <= to_unsigned(2, 49);
					ce_state2 <= '1';
				else
					next_state1 <= state2;
					ce_state1 <= '1';
					next_state2 <= state3;
					ce_state2 <= '1';
				end if;
			end if;
		end if;
		outputdata_count <= std_logic_vector(slice(state1, 0, 48));
		outputdata_wrap <= std_logic_vector(and_u((bool_to_unsigned(state2 >= unsigned(inputdata_max))), unsigned(inputdata_enable)));
	end process;
	
	
	-- Register process
	
	reg_proc: process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				state1 <= to_unsigned(0, 49);
				state2 <= to_unsigned(1, 49);
				state3 <= to_unsigned(2, 49);
				state4 <= to_unsigned(0, 1);
			elsif ce = '1' then
				if ce_state1 = '1' then
					state1 <= next_state1;
				end if;
				if ce_state2 = '1' then
					state2 <= next_state2;
				end if;
				if ce_state3 = '1' then
					state3 <= next_state3;
				end if;
				if ce_state4 = '1' then
					state4 <= next_state4;
				end if;
			end if;
		end if;
	end process;
	
end StateMachine;
