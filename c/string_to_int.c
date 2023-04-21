#include <stdio.h>

int s_to_n(char s[]) {
    int sum = 0, i;

    for (i = 0; s[i] != '\0'; ++i)
        sum = sum * 10 + (s[i] - '0');

    return sum;
}

int main () {
    printf("result: %d\n", s_to_n("25637"));

    return 0;
}
