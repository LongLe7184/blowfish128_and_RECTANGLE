import IBR128_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class IBR128_seq_item extends uvm_sequence_item;

	operation Operation;
	algorithm Algorithm;	
	bcom BCOM;
	int BlockNum;
	bit [127:0] IV;
	bit [127:0] Key;
	bit [127:0] PData;
	bit [127:0] EData;

	//UVM factory registration
	`uvm_object_utils_begin(IBR128_seq_item)
		`uvm_field_enum(operation, Operation, UVM_DEFAULT)
		`uvm_field_enum(algorithm, Algorithm, UVM_DEFAULT)
		`uvm_field_enum(bcom, BCOM, UVM_DEFAULT)
		`uvm_field_int(BlockNum, UVM_DEFAULT)
		`uvm_field_int(IV, UVM_DEFAULT)
		`uvm_field_int(PData, UVM_DEFAULT)
		`uvm_field_int(EData, UVM_DEFAULT)
	`uvm_object_utils_end

	//Constructor
	function new(string name = "IBR128_seq_item");
		super.new(name);
	endfunction

endclass
