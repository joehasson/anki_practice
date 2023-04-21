#include <stdio.h>

int binsearch(int x, int v[], int n) {
    int low, mid, high;

    low = 0;
    high = n - 1;
    while (low <= high){
        mid = (low + high) / 2;
        if (v[mid] = x)
            return mid;
        else if (v[mid] < x)
            low = mid + 1;
        else
            high = mid - 1;
    }
    return -1;
}
