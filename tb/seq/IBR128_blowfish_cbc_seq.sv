import IBR128_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class IBR128_blowfish_cbc_seq extends uvm_sequence #(IBR128_base_item);
	`uvm_object_utils(IBR128_blowfish_cbc_seq)

	//Randomize or assign specify value
	int BlockNum = 1; //-> First Block
	bit [127:0] IV_data = 128'h1111_2222_3333_4444_5555_6666_7777_8888;
	bit [127:0] key_data = 128'haabb_0918_2736_ccdd_9988_1234_5670_1122;
	bit [127:0] plainText_data = 128'h1234_56ab_cd13_2536_1234_56ab_cd13_2536;
	operation Op = ENCRYPT;
	algorithm Al = BLOWFISH;
	bcom bcOpMode = CBC;

	IBR128_init_seq init_seq;
	IBR128_cmd_seq cmd_seq;

	function new(string name="IBR128_blowfish_cbc_seq");
		super.new(name);
	endfunction

	virtual task body();
		IBR128_seq_item seq_item = IBR128_seq_item::type_id::create("seq_item");

		seq_item.Operation = ENCRYPT;
		seq_item.Algorithm = BLOWFISH;
		seq_item.BCOM = CBC;
		seq_item.BlockNum = BlockNum;
		seq_item.Key = key_data;
		seq_item.IV = IV_data;
		seq_item.PData = plainText_data;
		seq_item.EData = 128'h0;
		seq_item.print();

		init_seq = IBR128_init_seq::type_id::create("init_seq");
		init_seq.IV_data = IV_data;
		init_seq.key_data = key_data;
		init_seq.plainText_data = plainText_data;
		init_seq.start(m_sequencer);

		cmd_seq = IBR128_cmd_seq::type_id::create("cmd_seq");
		cmd_seq.BlockNum = BlockNum;
		cmd_seq.Op = Op;
		cmd_seq.Al = Al;
		cmd_seq.bcOpMode = bcOpMode;
		cmd_seq.start(m_sequencer);

		`uvm_info("SEQ", "Exit body", UVM_LOW)
	endtask
endclass
