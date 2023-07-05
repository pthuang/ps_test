//================================================================
// Project name: ps_test
// File    name: axi_bridge.c
// Header      : axi_bridge.h
// Author      : pthuang
// Function    : axi register driver.
// 
//
//
//================================================================

#include "axi_bridge.h" 
#include "xil_printf.h"

#define BASE_ADDR 0X44A10000
static const unsigned int REG_SIZE = 0x4000;

#define regTable ((volatile unsigned int*)BASE_ADDR)

unsigned int readRegTable (unsigned int readAddr) {
	if (readAddr < REG_SIZE) {
		return regTable[readAddr]; 
	} else {
		xil_printf("readRegTable Error: Address out of range!!!\r\n");
		return 0;
	}
}

void writeRegTable (unsigned int writeAddr, unsigned int writeData) {
	if (writeAddr < REG_SIZE) {
		regTable[writeAddr] = writeData; 
	} else {
		xil_printf("readRegTable Error: Address out of range!!!\r\n"); 
	}
	
}
