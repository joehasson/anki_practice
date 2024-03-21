#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

int main () {
    char byte = 'x';
    int parent_to_child_p[2];
    int child_to_parent_p[2];
    int pid;

    if (pipe(parent_to_child_p) != 0 || pipe(child_to_parent_p) != 0) {
        fprintf(stderr, strerror(errno));
        exit(1);
    }

    pid = fork();

    if (pid < 0) {
        fprintf(stderr, strerror(errno));
        exit(1);
    } 

    else if (pid == 0) { // we are in the child process
        char buf[1];
        pid_t pid = getpid();
        read(parent_to_child_p[0], buf, 1);
        printf("Child process %d received byte %c from parent\n", pid, buf[0]);
        write(child_to_parent_p[1], "z", 1);
    }

    else { // we are in parent process
        char buf[1];
        write(parent_to_child_p[1], &byte, 1);
        read(child_to_parent_p[0], buf, 1);
        printf("Parent process received byte %c from child\n", buf[0]);
    }
}
