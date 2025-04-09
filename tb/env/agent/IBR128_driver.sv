import IBR128_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class IBR128_driver extends uvm_driver #(IBR128_base_item);
	`uvm_component_utils(IBR128_driver)

	virtual IBR128_if vif;

	function new(string name = "IBR128_driver", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual IBR128_if)::get(this, "", "vif", vif))
			`uvm_fatal("DRV", "Couldn't get vif")
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			IBR128_base_item base_item;
			`uvm_info("DRV", $sformatf("Wait for item from seqcr"), UVM_LOW)
			seq_item_port.get_next_item(base_item);
			// seq_to_signals(base_item);
			drive_item(base_item);
			`uvm_info("DRV", $sformatf("Drive to DUT:"), UVM_LOW)
			// base_item.print();
			seq_item_port.item_done();
		end
	endtask: run_phase

	// virtual function void seq_to_signals(IBR128_base_item base_item);
		// case(base_item.trns_type)
			// IV_TRANS, KEY_TRANS, PLAINTEXT_TRANS, CMD_TRANS: begin
				// base_item.Write = 1;
				// base_item.Read = 0;
			// end
			// CIPHERTEXT_TRANS, STATUS_TRANS: begin
				// base_item.Write = 0;
				// base_item.Read = 1;
			// end
			// default: begin
				// base_item.Write = 0;
				// base_item.Read = 0;
			// end
		// endcase
	// endfunction: seq_to_signals 

	virtual task drive_item(IBR128_base_item base_item);
		@(posedge vif.Clk);
		vif.CS <= base_item.CS;
		vif.Addr <= base_item.Addr;
		vif.Write <= base_item.Write;
		vif.Read <= base_item.Read;
		vif.WData <= base_item.WData;
	endtask: drive_item

endclass
