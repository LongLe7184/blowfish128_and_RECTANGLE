`timescale 1ns/1ps

module tb_IBR128_wrapper;

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

	logic Clk_tb, RstN_tb, CS_tb, Write_tb, Read_tb;
	logic [4:0] Addr_tb;
	logic [31:0] WData_tb, RData_tb;

	IBR128_wrapper IBR128_wrapper(
		.Clk(Clk_tb),
		.RstN(RstN_tb),
		.CS(CS_tb),
		.Write(Write_tb),
		.Read(Read_tb),
		.Addr(Addr_tb),
		.WData(WData_tb),
		.RData(RData_tb)
	);

	initial begin
		Clk_tb = 1;
		forever #10 Clk_tb = !Clk_tb;
	end

	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(1);
	end

	initial begin
//Reset phase
		RstN_tb <= 0;
		#60 RstN_tb <= 1;
		
		#20 CS_tb <= 1;
		Write_tb <= 1;
		Read_tb <= 0;
		for(int i=0; i<12; i++) begin
			#20
			Addr_tb <= IBR128_IV0 + i;
			case(i)
				32'h0: WData_tb <= 32'h7777_8888;
				32'h1: WData_tb <= 32'h5555_6666;
				32'h2: WData_tb <= 32'h3333_4444;
				32'h3: WData_tb <= 32'h1111_2222;
				
				32'h4: WData_tb <= 32'h5670_1122;
				32'h5: WData_tb <= 32'h9988_1234;
				32'h6: WData_tb <= 32'h2736_ccdd;
				32'h7: WData_tb <= 32'haabb_0918;

				32'h8: WData_tb <= 32'hcd13_2536;
				32'h9: WData_tb <= 32'h1234_56ab;
				32'ha: WData_tb <= 32'hcd13_2536;
				32'hb: WData_tb <= 32'h1234_56ab;
			endcase
		end

		//FB + SOM[1:0] + Encrypt + SA + Enable
		# 20
		Addr_tb <= 5'h10;
		WData_tb <= {26'h0, 1'b1, 2'b01, 1'b1, 1'b0, 1'b1};

		#60 Write_tb <= 0;
		Read_tb <= 1;
		Addr_tb <= IBR128_STA;
		wait(RData_tb[0]);

		#200 $finish;
	end

endmodule


