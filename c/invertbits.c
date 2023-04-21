#include <stdio.h>

unsigned invert_bits(unsigned x, int p, int n);

int main () {
    printf("Inverting bits  gives: %d\n", invert_bits(182U, 5 , 3)); 
    return 0;
}

 /* 182U -> 1011 0110
 *  Inverting 3 bits counting five in: mask 0011 1000
 *  1000 1110 -> 128 + 8 + 4 + 2 = 142
 */
