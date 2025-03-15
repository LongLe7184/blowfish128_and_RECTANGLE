//-----------------------------------------------------------
// Function: REACTANGLE128's Core Module
//-----------------------------------------------------------
// Author	: Long Le, Manh Nguyen
// Date  	: Mar-12th, 2025
// Description	: Perform encrypting/decrypting process 
//-----------------------------------------------------------

`include "RECTANGLE128_sbox.sv"
`include "RECTANGLE128_per.sv"

module RECTANGLE128_core(
	input Clk,
	input RstN,
	input Enable,
	input Encrypt,
	input [63:0] plainText,
	output [63:0] cipherText,
	output cipherReady,
	//skeymem interface signals
	input skey_ready,
	input [63:0] roundKey,
	output [4:0] RAddr
	);

	logic [4:0] round_counter;

	always @(posedge Clk or negedge RstN or negedge Enable) begin
		if(!RstN | !Enable) begin
			round_counter <= 5'b0;
		end else if (Enable & skey_ready) begin
			if(round_counter != 5'd27)
				round_counter <= round_counter + 1'b1;
		end
	end
	
	logic [4:0] RAddr_reg;
	logic [63:0] round_text;
	logic [63:0] sub_in, rot_in;
	logic [63:0] sub_text, rot_text;
	
	assign sub_in = (Encrypt) ? round_text : 64'h0;
	assign rot_in = (Encrypt) ? 64'h0      : round_text;

	assign sub_text = (Encrypt) ? rectangle128_16cols_substitution(sub_in, 1'b1) :
				      rectangle128_16cols_substitution(rot_text, 1'b0);
	assign rot_text = (Encrypt) ? rectangle128_permutation(sub_text, 1'b1) :
				      rectangle128_permutation(rot_in, 1'b0);

	always @(posedge Clk or negedge RstN or negedge Enable) begin
		if(!RstN | !Enable) begin
			round_text <= 64'b0;
			RAddr_reg <= 5'b0;
		end else begin
			if(Enable & skey_ready) begin
				RAddr_reg <= (Encrypt) ? round_counter : (5'd25 - round_counter);
				if(round_counter != 5'd00) begin
					if(round_counter == 5'd01) begin
						round_text <= plainText ^ roundKey;
					end else if(round_counter < 5'd27) begin
						round_text <= (Encrypt) ? (rot_text ^ roundKey) : (sub_text ^ roundKey);
					end else if(round_counter == 5'd27) begin
						round_text <= round_text;
					end
				end
			end
		end
	end

	assign RAddr = RAddr_reg;
	assign cipherText = round_text;
	assign cipherReady = (round_counter == 5'd27) ? 1'b1 : 1'b0;

endmodule
