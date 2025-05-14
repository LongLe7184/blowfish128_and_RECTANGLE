# Test names

# set TEST_NAME "IBR128_rectangle_cbc_test"
# set TEST_NAME "IBR128_rectangle_ofb_test"
# set TEST_NAME "IBR128_rectangle_ctr_test"
# set TEST_NAME "IBR128_blowfish_cbc_test"
# set TEST_NAME "IBR128_blowfish_ofb_test"
set TEST_NAME "IBR128_blowfish_ctr_test"

# Project root directory - adjust if needed
set PROJ_ROOT "D:/designIP/blowfish128_and_RECTANGLE"
set RTL_DIR "$PROJ_ROOT/rtl"
set TB_DIR "$PROJ_ROOT/tb"

# UVM Library path - adjust to your installation
set UVM_HOME "D:/uvm/UVM/1.2"

# Create and map libraries
if {[file exists work]} {
    vdel -lib work -all
}
vlib work
vmap work work

# Map UVM
vmap uvm $UVM_HOME/src

# Compile UVM library (if needed)
puts "Compiling UVM library..."
vlog -sv +incdir+$UVM_HOME/src $UVM_HOME/src/uvm_pkg.sv +define+UVM_CMDLINE_NO_DPI +define+UVM_REGEX_NO_DPI +define+UVM_NO_DPI

# Compile RTL files in correct order
puts "Compiling RTL files..."

# RECTANGLE component first
set RECTANGLE_DESIGN_DIR "$RTL_DIR/RECTANGLE"
if {[file exists $RECTANGLE_DESIGN_DIR]} {
    foreach file [glob -nocomplain $RECTANGLE_DESIGN_DIR/*.svh] {
        vlog -sv -work work +incdir+$RECTANGLE_DESIGN_DIR $file
        puts "\[DEBUG\] Compiled: $file"
    }
    foreach file [glob -nocomplain $RECTANGLE_DESIGN_DIR/*.sv] {
        vlog -sv -work work +incdir+$RECTANGLE_DESIGN_DIR $file
        puts "\[DEBUG\] Compiled: $file"
    }
}

# Blowfish component next
set BLOWFISH_DESIGN_DIR "$RTL_DIR/blowfish128"
if {[file exists $BLOWFISH_DESIGN_DIR]} {
    foreach file [glob -nocomplain $BLOWFISH_DESIGN_DIR/*.svh] {
        vlog -sv -work work +incdir+$BLOWFISH_DESIGN_DIR $file
        puts "\[DEBUG\] Compiled: $file"
    }
    foreach file [glob -nocomplain $BLOWFISH_DESIGN_DIR/*.sv] {
        vlog -sv -work work +incdir+$BLOWFISH_DESIGN_DIR $file
        puts "\[DEBUG\] Compiled: $file"
    }
}

# Main IBR128 components - this is where IBR128_csr.sv and IBR128_core.sv should be
if {[file exists $RTL_DIR]} {
    foreach file [glob -nocomplain $RTL_DIR/*.svh] {
        vlog -sv -work work +incdir+$RTL_DIR $file
        puts "\[DEBUG\] Compiled: $file"
    }
    foreach file [glob -nocomplain $RTL_DIR/*.sv] {
        vlog -sv -work work +incdir+$RTL_DIR $file
        puts "\[DEBUG\] Compiled: $file"
    }
}

# Compile testbench files in correct order
puts "Compiling testbench files..."

# Compile local pkg
vlog -sv -work work +incdir+$TB_DIR +incdir+$TB_DIR/seq +incdir+$TB_DIR/test +incdir+$TB_DIR/env +incdir+$TB_DIR/env/agent +incdir+$TB_DIR/env/model +incdir+$UVM_HOME/src $TB_DIR/IBR128_pkg.sv

# IMPORTANT: First compile the interface and top level testbench which import uvm_pkg
if {[file exists $TB_DIR]} {
    foreach file [glob -nocomplain $TB_DIR/*.sv] {
        if {[file tail $file] != "IBR128_pkg.sv"} {
            vlog -sv -work work +incdir+$TB_DIR +incdir+$UVM_HOME/src $file
        }
    }
}

# Compile sequence items and sequences
set SEQ_DIR "$TB_DIR/seq"
if {[file exists $SEQ_DIR]} {
    foreach file [glob -nocomplain $SEQ_DIR/*.sv] {
        vlog -sv -work work +incdir+$TB_DIR +incdir+$SEQ_DIR +incdir+$UVM_HOME/src $file
    }
}

# Compile agent components
set AGENT_DIR "$TB_DIR/env/agent"
if {[file exists $AGENT_DIR]} {
    foreach file [glob -nocomplain $AGENT_DIR/*.sv] {
        vlog -sv -work work +incdir+$TB_DIR +incdir+$AGENT_DIR +incdir+$UVM_HOME/src $file
    }
}

# Compile environment components
set ENV_DIR "$TB_DIR/env"
if {[file exists $ENV_DIR]} {
    foreach file [glob -nocomplain $ENV_DIR/*.sv] {
        vlog -sv -work work +incdir+$TB_DIR +incdir+$ENV_DIR +incdir+$UVM_HOME/src $file
    }
}

# Compile test files
set TEST_DIR "$TB_DIR/test"
if {[file exists $TEST_DIR]} {
    foreach file [glob -nocomplain $TEST_DIR/*.sv] {
        vlog -sv -work work +incdir+$TB_DIR +incdir+$TEST_DIR +incdir+$UVM_HOME/src $file
    }
}

# Start simulation
puts "Starting simulation..."
vsim -t 1ps -novopt work.IBR128_tb_top +UVM_TESTNAME=$TEST_NAME +UVM_NO_DPI

# Run simulation for a reasonable time
run -all

puts "Simulation complete."
