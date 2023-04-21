#include <stdio.h>
#include <string.h>
#include "unity.h"

/* strend: return 1 if the string t occurs at the end of the string s, 
 * and zero otherwise */
int strend(char *s, char *t){
    int i;

    if (strlen(s) < strlen(t))
        return 0;

    s += strlen(s) - strlen(t);

    while (*s)
        if (*s++ != *t++)
            return 0;
    return 1;
}

void setUp(void){}
void tearDown(void){}

void test_strend(void){
    TEST_ASSERT_EQUAL_INT(1, strend("hello", "lo"));
}

void test_strend2(void){
    TEST_ASSERT_EQUAL_INT(0, strend("hello", "ll"));
}

void test_strend3(void){
    TEST_ASSERT_EQUAL_INT(0, strend("hello", "hell"));
}

void test_strend4(void){
    TEST_ASSERT_EQUAL_INT(0, strend("hello", "bar"));
}

void test_strend5(void){
    TEST_ASSERT_EQUAL_INT(1, strend("hello", "hello"));
}

void test_strend6(void){
    TEST_ASSERT_EQUAL_INT(0, strend("hello", "helloo"));
}

int main(void){
    UNITY_BEGIN();
    RUN_TEST(test_strend);
    RUN_TEST(test_strend2);
    RUN_TEST(test_strend3);
    RUN_TEST(test_strend4);
    RUN_TEST(test_strend5);
    RUN_TEST(test_strend6);
    return UNITY_END();
}
