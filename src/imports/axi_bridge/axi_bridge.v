`timescale 1ns/1ps
/***********************************************************************
File_name:      axi_bridge.v
Project_name:   ps_test.xpr
Author:         pthuang
Function:
            axi_bridge between ps and pl 

version: 1.0

log:    2023.07.05 create file v1.0

**********************************************************************/
module axi_bridge (
    // axi port signals 
    input               axi_clk         , // axi clock.
    input               axi_rst         , // axi reset.
    input     [31:00]   axi_araddr      , // read  address  channel.
    input     [02:00]   axi_arprot      , // read  address  channel. protection type
    output reg          axi_arready     , // read  address  channel.
    input               axi_arvalid     , // read  address  channel.
    output reg[31:00]   axi_rdata       , // read  data     channel.
    input               axi_rready      , // read  data     channel.
    output reg[01:00]   axi_rresp       , // read  data     channel. read response.
    output reg          axi_rvalid      , // read  data     channel.
    input     [31:00]   axi_awaddr      , // write address  channel.
    input     [02:00]   axi_awprot      , // write address  channel. protection type
    output reg          axi_awready     , // write address  channel.
    input               axi_awvalid     , // write address  channel.
    input     [31:00]   axi_wdata       , // write data     channel.
    output reg          axi_wready      , // write data     channel.
    input     [03:00]   axi_wstrb       , // write data     channel. strobe 
    input               axi_wvalid      , // write data     channel.
    input               axi_bready      , // write response channel.
    output reg[01:00]   axi_bresp       , // write response channel.
    output reg          axi_bvalid      , // write response channel.
    // user port signals 
    input               user_clk        , // 
    input               user_rst        , // 
    output reg[31:00]   user_rd_data0   , // 
    output reg[31:00]   user_rd_data1   , // 
    output reg[31:00]   user_rd_data2   , // 
    output reg[31:00]   user_rd_data3   , // 
    output reg[31:00]   user_rd_data4   , // 
    output reg[31:00]   user_rd_data5   , // 
    output reg[31:00]   user_rd_data6   , // 
    output reg[31:00]   user_rd_data7   , // 
    input     [31:00]   user_wr_data0   , // 
    input     [31:00]   user_wr_data1   , // 
    input     [31:00]   user_wr_data2   , // 
    input     [31:00]   user_wr_data3   , // 
    input     [31:00]   user_wr_data4   , // 
    input     [31:00]   user_wr_data5   , // 
    input     [31:00]   user_wr_data6   , // 
    input     [31:00]   user_wr_data7     // 
);

    reg [31:00]     read_addr; //  
    reg [31:00]     read_regtable[07:00];
    reg [31:00]     read_regtable_r0[07:00];
    reg [31:00]     read_regtable_r1[07:00]; 

    reg [31:00]     write_addr; //  
    reg [31:00]     write_data; //  
    reg             write_evt;
    reg [31:00]     rw_regtable[07:00];
    reg [31:00]     rw_regtable_r0[07:00];
    reg [31:00]     rw_regtable_r1[07:00];

    

    // ===================== axi read logic =======================================
    always @(posedge axi_clk or posedge axi_rst) begin
        if (axi_rst) begin 
            axi_arready <= 'b1;
            read_addr   <= 'h0; 
        end else begin
            if (axi_arvalid) begin 
                axi_arready <= 0; 
            end else begin
                axi_arready <= 1;  
            end
            // axi_arprot: 000 means Transcations is Normal Secure and Data attribute.
            if (axi_arready && axi_arvalid && axi_arprot == 3'b000) begin
                read_addr <= {16'h0,axi_araddr[15:02],2'h0};
            end
        end
    end

    always @(posedge axi_clk) begin
        read_regtable[0] <= user_wr_data0;
        read_regtable[1] <= user_wr_data1;
        read_regtable[2] <= user_wr_data2;
        read_regtable[3] <= user_wr_data3;
        read_regtable[4] <= user_wr_data4;
        read_regtable[5] <= user_wr_data5;
        read_regtable[6] <= user_wr_data6;
        read_regtable[7] <= user_wr_data7;
    end

    generate
        begin: gen0 
            genvar i;
            for (i = 0; i < 8; i = i + 1)
            begin: axi_read 
                always @(posedge axi_clk) begin
                    read_regtable_r0[i] <= read_regtable[i];
                    read_regtable_r1[i] <= read_regtable_r0[i];
                end
            end
        end 
    endgenerate

    always @(posedge axi_clk or posedge axi_rst) begin
        if (axi_rst) begin 
            axi_rvalid <= 'b0;
            axi_rdata  <= 'h0; 
            axi_rresp  <= 'h0; 
        end else begin
            if (axi_arvalid) begin 
                axi_rvalid <= 1;
            end else if (axi_rready && axi_rvalid) begin
                axi_rvalid <= 0; 
            end else begin
                axi_rvalid <= axi_rvalid;
            end

            if (axi_rready && axi_rvalid) begin
                axi_rresp <= 2'h0; // OKAY
                case(read_addr) 
                32'd0   : axi_rdata <= rw_regtable[0]; 
                32'd1   : axi_rdata <= rw_regtable[1]; 
                32'd2   : axi_rdata <= rw_regtable[2]; 
                32'd3   : axi_rdata <= rw_regtable[3]; 
                32'd4   : axi_rdata <= rw_regtable[4]; 
                32'd5   : axi_rdata <= rw_regtable[5]; 
                32'd6   : axi_rdata <= rw_regtable[6]; 
                32'd7   : axi_rdata <= rw_regtable[7]; 
                32'd8   : axi_rdata <= read_regtable_r1[0]; 
                32'd9   : axi_rdata <= read_regtable_r1[1]; 
                32'd10  : axi_rdata <= read_regtable_r1[2]; 
                32'd11  : axi_rdata <= read_regtable_r1[3]; 
                32'd12  : axi_rdata <= read_regtable_r1[4]; 
                32'd13  : axi_rdata <= read_regtable_r1[5]; 
                32'd14  : axi_rdata <= read_regtable_r1[6]; 
                32'd15  : axi_rdata <= read_regtable_r1[7]; 
                default : axi_rdata <= 32'h0         ; 
                endcase 
            end
        end
    end


    // ===================== axi write logic =======================================
    always @(posedge axi_clk or posedge axi_rst) begin
        if (axi_rst) begin
            axi_awready <= 'b1;
            write_addr  <= 'h0;
        end else begin
            if (axi_awvalid) begin 
                axi_awready <= 0; 
            end else begin 
                axi_awready <= 1;  
            end
            // axi_arprot: 000 means Transcations is Normal Secure and Data attribute.
            if (axi_awready && axi_awvalid && axi_awprot == 3'b000) begin
                write_addr <= {16'h0,axi_awaddr[15:02],2'h0}; 
            end
        end
    end

    always @(posedge axi_clk or posedge axi_rst) begin
        if (axi_rst) begin
            axi_wready <= 'b1;
            write_data <= 'h0;
            write_evt  <= 'b0;
        end else begin 
            if (axi_wvalid) begin 
                axi_wready <= 0; 
            end else begin 
                axi_wready <= 1;  
            end 
            // All 4 Byte Valid.
            write_evt <= 0;
            if (axi_wready && axi_wvalid && axi_wstrb == 4'hF) begin
                write_data <= axi_wdata;
                write_evt  <= 1;
            end
        end
    end

    always @(posedge axi_clk or posedge axi_rst) begin
        if (axi_rst) begin
            axi_bvalid   <= 'b0;
            axi_bresp    <= 'h0;
        end else begin 
            if (write_evt) begin
                axi_bvalid <= 1;
            end else if(axi_bready && axi_bvalid) begin
                axi_bvalid <= 0;
            end else begin
                axi_bvalid <= axi_bvalid;
            end

            if (write_evt) begin
                axi_bresp  <= 2'h0; // OKAY
            end
        end
    end

    always @(posedge axi_clk or posedge axi_rst) begin
        if (axi_rst) begin
            rw_regtable[0] <= 'h0;
            rw_regtable[1] <= 'h0;
            rw_regtable[2] <= 'h0;
            rw_regtable[3] <= 'h0;
            rw_regtable[4] <= 'h0;
            rw_regtable[5] <= 'h0;
            rw_regtable[6] <= 'h0;
            rw_regtable[7] <= 'h0;
        end else begin
            if (axi_bready && axi_bvalid) begin
                case(write_addr)
                32'd0   : rw_regtable[0] <= write_data;
                32'd1   : rw_regtable[1] <= write_data;
                32'd2   : rw_regtable[2] <= write_data;
                32'd3   : rw_regtable[3] <= write_data;
                32'd4   : rw_regtable[4] <= write_data;
                32'd5   : rw_regtable[5] <= write_data;
                32'd6   : rw_regtable[6] <= write_data;
                32'd7   : rw_regtable[7] <= write_data;
                default : ;
                endcase
            end  
        end
    end 

    generate
        begin : gen1 
            genvar i;
            for (i = 0; i < 8; i = i + 1)
            begin: axi_write 
                always @(posedge axi_clk) begin
                    rw_regtable_r0[i] <= rw_regtable[i];
                    rw_regtable_r1[i] <= rw_regtable_r0[i];
                end
            end
        end 
    endgenerate

    always @(posedge user_clk) begin  
        user_rd_data0 <= rw_regtable_r1[0];
        user_rd_data1 <= rw_regtable_r1[1];
        user_rd_data2 <= rw_regtable_r1[2];
        user_rd_data3 <= rw_regtable_r1[3];
        user_rd_data4 <= rw_regtable_r1[4];
        user_rd_data5 <= rw_regtable_r1[5];
        user_rd_data6 <= rw_regtable_r1[6];
        user_rd_data7 <= rw_regtable_r1[7];
    end



endmodule 
