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

-- 控制hook的深度
local function hook(level)
    local call = 0
    return function (mode, line)
        --print(inspect({...}))
        local info = debug.getinfo(2, "nS")
        --print(inspect(info))
        if mode == "return" then
            if call <= 0 then
                debug.sethook()
                return
            end
            call = call - 1
        elseif mode == "call" then
            call = call + 1
        end
        if call <= level then
            print(mode, inspect(info))
        end
    end
end

-- 在sethook 返回之后，将f设置为hook
local function up(level, f)
    local call = 0
    return function(mode)
        if mode == "return" then
            call = call + 1
            if call == level then
                debug.sethook(f, "cr")
            end
        elseif mode == "call" then
            call = call - 1
        end
    end
end

debug.sethook(up(1, hook(2)), "cr")
-- debug.sethook(up(1, hook(2)), "cr")

main()

local co = coroutine.create(foo)
print(coroutine.resume(co))
