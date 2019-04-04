-- luacheck: globals import
local require = import and import(...) or require
local datatype = require "datatype"

-- for complex struct
local function gen_mt(c)
    if not next(c.method) then
        return nil
    end

    local index_func = function(_,k)
        local m = c.method[k]
        if m then
            return m
        end
        error(string.format("Type %s index field '%s'", c.name, k))
    end

    local newindex_func = function(_, k, _)
        error(string.format("Type %s newindex field '%s'", c.name, k))
    end

    return {
        __index = index_func,
        __newindex = newindex_func,
    }
end

-- for simple struct
local function gen_simple_mt(c)
    if not next(c.method) then
        return nil
    end

    local index_func = function(_,k)
        local m = c.method[k]
        if m then
            return m
        end
    end

    return {
        __index = index_func,
    }
end

local function gen_new(c)
    local constructor = c.method[c.name]
    if constructor then
        c.method[c.name] = nil
    end

    if c.struct then
        local cname = c.name
        if c.callback.new then
            error(string.format("Type %s defined at %s has a struct. It defines new at %s, use %s instead",
                c.name, c.defined, c.source.new, cname))
        end
        return function()
            local ret = {}
            for k,v in pairs(c.struct) do
                local default = v.default
                if default ~= nil then
                    ret[k] = default
                else
                    ret[k] = v.default_func()
                end
            end

            if constructor then
                constructor(ret)
            end

            local mt = gen_mt(c)
            if mt then
                setmetatable(ret, mt)
            end
            return ret
        end
    else
        -- user type
        local new = c.callback.new
        if new == nil then
            error(string.format("Type %s defined at %s has no struct without new",
                c.name, c.defined))
        end

        local mt = gen_simple_mt(c)

        if not constructor and not mt then
            return new
        end

        return function()
            local ret = new()

            if constructor then
                constructor(ret)
            end

            if mt then
                setmetatable(ret, mt)
            end
            return ret
        end
    end
end

local function gen_delete(c)
    return c.callback.delete
end

return function(c)
    local struct = c.struct and datatype(c)
    return {
        struct = struct,
        new = gen_new(c),
        delete = gen_delete(c),
    }
end
