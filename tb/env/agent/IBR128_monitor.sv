import IBR128_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class IBR128_monitor extends uvm_monitor;
	`uvm_component_utils(IBR128_monitor)
	uvm_analysis_port#(IBR128_base_item) mon_analysis_port;
	virtual IBR128_if vif;

	function new(string name="IBR128_monitor", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual IBR128_if)::get(this, "", "vif", vif))
			`uvm_fatal("MON", "Couldn't get vif")
		mon_analysis_port = new ("mon_analysis_port", this);
	endfunction: build_phase
	
	virtual task run_phase(uvm_phase phase);
		`uvm_info("MON", "Enter runphase", UVM_LOW)
		super.run_phase(phase);
		forever begin
			@(posedge vif.Clk);
			if(vif.CS) begin
				IBR128_base_item base_item = new;
				base_item.Addr = vif.Addr;
				base_item.Write = vif.Write;
				base_item.Read = vif.Read;
				base_item.WData = vif.WData;

				if(vif.Read && vif.Addr==5'h11) begin
					if(vif.RData[0]) begin
						base_item.RData = vif.RData;
					end
				end
				`uvm_info(get_type_name(), $sformatf("Monitor captures packet: %s", base_item.toString()), UVM_LOW)
				mon_analysis_port.write(base_item);
			end
		end
		`uvm_info("MON", "Exit runphase", UVM_LOW)
	endtask: run_phase
endclass
