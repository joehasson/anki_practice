#include <stdio.h>

int s_to_n(char s[]) {
	int i = 0;
	while (*s)
		i = (i * 10) + (*s++ - '0');
	return i;
}

int main () {
    printf("result: %d\n", s_to_n("25637"));

    return 0;
}
