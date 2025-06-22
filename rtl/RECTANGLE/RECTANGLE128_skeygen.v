//-----------------------------------------------------------
// Function: REACTANGLE128's Skeygen Module
//-----------------------------------------------------------
// Author	: Long Le, Manh Nguyen
// Date  	: Mar-9th, 2025
// Description	: Generating Sub-Keys base on Key Schedule
//-----------------------------------------------------------

module RECTANGLE128_skeygen(
	input Clk,
	input RstN,
	input Enable,
	input [63:0] key0,
	input [63:0] key1,
	//Local memory interface signals
	output flush,
	output WE,
	output [4:0] WAddr,
	output [63:0] KeyIn
	);

	function [3:0] rectangle128_sbox;
		input [3:0] sbox_in;
		begin
			case(sbox_in[3:0])
				4'h0: rectangle128_sbox = 4'h6;
				4'h1: rectangle128_sbox = 4'h5;
				4'h2: rectangle128_sbox = 4'hC;
				4'h3: rectangle128_sbox = 4'hA;
				4'h4: rectangle128_sbox = 4'h1;
				4'h5: rectangle128_sbox = 4'hE;
				4'h6: rectangle128_sbox = 4'h7;
				4'h7: rectangle128_sbox = 4'h9;
				4'h8: rectangle128_sbox = 4'hB;
				4'h9: rectangle128_sbox = 4'h0;
				4'hA: rectangle128_sbox = 4'h3;
				4'hB: rectangle128_sbox = 4'hD;
				4'hC: rectangle128_sbox = 4'h8;
				4'hD: rectangle128_sbox = 4'hF;
				4'hE: rectangle128_sbox = 4'h4;
				4'hF: rectangle128_sbox = 4'h2;
			endcase
		end
	endfunction
	wire [4:0] RC [25:1];
	
	assign RC[1] = 5'h01;
	assign RC[2] = 5'h02;
	assign RC[3] = 5'h04;
	assign RC[4] = 5'h09;
	assign RC[5] = 5'h12;

	assign RC[6] = 5'h05;
	assign RC[7] = 5'h0B;
	assign RC[8] = 5'h16;
	assign RC[9] = 5'h0C;
	assign RC[10] = 5'h19;

	assign RC[11] = 5'h13;
	assign RC[12] = 5'h07;
	assign RC[13] = 5'h0F;
	assign RC[14] = 5'h1F;
	assign RC[15] = 5'h1E;
	
	assign RC[16] = 5'h1C;
	assign RC[17] = 5'h18;
	assign RC[18] = 5'h11;
	assign RC[19] = 5'h03;
	assign RC[20] = 5'h06;

	assign RC[21] = 5'h0D;
	assign RC[22] = 5'h1B;
	assign RC[23] = 5'h17;
	assign RC[24] = 5'h0E;
	assign RC[25] = 5'h1D;

	reg [31:0] ini_row0, ini_row1, ini_row2, ini_row3;

	wire [3:0] sbox_out0, sbox_out1, sbox_out2, sbox_out3, sbox_out4, sbox_out5, sbox_out6, sbox_out7;
	
	//Column Substitution
	assign sbox_out0 = rectangle128_sbox( {ini_row3[0], ini_row2[0], ini_row1[0], ini_row0[0]} );
	assign sbox_out1 = rectangle128_sbox( {ini_row3[1], ini_row2[1], ini_row1[1], ini_row0[1]} );
	assign sbox_out2 = rectangle128_sbox( {ini_row3[2], ini_row2[2], ini_row1[2], ini_row0[2]} );
	assign sbox_out3 = rectangle128_sbox( {ini_row3[3], ini_row2[3], ini_row1[3], ini_row0[3]} );
	assign sbox_out4 = rectangle128_sbox( {ini_row3[4], ini_row2[4], ini_row1[4], ini_row0[4]} );
	assign sbox_out5 = rectangle128_sbox( {ini_row3[5], ini_row2[5], ini_row1[5], ini_row0[5]} );
	assign sbox_out6 = rectangle128_sbox( {ini_row3[6], ini_row2[6], ini_row1[6], ini_row0[6]} );
	assign sbox_out7 = rectangle128_sbox( {ini_row3[7], ini_row2[7], ini_row1[7], ini_row0[7]} );

	wire [31:0] sub_row0, sub_row1, sub_row2, sub_row3;
	//Matrix Re-Arrangement
	assign sub_row0 = { ini_row0[31:8], sbox_out7[0], sbox_out6[0], sbox_out5[0], sbox_out4[0], sbox_out3[0], sbox_out2[0], sbox_out1[0], sbox_out0[0] }; 
	assign sub_row1 = { ini_row1[31:8], sbox_out7[1], sbox_out6[1], sbox_out5[1], sbox_out4[1], sbox_out3[1], sbox_out2[1], sbox_out1[1], sbox_out0[1] }; 
	assign sub_row2 = { ini_row2[31:8], sbox_out7[2], sbox_out6[2], sbox_out5[2], sbox_out4[2], sbox_out3[2], sbox_out2[2], sbox_out1[2], sbox_out0[2] }; 
	assign sub_row3 = { ini_row3[31:8], sbox_out7[3], sbox_out6[3], sbox_out5[3], sbox_out4[3], sbox_out3[3], sbox_out2[3], sbox_out1[3], sbox_out0[3] }; 

	wire [31:0] feistel_row0, feistel_row1, feistel_row2, feistel_row3;
	//Feistel Transformation
	assign feistel_row0 =  sub_row1 ^ {sub_row0[23:0], sub_row0[31:24]};
	assign feistel_row1 =  sub_row2;
	assign feistel_row2 =  sub_row3 ^ {sub_row2[15:0], sub_row2[31:16]};
	assign feistel_row3 =  sub_row0;

	reg [4:0] round_counter;

	always @(posedge Clk or negedge RstN) begin
		if(!RstN) begin
			round_counter <= 5'b0;
		end else if (RstN & Enable) begin
			if(round_counter != 5'd27)
				round_counter <= round_counter + 1'b1;
		end
	end

	always @(posedge Clk or negedge RstN) begin
		if(!RstN) begin
			ini_row0 <= 32'b0;
			ini_row1 <= 32'b0;
			ini_row2 <= 32'b0;
			ini_row3 <= 32'b0;
		end else begin
			if(Enable) begin
				if(round_counter == 5'd0) begin
					ini_row0 <= key0[31:0];
					ini_row1 <= key0[63:32];
					ini_row2 <= key1[31:0];
					ini_row3 <= key1[63:32];
				end else if (round_counter <= 5'd25) begin
					ini_row0 <= { feistel_row0[31:5], (feistel_row0[4:0] ^ RC[round_counter]) };
					ini_row1 <= feistel_row1;
					ini_row2 <= feistel_row2;
					ini_row3 <= feistel_row3;
				end
			end
		end
	end

	assign KeyIn = { ini_row3[15:0],
			 ini_row2[15:0],
			 ini_row1[15:0],
			 ini_row0[15:0] };

	assign WAddr = ((round_counter == 5'd0) || (round_counter == 5'd27)) ? 5'd0 : (round_counter - 1'b1);
	assign WE = ((round_counter == 5'd0) || (round_counter == 5'd27)) ? 1'b0 : 1'b1;
	
	//RESERVED: flush memory whenever input a new key
	assign flush = RstN;

endmodule
