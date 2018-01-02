library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity MappedRegistersController_50 is
	port (
		switch_registers: in std_logic;
		clk_switch: in std_logic;
		rst_switch: in std_logic;
		register_out: in std_logic_vector(7 downto 0);
		FROM_SWITCH_SOP_N: in std_logic;
		FROM_SWITCH_EOP_N: in std_logic;
		FROM_SWITCH_SRC_RDY_N: in std_logic;
		FROM_SWITCH_DATA: in std_logic_vector(31 downto 0);
		TO_SWITCH_DST_RDY_N: in std_logic;
		register_clk: out std_logic;
		register_in: out std_logic_vector(7 downto 0);
		register_rotate: out std_logic;
		register_stop: out std_logic;
		register_switch: out std_logic;
		FROM_SWITCH_DST_RDY_N: out std_logic;
		TO_SWITCH_SOP_N: out std_logic;
		TO_SWITCH_EOP_N: out std_logic;
		TO_SWITCH_SRC_RDY_N: out std_logic;
		TO_SWITCH_DATA: out std_logic_vector(31 downto 0)
	);
end MappedRegistersController_50;

architecture MaxDC of MappedRegistersController_50 is
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
	component MappedRegistersEA is
		port (
			clk_switch: in std_logic;
			rst_switch: in std_logic;
			FROM_SWITCH_SOP_N: in std_logic;
			FROM_SWITCH_EOP_N: in std_logic;
			FROM_SWITCH_SRC_RDY_N: in std_logic;
			FROM_SWITCH_DATA: in std_logic_vector(31 downto 0);
			TO_SWITCH_DST_RDY_N: in std_logic;
			ea_finished: in std_logic;
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
			ea_start: out std_logic;
			FROM_EA_DST_RDY_N: out std_logic;
			TO_EA_SOP_N: out std_logic;
			TO_EA_EOP_N: out std_logic;
			TO_EA_SRC_RDY_N: out std_logic;
			TO_EA_DATA: out std_logic_vector(31 downto 0);
			base_address: out std_logic_vector(23 downto 0);
			reserved_0: out std_logic_vector(5 downto 0);
			w_nr: out std_logic;
			is_response_header: out std_logic;
			last_read_address: out std_logic_vector(23 downto 0);
			reserved_1: out std_logic_vector(7 downto 0)
		);
	end component;
	component mapped_registers_controller is
		generic (
			CHAIN_LENGTH : integer;
			CHAIN_LENGTH_BITS : integer
		);
		port (
			clk_registers: in std_logic;
			rst_registers: in std_logic;
			switch_registers: in std_logic;
			controller_start: in std_logic;
			is_write: in std_logic;
			base_address: in std_logic_vector(5 downto 0);
			last_read_address: in std_logic_vector(5 downto 0);
			WRITE_PORT_SOP_N: in std_logic;
			WRITE_PORT_EOP_N: in std_logic;
			WRITE_PORT_SRC_RDY_N: in std_logic;
			WRITE_PORT_DATA: in std_logic_vector(31 downto 0);
			READ_PORT_DST_RDY_N: in std_logic;
			register_out: in std_logic_vector(7 downto 0);
			controller_finished: out std_logic;
			WRITE_PORT_DST_RDY_N: out std_logic;
			READ_PORT_SOP_N: out std_logic;
			READ_PORT_EOP_N: out std_logic;
			READ_PORT_SRC_RDY_N: out std_logic;
			READ_PORT_DATA: out std_logic_vector(31 downto 0);
			register_clk: out std_logic;
			register_in: out std_logic_vector(7 downto 0);
			register_rotate: out std_logic;
			register_stop: out std_logic;
			register_switch: out std_logic
		);
	end component;
	
	-- Signal declarations
	
	signal mappedregistersea_i_from_switch_dst_rdy_n : std_logic_vector(0 downto 0);
	signal mappedregistersea_i_to_switch_sop_n : std_logic_vector(0 downto 0);
	signal mappedregistersea_i_to_switch_eop_n : std_logic_vector(0 downto 0);
	signal mappedregistersea_i_to_switch_src_rdy_n : std_logic_vector(0 downto 0);
	signal mappedregistersea_i_to_switch_data : std_logic_vector(31 downto 0);
	signal mappedregistersea_i_ea_start : std_logic_vector(0 downto 0);
	signal mappedregistersea_i_from_ea_dst_rdy_n : std_logic_vector(0 downto 0);
	signal mappedregistersea_i_to_ea_sop_n : std_logic_vector(0 downto 0);
	signal mappedregistersea_i_to_ea_eop_n : std_logic_vector(0 downto 0);
	signal mappedregistersea_i_to_ea_src_rdy_n : std_logic_vector(0 downto 0);
	signal mappedregistersea_i_to_ea_data : std_logic_vector(31 downto 0);
	signal mappedregistersea_i_base_address : std_logic_vector(23 downto 0);
	signal mappedregistersea_i_reserved_0 : std_logic_vector(5 downto 0);
	signal mappedregistersea_i_w_nr : std_logic_vector(0 downto 0);
	signal mappedregistersea_i_is_response_header : std_logic_vector(0 downto 0);
	signal mappedregistersea_i_last_read_address : std_logic_vector(23 downto 0);
	signal mappedregistersea_i_reserved_1 : std_logic_vector(7 downto 0);
	signal mappedregisterscontrollerexternal_i_controller_finished : std_logic_vector(0 downto 0);
	signal mappedregisterscontrollerexternal_i_write_port_dst_rdy_n : std_logic_vector(0 downto 0);
	signal mappedregisterscontrollerexternal_i_read_port_sop_n : std_logic_vector(0 downto 0);
	signal mappedregisterscontrollerexternal_i_read_port_eop_n : std_logic_vector(0 downto 0);
	signal mappedregisterscontrollerexternal_i_read_port_src_rdy_n : std_logic_vector(0 downto 0);
	signal mappedregisterscontrollerexternal_i_read_port_data : std_logic_vector(31 downto 0);
	signal mappedregisterscontrollerexternal_i_register_clk : std_logic_vector(0 downto 0);
	signal mappedregisterscontrollerexternal_i_register_in : std_logic_vector(7 downto 0);
	signal mappedregisterscontrollerexternal_i_register_rotate : std_logic_vector(0 downto 0);
	signal mappedregisterscontrollerexternal_i_register_stop : std_logic_vector(0 downto 0);
	signal mappedregisterscontrollerexternal_i_register_switch : std_logic_vector(0 downto 0);
	signal mappedregisterscontrollerexternal_i_base_address1 : std_logic_vector(5 downto 0);
	signal mappedregisterscontrollerexternal_i_last_read_address1 : std_logic_vector(5 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	mappedregisterscontrollerexternal_i_base_address1 <= slice(mappedregistersea_i_base_address, 0, 6);
	mappedregisterscontrollerexternal_i_last_read_address1 <= slice(mappedregistersea_i_last_read_address, 0, 6);
	register_clk <= vec_to_bit(mappedregisterscontrollerexternal_i_register_clk);
	register_in <= mappedregisterscontrollerexternal_i_register_in;
	register_rotate <= vec_to_bit(mappedregisterscontrollerexternal_i_register_rotate);
	register_stop <= vec_to_bit(mappedregisterscontrollerexternal_i_register_stop);
	register_switch <= vec_to_bit(mappedregisterscontrollerexternal_i_register_switch);
	FROM_SWITCH_DST_RDY_N <= vec_to_bit(mappedregistersea_i_from_switch_dst_rdy_n);
	TO_SWITCH_SOP_N <= vec_to_bit(mappedregistersea_i_to_switch_sop_n);
	TO_SWITCH_EOP_N <= vec_to_bit(mappedregistersea_i_to_switch_eop_n);
	TO_SWITCH_SRC_RDY_N <= vec_to_bit(mappedregistersea_i_to_switch_src_rdy_n);
	TO_SWITCH_DATA <= mappedregistersea_i_to_switch_data;
	
	-- Register processes
	
	
	-- Entity instances
	
	MappedRegistersEA_i : MappedRegistersEA
		port map (
			FROM_SWITCH_DST_RDY_N => mappedregistersea_i_from_switch_dst_rdy_n(0), -- 1 bits (out)
			TO_SWITCH_SOP_N => mappedregistersea_i_to_switch_sop_n(0), -- 1 bits (out)
			TO_SWITCH_EOP_N => mappedregistersea_i_to_switch_eop_n(0), -- 1 bits (out)
			TO_SWITCH_SRC_RDY_N => mappedregistersea_i_to_switch_src_rdy_n(0), -- 1 bits (out)
			TO_SWITCH_DATA => mappedregistersea_i_to_switch_data, -- 32 bits (out)
			ea_start => mappedregistersea_i_ea_start(0), -- 1 bits (out)
			FROM_EA_DST_RDY_N => mappedregistersea_i_from_ea_dst_rdy_n(0), -- 1 bits (out)
			TO_EA_SOP_N => mappedregistersea_i_to_ea_sop_n(0), -- 1 bits (out)
			TO_EA_EOP_N => mappedregistersea_i_to_ea_eop_n(0), -- 1 bits (out)
			TO_EA_SRC_RDY_N => mappedregistersea_i_to_ea_src_rdy_n(0), -- 1 bits (out)
			TO_EA_DATA => mappedregistersea_i_to_ea_data, -- 32 bits (out)
			base_address => mappedregistersea_i_base_address, -- 24 bits (out)
			reserved_0 => mappedregistersea_i_reserved_0, -- 6 bits (out)
			w_nr => mappedregistersea_i_w_nr(0), -- 1 bits (out)
			is_response_header => mappedregistersea_i_is_response_header(0), -- 1 bits (out)
			last_read_address => mappedregistersea_i_last_read_address, -- 24 bits (out)
			reserved_1 => mappedregistersea_i_reserved_1, -- 8 bits (out)
			clk_switch => clk_switch, -- 1 bits (in)
			rst_switch => rst_switch, -- 1 bits (in)
			FROM_SWITCH_SOP_N => FROM_SWITCH_SOP_N, -- 1 bits (in)
			FROM_SWITCH_EOP_N => FROM_SWITCH_EOP_N, -- 1 bits (in)
			FROM_SWITCH_SRC_RDY_N => FROM_SWITCH_SRC_RDY_N, -- 1 bits (in)
			FROM_SWITCH_DATA => FROM_SWITCH_DATA, -- 32 bits (in)
			TO_SWITCH_DST_RDY_N => TO_SWITCH_DST_RDY_N, -- 1 bits (in)
			ea_finished => vec_to_bit(mappedregisterscontrollerexternal_i_controller_finished), -- 1 bits (in)
			FROM_EA_SOP_N => vec_to_bit(mappedregisterscontrollerexternal_i_read_port_sop_n), -- 1 bits (in)
			FROM_EA_EOP_N => vec_to_bit(mappedregisterscontrollerexternal_i_read_port_eop_n), -- 1 bits (in)
			FROM_EA_SRC_RDY_N => vec_to_bit(mappedregisterscontrollerexternal_i_read_port_src_rdy_n), -- 1 bits (in)
			FROM_EA_DATA => mappedregisterscontrollerexternal_i_read_port_data, -- 32 bits (in)
			TO_EA_DST_RDY_N => vec_to_bit(mappedregisterscontrollerexternal_i_write_port_dst_rdy_n) -- 1 bits (in)
		);
	MappedRegistersControllerExternal_i : mapped_registers_controller
		generic map (
			CHAIN_LENGTH => 50,
			CHAIN_LENGTH_BITS => 6
		)
		port map (
			controller_finished => mappedregisterscontrollerexternal_i_controller_finished(0), -- 1 bits (out)
			WRITE_PORT_DST_RDY_N => mappedregisterscontrollerexternal_i_write_port_dst_rdy_n(0), -- 1 bits (out)
			READ_PORT_SOP_N => mappedregisterscontrollerexternal_i_read_port_sop_n(0), -- 1 bits (out)
			READ_PORT_EOP_N => mappedregisterscontrollerexternal_i_read_port_eop_n(0), -- 1 bits (out)
			READ_PORT_SRC_RDY_N => mappedregisterscontrollerexternal_i_read_port_src_rdy_n(0), -- 1 bits (out)
			READ_PORT_DATA => mappedregisterscontrollerexternal_i_read_port_data, -- 32 bits (out)
			register_clk => mappedregisterscontrollerexternal_i_register_clk(0), -- 1 bits (out)
			register_in => mappedregisterscontrollerexternal_i_register_in, -- 8 bits (out)
			register_rotate => mappedregisterscontrollerexternal_i_register_rotate(0), -- 1 bits (out)
			register_stop => mappedregisterscontrollerexternal_i_register_stop(0), -- 1 bits (out)
			register_switch => mappedregisterscontrollerexternal_i_register_switch(0), -- 1 bits (out)
			clk_registers => clk_switch, -- 1 bits (in)
			rst_registers => rst_switch, -- 1 bits (in)
			switch_registers => switch_registers, -- 1 bits (in)
			controller_start => vec_to_bit(mappedregistersea_i_ea_start), -- 1 bits (in)
			is_write => vec_to_bit(mappedregistersea_i_w_nr), -- 1 bits (in)
			base_address => mappedregisterscontrollerexternal_i_base_address1, -- 6 bits (in)
			last_read_address => mappedregisterscontrollerexternal_i_last_read_address1, -- 6 bits (in)
			WRITE_PORT_SOP_N => vec_to_bit(mappedregistersea_i_to_ea_sop_n), -- 1 bits (in)
			WRITE_PORT_EOP_N => vec_to_bit(mappedregistersea_i_to_ea_eop_n), -- 1 bits (in)
			WRITE_PORT_SRC_RDY_N => vec_to_bit(mappedregistersea_i_to_ea_src_rdy_n), -- 1 bits (in)
			WRITE_PORT_DATA => mappedregistersea_i_to_ea_data, -- 32 bits (in)
			READ_PORT_DST_RDY_N => vec_to_bit(mappedregistersea_i_from_ea_dst_rdy_n), -- 1 bits (in)
			register_out => register_out -- 8 bits (in)
		);
end MaxDC;
