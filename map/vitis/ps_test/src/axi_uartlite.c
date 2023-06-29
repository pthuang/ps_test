
#include "axi_uartlite.h"
//#include "xil_printf.h"
//#include "xil_types.h"


#define UART_BASE 0x40600000

//#define RX_FIFO   (UART_BASE + 0x00)
//#define TX_FIFO   (UART_BASE + 0x04)
//#define STATE_REG (UART_BASE + 0x08)
//#define CTRL_REG  (UART_BASE + 0x0C)

#define regTable ((volatile unsigned int*)UART_BASE)

#define rxFifo   regTable[0]
#define txFifo   regTable[1]
#define stateReg regTable[2]
#define ctrlReg  regTable[3]

unsigned int uartAxiLiteCheck () {
	return stateReg;
}

void uartTx (unsigned char txDataPayload) {
	txFifo = txDataPayload;
}

unsigned int uartRx () {
	return rxFifo;
}
