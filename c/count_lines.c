#include <stdio.h>

int main () {
	int i = 0, c;

	while ((c = getchar()) != EOF)
		if (c == '\n')
			i++;

	printf("The number of input newlines is: %d\n", i);
}
