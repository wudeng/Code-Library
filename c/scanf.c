#include <stdio.h>

int main() {
    char *str = "x:1";
    int x = 0;
    sscanf(str, "x:%d", &x);
    printf("x = %d\n", x);
    return 0;
}
