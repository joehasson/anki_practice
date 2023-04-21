#include <stdio.h>

int main () {
    printf("There are %d bits in an int\n", 8*sizeof((int) 1));
    printf("There are %d bits in a short\n", 8*sizeof((short) 1));
    printf("And in a long there are %d\n", 8*sizeof((long) 1));
    printf("In a char there are %d\n bits", 8*sizeof((char) 1));
}
