`timescale 1ns/1ps
/***********************************************************************
File_name:      timer_inetrrupt.v
Project_name:   ps_test.xpr
Author:         pthuang
Function:
            timer interrupt for MicroBlaze.

version: 1.0

log:    2023.06.28 create file v0.0

**********************************************************************/
module timer_inetrrupt # ( 
    parameter   TIME_CNT_LEN = 32'd10000      , // default: 10000 * 10 ns = 100 us
    parameter   PULSE_WIDTH  = 32'd100          // default: 100   * 10 ns = 1   us
)
(
    input               clk_100         , // 
    input               rst_100         , // 
    input     [31:00]   pulse_width     , // 
    output reg[14:00]   inetrrupt_pulse      
);

    reg [31:00] cnt_100us;
    reg [11:00] cnt_hold;

    always @(posedge clk_100 or posedge rst_100) begin
        if (rst_100) begin 
            cnt_100us       <= 'h0;
            cnt_hold        <= 'h0;
            inetrrupt_pulse <= 'b0;
        end else begin
            if (cnt_100us == TIME_CNT_LEN - 1) begin
                cnt_100us <= 0;
                inetrrupt_pulse <= 1;
            end else begin
                cnt_100us <= cnt_100us + 1;
            end

            if (inetrrupt_pulse) begin
                if (cnt_hold == PULSE_WIDTH - 1) begin
                // if (cnt_hold == pulse_width - 1) begin
                    cnt_hold <= 0;
                end else begin
                    cnt_hold <= cnt_hold + 1;
                end
            end else begin
                cnt_hold <= 0;
            end 

            if (cnt_100us == TIME_CNT_LEN - 1) begin 
                inetrrupt_pulse <= 1;
            end else if(cnt_hold == PULSE_WIDTH - 1) begin
            // end else if(cnt_hold == pulse_width - 1) begin
                inetrrupt_pulse <= 0;
            end else begin
                inetrrupt_pulse <= inetrrupt_pulse;
            end
        end
    end


endmodule 
