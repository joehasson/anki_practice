#include <stdio.h>

#define MAX 1000

void copy(char from[], char to[]);
int my_getline(char copy_into[]);

int main() {
    char current_line[MAX];
    char longest_line[MAX];
    int longest_len = 0;
    int i = 0;

    while (i = my_getline(current_line))
        if (i > longest_len){
            copy(current_line, longest_line);
            longest_len = i;
    }

    printf("The longest line was %s\n", longest_line);
    printf("It had %d letters\n", longest_len);
}

int my_getline(char copy_into[]) {
    int c, i = 0;

    while (i < MAX && (c = getchar()) != EOF && c != '\n')
        copy_into[i++] = c;

    if (c == '\n')
        copy_into[i++] = c;
    
    copy_into[i] = '\0';
    return i;
}


void copy(char from[], char to[]){
    int i;
    for (i = 0; from[i] != '\0'; i++)
        to[i] = from[i];

    to[i] = '\0';

    return ;
}


