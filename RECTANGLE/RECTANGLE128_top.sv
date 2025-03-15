//-----------------------------------------------------------
// Module: RECTANGLE128's Top Module
//-----------------------------------------------------------
// Author	: Long Le, Manh Nguyen
// Date  	: Mar-12th, 2025
// Description	: Connecting RECTANGLE128's sub-modules
//-----------------------------------------------------------

module RECTANGLE128_top(
	input Clk,
	input RstN,
	input Enable,
	input [63:0] plainText,
	input Encrypt,
	input [63:0] key0,
	input [63:0] key1,
	output [63:0] cipherText,
	output cipherReady
	);

	//skeygen & skeymem signals
	logic flush, WE;
	logic [4:0] WAddr;
	logic [63:0] KeyIn;

	//skeymem & core signals
	logic skey_ready;
	logic [4:0] RAddr;
	logic [63:0] roundKey;

	RECTANGLE128_skeygen RECTANGLE128_skeygen(
		.Clk(Clk),
		.RstN(RstN),
		.Enable(Enable),
		.key0(key0),
		.key1(key1),
		//skeymem Interface
		.flush(flush),
		.WE(WE),
		.WAddr(WAddr),
		.KeyIn(KeyIn)
	);

	RECTANGLE128_skeymem RECTANGLE128_skeymem(
		.Clk(Clk),
		//skeygen Interface
		.flush(flush),
		.WE(WE),
		.WAddr(WAddr),
		.KeyIn(KeyIn),
		//core Interface
		.RAddr(RAddr),
		.KeyOut(roundKey),
		.skey_ready(skey_ready)
	);

	RECTANGLE128_core RECTANGLE128_core(
		.Clk(Clk),
		.RstN(RstN),
		.Enable(Enable),
		.Encrypt(Encrypt),
		.plainText(plainText),
		.cipherText(cipherText),
		.cipherReady(cipherReady),
		//skey_mem Interface
		.skey_ready(skey_ready),
		.roundKey(roundKey),
		.RAddr(RAddr)
	);

endmodule
