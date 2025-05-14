//-----------------------------------------------------------
// Module: AXI4_to_Avalon_Bridge
//-----------------------------------------------------------
// Date      : May-8th, 2025
// Description: Bridge to convert AXI4 interface to Avalon interface
//              BUS WIDTH: 32-bit
//-----------------------------------------------------------

module AXI4_to_Avalon_Bridge (
    // Global signals
    input  logic        axi_aclk,
    input  logic        axi_aresetn,
    
    // AXI4 slave interface
    // Write address channel
    input  logic [7:0]  s_axi_awid,
    input  logic [31:0] s_axi_awaddr,
    input  logic [7:0]  s_axi_awlen,    // Burst length (0 to 255)
    input  logic [2:0]  s_axi_awsize,   // Burst size (0=1B, 1=2B, 2=4B, etc.)
    input  logic [1:0]  s_axi_awburst,  // Burst type (00=FIXED, 01=INCR, 10=WRAP)
    input  logic [1:0]  s_axi_awlock,   // Lock type
    input  logic [3:0]  s_axi_awcache,  // Cache type
    input  logic [2:0]  s_axi_awprot,   // Protection type
    input  logic [3:0]  s_axi_awqos,    // Quality of Service
    input  logic        s_axi_awvalid,
    output logic        s_axi_awready,
    
    // Write data channel
    input  logic [31:0] s_axi_wdata,
    input  logic [3:0]  s_axi_wstrb,
    input  logic        s_axi_wlast,    // Last transfer in burst
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
    input  logic [7:0]  s_axi_arlen,    // Burst length (0 to 255)
    input  logic [2:0]  s_axi_arsize,   // Burst size (0=1B, 1=2B, 2=4B, etc.)
    input  logic [1:0]  s_axi_arburst,  // Burst type (00=FIXED, 01=INCR, 10=WRAP)
    input  logic [1:0]  s_axi_arlock,   // Lock type
    input  logic [3:0]  s_axi_arcache,  // Cache type
    input  logic [2:0]  s_axi_arprot,   // Protection type
    input  logic [3:0]  s_axi_arqos,    // Quality of Service
    input  logic        s_axi_arvalid,
    output logic        s_axi_arready,
    
    // Read data channel
    output logic [7:0]  s_axi_rid,
    output logic [31:0] s_axi_rdata,
    output logic [1:0]  s_axi_rresp,
    output logic        s_axi_rlast,
    output logic        s_axi_rvalid,
    input  logic        s_axi_rready,
    
    // Avalon-MM interface
    output logic        avl_clk,
    output logic        avl_reset_n,
    output logic        avl_cs,
    output logic        avl_write,
    output logic        avl_read,
    output logic [31:0] avl_addr,   // 32-bit address
    output logic [31:0] avl_writedata,
    input  logic [31:0] avl_readdata,
    output logic [3:0]  avl_byteenable,
    input  logic        avl_waitrequest,
    input  logic        avl_readdatavalid
);

    // AXI response codes
    localparam AXI_RESP_OKAY   = 2'b00;
    localparam AXI_RESP_EXOKAY = 2'b01;
    localparam AXI_RESP_SLVERR = 2'b10;
    localparam AXI_RESP_DECERR = 2'b11;
    
    // AXI burst types
    localparam AXI_BURST_FIXED = 2'b00;
    localparam AXI_BURST_INCR  = 2'b01;
    localparam AXI_BURST_WRAP  = 2'b10;
    
    // State machine for write transactions
    typedef enum logic [2:0] {
        WRITE_IDLE,
        // WRITE_ADDR,
        WRITE_DATA,
        WRITE_WAIT,
        WRITE_RESPONSE
    } write_state_t;
    
    // State machine for read transactions
    typedef enum logic [2:0] {
        READ_IDLE,
        READ_ADDR,
        READ_WAIT,
        READ_DATA
        // READ_RESPONSE
    } read_state_t;
    
    write_state_t write_state, next_write_state;
    read_state_t  read_state, next_read_state;
    
    // Registered signals for write channel
    logic [7:0]  write_id_reg;
    logic [31:0] write_addr_reg;
    logic [7:0]  write_burst_len_reg;
    logic [7:0]  write_burst_count;
    logic [1:0]  write_burst_type_reg;
    
    // Registered signals for read channel
    logic [7:0]  read_id_reg;
    logic [31:0] read_addr_reg;
    logic [7:0]  read_burst_len_reg;
    logic [7:0]  read_burst_count;
    logic [1:0]  read_burst_type_reg;
    
    // Connect clock and reset
    assign avl_clk = axi_aclk;
    assign avl_reset_n = axi_aresetn;
    
    //-----------------------------------------------------------
    // Write Transaction State Machine
    //-----------------------------------------------------------
    always_ff @(posedge axi_aclk or negedge axi_aresetn) begin
        if (~axi_aresetn) begin
            write_state <= WRITE_IDLE;
            write_id_reg <= '0;
            write_addr_reg <= '0;
            write_burst_len_reg <= '0;
            write_burst_count <= '0;
            write_burst_type_reg <= '0;
        end else begin
            write_state <= next_write_state;
            
            // Handle write address capture
            if (s_axi_awvalid && s_axi_awready) begin
                write_id_reg <= s_axi_awid;
                write_addr_reg <= s_axi_awaddr;
                write_burst_len_reg <= s_axi_awlen;
                write_burst_type_reg <= s_axi_awburst;
                write_burst_count <= '0;
            end
            
            // Update burst count and address for burst transactions
            if (write_state == WRITE_DATA && s_axi_wvalid && s_axi_wready) begin
                write_burst_count <= write_burst_count + 1'b1;
                
                // Update address for next transfer in burst
                if (write_burst_type_reg == AXI_BURST_INCR) begin
                    write_addr_reg <= write_addr_reg + 4; // Increment by 4 bytes (32 bits)
                end
            end
        end
    end
    
    // Write state machine next state logic
    always_comb begin
        next_write_state = write_state;
        
        case (write_state)
            WRITE_IDLE: begin
                if (s_axi_awvalid) begin
                    // next_write_state = WRITE_ADDR;
                    next_write_state = WRITE_DATA;
                end
            end
            
	    /*This state is no longer need since the s_axi_wready signal only depend on avl_wait_request*/
            // WRITE_ADDR: begin
                // next_write_state = WRITE_DATA;
            // end
            
            WRITE_DATA: begin
                if (s_axi_wvalid) begin
                    // If avalon is not ready, go to wait state
                    if (avl_waitrequest) begin
                        next_write_state = WRITE_WAIT;
                    end
                    // If this is the last transfer in the burst
                    else if (s_axi_wlast) begin
                        next_write_state = WRITE_RESPONSE;
                    end
                end
            end
            
            WRITE_WAIT: begin
                // Wait until Avalon is ready
                if (!avl_waitrequest) begin
                    // If this was the last transfer in burst
                    if (write_burst_count == write_burst_len_reg) begin
                        next_write_state = WRITE_RESPONSE;
                    end else begin
                        next_write_state = WRITE_DATA;
                    end
                end
            end
            
            WRITE_RESPONSE: begin
                if (s_axi_bready) begin
                    next_write_state = WRITE_IDLE;
                end
            end
            
            default: next_write_state = WRITE_IDLE;
        endcase
    end
    
    // Write address channel control signals
    assign s_axi_awready = (write_state == WRITE_IDLE);
    
    // Write data channel control signals
    // assign s_axi_wready = (write_state == WRITE_DATA) && !avl_waitrequest;
    assign s_axi_wready = !avl_waitrequest;
    
    // Write response channel control signals
    assign s_axi_bid = write_id_reg;
    assign s_axi_bresp = AXI_RESP_OKAY; // Always return OKAY
    assign s_axi_bvalid = (write_state == WRITE_RESPONSE);
    
    // Avalon write control signals
    assign avl_write = (write_state == WRITE_DATA || write_state == WRITE_WAIT) && s_axi_wvalid;
    assign avl_addr = (avl_write) ? write_addr_reg : 
                     (avl_read)  ? read_addr_reg  : '0;
    assign avl_writedata = s_axi_wdata;
    assign avl_byteenable = s_axi_wstrb;
    assign avl_cs = avl_write | avl_read;
    
    //-----------------------------------------------------------
    // Read Transaction State Machine
    //-----------------------------------------------------------
    always_ff @(posedge axi_aclk or negedge axi_aresetn) begin
        if (~axi_aresetn) begin
            read_state <= READ_IDLE;
            read_id_reg <= '0;
            read_addr_reg <= '0;
            read_burst_len_reg <= '0;
            read_burst_count <= '0;
            read_burst_type_reg <= '0;
        end else begin
            read_state <= next_read_state;
            
            // Handle read address capture
            if (s_axi_arvalid && s_axi_arready) begin
                read_id_reg <= s_axi_arid;
                read_addr_reg <= s_axi_araddr;
                read_burst_len_reg <= s_axi_arlen;
                read_burst_type_reg <= s_axi_arburst;
                read_burst_count <= '0;
            end
            
            // Update burst count and address for burst transactions
            if (read_state == READ_DATA && avl_readdatavalid) begin
                read_burst_count <= read_burst_count + 1'b1;
                
                // Update address for next transfer in burst
                if (read_burst_type_reg == AXI_BURST_INCR) begin
                    read_addr_reg <= read_addr_reg + 4; // Increment by 4 bytes (32 bits)
                end
            end
        end
    end
    
    // Read state machine next state logic
    always_comb begin
        next_read_state = read_state;
        
        case (read_state)
            READ_IDLE: begin
                if (s_axi_arvalid) begin
                    next_read_state = READ_ADDR;
                end
            end
            
            READ_ADDR: begin
                next_read_state = READ_WAIT;
            end
            
            READ_WAIT: begin
                // If Avalon is not ready, stay in wait state
                if (!avl_waitrequest) begin
                    next_read_state = READ_DATA;
                end
            end
            
            READ_DATA: begin
                // If all data in burst has been received
                if (avl_readdatavalid && (read_burst_count == read_burst_len_reg)) begin
                    // Go directly back to IDLE state after last beat
                    // This avoids waiting for rready which may have already been deasserted
                    next_read_state = READ_IDLE;
                end
            end
            
            // This state is no longer needed, causing dead block in read burst
            // READ_RESPONSE: begin
                // next_read_state = READ_IDLE;
            // end
            
            default: next_read_state = READ_IDLE;
        endcase
    end
    
    // Read address channel control signals
    assign s_axi_arready = (read_state == READ_IDLE);
    
    // Read data channel control signals
    assign s_axi_rid = read_id_reg;
    assign s_axi_rdata = avl_readdata;
    assign s_axi_rresp = AXI_RESP_OKAY; // Always return OKAY
    
    // FIX: Assert rvalid whenever Avalon provides valid read data
    assign s_axi_rvalid = avl_readdatavalid;
    
    // FIX: Assert rlast only on the last beat of the burst
    assign s_axi_rlast = avl_readdatavalid && (read_burst_count == read_burst_len_reg);
    
    // Avalon read control signals
    assign avl_read = (read_state == READ_WAIT || read_state == READ_DATA) && !avl_readdatavalid;
    
endmodule
