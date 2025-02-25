//-----------------------------------------------------------
// Module: Blowfish-128's Core Module
//-----------------------------------------------------------
// Author	: Long Le, Manh Nguyen
// Date  	: Feb-16th, 2025
// Description	: Blowfish128's core module, perform encrypting process
//-----------------------------------------------------------

module blowfish128_core(
	input Clk,
	input RstN,
	input Enable,
	input logic  [127:0] plainText,
	output logic [127:0] cipherText,
	output logic cipherReady,
	//skeygen interface signals
	input logic skey_ready,
	input logic [31:0] P1, P2, P3, P4, P5,
	input logic [31:0] P6, P7, P8, P9, P10,
	input logic [31:0] P11, P12, P13, P14, P15,
	input logic [31:0] P16, P17, P18, P19, P20,
	//ffunc interface signals
	input logic [63:0] Y,
	input logic ffunc_ready,
	output logic [63:0] X,
	output logic ffunc_enable
	);

	typedef enum logic [1:0] {
		INITIAL,
		FEISTEL,
		PROCESS,
		STANDBY
	} step_t;
	
	step_t step, next_step;
	
	// logic [1:0] step;
	logic [3:0] rCounter;
	logic [63:0] lH, rH;
	logic [63:0] PArr [7:0];

	assign PArr[0] = (skey_ready) ? {P1, P2} : 64'h0;
	assign PArr[1] = (skey_ready) ? {P3, P4} : 64'h0;
	assign PArr[2] = (skey_ready) ? {P5, P6} : 64'h0;
	assign PArr[3] = (skey_ready) ? {P7, P8} : 64'h0;
	assign PArr[4] = (skey_ready) ? {P9, P10} : 64'h0;
	assign PArr[5] = (skey_ready) ? {P11, P12} : 64'h0;
	assign PArr[6] = (skey_ready) ? {P13, P14} : 64'h0;
	assign PArr[7] = (skey_ready) ? {P15, P16} : 64'h0;

	//State transition
	always @(posedge Clk or negedge RstN) begin
		if(~RstN) begin
			step <= INITIAL;
		end else begin
			step <= next_step;
		end
	end

	//Next state
	always @(RstN or step or skey_ready or rCounter) begin
		next_step = step;
		case(step)
			INITIAL: if(skey_ready) 	 next_step = FEISTEL;
			FEISTEL: if(rCounter == 4'b1000) next_step = PROCESS;
			PROCESS: 			 next_step = STANDBY;
			STANDBY: 			 next_step = STANDBY;
		endcase
	end

	always @(posedge Clk or negedge RstN) begin
		if(~RstN) begin
			rCounter <= 4'b0;
			lH <= 64'b0;
			rH <= 64'b0;
			ffunc_enable <= 1'b0;
		end else begin
			if(Enable) begin
				case(step)
					INITIAL: begin
						lH <= plainText[127:64];
						rH <= plainText[63:0];
					end
					FEISTEL: begin
						if(~ffunc_ready) begin
							ffunc_enable <= 1'b1;
							X <= lH ^ PArr[rCounter];
						end else begin
							lH <= rH ^ Y;
							rH <= X;
							rCounter <= rCounter + 1'b1;
							ffunc_enable <= 1'b0;
						end
						if(rCounter == 4'b1000) begin
							lH <= rH;
							rH <= lH;
						end
					end
					PROCESS: begin
						lH <= lH ^ ({P19, P20});
						rH <= rH ^ ({P17, P18});
					end
					STANDBY: begin
						//RESERVERD STATE
						//Done Encrypting
					end
				endcase
			end
		end
	end

	assign cipherText = {lH, rH};
	assign cipherReady = (step == STANDBY)? 1 : 0;

endmodule
