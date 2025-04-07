package IBR128_pkg;
	typedef enum logic[2:0] {
		IV_TRANS,
		KEY_TRANS,
		PLAINTEXT_TRANS,
		CIPHERTEXT_TRANS,
		CMD_TRANS,
		STATUS_TRANS,
		NOP_TRANS
	} transtype;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	`include "IBR128_base_item.sv"
	`include "IBR128_encrypt_seq.sv"
	`include "IBR128_driver.sv"
	`include "IBR128_monitor.sv"
	`include "IBR128_agent.sv"
	`include "IBR128_scoreboard.sv"
	`include "IBR128_env.sv"
	`include "IBR128_base_test.sv"


endpackage : IBR128_pkg
