//-----------------------------------------------------------
// Function: IBR128 Core Module
//-----------------------------------------------------------
// Author	: Long Le, Manh Nguyen
// Date  	: April-5th, 2025
// Description	: Connecting IBR128's opmode & encrypt module
//-----------------------------------------------------------

module IBR128_core(
	input Clk,
	input RstN,
	input Enable,
	input SA,
	input Encrypt,
	input [1:0] SOM,
	input [127:0] plainText,
	input [127:0] IV,
	input FB,
	input [63:0] key0,
	input [63:0] key1,
	output [127:0] cipherText,
	output cipherReady
	);

	wire encrypt, block_start, sa, block_ready;
	wire [127:0] pData, eData;

	IBR128_opmode IBR128_opmode(
		.Clk(Clk),
		.RstN(RstN),
		.Enable(Enable),
		.Encrypt(Encrypt),
		.SOM(SOM),
		.FB(FB),
		.plainText(plainText),
		.SA(SA),
		.IV(IV),
		.cipherText(cipherText),
		.cipherReady(cipherReady),
		//Internal signals
		.encrypt(encrypt),
		.block_start(block_start),
		.pData(pData),
		.sa(sa),
		.block_ready(block_ready),
		.eData(eData)
	);

	IBR128_encrypt IBR128_encrypt(
		.Clk(Clk),
		.RstN(RstN),
		.key0(key0),
		.key1(key1),
		.encrypt(encrypt),
		.block_start(block_start),
		.pData(pData),
		.sa(sa),
		.block_ready(block_ready),
		.eData(eData)
	);

endmodule
