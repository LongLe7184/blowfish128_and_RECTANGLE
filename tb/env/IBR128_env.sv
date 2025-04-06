import IBR128_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class IBR128_env extends uvm_env;
	`uvm_component_utils(IBR128_env)

	IBR128_agent agent;
	IBR128_scoreboard scoreboard;

	function new(string name="IBR128_env", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agent = IBR128_agent::type_id::create("agent", this);
		scoreboard = IBR128_scoreboard::type_id::create("scoreboard", this);
	endfunction: build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		agent.mon.mon_analysis_port.connect(scoreboard.m_analysis_imp);
	endfunction: connect_phase

endclass
