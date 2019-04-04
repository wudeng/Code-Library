--luacheck: globals log
--luacheck: ignore 561
local log = print

-- load systems

local system = {}    -- module system
system.events = { "new", "change", "remove" }

function system.singleton(sys, c)
    local s = {}
    for _,v in pairs(sys) do
        if v.singleton then
            for _, singleton_name in ipairs(v.singleton) do
                local singleton_typeobject = c[singleton_name]
                if not singleton_typeobject then
                    error( singleton_name .. " is not defined")
                end
                if s[singleton_name] == nil then
                    log("New singleton %s", singleton_name)
                    s[singleton_name] = singleton_typeobject.new()
                end
            end
        end
    end
    return s
end

local function gen_proxy(sname, sto, singletons)
    local inst = {}
    if sto.singleton then
        for _, singleton_name in ipairs(sto.singleton) do
            inst[singleton_name] = singletons[singleton_name]
        end
    end

    if sto.method then
        for method_name, f in pairs(sto.method) do
            if inst[method_name] then
                error(string.format("Method %s conflict in system %s", method_name, sname))
            end
            inst[method_name] = f
        end
    end
    return inst
end

function system.proxy(sys, singletons)
    local p = {}
    for sname, system_typeobject in pairs(sys) do
        p[sname] = gen_proxy(sname, system_typeobject, singletons)
    end
    return p
end

local function get_sort_keys(t)
    local keys = {}
    for k in pairs(t) do
        table.insert(keys, k)
    end

    table.sort(keys)
    return keys
end

local function solve_depend(graph)
    -- topological sorting
    local ret = {}    -- sorted result
    local S = {}    -- nodes with no depend
    local G = {}    -- nodes with depend
    local function insert_result(value)
        table.insert(ret, value)
        S[value] = true
    end

    local graphkeys = get_sort_keys(graph)

    -- combine depend and dependby
    local dp_table = {}
    --for k,v in pairs(graph) do
    for _, k in ipairs(graphkeys) do
        local v = graph[k]
        local function get_dp(t, dpk)
            local dp = t[dpk]
            if dp == nil then
                dp = {}
                t[dpk] = dp
            end
            return dp
        end

        local depend = v.depend
        if depend then
            assert(type(depend) == "table", k)
            local dp = get_dp(dp_table, k)
            table.move(depend, 1, #depend, #dp+1, dp)
        end

        local dependby = v.dependby
        if dependby then
            for _, n in ipairs(dependby) do
                assert(type(dependby) == "table", k)
                local dpby = get_dp(dp_table, n)
                table.insert(dpby, k)
            end
        end
    end

    --for k,v in pairs(graph) do
    for _, k in ipairs(graphkeys) do
        -- local depend = v.depend
        local depend = dp_table[k]
        if depend then
            assert(type(depend) == "table", k)
            local depend_keys = {}
            for _, key in ipairs(depend) do
                if not S[key] then
                    if graph[key] == nil then
                        error(key .. " not exist")
                    end
                    depend_keys[key] = true
                end
            end
            if next(depend_keys) then
                G[k] = depend_keys
            else
                insert_result(k)
            end
        else
            insert_result(k)
        end
    end
    while next(G) do
        local reduce
        local Gkeys = get_sort_keys(G)

        --for name,depends in pairs(G) do
        for _, name in ipairs(Gkeys) do
            local depends = G[name]
            for depend in pairs(depends) do
                if S[depend] then
                    depends[depend] = nil
                end
            end
            if next(depends) == nil then
                insert_result(name)
                G[name] = nil
                reduce = true
            end
        end
        if not reduce then
            local tmp = { "Circular dependency : "}
            for k, v in pairs(G) do
                local line = { k .. " :" }
                for depend in pairs(v) do
                    table.insert(line, depend)
                end
                table.insert(tmp, table.concat(line, " "))
            end
            error(table.concat(tmp, "\n"))
        end
    end
    return ret
end

-- 排序系统，生成init和update列表
function system.sort(sys, first, last)
    local sorted = {}
    local norder = {}
    for sname in pairs(sys) do
        norder[sname] = true
    end

    -- 标志最后更新
    if last then
        for _, sname in ipairs(last) do
            if sys[sname] then
                norder[sname] = false
            end
        end
    end

    -- 最先更新
    if first then
        for _, sname in ipairs(first) do
            if sys[sname] then
                table.insert(sorted, sname)
                norder[sname] = nil
            end
        end
    end

    local dp_list = solve_depend(sys)
    for _, sname in ipairs(dp_list) do
        if norder[sname] then
            table.insert(sorted, sname)
            norder[sname] = nil
        end
    end

    if last then
        for _, sname in ipairs(last) do
            if norder[sname] == false then
                table.insert(sorted, sname)
                norder[sname] = nil
            end
        end
    end

    assert(not next(norder))

    local init_list = {}
    local update_list = {}
    for _, sname in ipairs(sorted) do
        local init = sys[sname].callback.init
        if init then
            table.insert(init_list, { sname, init })
        end

        local update = sys[sname].callback.update
        if update then
            table.insert(update_list, { sname, update })
        end
    end
    return init_list, update_list, sorted
end

local function subscriber_list(ret, event, sname, sto, proxy)
    for cname, f in pairs(sto[event]) do
        local functor = { sname, f, proxy[sname] }
        local name = cname .. "." .. event -- full event name
        local t = ret[name]
        if not t then
            t = {functor}
            ret[name] = t
        else
            table.insert(t, functor)
        end
    end
end

-- 生成消息订阅者
function system.subscribers(sys, sort_list, proxy)
    local ret = {}
    for _, sname in ipairs(sort_list) do
        for _, event in ipairs(system.events) do
            subscriber_list(ret, event, sname, sys[sname], proxy)
        end
    end

    return ret
end

local switch_mt = {}; switch_mt.__index = switch_mt

function switch_mt:enable(name, enable)
    if enable ~= false then
        enable = nil
    end
    if self[name] ~= enable then
        self.__needupdate = true
        self[name] = enable
    end
end

function switch_mt:_copy_list(dst, src)
    local index = 1
    for i=1, #src do
        local name = src[i][1]
        if self[name] ~= false then
            -- enable it
            dst[index] = src[i]
            index = index + 1
        end
    end

    for i=index, #dst do
        dst[i] = nil
    end
end

function switch_mt:update()
    if not self.__needupdate then
        return
    end

    if self.mode == "list" then
        self:_copy_list(self.__ret, self.__all)
    else
        for k, list in pairs(self.__all) do
            self:_copy_list(self.__ret[k], list)
        end
    end
    self.__needupdate = nil
end

function system.list_switch(list)
    local all_list = {}
    for k,v in pairs(list) do
        all_list[k] = v
    end
    return setmetatable({
        __ret = list,
        __all = all_list,
        mode = "list",
    } , switch_mt )
end

function system.table_switch(map)
    local all = {}

    -- copy
    for k, array in pairs(map) do
        local list = {}
        all[k] = list
        for i, v in ipairs(array) do
            list[i] = v
        end
    end

    return setmetatable({
        __all = all,
        __ret = map,
        mode = "map",
    },  switch_mt)
end

-- luacheck: globals TEST
if TEST then
    system._solve_depend = solve_depend    -- for test
end

return system
