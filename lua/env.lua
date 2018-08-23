local inspect = require "lib.inspect"
local t = {
    name = "hello"
}

local chunk = [[
    print(t.name)
    t.name = "world"
    print(t.name)
    t.age = 10
]]

load(chunk, nil, nil, { t = t, print=print })()

print(inspect(t))
