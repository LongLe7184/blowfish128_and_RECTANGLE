//-----------------------------------------------------------
// Module: Blowfish-128's Top Module
//-----------------------------------------------------------
// Author	: Long Le, Manh Nguyen
// Date  	: Feb-25th, 2025
// Description	: Connecting sub-modules
//-----------------------------------------------------------

`ifndef BLOWFISH128_TOP
`define BLOWFISH128_TOP

module blowfish128_top(
	//Global Control Signals
	input Clk,
	input RstN,
	input Enable,
	input Encrypt,
	//plainText & Key Input
	input [127:0] plainText,
	input [63:0] key0,
	input [63:0] key1,
	input [63:0] key2,
	input [63:0] key3,
	input [63:0] key4,
	input [63:0] key5,
	input [63:0] key6,
	input [3:0] key_length,
	//cipherText Output
	output [127:0] cipherText,
	output cipherReady
	);

	//skeygen signals
	wire skey_ready;
	wire [31:0] P1, P2, P3, P4, P5;
	wire [31:0] P6, P7, P8, P9, P10;
	wire [31:0] P11, P12, P13, P14, P15;
	wire [31:0] P16, P17, P18, P19, P20;
	
	//ffunc signals
 	wire ffunc_enable, ffunc_ready;
	wire [63:0] X, Y;

	blowfish128_core blowfish128_core(
		.Clk(Clk),
		.RstN(RstN),
		.Enable(Enable),
		.Encrypt(Encrypt),
		.plainText(plainText),
		.cipherText(cipherText),
		.cipherReady(cipherReady),
		//skeygen interface signals
		.skey_ready(skey_ready),
		.P1(P1),
		.P2(P2),
		.P3(P3),
		.P4(P4),
		.P5(P5),
		.P6(P6),
		.P7(P7),
		.P8(P8),
		.P9(P9),
		.P10(P10),
		.P11(P11),
		.P12(P12),
		.P13(P13),
		.P14(P14),
		.P15(P15),
		.P16(P16),
		.P17(P17),
		.P18(P18),
		.P19(P19),
		.P20(P20),
		//ffunc interface signals
		.Y(Y),
		.ffunc_ready(ffunc_ready),
		.X(X),
		.ffunc_enable(ffunc_enable)
	);

	blowfish128_skeygen blowfish128_skeygen(
		.Clk(Clk),
		.RstN(RstN),
		.Enable(Enable),
		.key0(key0),
		.key1(key1),
		.key2(key2),
		.key3(key3),
		.key4(key4),
		.key5(key5),
		.key6(key6),
		.key_length(key_length),
		//core interface signals
		.skey_ready(skey_ready),
		.P1(P1),
		.P2(P2),
		.P3(P3),
		.P4(P4),
		.P5(P5),
		.P6(P6),
		.P7(P7),
		.P8(P8),
		.P9(P9),
		.P10(P10),
		.P11(P11),
		.P12(P12),
		.P13(P13),
		.P14(P14),
		.P15(P15),
		.P16(P16),
		.P17(P17),
		.P18(P18),
		.P19(P19),
		.P20(P20)
	);

	blowfish128_ffunc blowfish128_ffunc(
		.Clk(Clk),
		.RstN(RstN),
		//core interface signals
		.Enable(ffunc_enable),
		.X(X),
		.Y(Y),
		.outputValid(ffunc_ready)
	);

endmodule

`endif
