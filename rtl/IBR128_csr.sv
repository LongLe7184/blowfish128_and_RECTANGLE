module IBR128_csr(
	input Clk,
	input RstN,
	input CS,
	input Write,
	input Read,
	input [4:0] Addr,
	input [31:0] WData,
	output logic [31:0] RData,
	//IBR128_core interface signals
	output logic Enable,
	output logic SA,
	output logic Encrypt,
	output logic [1:0] SOM,
	output logic [127:0] plainText,
	output logic [127:0] IV,
	output logic FB,
	output logic [63:0] key0,
	output logic [63:0] key1,
	input [127:0] cipherText,
	input cipherReady
	);

	localparam IBR128_IV0 = 5'h00;
	localparam IBR128_IV1 = 5'h01;
	localparam IBR128_IV2 = 5'h02;
	localparam IBR128_IV3 = 5'h03;

	localparam IBR128_KEY0 = 5'h04;
	localparam IBR128_KEY1 = 5'h05;
	localparam IBR128_KEY2 = 5'h06;
	localparam IBR128_KEY3 = 5'h07;

	localparam IBR128_PT0 = 5'h08;
	localparam IBR128_PT1 = 5'h09;
	localparam IBR128_PT2 = 5'h0A;
	localparam IBR128_PT3 = 5'h0B;

	localparam IBR128_CT0 = 5'h0C;
	localparam IBR128_CT1 = 5'h0D;
	localparam IBR128_CT2 = 5'h0E;
	localparam IBR128_CT3 = 5'h0F;

	localparam IBR128_CTRL = 5'h10;
	localparam IBR128_STA = 5'h11;

	logic [31:0] data_reg [11:0];
	logic [31:0] data_ro_reg [15:12];
	logic [31:0] ctrl_reg;
	logic [31:0] status_reg;

	/*CTRL REGISTER MAPPING*/
	assign Enable = ctrl_reg[0];
	assign SA = ctrl_reg[1];
	assign Encrypt = ctrl_reg[2];
	assign SOM = ctrl_reg[4:3];
	assign FB = ctrl_reg[5];

	/*STATUS REGISTER MAPPING*/
	assign status_reg = {24'h0, ctrl_reg[5], ctrl_reg[4:3], ctrl_reg[2], ctrl_reg[1], cipherReady}; 

	/*DATA REGISTER MAPPING*/
	assign IV = {data_reg[IBR128_IV3], data_reg[IBR128_IV2], data_reg[IBR128_IV1], data_reg[IBR128_IV0]};
	assign key0 = {data_reg[IBR128_KEY1], data_reg[IBR128_KEY0]};
	assign key1 = {data_reg[IBR128_KEY3], data_reg[IBR128_KEY2]};
	assign plainText = {data_reg[IBR128_PT3], data_reg[IBR128_PT2], data_reg[IBR128_PT1], data_reg[IBR128_PT0]};
	
	assign data_ro_reg[IBR128_CT0] = (cipherReady) ? cipherText[31:0] : 32'h0;  
	assign data_ro_reg[IBR128_CT1] = (cipherReady) ? cipherText[63:32] : 32'h0;  
	assign data_ro_reg[IBR128_CT2] = (cipherReady) ? cipherText[95:64] : 32'h0;  
	assign data_ro_reg[IBR128_CT3] = (cipherReady) ? cipherText[127:96] : 32'h0;  

	always @(posedge Clk or negedge RstN) begin
		if(!RstN) begin
			data_reg[IBR128_IV0] <= 32'h0;
			data_reg[IBR128_IV1] <= 32'h0;
			data_reg[IBR128_IV2] <= 32'h0;
			data_reg[IBR128_IV3] <= 32'h0;
			data_reg[IBR128_KEY0] <= 32'h0;
			data_reg[IBR128_KEY1] <= 32'h0;
			data_reg[IBR128_KEY2] <= 32'h0;
			data_reg[IBR128_KEY3] <= 32'h0;
			data_reg[IBR128_PT0] <= 32'h0;
			data_reg[IBR128_PT1] <= 32'h0;
			data_reg[IBR128_PT2] <= 32'h0;
			data_reg[IBR128_PT3] <= 32'h0;
			ctrl_reg <= 32'h0;
		end else if(CS & Write) begin
			case(Addr)
				IBR128_IV0: data_reg[IBR128_IV0] <= WData;
				IBR128_IV1: data_reg[IBR128_IV1] <= WData;
				IBR128_IV2: data_reg[IBR128_IV2] <= WData;
				IBR128_IV3: data_reg[IBR128_IV3] <= WData;
				IBR128_KEY0: data_reg[IBR128_KEY0] <= WData;
				IBR128_KEY1: data_reg[IBR128_KEY1] <= WData;
				IBR128_KEY2: data_reg[IBR128_KEY2] <= WData;
				IBR128_KEY3: data_reg[IBR128_KEY3] <= WData;
				IBR128_PT0: data_reg[IBR128_PT0] <= WData;
				IBR128_PT1: data_reg[IBR128_PT1] <= WData;
				IBR128_PT2: data_reg[IBR128_PT2] <= WData;
				IBR128_PT3: data_reg[IBR128_PT3] <= WData;
				IBR128_CTRL: ctrl_reg <= WData;
			endcase
		end
	end
	
	always @(posedge Clk or negedge RstN) begin
		if(CS & Read) begin
			case(Addr)
				IBR128_CT0: RData <= data_ro_reg[IBR128_CT0];
				IBR128_CT1: RData <= data_ro_reg[IBR128_CT1];
				IBR128_CT2: RData <= data_ro_reg[IBR128_CT2];
				IBR128_CT3: RData <= data_ro_reg[IBR128_CT3];
				IBR128_STA: RData <= status_reg;
			endcase
		end
	end

endmodule
