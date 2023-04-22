#include <stdio.h>
#include "unity.h"

/* Implementation */
/* find x in sorted array v[0], v[1], ... , v[n-1]
 * else return -1
 *
 * Make only one check inside the loop
 */
int binsearch (int x, int *v, int n){
    int low, mid, high;
    low = 0;
    high = n -1;

    while (low <= high){
        mid = (low + high) / 2;
        if (v[mid] < x)
            low = mid + 1;
        else
            high = mid - 1;
    }

    if (v[low] == x)
        return low;
    else if(v[high] == x)
        return high;
    else
        return -1;
}

/* Test Cases */

void setUp(void) {}

void tearDown(void) {}

/* Test with 1 element*/
void test_binsearch_1(void) {
    int v[1];
    v[0] = 0;
    TEST_ASSERT_EQUAL(0, binsearch(0, v, 1));
    TEST_ASSERT_EQUAL(-1, binsearch(1, v, 1));
}

/* Test with 100 elements */
void test_binsearch_100(void) {
    int v[100];
    int i;
    for (i = 0; i < 100; i++)
        v[i] = i;
    TEST_ASSERT_EQUAL(0, binsearch(0, v, 100));
    TEST_ASSERT_EQUAL(50, binsearch(50, v, 100));
    TEST_ASSERT_EQUAL(99, binsearch(99, v, 100));
    TEST_ASSERT_EQUAL(-1, binsearch(100, v, 100));
}

/* Test with 101 elements */
void test_binsearch_101(void) {
    int v[101];
    int i;
    for (i = 0; i < 101; i++)
        v[i] = i;
    TEST_ASSERT_EQUAL(0, binsearch(0, v, 101));
    TEST_ASSERT_EQUAL(50, binsearch(50, v, 101));
    TEST_ASSERT_EQUAL(100, binsearch(100, v, 101));
    TEST_ASSERT_EQUAL(-1, binsearch(101, v, 101));
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_binsearch_1);
    RUN_TEST(test_binsearch_100);
    RUN_TEST(test_binsearch_101);
    return UNITY_END();
}
