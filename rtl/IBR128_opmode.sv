module IBR128_opmode(
	input Clk,
	input RstN,
	input Enable,
	input Encrypt,
	input [1:0] SOM,
	input FB,
	//Encrypt Input
	input [127:0] plainText,
	input [63:0] key0,
	input [63:0] key1,
	input SA,
	input [127:0] IV,
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
	
	logic [127:0] nextBlock_input;
	logic [127:0] ctr;
	logic [127:0] cipherText_reg;
	logic cipherReady_reg;
	logic adder_en;

	assign adder_en = (block_start && !block_ready && (modeSel == CTR)) ? 1'b1 : 1'b0;

	IBR128_adder IBR128_adder(
		.Clk(Clk),
		.RstN(RstN),
		.Enable(adder_en),
		.A(nextBlock_input),
		.B(128'b1),
		.S(ctr)
	);

	//Reset Sequence
	always @(posedge Clk or negedge RstN or negedge Enable) begin
		if(!RstN | !Enable) begin
			encrypt <= 1'b0;
			block_start <= 1'b0;
			pData <= 128'b0;
			sa <= 1'b0;
			cipherText_reg <= 128'b0;
			cipherReady_reg <= 1'b0;
		end
	end

	//Initial Sequence
	always @(posedge Clk or negedge RstN) begin
		if(!RstN) begin
			nextBlock_input <= 128'b0;
		end else if (Enable & FB & !block_ready) begin
			nextBlock_input <= IV;
		end
	end

	//CBC BCOM Implementation
	always @(posedge Clk) begin
		if (Enable && (modeSel == CBC)) begin
			if(!block_ready) begin
				encrypt <= Encrypt;
				block_start <= 1'b1;
				pData <= (Encrypt) ? (nextBlock_input ^ plainText) : plainText;
				sa <= SA;	
			end else begin
				nextBlock_input <= (Encrypt) ? eData : plainText;
				cipherText_reg <= (Encrypt) ? eData : (eData ^ nextBlock_input);
				cipherReady_reg <= block_ready;
			end
		end
	end

	//OFB BCOM Implementation
	always @(posedge Clk) begin
		if(Enable && (modeSel == OFB)) begin
			if(!block_ready) begin
				encrypt <= 1'b1;
				block_start <= 1'b1;
				pData <= nextBlock_input;
				sa <= SA;
			end else begin
				nextBlock_input <= eData;
				cipherText_reg <= eData ^ plainText;
				cipherReady_reg <= block_ready;
			end
		end
	end

	//CTR BCOM Implementation
	always @(posedge Clk) begin
		if(Enable && (modeSel == CTR)) begin
			if(!block_ready) begin
				encrypt <= 1'b1;
				block_start <= 1'b1;
				pData <= nextBlock_input;
				sa <= SA;
			end else begin
				nextBlock_input <= ctr;
				cipherText_reg <= eData ^ plainText;
				cipherReady_reg <= block_ready;
			end
		end
	end

	assign cipherText = cipherText_reg;
	assign cipherReady = cipherReady_reg;

endmodule
