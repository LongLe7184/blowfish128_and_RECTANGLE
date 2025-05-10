//-----------------------------------------------------------
// Module: Avalon_to_IBR128_Adapter
//-----------------------------------------------------------
// Author    : -
// Date      : May-8th, 2025
// Description: Adapter to convert from 32-bit Avalon interface
//              to the 5-bit address Avalon interface used by IBR128_wrapper
//              Address translation handles word-aligned addressing
//-----------------------------------------------------------

module Avalon_to_IBR128_Adapter (
    // Avalon-MM slave interface (32-bit address)
    input  logic        avl_clk,
    input  logic        avl_reset_n,
    input  logic        avl_cs,
    input  logic        avl_write,
    input  logic        avl_read,
    input  logic [31:0] avl_addr,
    input  logic [31:0] avl_writedata,
    output logic [31:0] avl_readdata,
    input  logic [3:0]  avl_byteenable,
    output logic        avl_waitrequest,
    output logic        avl_readdatavalid,
    
    // IBR128 interface (5-bit address)
    output logic        ibr_clk,
    output logic        ibr_reset_n,
    output logic        ibr_cs,
    output logic        ibr_write,
    output logic        ibr_read,
    output logic [4:0]  ibr_addr,
    output logic [31:0] ibr_writedata,
    input  logic [31:0] ibr_readdata
);

    // Base address configuration - this could be made configurable via parameters
    // localparam [31:0] IBR128_BASE_ADDR = 32'h0000_0000; // Base address in the Avalon address space
    
    // Simple pass-through for most signals
    assign ibr_clk = avl_clk;
    assign ibr_reset_n = avl_reset_n;
    assign ibr_cs = avl_cs;
    assign ibr_addr = avl_addr[6:2]; //Word Aligned address
    assign ibr_write = avl_write;
    assign ibr_read = avl_read;
    assign ibr_writedata = avl_writedata;
    assign avl_readdata = ibr_readdata;
    
    // No wait states for this simple adapter
    assign avl_waitrequest = 1'b0;
    
    // Read data is valid one cycle after read is asserted
    logic read_valid_reg;
    
    always_ff @(posedge avl_clk or negedge avl_reset_n) begin
        if (~avl_reset_n) begin
            read_valid_reg <= 1'b0;
        end else begin
            read_valid_reg <= avl_read;
        end
    end
    
    assign avl_readdatavalid = read_valid_reg;
    
endmodule
