#include <unistd.h>
#include <stdio.h>

int main() {
    for (int i=0; i<1000; i++) {
        usleep(400);
    }
    return 0;
}
