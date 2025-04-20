import IBR128_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class IBR128_blowfish_ctr_seq extends uvm_sequence #(IBR128_base_item);
	`uvm_object_utils(IBR128_blowfish_ctr_seq)

	//Randomize or assign specify value
	int BlockNum; //-> Nth Block
	const bit [127:0] IV_data = 128'h1111_2222_3333_4444_5555_6666_7777_8888;
	const bit [127:0] key_data = 128'haabb_0918_2736_ccdd_9988_1234_5670_1122;
	// bit [127:0] plainText_data = 128'h1234_56ab_cd13_2536_1234_56ab_cd13_2536;
	rand bit [127:0] plainText_data;
	operation Op;
	algorithm Al = BLOWFISH;
	bcom bcOpMode = CTR;

	IBR128_init_seq init_seq;
	IBR128_cmd_seq cmd_seq;
	IBR128_status_seq status_seq;
	IBR128_collect_seq collect_seq;
	IBR128_intermediate_seq intermediate_seq;

	function new(string name="IBR128_blowfish_ctr_seq");
		super.new(name);
	endfunction

	virtual task body();
		IBR128_seq_item seq_item = IBR128_seq_item::type_id::create("seq_item");

		seq_item.Operation = Op;
		seq_item.Algorithm = Al;
		seq_item.BCOM = bcOpMode;
		seq_item.BlockNum = BlockNum;
		seq_item.Key = key_data;
		seq_item.IV = IV_data;
		seq_item.PData = plainText_data;
		seq_item.EData = 128'h0;
		if(BlockNum == 1) begin
			seq_item.CarryData = 0; //=0 if BlockNum is 1, and =CarryData(from Scoreboard) if BlockNum>1
		end else begin
			seq_item.CarryData = get_scorboard_carry_data();
		end

		//Init IP with IV, Key, PData
		init_seq = IBR128_init_seq::type_id::create("init_seq");
		init_seq.IV_data = IV_data;
		init_seq.key_data = key_data;
		init_seq.plainText_data = plainText_data;
		init_seq.BlockNum = BlockNum;
		init_seq.parent_seq_item = seq_item;
		init_seq.is_first_sequence = 1;
		init_seq.start(m_sequencer);

		//Enable IP
		cmd_seq = IBR128_cmd_seq::type_id::create("cmd_seq");
		cmd_seq.BlockNum = BlockNum;
		cmd_seq.Op = Op;
		cmd_seq.Al = Al;
		cmd_seq.bcOpMode = bcOpMode;
		cmd_seq.parent_seq_item = seq_item;
		cmd_seq.is_first_sequence = 0;
		cmd_seq.start(m_sequencer);

		//Check IP status
		status_seq = IBR128_status_seq::type_id::create("status_seq");
		status_seq.parent_seq_item = seq_item;
		status_seq.is_first_sequence = 0;
		status_seq.start(m_sequencer);

		//Collect output
		collect_seq = IBR128_collect_seq::type_id::create("collect_seq");
		collect_seq.parent_seq_item = seq_item;
		collect_seq.is_first_sequence = 0;
		collect_seq.start(m_sequencer);

		//De-assert Enable (Going to next Block)
		intermediate_seq = IBR128_intermediate_seq::type_id::create("intermediate_seq");
		intermediate_seq.parent_seq_item = seq_item;
		intermediate_seq.is_first_sequence = 0;
		intermediate_seq.start(m_sequencer);

		`uvm_info("SEQ", "Exit body", UVM_LOW)
	endtask

	function bit [127:0] get_scorboard_carry_data();
		IBR128_scoreboard scb;
		// Find the scoreboard in the UVM component hierarchy
		if (!$cast(scb, uvm_top.find("uvm_test_top.env.scoreboard"))) begin
			`uvm_error("SEQ", "Failed to find scoreboard in hierarchy")
			return 128'h0;
		end

		return scb.CarryData;	
	endfunction

endclass
