`timescale 1ns / 1ps

module tb_RECTANGLE128_skeygen;
	// Testbench signals
	reg Clk;
	reg RstN;
	reg Enable;
	reg [63:0] key0, key1;

	wire flush, WE;
	wire [4:0] WAddr, round_counter;
	wire [63:0] KeyIn;
    
    // Instantiate the module under test
	RECTANGLE128_skeygen uut (
		.Clk(Clk),
		.RstN(RstN),
		.Enable(Enable),
		.key0(key0),
		.key1(key1),
		.flush(flush),
		.WE(WE),
		.WAddr(WAddr),
		.KeyIn(KeyIn)
	);

	assign round_counter = uut.round_counter;

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
		// aabb09182736ccddaabb09182736ccdd
		key0 = 64'hAABB09182736CCDD;
		key1 = 64'hAABB09182736CCDD;

		// Reset sequence
		#10 RstN = 1;
		#10 Enable = 1;

		// Finish simulation
		#500 $finish;
	end

endmodule
