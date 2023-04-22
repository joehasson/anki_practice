#include "unity.h"

unsigned rightrot(unsigned x);

/*test cases*/

/*We need these functions to make unity work, even
/ if they do nothing */
void setUp(void) {
}
void tearDown(void) {
}

/*
 * These tests (unlike the function) assume that unsigned ints 
 * are 32 bits
 */
void test_rightrot(void) {
    printf("rightrot(0x00000001U) = 0x%08x\n", rightrot(0x00000001U));
    TEST_ASSERT_EQUAL(0x80000000U, rightrot(0x00000001U));
}
void test_rightrot2(void) {
    TEST_ASSERT_EQUAL(0x00000000U, rightrot(0x00000000U));
}

void test_rightrot3(void) {
    TEST_ASSERT_EQUAL(0xE1C54F70U, rightrot(0xC38A9EE1U));
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_rightrot);
    RUN_TEST(test_rightrot2);
    RUN_TEST(test_rightrot3);
    return UNITY_END();
}
