
local t = {10, 20, nil, 40}
print(#t)
print(select("#", table.unpack(t)))

local f = 1
local b = (f == 1)
print(type(b), b)

print(arg[1])
