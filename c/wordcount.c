#include <stdio.h>

#define IN 1
#define OUT 0

main () {
    int nc, nw, nl, c, state;

    state = OUT;
    while ((c = getchar()) != EOF) {
        ++nc;
        if (c == '\n' || c == ' ' || c == '\t')
            state = OUT;
        else if (state = OUT){
            ++nw;
            state = IN;
        }
        if (c == '\n')
            ++nl;
    }
    printf("%d %d %d\n", nc, nw, nl);
}
        
