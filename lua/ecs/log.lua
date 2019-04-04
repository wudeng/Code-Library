local inspect = require "inspect"
print = function(...)
    local t = table.pack(...)
    local info = debug.getinfo(2)
    local lineinfo = string.format("%s:%d", info.source, info.currentline)
    local write = io.write
    write(lineinfo)
    for i = 1, t.n do
        io.write("\t")
        io.write(inspect(t[i]))
    end
    io.write("\n")
end

return {
    Debugf = function(fmt, ...)
        print(string.format(fmt, ...))
    end,
    Errorf = function(fmt, ...)
        print(string.format(fmt, ...))
    end,
}

