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

local b = setmetatable({}, {
    __newindex = function(t, k, v)
        print("assign value")
        -- t[k] = v is not allowed
        rawset(t, k, v)
    end
})

b[1] = 100
print(inspect(b))
