#!/bin/bash

# Set the path to ModelSim installation directory
export MODELSIM_DIR=/c/intelFPGA/17.0/modelsim_ase/win32aloem

# Add ModelSim binaries to the PATH
export PATH=$MODELSIM_DIR/bin:$PATH

# Launch ModelSim and running Tcl script (inside ModelSim)
vsim -c -do "
	# Specify the directory containing .sv files
	set directory1 \"./../rtl/blowfish128\"
	set directory2 \"./../rtl/RECTANGLE\"
	set directory3 \"./../rtl\"
	set directory4 \"./../tb\"

	# Get the list of .sv files in the directory
	set file_list1 [glob -nocomplain -directory \$directory1 *.sv]
	set file_list2 [glob -nocomplain -directory \$directory2 *.sv]
	set file_list3 [glob -nocomplain -directory \$directory3 *.sv]
	set file_list4 [glob -nocomplain -directory \$directory4 *.sv]
	
	# Concatenate the list
	set file_list [concat \$file_list1 \$file_list2 \$file_list3 \$file_list4]

	# Print out the list of .sv files
	foreach file \$file_list {
		puts \$file
	}

	# Create the project
	project new . blowfish_and_RECTANGLE

	# Add files to the project
	foreach file \$file_list {
		project addfile \$file
	}

	# Compile the project
	project compileall

	# Exit ModelSim
	exit
"

# Open ModelSim
vsim -gui
