`timescale 1ns / 1ps

module tb_blowfish128_skeygen;
    // Testbench signals
    reg Clk;
    reg RstN;
    reg [63:0] key0, key1, key2, key3, key4, key5, key6, key7;
    reg [3:0] key_length;
    reg Enable;
    
    wire skey_ready;
    wire [31:0] P1, P2, P3, P4, P5, P6, P7, P8, P9, P10;
    wire [31:0] P11, P12, P13, P14, P15, P16, P17, P18, P19, P20;
    
    // Instantiate the module under test
    blowfish128_skeygen uut (
        .Clk(Clk),
        .RstN(RstN),
        .Enable(Enable),
        .key0(key0), .key1(key1), .key2(key2), .key3(key3),
        .key4(key4), .key5(key5), .key6(key6), .key7(key7),
        .key_length(key_length),
        .skey_ready(skey_ready),
        .P1(P1), .P2(P2), .P3(P3), .P4(P4), .P5(P5),
        .P6(P6), .P7(P7), .P8(P8), .P9(P9), .P10(P10),
        .P11(P11), .P12(P12), .P13(P13), .P14(P14), .P15(P15),
        .P16(P16), .P17(P17), .P18(P18), .P19(P19), .P20(P20)
    );

    // Clock generation
	initial begin	
		#0 Clk = 0;
		forever #5 Clk = !Clk;
	end
	
	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(1);
	end
    
	initial begin
        // Initialize signals
        RstN = 0;
        Enable = 0;
        key_length = 4;
        
        // Example key values
        key0 = 64'h0123456789ABCDEF;
        key1 = 64'hFEDCBA9876543210;
        key2 = 64'h0011223344556677;
        key3 = 64'h8899AABBCCDDEEFF;
        key4 = 64'h1234567890ABCDEF;
        key5 = 64'h0FEDCBA987654321;
        key6 = 64'h1122334455667788;
        key7 = 64'h99AABBCCDDEEFF00;
        
        // Reset sequence
        #10 RstN = 1;
        #10 Enable = 1;
        
        // Wait for skey_ready
        // wait(skey_ready);
        
        // Disable the module
        // Enable = 0;
        
        // Print P-array values
        $display("P-array values:");
        $display("P1=%h P2=%h P3=%h P4=%h P5=%h", P1, P2, P3, P4, P5);
        $display("P6=%h P7=%h P8=%h P9=%h P10=%h", P6, P7, P8, P9, P10);
        $display("P11=%h P12=%h P13=%h P14=%h P15=%h", P11, P12, P13, P14, P15);
        $display("P16=%h P17=%h P18=%h P19=%h P20=%h", P16, P17, P18, P19, P20);
        
        // Finish simulation
        #50 $finish;
    end
endmodule
