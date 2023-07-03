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
//#include <stdio.h>
#include "axi_uartlite.h"
//#include <xil_printf.h>

// axi_uartlite offset in Microbalze BD 
#define UART_BASE_ADDR 0x40600000

#define regTable ((volatile unsigned int*)UART_BASE_ADDR)

#define rxFifo   regTable[0] // (UART_BASE_ADDR + 0x00)
#define txFifo   regTable[1] // (UART_BASE_ADDR + 0x04)
#define stateReg regTable[2] // (UART_BASE_ADDR + 0x08)
#define ctrlReg  regTable[3] // (UART_BASE_ADDR + 0x0C)

// check
unsigned char uartReadState () {
	return stateReg;
}

void uartTx (unsigned char txDataPayload) {
	unsigned char txRdy = 0;
	while(~txRdy) { //
		txRdy = (uartReadState() & 0x04) << 5;
	}
	txFifo = txDataPayload;
}

unsigned char uartRx () {
	unsigned char rxRdy = 0;
	while(~rxRdy) {
		rxRdy = (uartReadState() & 0x01) << 7;
	}
	return rxFifo;
}
