import IBR128_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class IBR128_driver extends uvm_driver #(IBR128_base_item);
	`uvm_component_utils(IBR128_driver)

	uvm_analysis_port #(IBR128_seq_item) drv_analysis_port;
	IBR128_seq_item current_seq_item;

	virtual IBR128_if vif;

	function new(string name = "IBR128_driver", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual IBR128_if)::get(this, "", "vif", vif))
			`uvm_fatal("DRV", "Couldn't get vif")
		drv_analysis_port = new ("drv_analysis_port", this);
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			IBR128_base_item base_item;
			`uvm_info("DRV", $sformatf("Wait for item from seqcr"), UVM_LOW)
			seq_item_port.get_next_item(base_item);
			
			if(base_item.is_first_of_sequence) begin
				$cast(current_seq_item, base_item.parent_seq_item);
				`uvm_info("DRV", $sformatf("Send an item to SCB:"), UVM_LOW)
				current_seq_item.print();
				drv_analysis_port.write(current_seq_item);
			end

			seq_to_signals(base_item);
			drive_item(base_item);

			if(base_item.trns_type == STATUS_TRANS) begin
				@(posedge vif.Clk);
				wait(vif.RData[0]);	
				`uvm_info("LONG_DEBUG", "Wait Complete!", UVM_LOW)
			end
			// else if (base_item.trns_type == CIPHERTEXT_TRANS) begin
				// base_item.RData = vif.RData;
			// end

			`uvm_info("DRV", $sformatf("Drive an item DUT:"), UVM_LOW)
			base_item.print();

			seq_item_port.item_done();
		end
	endtask: run_phase

	virtual function void seq_to_signals(IBR128_base_item base_item);
		case(base_item.trns_type)
			IV_TRANS, KEY_TRANS, PLAINTEXT_TRANS, CMD_TRANS: begin
				base_item.CS = 1;
				base_item.Write = 1;
				base_item.Read = 0;
			end
			CIPHERTEXT_TRANS, STATUS_TRANS: begin
				base_item.CS = 1;
				base_item.Write = 0;
				base_item.Read = 1;
			end
			default: begin
				base_item.CS = 0;
				base_item.Write = 0;
				base_item.Read = 0;
			end
		endcase
	endfunction: seq_to_signals 

	virtual task drive_item(IBR128_base_item base_item);
		@(posedge vif.Clk);
		vif.CS <= base_item.CS;
		vif.Addr <= base_item.Addr;
		vif.Write <= base_item.Write;
		vif.Read <= base_item.Read;
		vif.WData <= base_item.WData;
		vif.trans_type_debug <= base_item.trns_type;

		//Additional Clock for Read Operation
		if(base_item.Read)
			@(posedge vif.Clk);
	endtask: drive_item

endclass
