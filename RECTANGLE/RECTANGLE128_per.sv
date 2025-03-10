//-----------------------------------------------------------
// Function: RECTANGLE128's Permutation Layer
//-----------------------------------------------------------
// Author	: Long Le, Manh Nguyen
// Date  	: Mar-9th, 2025
// Description	: Contains Permutation & Inv-Permutation
//-----------------------------------------------------------

`ifndef RECTANGLE128_PERMUTATION
`define RECTANGLE128_PERMUTATION

//Contain Rotate Left Operations
function logic [63:0] rectangle128_permutation(input [63:0] data_in);
	assign rectangle128_permutation = { data_in[15:0], 
					  { data_in[30:16], data_in[31] },
					  { data_in[35:32], data_in[47:36] },
					  { data_in[50:48], data_in[63:51] }
					  };	
endfunction: rectangle128_permutation 

//Contain Rotate Left Operations
function logic [63:0] rectangle128_inv_permutation(input [63:0] data_in);
	assign rectangle128_inv_permutation = { data_in[15:0], 
					      { data_in[16], data_in[31:17] },
					      { data_in[43:32], data_in[47:44] },
					      { data_in[60:48], data_in[63:61] }
					      };	
endfunction: rectangle128_inv_permutation

`endif
