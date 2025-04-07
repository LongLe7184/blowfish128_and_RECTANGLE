import IBR128_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

//Create an analysis imp with suffix "_mon"
`uvm_analysis_imp_decl(_mon);

class IBR128_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(IBR128_scoreboard)

	uvm_analysis_imp_mon#(IBR128_base_item, IBR128_scoreboard) m_analysis_imp;

	IBR128_base_item item_fifo[10];

	function new(string name="IBR128_scoreboard", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		m_analysis_imp = new("m_analysis_imp", this);
	endfunction: build_phase

	virtual function void write_mon(IBR128_base_item item);
		`uvm_info("SCB", "write function", UVM_LOW)
	endfunction: write_mon

endclass
