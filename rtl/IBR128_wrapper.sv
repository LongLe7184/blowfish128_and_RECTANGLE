module IBR128_wrapper(
	input Clk,
	input RstN,
	input CS,
	input Write,
	input Read,
	input [4:0] Addr,
	input [31:0] WData,
	output [31:0] RData
	);

	wire Enable, SA, Encrypt, FB, cipherReady;
	wire [1:0] SOM;
	wire [63:0] key0, key1;
	wire [127:0] plainText, IV, cipherText;

	IBR128_csr IBR128_csr(
		.Clk(Clk),
		.RstN(RstN),
		.CS(CS),
		.Write(Write),
		.Read(Read),
		.Addr(Addr),
		.WData(WData),
		.RData(RData),
		.Enable(Enable),
		.SA(SA),
		.Encrypt(Encrypt),
		.SOM(SOM),
		.plainText(plainText),
		.IV(IV),
		.FB(FB),
		.key0(key0),
		.key1(key1),
		.cipherText(cipherText),
		.cipherReady(cipherReady)
	);

	IBR128_core IBR128_core(
		.Clk(Clk),
		.RstN(RstN),
		.Enable(Enable),
		.SA(SA),
		.Encrypt(Encrypt),
		.SOM(SOM),
		.plainText(plainText),
		.IV(IV),
		.FB(FB),
		.key0(key0),
		.key1(key1),
		.cipherText(cipherText),
		.cipherReady(cipherReady)
	);

endmodule
