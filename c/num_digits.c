#include <stdio.h>

main () {
    int c, i;
    int counters[10];

    for (i = 0; i < 10; ++i)
        counters[i] = 0;

    while ((c = getchar()) != EOF)
            if ('0' <= c && c <= '9')
                ++counters[c - '0'];

    for (i = 0; i < 10; ++i)
        printf(" %d", counters[i]);

    return 0;
}
