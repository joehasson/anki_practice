#include <stdio.h>
#include "unity.h"

int bitcount (unsigned x);

/* Test cases */

void setUp (void) {}

void tearDown (void) {}

/*152 bit pattern = 1001 1000, so bitcount is 3*/
void test_bitcount_152 (void) {
    TEST_ASSERT_EQUAL(3, bitcount(152U));
}

/* 3831 bit pattern = 1110 1111 0111, so bitcount is 10 */
void test_bitcount_3831 (void) {
    TEST_ASSERT_EQUAL(10, bitcount(3831U));
}

/* 0xEA34 = 1110 1010 0011 0100 so bitcount is 8 */
void test_bitcount_0xEA34 (void) {
    TEST_ASSERT_EQUAL(8, bitcount(0xEA34U));
}

int main (void) {
    UNITY_BEGIN();
    RUN_TEST(test_bitcount_152);
    RUN_TEST(test_bitcount_3831);
    RUN_TEST(test_bitcount_0xEA34);
    return UNITY_END();
}
