
local hook = require "hook"

hook.hook(2)

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

main()

--local co = coroutine.create(foo)
--print(coroutine.resume(co))
