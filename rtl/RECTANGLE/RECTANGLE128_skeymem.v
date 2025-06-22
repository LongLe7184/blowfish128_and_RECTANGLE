//-----------------------------------------------------------
// Function: REACTANGLE128's Skey Memmory
//-----------------------------------------------------------
// Author	: Long Le, Manh Nguyen
// Date  	: Mar-9th, 2025
// Description	: Storing generated subkeys
//-----------------------------------------------------------

module RECTANGLE128_skeymem(
	input Clk,
	input flush,
	input WE,
	input [4:0] WAddr,
	input [63:0] KeyIn,
	//Core Interface Signals
	input [4:0] RAddr,
	output [63:0] KeyOut,
	output skey_ready
	);

	reg [63:0] skey_mem [25:0];
	reg ready;

	always @(posedge Clk or negedge flush) begin
		if(!flush) begin
			skey_mem[0] <= 64'h0;	
			skey_mem[1] <= 64'h0;	
			skey_mem[2] <= 64'h0;	
			skey_mem[3] <= 64'h0;	
			skey_mem[4] <= 64'h0;	
			skey_mem[5] <= 64'h0;	
			skey_mem[6] <= 64'h0;	
			skey_mem[7] <= 64'h0;	
			skey_mem[8] <= 64'h0;	
			skey_mem[9] <= 64'h0;	
			skey_mem[10] <= 64'h0;	
			skey_mem[11] <= 64'h0;	
			skey_mem[12] <= 64'h0;	
			skey_mem[13] <= 64'h0;	
			skey_mem[14] <= 64'h0;	
			skey_mem[15] <= 64'h0;	
			skey_mem[16] <= 64'h0;	
			skey_mem[17] <= 64'h0;	
			skey_mem[18] <= 64'h0;	
			skey_mem[19] <= 64'h0;	
			skey_mem[20] <= 64'h0;	
			skey_mem[21] <= 64'h0;	
			skey_mem[22] <= 64'h0;	
			skey_mem[23] <= 64'h0;	
			skey_mem[24] <= 64'h0;	
			skey_mem[25] <= 64'h0;
			ready <= 1'b0;
		end else begin
			if(WE) begin
				skey_mem[WAddr] <= KeyIn;
				if(WAddr == 5'd25)
					ready <= 1'b1;	
			end
		end
	end
	
	assign skey_ready = ready;

	assign KeyOut = (RAddr == 5'd00) ? skey_mem[0] :
			(RAddr == 5'd01) ? skey_mem[1] :
			(RAddr == 5'd02) ? skey_mem[2] :
			(RAddr == 5'd03) ? skey_mem[3] :
			(RAddr == 5'd04) ? skey_mem[4] :
			(RAddr == 5'd05) ? skey_mem[5] :
			(RAddr == 5'd06) ? skey_mem[6] :
			(RAddr == 5'd07) ? skey_mem[7] :
			(RAddr == 5'd08) ? skey_mem[8] :
			(RAddr == 5'd09) ? skey_mem[9] :
			(RAddr == 5'd10) ? skey_mem[10] :
			(RAddr == 5'd11) ? skey_mem[11] :
			(RAddr == 5'd12) ? skey_mem[12] :
			(RAddr == 5'd13) ? skey_mem[13] :
			(RAddr == 5'd14) ? skey_mem[14] :
			(RAddr == 5'd15) ? skey_mem[15] :
			(RAddr == 5'd16) ? skey_mem[16] :
			(RAddr == 5'd17) ? skey_mem[17] :
			(RAddr == 5'd18) ? skey_mem[18] :
			(RAddr == 5'd19) ? skey_mem[19] :
			(RAddr == 5'd20) ? skey_mem[20] :
			(RAddr == 5'd21) ? skey_mem[21] :
			(RAddr == 5'd22) ? skey_mem[22] :
			(RAddr == 5'd23) ? skey_mem[23] :
			(RAddr == 5'd24) ? skey_mem[24] :
			(RAddr == 5'd25) ? skey_mem[25] : 64'h0;

endmodule
