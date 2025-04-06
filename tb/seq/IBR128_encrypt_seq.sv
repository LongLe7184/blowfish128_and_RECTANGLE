import IBR128_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class IBR128_encrypt_seq extends uvm_sequence;
	`uvm_object_utils(IBR128_encrypt_seq)

	function new(string name="IBR128_encrypt_seq");
		super.new(name);
	endfunction

	//Randomize or assign specify value
	bit [127:0] IV = 128'h1111_2222_3333_4444_5555_6666_7777_8888;
	bit [127:0] key = 128'haabb_0918_2736_ccdd_9988_1234_5670_1122;
	bit [127:0] plainText = 128'h1234_56ab_cd13_2536_1234_56ab_cd13_2536;

	virtual task body();
		IBR128_base_item item = IBR128_base_item::type_id::create("item");
		
		//Init IP with IV, key and plainText
		for(int i=0; i<12; i++) begin
			start_item(item);
			item.Addr = i;
			item.Write = 1;
			item.Read = 0;
			if(i<=0 && i<4)
				item.WData = IV[ 32*i +: 32 ];
			if(i<=4 && i<8)
				item.WData = key[ 32*(i-4) +: 32 ];
			if(i<=8 && i<12)
				item.WData = plainText[ 32*(i-8) +: 32 ];
			`uvm_info("SEQ", "Generate new item: ", UVM_LOW)
			item.print();
			finish_item(item);
		end

		//Enable IP with CTRL flags
		start_item(item);
		item.Addr = 5'h10;
		item.Write = 1;
		item.Read = 0;
		item.WData = {26'h0, 1'b1, 2'b01, 1'b1, 1'b0, 1'b1};
		item.print();
		finish_item(item);

		`uvm_info("SEQ", "Exit body", UVM_LOW)
	endtask
endclass
