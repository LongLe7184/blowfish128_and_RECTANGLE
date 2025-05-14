import IBR128_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

//Create an analysis imp with suffix "_mon"
`uvm_analysis_imp_decl(_mon);
`uvm_analysis_imp_decl(_drv);

class IBR128_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(IBR128_scoreboard)

	uvm_analysis_imp_drv#(IBR128_seq_item, IBR128_scoreboard) m_analysis_imp_drv;
	uvm_analysis_imp_mon#(IBR128_base_item, IBR128_scoreboard) m_analysis_imp_mon;

	int seq_length;
	bit [127:0] pBlock[$];
	bit [127:0] eBlock[$];
	bit [127:0] dBlock[$];

	IBR128_seq_item drv_items[$];
	IBR128_base_item mon_items[$];
	IBR128_seq_item golden_item;
	IBR128_seq_item actual_item;
	IBR128_base_item base_item;

	bit [127:0] CarryData;
	bit done_comparing = 1;
	event done_comparing_event;

	function new(string name="IBR128_scoreboard", uvm_component parent=null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		m_analysis_imp_drv = new("m_analysis_imp_drv", this);
		m_analysis_imp_mon = new("m_analysis_imp_mon", this);

		if(!uvm_config_db#(int)::get(this, "", "seq_length", seq_length))
			`uvm_fatal("SCB", "Couldn't get seq_length")

	endfunction: build_phase

	virtual function void write_drv(IBR128_seq_item item);
		`uvm_info("SCB", "write_drv function called", UVM_LOW)
        	drv_items.push_back(item);
	endfunction: write_drv

	virtual function void write_mon(IBR128_base_item item);

		`uvm_info("SCB", "write_mon function called", UVM_LOW)

		if(item.trns_type == CIPHERTEXT_TRANS) begin
        		mon_items.push_back(item);
			`uvm_info("SCB", $sformatf("mon_items queue size = %d", mon_items.size()), UVM_LOW)
			`uvm_info("SCB", $sformatf("drv_items queue size = %d", drv_items.size()), UVM_LOW)
		end

		done_comparing = 0;

		if( (drv_items.size() == 1) && (mon_items.size() == 4) ) begin

			golden_item = drv_items.pop_front(); 
			case(golden_item.Algorithm)
				BLOWFISH: begin
					if(golden_item.Operation == ENCRYPT) begin
						blowfish128_encrypt_ref_model golden_model = new();
						golden_item = golden_model.predict(golden_item);
					end else begin

					end
				end
				RECTANGLE: begin
					if(golden_item.Operation == ENCRYPT) begin
						rectangle128_encrypt_ref_model golden_model = new(); 
						golden_item = golden_model.predict(golden_item); 
					end else if(golden_item.Operation == DECRYPT) begin
						rectangle128_decrypt_ref_model golden_model = new();
						golden_item = golden_model.predict(golden_item);
					end
				end
			endcase

			CarryData = golden_item.CarryData;

			// Copy all property except EData
			actual_item = golden_item;
			actual_item.EData = 0;
			while(mon_items.size() != 0) begin
				base_item = mon_items.pop_front();
				case(base_item.Addr)
					5'h0C: actual_item.EData[31:0] = base_item.RData;
					5'h0D: actual_item.EData[63:32] = base_item.RData;
					5'h0E: actual_item.EData[95:64] = base_item.RData;
					5'h0F: actual_item.EData[127:96] = base_item.RData;
				endcase
			end

			compare(golden_item, actual_item);	

			done_comparing = 1;
			-> done_comparing_event;

			if(golden_item.Operation == DECRYPT && golden_item.BlockNum == seq_length)
				summarize();
		end

	endfunction: write_mon

	virtual function void compare(IBR128_seq_item golden, IBR128_seq_item actual);
		if(actual.EData == golden.EData) begin
			string str = $sformatf("\n\t======  COMPARE RESULT: [MATCH] ======\
						\n\tOperation   : %s\
						\n\tBlock Num   : %d\
						\n\tGolden EData: %032h\
						\n\tActual EData: %032h\
						\n\t======================================", golden.op2String(), golden.BlockNum, golden.EData, actual.EData);
			`uvm_info("COMPARE", str, UVM_LOW)
		end else begin
			string str = $sformatf("\n\t=====  COMPARE RESULT: [MISMATCH] ====\
						\n\tOperation   : %s\
						\n\tBlock Num   : %d\
						\n\tGolden EData: %032h\
						\n\tActual EData: %032h\
						\n\t======================================", golden.op2String(), golden.BlockNum, golden.EData, actual.EData);
			`uvm_error("COMPARE", str);
		end

		if(actual.Operation == ENCRYPT) begin
			pBlock.push_back(actual.PData);
			eBlock.push_back(actual.EData);
		end else begin
			dBlock.push_back(actual.EData);
		end

	endfunction: compare

	virtual function void summarize();
		string str;

		if(pBlock.size() != eBlock.size() || pBlock.size() != dBlock.size() || eBlock.size() != dBlock.size())
			`uvm_warning("SUMMARY", $sformatf("Queues Size is not the same!\
							\ eBlock.size = %d,\
							\ pBlock.size = %d,\
							\ dBlock.size = %d"
							, eBlock.size()
							, pBlock.size()
							, dBlock.size()))

		str = $sformatf("\n\t\t\t------------------------------------------------------------------------\
				 \n\t\t\t\t\t\t=====\tTEST SUMMARIZE\t=====\
				 \n\t\t\t------------------------------------------------------------------------\
				 \n\tBlockNum\tPBlock\t\t\t\t\tEBlock\t\t\t\t\tDBlock\n");
		
		`uvm_info("SUMMARY", str, UVM_LOW);

		for(int i=0; i < seq_length; i++) begin
			if(pBlock.size() && eBlock.size() && dBlock.size()) begin
				logic[127:0] pData, eData, dData;
				pData = pBlock.pop_front();
				eData = eBlock.pop_front();
				dData = dBlock.pop_front();
				$display($sformatf("\t%d\t%h\t%h\t%h\n", (i+1), pData, eData, dData));
			end
		end

	endfunction

endclass
