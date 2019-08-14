local inspect = require "inspect"

local a = "abc"

local t = {}

for i = 1, string.len(a) do
    t[#t + 1] = string.byte(a, i)
end

print(inspect(t))


print(string.char(table.unpack(t)))
