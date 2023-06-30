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
#define UART_BASE 0x40600000 
// const unsigned int UART_BASE = 0x40600000;

#define regTable ((volatile unsigned int*)UART_BASE)

#define rxFifo   regTable[0] // (UART_BASE + 0x00)
#define txFifo   regTable[1] // (UART_BASE + 0x04)
#define stateReg regTable[2] // (UART_BASE + 0x08)
#define ctrlReg  regTable[3] // (UART_BASE + 0x0C)


// #define RXFIFO   (UART_BASE + 0x00)
// #define TXFIFO   (UART_BASE + 0x04)
// #define STATEREG (UART_BASE + 0x08)
// #define CTRLREG  (UART_BASE + 0x0C)

// #define rxFifo   ((unsigned char)(*((volatile unsigned int*)RXFIFO))) 
// #define txFifo   ((unsigned char)(*((volatile unsigned int*)TXFIFO))) 
// #define stateReg ((unsigned char)(*((volatile unsigned int*)STATEREG)))
// #define ctrlReg  ((unsigned int )(*((volatile unsigned int*)CTRLREG)))

// check
unsigned char uartAxiLiteCheck () {
	return stateReg;
}

void uartTx (unsigned int txDataPayload) {
	txFifo = txDataPayload;
}

unsigned char uartRx () {
	return rxFifo;
}
