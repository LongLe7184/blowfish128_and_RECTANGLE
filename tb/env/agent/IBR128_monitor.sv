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
				base_item.trns_type = trans_type_determination(vif.Addr); 
				base_item.CS = vif.CS;
				base_item.Addr = vif.Addr;
				base_item.Write = vif.Write;
				base_item.Read = vif.Read;
				base_item.WData = vif.WData;

				if(vif.Read && vif.Addr==5'h11) begin
					if(vif.RData[0]) begin
						base_item.RData = vif.RData;
					end
				end

				if(base_item.trns_type != STATUS_TRANS) begin
					`uvm_info(get_type_name(), $sformatf("Monitor captures packet: %s", base_item.toString()), UVM_LOW)
					mon_analysis_port.write(base_item);
				end
			end
		end
		`uvm_info("MON", "Exit runphase", UVM_LOW)
	endtask: run_phase

	virtual function transtype trans_type_determination(bit [4:0] addr);
		if(addr>=0 && addr<4) 
			return IV_TRANS;
		 else if(addr>=4 && addr<8) 
			return KEY_TRANS;
		 else if(addr>=8 && addr<12) 
			return PLAINTEXT_TRANS;
		 else if(addr>=12 && addr<16) 
			return CIPHERTEXT_TRANS;
		 else if(addr==16) 
			return CMD_TRANS;
		 else if(addr==17) 
			return STATUS_TRANS;
		 else 
			return NOP_TRANS;
		
	endfunction : trans_type_determination

endclass
