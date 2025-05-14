//-----------------------------------------------------------
// Module: AXI4_IBR128_Bridge_TB
//-----------------------------------------------------------
// Date      : May-8th, 2025
// Description: Testbench for AXI4 to IBR128 Bridge
//-----------------------------------------------------------

`timescale 1ns/1ps

module AXI4_IBR128_Bridge_TB();

    // Clock and reset
    logic axi_aclk;
    logic axi_aresetn;
    
    // AXI4 slave interface
    // Write address channel
    logic [7:0]  s_axi_awid;
    logic [31:0] s_axi_awaddr;
    logic [7:0]  s_axi_awlen;
    logic [2:0]  s_axi_awsize;
    logic [1:0]  s_axi_awburst;
    logic [1:0]  s_axi_awlock;
    logic [3:0]  s_axi_awcache;
    logic [2:0]  s_axi_awprot;
    logic [3:0]  s_axi_awqos;
    logic        s_axi_awvalid;
    logic        s_axi_awready;
    
    // Write data channel
    logic [31:0] s_axi_wdata;
    logic [3:0]  s_axi_wstrb;
    logic        s_axi_wlast;
    logic        s_axi_wvalid;
    logic        s_axi_wready;
    
    // Write response channel
    logic [7:0]  s_axi_bid;
    logic [1:0]  s_axi_bresp;
    logic        s_axi_bvalid;
    logic        s_axi_bready;
    
    // Read address channel
    logic [7:0]  s_axi_arid;
    logic [31:0] s_axi_araddr;
    logic [7:0]  s_axi_arlen;
    logic [2:0]  s_axi_arsize;
    logic [1:0]  s_axi_arburst;
    logic [1:0]  s_axi_arlock;
    logic [3:0]  s_axi_arcache;
    logic [2:0]  s_axi_arprot;
    logic [3:0]  s_axi_arqos;
    logic        s_axi_arvalid;
    logic        s_axi_arready;
    
    // Read data channel
    logic [7:0]  s_axi_rid;
    logic [31:0] s_axi_rdata;
    logic [1:0]  s_axi_rresp;
    logic        s_axi_rlast;
    logic        s_axi_rvalid;
    logic        s_axi_rready;
    
    // Clock generation
    initial begin
        axi_aclk = 0;
        forever #5 axi_aclk = ~axi_aclk; // 100MHz clock
    end
    
    // Reset generation
    initial begin
        axi_aresetn = 0;
        #100 axi_aresetn = 1;
    end
    
    // IBR128 CSR Register addresses (based on the provided CSR module)
    localparam IBR128_IV0   = 5'h00;  // Avalon address 0x00
    localparam IBR128_IV1   = 5'h01;  // Avalon address 0x04
    localparam IBR128_IV2   = 5'h02;  // Avalon address 0x08
    localparam IBR128_IV3   = 5'h03;  // Avalon address 0x0C
    localparam IBR128_KEY0  = 5'h04;  // Avalon address 0x10
    localparam IBR128_KEY1  = 5'h05;  // Avalon address 0x14
    localparam IBR128_KEY2  = 5'h06;  // Avalon address 0x18
    localparam IBR128_KEY3  = 5'h07;  // Avalon address 0x1C
    localparam IBR128_PT0   = 5'h08;  // Avalon address 0x20
    localparam IBR128_PT1   = 5'h09;  // Avalon address 0x24
    localparam IBR128_PT2   = 5'h0A;  // Avalon address 0x28
    localparam IBR128_PT3   = 5'h0B;  // Avalon address 0x2C
    localparam IBR128_CT0   = 5'h0C;  // Avalon address 0x30
    localparam IBR128_CT1   = 5'h0D;  // Avalon address 0x34
    localparam IBR128_CT2   = 5'h0E;  // Avalon address 0x38
    localparam IBR128_CT3   = 5'h0F;  // Avalon address 0x3C
    localparam IBR128_CTRL  = 5'h10;  // Avalon address 0x40
    localparam IBR128_STA   = 5'h11;  // Avalon address 0x44
    
    // AXI4 burst types
    localparam AXI_BURST_FIXED = 2'b00;
    localparam AXI_BURST_INCR  = 2'b01;
    localparam AXI_BURST_WRAP  = 2'b10;
    
    // DUT instantiation
    AXI4_IBR128_Top DUT (
        .axi_aclk(axi_aclk),
        .axi_aresetn(axi_aresetn),
        
        // AXI4 slave interface
        .s_axi_awid(s_axi_awid),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awlen(s_axi_awlen),
        .s_axi_awsize(s_axi_awsize),
        .s_axi_awburst(s_axi_awburst),
        .s_axi_awlock(s_axi_awlock),
        .s_axi_awcache(s_axi_awcache),
        .s_axi_awprot(s_axi_awprot),
        .s_axi_awqos(s_axi_awqos),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_awready(s_axi_awready),
        
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wlast(s_axi_wlast),
        .s_axi_wvalid(s_axi_wvalid),
        .s_axi_wready(s_axi_wready),
        
        .s_axi_bid(s_axi_bid),
        .s_axi_bresp(s_axi_bresp),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_bready(s_axi_bready),
        
        .s_axi_arid(s_axi_arid),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_arlen(s_axi_arlen),
        .s_axi_arsize(s_axi_arsize),
        .s_axi_arburst(s_axi_arburst),
        .s_axi_arlock(s_axi_arlock),
        .s_axi_arcache(s_axi_arcache),
        .s_axi_arprot(s_axi_arprot),
        .s_axi_arqos(s_axi_arqos),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_arready(s_axi_arready),
        
        .s_axi_rid(s_axi_rid),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rresp(s_axi_rresp),
        .s_axi_rlast(s_axi_rlast),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_rready(s_axi_rready)
    );
    
    // Task for AXI4 single write transaction
    task axi_write;
        input [31:0] addr;
        input [31:0] data;
        begin
            // Set up write address channel
            s_axi_awid = 8'h00;
            s_axi_awaddr = addr;
            s_axi_awlen = 8'h00;  // Single transfer
            s_axi_awsize = 3'b010; // 4 bytes per transfer
            s_axi_awburst = AXI_BURST_INCR;
            s_axi_awlock = 2'b00;
            s_axi_awcache = 4'b0000;
            s_axi_awprot = 3'b000;
            s_axi_awqos = 4'b0000;
            s_axi_awvalid = 1'b1;
            
            // Wait for awready
            wait(s_axi_awready);
            @(posedge axi_aclk);
            s_axi_awvalid = 1'b0;
            
            // Set up write data channel
            s_axi_wdata = data;
            s_axi_wstrb = 4'b1111; // All bytes valid
            s_axi_wlast = 1'b1;
            s_axi_wvalid = 1'b1;
            
            // Wait for wready
            wait(s_axi_wready);
            @(posedge axi_aclk);
            s_axi_wvalid = 1'b0;
            
            // Receive write response
            s_axi_bready = 1'b1;
            
            // Wait for bvalid
            wait(s_axi_bvalid);
            @(posedge axi_aclk);
            s_axi_bready = 1'b0;
        end
    endtask
    
    // Task for AXI4 single read transaction
    task axi_read;
        input [31:0] addr;
        output [31:0] data;
        begin
            // Set up read address channel
            s_axi_arid = 8'h00;
            s_axi_araddr = addr;
            s_axi_arlen = 8'h00;  // Single transfer
            s_axi_arsize = 3'b010; // 4 bytes per transfer
            s_axi_arburst = AXI_BURST_INCR;
            s_axi_arlock = 2'b00;
            s_axi_arcache = 4'b0000;
            s_axi_arprot = 3'b000;
            s_axi_arqos = 4'b0000;
            s_axi_arvalid = 1'b1;
            
            // Wait for arready
            wait(s_axi_arready);
            @(posedge axi_aclk);
            s_axi_arvalid = 1'b0;
            
            // Receive read data
            s_axi_rready = 1'b1;
            
            // Wait for rvalid
            wait(s_axi_rvalid);
            data = s_axi_rdata;
            @(posedge axi_aclk);
            s_axi_rready = 1'b0;
        end
    endtask
    
    // Task for burst write transaction
    task axi_burst_write;
        input [31:0] addr;
        input [7:0]  len;  // Number of transfers - 1
        input [31:0] data_array [];
        begin
            // Set up write address channel
            s_axi_awid = 8'h00;
            s_axi_awaddr = addr;
            s_axi_awlen = len;
            s_axi_awsize = 3'b010; // 4 bytes per transfer
            s_axi_awburst = AXI_BURST_INCR;
            s_axi_awlock = 2'b00;
            s_axi_awcache = 4'b0000;
            s_axi_awprot = 3'b000;
            s_axi_awqos = 4'b0000;
            s_axi_awvalid = 1'b1;
            
            // Wait for awready
            wait(s_axi_awready);
            @(posedge axi_aclk);
            s_axi_awvalid = 1'b0;
            
            // Write data
            for (int i = 0; i <= len; i++) begin
                s_axi_wdata = data_array[i];
                s_axi_wstrb = 4'b1111; // All bytes valid
                s_axi_wlast = (i == len);
                s_axi_wvalid = 1'b1;
                
                // Wait for wready
                wait(s_axi_wready);
                @(posedge axi_aclk);
            end
            s_axi_wvalid = 1'b0;
            
            // Receive write response
            s_axi_bready = 1'b1;
            
            // Wait for bvalid
            wait(s_axi_bvalid);
            @(posedge axi_aclk);
            s_axi_bready = 1'b0;
        end
    endtask
    
    // Task for burst read transaction
    task axi_burst_read;
        input [31:0] addr;
        input [7:0]  len;  // Number of transfers - 1
        output [31:0] data_array [];
        begin
            // Allocate array
            data_array = new[len + 1];
            
            // Set up read address channel
            s_axi_arid = 8'h00;
            s_axi_araddr = addr;
            s_axi_arlen = len;
            s_axi_arsize = 3'b010; // 4 bytes per transfer
            s_axi_arburst = AXI_BURST_INCR;
            s_axi_arlock = 2'b00;
            s_axi_arcache = 4'b0000;
            s_axi_arprot = 3'b000;
            s_axi_arqos = 4'b0000;
            s_axi_arvalid = 1'b1;
            
            // Wait for arready
            wait(s_axi_arready);
            @(posedge axi_aclk);
            s_axi_arvalid = 1'b0;
            
            // Receive read data
            s_axi_rready = 1'b1;
            
            for (int i = 0; i <= len; i++) begin
                // Wait for rvalid
                wait(s_axi_rvalid);
                data_array[i] = s_axi_rdata;
                @(posedge axi_aclk);
            end
            s_axi_rready = 1'b0;
        end
    endtask
    
    // Test sequence
    initial begin
        logic [31:0] read_data;
        logic [31:0] burst_data[];
	logic [31:0] burst_read[];
        burst_data = new[12];
        burst_read = new[4];

        // Initialize signals
        s_axi_awvalid = 0;
        s_axi_wvalid = 0;
        s_axi_bready = 0;
        s_axi_arvalid = 0;
        s_axi_rready = 0;
        
        // Wait for reset to complete
        wait(axi_aresetn);
        @(posedge axi_aclk);
        
        // Test scenario 2: Write all IV registers
        $display("Test 2: Write IV Registers");
        axi_write(IBR128_IV0 * 4, 32'h1234_5678);
        axi_write(IBR128_IV1 * 4, 32'h9ABC_DEF0);
        axi_write(IBR128_IV2 * 4, 32'hFEDC_BA98);
        axi_write(IBR128_IV3 * 4, 32'h7654_3210);
        
        // Test scenario 3: Write all KEY registers
        $display("Test 3: Write KEY Registers");
        axi_write(IBR128_KEY0 * 4, 32'hDEAD_BEEF);
        axi_write(IBR128_KEY1 * 4, 32'hC0DE_CAFE);
        axi_write(IBR128_KEY2 * 4, 32'hFACE_B00C);
        axi_write(IBR128_KEY3 * 4, 32'h1234_ABCD);
        
        // Test scenario 4: Write plaintext and check encryption
        $display("Test 4: Write Plaintext and Read Ciphertext");
        axi_write(IBR128_PT0 * 4, 32'h0102_0304);
        axi_write(IBR128_PT1 * 4, 32'h0506_0708);
        axi_write(IBR128_PT2 * 4, 32'h090A_0B0C);
        axi_write(IBR128_PT3 * 4, 32'h0D0E_0F00);
        
        // Trigger encryption
        axi_write(IBR128_CTRL * 4, 32'h0000_002F); // Enable=1, SA=1, Encrypt=1, SOM=1, FB=1

        // Wait for encryption to complete - in real system, polling the STATUS register instead
        repeat (80) @(posedge axi_aclk);
        // axi_read(IBR128_STA * 4, read_data);
        
        // Read ciphertext
        axi_read(IBR128_CT0 * 4, read_data);
        $display("Ciphertext[31:0] = %h", read_data);
        axi_read(IBR128_CT1 * 4, read_data);
        $display("Ciphertext[63:32] = %h", read_data);
        axi_read(IBR128_CT2 * 4, read_data);
        $display("Ciphertext[95:64] = %h", read_data);
        axi_read(IBR128_CT3 * 4, read_data);
        $display("Ciphertext[127:96] = %h", read_data);
        
        repeat (20) @(posedge axi_aclk);
	//Intermediate sequence
	axi_write(IBR128_CTRL * 4, 32'h0000_0000);

        // Test scenario 5: Burst write to multiple registers
        $display("Test 5: Burst Write to Multiple Registers");
        burst_data[0] = 32'h1111_1111;
        burst_data[1] = 32'h2222_2222;
        burst_data[2] = 32'h3333_3333;
        burst_data[3] = 32'h4444_4444;
        burst_data[4] = 32'h1111_1111;
        burst_data[5] = 32'h2222_2222;
        burst_data[6] = 32'h3333_3333;
        burst_data[7] = 32'h4444_4444;
        burst_data[8] = 32'h1111_1111;
        burst_data[9] = 32'h2222_2222;
        burst_data[10] = 32'h3333_3333;
        burst_data[11] = 32'h4444_4444;
        
        // Burst write to IV registers
        axi_burst_write(IBR128_IV0 * 4, 11, burst_data);
        
        // Trigger encryption
        axi_write(IBR128_CTRL * 4, 32'h0000_002F); // Enable=1, SA=1, Encrypt=1, SOM=1, FB=1

        repeat (80) @(posedge axi_aclk);

	axi_burst_read(IBR128_CT0 * 4, 3, burst_read);
        
        // Finish simulation
        #1000;
        $display("Simulation complete");
        $finish;
    end

    // Monitor AXI transactions
    initial begin
        forever begin
            @(posedge axi_aclk);
            if (s_axi_awvalid && s_axi_awready)
                $display("Write Address: %h, ID: %h, Len: %d", s_axi_awaddr, s_axi_awid, s_axi_awlen);
            if (s_axi_wvalid && s_axi_wready)
                $display("Write Data: %h, Strb: %b, Last: %b", s_axi_wdata, s_axi_wstrb, s_axi_wlast);
            if (s_axi_bvalid && s_axi_bready)
                $display("Write Response: ID: %h, Resp: %h", s_axi_bid, s_axi_bresp);
            if (s_axi_arvalid && s_axi_arready)
                $display("Read Address: %h, ID: %h, Len: %d", s_axi_araddr, s_axi_arid, s_axi_arlen);
            if (s_axi_rvalid && s_axi_rready)
                $display("Read Data: %h, ID: %h, Resp: %h, Last: %b", s_axi_rdata, s_axi_rid, s_axi_rresp, s_axi_rlast);
        end
    end

endmodule
