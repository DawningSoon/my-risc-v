#include <stdint-gcc.h>

#define addr_base ((volatile uint32_t *)0x1000)

int main()
{
    uint32_t i;
    volatile uint32_t *ptr = addr_base;
    i=0;
    i= 'h';
    *ptr = i;
    ptr =(uint32_t*)(ptr +4);
    i= 'e';
    *ptr = i;
    ptr =(uint32_t*)(ptr +4);
    i= 'l';
    *ptr = i;
    ptr =(uint32_t*)(ptr +4);
    i= 'l';
    *ptr = i;
    ptr =(uint32_t*)(ptr +4);
    i= 'o';
    *ptr = i;
    ptr =(uint32_t*)(ptr +4);
    i= ' ';
    *ptr = i;
    ptr =(uint32_t*)(ptr +4);
    i= 'w';
    *ptr = i;
    ptr =(uint32_t*)(ptr +4);
    i= 'o';
    *ptr = i;
    ptr =(uint32_t*)(ptr +4);
    i= 'r';
    *ptr = i;
    ptr =(uint32_t*)(ptr +4);
    i= 'l';
    *ptr = i;
    ptr =(uint32_t*)(ptr +4);
    i= 'd';
    *ptr = i;
    ptr =(uint32_t*)(ptr +4);
    i= '!';
    *ptr = i;
    ptr =(uint32_t*)(ptr +4);
    while(1)
    {
        // i++;
    }
}