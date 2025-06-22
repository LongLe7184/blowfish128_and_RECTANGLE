//-----------------------------------------------------------
// Function: REACTANGLE128's Core Module
//-----------------------------------------------------------
// Author	: Long Le, Manh Nguyen
// Date  	: Mar-12th, 2025
// Description	: Perform encrypting/decrypting process 
//-----------------------------------------------------------

`include "RECTANGLE128_sbox.v"

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

	reg [63:0] round_text;
	wire [63:0] sub_in, rot_in;
	wire [63:0] sub_text, rot_text;
	
	assign sub_in = (Encrypt) ? round_text : 64'h0;
	assign rot_in = (Encrypt) ? 64'h0      : round_text;

	//SUBSTITUTION LAYER
	wire [3:0] so0, so1, so2, so3, so4, so5, so6, so7;
	wire [3:0] so8, so9, so10, so11, so12, so13, so14, so15;

	wire [3:0] so0_A, so1_A, so2_A, so3_A, so4_A, so5_A, so6_A, so7_A;
	wire [3:0] so8_A, so9_A, so10_A, so11_A, so12_A, so13_A, so14_A, so15_A;

	wire [3:0] so0_B, so1_B, so2_B, so3_B, so4_B, so5_B, so6_B, so7_B;
	wire [3:0] so8_B, so9_B, so10_B, so11_B, so12_B, so13_B, so14_B, so15_B;

	//Column Substitution
	rectangle128_sbox sbox0  ( .sbox_in ( { sub_in[48],  sub_in[32],  sub_in[16],  sub_in[0]}  ),
				   .sbox_out( so0_A  ) );
	rectangle128_sbox sbox1  ( .sbox_in ( { sub_in[49],  sub_in[33],  sub_in[17],  sub_in[1]}  ),
				   .sbox_out( so1_A  ) );
	rectangle128_sbox sbox2  ( .sbox_in ( { sub_in[50],  sub_in[34],  sub_in[18],  sub_in[2]}  ),
				   .sbox_out( so2_A  ) );
	rectangle128_sbox sbox3  ( .sbox_in ( { sub_in[51],  sub_in[35],  sub_in[19],  sub_in[3]}  ),
				   .sbox_out( so3_A  ) );
	rectangle128_sbox sbox4  ( .sbox_in ( { sub_in[52],  sub_in[36],  sub_in[20],  sub_in[4]}  ),
				   .sbox_out( so4_A  ) );
	rectangle128_sbox sbox5  ( .sbox_in ( { sub_in[53],  sub_in[37],  sub_in[21],  sub_in[5]}  ),
				   .sbox_out( so5_A  ) );
	rectangle128_sbox sbox6  ( .sbox_in ( { sub_in[54],  sub_in[38],  sub_in[22],  sub_in[6]}  ),
				   .sbox_out( so6_A  ) );
	rectangle128_sbox sbox7  ( .sbox_in ( { sub_in[55],  sub_in[39],  sub_in[23],  sub_in[7]}  ),
				   .sbox_out( so7_A  ) );
	rectangle128_sbox sbox8  ( .sbox_in ( { sub_in[56],  sub_in[40],  sub_in[24],  sub_in[8]}  ),
				   .sbox_out( so8_A  ) );
	rectangle128_sbox sbox9  ( .sbox_in ( { sub_in[57],  sub_in[41],  sub_in[25],  sub_in[9]}  ),
				   .sbox_out( so9_A  ) );
	rectangle128_sbox sbox10 ( .sbox_in ( { sub_in[58],  sub_in[42],  sub_in[26],  sub_in[10]} ),
				   .sbox_out( so10_A ) );
	rectangle128_sbox sbox11 ( .sbox_in ( { sub_in[59],  sub_in[43],  sub_in[27],  sub_in[11]} ),
				   .sbox_out( so11_A ) );
	rectangle128_sbox sbox12 ( .sbox_in ( { sub_in[60],  sub_in[44],  sub_in[28],  sub_in[12]} ),
				   .sbox_out( so12_A ) );
	rectangle128_sbox sbox13 ( .sbox_in ( { sub_in[61],  sub_in[45],  sub_in[29],  sub_in[13]} ),
				   .sbox_out( so13_A ) );
	rectangle128_sbox sbox14 ( .sbox_in ( { sub_in[62],  sub_in[46],  sub_in[30],  sub_in[14]} ),
				   .sbox_out( so14_A ) );
	rectangle128_sbox sbox15 ( .sbox_in ( { sub_in[63],  sub_in[47],  sub_in[31],  sub_in[15]} ),
				   .sbox_out( so15_A ) );

	rectangle128_inv_sbox inv_sbox0  ( .sbox_in ( {rot_text[48],  rot_text[32],  rot_text[16],  rot_text[0]}  ),
					   .sbox_out( so0_B  ) );
	rectangle128_inv_sbox inv_sbox1  ( .sbox_in ( {rot_text[49],  rot_text[33],  rot_text[17],  rot_text[1]}  ),
					   .sbox_out( so1_B  ) );
	rectangle128_inv_sbox inv_sbox2  ( .sbox_in ( {rot_text[50],  rot_text[34],  rot_text[18],  rot_text[2]}  ),
					   .sbox_out( so2_B  ) );
	rectangle128_inv_sbox inv_sbox3  ( .sbox_in ( {rot_text[51],  rot_text[35],  rot_text[19],  rot_text[3]}  ),
					   .sbox_out( so3_B  ) );
	rectangle128_inv_sbox inv_sbox4  ( .sbox_in ( {rot_text[52],  rot_text[36],  rot_text[20],  rot_text[4]}  ),
					   .sbox_out( so4_B  ) );
	rectangle128_inv_sbox inv_sbox5  ( .sbox_in ( {rot_text[53],  rot_text[37],  rot_text[21],  rot_text[5]}  ),
					   .sbox_out( so5_B  ) );
	rectangle128_inv_sbox inv_sbox6  ( .sbox_in ( {rot_text[54],  rot_text[38],  rot_text[22],  rot_text[6]}  ),
					   .sbox_out( so6_B  ) );
	rectangle128_inv_sbox inv_sbox7  ( .sbox_in ( {rot_text[55],  rot_text[39],  rot_text[23],  rot_text[7]}  ),
					   .sbox_out( so7_B  ) );
	rectangle128_inv_sbox inv_sbox8  ( .sbox_in ( {rot_text[56],  rot_text[40],  rot_text[24],  rot_text[8]}  ),
					   .sbox_out( so8_B  ) );
	rectangle128_inv_sbox inv_sbox9  ( .sbox_in ( {rot_text[57],  rot_text[41],  rot_text[25],  rot_text[9]}  ),
					   .sbox_out( so9_B  ) );
	rectangle128_inv_sbox inv_sbox10 ( .sbox_in ( {rot_text[58],  rot_text[42],  rot_text[26],  rot_text[10]} ),
					   .sbox_out( so10_B ) );
	rectangle128_inv_sbox inv_sbox11 ( .sbox_in ( {rot_text[59],  rot_text[43],  rot_text[27],  rot_text[11]} ),
					   .sbox_out( so11_B ) );
	rectangle128_inv_sbox inv_sbox12 ( .sbox_in ( {rot_text[60],  rot_text[44],  rot_text[28],  rot_text[12]} ),
					   .sbox_out( so12_B ) );
	rectangle128_inv_sbox inv_sbox13 ( .sbox_in ( {rot_text[61],  rot_text[45],  rot_text[29],  rot_text[13]} ),
					   .sbox_out( so13_B ) );
	rectangle128_inv_sbox inv_sbox14 ( .sbox_in ( {rot_text[62],  rot_text[46],  rot_text[30],  rot_text[14]} ),
					   .sbox_out( so14_B ) );
	rectangle128_inv_sbox inv_sbox15 ( .sbox_in ( {rot_text[63],  rot_text[47],  rot_text[31],  rot_text[15]} ),
					   .sbox_out( so15_B ) );

	assign so0  = (Encrypt) ? so0_A  : so0_B;
	assign so1  = (Encrypt) ? so1_A  : so1_B;
	assign so2  = (Encrypt) ? so2_A  : so2_B;
	assign so3  = (Encrypt) ? so3_A  : so3_B;
	assign so4  = (Encrypt) ? so4_A  : so4_B;
	assign so5  = (Encrypt) ? so5_A  : so5_B;
	assign so6  = (Encrypt) ? so6_A  : so6_B;
	assign so7  = (Encrypt) ? so7_A  : so7_B;
	assign so8  = (Encrypt) ? so8_A  : so8_B;
	assign so9  = (Encrypt) ? so9_A  : so9_B;
	assign so10 = (Encrypt) ? so10_A : so10_B;
	assign so11 = (Encrypt) ? so11_A : so11_B;
	assign so12 = (Encrypt) ? so12_A : so12_B;
	assign so13 = (Encrypt) ? so13_A : so13_B;
	assign so14 = (Encrypt) ? so14_A : so14_B;
	assign so15 = (Encrypt) ? so15_A : so15_B;

	//Output
	assign sub_text = {
		so15[3], so14[3], so13[3], so12[3], so11[3], so10[3], so9[3], so8[3], so7[3], so6[3], so5[3], so4[3], so3[3], so2[3], so1[3], so0[3], 
		so15[2], so14[2], so13[2], so12[2], so11[2], so10[2], so9[2], so8[2], so7[2], so6[2], so5[2], so4[2], so3[2], so2[2], so1[2], so0[2], 
		so15[1], so14[1], so13[1], so12[1], so11[1], so10[1], so9[1], so8[1], so7[1], so6[1], so5[1], so4[1], so3[1], so2[1], so1[1], so0[1], 
		so15[0], so14[0], so13[0], so12[0], so11[0], so10[0], so9[0], so8[0], so7[0], so6[0], so5[0], so4[0], so3[0], so2[0], so1[0], so0[0]
		};

	//PERMUTATION LAYER
	assign rot_text = (Encrypt) ? { { sub_text[50:48], sub_text[63:51] },
					{ sub_text[35:32], sub_text[47:36] },
					{ sub_text[30:16], sub_text[31] },
					{ sub_text[15:0] }
				      } :
				      { { rot_in[60:48], rot_in[63:61] },
					{ rot_in[43:32], rot_in[47:44] },
					{ rot_in[16], rot_in[31:17] },
					{ rot_in[15:0] }
				      };
	
	reg [4:0] round_counter, RAddr_reg;

	//COUNTER
	always @(posedge Clk or negedge RstN or negedge Enable) begin
		if(!RstN | !Enable) begin
			round_counter <= 5'b0;
		end else if (Enable & skey_ready) begin
			if(round_counter != 5'd27)
				round_counter <= round_counter + 1'b1;
		end
	end

	//ROUND TRANSFORM
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
