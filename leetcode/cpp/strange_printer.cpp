class Solution {
public:
    int strangePrinter(string s) {
        int len = s.length();
        if (len == 0) return 0;
        vector<vector<int> > f(len, vector<int>(len, 0));
        for (int i=0; i<len; i++) {
            f[i][i] = 1;
        }
        for (int l=1; l<len; l++) {
            for (int i=0; i+l<len; i++) {
                int j = i+l;
                f[i][j] = f[i][j-1] + (s[j] == s[j-1] ? 0 : 1);
                for (int k=j-2; k>=i; k--) {
                    if (s[k] == s[j]) {
                        f[i][j] = min(f[i][j], f[i][k] + f[k+1][j-1]);
                    }
                }
            }            
        }
        return f[0][len-1];
    }
};
