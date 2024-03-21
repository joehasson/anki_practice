#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXLINES 500
#define MAXLINE 1000

int mygetline(char *linebuf)
{
	int i = 0, c;
	while (i < MAXLINE 
			&& (c = getchar()) != EOF
			&& c != '\n'
		  ){
		linebuf[i++] = c;
	}

	if (c == '\n'){
		linebuf[i++] = c;
	}

	linebuf[i] = '\0';
	return i;
}

int getlines(char **linesbuf)
{
	int len, i = 0;
	char linebuf[MAXLINE];

	while ((len = mygetline(linebuf)) > 0){
		char *p = malloc(len);
		strcpy(p, linebuf);
		linesbuf[i++] = p;
	}

	return i;
}

int main () {
	char *linesbuf[MAXLINES];
	int i, nlines;

	nlines = getlines(linesbuf);

	for (i = 0; i < nlines; i++){
		printf("%s", linesbuf[i]);
	}

	return 0;
}
	
	

