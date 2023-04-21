#include <stdio.h>

void incr_pointer(int *i) {
    *i = *i + 1;
}

int main () {
    int x = 3;
    incr_pointer(&x);
    printf("%d\n", x);

    return 0;
}
