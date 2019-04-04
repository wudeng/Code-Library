-- just for test

local lfs = require "lfs"
local M = {}
function M.isfile(filepath)
    return lfs.attributes(filepath, "mode") == "file"
end

function M.isdir(filepath)
    return lfs.attributes(filepath, "mode") == "directory"
end

M.dir = lfs.dir
return M
