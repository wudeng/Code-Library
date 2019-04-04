-- luacheck: globals import
local require = import and import(...) or require

local fs = require "filesystem"

local function add_path(root, path, all)
    local dir
    if root then
        dir = root .. "/" .. path
    else
        dir = path
    end

    local function isdir(filepath)
        if root then
            filepath = root .. "/" .. filepath
        end
        return fs.isdir(filepath)
    end

    for fname in fs.dir(dir) do
        local rpath = path .. "/" .. fname
        if isdir(rpath) and fname:match("[^%.]+") then
            add_path(root, rpath, all)
        else
            local name = rpath:match "^(.*)%.lua$"
            if name then
                assert(not all[rpath], rpath)
                all[rpath] = name:gsub("%/", ".")
            end
        end
    end
end

return function (paths, root)
    local all = {}
    for _, p in ipairs(paths) do
        add_path(root, p, all)
    end

    local modules = {}
    for _, p in pairs(all) do
        modules[#modules + 1] = p
    end
    return modules
end
