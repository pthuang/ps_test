/*********************************
File_name:      xxx.v
Project_name:   xxx
Author:         Weitao Zhao
Function:





version: 1.0


log:    2022.06.29 create file v1.0


********************************/
module sync_rst_gen
(
    input           clk_in       ,
    input           async_rst_in , // posedge Async reset
    output          sync_rst_out   // high valid
);

//==================< Internal Declaration >============================
reg            sync_rst;
reg            sync_rst_r;
reg            sync_rst_rr;
reg            sync_rst_rrr;

assign sync_rst_out = sync_rst_rrr;

//=======================< Debug Logic >================================





//=======================< Main Logic >=================================
always@(posedge clk_in or posedge async_rst_in)
begin
    if(async_rst_in)
    begin
        sync_rst     <= 1;
        sync_rst_r   <= 1;
        sync_rst_rr  <= 1;
        sync_rst_rrr <= 1;
    end
    else
    begin
        sync_rst     <= 0;
        sync_rst_r   <=  sync_rst;
        sync_rst_rr  <=  sync_rst_r;
        sync_rst_rrr <=  sync_rst_rr;
    end
end






endmodule