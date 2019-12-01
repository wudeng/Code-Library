local mt = {__gc = function()
    print("hello")
end}

setmetatable({}, mt)

-- collectgarbage()
os.exit(true, true) -- the second true: close lua state before exit
