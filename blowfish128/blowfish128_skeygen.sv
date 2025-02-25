//-----------------------------------------------------------
// Function: Blowfish-128's Skeygen Module
//-----------------------------------------------------------
// Author	: Manh Nguyen, Long Le
// Date  	: Feb-8th, 2025
// Description	: another version of skeygen module using switch case
//-----------------------------------------------------------

module blowfish128_skeygen (
	input Clk,
	input RstN,
	input Enable,
	input Encrypt,
	input [63:0] key0,
	input [63:0] key1,
	input [63:0] key2,
	input [63:0] key3,
	input [63:0] key4,
	input [63:0] key5,
	input [63:0] key6,
	input [63:0] key7,
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


	assign key = {key7, key6, key5, key4, key3, key2, key1, key0};


	always @(posedge Clk or negedge RstN) begin
		if (!RstN) begin
			state_machine <= IDLE;
			ready <= 0;
			p_array[0] <= 32'h243F6A88;
			p_array[1] <= 32'h85A308D3;
			p_array[2] <= 32'h13198A2E;
			p_array[3] <= 32'h03707344;
			p_array[4] <= 32'hA4093822;
			p_array[5] <= 32'h299F31D0;
			p_array[6] <= 32'h082EFA98;
			p_array[7] <= 32'hEC4E6C89;
			p_array[8] <= 32'h452821E6;
			p_array[9] <= 32'h38D01377;
			p_array[10] <= 32'hBE5466CF;
			p_array[11] <= 32'h34E90C6C;
			p_array[12] <= 32'hC0AC29B7;
			p_array[13] <= 32'hC97C50DD;
			p_array[14] <= 32'h3F84D5B5;
			p_array[15] <= 32'hB5470917;
			p_array[16] <= 32'h9216D5D9;
			p_array[17] <= 32'h8979FB1B;
			p_array[18] <= 32'h578FDFE3;
			p_array[19] <= 32'h3AC372E6;
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

	assign P1  = (Encrypt) ? p_array[0] : p_array[19];
	assign P2  = (Encrypt) ? p_array[1] : p_array[18];
	assign P3  = (Encrypt) ? p_array[2] : p_array[17];
	assign P4  = (Encrypt) ? p_array[3] : p_array[16];
	assign P5  = (Encrypt) ? p_array[4] : p_array[15];
	assign P6  = (Encrypt) ? p_array[5] : p_array[14];
	assign P7  = (Encrypt) ? p_array[6] : p_array[13];
	assign P8  = (Encrypt) ? p_array[7] : p_array[12];
	assign P9  = (Encrypt) ? p_array[8] : p_array[11];
	assign P10 = (Encrypt) ? p_array[9] : p_array[10];
	assign P11 = (Encrypt) ? p_array[10] : p_array[9];
	assign P12 = (Encrypt) ? p_array[11] : p_array[8];
	assign P13 = (Encrypt) ? p_array[12] : p_array[7];
	assign P14 = (Encrypt) ? p_array[13] : p_array[6];
	assign P15 = (Encrypt) ? p_array[14] : p_array[5];
	assign P16 = (Encrypt) ? p_array[15] : p_array[4];
	assign P17 = (Encrypt) ? p_array[16] : p_array[3];
	assign P18 = (Encrypt) ? p_array[17] : p_array[2];
	assign P19 = (Encrypt) ? p_array[18] : p_array[1];
	assign P20 = (Encrypt) ? p_array[19] : p_array[0];

endmodule
