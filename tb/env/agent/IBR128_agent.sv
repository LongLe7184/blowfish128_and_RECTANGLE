import IBR128_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class IBR128_agent extends uvm_agent;
	`uvm_component_utils(IBR128_agent)
	IBR128_driver drv;
	IBR128_monitor mon;
	uvm_sequencer#(IBR128_base_item) sqcr;
	
	function new(string name="IBR128_agent", uvm_component parent=null);
		super.new(name, parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sqcr = uvm_sequencer#(IBR128_base_item)::type_id::create("sqcr", this);
		drv = IBR128_driver::type_id::create("drv", this);
		mon = IBR128_monitor::type_id::create("mon", this);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		drv.seq_item_port.connect(sqcr.seq_item_export);
	endfunction

endclass
