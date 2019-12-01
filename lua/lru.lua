-- hash map + double linked list = lru
local node_mt = {}
node_mt.__index = node_mt

function node_mt:remove()
    self.pre.nxt = self.nxt
    self.nxt.pre = self.pre
    return self.key
end

function node_mt:append(head)
    self.nxt = head.nxt
    head.nxt.pre = self
    head.nxt = self
    self.pre = head
end

local function new_node(key, value)
    local obj = {key = key, value = value}
    obj.nxt = obj
    obj.pre = obj
    return setmetatable(obj, node_mt)
end

local mt = {}
mt.__index = mt

function mt:get(key)
    local v = self.cache[key]
    if not v then
        return nil
    end
    v:remove()
    v:append(self.head)
    return v.value
end

function mt:set(key, value)
    local v = self.cache[key]
    if v then -- 找到，更新值，插入头部
        v.value = value
        v:remove()
        v:append(self.head)
    else    -- 没找到，淘汰旧值, 插入头部
        v = new_node(key, value)
        self.cache[key] = v
        if self.size == self.capacity then
            self.cache[self.head.pre.key] = nil
            self.head.pre:remove()
        else
            self.size = self.size + 1
        end
        v:append(self.head)
    end
end

local function new(capacity)
    return setmetatable({
        cache = {},
        head = new_node(),
        capacity = capacity,
        size = 0,
    }, mt)
end

local lru = new(3)
lru:set(1,1)
print(lru:get(1))
lru:set(2,2)
print(lru:get(2))
lru:set(3,3)
print(lru:get(3))
lru:set(4,4)
print(lru:get(1))
