#ifndef _AXI_UARTLITE_
#define _AXI_UARTLITE_

	unsigned char uartReadState ();
	void uartTx (unsigned char txDataPayload);
	unsigned char uartRx ();

#endif
