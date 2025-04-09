import IBR128_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class IBR128_cmd_seq extends uvm_sequence #(IBR128_base_item);
	`uvm_object_utils(IBR128_cmd_seq)

	function new(string name="IBR128_cmd_seq");
		super.new(name);
	endfunction

	int BlockNum;
	operation Op;
	algorithm Al;
	bcom bcOpMode;
	logic [31:0] ctrl_reg;

	virtual function void prepareCtrlReg();
		ctrl_reg = 32'h0;
		//Enable
		ctrl_reg[0] = 1'b1;
		//Select Algorithm
		case(Al)
			BLOWFISH: ctrl_reg[1] = 1'b0;
			RECTANGLE: ctrl_reg[1] = 1'b1;
		endcase
		//Choose Operation
		case(Op)
			DECRYPT: ctrl_reg[2] = 1'b0;
			ENCRYPT: ctrl_reg[2] = 1'b1;
		endcase
		//Choose BCOM
		case(bcOpMode)
			CBC: ctrl_reg[4:3] = 2'b01;
			OFB: ctrl_reg[4:3] = 2'b10;
			CTR: ctrl_reg[4:3] = 2'b11;
		endcase
		//First-Block signal
		if(BlockNum == 1) begin
			ctrl_reg[5] = 1'b1;
		end else begin
			ctrl_reg[5] = 1'b0;
		end
	endfunction: prepareCtrlReg;

	virtual task body();
		IBR128_base_item base_item = IBR128_base_item::type_id::create("base_item");

		prepareCtrlReg();

		start_item(base_item);
		base_item.trns_type = CMD_TRANS;
		base_item.CS = 1;
		base_item.Addr = 5'h10;
		base_item.Write = 1;
		base_item.Read = 0;
		base_item.WData = ctrl_reg;
		
		`uvm_info("SEQ", "Generate new item: ", UVM_LOW)
		base_item.print();
		finish_item(base_item);

		`uvm_info("SEQ", "Exit body", UVM_LOW)
	endtask
endclass
