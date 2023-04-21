#include <stdio.h>

typedef unsigned char byte;

void show_bytes (byte *v, size_t s) {
    int i = 0;
    while (i < s)
        printf("%.2x ", v[i++]);
    printf("\n");
}

void show_int(int i) {
    show_bytes((byte *) &i, sizeof(int));
}

long exponentiate (int b, int p) {
    int i;
    long res = 1;
    for (i = 0; i < p; i++)
        res = res * b;
    return res;
}

/* Make the largest value that can be held by type int */
int make_largest() {
    long v = exponentiate (2, 31) - 1;
    return (int) v;
}

int main () {
    printf("Showing int 163\n");
    show_int(163);
    printf("Showing int 2**30\n");
    show_int(exponentiate(2,30));
    printf("Make largest yields %d\n", make_largest());
    show_int(make_largest());
    return 0;
}
