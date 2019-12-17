local function f()
    --x() 
    error("xyz",3)
end

print(pcall(f))

print(xpcall(f, debug.traceback))


