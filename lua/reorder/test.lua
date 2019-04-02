--local function next_index(weight, total, left_index)
--    local rnd = math.random(total)
--    local acc = 0
--    for k in pairs(left_index) do
--        local w = weight[k]
--        acc = acc + w
--        if rnd <= acc then
--            return k
--        end
--    end
--end
--
--local function reorder(weight, total, left_index, ret)
--    if total == 0 then
--        return ret
--    end
--    local next_i = next_index(weight, total, left_index)
--    table.insert(ret, next_i)
--    left_index[next_i] = nil
--    total = total - weight[next_i]
--    return reorder(weight, total, left_index, ret)
--end

local function reorder(indexes, weight, total)
    for i = 1, #indexes do
        local rnd = math.random(total)
        local acc = 0
        for j = i, #indexes do
            local w = weight[indexes[j]]
            acc = acc + w
            if rnd <= acc then
                indexes[i], indexes[j] = indexes[j], indexes[i]
                total = total - w
                break
            end
        end
    end
end

local inspect = require "inspect"

local c = {0, 0}
for _ = 1, 200 do
	local indexes = {1,2}
	reorder(indexes, {20,20}, 40)
	c[indexes[1]] = (c[indexes[1]] or 0) + 1
	print(inspect(indexes))
end

print(inspect(c))
