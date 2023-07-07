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
    reg [31:00]     write_addr; //  
    reg [31:00]     write_data; //  
    reg             write_evt;
    reg             wdata_finish;
    reg [05:00]     cnt_wd_finish;

    reg [02:00]     wdata_finish_r; 
    reg [31:00]     rw_regtable[07:00];
    reg [31:00]     rd_regtable[07:00];
    

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
                read_addr <= axi_araddr;
            end
        end
    end

    always @(posedge user_clk) begin
        rd_regtable[0] <= user_wr_data0;
        rd_regtable[1] <= user_wr_data1;
        rd_regtable[2] <= user_wr_data2;
        rd_regtable[3] <= user_wr_data3;
        rd_regtable[4] <= user_wr_data4;
        rd_regtable[5] <= user_wr_data5;
        rd_regtable[6] <= user_wr_data6;
        rd_regtable[7] <= user_wr_data7;
    end

    always @(posedge axi_clk or posedge axi_rst) begin
        if (axi_rst) begin 
            axi_rvalid <= 'b0;
            axi_rdata  <= 'h0; 
            axi_rresp  <= 'h0; 
        end else begin
            if (axi_rready) begin
                if (axi_rvalid) begin 
                    axi_rvalid <= 0;
                end else begin
                    axi_rvalid <= 1; 
                end
            end else begin
                axi_rvalid <= 0;
            end

            if (axi_rready && axi_rvalid) begin
                axi_rresp <= 2'h0; // OKAY
                case(read_addr) 
                0       : axi_rdata <= rw_regtable[0]; 
                1       : axi_rdata <= rw_regtable[1]; 
                2       : axi_rdata <= rw_regtable[2]; 
                3       : axi_rdata <= rw_regtable[3]; 
                4       : axi_rdata <= rw_regtable[4]; 
                5       : axi_rdata <= rw_regtable[5]; 
                6       : axi_rdata <= rw_regtable[6]; 
                7       : axi_rdata <= rw_regtable[7]; 
                8       : axi_rdata <= rd_regtable[0]; 
                9       : axi_rdata <= rd_regtable[1]; 
                10      : axi_rdata <= rd_regtable[2]; 
                11      : axi_rdata <= rd_regtable[3]; 
                12      : axi_rdata <= rd_regtable[4]; 
                13      : axi_rdata <= rd_regtable[5]; 
                14      : axi_rdata <= rd_regtable[6]; 
                15      : axi_rdata <= rd_regtable[7]; 
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
                write_addr <= axi_awaddr;
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
            wdata_finish <= 'b0;
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
            wdata_finish <= 'b0; 
        end else begin 
            if (axi_bready && axi_bvalid) begin
                wdata_finish <= 1;
            end else if (wdata_finish && cnt_wd_finish == 6'd15) begin
                wdata_finish <= 0;
            end else begin
                wdata_finish <= wdata_finish; 
            end

            if (cnt_wd_finish == 6'd15) begin
                cnt_wd_finish <= 'h0;
            end else if(wdata_finish) begin
                cnt_wd_finish <= cnt_wd_finish + 1;
            end else begin
                cnt_wd_finish <= cnt_wd_finish;
            end
        end
    end


    always @(posedge user_clk) begin
        wdata_finish_r[0] <= wdata_finish;
        wdata_finish_r[1] <= wdata_finish_r[0];
        wdata_finish_r[2] <= wdata_finish_r[1];
    end 

    always @(posedge user_clk or posedge user_rst) begin
        if (user_rst) begin 
            rw_regtable[0] <= 'h0;
            rw_regtable[1] <= 'h0;
            rw_regtable[2] <= 'h0;
            rw_regtable[3] <= 'h0;
            rw_regtable[4] <= 'h0;
            rw_regtable[5] <= 'h0;
            rw_regtable[6] <= 'h0;
            rw_regtable[7] <= 'h0;
        end else begin 
            if (wdata_finish_r[2:1] == 2'b01) begin
                case(write_addr)
                0       : rw_regtable[0] <= write_data;
                1       : rw_regtable[1] <= write_data;
                2       : rw_regtable[2] <= write_data;
                3       : rw_regtable[3] <= write_data;
                4       : rw_regtable[4] <= write_data;
                5       : rw_regtable[5] <= write_data;
                6       : rw_regtable[6] <= write_data;
                7       : rw_regtable[7] <= write_data;
                default : ;
                endcase
            end
        end 
    end 

    always @(posedge user_clk) begin
        user_rd_data0 <= rw_regtable[0];
        user_rd_data1 <= rw_regtable[1];
        user_rd_data2 <= rw_regtable[2];
        user_rd_data3 <= rw_regtable[3];
        user_rd_data4 <= rw_regtable[4];
        user_rd_data5 <= rw_regtable[5];
        user_rd_data6 <= rw_regtable[6];
        user_rd_data7 <= rw_regtable[7];
    end



endmodule 
