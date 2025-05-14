//-----------------------------------------------------------
// Function: IBR128 Encrypt Sub-Module
//-----------------------------------------------------------
// Author	: Long Le, Manh Nguyen
// Date  	: April-5th, 2025
// Description	: Contains Blowfish128 & 2 RECTANGLE128 blocks
//-----------------------------------------------------------

`include "./RECTANGLE/RECTANGLE128_top.sv"
`include "./blowfish128/blowfish128_top.sv"

module IBR128_encrypt(
	input Clk,
	input RstN,
	input [63:0] key0,
	input [63:0] key1,
	//Internal signals
	input encrypt,
	input block_start,
	input [127:0] pData,
	input sa,
	output logic block_ready,
	output logic [127:0] eData
	);

	logic blowfish_en, rectangle_en;
	assign blowfish_en = block_start & !sa;
	assign rectangle_en = block_start & sa;
	
	logic [127:0] blowfish_eText;
	logic blowfish_eReady;

	blowfish128_top blowfish128(
		.Clk(Clk),
		.RstN(RstN),
		.Enable(blowfish_en),
		.Encrypt(encrypt),
		.plainText(pData),
		.key0(key0),
		.key1(key1),
		.key2(64'h0),
		.key3(64'h0),
		.key4(64'h0),
		.key5(64'h0),
		.key6(64'h0),
		.key_length(4'h4),
		.cipherText(blowfish_eText),
		.cipherReady(blowfish_eReady)
	);
	
	logic [63:0] rectangle_eText1, rectangle_eText2;
	logic rectangle_eReady1;

	RECTANGLE128_top RECTANGLE128_1(
		.Clk(Clk),
		.RstN(RstN),
		.Enable(rectangle_en),
		.plainText(pData[127:64]),
		.Encrypt(encrypt),
		.key0(key0),
		.key1(key1),
		.cipherText(rectangle_eText1),
		.cipherReady(rectangle_eReady1)
	);

	RECTANGLE128_top RECTANGLE128_2(
		.Clk(Clk),
		.RstN(RstN),
		.Enable(rectangle_en),
		.plainText(pData[63:0]),
		.Encrypt(encrypt),
		.key0(key0),
		.key1(key1),
		.cipherText(rectangle_eText2),
		.cipherReady()
	);

	assign eData = (sa) ? {rectangle_eText1, rectangle_eText2} : blowfish_eText;
	assign block_ready = (sa) ? rectangle_eReady1 : blowfish_eReady;

endmodule
