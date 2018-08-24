local function f()
    return 1, 2, nil
end

print( xpcall(f, debug.traceback) )

local ret = table.pack(xpcall(f, debug.traceback))

assert(ret[1], ret[2])

print(table.unpack(ret, 2, ret.n)) -- 1, 2, nil

print(table.unpack(ret, 2)) -- 1, 2
