-- https://stackoverflow.com/questions/29972712/algorithm-to-shuffle-an-array-randomly-based-on-different-weights
local inspect = require "inspect"

local array = {1, 2, 7}
local weight = {1, 2, 7}


local function weight_random_shuffle()
    local index = {1, 2, 3}
    local k = {}
    for i, w in ipairs(weight) do
        k[i] = -math.random()^(1 / weight[i])
        --print(k[i])
    end

    table.sort(index, function(i, j) 
        return k[i] < k[j]
    end)

    print(inspect(index))
end

for i=1,1000 do
    weight_random_shuffle()
end

