#include <stdlib.h>
#include <iostream>
using namespace std;

void do_something(size_t i) {
    // Leak some memory.
    int *p = new int[i]; // or malloc(i * 4);
}

int main(int argc, char **argv) {
    for (size_t i = 1; i <= 1000; i++) {
        do_something(i);
    }

    cout << "jemalloc test." << endl;
    return 0;
}
