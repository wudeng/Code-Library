
local function foo()
    local function bar()
        return 1
    end
    bar()
end

for i = 1, 10000000 do
    foo()
end
