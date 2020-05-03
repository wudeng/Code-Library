local inspect = require "inspect"

--local t = {1,2,3,4,5}
--print(inspect(t))
--table.move(t, 3, 3+5, 1)
--print(inspect(t))


local count = 100000
local t = {}

local t1 = os.clock()
for i=1,count do
    t[i] = i
end

local t2 = os.clock()
print("============", t2-t1)
for i = 1,count do
    table.remove(t,1)
end

local t3 = os.clock()
print("============", t3-t2)
print(#t)

