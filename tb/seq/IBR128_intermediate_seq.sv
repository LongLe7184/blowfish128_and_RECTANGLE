import IBR128_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class IBR128_intermediate_seq extends uvm_sequence #(IBR128_base_item);
	`uvm_object_utils(IBR128_intermediate_seq)

	function new(string name="IBR128_intermediate_seq");
		super.new(name);
	endfunction

	IBR128_seq_item parent_seq_item;
	bit is_first_sequence;

	virtual task body();
		IBR128_base_item base_item = IBR128_base_item::type_id::create("base_item");

		start_item(base_item);
		base_item.trns_type = CMD_TRANS;
		base_item.Addr = 5'h10;
		base_item.WData = 32'h0;
		base_item.parent_seq_item = parent_seq_item;
		base_item.is_first_of_sequence = is_first_sequence;
		
		`uvm_info("SEQ", "Generated new item", UVM_LOW)
		finish_item(base_item);

		`uvm_info("SEQ", "Exit body", UVM_LOW)
	endtask
endclass
