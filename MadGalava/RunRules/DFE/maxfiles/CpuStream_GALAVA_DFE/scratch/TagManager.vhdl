library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity TagManager is
	port (
		streamrst_pcie: in std_logic;
		clk_pcie: in std_logic;
		rst_pcie_n: in std_logic;
		in_write_req_ready: in std_logic;
		in_write_req_last: in std_logic;
		in_write_req_id: in std_logic_vector(31 downto 0);
		in_write_req_len: in std_logic_vector(8 downto 0);
		in_write_req_addr: in std_logic_vector(60 downto 0);
		in_write_req_data: in std_logic_vector(127 downto 0);
		in_write_req_data_valid: in std_logic;
		out_write_req_done: in std_logic;
		out_write_req_data_read: in std_logic;
		in_read_req_ready: in std_logic;
		in_read_req_len: in std_logic_vector(6 downto 0);
		in_read_req_addr: in std_logic_vector(60 downto 0);
		in_read_req_metadata: in std_logic_vector(35 downto 0);
		out_read_req_done: in std_logic;
		in_read_response_data: in std_logic_vector(127 downto 0);
		in_read_response_data_valid: in std_logic_vector(1 downto 0);
		in_read_response_tag: in std_logic_vector(7 downto 0);
		in_read_response_complete: in std_logic;
		in_read_response_ready: in std_logic;
		out_read_response_metadata_free: in std_logic;
		in_write_req_done: out std_logic;
		in_write_req_data_read: out std_logic;
		out_write_req_ready: out std_logic;
		out_write_req_last: out std_logic;
		out_write_req_id: out std_logic_vector(31 downto 0);
		out_write_req_len: out std_logic_vector(8 downto 0);
		out_write_req_addr: out std_logic_vector(60 downto 0);
		out_write_req_tag: out std_logic_vector(7 downto 0);
		out_write_req_data: out std_logic_vector(127 downto 0);
		out_write_req_data_valid: out std_logic;
		in_read_req_done: out std_logic;
		out_read_req_ready: out std_logic;
		out_read_req_len: out std_logic_vector(6 downto 0);
		out_read_req_addr: out std_logic_vector(60 downto 0);
		out_read_req_tag: out std_logic_vector(7 downto 0);
		out_read_response_data_valid: out std_logic_vector(1 downto 0);
		out_read_response_data: out std_logic_vector(127 downto 0);
		out_read_response_metadata: out std_logic_vector(35 downto 0);
		out_read_response_metadata_valid: out std_logic
	);
end TagManager;

architecture MaxDC of TagManager is
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
	component tag_manager is
		generic (
			DATA_BUS_WIDTH : integer;
			DATA_VALID_WIDTH : integer;
			DB_WIDTH : integer;
			MAX_TAG : integer;
			TAG_WIDTH : integer;
			TAG_WRITE_REQUESTS : integer
		);
		port (
			clk_pcie: in std_logic;
			rst_pcie_n: in std_logic;
			streamrst_pcie: in std_logic;
			in_write_req_ready: in std_logic;
			out_write_req_done: in std_logic;
			in_read_req_ready: in std_logic;
			in_read_req_metadata: in std_logic_vector(35 downto 0);
			out_read_req_done: in std_logic;
			in_read_response_data: in std_logic_vector(127 downto 0);
			in_read_response_data_valid: in std_logic_vector(1 downto 0);
			in_read_response_ready: in std_logic;
			in_read_response_tag: in std_logic_vector(4 downto 0);
			out_read_response_metadata_free: in std_logic;
			in_read_response_complete: in std_logic;
			db_decode_data: in std_logic_vector(35 downto 0);
			in_write_req_done: out std_logic;
			out_write_req_ready: out std_logic;
			out_write_req_tag: out std_logic_vector(4 downto 0);
			in_read_req_done: out std_logic;
			out_read_req_ready: out std_logic;
			out_read_req_tag: out std_logic_vector(4 downto 0);
			out_read_response_metadata_valid: out std_logic;
			out_read_response_metadata: out std_logic_vector(35 downto 0);
			out_read_response_data: out std_logic_vector(127 downto 0);
			out_read_response_data_valid: out std_logic_vector(1 downto 0);
			db_assign_addr: out std_logic_vector(4 downto 0);
			db_assign_data: out std_logic_vector(35 downto 0);
			db_assign_write: out std_logic;
			db_decode_addr: out std_logic_vector(4 downto 0)
		);
	end component;
	component AlteraBlockMem_RAM_TWO_PORT_36x512_RAM_TWO_PORT_ireg is
		port (
			wea: in std_logic_vector(0 downto 0);
			addra: in std_logic_vector(8 downto 0);
			dina: in std_logic_vector(35 downto 0);
			clka: in std_logic;
			addrb: in std_logic_vector(8 downto 0);
			doutb: out std_logic_vector(35 downto 0)
		);
	end component;
	
	-- Signal declarations
	
	signal tagmanagerexternal_i_in_write_req_done : std_logic_vector(0 downto 0);
	signal tagmanagerexternal_i_out_write_req_ready : std_logic_vector(0 downto 0);
	signal tagmanagerexternal_i_out_write_req_tag : std_logic_vector(4 downto 0);
	signal tagmanagerexternal_i_in_read_req_done : std_logic_vector(0 downto 0);
	signal tagmanagerexternal_i_out_read_req_ready : std_logic_vector(0 downto 0);
	signal tagmanagerexternal_i_out_read_req_tag : std_logic_vector(4 downto 0);
	signal tagmanagerexternal_i_out_read_response_metadata_valid : std_logic_vector(0 downto 0);
	signal tagmanagerexternal_i_out_read_response_metadata : std_logic_vector(35 downto 0);
	signal tagmanagerexternal_i_out_read_response_data : std_logic_vector(127 downto 0);
	signal tagmanagerexternal_i_out_read_response_data_valid : std_logic_vector(1 downto 0);
	signal tagmanagerexternal_i_db_assign_addr : std_logic_vector(4 downto 0);
	signal tagmanagerexternal_i_db_assign_data : std_logic_vector(35 downto 0);
	signal tagmanagerexternal_i_db_assign_write : std_logic_vector(0 downto 0);
	signal tagmanagerexternal_i_db_decode_addr : std_logic_vector(4 downto 0);
	signal metadata_db_i_doutb : std_logic_vector(35 downto 0);
	signal tagmanagerexternal_i_in_read_response_tag1 : std_logic_vector(4 downto 0);
	signal metadata_db_i_addra1 : std_logic_vector(8 downto 0);
	signal cat_ln161_tagmanager : std_logic_vector(8 downto 0);
	signal metadata_db_i_addrb1 : std_logic_vector(8 downto 0);
	signal cat_ln166_tagmanager : std_logic_vector(8 downto 0);
	signal cat_ln73_tagmanager : std_logic_vector(7 downto 0);
	signal cat_ln102_tagmanager : std_logic_vector(7 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	tagmanagerexternal_i_in_read_response_tag1 <= slice(in_read_response_tag, 0, 5);
	cat_ln161_tagmanager<=("0000" & tagmanagerexternal_i_db_assign_addr);
	metadata_db_i_addra1 <= cat_ln161_tagmanager;
	cat_ln166_tagmanager<=("0000" & tagmanagerexternal_i_db_decode_addr);
	metadata_db_i_addrb1 <= cat_ln166_tagmanager;
	cat_ln73_tagmanager<=("000" & tagmanagerexternal_i_out_write_req_tag);
	cat_ln102_tagmanager<=("000" & tagmanagerexternal_i_out_read_req_tag);
	in_write_req_done <= vec_to_bit(tagmanagerexternal_i_in_write_req_done);
	in_write_req_data_read <= vec_to_bit(bit_to_vec(out_write_req_data_read));
	out_write_req_ready <= vec_to_bit(tagmanagerexternal_i_out_write_req_ready);
	out_write_req_last <= vec_to_bit(bit_to_vec(in_write_req_last));
	out_write_req_id <= in_write_req_id;
	out_write_req_len <= in_write_req_len;
	out_write_req_addr <= in_write_req_addr;
	out_write_req_tag <= cat_ln73_tagmanager;
	out_write_req_data <= in_write_req_data;
	out_write_req_data_valid <= vec_to_bit(bit_to_vec(in_write_req_data_valid));
	in_read_req_done <= vec_to_bit(tagmanagerexternal_i_in_read_req_done);
	out_read_req_ready <= vec_to_bit(tagmanagerexternal_i_out_read_req_ready);
	out_read_req_len <= in_read_req_len;
	out_read_req_addr <= in_read_req_addr;
	out_read_req_tag <= cat_ln102_tagmanager;
	out_read_response_data_valid <= tagmanagerexternal_i_out_read_response_data_valid;
	out_read_response_data <= tagmanagerexternal_i_out_read_response_data;
	out_read_response_metadata <= tagmanagerexternal_i_out_read_response_metadata;
	out_read_response_metadata_valid <= vec_to_bit(tagmanagerexternal_i_out_read_response_metadata_valid);
	
	-- Register processes
	
	
	-- Entity instances
	
	TagManagerExternal_i : tag_manager
		generic map (
			DATA_BUS_WIDTH => 128,
			DATA_VALID_WIDTH => 2,
			DB_WIDTH => 36,
			MAX_TAG => 31,
			TAG_WIDTH => 5,
			TAG_WRITE_REQUESTS => 31
		)
		port map (
			in_write_req_done => tagmanagerexternal_i_in_write_req_done(0), -- 1 bits (out)
			out_write_req_ready => tagmanagerexternal_i_out_write_req_ready(0), -- 1 bits (out)
			out_write_req_tag => tagmanagerexternal_i_out_write_req_tag, -- 5 bits (out)
			in_read_req_done => tagmanagerexternal_i_in_read_req_done(0), -- 1 bits (out)
			out_read_req_ready => tagmanagerexternal_i_out_read_req_ready(0), -- 1 bits (out)
			out_read_req_tag => tagmanagerexternal_i_out_read_req_tag, -- 5 bits (out)
			out_read_response_metadata_valid => tagmanagerexternal_i_out_read_response_metadata_valid(0), -- 1 bits (out)
			out_read_response_metadata => tagmanagerexternal_i_out_read_response_metadata, -- 36 bits (out)
			out_read_response_data => tagmanagerexternal_i_out_read_response_data, -- 128 bits (out)
			out_read_response_data_valid => tagmanagerexternal_i_out_read_response_data_valid, -- 2 bits (out)
			db_assign_addr => tagmanagerexternal_i_db_assign_addr, -- 5 bits (out)
			db_assign_data => tagmanagerexternal_i_db_assign_data, -- 36 bits (out)
			db_assign_write => tagmanagerexternal_i_db_assign_write(0), -- 1 bits (out)
			db_decode_addr => tagmanagerexternal_i_db_decode_addr, -- 5 bits (out)
			clk_pcie => clk_pcie, -- 1 bits (in)
			rst_pcie_n => rst_pcie_n, -- 1 bits (in)
			streamrst_pcie => streamrst_pcie, -- 1 bits (in)
			in_write_req_ready => in_write_req_ready, -- 1 bits (in)
			out_write_req_done => out_write_req_done, -- 1 bits (in)
			in_read_req_ready => in_read_req_ready, -- 1 bits (in)
			in_read_req_metadata => in_read_req_metadata, -- 36 bits (in)
			out_read_req_done => out_read_req_done, -- 1 bits (in)
			in_read_response_data => in_read_response_data, -- 128 bits (in)
			in_read_response_data_valid => in_read_response_data_valid, -- 2 bits (in)
			in_read_response_ready => in_read_response_ready, -- 1 bits (in)
			in_read_response_tag => tagmanagerexternal_i_in_read_response_tag1, -- 5 bits (in)
			out_read_response_metadata_free => out_read_response_metadata_free, -- 1 bits (in)
			in_read_response_complete => in_read_response_complete, -- 1 bits (in)
			db_decode_data => metadata_db_i_doutb -- 36 bits (in)
		);
	metadata_db_i : AlteraBlockMem_RAM_TWO_PORT_36x512_RAM_TWO_PORT_ireg
		port map (
			doutb => metadata_db_i_doutb, -- 36 bits (out)
			wea => tagmanagerexternal_i_db_assign_write, -- 1 bits (in)
			addra => metadata_db_i_addra1, -- 9 bits (in)
			dina => tagmanagerexternal_i_db_assign_data, -- 36 bits (in)
			clka => clk_pcie, -- 1 bits (in)
			addrb => metadata_db_i_addrb1 -- 9 bits (in)
		);
end MaxDC;
