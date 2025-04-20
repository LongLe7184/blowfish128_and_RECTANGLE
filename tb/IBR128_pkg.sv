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

	//items
	`include "IBR128_seq_item.sv"
	`include "IBR128_base_item.sv"

	//models
	`include "model_DEF.sv"
	`include "blowfish128_encrypt_ref_model.sv"
	`include "rectangle128_encrypt_ref_model.sv"
	`include "rectangle128_decrypt_ref_model.sv"

	//components
	`include "IBR128_driver.sv"
	`include "IBR128_monitor.sv"
	`include "IBR128_agent.sv"
	`include "IBR128_scoreboard.sv"
	`include "IBR128_env.sv"

	//sequences
	`include "IBR128_init_seq.sv"
	`include "IBR128_cmd_seq.sv"
	`include "IBR128_status_seq.sv"
	`include "IBR128_collect_seq.sv"
	`include "IBR128_intermediate_seq.sv"
	`include "IBR128_blowfish_cbc_seq.sv"
	`include "IBR128_blowfish_ofb_seq.sv"
	`include "IBR128_blowfish_ctr_seq.sv"
	`include "IBR128_rectangle_cbc_seq.sv"
	`include "IBR128_rectangle_ofb_seq.sv"
	`include "IBR128_rectangle_ctr_seq.sv"

	//tests
	`include "IBR128_base_test.sv"
	`include "IBR128_blowfish_cbc_test.sv"
	`include "IBR128_blowfish_ofb_test.sv"
	`include "IBR128_blowfish_ctr_test.sv"
	`include "IBR128_rectangle_cbc_test.sv"
	`include "IBR128_rectangle_ofb_test.sv"
	`include "IBR128_rectangle_ctr_test.sv"

endpackage : IBR128_pkg
