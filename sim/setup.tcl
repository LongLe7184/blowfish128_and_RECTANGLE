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
vlog -sv -work work +incdir+$RTL_DIR/RECTANGLE $RTL_DIR/RECTANGLE/RECTANGLE128_sbox.sv
vlog -sv -work work +incdir+$RTL_DIR/RECTANGLE $RTL_DIR/RECTANGLE/RECTANGLE128_skeymem.sv
vlog -sv -work work +incdir+$RTL_DIR/RECTANGLE $RTL_DIR/RECTANGLE/RECTANGLE128_skeygen.sv
vlog -sv -work work +incdir+$RTL_DIR/RECTANGLE $RTL_DIR/RECTANGLE/RECTANGLE128_core.sv
vlog -sv -work work +incdir+$RTL_DIR/RECTANGLE $RTL_DIR/RECTANGLE/RECTANGLE128_top.sv

# Blowfish component next
vlog -sv -work work +incdir+$RTL_DIR/blowfish128 $RTL_DIR/blowfish128/blowfish128_DEF.svh
vlog -sv -work work +incdir+$RTL_DIR/blowfish128 $RTL_DIR/blowfish128/blowfish128_sbox.sv
vlog -sv -work work +incdir+$RTL_DIR/blowfish128 $RTL_DIR/blowfish128/blowfish128_ffunc.sv
vlog -sv -work work +incdir+$RTL_DIR/blowfish128 $RTL_DIR/blowfish128/blowfish128_skeygen.sv
vlog -sv -work work +incdir+$RTL_DIR/blowfish128 $RTL_DIR/blowfish128/blowfish128_core.sv
vlog -sv -work work +incdir+$RTL_DIR/blowfish128 $RTL_DIR/blowfish128/blowfish128_top.sv

# Main IBR128 components
vlog -sv -work work +incdir+$RTL_DIR $RTL_DIR/IBR128_adder.sv
vlog -sv -work work +incdir+$RTL_DIR $RTL_DIR/IBR128_opmode.sv
vlog -sv -work work +incdir+$RTL_DIR $RTL_DIR/IBR128_csr.sv
vlog -sv -work work +incdir+$RTL_DIR $RTL_DIR/IBR128_encrypt.sv
vlog -sv -work work +incdir+$RTL_DIR $RTL_DIR/IBR128_core.sv
vlog -sv -work work +incdir+$RTL_DIR $RTL_DIR/IBR128_wrapper.sv

# Compile testbench files in correct order
puts "Compiling testbench files..."

# Compile local pkg
vlog -sv -work work +incdir+$TB_DIR +incdir+$TB_DIR/seq +incdir+$TB_DIR/test +incdir+$TB_DIR/env +incdir+$TB_DIR/env/agent +incdir+$UVM_HOME/src $TB_DIR/IBR128_pkg.sv

# IMPORTANT: First compile the interface and top level testbench which import uvm_pkg
vlog -sv -work work +incdir+$TB_DIR +incdir+$UVM_HOME/src $TB_DIR/IBR128_if.sv
vlog -sv -work work +incdir+$TB_DIR +incdir+$UVM_HOME/src $TB_DIR/IBR128_tb_top.sv

# Compile sequence items and sequences
vlog -sv -work work +incdir+$TB_DIR/seq +incdir+$TB_DIR +incdir+$UVM_HOME/src $TB_DIR/seq/IBR128_base_item.sv
vlog -sv -work work +incdir+$TB_DIR/seq +incdir+$TB_DIR +incdir+$UVM_HOME/src $TB_DIR/seq/IBR128_encrypt_seq.sv

# Compile agent components (assuming they exist - adjust if needed)
set AGENT_DIR "$TB_DIR/env/agent"
if {[file exists $AGENT_DIR]} {
    foreach file [glob -nocomplain "$AGENT_DIR/*.sv"] {
        vlog -sv -work work +incdir+$TB_DIR +incdir+$AGENT_DIR +incdir+$UVM_HOME/src $file
    }
}

# Compile environment components
vlog -sv -work work +incdir+$TB_DIR +incdir+$TB_DIR/env +incdir+$UVM_HOME/src $TB_DIR/env/IBR128_scoreboard.sv
vlog -sv -work work +incdir+$TB_DIR +incdir+$TB_DIR/env +incdir+$UVM_HOME/src $TB_DIR/env/IBR128_env.sv

# Compile test files
vlog -sv -work work +incdir+$TB_DIR +incdir+$TB_DIR/test +incdir+$UVM_HOME/src $TB_DIR/test/IBR128_base_test.sv

# Start simulation
puts "Starting simulation..."
#vlog -sv -dpiheader $UVM_HOME/src/dpi/uvm_dpi.h $UVM_HOME/src/dpi/uvm_dpi.cc
# This should create the necessary shared library
#vsim -sv_lib $UVM_HOME/lib/uvm_dpi -t 1ps -novopt work.IBR128_tb_top +UVM_TESTNAME=IBR128_base_test
#vsim -t 1ps -novopt -uvmhome $UVM_HOME work.IBR128_tb_top +UVM_TESTNAME=IBR128_base_test
vsim -t 1ps -novopt work.IBR128_tb_top +UVM_TESTNAME=IBR128_base_test +UVM_NO_DPI

# Optionally add waveforms
# do wave.do

# Run simulation for a reasonable time
run 5000ns

puts "Simulation complete."
# Exit QuestaSim (comment this out if you want to explore simulation results)
# exit
