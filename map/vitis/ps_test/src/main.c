//================================================================
// Project name: ps_test
// File    name: axi_uartlite.c
// Header      : axi_uartlite.h
// Author      : pthuang
// Function    : simple test application
//      This application configures UART 16550 to baud rate 9600.
//      PS7 UART (Zynq) is not initialized by this application, 
//      since bootrom/bsp configures it to baud rate 115200
//              
//      ------------------------------------------------
//      | UART TYPE   BAUD RATE                        |
//      ------------------------------------------------
//      uartns550     115200
//      uartlite      Configurable only in HW design
//      ps7_uart      115200 (configured by bootrom/bsp)
//
//
//================================================================

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "axi_uartlite.h"
#include <sleep.h>


int main() {
    init_platform();
    print("platform init done!\n\r");

    // check
    unsigned char uart_state;
    uart_state = uartAxiLiteCheck();
    xil_printf("uart state register vsalue: %3d \r\n", uart_state);

    // transmit
    uartTx (0x55);

    // reveiver
    unsigned char rx_data;
    rx_data = uartRx();
	xil_printf("uart state register vsalue: %3d \r\n", rx_data);


	sleep(1000);
    cleanup_platform();
    return 0;
}
