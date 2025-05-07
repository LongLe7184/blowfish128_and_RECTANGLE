set $TEST_NAME [lindex $argv 0]
puts "Opening waveform..."
vmap work work
vsim -gui -t ps -novopt $TEST_NAME/work.IBR128_tb_top

# View .wlf file (first step inside QuestaSim)
vsim -view $TEST_NAME/$TEST_NAME.wlf

# Add saved signals list (second step inside QuestaSim)
do wave.do
# Or add wave manually inside QuestaSim
