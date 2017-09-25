create_clock -period "50 MHz" [get_ports clock]
create_clock -period 1000 [get_ports {key[0]}]
create_clock -period 1000 [get_nets {key[0]~inputclkctrl}]
create_clock -period "1 MHz" [get_nets {counter[24]~clkctrl}]

#derive_clock_uncertainty
#create_generated_clock -name {clk} -divide_by 2 -source [get_ports {MAX10_CLK1_50}] [get_registers {sm_top:sm_top|sm_clk_divider:sm_clk_divider|sm_register_we:r_cntr|q[*]}]

#set_false_path -from [get_ports {key[0]}] -to [get_nets {key[0]~inputclkctrl}]

set_false_path -from [get_ports {key[*]}] -to [all_clocks]
#set_false_path -from [get_ports {sw[*]}] -to [all_clocks]

set_false_path -from * -to [get_ports {led[*]}]
#set_false_path -from * -to [get_ports {hex*[*]}]
