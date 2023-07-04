//================================================================
// Project name: ps_test
// File    name: axi_uartlite.c
// Header      : axi_uartlite.h
// Author      : pthuang
// Function    : axi-lite uart driver.
// 
//
//
//================================================================

#include "axi_gpio.h"
#include "xparameters.h"
#include "xgpio.h"
#include "xstatus.h"
#include "xintc.h"
#include "xil_exception.h"

#define GPIO_BASE_ADDR 0X40000000

#define GPIODATA  (GPIO_BASE_ADDR + 0x0000) // Ch1 GPIO Data Register
#define GPIOTRI   (GPIO_BASE_ADDR + 0x0004) // Ch1 GPIO 3-state Control. 0: Output, 1: Input.
#define GPIO2DATA (GPIO_BASE_ADDR + 0x0008) // Ch2 GPIO Data Register
#define GPIO2TRI  (GPIO_BASE_ADDR + 0x000C) // Ch2 GPIO 3-state Control.

// only valid when using Enable Interrupt parameter
#define GPIOGIER  (GPIO_BASE_ADDR + 0x011c) // Global Interrupt Enable Register. hign 1 bit valid,other 31 bits reserved.
#define GPIOIPIER (GPIO_BASE_ADDR + 0x0128) // IP Interrupt Enable Register. [31:02]reserved, [1]: ch2 enable, [0]: ch1 enable; 
#define GPIOIPISR (GPIO_BASE_ADDR + 0x0120) // IP Interrupt Status Register. [31:02]reserved, [1]: 1(ch2 input interrupt), [0]: 1(ch1 input interrupt);

#define gpioData  ((volatile unsigned int*)GPIODATA)
#define gpioTri   ((volatile unsigned int*)GPIOTRI) 
#define gpio2Data ((volatile unsigned int*)GPIO2DATA)
#define gpio2Tri  ((volatile unsigned int*)GPIO2TRI)
#define gpioGIer  ((volatile unsigned char*)GPIOGIER)
#define gpioIpIer ((volatile unsigned char*)GPIOIPIER)
#define gpioIpIsr ((volatile unsigned char*)GPIOIPISR)

#define GPIO_DEVICE_ID   XPAR_GPIO_0_DEVICE_ID
#define INTC_DEVICE_ID   XPAR_INTC_0_DEVICE_ID
#define AXI_GPIO_INTR_ID XPAR_INTC_0_GPIO_0_VEC_ID
#define EXCEPTION_ID     XIL_EXCEPTION_ID_INT

int GpioHandler(void *CallbackRef);

void gpioSetInput () {
	*gpioTri  = 0x00000001;
	*gpio2Tri = 0x00000001; 
}

void gpioSetOutput () {
	*gpioTri  = 0x00000000; 
	*gpio2Tri = 0x00000000; 
}

void openInterruptEnable () {
	// ip enable
	*gpioIpIer = 0x03; // 2'b11
	// global ebable
	*gpioGIer  = 0x80; // 8'b1000_0000
}

void clearIsr (unsigned char channel) {
	switch (channel) {
		case 0x00 : *gpioIpIsr = 0x03; break; // both clear cahnnel 1&2 ISR 
		case 0x01 : *gpioIpIsr = 0x01; break; // clear cahnnel 1   ISR 
		case 0x02 : *gpioIpIsr = 0x02; break; // clear cahnnel 2   ISR 
		default   : *gpioIpIsr = 0x00; break; 
	} 
}

void gpioInterruptInitial (XGpio key, XIntc Intc) {
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
}

int GpioHandler(void *CallbackRef){
    XGpio *GpioPtr = (XGpio *)CallbackRef;
        // key_intr_flag = 1;
        print("gpio interrupt\n\r");
        XGpio_InterruptDisable(GpioPtr, 1);  // close Interrupt
        XGpio_InterruptClear(GpioPtr, 1);    // clear Interrupt
        // sleep(3);
        XGpio_InterruptEnable(GpioPtr, 1);   // enable Interrupt
        return 1;
}




