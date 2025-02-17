//-----------------------------------------------------------
// Function: Blowfish-128's Skeygen Module
//-----------------------------------------------------------
// Author	: Manh Nguyen, Long Le
// Date  	: Feb-8th, 2025
// Description	: skeygen module used in key generation process
//-----------------------------------------------------------

module skeygen (
	input Clk,
	input RstN,
	input [63:0] key0,
	input [63:0] key1,
	input [63:0] key2,
	input [63:0] key3,
	input [63:0] key4,
	input [63:0] key5,
	input [63:0] key6,
	input [63:0] key7,
	input [3:0] key_length,
	input Encrypt,
	input Enable,
	
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

	//Internal signal
	reg [31:0] p_initial [0:19];      	// Contain initial value of p_array
	reg [31:0] p_array   [0:19]; 		// Contain value of p_array
	reg [31:0] temp;
	reg [1:0]  state_machine;			// Contain state of state machine
    reg [4:0] i;                   		// Counter for P-array initialization
    reg [4:0] j;                  		// Counter for key XOR operation
	wire [447:0] key;
	reg ready;
	
	integer k1, k2;						// Variable for loop
	
    localparam IDLE = 2'b00;
    localparam XOR_KEY = 2'b01;
    localparam UPDATE_P = 2'b10;
	
	initial begin
        p_initial[0] = 32'h243F6A88; p_initial[1] = 32'h85A308D3; p_initial[2] = 32'h13198A2E; p_initial[3] = 32'h03707344;
        p_initial[4] = 32'hA4093822; p_initial[5] = 32'h299F31D0; p_initial[6] = 32'h082EFA98; p_initial[7] = 32'hEC4E6C89;
        p_initial[8] = 32'h452821E6; p_initial[9] = 32'h38D01377; p_initial[10] = 32'hBE5466CF; p_initial[11] = 32'h34E90C6C;
        p_initial[12] = 32'hC0AC29B7; p_initial[13] = 32'hC97C50DD; p_initial[14] = 32'h3F84D5B5; p_initial[15] = 32'hB5470917;
        p_initial[16] = 32'h9216D5D9; p_initial[17] = 32'h8979FB1B; p_initial[18] = 32'h578fdfe3; p_initial[19] = 32'h3ac372e6;
    end
	
	assign key = {key7, key6, key5, key4, key3, key2, key1, key0};

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
	
	assign skey_ready = ready;
	
    always @(posedge Clk or negedge RstN) begin
        if (!RstN) begin
            state_machine <= IDLE;
            ready <= 0;
            i <= 0;
            j <= 0;
			for (k1 = 0; k1 < 20; k1 = k1 + 1) begin
				p_array[k1] <= p_initial[k1];
			end
        end else begin
            case (state_machine)
                IDLE: begin
                    if (Enable) begin
                        state_machine <= XOR_KEY;
			            ready <= 0;
                        i <= 0;
                        j <= 0;
                    end
                end

                XOR_KEY: begin
					ready <= 0;
					for (k2 = 0; k2 < 20; k2 = k2 + 1) begin
						temp = key[j*32 +: 32]; // Extract 32-bit chunk of the key
						if (Encrypt) begin 
							p_array[k2] <= p_array[k2] ^ temp;
						end else begin
							p_array[19 - k2] <= p_array[19 - k2] ^ temp;
						end
						j = (j + 1) % key_length;
					end
					state_machine <= UPDATE_P;
                end

                UPDATE_P: begin
				    state_machine <= IDLE;
                    ready <= 1; // Signal that P-array is ready
                end
				
				default:
					state_machine <= IDLE;
            endcase
        end
    end	
	
endmodule