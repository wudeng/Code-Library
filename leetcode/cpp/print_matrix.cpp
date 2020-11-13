#include <vector>

#include "common.h"

using namespace std;

vector<int> printMatrix(vector<vector<int> > matrix) {
	int up = 0, left=0, down = matrix.size()-1, right = matrix[0].size()-1;
	vector<int> res;
	int row = 0, col = 0;
	while (row >= up && row <= down && col >=left && col <= right) {
		while (col <= right) {
			res.push_back(matrix[row][col++]);
		}
		up++; col--; row++;
		while (row <= down) {
			res.push_back(matrix[row++][col]);
		}
		right--; row--; col--;
        if (up <= down) {
            while(col >= left) {
                res.push_back(matrix[row][col--]);
            }
            down--; row--; col++;
        }
        if (left <= right) {
            while(row >= up) {
                res.push_back(matrix[row--][col]);
            }
            left++; row++; col++;
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
