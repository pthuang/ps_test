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

#include "axi_gpio.c"

#define GPIO_BASE_ADDR 0X40000000

#define GPIODATA  (GPIO_BASE_ADDR + 0x0000) // Ch1 GPIO Data Register
#define GPIOTRI   (GPIO_BASE_ADDR + 0x0004) // Ch1 GPIO 3-state Control.
#define GPIO2DATA (GPIO_BASE_ADDR + 0x0008) // Ch2 GPIO Data Register
#define GPIO2TRI  (GPIO_BASE_ADDR + 0x000C) // Ch2 GPIO 3-state Control.

// only valid when using Enable Interrupt parameter
#define GPIOGIER  (GPIO_BASE_ADDR + 0x011c) // Global Interrupt Enable Register
#define GPIOIPIER (GPIO_BASE_ADDR + 0x0128) // IP Interrupt Enable Register
#define GPIOIPISR (GPIO_BASE_ADDR + 0x0120) // IP Interrupt Status Register

#define gpioData  ((unsigned int)(*((volatile unsigned int*)GPIODATA))) 
#define gpioTri   ((unsigned int)(*((volatile unsigned int*)GPIOTRI))) 
#define gpio2Data ((unsigned int)(*((volatile unsigned int*)GPIO2DATA)))
#define gpio2Tri  ((unsigned int)(*((volatile unsigned int*)GPIO2TRI)))
#define gpioGIer  ((unsigned int)(*((volatile unsigned int*)GPIO2TRI)))
#define gpioIpIer ((unsigned int)(*((volatile unsigned int*)GPIO2TRI)))
#define gpioIpIsr ((unsigned int)(*((volatile unsigned int*)GPIO2TRI)))








