#include <cstdio>
#include <vector>

void printArray(std::vector<int> &array) {
    for (int i = 0; i< array.size(); i++) {
        printf("%d,", array[i]);
    }
    printf("\n");
}

