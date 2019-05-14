
函数内部声明内部函数相当于创建新的函数变量，效率上要略低于在外部申明函数。


ubuntu@deng (→ master) perf$ time lua test.lua 

real    0m1.509s
user    0m1.244s
sys     0m0.076s
ubuntu@deng (→ master) perf$ time lua test1.lua 

real    0m1.197s
user    0m0.936s
sys     0m0.088s
