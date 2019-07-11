local obj = setmetatable({}, {
    __newindex=function(t,k,v) 
        print("set key:", k) 
        rawset(t, k, v) 
    end,
    __index=function(t,k) 
        print("get key:", k) 
    end,
})

local a
print("begin")
a = obj.a
obj.a = 1
a = obj.a
obj.b = 2
obj.a = 2
print("end")
