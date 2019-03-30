local inspect = require "inspect"

local function bar()
    return "ret bar"
end

local function foo()
    bar()
    return "ret foo"
end

function main()
    foo()
end


local function hook(...)
    --print(inspect({...}))
    local info = debug.getinfo(2, "nS")
    --print(inspect(info))
    local mode = ...
    if mode == "return" then
        print(mode, inspect(info))
    else 
        print(mode, inspect(info))
    end
end

debug.sethook(hook, "cr")

main()

debug.sethook()
