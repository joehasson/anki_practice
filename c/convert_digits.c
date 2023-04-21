#include <stdio.h>

main () {
    int c;
    int n = 0;
    
    while ((c = getchar()) != '\n')
        n = (n * 10) + (c - '0');
    printf("You entered %d\n", n);
}
