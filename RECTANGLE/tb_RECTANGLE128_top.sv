`timescale 1ns / 1ps

module tb_RECTANGLE128_top;
	// Testbench signals
	logic Clk, RstN, Enable, Encrypt, cipherReady;
	logic [63:0] plainText, cipherText, key0, key1;
	
	logic flush, WE;
	logic [4:0] WAddr, round_counter;
	logic [63:0] KeyIn, KeyOut;
    
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

	// Clock generation
	initial begin	
		#0 Clk = 1;
		forever #5 Clk = !Clk;
	end

	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(1);
	end

	initial begin
		// Initialize signals
		RstN = 0;
		Enable = 0;

		// Example key values
		key0 = 64'hAABB09182736CCDD;
		key1 = 64'hAABB09182736CCDD;

		// Reset sequence
		#10 RstN = 1;
		#10 Enable = 1;

		// Finish simulation
		#500 $finish;
	end

endmodule
