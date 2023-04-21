#include <stdio.h>

#define MAX 1000

int get_next(char into_arr[]);
void copy(char from[], char to[]);

main () {
    int current_len, longest_len;
    char current[MAX], longest[MAX];

    current_len = longest_len = 0;

    while ((current_len = get_next(current)) > 0)
        if (current_len > longest_len) {
            copy(current, longest);
            longest_len = current_len;
        }

    printf("longest line: %s\n", longest);
    printf("was %d characters long\n", longest_len); 
}

int get_next (char into_arr[]) {
    int i, c;

    for (i = 0; i < MAX && (c = getchar()) != EOF && c != '\n'; ++i)
        into_arr[i] = c;

    if (c == '\n'){
        into_arr[i] = c;
        ++i;
    }

    into_arr[i] = '\0';
    return i;
}

void copy(char from[], char to[]) {
    int i, c;
    
    for (i = 0; (c = from[i]) != '\0'; ++i)
        to[i] = c;
    to[i] = '\0';
}
