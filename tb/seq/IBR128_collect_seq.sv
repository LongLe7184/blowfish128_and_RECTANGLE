import IBR128_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class IBR128_collect_seq extends uvm_sequence #(IBR128_base_item);
	`uvm_object_utils(IBR128_collect_seq)

	bit [127:0] IV_data;
	bit [127:0] key_data;
	bit [127:0] plainText_data;

	function new(string name="IBR128_collect_seq");
		super.new(name);
	endfunction

	virtual task body();
		IBR128_base_item base_item = IBR128_base_item::type_id::create("base_item");
		
		//Init IP with IV, key and plainText
		for(int i=12; i<16; i++) begin
			start_item(base_item);
			base_item.Addr = i;
			base_item.trns_type = CIPHERTEXT_TRANS;
			`uvm_info("SEQ", "Generated new item", UVM_LOW)
			finish_item(base_item);
		end

		`uvm_info("SEQ", "Exit body", UVM_LOW)
	endtask
endclass
