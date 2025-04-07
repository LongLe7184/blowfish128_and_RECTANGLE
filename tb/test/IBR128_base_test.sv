import IBR128_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class IBR128_base_test extends uvm_test;
	`uvm_component_utils(IBR128_base_test)
	IBR128_env env;
	virtual IBR128_if vif;

	function new(string name="IBR128_base_test", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = IBR128_env::type_id::create("env", this);
		if(!uvm_config_db#(virtual IBR128_if)::get(this, "", "vif", vif))
			`uvm_fatal("TEST", "Couldn't get vif")
		uvm_config_db#(virtual IBR128_if)::set(this, "env.agent.*", "vif", vif);
	endfunction

	virtual function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction
	
	virtual task run_phase(uvm_phase phase);
		IBR128_encrypt_seq seq = IBR128_encrypt_seq::type_id::create("seq");
		phase.raise_objection(this);
		apply_resetN();
		seq.start(env.agent.sqcr);
		phase.drop_objection(this);
		phase.phase_done.set_drain_time(this, 200ns);
	endtask

	virtual task apply_resetN();
		vif.RstN <= 0;
		repeat(5) @(posedge vif.Clk);
		vif.RstN <= 1;
		repeat(5) @(posedge vif.Clk);
	endtask

endclass
