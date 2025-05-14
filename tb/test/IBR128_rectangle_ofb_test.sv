import IBR128_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

//Undefine SEQ_LENGTH (since other test can be compiled first)
`undef SEQ_LENGTH
`define SEQ_LENGTH 200

class IBR128_rectangle_ofb_test extends IBR128_base_test;
	`uvm_component_utils(IBR128_rectangle_ofb_test)

	function new(string name="IBR128_rectangle_ofb_test", uvm_component parent=null);
		super.new(name, parent);
		seq_length = `SEQ_LENGTH;
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
	endfunction
	
	task run_phase(uvm_phase phase);

		IBR128_scoreboard scb;
		if (!$cast(scb, uvm_top.find("uvm_test_top.env.scoreboard"))) begin
			`uvm_error("TEST", "Failed to find scoreboard")
			return;
		end

		phase.raise_objection(this);

		`uvm_info("TEST_PHASE", $sformatf("Entering Encrypting Test Phase with %d Block", `SEQ_LENGTH), UVM_LOW)

		//Encrypting
		apply_resetN();

		for(int i=0; i < `SEQ_LENGTH; i++) begin
			IBR128_rectangle_ofb_seq seq1 = IBR128_rectangle_ofb_seq::type_id::create($sformatf("seq1_%0d", i));
			seq1.BlockNum = i+1;
			seq1.Op = ENCRYPT;

			if(!seq1.randomize()) begin
				`uvm_error("TEST", "Sequence randomization failed")
			end

			`uvm_info("TEST", $sformatf("Starting Encrypting sequence iteration %0d", i+1), UVM_LOW)
			seq1.start(env.agent.sqcr);

			// wait_for_scoreboard_done();
			wait_for_scoreboard_done(scb);
		end

		`uvm_info("TEST_PHASE", $sformatf("Entering Decrypting Test Phase with %d Block", scb.eBlock.size()), UVM_LOW)

		//Decrypting
		apply_resetN();
		
		if(scb.eBlock.size() != `SEQ_LENGTH)
			`uvm_error("TEST", "EBlock queue size is not compatible!")

		for(int i=0; i < `SEQ_LENGTH; i++) begin
			IBR128_rectangle_ofb_seq seq2 = IBR128_rectangle_ofb_seq::type_id::create($sformatf("seq2_%0d", i));
			seq2.BlockNum = i+1;
			seq2.Op = ENCRYPT;

			if(!seq2.randomize() with {seq2.plainText_data == scb.eBlock[i];}) begin
				`uvm_error("TEST", "Sequence randomization failed")
			end

			`uvm_info("TEST", $sformatf("Starting Decrypting sequence iteration %0d", i+1), UVM_LOW)
			seq2.start(env.agent.sqcr);

			wait_for_scoreboard_done(scb);
			// wait_for_scoreboard_done();
		end

		phase.drop_objection(this);

		phase.phase_done.set_drain_time(this, 200ns);
	endtask

endclass
