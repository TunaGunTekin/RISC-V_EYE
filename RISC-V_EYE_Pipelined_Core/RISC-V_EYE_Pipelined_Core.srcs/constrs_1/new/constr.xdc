## Clock Signal
# Zybo Z7-20 üzerindeki 125 MHz saat sinyali (K17 Pini)
set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS33 } [get_ports { clk }]; 
create_clock -add -name sys_clk_pin -period 25.00 -waveform {0 4} [get_ports { clk }];

## Buttons
# Reset sinyali için BTN0 kullanıyoruz (K18 Pini)
set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports { reset }]; 


