import IBR128_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

//Undefine SEQ_LENGTH (since other test can be compiled first)
`undef SEQ_LENGTH
`define SEQ_LENGTH 10

class IBR128_middle_reset_test extends IBR128_base_test;
	`uvm_component_utils(IBR128_middle_reset_test)

	int reset_point = 5;

	function new(string name="IBR128_middle_reset_test", uvm_component parent=null);
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
			IBR128_blowfish_cbc_seq seq1 = IBR128_blowfish_cbc_seq::type_id::create($sformatf("seq1_%0d", i));
			seq1.BlockNum = i+1;
			seq1.Op = ENCRYPT;

			if(!seq1.randomize()) begin
				`uvm_error("TEST", "Sequence randomization failed")
			end

			`uvm_info("TEST", $sformatf("Starting Encrypting sequence iteration %0d", i+1), UVM_LOW)
			seq1.start(env.agent.sqcr);

			if(i == reset_point-1) begin
				//Middle reset at reset_point-th sequence
				repeat(10) @(posedge vif.Clk);
				`uvm_info("TEST", $sformatf("Apply Middle_Reset at %d sequence", reset_point-1), UVM_LOW)
				apply_resetN();
				break;
			end

			// wait_for_scoreboard_done();
			wait_for_scoreboard_done(scb);
		end

		`uvm_info("TEST_PHASE", $sformatf("Entering Encrypting Test Phase with %d Block", `SEQ_LENGTH), UVM_LOW)

		for(int i=0; i < `SEQ_LENGTH; i++) begin
			IBR128_rectangle_cbc_seq seq2 = IBR128_rectangle_cbc_seq::type_id::create($sformatf("seq1_%0d", i));
			seq2.BlockNum = i+1;
			seq2.Op = ENCRYPT;

			if(!seq2.randomize()) begin
				`uvm_error("TEST", "Sequence randomization failed")
			end

			`uvm_info("TEST", $sformatf("Starting Encrypting sequence iteration %0d", i+1), UVM_LOW)
			seq2.start(env.agent.sqcr);

			// wait_for_scoreboard_done();
			wait_for_scoreboard_done(scb);
		end

		phase.drop_objection(this);

		phase.phase_done.set_drain_time(this, 200ns);
	endtask

endclass
