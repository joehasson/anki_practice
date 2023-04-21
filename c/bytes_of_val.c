#include <stdio.h>

typedef unsigned char byte;

void show_bytes(byte *p, size_t len) {
    int i;

    for (i = 0; i < len; ++i)
        printf("%.2x ", p[i]);
    printf("\n");
}

void show_int(int i) {
    show_bytes((byte *) &i, sizeof(int));
}

void show_double(double d) {
    show_bytes((byte *) &d, sizeof(double));
}

int main () {
    printf("The bytewise int representation of 1876 on this machine is " );
    show_int((int) 1876);

    return 0;
}

