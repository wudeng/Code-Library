
local function profile(f, ...)
    local ret = {f(...)}
    return table.unpack(ret)
end

--print(profile(math.max, 1, 3))
--
--for i = 1, 10000000 do 
--    profile(math.max, 1, 3)
--end


local function ret(...)
    return ...
end

local function profile2(f, ...)
    return ret(f(...))
end

print(profile2(math.max, 1, 3))

for i = 1, 10000000 do 
    profile2(math.max, 1, 3)
end
