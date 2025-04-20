set $TEST_NAME [lindex $argv 0]
puts "Opening waveform..."
vmap work work
vsim -gui -t ps -novopt $TEST_NAME/work.IBR128_tb_top
vsim -view $TEST_NAME/$TEST_NAME.wlf
