local inspect = require "lib.inspect"

local big = string.pack(">I2", 1)
local small = string.pack("<I2", 1)

print(inspect(big))     -- "\0\1"
print(inspect(small))   -- "\1\0"

