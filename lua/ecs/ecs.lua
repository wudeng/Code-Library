--luacheck: globals import log
local require = import and import(...) or require
local log = log and log(...)
local errlog = log

local function init()
    local ok, Log = pcall(require, "log")
    if ok then
        log = Log.Debugf
        errlog = Log.Errorf
    end
end
init()

local typeclass = require "typeclass"
local system = require "system"
local component = require "component"
local pprof = require "pprof"

local fs = require "filesystem"

local ecs = {}
local world = {}
world.__index = world

-- 临时表，减少gc，慎重使用
local tmpt = {}

local default_component = {
    eid = true,
    peid = true,
}
-- 发布事件
local function event_publish(w, eid, c, event, ...)
    local event_name = c .. "." .. event
    if not w._subscribers[event_name] then
        return
    end

    local args = table.pack(event_name, eid, ...)
    w._events.n = w._events.n + 1
    w._events[w._events.n] = args
end

local function new_component(w, entity, c, ...)
    if c then
        if entity[c] then
            error(string.format("multiple component defined:%s", c))
        end
        entity[c] = w._component_type[c].new()

        event_publish(w, entity.eid, c, "new")

        local set = w._set[c]
        if set then
            set[#set+1] = entity.eid
        end
        new_component(w, entity, ...)
    end
end

function world:add_component(eid, ...)
    local e = assert(self[eid], eid)
    new_component(self, e, ...)
    return e
end

function world:_remove_component(eid, e, component_type)
    local c = e[component_type]
    if not c then
        error("c is nil")
    end
    self._set[component_type] = nil
    local del = self._component_type[component_type].delete
    if del then
        del(c)
    end
    e[component_type] = nil
    event_publish(self, eid, component_type, "remove", c)
end

function world:remove_component(eid, component_type)
    if default_component[component_type] then
        error(component_type .. " is default component")
    end
    local e = assert(self[eid])
    self:_remove_component(eid, e, component_type)
end

function world:reserve_components(eid, components)
    local map = {}
    for _, c in ipairs(components) do
        map[c] = true
    end

    local e = assert(self[eid])
    for ct in pairs(e) do
        if not (default_component[ct] or map[ct]) then
            self:_remove_component(eid, e, ct)
        end
    end
end

function world:change_component(eid, component_type, ...)
    event_publish(self, eid, component_type, "change", ...)
end

function world:component_list(eid)
    local e = assert(self[eid])
    local r = {}
    for k in pairs(e) do
        table.insert(r, k)
    end
    return r
end

local function create_entity(w, peid)
    local eid = w._entity_id + 1
    w._entity_id = eid
    local e = {}
    e.eid = eid
    e.peid = peid

    w[eid] = e
    w._entity[eid] = e
    return eid, e
end

-- peid: parent entity id
-- ...: component list
function world:new_entity(peid, ...)
    if not peid then
        peid = 0
    end

    if peid ~= 0 then
        assert(self[peid], "Invalid entity parent:"..peid)
    end

    local eid, e = create_entity(self, peid)
    new_component(self, e, ...)
    return eid, e
end

-- remove all child of peid
function world:remove_child(peid)
    if not self[peid] then
        return
    end

    local n = 0
    for eid, e in pairs(self._entity) do
        if e.peid == peid then
            n = n + 1
            tmpt[n] = eid
        end
    end

    for i=1,n do
        self:remove_entity(tmpt[i])
    end
end

function world:remove_entity(eid)
    local e = assert(self[eid])

    -- remove child
    self:remove_child(eid)

    -- remove self
    self[eid] = nil
    self._entity[eid] = nil

    -- notify all components of this entity
    for component_type in pairs(e) do
        if not default_component[component_type] then
            self:_remove_component(eid, e, component_type)
        end
    end
end

local function component_next(set, index)
    local n = #set
    index = index + 1
    while index <= n do
        local eid = set[index]
        if eid == nil then
            return
        end
        local e = set.entity[eid]
        if e then
            return index, e
        end
        set[index] = set[n]
        set[n] = nil
        n = n - 1
    end
end

function world:each(component_type)
    local s = self._set[component_type]
    if s == nil then
        s = { entity = self._entity }
        for eid, e in pairs(self._entity) do
            if e[component_type] ~= nil then
                s[#s+1] = eid
            end
        end
        self._set[component_type] = s
    end
    return component_next, s, 0
end

function world:first_entity(c_type)
    -- luacheck: push ignore 
    for _, e in self:each(c_type) do
        return e
    end
    -- luacheck: pop
end

function world:get_parent(eid)
    local e = self[eid]
    return self[e.peid]
end

function world:get_root(eid)
    local e = self[eid]
    while e.peid ~= 0 do
        e = self[e.peid]
    end
    return e
end

-- 获取指定名字的 singleton
function world:singleton(name)
    return self.singletons[name]
end

-- 内部状态
function world:info()
    local ret = {}
    ret.entitys = {}
    for eid in pairs(self._entity) do
        ret.entitys[#ret.entitys + 1] = eid
    end

    ret.singletons = {}
    for name in pairs(self.singletons) do
        ret.singletons[#ret.singletons + 1] = name
    end

    local components = {}
    ret.components = components
    for _, e in pairs(self._entity) do
        for c in pairs(e) do
            if not components[c] then
                components[c] = 0
            end
            components[c] = components[c] + 1
        end
    end
    return ret
end

local function component_filter(minor_type)
    return function(set, index)
        local e
        while true do
            index, e = component_next(set, index)
            if e then
                if e[minor_type] then
                    return index, e
                end
            else
                return
            end
        end
    end
end

function world:each2(ct1, ct2)
    local _,s = self:each(ct1)
    return component_filter(ct2), s, 0
end

local function searchpath(name, path)
    local err = ''
    name = string.gsub(name, '%.', '/')
    for c in string.gmatch(path, '[^;]+') do
        local filename = string.gsub(c, '%?', name)
        if fs.isfile(filename) then
            return filename
        end
        err = err .. ("\n    no file '%s'"):format(filename)
    end
    return nil, err
end

local function init_modules(w, modules, module_path)
    local reg, class = typeclass(w)
    local env = setmetatable({}, {
        __index = _G,
        __newindex = function(_,k,_)
            assert(false, "Can't define global variable:" .. k)
        end,
    })

    local mods = {}
    local function import(name)
        local mod = mods[name]
        if mod ~= nil then
            return mod
        end

        local path, err = searchpath(name, module_path)
        if not path then
            error(("module '%s' not found:%s"):format(name, err))
        end

        -- luacheck: ignore err
        local module, err = loadfile(path, "bt", env)
        if not module then
            error(("module '%s' load failed:%s"):format(name, err))
        end

        log("Init module '%s'", name)
        mod = module(reg)
        if mod == nil then
            mod = true
        end
        mods[name] = mod
        return mod
    end

    reg.import = import

    for _, name in ipairs(modules) do
        import(name)
    end

    return class
end

-- config.modules
-- config.module_path
-- config.update_first
-- config.update_last
-- config.args
-- config.profile -- 统计性能
function ecs.new_world(config)
    local w = setmetatable({
        args = config.args,
        _component_type = {},    -- component type objects
        update = nil,    -- update systems

        _entity = {},    -- entity id set
        _entity_id = 0,

        singletons = nil, -- singletons: name -> singleton

        _subscribers = nil, -- component_type.event: { subscriber_list }
        _events = { n = 0 }, -- events list

        _set = setmetatable({}, { __mode = "kv" }), -- component_type : entity list
    }, world)

    -- load systems and components from modules
    local class = init_modules(w, config.modules, config.module_path)

    for k,v in pairs(class.component) do
        w._component_type[k] = component(v)
    end

    -- init system
    w.singletons = system.singleton(class.system, w._component_type)
    local proxy = system.proxy(class.system, w.singletons)

    local init_list, update_list, sort_list = system.sort(class.system, config.update_first, config.update_last)

    local update_switch = system.list_switch(update_list)

    w._subscribers = system.subscribers(class.system, sort_list, proxy)
    local subscribers_switch = system.table_switch(w._subscribers)

    function w.enable_system(name, enable)
        update_switch:enable(name, enable)
        subscribers_switch:enable(name, enable)
    end

    local profile = config.profile or pprof.dummy
    local counter = profile.counter

    local frame
    local safe_call = function(catalog, name, f, ...)
        local t1 = counter()
        local ok, err = xpcall(f, debug.traceback, ...)
        local elapsed = counter() - t1
        profile:count(catalog, name, elapsed, frame)

        if not ok then
            errlog(err)
        end
    end

    -- dispatch events
    local notify = function(catalog)
        subscribers_switch:update()

        -- dispatch event
        local n = w._events.n
        for i=1, n do
            local event = w._events[i]
            local event_name = event[1]

            local subscribers = w._subscribers[event_name]
            if not subscribers then
                goto continue
            end

            for _, functor in ipairs(subscribers) do
                local f, inst = functor[2], functor[3]
                safe_call(catalog, event_name, f, inst, table.unpack(event, 2, event.n))
            end
            ::continue::
        end

        local nn = 0
        for p = n + 1, w._events.n do
            nn = nn + 1
            w._events[nn] = w._events[p]
        end
        w._events.n = nn
    end

    local update = function()
        update_switch:update()
        for _, v in ipairs(update_list) do
            local name, f = v[1], v[2]
            safe_call("update", name, f, proxy[name])
        end
    end

    frame = 0
    function w.update()
        local t1 = counter()
        frame = frame + 1
        notify("pre_notify")
        update()
        notify("pos_notify")
        local elapsed = counter() - t1
        profile:count("total", "all", elapsed)
    end

    -- call init functions
    for _, v in ipairs(init_list) do
        local name, f = v[1], v[2]
        log("Init system %s", name)
        f(proxy[name])
    end

    return w
end

return ecs
