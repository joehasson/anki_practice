#include <stdio.h>

int my_strlen(char s[]);

int main () {
    char foo[] = "abc";
    char bar[] = "hello";
    char baz[] = "abcdefghijklmnopqrstuvwxyz";

    printf("abc is size %d\n", my_strlen(foo));
    printf("hello is size %d\n", my_strlen(bar));
    printf("abcdefghijklmnopqrstuvwxyzis size %d\n", my_strlen(baz));
    return 0;
    }

int my_strlen(char s[]){
    int i = 0;

    while (s[i] != '\0')
        i++;
        
    return i;
}
