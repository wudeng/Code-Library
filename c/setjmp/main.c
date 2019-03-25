#include <stdio.h>
#include <setjmp.h>

jmp_buf env;

void f() {
    printf("f\n");
    g();
}

void g() {
    printf("g\n");
    longjmp(env, 10);
}

int main() {
    int ret = setjmp(env);
    if (ret == 0) {
		f();
        printf("1 %d\n", ret);
    } else {
        printf("2 %d\n", ret);
    }
    return 0;
}
