#include <stdio.h>

#define MAXLINE 1000

/* Read a line from stdin and return its length */
int nextline(char buffer[]){
	char c;
	int i = 0;
	while (i < MAXLINE && (c = getchar()) != EOF && c != '\n')
		buffer[i++] = c;
	buffer[i] = '\0';
	return i;
}

/* Copies contents of from into to, assumes room */
void copy_into(char *from, char *to){
	int i = 0;
	do
		to[i] = from[i];
	while (from[i++]);
}

int main () {
	char current[MAXLINE], longest[MAXLINE];
	int len = 0, longest_len = 0;

	while ((len = nextline(current)))
		if (len > longest_len){
			copy_into(current, longest);
			longest_len = len;
		}
	printf("The longest line was %d long: %s\n", longest_len, longest);

	return 0;
}

