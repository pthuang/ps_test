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

#define BASE_ADDR 0X44A10000

typedef struct {
    unsigned int reg0;
    unsigned int reg1;
    unsigned int reg2;
    unsigned int reg3;
    unsigned int reg4;
    unsigned int reg5;
    unsigned int reg6;
    unsigned int reg7;
} RegTable;

#define regTable ((volatile RegTable*)BASE_ADDR)

unsigned int readRegTable (unsigned int readAddr) {
	unsigned int readData;
	switch(readAddr) {
		case 0x00 : readData = regTable->reg0; break;
		case 0x01 : readData = regTable->reg1; break;
		case 0x02 : readData = regTable->reg2; break;
		case 0x03 : readData = regTable->reg3; break;
		case 0x04 : readData = regTable->reg4; break;
		case 0x05 : readData = regTable->reg5; break;
		case 0x06 : readData = regTable->reg6; break;
		case 0x07 : readData = regTable->reg7; break;
		default   : readData = 0;              break;
	}
	return readData;
}

void writeRegTable (unsigned int writeAddr, unsigned int writeData) {
	switch(writeAddr) {
		case 0x00 : regTable->reg0 = writeData; break;
		case 0x01 : regTable->reg1 = writeData; break;
		case 0x02 : regTable->reg2 = writeData; break;
		case 0x03 : regTable->reg3 = writeData; break;
		case 0x04 : regTable->reg4 = writeData; break;
		case 0x05 : regTable->reg5 = writeData; break;
		case 0x06 : regTable->reg6 = writeData; break;
		case 0x07 : regTable->reg7 = writeData; break;
		default   :                             break;
	}
}