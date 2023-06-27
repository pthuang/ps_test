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
    wire        zynq_aclk                       ; // 200M
    wire        zynq_aresetn                    ; // 

    // =========== MicroBlaze =================================
    wire        gpio_tri_in                     ;
    wire        spi_io0_i                       ;
    wire        spi_io0_o                       ;
    wire        spi_io0_t                       ;
    wire        spi_io1_i                       ;
    wire        spi_io1_o                       ;
    wire        spi_io1_t                       ;
    wire        spi_ss_i                        ;
    wire        spi_ss_o                        ;
    wire        spi_ss_t                        ;
    wire        uart_rxd                        ;
    wire        uart_txd                        ;

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
        .FIXED_IO_mio               ( FIXED_IO_mio              ),
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

    assign uart_rxd = uart_txd; 
    mb_sys mb_sys (
        .mb_clk_in                  ( clk_100                   ), // mb system clock 
        .mb_rst_in                  ( rst_100                   ), // mb system reset 
        .mb_clk_locked              ( mmcm_locked               ), // mb system clock locked 
        .gpio_in_tri_i              ( gpio_tri_in               ), // gpio interrupt in 
        .spi_io0_i                  ( spi_io0_i                 ), // input 
        .spi_io0_o                  ( spi_io0_o                 ), // output
        .spi_io0_t                  ( spi_io0_t                 ), // output
        .spi_io1_i                  ( spi_io1_i                 ), // input 
        .spi_io1_o                  ( spi_io1_o                 ), // output
        .spi_io1_t                  ( spi_io1_t                 ), // output
        .spi_ss_i                   ( spi_ss_i                  ), // input 
        .spi_ss_o                   ( spi_ss_o                  ), // output
        .spi_ss_t                   ( spi_ss_t                  ), // output
        .uart_rxd                   ( uart_rxd                  ), // input 
        .uart_txd                   ( uart_txd                  )  // output
    );

    

endmodule