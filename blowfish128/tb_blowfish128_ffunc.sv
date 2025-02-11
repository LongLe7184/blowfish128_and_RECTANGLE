`timescale 1ns/1ps

module tb_blowfish128_ffunc;
	logic Clk_tb;
	logic RstN_tb;
	logic Enable_tb;
	logic [63:0] X_tb;
	logic [63:0] Y_tb;
	logic outputValid_tb;

	blowfish128_ffunc DUT(
		.Clk		(Clk_tb),
		.RstN		(RstN_tb),
		.Enable		(Enable_tb),
		.X		(X_tb),
		.Y		(Y_tb),
		.outputValid	(outputValid_tb)
	);

	logic [2:0] state_tb, next_state_tb;

	assign state_tb = DUT.state;
	assign next_state_tb = DUT.next_state;

	logic [7:0] a_tb, b_tb, c_tb, d_tb, e_tb, f_tb, g_tb, h_tb;
	logic [127:0] SBox1_tb, SBox2_tb;
	logic [31:0] S1a_tb, S1b_tb, S1c_tb, S1d_tb, S2e_tb, S2f_tb, S2g_tb, S2h_tb;
	logic [31:0] res1H_tb, res1L_tb, res2H_tb, res2L_tb, res3H_tb, res3L_tb;
	logic valid_stage_tb, valid_stage0_tb, valid_stage1_tb, valid_stage2_tb, valid_stage3_tb;

	assign a_tb = DUT.a;
	assign b_tb = DUT.b;
	assign c_tb = DUT.c;
	assign d_tb = DUT.d;
	assign e_tb = DUT.e;
	assign f_tb = DUT.f;
	assign g_tb = DUT.g;
	assign h_tb = DUT.h;

	assign SBox1_tb = DUT.SBox1;
	assign SBox2_tb = DUT.SBox2;
	
	assign S1a_tb = DUT.S1a;
	assign S1b_tb = DUT.S1b;
	assign S1c_tb = DUT.S1c;
	assign S1d_tb = DUT.S1d;
	assign S2e_tb = DUT.S2e;
	assign S2f_tb = DUT.S2f;
	assign S2g_tb = DUT.S2g;
	assign S2h_tb = DUT.S2h;
	
	assign res1H_tb = DUT.res1H;
	assign res1L_tb = DUT.res1L;
	assign res2H_tb = DUT.res2H;
	assign res2L_tb = DUT.res2L;
	assign res3H_tb = DUT.res3H;
	assign res3L_tb = DUT.res3L;

	assign valid_stage_tb = DUT.valid_stage;
	assign valid_stage0_tb = DUT.valid_stage0;
	assign valid_stage1_tb = DUT.valid_stage1;
	assign valid_stage2_tb = DUT.valid_stage2;
	assign valid_stage3_tb = DUT.valid_stage3;

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
		X_tb <= 64'h 1234_5678_abcd_ef01;
	
		#200 RstN_tb <= 0;
		#10 RstN_tb <= 1;
		X_tb <= 64'h fedc_ba09_8765_4321;
		
		#200 $finish;
	end

endmodule
