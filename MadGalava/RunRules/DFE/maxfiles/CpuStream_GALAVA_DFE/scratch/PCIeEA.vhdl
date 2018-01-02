library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity PCIeEA is
	port (
		clk_switch: in std_logic;
		rst_switch: in std_logic;
		FROM_SWITCH_SOP_N: in std_logic;
		FROM_SWITCH_EOP_N: in std_logic;
		FROM_SWITCH_SRC_RDY_N: in std_logic;
		FROM_SWITCH_DATA: in std_logic_vector(31 downto 0);
		TO_SWITCH_DST_RDY_N: in std_logic;
		clk_pcie: in std_logic;
		rst_pcie_n: in std_logic;
		pcie_ea_read: in std_logic;
		pcie_ea_data_in: in std_logic_vector(31 downto 0);
		pcie_ea_fc_in: in std_logic_vector(1 downto 0);
		pcie_ea_write: in std_logic;
		pcie_ea_select_dma: in std_logic;
		pcie_ea_reset: in std_logic;
		reset_ext: in std_logic;
		dma_from_host_data: in std_logic_vector(33 downto 0);
		dma_from_host_empty: in std_logic;
		FROM_SWITCH_DST_RDY_N: out std_logic;
		TO_SWITCH_SOP_N: out std_logic;
		TO_SWITCH_EOP_N: out std_logic;
		TO_SWITCH_SRC_RDY_N: out std_logic;
		TO_SWITCH_DATA: out std_logic_vector(31 downto 0);
		pcie_ea_version: out std_logic_vector(31 downto 0);
		pcie_ea_empty: out std_logic;
		pcie_ea_fc_type: out std_logic_vector(1 downto 0);
		pcie_ea_toggle: out std_logic;
		pcie_ea_data: out std_logic_vector(31 downto 0);
		pcie_ea_fill: out std_logic_vector(9 downto 0);
		user_control_rst_user: out std_logic;
		dma_from_host_rd_clk: out std_logic;
		dma_from_host_rd_rst: out std_logic;
		dma_from_host_rd_en: out std_logic
	);
end PCIeEA;

architecture MaxDC of PCIeEA is
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
	component AlteraFifoEntity_34_512_34_dualclock_aclr_wrusedw_pfv495 is
		port (
			wr_clk: in std_logic;
			rd_clk: in std_logic;
			din: in std_logic_vector(33 downto 0);
			wr_en: in std_logic;
			rd_en: in std_logic;
			rst: in std_logic;
			dout: out std_logic_vector(33 downto 0);
			full: out std_logic;
			empty: out std_logic;
			wr_data_count: out std_logic_vector(8 downto 0);
			prog_full: out std_logic
		);
	end component;
	component AlteraFifoEntity_34_512_34_dualclock_aclr_wrusedw_fwft_pfv383 is
		port (
			wr_clk: in std_logic;
			rd_clk: in std_logic;
			din: in std_logic_vector(33 downto 0);
			wr_en: in std_logic;
			rd_en: in std_logic;
			rst: in std_logic;
			dout: out std_logic_vector(33 downto 0);
			full: out std_logic;
			empty: out std_logic;
			wr_data_count: out std_logic_vector(8 downto 0);
			prog_full: out std_logic
		);
	end component;
	component vhdl_input_synchronized_bus_synchronizer is
		generic (
			width : integer;
			reset_value : integer;
			IS_VIRTEX6 : boolean
		);
		port (
			in_clk: in std_logic;
			in_rst: in std_logic;
			dat_i: in std_logic_vector(width-1 downto 0);
			out_clk: in std_logic;
			out_rst: in std_logic;
			dat_o: out std_logic_vector(width-1 downto 0)
		);
	end component;
	
	-- Signal declarations
	
	signal fifo_to_host_dout : std_logic_vector(33 downto 0);
	signal fifo_to_host_full : std_logic_vector(0 downto 0);
	signal fifo_to_host_empty : std_logic_vector(0 downto 0);
	signal fifo_to_host_wr_data_count : std_logic_vector(8 downto 0);
	signal fifo_to_host_prog_full : std_logic_vector(0 downto 0);
	signal slave_from_host_fifo_dout : std_logic_vector(33 downto 0);
	signal slave_from_host_fifo_full : std_logic_vector(0 downto 0);
	signal slave_from_host_fifo_empty : std_logic_vector(0 downto 0);
	signal slave_from_host_fifo_wr_data_count : std_logic_vector(8 downto 0);
	signal slave_from_host_fifo_prog_full : std_logic_vector(0 downto 0);
	signal inst_ln12_inputsynchronisedsynchroniser_dat_o : std_logic_vector(0 downto 0);
	signal reg_ln64_pcieea : std_logic_vector(33 downto 0) := "0000000000000000000000000000000000";
	signal cat_ln64_pcieea : std_logic_vector(33 downto 0);
	signal reg_ln63_pcieea : std_logic_vector(0 downto 0) := "0";
	signal reg_ln59_pcieea : std_logic_vector(0 downto 0) := "0";
	signal data_in_r : std_logic_vector(33 downto 0) := "0000000000000000000000000000000000";
	signal cat_ln113_pcieea : std_logic_vector(33 downto 0);
	signal write_r : std_logic_vector(0 downto 0) := "0";
	signal slave_from_host_fifo_rd_en1 : std_logic_vector(0 downto 0);
	signal muxsrc_ln118_pcieea1 : std_logic_vector(0 downto 0);
	signal muxsrc_ln134_pcieea1 : std_logic_vector(0 downto 0);
	signal muxsel_sop_mux1 : std_logic_vector(0 downto 0);
	signal muxout_sop_mux : std_logic_vector(0 downto 0);
	signal muxsrc_ln119_pcieea1 : std_logic_vector(0 downto 0);
	signal muxsrc_ln135_pcieea1 : std_logic_vector(0 downto 0);
	signal muxsel_eop_mux1 : std_logic_vector(0 downto 0);
	signal muxout_eop_mux : std_logic_vector(0 downto 0);
	signal muxsel_src_rdy_mux1 : std_logic_vector(0 downto 0);
	signal muxout_src_rdy_mux : std_logic_vector(0 downto 0);
	signal muxsrc_ln117_pcieea1 : std_logic_vector(31 downto 0);
	signal muxsrc_ln133_pcieea1 : std_logic_vector(31 downto 0);
	signal muxsel_data_mux1 : std_logic_vector(0 downto 0);
	signal muxout_data_mux : std_logic_vector(31 downto 0);
	signal cat_ln40_pcieea : std_logic_vector(31 downto 0);
	signal reg_ln76_pcieea : std_logic_vector(0 downto 0) := "0";
	signal fill_r : std_logic_vector(9 downto 0) := "0000000000";
	signal cat_ln111_pcieea : std_logic_vector(9 downto 0);
	
	-- Attribute type declarations
	
	
	-- Attribute declarations
	
begin
	
	-- Assignments
	
	cat_ln64_pcieea<=(bit_to_vec(FROM_SWITCH_EOP_N) & bit_to_vec(FROM_SWITCH_SOP_N) & FROM_SWITCH_DATA);
	cat_ln113_pcieea<=(pcie_ea_fc_in & pcie_ea_data_in);
	slave_from_host_fifo_rd_en1 <= (not (bit_to_vec(TO_SWITCH_DST_RDY_N) or slave_from_host_fifo_empty));
	muxsrc_ln118_pcieea1 <= slice(slave_from_host_fifo_dout, 32, 1);
	muxsrc_ln134_pcieea1 <= slice(dma_from_host_data, 32, 1);
	muxsel_sop_mux1 <= inst_ln12_inputsynchronisedsynchroniser_dat_o;
	muxproc_sop_mux : process(muxsrc_ln118_pcieea1, muxsrc_ln134_pcieea1, muxsel_sop_mux1)
	begin
		case muxsel_sop_mux1 is
			when "0" => muxout_sop_mux <= muxsrc_ln118_pcieea1;
			when "1" => muxout_sop_mux <= muxsrc_ln134_pcieea1;
			when others => 
			muxout_sop_mux <= (others => 'X');
		end case;
	end process;
	muxsrc_ln119_pcieea1 <= slice(slave_from_host_fifo_dout, 33, 1);
	muxsrc_ln135_pcieea1 <= slice(dma_from_host_data, 33, 1);
	muxsel_eop_mux1 <= inst_ln12_inputsynchronisedsynchroniser_dat_o;
	muxproc_eop_mux : process(muxsrc_ln119_pcieea1, muxsrc_ln135_pcieea1, muxsel_eop_mux1)
	begin
		case muxsel_eop_mux1 is
			when "0" => muxout_eop_mux <= muxsrc_ln119_pcieea1;
			when "1" => muxout_eop_mux <= muxsrc_ln135_pcieea1;
			when others => 
			muxout_eop_mux <= (others => 'X');
		end case;
	end process;
	muxsel_src_rdy_mux1 <= inst_ln12_inputsynchronisedsynchroniser_dat_o;
	muxproc_src_rdy_mux : process(slave_from_host_fifo_empty, dma_from_host_empty, muxsel_src_rdy_mux1)
	begin
		case muxsel_src_rdy_mux1 is
			when "0" => muxout_src_rdy_mux <= slave_from_host_fifo_empty;
			when "1" => muxout_src_rdy_mux <= bit_to_vec(dma_from_host_empty);
			when others => 
			muxout_src_rdy_mux <= (others => 'X');
		end case;
	end process;
	muxsrc_ln117_pcieea1 <= slice(slave_from_host_fifo_dout, 0, 32);
	muxsrc_ln133_pcieea1 <= slice(dma_from_host_data, 0, 32);
	muxsel_data_mux1 <= inst_ln12_inputsynchronisedsynchroniser_dat_o;
	muxproc_data_mux : process(muxsrc_ln117_pcieea1, muxsrc_ln133_pcieea1, muxsel_data_mux1)
	begin
		case muxsel_data_mux1 is
			when "0" => muxout_data_mux <= muxsrc_ln117_pcieea1;
			when "1" => muxout_data_mux <= muxsrc_ln133_pcieea1;
			when others => 
			muxout_data_mux <= (others => 'X');
		end case;
	end process;
	cat_ln40_pcieea<=("0011000100111100" & "0000000000000010");
	cat_ln111_pcieea<=(slave_from_host_fifo_prog_full & slave_from_host_fifo_wr_data_count);
	FROM_SWITCH_DST_RDY_N <= vec_to_bit(reg_ln59_pcieea);
	TO_SWITCH_SOP_N <= vec_to_bit(muxout_sop_mux);
	TO_SWITCH_EOP_N <= vec_to_bit(muxout_eop_mux);
	TO_SWITCH_SRC_RDY_N <= vec_to_bit(muxout_src_rdy_mux);
	TO_SWITCH_DATA <= muxout_data_mux;
	pcie_ea_version <= cat_ln40_pcieea;
	pcie_ea_empty <= vec_to_bit(fifo_to_host_empty);
	pcie_ea_fc_type <= slice(fifo_to_host_dout, 32, 2);
	pcie_ea_toggle <= vec_to_bit(reg_ln76_pcieea);
	pcie_ea_data <= slice(fifo_to_host_dout, 0, 32);
	pcie_ea_fill <= fill_r;
	user_control_rst_user <= vec_to_bit((bit_to_vec(pcie_ea_reset) or bit_to_vec(reset_ext)));
	dma_from_host_rd_clk <= vec_to_bit(bit_to_vec(clk_switch));
	dma_from_host_rd_rst <= vec_to_bit(bit_to_vec(pcie_ea_reset));
	dma_from_host_rd_en <= vec_to_bit((not (bit_to_vec(TO_SWITCH_DST_RDY_N) or bit_to_vec(dma_from_host_empty))));
	
	-- Register processes
	
	reg_process : process(clk_switch)
	begin
		if rising_edge(clk_switch) then
			reg_ln64_pcieea <= cat_ln64_pcieea;
			reg_ln63_pcieea <= (not (bit_to_vec(FROM_SWITCH_SRC_RDY_N) or reg_ln59_pcieea));
			reg_ln59_pcieea <= fifo_to_host_prog_full;
		end if;
	end process;
	reg_process1 : process(clk_pcie)
	begin
		if rising_edge(clk_pcie) then
			data_in_r <= cat_ln113_pcieea;
			if slv_to_slv(bit_to_vec(pcie_ea_reset)) = "1" then
				write_r <= "0";
			else
				write_r <= bit_to_vec(pcie_ea_write);
			end if;
			if slv_to_slv(bit_to_vec(pcie_ea_reset)) = "1" then
				reg_ln76_pcieea <= "0";
			else
				if slv_to_slv(((not fifo_to_host_empty) and bit_to_vec(pcie_ea_read))) = "1" then
					reg_ln76_pcieea <= (not reg_ln76_pcieea);
				end if;
			end if;
			fill_r <= cat_ln111_pcieea;
		end if;
	end process;
	
	-- Entity instances
	
	fifo_to_host : AlteraFifoEntity_34_512_34_dualclock_aclr_wrusedw_pfv495
		port map (
			dout => fifo_to_host_dout, -- 34 bits (out)
			full => fifo_to_host_full(0), -- 1 bits (out)
			empty => fifo_to_host_empty(0), -- 1 bits (out)
			wr_data_count => fifo_to_host_wr_data_count, -- 9 bits (out)
			prog_full => fifo_to_host_prog_full(0), -- 1 bits (out)
			wr_clk => clk_switch, -- 1 bits (in)
			rd_clk => clk_pcie, -- 1 bits (in)
			din => reg_ln64_pcieea, -- 34 bits (in)
			wr_en => vec_to_bit(reg_ln63_pcieea), -- 1 bits (in)
			rd_en => pcie_ea_read, -- 1 bits (in)
			rst => pcie_ea_reset -- 1 bits (in)
		);
	slave_from_host_fifo : AlteraFifoEntity_34_512_34_dualclock_aclr_wrusedw_fwft_pfv383
		port map (
			dout => slave_from_host_fifo_dout, -- 34 bits (out)
			full => slave_from_host_fifo_full(0), -- 1 bits (out)
			empty => slave_from_host_fifo_empty(0), -- 1 bits (out)
			wr_data_count => slave_from_host_fifo_wr_data_count, -- 9 bits (out)
			prog_full => slave_from_host_fifo_prog_full(0), -- 1 bits (out)
			wr_clk => clk_pcie, -- 1 bits (in)
			rd_clk => clk_switch, -- 1 bits (in)
			din => data_in_r, -- 34 bits (in)
			wr_en => vec_to_bit(write_r), -- 1 bits (in)
			rd_en => vec_to_bit(slave_from_host_fifo_rd_en1), -- 1 bits (in)
			rst => pcie_ea_reset -- 1 bits (in)
		);
	inst_ln12_inputsynchronisedsynchroniser : vhdl_input_synchronized_bus_synchronizer
		generic map (
			width => 1,
			reset_value => 0,
			IS_VIRTEX6 => false
		)
		port map (
			dat_o => inst_ln12_inputsynchronisedsynchroniser_dat_o, -- 1 bits (out)
			in_clk => clk_pcie, -- 1 bits (in)
			in_rst => vec_to_bit("0"), -- 1 bits (in)
			dat_i => bit_to_vec(pcie_ea_select_dma), -- 1 bits (in)
			out_clk => clk_switch, -- 1 bits (in)
			out_rst => vec_to_bit("0") -- 1 bits (in)
		);
end MaxDC;
