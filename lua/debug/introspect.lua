
local t = {}

local function f(k, v)
    t[k] = v
end
print(_G)
print(_ENV)

print(debug.getupvalue(f, 1))
