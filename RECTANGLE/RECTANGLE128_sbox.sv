//-----------------------------------------------------------
// Function: RECTANGLE128's Substitution Layer
//-----------------------------------------------------------
// Author	: Long Le, Manh Nguyen
// Date  	: Mar-9th, 2025
// Description	: Contains Substitution & Inv-Substitution 4x4 SBoxes
//-----------------------------------------------------------

`ifndef RECTANGLE128_SBOX
`define RECTANGLE128_SBOX

function logic [3:0] rectangle128_sbox(input [3:0] sbox_in);
	case(sbox_in[3:0])
		4'h0: rectangle128_sbox[3:0] = 4'h6;
		4'h1: rectangle128_sbox[3:0] = 4'h5;
		4'h2: rectangle128_sbox[3:0] = 4'hC;
		4'h3: rectangle128_sbox[3:0] = 4'hA;
		4'h4: rectangle128_sbox[3:0] = 4'h1;
		4'h5: rectangle128_sbox[3:0] = 4'hE;
		4'h6: rectangle128_sbox[3:0] = 4'h7;
		4'h7: rectangle128_sbox[3:0] = 4'h9;
		4'h8: rectangle128_sbox[3:0] = 4'hB;
		4'h9: rectangle128_sbox[3:0] = 4'h0;
		4'hA: rectangle128_sbox[3:0] = 4'h3;
		4'hB: rectangle128_sbox[3:0] = 4'hD;
		4'hC: rectangle128_sbox[3:0] = 4'h8;
		4'hD: rectangle128_sbox[3:0] = 4'hF;
		4'hE: rectangle128_sbox[3:0] = 4'h4;
		4'hF: rectangle128_sbox[3:0] = 4'h2;
	endcase
endfunction: rectangle128_sbox 

function logic [3:0] rectangle128_inv_sbox(input [3:0] sbox_in);
	case(sbox_in[3:0])
		4'h0: rectangle128_inv_sbox[3:0] = 4'h9;
		4'h1: rectangle128_inv_sbox[3:0] = 4'h4;
		4'h2: rectangle128_inv_sbox[3:0] = 4'hF;
		4'h3: rectangle128_inv_sbox[3:0] = 4'hA;
		4'h4: rectangle128_inv_sbox[3:0] = 4'hE;
		4'h5: rectangle128_inv_sbox[3:0] = 4'h1;
		4'h6: rectangle128_inv_sbox[3:0] = 4'h0;
		4'h7: rectangle128_inv_sbox[3:0] = 4'h6;
		4'h8: rectangle128_inv_sbox[3:0] = 4'hC;
		4'h9: rectangle128_inv_sbox[3:0] = 4'h7;
		4'hA: rectangle128_inv_sbox[3:0] = 4'h3;
		4'hB: rectangle128_inv_sbox[3:0] = 4'h8;
		4'hC: rectangle128_inv_sbox[3:0] = 4'h2;
		4'hD: rectangle128_inv_sbox[3:0] = 4'hB;
		4'hE: rectangle128_inv_sbox[3:0] = 4'h5;
		4'hF: rectangle128_inv_sbox[3:0] = 4'hD;
	endcase
endfunction: rectangle128_inv_sbox 

`endif
