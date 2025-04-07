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
		string str;
		case(trns_type)
			IV_TRANS: str = "IV_trans";
			KEY_TRANS: str = "KEY_trans";
			PLAINTEXT_TRANS: str = "PLAINTEXT_trans";
			CIPHERTEXT_TRANS: str = "CIPHERTEXT_trans";
			CMD_TRANS: str = "CMD_trans";
			STATUS_TRANS: str = "CMD_trans";
			default: str = "NOP_trans";
		endcase

		return $sformatf("trans=%s cs=0x%0h addr=0x%0h wr=0x%0h rd=0x%0h wdata=0x%0h rdata=0x%0h", str, CS, Addr, Write, Read, WData, RData);
	endfunction

endclass
