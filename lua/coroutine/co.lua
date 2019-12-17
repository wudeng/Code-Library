local function foo(x)
    print("111", x)
    coroutine.yield(x+1)
    print("222")
    error("error_msg")
    return "333"
end

print("000")
local co = coroutine.create(foo)

print(coroutine.resume(co, 10))
print(coroutine.resume(co))
print(debug.traceback(co,"mytrace"))
--print(coroutine.resume(co))
