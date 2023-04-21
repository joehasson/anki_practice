#include <stdio.h>

int main () {
    int counts[10];
    int c, i;

    for (i = 0; i < 10; i++)
        counts[i] = 0;

    while ((c = getchar()) != EOF)
        if (0 <= (i = c - '0') && i <= 9)
            counts[i]++;

    for (i = 0; i < 10; i++)
        printf("The count for %d was %d\n", i, counts[i]);

    return 0;
}
