#include <stdio.h>

#define IN 1
#define OUT 0

main () {
    int c, nc, nw, nl, state;

    printf("Enter some input then press ctrl+D\n");

    nc = nw = nl = 0;
    state = OUT;
    while ((c = getchar()) != EOF) {
        ++nc;
        if (c == '\n')
            ++nl;
        if (c == '\t' || c == ' ' || c == '\n')
            state = OUT;
        else if (state == OUT){
            state = IN;
            ++nw;
        }
    }
    printf("%d %d %d\n", nc, nw, nl);
}
                
