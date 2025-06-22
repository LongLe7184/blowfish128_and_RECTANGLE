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
	input Encrypt,
	input  [127:0] plainText,
	output [127:0] cipherText,
	output cipherReady,
	//skeygen interface signals
	input skey_ready,
	input [31:0] P1, P2, P3, P4, P5,
	input [31:0] P6, P7, P8, P9, P10,
	input [31:0] P11, P12, P13, P14, P15,
	input [31:0] P16, P17, P18, P19, P20,
	//ffunc interface signals
	input [63:0] Y,
	input ffunc_ready,
	output reg [63:0] X,
	output reg ffunc_enable
	);

	parameter [1:0] INITIAL = 2'b00;
	parameter [1:0] FEISTEL = 2'b01;
	parameter [1:0] PROCESS = 2'b10;
	parameter [1:0] STANDBY = 2'b11;	

	reg [1:0] step, next_step;
	
	reg [3:0] rCounter;
	reg [63:0] lH, rH;
	wire [63:0] PArr [7:0];

	assign PArr[0] = (!skey_ready)  ? 64'h0    :
			 (Encrypt)	? {P1, P2} : {P19, P20};
	assign PArr[1] = (!skey_ready)  ? 64'h0    :
			 (Encrypt)	? {P3, P4} : {P17, P18};
	assign PArr[2] = (!skey_ready)  ? 64'h0    :
			 (Encrypt)	? {P5, P6} : {P15, P16};
	assign PArr[3] = (!skey_ready)  ? 64'h0    :
			 (Encrypt)	? {P7, P8} : {P13, P14};
	assign PArr[4] = (!skey_ready)  ? 64'h0    :
			 (Encrypt)	? {P9, P10} : {P11, P12};
	assign PArr[5] = (!skey_ready)  ? 64'h0    :
			 (Encrypt)	? {P11, P12} : {P9, P10};
	assign PArr[6] = (!skey_ready)  ? 64'h0    :
			 (Encrypt)	? {P13, P14} : {P7, P8};
	assign PArr[7] = (!skey_ready)  ? 64'h0    :
			 (Encrypt)	? {P15, P16} : {P5, P6};
	
	//State transition
	always @(posedge Clk or negedge RstN or negedge Enable) begin
		if(!RstN | !Enable) begin
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

	always @(posedge Clk or negedge RstN or negedge Enable) begin
		if(!RstN | !Enable) begin
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
						if(rCounter != 4'b1000) begin
							if(!ffunc_ready) begin
								ffunc_enable <= 1'b1;
								X <= lH ^ PArr[rCounter];
							end else begin
								lH <= rH ^ Y;
								rH <= X;
								rCounter <= rCounter + 1'b1;
								ffunc_enable <= 1'b0;
							end
						end else begin
							lH <= rH;
							rH <= lH;
						end
					end
					PROCESS: begin
						if(Encrypt) begin
							lH <= lH ^ ({P19, P20});
							rH <= rH ^ ({P17, P18});
						end else begin
							lH <= lH ^ ({P1, P2});
							rH <= rH ^ ({P3, P4});
						end
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
	assign cipherReady = (step == STANDBY)? 1'b1 : 1'b0;

endmodule
