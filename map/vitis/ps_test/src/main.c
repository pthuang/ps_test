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
#include "xparameters.h"
#include "xuartlite.h"
#include "xgpio.h"
#include "xstatus.h"
#include "xintc.h"
#include "xil_exception.h"
#include "xil_printf.h"
#include "axi_uartlite.h"
#include "axi_gpio.h"
#include <sleep.h>


#define GPIO_DEVICE_ID   XPAR_GPIO_0_DEVICE_ID
#define INTC_DEVICE_ID   XPAR_INTC_0_DEVICE_ID
#define AXI_GPIO_INTR_ID XPAR_INTC_0_GPIO_0_VEC_ID
#define EXCEPTION_ID     XIL_EXCEPTION_ID_INT

static XGpio key; // The Instance of the GPIO Driver
static XIntc Intc;

void GpioHandler(void *CallbackRef);


unsigned char key_intr_flag = 0;
unsigned char key_value;

int main() {
    init_platform();
    print("platform init done!\n\r");

    // uart example
    int i;
    for(i=0; i < 10; i++) {
        // xil_printf("uart state register value: %3d \r\n", uartAxiLiteCheck());
        // transmit
        uartTx ((unsigned char)i);
        // reveiver
        unsigned char rx_data;
        rx_data = uartRx();
    	xil_printf("uart state register vsalue: %3d \r\n", rx_data);
    }

    // Device Initial
    XGpio_Initialize(&key, GPIO_DEVICE_ID);
    XGpio_SetDataDirection(&key, 1, 0x01); // FFFF set as input 

    // Initial Interrupt Controler
	XIntc_Initialize(&Intc, INTC_DEVICE_ID);

    // Associate interrupt ID and interrupt service function
    // The interrupt service function is a function that needs to be written by ourselves to respond to and handle AXI GPIO interrupts
	XIntc_Connect(&Intc,AXI_GPIO_INTR_ID,(Xil_ExceptionHandler)GpioHandler,&key);

	// Enable GPIO interrupt
	XGpio_InterruptEnable(&key, 1);
	// Enable GPIO global interrupt
	XGpio_InterruptGlobalEnable(&key);

    // Enable the interrupt vector corresponding to the peripheral
	XIntc_Enable(&Intc, AXI_GPIO_INTR_ID);

    // start interrupt controller
	XIntc_Start(&Intc, XIN_REAL_MODE);

    // Set and open interrupt exception handling
	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(EXCEPTION_ID, (Xil_ExceptionHandler)XIntc_InterruptHandler,&Intc);
	Xil_ExceptionEnable();


    while(1) {
        if (key_intr_flag) {
            key_value = XGpio_DiscreteRead(&key, 1); // read key value.

            uartTx (0x0A);
            if (uartRx() == 0x0A) {
                xil_printf("gpio interrupt Triggered!!!\r\n");
            }

            sleep(1);
            key_intr_flag = 0; // clear interrupt flag 
        }
    }

    cleanup_platform();
    return 0;
}

void GpioHandler(void *CallbackRef){
    XGpio *GpioPtr = (XGpio *)CallbackRef;
        key_intr_flag = 1;
        print("gpio interrupt\n\r");
        XGpio_InterruptDisable(GpioPtr, 1);  // close Interrupt
        XGpio_InterruptClear(GpioPtr, 1);    // clear Interrupt  
        XGpio_InterruptEnable(GpioPtr, 1);   // enable Interrupt
}
