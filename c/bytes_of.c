#include <stdio.h>

typedef unsigned char byte;

void show_bytes (byte *val, size_t size) {
    int i;
    for (i = 0; i < size; i++)
        printf("%.2x ", *(val+i));
    printf("\n");

    return ;
}

void show_char(char c) {
    show_bytes ((byte *)&c, sizeof(char));
}
void show_int(int i) {
    show_bytes ((byte *)&i, sizeof(int));
}
void show_float(float f) {
    show_bytes ((byte *)&f, sizeof(float));
}
void show_double(double d) {
    show_bytes ((byte *)&d, sizeof(double));
}

int main () {
    char c = 'a';
    int i = 39827594;
    float f = 162.395;
    double d = f;

    show_char(c);
    show_int(i);
    show_float(f);
    show_double(d);

    return 0;
}
