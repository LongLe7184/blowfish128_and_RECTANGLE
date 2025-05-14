//-----------------------------------------------------------
// Function: Blowfish-128's Skeygen Module
//-----------------------------------------------------------
// Author	: Manh Nguyen, Long Le
// Date  	: Mar-23rd, 2025
// Description	: Skeygen 128-bit keylength module
// 		  generating subkeys (use for integrate IP version)
//-----------------------------------------------------------

`include "blowfish128_DEF.svh"

module blowfish128_skeygen (
	input Clk,
	input RstN,
	input Enable,
	input [63:0] key0,
	input [63:0] key1,
	input [63:0] key2,
	input [63:0] key3,
	input [63:0] key4,
	input [63:0] key5,
	input [63:0] key6,
	input [3:0] key_length,
	//core interface signals
	output skey_ready,
	output [31:0] P1,
	output [31:0] P2,
	output [31:0] P3,
	output [31:0] P4,
	output [31:0] P5,
	output [31:0] P6,
	output [31:0] P7,
	output [31:0] P8,
	output [31:0] P9,
	output [31:0] P10,
	output [31:0] P11,
	output [31:0] P12,
	output [31:0] P13,
	output [31:0] P14,
	output [31:0] P15,
	output [31:0] P16,
	output [31:0] P17,
	output [31:0] P18,
	output [31:0] P19,
	output [31:0] P20
	);
	
	typedef enum logic [1:0] {
		IDLE,
		XOR_KEY,
		STANDBY
	} state_t;

	//Internal signal
	reg [31:0] p_array   [0:19]; 		// Contain values of p_array
	state_t  state_machine;			// State of state machine
	wire [447:0] key;
	reg ready;

	assign key = {key6, key5, key4, key3, key2, key1, key0};


	always @(posedge Clk or negedge RstN or negedge Enable) begin
		if (!RstN | !Enable) begin
			state_machine <= IDLE;
			ready <= 0;
			p_array[0] <= `PARR_ELEMENT_000;
			p_array[1] <= `PARR_ELEMENT_001;
			p_array[2] <= `PARR_ELEMENT_002;
			p_array[3] <= `PARR_ELEMENT_003;
			p_array[4] <= `PARR_ELEMENT_004;
			p_array[5] <= `PARR_ELEMENT_005;
			p_array[6] <= `PARR_ELEMENT_006;
			p_array[7] <= `PARR_ELEMENT_007;
			p_array[8] <= `PARR_ELEMENT_008;
			p_array[9] <= `PARR_ELEMENT_009;
			p_array[10] <= `PARR_ELEMENT_010;
			p_array[11] <= `PARR_ELEMENT_011;
			p_array[12] <= `PARR_ELEMENT_012;
			p_array[13] <= `PARR_ELEMENT_013;
			p_array[14] <= `PARR_ELEMENT_014;
			p_array[15] <= `PARR_ELEMENT_015;
			p_array[16] <= `PARR_ELEMENT_016;
			p_array[17] <= `PARR_ELEMENT_017;
			p_array[18] <= `PARR_ELEMENT_018;
			p_array[19] <= `PARR_ELEMENT_019;
		end else begin
			case (state_machine)

				//IDLE state
				IDLE: begin
					if (Enable) begin
						state_machine <= XOR_KEY;
						ready <= 0;
					end
				end

				//XOR_KEY state
				XOR_KEY: begin
					ready <= 0;

					case (key_length)

	/*---------------------		RESERVED CASES		---------------------
	*
	* Integrate version will use 128-bit key length only, the other key
	* length will be use in needed
	*
	*----------------------------------------------------------------------------

						//32-bit key length
						4'd1: begin
							p_array[0] <= p_array[0] ^ key[0 +: 32];
							p_array[1] <= p_array[1] ^ key[0 +: 32];
							p_array[2] <= p_array[2] ^ key[0 +: 32];
							p_array[3] <= p_array[3] ^ key[0 +: 32];
							p_array[4] <= p_array[4] ^ key[0 +: 32];
							p_array[5] <= p_array[5] ^ key[0 +: 32];
							p_array[6] <= p_array[6] ^ key[0 +: 32];
							p_array[7] <= p_array[7] ^ key[0 +: 32];
							p_array[8] <= p_array[8] ^ key[0 +: 32];
							p_array[9] <= p_array[9] ^ key[0 +: 32];
							p_array[10] <= p_array[10] ^ key[0 +: 32];
							p_array[11] <= p_array[11] ^ key[0 +: 32];
							p_array[12] <= p_array[12] ^ key[0 +: 32];
							p_array[13] <= p_array[13] ^ key[0 +: 32];
							p_array[14] <= p_array[14] ^ key[0 +: 32];
							p_array[15] <= p_array[15] ^ key[0 +: 32];
							p_array[16] <= p_array[16] ^ key[0 +: 32];
							p_array[17] <= p_array[17] ^ key[0 +: 32];
							p_array[18] <= p_array[18] ^ key[0 +: 32];
							p_array[19] <= p_array[19] ^ key[0 +: 32];
						end

						//64-bit key length
						4'd2: begin
							p_array[0] <= p_array[0] ^ key[0 +: 32];
							p_array[1] <= p_array[1] ^ key[32 +: 32];
							p_array[2] <= p_array[2] ^ key[0 +: 32];
							p_array[3] <= p_array[3] ^ key[32 +: 32];
							p_array[4] <= p_array[4] ^ key[0 +: 32];
							p_array[5] <= p_array[5] ^ key[32 +: 32];
							p_array[6] <= p_array[6] ^ key[0 +: 32];
							p_array[7] <= p_array[7] ^ key[32 +: 32];
							p_array[8] <= p_array[8] ^ key[0 +: 32];
							p_array[9] <= p_array[9] ^ key[32 +: 32];
							p_array[10] <= p_array[10] ^ key[0 +: 32];
							p_array[11] <= p_array[11] ^ key[32 +: 32];
							p_array[12] <= p_array[12] ^ key[0 +: 32];
							p_array[13] <= p_array[13] ^ key[32 +: 32];
							p_array[14] <= p_array[14] ^ key[0 +: 32];
							p_array[15] <= p_array[15] ^ key[32 +: 32];
							p_array[16] <= p_array[16] ^ key[0 +: 32];
							p_array[17] <= p_array[17] ^ key[32 +: 32];
							p_array[18] <= p_array[18] ^ key[0 +: 32];
							p_array[19] <= p_array[19] ^ key[32 +: 32];
						end

						//96-bit key length
						4'd3: begin
							p_array[0] <= p_array[0] ^ key[0 +: 32];
							p_array[1] <= p_array[1] ^ key[32 +: 32];
							p_array[2] <= p_array[2] ^ key[64 +: 32];
							p_array[3] <= p_array[3] ^ key[0 +: 32];
							p_array[4] <= p_array[4] ^ key[32 +: 32];
							p_array[5] <= p_array[5] ^ key[64 +: 32];
							p_array[6] <= p_array[6] ^ key[0 +: 32];
							p_array[7] <= p_array[7] ^ key[32 +: 32];
							p_array[8] <= p_array[8] ^ key[64 +: 32];
							p_array[9] <= p_array[9] ^ key[0 +: 32];
							p_array[10] <= p_array[10] ^ key[32 +: 32];
							p_array[11] <= p_array[11] ^ key[64 +: 32];
							p_array[12] <= p_array[12] ^ key[0 +: 32];
							p_array[13] <= p_array[13] ^ key[32 +: 32];
							p_array[14] <= p_array[14] ^ key[64 +: 32];
							p_array[15] <= p_array[15] ^ key[0 +: 32];
							p_array[16] <= p_array[16] ^ key[32 +: 32];
							p_array[17] <= p_array[17] ^ key[64 +: 32];
							p_array[18] <= p_array[18] ^ key[0 +: 32];
							p_array[19] <= p_array[19] ^ key[32 +: 32];
						end

	*----------------------------------------------------------------------------*
	* 			END OF PART.1 RESERVED CASES
	*----------------------------------------------------------------------------*/

						//128-bit key length
						4'd4: begin
							p_array[0] <= p_array[0] ^ key[0 +: 32];
							p_array[1] <= p_array[1] ^ key[32 +: 32];
							p_array[2] <= p_array[2] ^ key[64 +: 32];
							p_array[3] <= p_array[3] ^ key[96 +: 32];
							p_array[4] <= p_array[4] ^ key[0 +: 32];
							p_array[5] <= p_array[5] ^ key[32 +: 32];
							p_array[6] <= p_array[6] ^ key[64 +: 32];
							p_array[7] <= p_array[7] ^ key[96 +: 32];
							p_array[8] <= p_array[8] ^ key[0 +: 32];
							p_array[9] <= p_array[9] ^ key[32 +: 32];
							p_array[10] <= p_array[10] ^ key[64 +: 32];
							p_array[11] <= p_array[11] ^ key[96 +: 32];
							p_array[12] <= p_array[12] ^ key[0 +: 32];
							p_array[13] <= p_array[13] ^ key[32 +: 32];
							p_array[14] <= p_array[14] ^ key[64 +: 32];
							p_array[15] <= p_array[15] ^ key[96 +: 32];
							p_array[16] <= p_array[16] ^ key[0 +: 32];
							p_array[17] <= p_array[17] ^ key[32 +: 32];
							p_array[18] <= p_array[18] ^ key[64 +: 32];
							p_array[19] <= p_array[19] ^ key[96 +: 32];
						end

	/*----------------------------------------------------------------------------*
	* 			CONTINUE PART.2 RESERVED CASES
	*-----------------------------------------------------------------------------*

						//160-bit key length
						4'd5: begin
							p_array[0] <= p_array[0] ^ key[0 +: 32];
							p_array[1] <= p_array[1] ^ key[32 +: 32];
							p_array[2] <= p_array[2] ^ key[64 +: 32];
							p_array[3] <= p_array[3] ^ key[96 +: 32];
							p_array[4] <= p_array[4] ^ key[128 +: 32];
							p_array[5] <= p_array[5] ^ key[0 +: 32];
							p_array[6] <= p_array[6] ^ key[32 +: 32];
							p_array[7] <= p_array[7] ^ key[64 +: 32];
							p_array[8] <= p_array[8] ^ key[96 +: 32];
							p_array[9] <= p_array[9] ^ key[128 +: 32];
							p_array[10] <= p_array[10] ^ key[0 +: 32];
							p_array[11] <= p_array[11] ^ key[32 +: 32];
							p_array[12] <= p_array[12] ^ key[64 +: 32];
							p_array[13] <= p_array[13] ^ key[96 +: 32];
							p_array[14] <= p_array[14] ^ key[128 +: 32];
							p_array[15] <= p_array[15] ^ key[0 +: 32];
							p_array[16] <= p_array[16] ^ key[32 +: 32];
							p_array[17] <= p_array[17] ^ key[64 +: 32];
							p_array[18] <= p_array[18] ^ key[96 +: 32];
							p_array[19] <= p_array[19] ^ key[128 +: 32];
						end

						//192-bit key length
						4'd6: begin
							p_array[0] <= p_array[0] ^ key[0 +: 32];
							p_array[1] <= p_array[1] ^ key[32 +: 32];
							p_array[2] <= p_array[2] ^ key[64 +: 32];
							p_array[3] <= p_array[3] ^ key[96 +: 32];
							p_array[4] <= p_array[4] ^ key[128 +: 32];
							p_array[5] <= p_array[5] ^ key[160 +: 32];
							p_array[6] <= p_array[6] ^ key[0 +: 32];
							p_array[7] <= p_array[7] ^ key[32 +: 32];
							p_array[8] <= p_array[8] ^ key[64 +: 32];
							p_array[9] <= p_array[9] ^ key[96 +: 32];
							p_array[10] <= p_array[10] ^ key[128 +: 32];
							p_array[11] <= p_array[11] ^ key[160 +: 32];
							p_array[12] <= p_array[12] ^ key[0 +: 32];
							p_array[13] <= p_array[13] ^ key[32 +: 32];
							p_array[14] <= p_array[14] ^ key[64 +: 32];
							p_array[15] <= p_array[15] ^ key[96 +: 32];
							p_array[16] <= p_array[16] ^ key[128 +: 32];
							p_array[17] <= p_array[17] ^ key[160 +: 32];
							p_array[18] <= p_array[18] ^ key[0 +: 32];
							p_array[19] <= p_array[19] ^ key[32 +: 32];
						end

						//224-bit key length
						4'd7: begin
							p_array[0] <= p_array[0] ^ key[0 +: 32];
							p_array[1] <= p_array[1] ^ key[32 +: 32];
							p_array[2] <= p_array[2] ^ key[64 +: 32];
							p_array[3] <= p_array[3] ^ key[96 +: 32];
							p_array[4] <= p_array[4] ^ key[128 +: 32];
							p_array[5] <= p_array[5] ^ key[160 +: 32];
							p_array[6] <= p_array[6] ^ key[192 +: 32];
							p_array[7] <= p_array[7] ^ key[0 +: 32];
							p_array[8] <= p_array[8] ^ key[32 +: 32];
							p_array[9] <= p_array[9] ^ key[64 +: 32];
							p_array[10] <= p_array[10] ^ key[96 +: 32];
							p_array[11] <= p_array[11] ^ key[128 +: 32];
							p_array[12] <= p_array[12] ^ key[160 +: 32];
							p_array[13] <= p_array[13] ^ key[192 +: 32];
							p_array[14] <= p_array[14] ^ key[0 +: 32];
							p_array[15] <= p_array[15] ^ key[32 +: 32];
							p_array[16] <= p_array[16] ^ key[64 +: 32];
							p_array[17] <= p_array[17] ^ key[96 +: 32];
							p_array[18] <= p_array[18] ^ key[128 +: 32];
							p_array[19] <= p_array[19] ^ key[160 +: 32];
						end

						//256-bit key length
						4'd8: begin
							p_array[0] <= p_array[0] ^ key[0 +: 32];
							p_array[1] <= p_array[1] ^ key[32 +: 32];
							p_array[2] <= p_array[2] ^ key[64 +: 32];
							p_array[3] <= p_array[3] ^ key[96 +: 32];
							p_array[4] <= p_array[4] ^ key[128 +: 32];
							p_array[5] <= p_array[5] ^ key[160 +: 32];
							p_array[6] <= p_array[6] ^ key[192 +: 32];
							p_array[7] <= p_array[7] ^ key[224 +: 32];
							p_array[8] <= p_array[8] ^ key[0 +: 32];
							p_array[9] <= p_array[9] ^ key[32 +: 32];
							p_array[10] <= p_array[10] ^ key[64 +: 32];
							p_array[11] <= p_array[11] ^ key[96 +: 32];
							p_array[12] <= p_array[12] ^ key[128 +: 32];
							p_array[13] <= p_array[13] ^ key[160 +: 32];
							p_array[14] <= p_array[14] ^ key[192 +: 32];
							p_array[15] <= p_array[15] ^ key[224 +: 32];
							p_array[16] <= p_array[16] ^ key[0 +: 32];
							p_array[17] <= p_array[17] ^ key[32 +: 32];
							p_array[18] <= p_array[18] ^ key[64 +: 32];
							p_array[19] <= p_array[19] ^ key[96 +: 32];
						end

						//288-bit key length
						4'd9: begin
							p_array[0] <= p_array[0] ^ key[0 +: 32];
							p_array[1] <= p_array[1] ^ key[32 +: 32];
							p_array[2] <= p_array[2] ^ key[64 +: 32];
							p_array[3] <= p_array[3] ^ key[96 +: 32];
							p_array[4] <= p_array[4] ^ key[128 +: 32];
							p_array[5] <= p_array[5] ^ key[160 +: 32];
							p_array[6] <= p_array[6] ^ key[192 +: 32];
							p_array[7] <= p_array[7] ^ key[224 +: 32];
							p_array[8] <= p_array[8] ^ key[256 +: 32];
							p_array[9] <= p_array[9] ^ key[0 +: 32];
							p_array[10] <= p_array[10] ^ key[32 +: 32];
							p_array[11] <= p_array[11] ^ key[64 +: 32];
							p_array[12] <= p_array[12] ^ key[96 +: 32];
							p_array[13] <= p_array[13] ^ key[128 +: 32];
							p_array[14] <= p_array[14] ^ key[160 +: 32];
							p_array[15] <= p_array[15] ^ key[192 +: 32];
							p_array[16] <= p_array[16] ^ key[224 +: 32];
							p_array[17] <= p_array[17] ^ key[256 +: 32];
							p_array[18] <= p_array[18] ^ key[0 +: 32];
							p_array[19] <= p_array[19] ^ key[32 +: 32];
						end

						//320-bit key length
						4'd10: begin
							p_array[0] <= p_array[0] ^ key[0 +: 32];
							p_array[1] <= p_array[1] ^ key[32 +: 32];
							p_array[2] <= p_array[2] ^ key[64 +: 32];
							p_array[3] <= p_array[3] ^ key[96 +: 32];
							p_array[4] <= p_array[4] ^ key[128 +: 32];
							p_array[5] <= p_array[5] ^ key[160 +: 32];
							p_array[6] <= p_array[6] ^ key[192 +: 32];
							p_array[7] <= p_array[7] ^ key[224 +: 32];
							p_array[8] <= p_array[8] ^ key[256 +: 32];
							p_array[9] <= p_array[9] ^ key[288 +: 32];
							p_array[10] <= p_array[10] ^ key[0 +: 32];
							p_array[11] <= p_array[11] ^ key[32 +: 32];
							p_array[12] <= p_array[12] ^ key[64 +: 32];
							p_array[13] <= p_array[13] ^ key[96 +: 32];
							p_array[14] <= p_array[14] ^ key[128 +: 32];
							p_array[15] <= p_array[15] ^ key[160 +: 32];
							p_array[16] <= p_array[16] ^ key[192 +: 32];
							p_array[17] <= p_array[17] ^ key[224 +: 32];
							p_array[18] <= p_array[18] ^ key[256 +: 32];
							p_array[19] <= p_array[19] ^ key[288 +: 32];
						end

						//352-bit key length
						4'd11: begin
							p_array[0] <= p_array[0] ^ key[0 +: 32];
							p_array[1] <= p_array[1] ^ key[32 +: 32];
							p_array[2] <= p_array[2] ^ key[64 +: 32];
							p_array[3] <= p_array[3] ^ key[96 +: 32];
							p_array[4] <= p_array[4] ^ key[128 +: 32];
							p_array[5] <= p_array[5] ^ key[160 +: 32];
							p_array[6] <= p_array[6] ^ key[192 +: 32];
							p_array[7] <= p_array[7] ^ key[224 +: 32];
							p_array[8] <= p_array[8] ^ key[256 +: 32];
							p_array[9] <= p_array[9] ^ key[288 +: 32];
							p_array[10] <= p_array[10] ^ key[320 +: 32];
							p_array[11] <= p_array[11] ^ key[0 +: 32];
							p_array[12] <= p_array[12] ^ key[32 +: 32];
							p_array[13] <= p_array[13] ^ key[64 +: 32];
							p_array[14] <= p_array[14] ^ key[96 +: 32];
							p_array[15] <= p_array[15] ^ key[128 +: 32];
							p_array[16] <= p_array[16] ^ key[160 +: 32];
							p_array[17] <= p_array[17] ^ key[192 +: 32];
							p_array[18] <= p_array[18] ^ key[224 +: 32];
							p_array[19] <= p_array[19] ^ key[256 +: 32];
						end

						//384-bit key length
						4'd12: begin
							p_array[0] <= p_array[0] ^ key[0 +: 32];
							p_array[1] <= p_array[1] ^ key[32 +: 32];
							p_array[2] <= p_array[2] ^ key[64 +: 32];
							p_array[3] <= p_array[3] ^ key[96 +: 32];
							p_array[4] <= p_array[4] ^ key[128 +: 32];
							p_array[5] <= p_array[5] ^ key[160 +: 32];
							p_array[6] <= p_array[6] ^ key[192 +: 32];
							p_array[7] <= p_array[7] ^ key[224 +: 32];
							p_array[8] <= p_array[8] ^ key[256 +: 32];
							p_array[9] <= p_array[9] ^ key[288 +: 32];
							p_array[10] <= p_array[10] ^ key[320 +: 32];
							p_array[11] <= p_array[11] ^ key[352 +: 32];
							p_array[12] <= p_array[12] ^ key[0 +: 32];
							p_array[13] <= p_array[13] ^ key[32 +: 32];
							p_array[14] <= p_array[14] ^ key[64 +: 32];
							p_array[15] <= p_array[15] ^ key[96 +: 32];
							p_array[16] <= p_array[16] ^ key[128 +: 32];
							p_array[17] <= p_array[17] ^ key[160 +: 32];
							p_array[18] <= p_array[18] ^ key[192 +: 32];
							p_array[19] <= p_array[19] ^ key[224 +: 32];
						end

						//416-bit key length
						4'd13: begin
							p_array[0] <= p_array[0] ^ key[0 +: 32];
							p_array[1] <= p_array[1] ^ key[32 +: 32];
							p_array[2] <= p_array[2] ^ key[64 +: 32];
							p_array[3] <= p_array[3] ^ key[96 +: 32];
							p_array[4] <= p_array[4] ^ key[128 +: 32];
							p_array[5] <= p_array[5] ^ key[160 +: 32];
							p_array[6] <= p_array[6] ^ key[192 +: 32];
							p_array[7] <= p_array[7] ^ key[224 +: 32];
							p_array[8] <= p_array[8] ^ key[256 +: 32];
							p_array[9] <= p_array[9] ^ key[288 +: 32];
							p_array[10] <= p_array[10] ^ key[320 +: 32];
							p_array[11] <= p_array[11] ^ key[352 +: 32];
							p_array[12] <= p_array[12] ^ key[384 +: 32];
							p_array[13] <= p_array[13] ^ key[0 +: 32];
							p_array[14] <= p_array[14] ^ key[32 +: 32];
							p_array[15] <= p_array[15] ^ key[64 +: 32];
							p_array[16] <= p_array[16] ^ key[96 +: 32];
							p_array[17] <= p_array[17] ^ key[128 +: 32];
							p_array[18] <= p_array[18] ^ key[160 +: 32];
							p_array[19] <= p_array[19] ^ key[192 +: 32];
						end

						//448-bit key length
						4'd14: begin
							p_array[0] <= p_array[0] ^ key[0 +: 32];
							p_array[1] <= p_array[1] ^ key[32 +: 32];
							p_array[2] <= p_array[2] ^ key[64 +: 32];
							p_array[3] <= p_array[3] ^ key[96 +: 32];
							p_array[4] <= p_array[4] ^ key[128 +: 32];
							p_array[5] <= p_array[5] ^ key[160 +: 32];
							p_array[6] <= p_array[6] ^ key[192 +: 32];
							p_array[7] <= p_array[7] ^ key[224 +: 32];
							p_array[8] <= p_array[8] ^ key[256 +: 32];
							p_array[9] <= p_array[9] ^ key[288 +: 32];
							p_array[10] <= p_array[10] ^ key[320 +: 32];
							p_array[11] <= p_array[11] ^ key[352 +: 32];
							p_array[12] <= p_array[12] ^ key[384 +: 32];
							p_array[13] <= p_array[13] ^ key[416 +: 32];
							p_array[14] <= p_array[14] ^ key[0 +: 32];
							p_array[15] <= p_array[15] ^ key[32 +: 32];
							p_array[16] <= p_array[16] ^ key[64 +: 32];
							p_array[17] <= p_array[17] ^ key[96 +: 32];
							p_array[18] <= p_array[18] ^ key[128 +: 32];
							p_array[19] <= p_array[19] ^ key[160 +: 32];
						end

	*----------------------------------------------------------------------------*
	* 			END OF PART.2 RESERVED CASES
	*----------------------------------------------------------------------------*/

					endcase
					ready <= 1; // Signal that P-array is ready
					state_machine <= STANDBY;
				end
				
				//STANDBY state
				STANDBY: begin
					//RESERVED STATE
					//Restart skey_gen if there's new key
				end

			endcase
		end
	end	

	assign skey_ready = ready;
	
	assign P1 = p_array[0];
	assign P2 = p_array[1];
	assign P3 = p_array[2];
	assign P4 = p_array[3];
	assign P5 = p_array[4];
	assign P6 = p_array[5];
	assign P7 = p_array[6];
	assign P8 = p_array[7];
	assign P9 = p_array[8];
	assign P10 = p_array[9];
	assign P11 = p_array[10];
	assign P12 = p_array[11];
	assign P13 = p_array[12];
	assign P14 = p_array[13];
	assign P15 = p_array[14];
	assign P16 = p_array[15];
	assign P17 = p_array[16];
	assign P18 = p_array[17];
	assign P19 = p_array[18];
	assign P20 = p_array[19];

endmodule
