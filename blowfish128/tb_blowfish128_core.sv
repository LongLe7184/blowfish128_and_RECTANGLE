`timescale 1ns/1ps

module tb_blowfish128_core;
	logic Clk_tb;
	logic RstN_tb;
	logic Enable_tb;
	logic [127:0] plainText_tb, cipherText_tb;
	logic cipherReady_tb;
	
	logic skey_ready_tb;
	logic [31:0] P1_tb, P2_tb, P3_tb, P4_tb, P5_tb, P6_tb, P7_tb, P8_tb, P9_tb, P10_tb;
	logic [31:0] P11_tb, P12_tb, P13_tb, P14_tb, P15_tb, P16_tb, P17_tb, P18_tb, P19_tb, P20_tb;
	
	wire [63:0] X_tb, Y_tb;
	wire ffunc_ready_tb, ffunc_enable_tb;

	blowfish128_core DUT(
		.Clk		(Clk_tb),
		.RstN		(RstN_tb),
		.Enable		(Enable_tb),
		.plainText	(plainText_tb),
		.cipherText	(cipherText_tb),
		.cipherReady	(cipherReady_tb),
		.skey_ready	(skey_ready_tb),
		.P1		(P1_tb),
		.P2		(P2_tb),
		.P3		(P3_tb),
		.P4		(P4_tb),
		.P5		(P5_tb),
		.P6		(P6_tb),
		.P7		(P7_tb),
		.P8		(P8_tb),
		.P9		(P9_tb),
		.P10		(P10_tb),
		.P11		(P11_tb),
		.P12		(P12_tb),
		.P13		(P13_tb),
		.P14		(P14_tb),
		.P15		(P15_tb),
		.P16		(P16_tb),
		.P17		(P17_tb),
		.P18		(P18_tb),
		.P19		(P19_tb),
		.P20		(P20_tb),
		.Y		(Y_tb),
		.ffunc_ready	(ffunc_ready_tb),
		.X		(X_tb),
		.ffunc_enable	(ffunc_enable_tb)
	);

	blowfish128_ffunc FFUNC(
		.Clk		(Clk_tb),
		.RstN		(RstN_tb),
		.Enable		(ffunc_enable_tb),
		.X		(X_tb),
		.Y		(Y_tb),
		.outputValid	(ffunc_ready_tb)
	);

	logic [1:0] step_tb;
	logic [3:0] rCounter_tb; 
	logic [63:0] lH_tb, rH_tb;

	assign step_tb = DUT.step;
	assign rCounter_tb = DUT.rCounter;
	assign lH_tb = DUT.lH;
	assign rH_tb = DUT.rH;
	
	initial begin
		Clk_tb = 0;
		forever #5 Clk_tb = ~Clk_tb;
	end

	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(1);
	end

	initial begin
		//Reset phase
		RstN_tb <= 0;
		Enable_tb <= 0;
		#50 RstN_tb <= 1;
		#5 Enable_tb <= 1;

		//Input value phase
		plainText_tb <= 128'h1234_56ab_cd13_2536_1234_56ab_cd13_2536;
		skey_ready_tb <= 1'b1;
		//Subkeys correspond of key[63:0] = aabb_0918_2736_ccdd
		P1_tb <= 32'h8e846390;
		P2_tb <= 32'ha295c40e;
		P3_tb <= 32'hb9a28336;
		P4_tb <= 32'h2446bf99;
		P5_tb <= 32'h0eb2313a;
		P6_tb <= 32'h0ea9fd0d;
		P7_tb <= 32'ha295f380;
		P8_tb <= 32'hcb78a054;
		P9_tb <= 32'hef9328fe;
		P10_tb <= 32'h1fe6dfaa;
		P11_tb <= 32'h14ef6fd7;
		P12_tb <= 32'h13dfc0b1;
		P13_tb <= 32'h6a1720af;
		P14_tb <= 32'hee4a9c00;
		P15_tb <= 32'h953fdcad;
		P16_tb <= 32'h9271c5ca;
		P17_tb <= 32'h38addcc1;
		P18_tb <= 32'hae4f37c6;
		P19_tb <= 32'hfd34d6fb;
		P20_tb <= 32'h1df5be3b;
		
		#2000 $finish;
	end

endmodule
