`timescale 1ns/1ps
/***********************************************************************
File_name:      top.v
Project_name:   ps_test.xpr
Author:         pthuang
Function:
            MicroBlaze test platform.

version: 1.0

log:    2023.06.28 create file v0.0

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

    // =========== UART =======================================
    wire            uart_user_rx_evt            ;
    wire[07:00]     uart_user_rx_data           ;
    wire            baud_bps_tb                 ;
    wire            uart_user_tx_evt            ;
    wire[07:00]     uart_user_tx_data           ;
    wire            uart_tx_done                ;

    // =========== SPI =======================================
    wire            spi_rx_evt                  ;
    wire[15:00]     spi_rx_data                 ;

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
        .uart_txd                   ( uart_txd                  )  // output
    );

    timer_inetrrupt # ( 
        .TIME_CNT_LEN               ( 32'd10000                 ), // 10000 * 10 ns = 100 us
        .PULSE_WIDTH                ( 32'd100                   )  // 100   * 10 ns = 1   us
    ) inetrrupt_gen (
        .clk_100                    ( clk_100                   ), // 
        .rst_100                    ( rst_100                   ), // 
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

    // spi_slave # (
    //     .USER_CLK_RATE              ( 32'd200_000_000           ), // user clock rate: 100 MHz
    //     .SPI_CLK_RATE               ( 32'd6_250_000             ), // spi  clock rate: 6.25 MHz
    //     .MCS_VALID_LEVEL            ( 0                         ), //      
    //     .SCK_MODE                   ( 2'b01                     ), //  
    //     .DATA_ENDIAN                ( 1                         ), //     
    //     .OUTPUT_WIDTH               ( 16                        )  // 
    // ) spi_slave (
    //     .user_clk                   ( clk_200                   ), // user clock 
    //     .user_rst                   ( rst_200                   ), // user reset, Async valid hign 
    //     .o_rx_evt                   ( spi_rx_evt                ), // receive data out event(from master)
    //     .o_rx_data                  ( spi_rx_data               ), // data payload
    //     .mcs                        ( spi_ss_o                  ), // 4-line spi in  
    //     .sclk                       ( spi_sck_o                 ), // 4-line spi in  
    //     .mosi                       ( spi_io0_o                 ), // 4-line spi in  
    //     .miso                       ( spi_io1_i                 )  // 4-line spi out   
    // );


    // spi_master # (
    //     .USER_CLK_RATE              ( 32'd100_000_000           ), // Default: 100 MHz
    //     .SPI_CLK_RATE               ( 32'd2_500_000             ), // Default: 2.5 MHz
    //     .MCS_VALID_LEVEL            ( 0                         ), //   
    //     .SCK_MODE                   ( 2'b01                     ), // 
    //     .DATA_ENDIAN                ( 1                         ), //    
    //     .INPUT_WIDTH                ( 16                        ), // 
    //     .OUTPUT_WIDTH               ( 16                        )  // 
    // ) spi_master (
    //     .user_clk                   ( clk_200                   ), // user clock 
    //     .user_rst                   ( rst_200                   ), // user reset, Async valid hign 
    //     .i_rd_evt                   ( 1'b0                      ), // spi read event
    //     .i_wr_evt                   ( spi_rx_evt                ), // spi write event
    //     .i_wr_data                  ( spi_rx_data               ), // data payload
    //     .o_rd_evt                   (                           ), // read data out event(from slave)
    //     .o_rd_data                  (                           ), // data payload  
    //     .mcs                        ( spi_ss_i                  ), // 4-line spi out 
    //     .sclk                       ( spi_sck_i                 ), // 4-line spi out 
    //     .mosi                       ( spi_io0_i                 ), // 4-line spi out 
    //     .miso                       ( spi_io1_o                 )  // 4-line spi in 
    // );

    // ila_temp ila_temp (
    //     .clk            ( clk_200       ), // input wire clk
    //     .probe0         ( spi_rx_evt    ), // input wire [0:0]  probe0  
    //     .probe1         ( spi_rx_data   )  // input wire [15:0]  probe1
    // );



    

endmodule