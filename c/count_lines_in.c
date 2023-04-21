#include <stdio.h>

main () {
    int c, i;

    i = 0;
    while ((c = getchar()) != EOF)
        if (c == '\n')
            ++i;
    printf("%d\n", i);
}
