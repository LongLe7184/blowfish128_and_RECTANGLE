//-----------------------------------------------------------
// Function: IBR128 Op. Mode Sub-Module
//-----------------------------------------------------------
// Author	: Long Le, Manh Nguyen
// Date  	: April-5th, 2025
// Description	: Implements 3 Block Cipher Operation Mode: CBC, OFB, CTR
// 		  - CBC: Cipher Block Chaining
// 		  - OFB: Output Feedback Mode
// 		  - CTR: Counter Mode
//-----------------------------------------------------------

module IBR128_opmode(
	input Clk,
	input RstN,
	input Enable,
	input Encrypt,
	input [1:0] SOM,
	input FB,
	//Encrypt Input
	input [127:0] plainText,
	input SA,
	input [127:0] IV,
	//Encrypt Output
	output [127:0] cipherText,
	output cipherReady,
	//Internal Signal
	output reg encrypt,
	output reg block_start,
	output reg [127:0] pData,
	output reg sa,
	input block_ready,
	input [127:0] eData
	);

	// Operation mode parameters
	parameter [1:0] NONE = 2'b00;
	parameter [1:0] CBC  = 2'b01;
	parameter [1:0] OFB  = 2'b10;
	parameter [1:0] CTR  = 2'b11;

	wire [1:0] modeSel;
	assign modeSel = (SOM == 2'h1) ? CBC :
			 (SOM == 2'h2) ? OFB :
			 (SOM == 2'h3) ? CTR : NONE;
	
	reg [127:0] nextBlock_input;
	wire [127:0] ctr;
	reg [127:0] cipherText_reg;
	reg cipherReady_reg;
	wire adder_en;
	reg cbc_flag;

	assign adder_en = (block_start && !block_ready && (modeSel == CTR)) ? 1'b1 : 1'b0;

	IBR128_adder IBR128_adder1(
		.Clk(Clk),
		.RstN(RstN),
		.Enable(adder_en),
		.A(nextBlock_input[127:64]),
		.B(64'b1),
		.S(ctr[127:64])
	);

	IBR128_adder IBR128_adder2(
		.Clk(Clk),
		.RstN(RstN),
		.Enable(adder_en),
		.A(nextBlock_input[63:0]),
		.B(64'b1),
		.S(ctr[63:0])
	);

	always @(posedge Clk or negedge RstN or negedge Enable) begin
		if(!RstN | !Enable) begin
			encrypt <= 1'b0;
			block_start <= 1'b0;
			pData <= 128'b0;
			sa <= 1'b0;
			cipherText_reg <= 128'b0;
			cipherReady_reg <= 1'b0;
			cbc_flag <= 1'b0;
		end else if (Enable) begin
			case(modeSel)
				//CBC BCOM Implementation
				CBC: begin
					if(!block_ready) begin
						nextBlock_input <= (FB) ? IV : nextBlock_input;
						encrypt <= Encrypt;
						block_start <= 1'b1;
						pData <= (Encrypt) ? (nextBlock_input ^ plainText) : plainText;
						sa <= SA;	
					end else begin
						nextBlock_input <= (Encrypt) ? eData : plainText;
						if(!cbc_flag) begin
							cipherText_reg <= (Encrypt) ? eData : (eData ^ nextBlock_input);
							cbc_flag <= 1'b1;
						end
						cipherReady_reg <= block_ready;
					end
				end
				//OFB BCOM Implementation
				OFB: begin
					if(!block_ready) begin
						nextBlock_input <= (FB) ? IV : nextBlock_input;
						encrypt <= 1'b1;
						block_start <= 1'b1;
						pData <= nextBlock_input;
						sa <= SA;
					end else begin
						nextBlock_input <= eData;
						cipherText_reg <= eData ^ plainText;
						cipherReady_reg <= block_ready;
					end
				end
				//CTR BCOM Implementation
				CTR: begin
					if(!block_ready) begin
						nextBlock_input <= (FB) ? IV : nextBlock_input;
						encrypt <= 1'b1;
						block_start <= 1'b1;
						pData <= nextBlock_input;
						sa <= SA;
					end else begin
						nextBlock_input <= ctr;
						cipherText_reg <= eData ^ plainText;
						cipherReady_reg <= block_ready;
					end
				end
			endcase
		end
	end

	assign cipherText = cipherText_reg;
	assign cipherReady = cipherReady_reg;

endmodule
