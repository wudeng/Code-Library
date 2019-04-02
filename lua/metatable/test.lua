local inspect = require "inspect"

local mt = {i = 1}
mt.__index = mt

local t = setmetatable({}, mt)

t.i = t.i

print(inspect(t))

t.i = 2

print(inspect(t))

t.i = t.i

print(inspect(t))

