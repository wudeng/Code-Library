local function foo()
end

print(debug.getinfo(foo, "S").source)
