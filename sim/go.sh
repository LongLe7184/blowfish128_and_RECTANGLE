#!/bin/bash

# Set path to QuestaSim
export QUESTASIM_DIR=/c/questasim64_10.2c/win64/

# Add QuestaSim to PATH
export PATH=$QUESTASIM_DIR:$PATH

# Run QuestaSim with the script
#vsim -c -do setup.tcl
vsim -c -do setup_v2.tcl

# Uncomment to open GUI after compilation
# vsim -gui
# vsim -gui -t ns -novopt work.IBR128_tb_top
