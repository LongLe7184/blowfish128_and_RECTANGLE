//-----------------------------------------------------------
// Function: RECTANGLE128's Substitution Layer
//-----------------------------------------------------------
// Author	: Long Le, Manh Nguyen
// Date  	: Mar-9th, 2025
// Description	: Contains Substitution & Inv-Substitution 4x4 SBoxes
//-----------------------------------------------------------

`ifndef RECTANGLE128_SBOX
`define RECTANGLE128_SBOX

//4x4 SBox
module rectangle128_sbox(
	input [3:0] sbox_in,
	output reg [3:0] sbox_out
	);

	always @(*) begin
		case(sbox_in[3:0])
			4'h0: sbox_out = 4'h6;
			4'h1: sbox_out = 4'h5;
			4'h2: sbox_out = 4'hC;
			4'h3: sbox_out = 4'hA;
			4'h4: sbox_out = 4'h1;
			4'h5: sbox_out = 4'hE;
			4'h6: sbox_out = 4'h7;
			4'h7: sbox_out = 4'h9;
			4'h8: sbox_out = 4'hB;
			4'h9: sbox_out = 4'h0;
			4'hA: sbox_out = 4'h3;
			4'hB: sbox_out = 4'hD;
			4'hC: sbox_out = 4'h8;
			4'hD: sbox_out = 4'hF;
			4'hE: sbox_out = 4'h4;
			4'hF: sbox_out = 4'h2;
		endcase
	end
endmodule 

//4x4 Inv-SBox
module rectangle128_inv_sbox(
	input [3:0] sbox_in,
	output reg [3:0] sbox_out
	);

	always @(*) begin
		case(sbox_in[3:0])
			4'h0: sbox_out = 4'h9;
			4'h1: sbox_out = 4'h4;
			4'h2: sbox_out = 4'hF;
			4'h3: sbox_out = 4'hA;
			4'h4: sbox_out = 4'hE;
			4'h5: sbox_out = 4'h1;
			4'h6: sbox_out = 4'h0;
			4'h7: sbox_out = 4'h6;
			4'h8: sbox_out = 4'hC;
			4'h9: sbox_out = 4'h7;
			4'hA: sbox_out = 4'h3;
			4'hB: sbox_out = 4'h8;
			4'hC: sbox_out = 4'h2;
			4'hD: sbox_out = 4'hB;
			4'hE: sbox_out = 4'h5;
			4'hF: sbox_out = 4'hD;
		endcase
	end
	endmodule

`endif
