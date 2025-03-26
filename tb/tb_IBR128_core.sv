`timescale 1ns/1ps

module tb_IBR128_core;
	logic Clk_tb, RstN_tb, Enable_tb, SA_tb, Encrypt_tb, OB_tb;
	logic [1:0] SOM_tb;
	logic [127:0] plainText_tb, cipherText_tb;
	logic [31:0] IV_tb;
	logic cipherReady_tb;
	logic [63:0] key0_tb, key1_tb;

	IBR128_core IBR128_core(
		.Clk(Clk_tb),
		.RstN(RstN_tb),
		.Enable(Enable_tb),
		.SA(SA_tb),
		.Encrypt(Encrypt_tb),
		.SOM(SOM_tb),
		.plainText(plainText_tb),
		.IV(IV_tb),
		.OB(OB_tb),
		.key0(key0_tb),
		.key1(key1_tb),
		.cipherText(cipherText_tb),
		.cipherReady(cipherReady_tb)
	);

	logic [127:0] counter_tb;
	assign counter_tb = IBR128_core.IBR128_opmode.counter;
	
	initial begin
		Clk_tb = 1;
		forever #10 Clk_tb = !Clk_tb;
	end

	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(1);
	end

	initial begin
		//Reset phase
		RstN_tb <= 0;
		Enable_tb <= 0;
		OB_tb <= 1; //OB HIGH by default
		#60 RstN_tb <= 1;

	//Start a transaction
		//Prepare Input
		SA_tb <= 1'b0;
		Encrypt_tb <= 1'b1;
		SOM_tb <= 2'h3;
		plainText_tb <= 128'h1234_56ab_cd13_2536_1234_56ab_cd13_2536;
		key1_tb <= 64'haabb_0918_2736_ccdd;
		key0_tb <= 64'h9988_1234_5670_1122;
		IV_tb <= 32'h1111_1111;
		//Enable IP
		#20 Enable_tb <= 1;
		OB_tb <= 0; //OB LOW when start to encrypt block
		//Wait for Output
		wait(cipherReady_tb);
		
	//Start new transaction
		#20 Enable_tb <= 1'b0;
		
		#20
		plainText_tb <= 128'h3456_7891_2351_6610_4309_acdf_ec12_ba22;
		//Enable IP
		#20 Enable_tb <= 1'b1;
		
		wait(cipherReady_tb);
		#20
		OB_tb <= 1; //OB back to HIGH when all blocks are encrypted
		#200 $finish;
	end

endmodule
