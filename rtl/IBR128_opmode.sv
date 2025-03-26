module IBR128_opmode(
	input Clk,
	input RstN,
	input Enable,
	input Encrypt,
	input [1:0] SOM,
	input OB,
	//Encrypt Input
	input [127:0] plainText,
	input [63:0] key0,
	input [63:0] key1,
	input SA,
	input [31:0] IV,
	//Encrypt Output
	output [127:0] cipherText,
	output cipherReady,
	//Internal Signal
	output logic  encrypt,
	output logic block_start,
	output logic [127:0] pData,
	output logic sa,
	input block_ready,
	input [127:0] eData
	);

	typedef enum logic [1:0] {
		NONE,
		CBC,
		OFB,
		CTR
	} opmode;

	opmode modeSel;
	assign modeSel = (SOM == 2'h1) ? CBC :
			 (SOM == 2'h2) ? OFB :
			 (SOM == 2'h3) ? CTR : NONE;

	logic [127:0] counter;

	always @(posedge Clk or negedge RstN) begin
		if(!RstN | OB) begin
			counter <= {IV[31:0], 96'b0};	
		end
	end

	always @(posedge block_ready) begin
		if(modeSel == CTR && block_ready) begin
			counter <= counter + 1'b1;
		end
	end

	logic [127:0] cipherText_reg;
	logic cipherReady_reg;

	always @(posedge Clk or negedge RstN or posedge OB or negedge Enable) begin
		if(!RstN | OB | !Enable) begin
			encrypt <= 1'b0;
			block_start <= 1'b0;
			pData <= 128'b0;
			sa <= 1'b0;
			cipherText_reg <= 128'b0;
			cipherReady_reg <= 1'b0;
		end else begin
			if(Enable) begin
				case(modeSel)
					CBC: begin

					end
					OFB: begin

					end
					CTR: begin
						if(!block_ready) begin
							encrypt <= 1'b1;
							block_start <= 1'b1;
							pData <= counter;
							sa <= SA;
						end else begin
							cipherText_reg <= eData ^ plainText;
							cipherReady_reg <= block_ready;
						end
					end
				endcase
			end
		end
	end

	assign cipherText = cipherText_reg;
	assign cipherReady = cipherReady_reg;

endmodule
