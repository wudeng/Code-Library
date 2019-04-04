local mt = {}
mt.__index = mt

function mt:info()
    return self.catlogs
end

function mt:count(catalog, name, span, ud)
    if not catalog then
        catalog = "default"
    end

    local items = self.catlogs[catalog]
    if not items then
        items = {}
        self.catlogs[catalog] = items
    end

    local item = items[name]
    if not item then
        item = {
            name = name,
            count = 1,
            cpu = span,
            max = span,
            min = span,
            recent = span,
            ud = ud,
        }
        items[name] = item
        return
    end

    item.count = item.count + 1
    item.cpu = item.cpu + span
    item.recent = span
    item.ud = ud
    if span > item.max then
        item.max = span
    end

    if span < item.min then
        item.min = span
    end
end

local M = {}
function M.new(counter)
    if not counter then
        counter = function() return 0 end
    end
    return setmetatable({counter=counter, catlogs={}}, mt)
end

-- 空计数器
local function dummy_func()
    return 0
end
M.dummy = {counter=dummy_func, count=dummy_func}

return M
