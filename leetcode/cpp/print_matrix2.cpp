#include <vector>

#include "common.h"

using namespace std;

vector<int> printMatrix(vector<vector<int> > matrix) {
	int up = 0, down = matrix.size()-1;
	int left = 0, right = matrix[0].size()-1;

	vector<int> res;
	while (left <= right && up <= down) {
		for (int i=left; i<=right; i++) {
			res.push_back(matrix[up][i]);
		}
		up++; 
		for (int i=up; i<=down; i++) {
			res.push_back(matrix[i][right]);
		}
		right--;
        if (up <= right) { // notice this if
            for (int i=right; i>=left; i--) {
                res.push_back(matrix[down][i]);
            }
            down--;
        }
        if (left <= right) {
            for (int i=down; i>=up; i--) {
                res.push_back(matrix[i][left]);
            }
            left++;
        }
	}
	return res;
}

int main() {
	vector<vector<int> > matrix = { {1}, {2}, {3}, {4}, {5}};
    vector<int> res = printMatrix(matrix);
	printArray(res);
	return 0;
}
