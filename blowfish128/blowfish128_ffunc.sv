//-----------------------------------------------------------
// Module: Blowfish-128's F-function Module
//-----------------------------------------------------------
// Author	: Long Le, Manh Nguyen
// Date  	: Feb-8th, 2025
// Description	: F-function module used in encrypting process
//-----------------------------------------------------------

/* USING NOTE:
*  This module reset state is trigger by Global ResetN (IP Reset signal) OR
*  the Enable control signal from Feistel rounds. Reset is REQUIRE to clear
*  previous values storing in this module and start the state machine (IDLE
*  phase).
* */

`include "blowfish128_sbox.sv"

module blowfish128_ffunc(
	input Clk,
	input RstN,
	input Enable,
	input logic [63:0] X,
	output logic [63:0] Y,
	output logic outputValid
	);

	logic [127:0] SBox1, SBox2;
	logic [31:0] S1a, S1b, S1c, S1d, S2e, S2f, S2g, S2h;
	logic [31:0] res1H, res1L, res2H, res2L, res3H, res3L;
	logic valid_stage1, valid_stage2, valid_stage3;

	typedef enum logic [1:0] {
		IDLE,
		XOR_F,
		ADD,
		XOR_S
	} state_t;

	state_t state;
	
	//State transition
	always @(posedge Clk or negedge RstN or negedge Enable) begin
		if(!RstN | !Enable) begin
			state <= IDLE;
		end else begin
			case(state)
				IDLE: 	state <= XOR_F;
				XOR_F: 	state <= ADD;
				ADD: 	state <= XOR_S;
				XOR_S: 	state <= XOR_S;
			endcase
		end
	end

	//Substitution and Rotation
	assign SBox1[127:96] = blowfish128_sbox1(X[63:56]);
	assign SBox1[95:64]  = blowfish128_sbox1({X[48], X[55:49]});
	assign SBox1[63:32]  = blowfish128_sbox1(X[47:40]);
	assign SBox1[31:0]   = blowfish128_sbox1({X[32], X[39:33]});
	assign SBox2[127:96] = blowfish128_sbox2({X[24], X[31:25]});
	assign SBox2[95:64]  = blowfish128_sbox2(X[23:16]);
	assign SBox2[63:32]  = blowfish128_sbox2({X[8], X[15:9]});
	assign SBox2[31:0]   = blowfish128_sbox2(X[7:0]);
	
	assign S1a = {SBox1[96], SBox1[127:97]};
	assign S1b = SBox1[95:64];
	assign S1c = {SBox1[32], SBox1[63:33]};
	assign S1d = SBox1[31:0];
	assign S2e = SBox2[127:96];
	assign S2f = {SBox2[94:64], SBox2[95]};
	assign S2g = SBox2[63:32];
	assign S2h = {SBox2[30:0], SBox2[31]};
	
	always @(posedge Clk or negedge RstN or negedge Enable) begin
		if(!RstN | !Enable) begin
			//XOR-FIRST STEP
			res1H <= 32'b0;
			res1L <= 32'b0;
			valid_stage1 <= 1'b0;
			//ADD STEP
			res2H <= 32'b0;
			res2L <= 32'b0;
			valid_stage2 = 1'b0;
			//XOR-SECOND STEP
			res3H <= 32'b0;
			res3L <= 32'b0;
			valid_stage3 <= 1'b0;
		end else begin
			case(state)
				//XOR-first step
				XOR_F: begin
					if(Enable) begin
						res1H <= S1a ^ S1b;
						res1L <= S2e ^ S2f;
						valid_stage1 <= 1'b1;
					end
				end
				//ADD step
				ADD: begin
					if(Enable & valid_stage1) begin
						res2H <= res1H + S1c;
						res2L <= res1L + S2g;
						valid_stage2 <= 1'b1;
					end
				end
				//XOR-second step
				XOR_S: begin
					if(Enable & valid_stage2) begin
						res3H <= res2H ^ S1d;
						res3L <= res2L ^ S2h;
						valid_stage3 <= 1'b1;
					end
				end
			endcase
		end
	end

	assign outputValid = valid_stage3;
	assign Y = {res3H, res3L};

endmodule
