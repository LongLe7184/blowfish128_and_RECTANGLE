//-----------------------------------------------------------
// Function: IBR128's Adder
//-----------------------------------------------------------
// Author	: Long Le, Manh Nguyen
// Date  	: April-5th, 2025
// Description	: 64-bit Pipeline Adder (use for CTR mode)
//-----------------------------------------------------------

module IBR128_adder(
	input Clk,
	input RstN,
	input Enable,
	input [63:0] A,
	input [63:0] B,
	output [63:0] S
	);

	reg [15:0] sum_stage1, sum_stage2, sum_stage3, sum_stage4;
	reg carry_stage1, carry_stage2, carry_stage3;

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
			sum_stage4 <= 16'b0;
		end else if(Enable) begin
			sum_stage4 <= A[63:48] + B[63:48] + carry_stage3;
		end
	end

	assign S = {sum_stage4, sum_stage3, sum_stage2, sum_stage1};

endmodule
