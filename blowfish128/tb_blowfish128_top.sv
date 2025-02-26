`timescale 1ns/1ps

module tb_blowfish128_top;
	//Global Control Signals
	logic Clk_tb;
	logic RstN_tb;
	logic Enable_tb;
	logic Encrypt_tb;
	//plainText & Key Input
	logic [127:0] plainText_tb;
	logic [63:0] key0_tb;
	logic [63:0] key1_tb;
	logic [63:0] key2_tb;
	logic [63:0] key3_tb;
	logic [63:0] key4_tb;
	logic [63:0] key5_tb;
	logic [63:0] key6_tb;
	logic [63:0] key7_tb;
	logic [3:0] key_length_tb;
	//cipherText Output
	logic [127:0] cipherText_tb;
	logic cipherReady_tb;
	
	blowfish128_top DUT(
		//Global Control Signals
		.Clk(Clk_tb),
		.RstN(RstN_tb),
		.Enable(Enable_tb),
		.Encrypt(Encrypt_tb),
		//plainText & Key Input
		.plainText(plainText_tb),
		.key0(key0_tb),
		.key1(key1_tb),
		.key2(key2_tb),
		.key3(key3_tb),
		.key4(key4_tb),
		.key5(key5_tb),
		.key6(key6_tb),
		.key7(key7_tb),
		.key_length(key_length_tb),
		//cipherText Output
		.cipherText(cipherText_tb),
		.cipherReady(cipherReady_tb)
	);

	initial begin
		Clk_tb = 0;
		forever #5 Clk_tb = ~Clk_tb;
	end

	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(1);
	end

	logic [127:0] cipher;

	initial begin
		//Reset phase
		RstN_tb <= 0;
		Enable_tb <= 0;
		#50 RstN_tb <= 1;
		#5 Enable_tb <= 1;

		//Input value phase
		plainText_tb <= 128'h1234_56ab_cd13_2536_1234_56ab_cd13_2536;
		key0_tb <= 64'haabb_0918_2736_ccdd;
		key_length_tb <= 4'h2;
		Encrypt_tb <= 1'h1;

		wait(cipherReady_tb);
		cipher = cipherText_tb;
		$display("%d Cipher Text: %h", $time, cipher);

		#10 Enable_tb = 0;
		#20 Enable_tb = 1;
		plainText_tb <= cipher;
		key0_tb <= 64'haabb_0918_2736_ccdd;
		key_length_tb <= 4'h2;
		Encrypt_tb <= 1'h0;
		
		wait(cipherReady_tb);
		cipher = cipherText_tb;
		$display("%d Cipher Text: %h", $time, cipher);

		#200 $finish;
	end

endmodule
