#include <stdio.h>
#include "unity.h"

int my_strlen(char s[]);

int my_strlen(char s[]){
    int c = 0;

    while (*s++)
        c++;

    return c;
}

// Test cases

void setUp(void){}
void tearDown(void){}

void test1(void){
    char foo[] = "abc";
    TEST_ASSERT_EQUAL(3, my_strlen(foo));
}

void test2(void){
    char foo[] =  "hello";
    TEST_ASSERT_EQUAL(5, my_strlen(foo));
}

void test3(void){
    char foo[] = "abcdefghijklmnopqrstuvwxyz";
    TEST_ASSERT_EQUAL(26, my_strlen(foo));
}

int main (void) {
    UNITY_BEGIN();
    RUN_TEST(test1);
    RUN_TEST(test2);
    RUN_TEST(test3);
    return UNITY_END();
    }

