#include <stdio.h>

int main() {
    char c = 0xff;
    unsigned int i = c;
    printf("i = %u\n", i); // 4294967295
    i = c & 0xff;
    printf("i = %u\n", i); // 255
    printf("i = %u\n", 0x100 | c); // 4294967295
    printf("i = %u\n", 0x100 | (c & 0xff)); // 511
    return 0;
}
