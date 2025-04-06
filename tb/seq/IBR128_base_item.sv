`include "uvm_macros.svh"
import uvm_pkg::*;

class IBR128_base_item extends uvm_sequence_item;
	bit CS;
	bit [4:0] Addr;
	bit Write;
	bit Read;
	bit [31:0] WData;
	bit [31:0] RData;

	//UVM factory registration
	`uvm_object_utils_begin(IBR128_base_item)
		`uvm_field_int(CS, UVM_DEFAULT)
		`uvm_field_int(Addr, UVM_DEFAULT)
		`uvm_field_int(Write, UVM_DEFAULT)
		`uvm_field_int(Read, UVM_DEFAULT)
		`uvm_field_int(WData, UVM_DEFAULT)
		`uvm_field_int(RData, UVM_DEFAULT)
	`uvm_object_utils_end

	//Constructor
	function new(string name = "IBR128_base_item");
		super.new(name);
	endfunction

	//toString function
	virtual function string toString();
		return $sformatf("cs=0x%0h addr=0x%0h wr=0x%0h rd=0x%0h wdata=0x%0h rdata=0x%0h", CS, Addr, Write, Read, WData, RData);
	endfunction

endclass
