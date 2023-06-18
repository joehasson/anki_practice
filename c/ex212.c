#include <stdio.h>
#include "unity.h"

unsigned get_lsb(unsigned x){
	return x & 0xFFu;
}

unsigned compl_all_but_lsb(unsigned x){
	return x ^ ~0xFFu;
}

unsigned switch_lsb_on(unsigned x){
	return x | 0xFFu;
}

// Unit tests

unsigned example = 0x87654321;

void setUp(void) {}
void tearDown(void) {}

void test_get_lsb (void) {
	TEST_ASSERT_EQUAL(get_lsb(example), 0x21);
}

void test_compl_all_but_lsb(void){
	TEST_ASSERT_EQUAL(compl_all_but_lsb(example), 0x789ABC21);
}

void test_switch_lsb_on (void) {
	TEST_ASSERT_EQUAL(switch_lsb_on(example), 0x876543FF);
}

int main () {
	UNITY_BEGIN();
	RUN_TEST(test_get_lsb);
	RUN_TEST(test_compl_all_but_lsb);
	RUN_TEST(test_switch_lsb_on);
	UNITY_END();
}

