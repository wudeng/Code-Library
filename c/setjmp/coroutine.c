#include <stdio.h>
#include <setjmp.h>

jmp_buf child_env, parent_env;

void child() {
    for (int i=0; i<6; i++) {
        printf("begin child...\n");
        if (!setjmp(child_env)) {
            printf("child..1\n");
            longjmp(parent_env, 1);
        } else {
            printf("child..2\n");
        }
    }
}

void call_with_coushion() {
    char array[1000];
    array[999] = 1;
    child();
}


int main() {
    if (!setjmp(parent_env)) {
        call_with_coushion();
    }
    for (int i=0; i<5; i++) {
        printf("begin parent...\n");
        if (!setjmp(parent_env)) {
            printf("parent..1\n");
            longjmp(child_env, 1);
        } else {
            printf("parent..2\n");
        }
    }
    return 0;
}
