#include <stdio.h>

int main () {
    int c, i, digits[10];

    for (i = 0; i < 10; i++)
        digits[i] = 0;

    while ((c = getchar()) != EOF)
        if ('0' <= c && c <= '9')
            digits[c - '0']++;

    for (i = 0; i < 10; i++)
        printf("%d ", digits[i]);
    printf("\n");

    return 0;
}
