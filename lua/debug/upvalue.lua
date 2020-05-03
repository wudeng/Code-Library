local op = print

local env = {
    print = function(...)
        print("new", ...)
    end
}
print("_ENV", _ENV)
print ("env", env)

local function f()
    print("hello")
end

local function getupvalue(f, name)
    local i = 1
    while true do 
        local k, v = debug.getupvalue(f, i)
        if not k then 
            break
        end
        if k == name then 
            return i, v 
        end 
        i = i + 1
    end
end

print(getupvalue(f, "_ENV"))
f()
-- debug.upvaluejoin(f, getupvalue(f,"_ENV"),function()return env end, 1)
debug.setupvalue(f,getupvalue(f,"_ENV"),env) -- stackoverflow
op(_ENV)
-- print(getupvalue(f, "_ENV"))
-- f()
