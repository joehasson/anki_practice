#include <stdio.h>

void incr(int *p) {
    *p = *p + 1;
}

int main () {
    int i = 3;
    incr(&i);
    printf("i is now equal to %d\n", i);
    
    return 0;
}
