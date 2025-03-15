`timescale 1ns / 1ps

module tb_RECTANGLE128_top;
	// Testbench signals
	logic Clk, RstN, Enable, Encrypt, cipherReady;
	logic [63:0] plainText, cipherText, key0, key1;
	
	logic flush, WE;
	logic [4:0] WAddr, RAddr;
	logic [63:0] KeyIn, roundKey;
    
	// Instantiate the module under test
	RECTANGLE128_top uut(
		.Clk(Clk),
		.RstN(RstN),
		.Enable(Enable),
		.plainText(plainText),
		.Encrypt(Encrypt),
		.key0(key0),
		.key1(key1),
		.cipherText(cipherText),
		.cipherReady(cipherReady)
	);

	assign flush = uut.flush;
	assign WE = uut.WE;
	assign WAddr = uut.WAddr;
	assign KeyIn = uut.KeyIn;
	assign skey_ready = uut.skey_ready;
	assign RAddr = uut.RAddr;
	assign roundKey = uut.roundKey;

	// Clock generation
	initial begin	
		#0 Clk = 1;
		forever #10 Clk = !Clk;
	end

	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(1);
	end

	logic [63:0] cipher;

	initial begin
		// Initialize signals
		RstN <= 0;
		Enable <= 0;

		// Example key values
		key0 <= 64'hAABB09182736CCDD;
		key1 <= 64'hAABB09182736CCDD;

		// Reset sequence
		#20 RstN <= 1;

		//Encrypt
		#20 Enable <= 1;
		plainText <= 64'h123456ABCD132536;
		Encrypt <= 1;

		wait(cipherReady);
		#20
		cipher = cipherText;
		$display("%d Cipher Text: %h", $time, cipher);

		//Decrypt
		#20 Enable <= 0;
		#20 Enable <= 1;
		plainText <= cipher;
		Encrypt <= 0;

		// Finish simulation
		wait(cipherReady);
		#50 $finish;
	end

endmodule
