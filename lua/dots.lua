local inspect = require "inspect"

local function hello(...)
    local t = {...}
    print(inspect(t))
end

hello("abc","dd",11)
