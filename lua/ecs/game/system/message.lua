local ecs = ...
local world = ecs.world

local message = ecs.system "message"
message.singleton "heroes"

local service = {}
function service:select_hero(ctx, req)
    local resp = {ok = true}
    if self.heroes[req.uid] then
        resp.ok = false
        return resp
    end

    self.heroes[req.uid] = req.heroid

    -- ugly code
    local eid,e = world:new_entity(0, "player", "hero", "move")
    assert(e.player.age == 0xf)
    assert(e.move.pos.x == 0)
    assert(e.move.sync == true)
    assert(e.hero.heroid == -1)

    e.hero.heroid = req.heroid

    world.args.oqueue:push({ctx, "select_hero", resp})
    return resp
end

function service:move(ctx, req)
    local eid = self.heroes[req.uid]
    local e = world[eid]
    e.move:set_position(req.position)
end

function message:update()
    local iqueue = world.args.iqueue
    local oqueue = world.args.oqueue
    while true do
        local m = iqueue:pop()
        if not m then
            break
        end
        print("input:", m[1], m[2], m[3])

        local ctx = m[1]
        local name = m[2]
        local req = m[3]
        local cb = assert(service[name], name)
        cb(self, ctx, req)
    end
    iqueue:clear()

    while true do
        local m = oqueue:pop()
        if not m then
            break
        end
        print("output:", m[1], m[2], m[3])
    end
    oqueue:clear()
end
