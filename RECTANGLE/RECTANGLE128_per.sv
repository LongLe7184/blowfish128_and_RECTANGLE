//-----------------------------------------------------------
// Function: RECTANGLE128's Permutation Layer
//-----------------------------------------------------------
// Author	: Long Le, Manh Nguyen
// Date  	: Mar-9th, 2025
// Description	: Contains Permutation & Inv-Permutation
//-----------------------------------------------------------

`ifndef RECTANGLE128_PERMUTATION
`define RECTANGLE128_PERMUTATION

/* Permutation Layer with Rotations
*  - ENCRYPT: Left Rot. [row3, row2, row1, row0] with [13, 12 , 1, 0] times
*  - DECRYPT: Right Rot. [row3, row2, row1, row0] with [13, 12 , 1, 0] times
* */

function logic [63:0] rectangle128_permutation(input [63:0] data_in, input Encrypt);
	assign rectangle128_permutation = (Encrypt) ? { { data_in[50:48], data_in[63:51] },
							{ data_in[35:32], data_in[47:36] },
							{ data_in[30:16], data_in[31] },
							{ data_in[15:0] }
						      } :
						      { { data_in[60:48], data_in[63:61] },
						      	{ data_in[43:32], data_in[47:44] },
							{ data_in[16], data_in[31:17] },
							{ data_in[15:0] }
						      };
endfunction: rectangle128_permutation 

`endif
