#include <vector>

#include "common.h"

using namespace std;

bool odd(int i) {
	return i & 1;
}

void reOrderArray(vector<int> &array) {
	int len = array.size();
	int i = 0;
	while ((i < len) && odd(array[i]))
		i++;
	int j = i + 1;
	while (j < len) {
		if (!odd(array[j])) {
			j++;
			continue;
		}
		int tmp = array[j];
		for (int k=j; k>i; k--) {
			array[k] = array[k-1];
		} 
		array[i++] = tmp;
	}        
}

int main() {
    //int a[] = {1, 2, 3, 4, 5, 6, 7};
    //vector<int> array(a, a+7);
    vector<int> array = {1, 2, 3, 4, 5, 6, 7};  // c++11
    printArray(array);
	reOrderArray(array);
    printArray(array);
	return 0;
}
