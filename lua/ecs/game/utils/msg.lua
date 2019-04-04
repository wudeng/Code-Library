local ecs = ...
local world = ecs.world

local M = {}

function M.message_count()
    return world.args.iqueue:count(), world.args.oqueue:count()
end

return M
