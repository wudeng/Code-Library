package.cpath=";../../build/clualib/?.so;"

function log(name)
    local tag = "[" .. name .. "] "
    local write = io.write
    return function(fmt, ...)
        write(tag)
        write(string.format(fmt, ...))
        write("\n")
    end
end

-- test ecs

local ecs = require "ecs"
local module = require "module"

local function new_world(iqueue, oqueue)
    local dir = "./game/"
    local modules = module({
        "system", 
        "component", 
    }, dir)

    local w = ecs.new_world {
        args = {iqueue = iqueue, oqueue = oqueue},
        modules = modules,
        module_path = dir .. "?.lua",
        update_order = { "stat_system", "message" }
    }
    return w
end

local queue_mt = {}
queue_mt.__index = queue_mt

function queue_mt:clear()
    self.r = 0
    self.n = 0
end

function queue_mt:count()
    return self.n - self.r
end

function queue_mt:push(m)
    if m == nil then
        error("m is nil")
    end

    self.n = self.n + 1
    self[self.n] = m
end

function queue_mt:pop()
    if self.r < self.n then
        self.r = self.r + 1
        return self[self.r]
    end
    return nil
end

local function new_queue()
    local obj = {
        r = 0, -- 已读个数
        n = 0, -- 队列长度
    }
    return setmetatable(obj, queue_mt)
end

local w1_iqueue = new_queue()
local w1_oqueue = new_queue()
local w1 = new_world(w1_iqueue, w1_oqueue)

print("Step 1")
local ctx1 = {}
local ctx2 = {}
w1_iqueue:push({ctx1, "select_hero", {uid=1, heroid=2}})
w1_iqueue:push({ctx2, "select_hero", {uid=2, heroid=1}})
w1.update()

print("Step 2")
w1_iqueue:push({ctx1, "move", {uid=1, position={x=1, y=2, z=3}}})
w1_iqueue:push({ctx2, "move", {uid=2, position={x=3, y=2, z=1}}})
w1.update()
