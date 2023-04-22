#include <stdio.h>
#include "unity.h"

unsigned setbits(unsigned x, int p, int n, unsigned y);

/* Implementation */

unsigned setbits(unsigned x, int p, int n, unsigned y) {
    // Get the lower order n bits of y and move them to
    // positions p...p-n+1. All other bits are zero. 
    unsigned from_y = y & ~(~0 << n);
    from_y <<= p - n + 1;
     
    // Creating a mask to turn off the bits from p...p-n+1 in x
    // Create mask with all bits before p on and after off
    unsigned bits_off_from_p = (~0 << (p+1));

    // Create mask with bits p-n to 0 on
    unsigned lower_bits_on = ~(~0 << (p-n+1));

    // Create final mask and apply to x
    unsigned mask = bits_off_from_p | lower_bits_on;
    x &= mask;

    // Turn bits p ... p-n+1 in x back on if they are on in y
    return x | from_y;
}
    


/* Test cases */

void setUp(void) {
}
void tearDown(void) {
}

/* 182 bit pattern = 1011 0110
 *                   7654 3210
 * 239 bit pattern = 1110 1111
 * Result pattern  = 1011 1110
 * = 255 - 64 - 1 = 190
 */
void test_setbits1(void) {
    unsigned res = setbits(182, 5, 3, 239);
    TEST_ASSERT_EQUAL(190, res);
}

/* 0xA01E = 1010 0000 0001 1110
 *          FEDC BA98 7654 3210
 * 0xCDD9 = 1100 1101 1101 1001
 *  with p=A, n=7 we have
 *  lower of y = 101 1001
 *  res = 1010 0101 1001 1110 
 *  = 0xA59E
 *  */
void test_setbits2(void){
    unsigned res = setbits(0xA01E, 0xA, 0x7, 0xCDD9);
    TEST_ASSERT_EQUAL(0xA59E, res);
}

int main () {
    UNITY_BEGIN();
    RUN_TEST(test_setbits1);
    RUN_TEST(test_setbits2);
    return UNITY_END();
}

