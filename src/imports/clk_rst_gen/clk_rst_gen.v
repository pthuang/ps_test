`timescale 1ns / 1ps

module clk_rst_gen (
    input           clk_50_in       , // 
    output          mmcm_locked     , // 
    output          clk_50          , // 
    output          rst_50          , // 
    output          clk_100         , // 
    output          rst_100         , // 
    output          clk_200         , // 
    output          rst_200         , // 
    output          clk_400         , //          
    output          rst_400           //          
);

    //==================< Internal Declaration >============================
    clk_gen clk_gen (
        .clk_50_in          ( clk_50_in         ), // in 50M
        .clk_400            ( clk_400           ), // out 400M
        .clk_200            ( clk_200           ), // out 200M
        .clk_100            ( clk_100           ), // out 100M
        .clk_50             ( clk_50            ), // out 50M
        .locked             ( mmcm_locked       )  // out locked
    );
    
    sync_rst_gen rst_50_gen  ( .clk_in ( clk_200 ), .async_rst_in ( ~mmcm_locked ), .sync_rst_out ( rst_50  ) );
    sync_rst_gen rst_100_gen ( .clk_in ( clk_100 ), .async_rst_in ( ~mmcm_locked ), .sync_rst_out ( rst_100 ) );
    sync_rst_gen rst_200_gen ( .clk_in ( clk_100 ), .async_rst_in ( ~mmcm_locked ), .sync_rst_out ( rst_200 ) );
    sync_rst_gen rst_400_gen ( .clk_in ( clk_100 ), .async_rst_in ( ~mmcm_locked ), .sync_rst_out ( rst_400 ) );

endmodule
