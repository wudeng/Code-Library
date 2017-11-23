func strangePrinter(s string) int {
    length := len(s)
    if length <= 1 {
        return int(length)
    }
    f := make([][]int, length)
    for i := 0; i < length; i++ {
        f[i] = make([]int, length)
        f[i][i] = 1
    }
    for l := 1; l < length; l++ {
        for i := 0; i + l < length; i++ {
            j := i + l
            if s[j] == s[j-1] {
                f[i][j] = f[i][j-1]
            } else {
                f[i][j] = f[i][j-1] + 1
            }
            for k := j - 1; k >= i; k-- {
                if s[j] == s[k] {
                    tmp := f[i][k] + f[k+1][j-1]
                    if f[i][j] > tmp {
                        f[i][j] = tmp
                    }
                }
            }
        }
    }
    return f[0][length-1]
}
