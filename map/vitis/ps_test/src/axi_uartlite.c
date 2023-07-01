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
// const unsigned int UART_BASE_ADDR = 0x40600000;

#define regTable ((volatile unsigned int*)UART_BASE_ADDR)

#define rxFifo   regTable[0] // (UART_BASE_ADDR + 0x00)
#define txFifo   regTable[1] // (UART_BASE_ADDR + 0x04)
#define stateReg regTable[2] // (UART_BASE_ADDR + 0x08)
#define ctrlReg  regTable[3] // (UART_BASE_ADDR + 0x0C)

// check
unsigned char uartAxiLiteCheck () {
	return stateReg;
}

void uartTx (unsigned char txDataPayload) {
	txFifo = txDataPayload;
}

unsigned char uartRx () {
	return rxFifo;
}
