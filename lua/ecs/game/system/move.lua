local ecs = ...
local world = ecs.world

local move = ecs.system "move"

function move:sync(e)
    return {
        eid = e.eid,
        position = {
            x = e.move.pos.x,
            y = e.move.pos.y,
            z = e.move.pos.z
        }
    }
end

function move:update()
    local pos_sync = nil
    for _, e in world:each "move" do
        if not e.move.sync then
            if not pos_sync then
                pos_sync = {}
            end
            e.move.sync = true
            pos_sync[#pos_sync+1] = self:sync(e)
            print("hero:", e.hero)
        end
    end
    if pos_sync then
        world.args.oqueue:push({nil, "pos_sync", pos_sync})
    end
end
