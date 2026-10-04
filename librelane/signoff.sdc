current_design $::env(DESIGN_NAME)
set clock_port [get_ports clk]
set reset_port [get_ports rst]

set input_ports [get_ports {
    rst
}]

set output_ports [get_ports {
    gpio[*]
}]

puts "\[INFO] Using clock $clock_port @ $::env(CLOCK_PERIOD) ns"
puts "\[INFO] Using reset $reset_port"

create_clock -period $::env(CLOCK_PERIOD) -name sys_clock $clock_port

set_max_fanout 16 [current_design]
set_max_transition 1 [current_design]

set_load 0.05 $output_ports

set_input_transition 4.0 $input_ports
set_input_delay -clock sys_clock 10.0 $input_ports
set_output_delay -clock sys_clock 10.0 $output_ports

set_clock_uncertainty .07 $clock_port

set_propagated_clock sys_clock
