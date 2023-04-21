#include <stdio.h>

unsigned setbits(unsigned x, int p, int n, unsigned y);


int main () {
    unsigned res = setbits(182, 5, 3, 239);
    return 0;
}


/* 182 bit pattern = 1011 0110
 *                   7654 3210
 * 239 bit pattern = 1110 1111
 * Result pattern  = 1011 1110
 * = 255 - 64 - 1 = 190
 */
