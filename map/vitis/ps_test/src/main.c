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
//#include "xparameters.h"
//#include "xuartlite.h"
#include "xgpio.h"
//#include "xstatus.h"
#include "xintc.h"
//#include "xil_exception.h"
#include "xil_printf.h"
#include "axi_uartlite.h"
#include "axi_gpio.h"
#include <sleep.h>


static XGpio key; // The Instance of the GPIO Driver
static XIntc Intc;


unsigned char key_intr_flag = 0;
unsigned char key_value;



int main() {
	int i;
	unsigned char rx_data;

    init_platform();
    print("platform init done!\n\r");

    gpioInterruptInitial (key, Intc);

    // uart example
    for(i=0; i < 10; i++) {
    	sleep(50);
        // transmit
        uartTx ((unsigned char)i);
        sleep(50);
        // reveiver
        rx_data = uartRx();
    	xil_printf("uart rx: %3d \r\n", rx_data);
    }

    while(1) {
        if (key_intr_flag) {
            key_value = XGpio_DiscreteRead(&key, 1); // read key value.

            uartTx (0x0A);
            if (uartRx() == 0x0A) {
                xil_printf("gpio interrupt Triggered!!!\r\n");
            }

            sleep(5);
            key_intr_flag = 0; // clear interrupt flag 
        }
    }

    cleanup_platform();
    return 0;
}


