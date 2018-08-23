local str = "abcd"
str = string.pack(">s2",str)

print(string.byte(str, 1, #str))
