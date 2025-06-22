#!/bin/bash

# Set path to QuestaSim
export QUESTASIM_DIR=/c/questasim64_10.2c/win64/

# Add QuestaSim to PATH
export PATH=$QUESTASIM_DIR:$PATH

# Run QuestaSim with the script
#vsim -c -do setup.tcl
#vsim -c -do setup_v2.tcl
vsim -c -do setup_v3.tcl

# TEST_NAME=IBR128_blowfish_cbc_test
# TEST_NAME=IBR128_blowfish_ofb_test
# TEST_NAME=IBR128_blowfish_ctr_test
# TEST_NAME=IBR128_rectangle_cbc_test
# TEST_NAME=IBR128_rectangle_ofb_test
# TEST_NAME=IBR128_rectangle_ctr_test
TEST_NAME=IBR128_middle_reset_test

# Uncomment to open GUI after compilation
# vsim -gui
# vsim -gui -t ps -novopt work.IBR128_tb_top
# vsim -gui -t ps -novopt $TEST_NAME/work.IBR128_tb_top
