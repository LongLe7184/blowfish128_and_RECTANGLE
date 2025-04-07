//-----------------------------------------------------------
// Function: IBR128's Adder
//-----------------------------------------------------------
// Author	: Long Le, Manh Nguyen
// Date  	: April-5th, 2025
// Description	: 128-bit Pipeline Adder (use for CTR mode)
//-----------------------------------------------------------

module IBR128_adder(
	input Clk,
	input RstN,
	input Enable,
	input logic [127:0] A,
	input logic [127:0] B,
	output logic [127:0] S
	);

	logic [15:0] sum_stage1, sum_stage2, sum_stage3, sum_stage4, sum_stage5, sum_stage6, sum_stage7, sum_stage8;
	logic carry_stage1, carry_stage2, carry_stage3, carry_stage4, carry_stage5, carry_stage6, carry_stage7;

	always @(posedge Clk or negedge RstN) begin
		if(!RstN) begin
			carry_stage1 <= 1'b0;
			sum_stage1 <= 16'b0;
		end else if(Enable) begin
			{carry_stage1, sum_stage1} <= A[15:0] + B[15:0];
		end
	end

	always @(posedge Clk or negedge RstN) begin
		if(!RstN) begin
			carry_stage2 <= 1'b0;
			sum_stage2 <= 16'b0;
		end else if(Enable) begin
			{carry_stage2, sum_stage2} <= A[31:16] + B[31:16] + carry_stage1;
		end
	end

	always @(posedge Clk or negedge RstN) begin
		if(!RstN) begin
			carry_stage3 <= 1'b0;
			sum_stage3 <= 16'b0;
		end else if(Enable) begin
			{carry_stage3, sum_stage3} <= A[47:32] + B[47:32] + carry_stage2;
		end
	end

	always @(posedge Clk or negedge RstN) begin
		if(!RstN) begin
			carry_stage4 <= 1'b0;
			sum_stage4 <= 16'b0;
		end else if(Enable) begin
			{carry_stage4, sum_stage4} <= A[63:48] + B[63:48] + carry_stage3;
		end
	end

	always @(posedge Clk or negedge RstN) begin
		if(!RstN) begin
			carry_stage5 <= 1'b0;
			sum_stage5 <= 16'b0;
		end else if(Enable) begin
			{carry_stage5, sum_stage5} <= A[79:64] + B[79:64] + carry_stage4;
		end
	end

	always @(posedge Clk or negedge RstN) begin
		if(!RstN) begin
			carry_stage6 <= 1'b0;
			sum_stage6 <= 16'b0;
		end else if(Enable) begin
			{carry_stage6, sum_stage6} <= A[95:80] + B[95:80] + carry_stage5;
		end
	end

	always @(posedge Clk or negedge RstN) begin
		if(!RstN) begin
			carry_stage7 <= 1'b0;
			sum_stage7 <= 16'b0;
		end else if(Enable) begin
			{carry_stage7, sum_stage7} <= A[111:96] + B[111:96] + carry_stage6;
		end
	end

	always @(posedge Clk or negedge RstN) begin
		if(!RstN) begin
			sum_stage8 <= 16'b0;
		end else if(Enable) begin
			sum_stage8 <= A[127:112] + B[127:112] + carry_stage7;
		end
	end

	assign S = {sum_stage8, sum_stage7, sum_stage6, sum_stage5, sum_stage4, sum_stage3, sum_stage2, sum_stage1};

endmodule
