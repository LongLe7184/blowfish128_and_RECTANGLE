//-----------------------------------------------------------
// Module: AXI4_IBR128_Top
//-----------------------------------------------------------
// Author    : -
// Date      : May-8th, 2025
// Description: Top-level module connecting AXI4 interface to IBR128
//              through AXI4-to-Avalon bridge and adapter
//-----------------------------------------------------------

module AXI4_IBR128_Top (
    // Global signals
    input  logic        axi_aclk,
    input  logic        axi_aresetn,
    
    // AXI4 slave interface
    // Write address channel
    input  logic [7:0]  s_axi_awid,
    input  logic [31:0] s_axi_awaddr,
    input  logic [7:0]  s_axi_awlen,
    input  logic [2:0]  s_axi_awsize,
    input  logic [1:0]  s_axi_awburst,
    input  logic [1:0]  s_axi_awlock,
    input  logic [3:0]  s_axi_awcache,
    input  logic [2:0]  s_axi_awprot,
    input  logic [3:0]  s_axi_awqos,
    input  logic        s_axi_awvalid,
    output logic        s_axi_awready,
    
    // Write data channel
    input  logic [31:0] s_axi_wdata,
    input  logic [3:0]  s_axi_wstrb,
    input  logic        s_axi_wlast,
    input  logic        s_axi_wvalid,
    output logic        s_axi_wready,
    
    // Write response channel
    output logic [7:0]  s_axi_bid,
    output logic [1:0]  s_axi_bresp,
    output logic        s_axi_bvalid,
    input  logic        s_axi_bready,
    
    // Read address channel
    input  logic [7:0]  s_axi_arid,
    input  logic [31:0] s_axi_araddr,
    input  logic [7:0]  s_axi_arlen,
    input  logic [2:0]  s_axi_arsize,
    input  logic [1:0]  s_axi_arburst,
    input  logic [1:0]  s_axi_arlock,
    input  logic [3:0]  s_axi_arcache,
    input  logic [2:0]  s_axi_arprot,
    input  logic [3:0]  s_axi_arqos,
    input  logic        s_axi_arvalid,
    output logic        s_axi_arready,
    
    // Read data channel
    output logic [7:0]  s_axi_rid,
    output logic [31:0] s_axi_rdata,
    output logic [1:0]  s_axi_rresp,
    output logic        s_axi_rlast,
    output logic        s_axi_rvalid,
    input  logic        s_axi_rready
);

    // Internal signals for standard Avalon interface
    logic        avl_clk;
    logic        avl_reset_n;
    logic        avl_cs;
    logic        avl_write;
    logic        avl_read;
    logic [31:0] avl_addr;
    logic [31:0] avl_writedata;
    logic [31:0] avl_readdata;
    logic [3:0]  avl_byteenable;
    logic        avl_waitrequest;
    logic        avl_readdatavalid;
    
    // Internal signals for IBR128 interface
    logic        ibr_clk;
    logic        ibr_reset_n;
    logic        ibr_cs;
    logic        ibr_write;
    logic        ibr_read;
    logic [4:0]  ibr_addr;
    logic [31:0] ibr_writedata;
    logic [31:0] ibr_readdata;

    // Instantiate AXI4 to Avalon bridge
    AXI4_to_Avalon_Bridge axi4_to_avalon_bridge_inst (
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
        .s_axi_rready(s_axi_rready),
        
        // Avalon-MM interface
        .avl_clk(avl_clk),
        .avl_reset_n(avl_reset_n),
        .avl_cs(avl_cs),
        .avl_write(avl_write),
        .avl_read(avl_read),
        .avl_addr(avl_addr),
        .avl_writedata(avl_writedata),
        .avl_readdata(avl_readdata),
        .avl_byteenable(avl_byteenable),
        .avl_waitrequest(avl_waitrequest),
        .avl_readdatavalid(avl_readdatavalid)
    );
    
    // Instantiate Avalon to IBR128 adapter
    Avalon_to_IBR128_Adapter avalon_to_ibr128_adapter_inst (
        // Avalon-MM slave interface (32-bit address)
        .avl_clk(avl_clk),
        .avl_reset_n(avl_reset_n),
        .avl_cs(avl_cs),
        .avl_write(avl_write),
        .avl_read(avl_read),
        .avl_addr(avl_addr),
        .avl_writedata(avl_writedata),
        .avl_readdata(avl_readdata),
        .avl_byteenable(avl_byteenable),
        .avl_waitrequest(avl_waitrequest),
        .avl_readdatavalid(avl_readdatavalid),
        
        // IBR128 interface (5-bit address)
        .ibr_clk(ibr_clk),
        .ibr_reset_n(ibr_reset_n),
        .ibr_cs(ibr_cs),
        .ibr_write(ibr_write),
        .ibr_read(ibr_read),
        .ibr_addr(ibr_addr),
        .ibr_writedata(ibr_writedata),
        .ibr_readdata(ibr_readdata)
    );
    
    // Instantiate IBR128_wrapper
    IBR128_wrapper ibr128_wrapper_inst (
        .Clk(ibr_clk),
        .RstN(ibr_reset_n),
        .CS(ibr_cs),
        .Write(ibr_write),
        .Read(ibr_read),
        .Addr(ibr_addr),
        .WData(ibr_writedata),
        .RData(ibr_readdata)
    );

endmodule
