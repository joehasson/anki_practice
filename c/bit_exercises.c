#include "unity.h"

// Implementation

unsigned just_least_byte(unsigned x){
}

unsigned complement_all_but_least_byte(unsigned x){
}

unsigned turn_on_all_least_byte(unsigned x){
}

// Test cases

void setUp(void){}
void tearDown(void){}

void test_just_least_byte(void){
    TEST_ASSERT_EQUAL(0x00000021U, just_least_byte(0x87654321U));
}

void test_complement_all_but_least_byte(void){
    TEST_ASSERT_EQUAL(0x789ABC21U, complement_all_but_least_byte(0x87654321U));
}

void test_turn_on_all_least_byte(void){
    TEST_ASSERT_EQUAL(0x876543FFU, turn_on_all_least_byte(0x87654321U));
}

int main(){
    UNITY_BEGIN();
    RUN_TEST(test_just_least_byte);
    RUN_TEST(test_complement_all_but_least_byte);
    RUN_TEST(test_turn_on_all_least_byte);
    return UNITY_END();
}
