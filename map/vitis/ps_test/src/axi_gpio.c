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

