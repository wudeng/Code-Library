local dummy = {}
function dummy:__tostring()
    return "<default_userdata>"
end

function dummy:__index(k)
    error("Access default userdata: "..k)
end

function dummy:__newindex(k)
    error("Modify default userdata: "..k)
end

local default_userdata = setmetatable({},{__index = dummy})

local available_type = {
    integer  = { default = 0 },
    float    = { default = 0.0 },
    boolean  = { default = false },
    string   = { default = "" },
    table    = { default = function() return {} end },
    userdata = { default = default_userdata },
}

local function gen_value(name, field, v)
    local typename
    local default

    local function get_default_type(default)            
        if default == nil then
            return nil
        end

        local tt = type(default)
        if tt == "number" then
            return math.type(default)
        end

        if tt == "function" then
            return nil
        end

        if tt == "userdata" then
            error("Invalid type:" .. tt)
        end

        return tt
    end


    if type(v) == "table" then
        -- 容忍用户定义的type和default不匹配的情况
        typename = v.type or get_default_type(v.default)
        default = v.default
    else
        typename = get_default_type(v)
        default = v
    end

    if not typename or not available_type[typename] then
        error(string.format("Invalid type! Component %s field %s", name, field))
    end

    local tv = type(default)
    if tv == "thread" or tv == "userdata" then
        error(string.format("Invalid default! Component %s field %s", name, field))
    end

    if default == nil then
        default = available_type[typename].default
    end

    return { 
        type    = typename, 
        default = default
    }
end

local function gen_default(v)
    local ttype = type(v.default)
    if ttype == "function" then
        v.default_func = v.default
        v.default = nil
    end

    if v.typename == "userdata" then
        return
    end

    if ttype == "table" then
        local defobj = v.default
        local function check_defobj(defobj)
            for k,v in pairs(defobj) do
                if type(v) == "table" then
                    check_defobj(v)
                end
                assert(type(k) ~= "table")
            end
        end
        check_defobj(defobj)

        local function deep_copy(obj)
            local t = {}
            for k, v in pairs(obj) do
                if type(v) == "table" then
                    local tt = deep_copy(v)
                    t[k] = tt
                else
                    t[k] = v
                end
            end
            return t
        end

        v.default = nil
        v.default_func = function()
            return deep_copy(defobj)
        end
    end
end

return function (c)
    local t = c.struct
    local struct = {}
    for k,v in pairs(t) do
        assert(type(k) == "string", "Property name should be string")
        v = gen_value(c.name, k, v)
        struct[k] = v
        gen_default(v)
    end
    c.struct = struct
    return t
end
