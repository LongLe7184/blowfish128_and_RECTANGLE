import IBR128_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class IBR128_base_test extends uvm_test;
	`uvm_component_utils(IBR128_base_test)
	IBR128_env env;
	virtual IBR128_if vif;
	int seq_length = 4;

	function new(string name="IBR128_base_test", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = IBR128_env::type_id::create("env", this);
		
		if(!uvm_config_db#(virtual IBR128_if)::get(this, "", "vif", vif))
			`uvm_fatal("TEST", "Couldn't get vif")
		uvm_config_db#(virtual IBR128_if)::set(this, "env.agent.*", "vif", vif);

		uvm_config_db#(int)::set(this, "env.scoreboard", "seq_length", seq_length);

	endfunction

	virtual function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction
	
	virtual task run_phase(uvm_phase phase);

		IBR128_scoreboard scb;
		if (!$cast(scb, uvm_top.find("uvm_test_top.env.scoreboard"))) begin
			`uvm_error("TEST", "Failed to find scoreboard")
			return;
		end

		phase.raise_objection(this);
		repeat(5) @(posedge vif.Clk);
		phase.drop_objection(this);

		phase.phase_done.set_drain_time(this, 200ns);
	endtask

	virtual task apply_resetN();
		vif.RstN <= 0;
		repeat(5) @(posedge vif.Clk);
		vif.RstN <= 1;
		repeat(5) @(posedge vif.Clk);
	endtask

	task wait_for_scoreboard_done(IBR128_scoreboard scb);
		if (scb.done_comparing == 0) begin
			`uvm_info("TEST", "Waiting for scoreboard to complete comparison", UVM_LOW)
			@(scb.done_comparing_event);
			`uvm_info("TEST", "Scoreboard comparison completed", UVM_LOW)
		end
	endtask

endclass
