#include "unity.h"

unsigned rightrot(unsigned x) {
    unsigned lsb = x & 1;
    return (x >> 1) | (lsb << (sizeof(x)-1));
}

/*test cases*/
void setUp(void) {
}
void tearDown(void) {
}

void test_rightrot(void) {
    TEST_ASSERT_EQUAL(0x00000001U, rightrot(0x80000000U));
}
void test_rightrot2(void) {
    TEST_ASSERT_EQUAL(0x00000000U, rightrot(0x00000000U));
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_rightrot);
    RUN_TEST(test_rightrot2);
    return UNITY_END();
}
