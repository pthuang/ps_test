`timescale 1ns/1ps
/***********************************************************************
File_name:      top.v
Project_name:   ps_test.xpr
Author:         pthuang
Function:
            MicroBlaze test platform.

version: 1.0

log:    2023.06.28 create file v1.0

**********************************************************************/
module top (
    input               ext_clk_in              , // PL 50M clock 
    // ps DDR2 -----------------------------
    inout      [14:00]  ddr_addr                , //
    inout      [02:00]  ddr_ba                  , //
    inout               ddr_cas_n               , //
    inout               ddr_ck_n                , //
    inout               ddr_ck_p                , //
    inout               ddr_cke                 , //
    inout               ddr_cs_n                , //
    inout      [03:00]  ddr_dm                  , //
    inout      [31:00]  ddr_dq                  , //
    inout      [03:00]  ddr_dqs_n               , //
    inout      [03:00]  ddr_dqs_p               , //
    inout               ddr_odt                 , //
    inout               ddr_ras_n               , //
    inout               ddr_reset_n             , //
    inout               ddr_we_n                , //
    inout               ddr_vrn                 , //
    inout               ddr_vrp                 , //
    // ARM ---------------------------------
    inout      [53:00]  fixed_io_mio            , // mio 
    inout               ps_clk                  , // 
    inout               ps_porb                 , // 
    inout               ps_srstb                , // 
    // -------------------------------------
    output     [02:00]  fpga_led                  // 
);

    // =========== CLOCK & RESET==============================
    wire        mmcm_locked                     ; // 
    wire        clk_50                          ; // 
    wire        rst_50                          ; // 
    wire        clk_100                         ; // 
    wire        rst_100                         ; // 
    wire        clk_200                         ; // 
    wire        rst_200                         ; // 
    wire        clk_400                         ; //          
    wire        rst_400                         ; //      




    // =========== ZYNQ =====================================
    // USB 
    wire        gmii_col    = 'b0               ; // 
    wire        gmii_crs                        ; // 
    wire        gmii_rx_clk                     ; // 
    wire        gmii_rx_dv                      ; // 
    wire        gmii_rx_er  = 'b0               ; // 
    wire[03:00] rmii_rxd                        ;
    wire[07:00] gmii_rxd    = {4'h0,rmii_rxd}   ; // 
    wire        gmii_tx_clk                     ; // 
    wire        gmii_tx_en                      ; // 
    wire        gmii_tx_er                      ; // 
    wire[07:00] gmii_txd                        ; // 
    // IIC 
    wire        iic_scl_i                       ; //
    wire        iic_scl_o                       ; //
    wire        iic_scl_t                       ; //
    wire        iic_sda_i                       ; //
    wire        iic_sda_o                       ; //
    wire        iic_sda_t                       ; //
    // ETH
    wire        eth1_mdc                        ; // 
    wire        eth1_mdio_i                     ; // 
    wire        eth1_mdio_o                     ; // 
    wire        eth1_mdio_t                     ; // 

    // zynq ps-pl-Fabric clock.
    wire        zynq_clk                        ; // 200M
    wire        zynq_resetn                     ; // 

    // =========== MicroBlaze =================================
    wire        gpio_tri_in                     ;
    wire[31:00] gpio_out_tri_o                  ;
    wire        spi_io0_i                       ;
    wire        spi_io0_o                       ;
    wire        spi_io0_t                       ;
    wire        spi_io1_i                       ;
    wire        spi_io1_o                       ;
    wire        spi_io1_t                       ;
    wire        spi_sck_i                       ;
    wire        spi_sck_o                       ;
    wire        spi_sck_t                       ;
    wire        spi_ss_i                        ;
    wire        spi_ss_o                        ;
    wire        spi_ss_t                        ;
    wire        uart_rxd                        ;
    wire        uart_txd                        ;
    wire[31:00] axi_master_araddr               ;
    wire[02:00] axi_master_arprot               ;
    wire        axi_master_arready              ;
    wire        axi_master_arvalid              ;
    wire[31:00] axi_master_awaddr               ;
    wire[02:00] axi_master_awprot               ;
    wire        axi_master_awready              ;
    wire        axi_master_awvalid              ;
    wire        axi_master_bready               ;
    wire[01:00] axi_master_bresp                ;
    wire        axi_master_bvalid               ;
    wire[31:00] axi_master_rdata                ;
    wire        axi_master_rready               ;
    wire[01:00] axi_master_rresp                ;
    wire        axi_master_rvalid               ;
    wire[31:00] axi_master_wdata                ;
    wire        axi_master_wready               ;
    wire[03:00] axi_master_wstrb                ;
    wire        axi_master_wvalid               ;

    wire[31:00] user_reg0                       ; // output reg[31:00] 
    wire[31:00] user_reg1                       ; // output reg[31:00] 
    wire[31:00] user_reg2                       ; // output reg[31:00] 
    wire[31:00] user_reg3                       ; // output reg[31:00] 
    wire[31:00] user_reg4                       ; // output reg[31:00] 
    wire[31:00] user_reg5                       ; // output reg[31:00] 
    wire[31:00] user_reg6                       ; // output reg[31:00] 
    wire[31:00] user_reg7                       ; // output reg[31:00]


    wire[31:00] pulse_width                     ;

    // =========== UART =======================================
    wire        uart_user_rx_evt                ;
    wire[07:00] uart_user_rx_data               ;
    wire        baud_bps_tb                     ;
    wire        uart_user_tx_evt                ;
    wire[07:00] uart_user_tx_data               ;
    wire        uart_tx_done                    ;

    // =========== SPI =======================================
    wire        spi_rx_evt                      ; 
    wire[15:00] spi_rx_data                     ; 

    // =========== Assign =====================================
    assign fpga_led = {2'h0, mmcm_locked};


    clk_rst_gen clk_rst_gen (
        .clk_50_in                  ( ext_clk_in                ), // 
        .mmcm_locked                ( mmcm_locked               ), // 
        .clk_50                     ( clk_50                    ), // 
        .rst_50                     ( rst_50                    ), // 
        .clk_100                    ( clk_100                   ), // 
        .rst_100                    ( rst_100                   ), // 
        .clk_200                    ( clk_200                   ), // 
        .rst_200                    ( rst_200                   ), // 
        .clk_400                    ( clk_400                   ), //          
        .rst_400                    ( rst_400                   )  //          
    );

    zynq zynq (
        .DDR_addr                   ( ddr_addr                  ),
        .DDR_ba                     ( ddr_ba                    ),
        .DDR_cas_n                  ( ddr_cas_n                 ),
        .DDR_ck_n                   ( ddr_ck_n                  ),
        .DDR_ck_p                   ( ddr_ck_p                  ),
        .DDR_cke                    ( ddr_cke                   ),
        .DDR_cs_n                   ( ddr_cs_n                  ),
        .DDR_dm                     ( ddr_dm                    ),
        .DDR_dq                     ( ddr_dq                    ),
        .DDR_dqs_n                  ( ddr_dqs_n                 ),
        .DDR_dqs_p                  ( ddr_dqs_p                 ),
        .DDR_odt                    ( ddr_odt                   ),
        .DDR_ras_n                  ( ddr_ras_n                 ),
        .DDR_reset_n                ( ddr_reset_n               ),
        .DDR_we_n                   ( ddr_we_n                  ),
        .ENET1_EXT_INTIN            ( 1'b0                      ),
        .FIXED_IO_ddr_vrn           ( ddr_vrn                   ),
        .FIXED_IO_ddr_vrp           ( ddr_vrp                   ),
        .FIXED_IO_mio               ( fixed_io_mio              ),
        .FIXED_IO_ps_clk            ( ps_clk                    ),
        .FIXED_IO_ps_porb           ( ps_porb                   ),
        .FIXED_IO_ps_srstb          ( ps_srstb                  ),
        .GMII_ETHERNET_1_col        ( gmii_col                  ), // usb 
        .GMII_ETHERNET_1_crs        ( gmii_crs                  ), // usb 
        .GMII_ETHERNET_1_rx_clk     ( gmii_rx_clk               ), // usb 
        .GMII_ETHERNET_1_rx_dv      ( gmii_rx_dv                ), // usb 
        .GMII_ETHERNET_1_rx_er      ( gmii_rx_er                ), // usb 
        .GMII_ETHERNET_1_rxd        ( gmii_rxd                  ), // usb 
        .GMII_ETHERNET_1_tx_clk     ( gmii_tx_clk               ), // usb 
        .GMII_ETHERNET_1_tx_en      ( gmii_tx_en                ), // usb 
        .GMII_ETHERNET_1_tx_er      ( gmii_tx_er                ), // usb 
        .GMII_ETHERNET_1_txd        ( gmii_txd                  ), // usb 
        .IIC_0_scl_i                ( iic_scl_i                 ), // iic 
        .IIC_0_scl_o                ( iic_scl_o                 ), // iic 
        .IIC_0_scl_t                ( iic_scl_t                 ), // iic 
        .IIC_0_sda_i                ( iic_sda_i                 ), // iic 
        .IIC_0_sda_o                ( iic_sda_o                 ), // iic 
        .IIC_0_sda_t                ( iic_sda_t                 ), // iic 
        .MDIO_ETHERNET_1_mdc        ( eth1_mdc                  ),
        .MDIO_ETHERNET_1_mdio_i     ( eth1_mdio_i               ),
        .MDIO_ETHERNET_1_mdio_o     ( eth1_mdio_o               ),
        .MDIO_ETHERNET_1_mdio_t     ( eth1_mdio_t               ),
        .USBIND_0_port_indctl       (                           ), // usb 
        .USBIND_0_vbus_pwrfault     ( 0                         ), // usb 
        .USBIND_0_vbus_pwrselect    (                           ), // usb 
        .cpu_if_araddr              ( cpu_if_araddr             ),
        .cpu_if_arprot              ( cpu_if_arprot             ),
        .cpu_if_arready             ( cpu_if_arready            ),
        .cpu_if_arvalid             ( cpu_if_arvalid            ),
        .cpu_if_awaddr              ( cpu_if_awaddr             ),
        .cpu_if_awprot              ( cpu_if_awprot             ),
        .cpu_if_awready             ( cpu_if_awready            ),
        .cpu_if_awvalid             ( cpu_if_awvalid            ),
        .cpu_if_bready              ( cpu_if_bready             ),
        .cpu_if_bresp               ( cpu_if_bresp              ),
        .cpu_if_bvalid              ( cpu_if_bvalid             ),
        .cpu_if_rdata               ( cpu_if_rdata              ),
        .cpu_if_rready              ( cpu_if_rready             ),
        .cpu_if_rresp               ( cpu_if_rresp              ),
        .cpu_if_rvalid              ( cpu_if_rvalid             ),
        .cpu_if_wdata               ( cpu_if_wdata              ),
        .cpu_if_wready              ( cpu_if_wready             ),
        .cpu_if_wstrb               ( cpu_if_wstrb              ),
        .cpu_if_wvalid              ( cpu_if_wvalid             ),
        .zynq_clk                   ( zynq_clk                  ),
        .zynq_resetn                ( zynq_resetn               )
    );

     
    mb_sys mb_sys (
        .mb_clk_in                  ( clk_100                   ), // mb system clock 
        .mb_rst_in                  ( rst_100                   ), // mb system reset 
        .mb_clk_locked              ( mmcm_locked               ), // mb system clock locked 
        .gpio_in_tri_i              ( gpio_tri_in               ), // gpio interrupt in 
        .gpio_out_tri_o             ( gpio_out_tri_o            ), // gpio interrupt in 
        .ext_spi_clk_in             ( clk_50                    ), // input For xip and standard modes, ext_spi_clk may be limited to 60 MHz.
        .spi_io0_i                  ( spi_io0_i                 ), // input  MOSI
        .spi_io0_o                  ( spi_io0_o                 ), // output MOSI
        .spi_io0_t                  ( spi_io0_t                 ), // output MOSI
        .spi_io1_i                  ( spi_io1_i                 ), // input  MISO
        .spi_io1_o                  ( spi_io1_o                 ), // output MISO
        .spi_io1_t                  ( spi_io1_t                 ), // output MISO
        .spi_sck_i                  ( spi_sck_i                 ), // input 
        .spi_sck_o                  ( spi_sck_o                 ), // output
        .spi_sck_t                  ( spi_sck_t                 ), // output
        .spi_ss_i                   ( spi_ss_i                  ), // input 
        .spi_ss_o                   ( spi_ss_o                  ), // output
        .spi_ss_t                   ( spi_ss_t                  ), // output
        .uart_rxd                   ( uart_rxd                  ), // input 
        .uart_txd                   ( uart_txd                  ), // output
        .axi_master_araddr          ( axi_master_araddr         ), // output 
        .axi_master_arprot          ( axi_master_arprot         ), // output 
        .axi_master_arready         ( axi_master_arready        ), // input  
        .axi_master_arvalid         ( axi_master_arvalid        ), // output 
        .axi_master_awaddr          ( axi_master_awaddr         ), // output 
        .axi_master_awprot          ( axi_master_awprot         ), // output 
        .axi_master_awready         ( axi_master_awready        ), // input  
        .axi_master_awvalid         ( axi_master_awvalid        ), // output 
        .axi_master_bready          ( axi_master_bready         ), // output 
        .axi_master_bresp           ( axi_master_bresp          ), // input  
        .axi_master_bvalid          ( axi_master_bvalid         ), // input  
        .axi_master_rdata           ( axi_master_rdata          ), // input  
        .axi_master_rready          ( axi_master_rready         ), // output 
        .axi_master_rresp           ( axi_master_rresp          ), // input  
        .axi_master_rvalid          ( axi_master_rvalid         ), // input  
        .axi_master_wdata           ( axi_master_wdata          ), // output 
        .axi_master_wready          ( axi_master_wready         ), // input  
        .axi_master_wstrb           ( axi_master_wstrb          ), // output 
        .axi_master_wvalid          ( axi_master_wvalid         )  // output  
    );

    axi_bridge axi_bridge (
        .axi_clk                    ( clk_100                   ), // input              
        .axi_rst                    ( rst_100                   ), // input              
        .axi_araddr                 ( axi_master_araddr         ), // input     [31:00]  
        .axi_arprot                 ( axi_master_arprot         ), // input     [02:00]  
        .axi_arready                ( axi_master_arready        ), // output             
        .axi_arvalid                ( axi_master_arvalid        ), // input              
        .axi_awaddr                 ( axi_master_awaddr         ), // input     [31:00]  
        .axi_awprot                 ( axi_master_awprot         ), // input     [02:00]  
        .axi_awready                ( axi_master_awready        ), // output             
        .axi_awvalid                ( axi_master_awvalid        ), // input              
        .axi_bready                 ( axi_master_bready         ), // input              
        .axi_bresp                  ( axi_master_bresp          ), // output    [01:00]  
        .axi_bvalid                 ( axi_master_bvalid         ), // output             
        .axi_rdata                  ( axi_master_rdata          ), // output reg[31:00]  
        .axi_rready                 ( axi_master_rready         ), // input              
        .axi_rresp                  ( axi_master_rresp          ), // output    [01:00]  
        .axi_rvalid                 ( axi_master_rvalid         ), // output             
        .axi_wdata                  ( axi_master_wdata          ), // input     [31:00]  
        .axi_wready                 ( axi_master_wready         ), // output             
        .axi_wstrb                  ( axi_master_wstrb          ), // input     [03:00]  
        .axi_wvalid                 ( axi_master_wvalid         ), // input  
        .user_clk                   ( clk_100                   ), // input             
        .user_rst                   ( rst_100                   ), // input             
        .user_rd_data0              ( user_reg0                 ), // output reg[31:00] 
        .user_rd_data1              ( user_reg1                 ), // output reg[31:00] 
        .user_rd_data2              ( user_reg2                 ), // output reg[31:00] 
        .user_rd_data3              ( user_reg3                 ), // output reg[31:00] 
        .user_rd_data4              ( user_reg4                 ), // output reg[31:00] 
        .user_rd_data5              ( user_reg5                 ), // output reg[31:00] 
        .user_rd_data6              ( user_reg6                 ), // output reg[31:00] 
        .user_rd_data7              ( user_reg7                 ), // output reg[31:00] 
        .user_wr_data0              ( user_reg0                 ), // input     [31:00] 
        .user_wr_data1              ( user_reg1                 ), // input     [31:00] 
        .user_wr_data2              ( user_reg2                 ), // input     [31:00] 
        .user_wr_data3              ( user_reg3                 ), // input     [31:00]             
        .user_wr_data4              ( user_reg4                 ), // input     [31:00]             
        .user_wr_data5              ( user_reg5                 ), // input     [31:00]             
        .user_wr_data6              ( user_reg6                 ), // input     [31:00]             
        .user_wr_data7              ( user_reg7                 )  // input     [31:00]             
    );

    timer_inetrrupt # ( 
        .TIME_CNT_LEN               ( 32'd1000000000            ), // 10000 * 10 ns = 10   s
        .PULSE_WIDTH                ( 32'd2                     )  // 2     * 10 ns = 0.02 us
    ) inetrrupt_gen (
        .clk_100                    ( clk_100                   ), // 
        .rst_100                    ( rst_100                   ), // 
        .pulse_width                ( pulse_width               ), // 
        .inetrrupt_pulse            ( gpio_tri_in               )     
    );
    
    uart_rx #(
        .MODULE_CLK_RATE            ( 32'd200000000             ), // user clock rate: 200 MHz
        .UART_BAUDCLK_RATE          ( 32'd115200                )  // spi  baud  rate: 115200 Hz  
    ) uart_rx (
        .clk                        ( clk_200                   ), 
        .rst                        ( rst_200                   ), 
        .uart_rx                    ( uart_txd                  ), 
        .uart_rx_evt_o              ( uart_user_rx_evt          ), 
        .uart_rx_data_o             ( uart_user_rx_data         ), 
        .baud_bps_tb                ( baud_bps_tb               )  // for simulation
    );

    // uart tx user drive logic 
    assign uart_user_tx_evt  = uart_user_rx_evt;
    assign uart_user_tx_data = uart_user_rx_data;

    uart_tx # (
        .MODULE_CLK_RATE            ( 32'd200000000             ), // user clock rate: 200 MHz
        .UART_BAUDCLK_RATE          ( 32'd115200                )  // spi  baud  rate: 115200 Hz  
    ) uart_tx (
        .clk                        ( clk_200                   ), // clock 
        .rst                        ( rst_200                   ), // active high reset
        .uart_tx_evt_i              ( uart_user_tx_evt          ), // tx event 
        .uart_tx_data_i             ( uart_user_tx_data         ), // tx data 
        .uart_tx_done               ( uart_tx_done              ), // tx done  
        .uart_tx                    ( uart_rxd                  )  // 
    );

    ila_temp ila_temp (
        .clk        ( clk_100               ), // input wire clk
        .probe0     ( gpio_tri_in           ), // input wire [0:0]  probe0  
        .probe1     ( axi_master_araddr     ), // input wire [31:0]  probe1 
        .probe2     ( axi_master_arprot     ), // input wire [2:0]  probe2 
        .probe3     ( axi_master_arready    ), // input wire [0:0]  probe3 
        .probe4     ( axi_master_arvalid    ), // input wire [0:0]  probe4 
        .probe5     ( axi_master_awaddr     ), // input wire [31:0]  probe5 
        .probe6     ( axi_master_awprot     ), // input wire [2:0]  probe6 
        .probe7     ( axi_master_awready    ), // input wire [0:0]  probe7 
        .probe8     ( axi_master_awvalid    ), // input wire [0:0]  probe8 
        .probe9     ( axi_master_bready     ), // input wire [0:0]  probe9 
        .probe10    ( axi_master_bresp      ), // input wire [1:0]  probe10 
        .probe11    ( axi_master_bvalid     ), // input wire [0:0]  probe11 
        .probe12    ( axi_master_rdata      ), // input wire [31:0]  probe12 
        .probe13    ( axi_master_rready     ), // input wire [0:0]  probe13 
        .probe14    ( axi_master_rresp      ), // input wire [1:0]  probe14 
        .probe15    ( axi_master_rvalid     ), // input wire [0:0]  probe15 
        .probe16    ( axi_master_wdata      ), // input wire [31:0]  probe16 
        .probe17    ( axi_master_wready     ), // input wire [0:0]  probe17 
        .probe18    ( axi_master_wstrb      ), // input wire [3:0]  probe18 
        .probe19    ( axi_master_wvalid     )  // input wire [0:0]  probe19
    );


    

endmodule