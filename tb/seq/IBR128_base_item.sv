import IBR128_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class IBR128_base_item extends uvm_sequence_item;

	transtype trns_type;
	bit CS;
	bit [4:0] Addr;
	bit Write;
	bit Read;
	bit [31:0] WData;
	bit [31:0] RData;
	bit is_first_of_sequence = 0;
	IBR128_seq_item parent_seq_item;

	//UVM factory registration
	`uvm_object_utils_begin(IBR128_base_item)
		`uvm_field_enum(transtype, trns_type, UVM_DEFAULT)
		`uvm_field_int(CS, UVM_DEFAULT)
		`uvm_field_int(Addr, UVM_DEFAULT)
		`uvm_field_int(Write, UVM_DEFAULT)
		`uvm_field_int(Read, UVM_DEFAULT)
		`uvm_field_int(WData, UVM_DEFAULT)
		`uvm_field_int(RData, UVM_DEFAULT)
	`uvm_object_utils_end

	//Constructor
	function new(string name = "IBR128_base_item");
		super.new(name);
	endfunction

	//toString function
	virtual function string toString();
		string trans_str;

		case(trns_type)
			IV_TRANS: trans_str = "IV_trans";
			KEY_TRANS: trans_str = "KEY_trans";
			PLAINTEXT_TRANS: trans_str = "PLAINTEXT_trans";
			CIPHERTEXT_TRANS: trans_str = "CIPHERTEXT_trans";
			CMD_TRANS: trans_str = "CMD_trans";
			STATUS_TRANS: trans_str = "STATUS_trans";
			default: trans_str = "NOP_trans";
		endcase

		return $sformatf("trans=%s cs=0x%0h addr=0x%0h wr=0x%0h rd=0x%0h wdata=0x%0h rdata=0x%0h", trans_str, CS, Addr, Write, Read, WData, RData);
	endfunction

endclass
