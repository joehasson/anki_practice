#include <stdio.h>
#include <assert.h>
#include "unity.h"

unsigned invert_bits(unsigned x, int p, int n);

// Implementation
unsigned invert_bits(unsigned x, int p, int n){
	unsigned n_ones;
	if (n == (sizeof(int) * 8)){
		n_ones = ~0;	
	}
	else {
		n_ones = ~(~0 << n);
		n_ones <<= p - n + 1;
	}
	return x ^ n_ones;
}

// Test cases

void setUp(void){}
void tearDown(void){}

 /* 182U -> 1011 0110
 *  Inverting 3 bits counting five in: mask 0011 1000
 *  1000 1110 -> 128 + 8 + 4 + 2 = 142
 */
void testcase(void){
    TEST_ASSERT_EQUAL(142, invert_bits(182U, 5 , 3));
}

void testcase2(void){
    const int num_bits = sizeof(unsigned) * 8;
    TEST_ASSERT_EQUAL(0xAE317FD2U, invert_bits(0x51CE802DU, num_bits-1, num_bits));
}

void testcase3(void){
    TEST_ASSERT_EQUAL(0x323, invert_bits(0xCA3, 11, 5));
}

int main () {
    UNITY_BEGIN();
    RUN_TEST(testcase);
    RUN_TEST(testcase2);
    RUN_TEST(testcase3);
    return UNITY_END();
}
