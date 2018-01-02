create_clock -period "100MHz" -name {refclk_pci_express} {pcie_ref_clk}
create_clock -period 20.00 cclk
create_clock -period "250 MHz" -name {maxring_refclk} {maxring_refclk}
create_clock -name STREAM_clkout0 -period "100.0 MHz" [get_pins -compatibility_mode {STREAM0*altera_pll*general[0]*|divclk}]
create_clock -name STREAM_clkout_inv0 -period "100.0 MHz" [get_pins -compatibility_mode {STREAM0*altera_pll*general[1]*|divclk}]
create_clock -name pcie_coreclkout -period "250 MHz" [get_pins -hierarchical {*stratixv_hssi_gen3_pcie_hip*coreclkout}]
derive_pll_clocks -create_base_clocks
derive_clock_uncertainty
set_false_path -to [get_registers {*|perf_monitor:*perfmonitorext|mem_data_addr*[*]}]
set_clock_groups -asynchronous -group {refclk_pci_express}
set_false_path -to [get_registers {*busy_altgxb_reconfig_r[0]}]
set_max_delay -to [get_registers {*|*synchroniser_prim:*:sync_level_src|dff_ce_asyncsr:\g_slice_packing:0:i_sync0|lpm_ff:dff|dffs[0]}] 8
set_false_path -to [get_registers {*SanityBlock*}]
set_false_path -from [get_ports sys_rst_n]
set_false_path -from [get_ports pcie_pin_perst]
set_clock_groups -asynchronous -group {cclk}
set_clock_groups -asynchronous -group {maxring_refclk}
set_clock_groups -asynchronous -group {STREAM_clkout0}
set_clock_groups -asynchronous -group {STREAM_clkout_inv0}
set_clock_groups -asynchronous -group {pcie_coreclkout}
set_false_path -from {StratixPCIeBase:PCIeBase_i|StratixVHardIPPCIe:StratixVHardIPPCIe_i|*reset_status}
set_output_delay -clock cclk -max [expr 0.50 - (-0.50) + 5.00] [get_ports {flash_data[*]}]
set_output_delay -clock cclk -min [expr 0.50 -  0.50   - 0.00] [get_ports {flash_data[*]}]
set_output_delay -clock cclk -max [expr 0.50 - (-0.50) + 5.00] [get_ports {fpga_config_fpp_data[*]}]
set_output_delay -clock cclk -min [expr 0.50 -  0.50   - 0.00] [get_ports {fpga_config_fpp_data[*]}]
set_output_delay -clock cclk -max [expr 0.50 - (-0.50) + 5.00] [get_ports {to_flash_valid}]
set_output_delay -clock cclk -min [expr 0.50 -  0.50   - 0.00] [get_ports {to_flash_valid}]
set_output_delay -clock cclk -max [expr 0.50 - (-0.50) + 5.00] [get_ports {sda_out}]
set_output_delay -clock cclk -min [expr 0.50 -  0.50   - 0.00] [get_ports {sda_out}]
set_input_delay -clock cclk -max [expr 0.50 - (-0.50) + 15.00] [get_ports {flash_data[*]}]
set_input_delay -clock cclk -min [expr 0.50 -   0.50  + 2.00] [get_ports {flash_data[*]}]
set_input_delay -clock cclk -max [expr 0.50 - (-0.50) + 15.00] [get_ports {fpga_config_fpp_data[*]}]
set_input_delay -clock cclk -min [expr 0.50 -   0.50  + 2.00] [get_ports {fpga_config_fpp_data[*]}]
set_input_delay -clock cclk -max [expr 0.50 - (-0.50) + 15.00] [get_ports {from_flash_valid}]
set_input_delay -clock cclk -min [expr 0.50 -   0.50  + 2.00] [get_ports {from_flash_valid}]
set_input_delay -clock cclk -max [expr 0.50 - (-0.50) + 15.00] [get_ports {sda_in}]
set_input_delay -clock cclk -min [expr 0.50 -   0.50  + 2.00] [get_ports {sda_in}]
set_input_delay -clock cclk -max [expr 0.50 - (-0.50) + 15.00] [get_ports {ssync_in}]
set_input_delay -clock cclk -min [expr 0.50 -   0.50  + 2.00] [get_ports {ssync_in}]
