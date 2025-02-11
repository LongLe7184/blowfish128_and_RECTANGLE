//-----------------------------------------------------------
// Function: Blowfish-128's F-function Module
//-----------------------------------------------------------
// Author	: Long Le, Manh Nguyen
// Date  	: Feb-8th, 2025
// Description	: F-function module used in encrypting process
//-----------------------------------------------------------

/* USING NOTE:
*  This module's RstN signal is trigger by Global ResetN (IP Reset signal) OR
*  the acknowledge signal from Feistel rounds. Reset is REQUIRE to clear
*  previous values storing in this module and begin the state machine (IDLE
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

	logic [7:0] a, b, c, d, e, f, g, h;
	logic [127:0] SBox1, SBox2;
	logic [31:0] S1a, S1b, S1c, S1d, S2e, S2f, S2g, S2h;
	logic [31:0] res1H, res1L, res2H, res2L, res3H, res3L;
	logic valid_stage, valid_stage0, valid_stage1, valid_stage2, valid_stage3;

	typedef enum logic [2:0] {
		IDLE,
		PREV_SBOX,
		AFTER_SBOX,
		XOR_F,
		ADD,
		XOR_S
	} state_t;

	state_t state, next_state;
	
	//State transition
	always @(posedge Clk or negedge RstN) begin
		if(~RstN) begin
			state <= IDLE;
		end else begin
			state <= next_state;
		end
	end

	//Next state
	always @(RstN or valid_stage or valid_stage0 or valid_stage1 or valid_stage2 or valid_stage3)begin
		next_state = state;
		case(state)
			IDLE: 		if(RstN) 	 next_state = PREV_SBOX;
			PREV_SBOX: 	if(valid_stage)  next_state = AFTER_SBOX;
			AFTER_SBOX: 	if(valid_stage0) next_state = XOR_F;
			XOR_F: 		if(valid_stage1) next_state = ADD;
			ADD: 		if(valid_stage2) next_state = XOR_S;
			XOR_S: 		if(valid_stage3) next_state = IDLE;
		endcase
	end

	assign SBox1[127:96] = blowfish128_sbox1(a);
	assign SBox1[95:64]  = blowfish128_sbox1(b);
	assign SBox1[63:32]  = blowfish128_sbox1(c);
	assign SBox1[31:0]   = blowfish128_sbox1(d);
	
	assign SBox2[127:96] = blowfish128_sbox2(e);
	assign SBox2[95:64]  = blowfish128_sbox2(f);
	assign SBox2[63:32]  = blowfish128_sbox2(g);
	assign SBox2[31:0]   = blowfish128_sbox2(h);
	
	always @(posedge Clk or negedge RstN) begin
		if(~RstN) begin
			//PREV_SBOX
			a <= 8'b0;
			b <= 8'b0;
			c <= 8'b0;
			d <= 8'b0;
			e <= 8'b0;
			f <= 8'b0;
			g <= 8'b0;
			h <= 8'b0;
			valid_stage <= 1'b0;
			//AFTER_SBOX
			S1a <= 32'b0;
			S1b <= 32'b0;
			S1c <= 32'b0;
			S1d <= 32'b0;
			S2e <= 32'b0;
			S2f <= 32'b0;
			S2g <= 32'b0;
			S2h <= 32'b0;
			valid_stage0 <= 1'b0;
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
				//Split and rotate S-Boxes inputs
				PREV_SBOX: begin
					if(Enable) begin
						a <= X[63:56];
						b <= {X[48], X[55:49]};
						c <= X[47:40];
						d <= {X[32], X[39:33]};
						e <= {X[24], X[31:25]};
						f <= X[23:16];
						g <= {X[8], X[15:9]};
						h <= X[7:0];
						valid_stage <= 1'b1;
					end
				end
				//Substitute and rotate S-Boxes outputs
				AFTER_SBOX: begin
					if(Enable & valid_stage) begin
						S1a <= {SBox1[96], SBox1[127:97]};
						S1b <= SBox1[95:64];
						S1c <= {SBox1[32], SBox1[63:33]};
						S1d <= SBox1[31:0];
						S2e <= SBox2[127:96];
						S2f <= {SBox2[94:64], SBox2[95]};
						S2g <= SBox2[63:32];
						S2h <= {SBox2[30:0], SBox2[31]};
						valid_stage0 <= 1'b1;
					end
				end
				//XOR-first step
				XOR_F: begin
					if(Enable & valid_stage0) begin
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
