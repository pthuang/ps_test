#ifndef _AXI_GPIO_
#define _AXI_GPIO_

	void gpioSetInput ();
	void gpioSetOutput ();
	void openInterruptEnable ();
	void clearIsr (unsigned char channel);
	void gpioInterruptInitial ();
	int GpioHandler(void *CallbackRef);

#endif
