
local function bar()
    return 1
end

local function foo()
    bar()
end

for i = 1, 10000000 do
    foo()
end
