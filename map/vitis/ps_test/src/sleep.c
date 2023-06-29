#include "sleep.h"

void sleep(unsigned int ms)
{
    unsigned int i, j;
    for (i = 0; i < ms; i++)
        for (j = 0; j < 8333; j++);
}
