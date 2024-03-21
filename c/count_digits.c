#include <stdio.h>

int main () {
	int ch, counts[10], i;

	printf("Enter some digits\n");

	for (i = 0; i < 10; i++)
		*(counts+i) = 0;

	while ((ch = getchar()) != EOF)
		if ('0' <= ch && ch <= '9')
			*(counts + ch - '0') += 1;

	for (i = 0; i < 10; i++)
		printf("Digit %c counted %d times\n", '0' + i, *(counts+i));

	return 0;
}

