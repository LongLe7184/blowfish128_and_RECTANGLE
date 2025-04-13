import IBR128_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class IBR128_init_seq extends uvm_sequence #(IBR128_base_item);
	`uvm_object_utils(IBR128_init_seq)

	bit [127:0] IV_data;
	bit [127:0] key_data;
	bit [127:0] plainText_data;
	int BlockNum;
	IBR128_seq_item parent_seq_item;
	bit is_first_sequence;

	function new(string name="IBR128_init_seq");
		super.new(name);
	endfunction

	virtual task body();
		IBR128_base_item base_item = IBR128_base_item::type_id::create("base_item");
		
		if(BlockNum == 1) begin //Init IV, key, plainText in First Block
			for(int i=0; i<12; i++) begin
				start_item(base_item);
				base_item.Addr = i;
				if(i>=0 && i<4) begin
					base_item.trns_type = IV_TRANS;
					base_item.WData = IV_data[ 32*i +: 32 ];
				end else if(i>=4 && i<8) begin
					base_item.trns_type = KEY_TRANS;
					base_item.WData = key_data[ 32*(i-4) +: 32 ];
				end else if(i>=8 && i<12) begin
					base_item.trns_type = PLAINTEXT_TRANS;
					base_item.WData = plainText_data[ 32*(i-8) +: 32 ];
				end
				base_item.parent_seq_item = parent_seq_item;
				base_item.is_first_of_sequence = (i==0) ? is_first_sequence : 0;
				`uvm_info("SEQ", "Generated new item", UVM_LOW)
				// base_item.print();
				finish_item(base_item);
			end
		end else begin //Start with PlainText from Second Block
			for(int i=8; i<12; i++) begin
				start_item(base_item);
				base_item.Addr = i;
				base_item.trns_type = PLAINTEXT_TRANS;
				base_item.WData = plainText_data[ 32*(i-8) +: 32 ];
				base_item.parent_seq_item = parent_seq_item;
				base_item.is_first_of_sequence = (i==8) ? is_first_sequence : 0;
				`uvm_info("SEQ", "Generated new item", UVM_LOW)
				// base_item.print();
				finish_item(base_item);
			end
		end

		`uvm_info("SEQ", "Exit body", UVM_LOW)
	endtask
endclass
