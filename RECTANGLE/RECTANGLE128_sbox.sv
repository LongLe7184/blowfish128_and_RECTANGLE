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

//4x4 Inv-SBox
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

/* Substitution Layer consists of 16 4x4 SBoxes
*  - ENCRYPT: Using 16 4x4 SBoxes
*  - DECRYPT: Using 16 4x4 Inv-SBoxes
* */

function logic [63:0] rectangle128_16cols_substitution (input [63:0] data_in, input Encrypt);
	logic [3:0] so0, so1, so2, so3, so4, so5, so6, so7;
	logic [3:0] so8, so9, so10, so11, so12, so13, so14, so15;
	//Column Substitution
	assign so0 = (Encrypt) ? rectangle128_sbox	( {data_in[48], data_in[32], data_in[16], data_in[0]} ) :
				 rectangle128_inv_sbox	( {data_in[48], data_in[32], data_in[16], data_in[0]} );
	assign so1 = (Encrypt) ? rectangle128_sbox	( {data_in[49], data_in[33], data_in[17], data_in[1]} ) :
				 rectangle128_inv_sbox	( {data_in[49], data_in[33], data_in[17], data_in[1]} );
	assign so2 = (Encrypt) ? rectangle128_sbox	( {data_in[50], data_in[34], data_in[18], data_in[2]} ) :
				 rectangle128_inv_sbox	( {data_in[50], data_in[34], data_in[18], data_in[2]} );
	assign so3 = (Encrypt) ? rectangle128_sbox	( {data_in[51], data_in[35], data_in[19], data_in[3]} ) :
				 rectangle128_inv_sbox	( {data_in[51], data_in[35], data_in[19], data_in[3]} );
	assign so4 = (Encrypt) ? rectangle128_sbox	( {data_in[52], data_in[36], data_in[20], data_in[4]} ) :
				 rectangle128_inv_sbox	( {data_in[52], data_in[36], data_in[20], data_in[4]} );
	assign so5 = (Encrypt) ? rectangle128_sbox	( {data_in[53], data_in[37], data_in[21], data_in[5]} ) :
				 rectangle128_inv_sbox	( {data_in[53], data_in[37], data_in[21], data_in[5]} );
	assign so6 = (Encrypt) ? rectangle128_sbox	( {data_in[54], data_in[38], data_in[22], data_in[6]} ) :
				 rectangle128_inv_sbox	( {data_in[54], data_in[38], data_in[22], data_in[6]} );
	assign so7 = (Encrypt) ? rectangle128_sbox	( {data_in[55], data_in[39], data_in[23], data_in[7]} ) :
				 rectangle128_inv_sbox	( {data_in[55], data_in[39], data_in[23], data_in[7]} );
	assign so8 = (Encrypt) ? rectangle128_sbox	( {data_in[56], data_in[40], data_in[24], data_in[8]} ) :
				 rectangle128_inv_sbox	( {data_in[56], data_in[40], data_in[24], data_in[8]} );
	assign so9 = (Encrypt) ? rectangle128_sbox	( {data_in[57], data_in[41], data_in[25], data_in[9]} ) :
				 rectangle128_inv_sbox	( {data_in[57], data_in[41], data_in[25], data_in[9]} );
	assign so10 = (Encrypt) ? rectangle128_sbox	( {data_in[58], data_in[42], data_in[26], data_in[10]} ) :
				 rectangle128_inv_sbox	( {data_in[58], data_in[42], data_in[26], data_in[10]} );
	assign so11 = (Encrypt) ? rectangle128_sbox	( {data_in[59], data_in[43], data_in[27], data_in[11]} ) :
				 rectangle128_inv_sbox	( {data_in[59], data_in[43], data_in[27], data_in[11]} );
	assign so12 = (Encrypt) ? rectangle128_sbox	( {data_in[60], data_in[44], data_in[28], data_in[12]} ) :
				 rectangle128_inv_sbox	( {data_in[60], data_in[44], data_in[28], data_in[12]} );
	assign so13 = (Encrypt) ? rectangle128_sbox	( {data_in[61], data_in[45], data_in[29], data_in[13]} ) :
				 rectangle128_inv_sbox	( {data_in[61], data_in[45], data_in[29], data_in[13]} );
	assign so14 = (Encrypt) ? rectangle128_sbox	( {data_in[62], data_in[46], data_in[30], data_in[14]} ) :
				 rectangle128_inv_sbox	( {data_in[62], data_in[46], data_in[30], data_in[14]} );
	assign so15 = (Encrypt) ? rectangle128_sbox	( {data_in[63], data_in[47], data_in[31], data_in[15]} ) :
				 rectangle128_inv_sbox	( {data_in[63], data_in[47], data_in[31], data_in[15]} );
	//Output
	assign rectangle128_16cols_substitution = {
		so15[3], so14[3], so13[3], so12[3], so11[3], so10[3], so9[3], so8[3], so7[3], so6[3], so5[3], so4[3], so3[3], so2[3], so1[3], so0[3], 
		so15[2], so14[2], so13[2], so12[2], so11[2], so10[2], so9[2], so8[2], so7[2], so6[2], so5[2], so4[2], so3[2], so2[2], so1[2], so0[2], 
		so15[1], so14[1], so13[1], so12[1], so11[1], so10[1], so9[1], so8[1], so7[1], so6[1], so5[1], so4[1], so3[1], so2[1], so1[1], so0[1], 
		so15[0], so14[0], so13[0], so12[0], so11[0], so10[0], so9[0], so8[0], so7[0], so6[0], so5[0], so4[0], so3[0], so2[0], so1[0], so0[0]
		};
endfunction: rectangle128_16cols_substitution

`endif
