package IBR128_pkg;
	typedef enum logic[0:0] {
		ENCRYPT,
		DECRYPT
	} operation;

	typedef enum logic[0:0] {
		BLOWFISH,
		RECTANGLE
	} algorithm;

	typedef enum logic[1:0] {
		NOP,
		CBC,
		OFB,
		CTR
	} bcom;

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

	//items & sequences
	`include "IBR128_seq_item.sv"
	`include "IBR128_base_item.sv"
	`include "IBR128_init_seq.sv"
	`include "IBR128_cmd_seq.sv"
	`include "IBR128_blowfish_cbc_seq.sv"
	
	//components
	`include "IBR128_driver.sv"
	`include "IBR128_monitor.sv"
	`include "IBR128_agent.sv"
	`include "IBR128_scoreboard.sv"
	`include "IBR128_env.sv"

	//tests
	`include "IBR128_base_test.sv"

endpackage : IBR128_pkg
