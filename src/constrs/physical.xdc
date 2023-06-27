# clock 
set_property IOSTANDARD  LVCMOS33 [get_ports ext_clk_in]
set_property PACKAGE_PIN AG21     [get_ports ext_clk_in]

#------------------ LED------------#
set_property IOSTANDARD  LVCMOS33 [get_ports {fpga_led[*]}]
set_property PACKAGE_PIN AC23     [get_ports {fpga_led[2]}]
set_property PACKAGE_PIN AH23     [get_ports {fpga_led[1]}]
set_property PACKAGE_PIN AF24     [get_ports {fpga_led[0]}]