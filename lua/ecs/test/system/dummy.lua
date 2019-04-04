local ecs = ...
local world = ecs.world

--local math3d = require "math3d"

-- local math = ecs.component "math"
-- function math.new()
--     return math3d.new()
-- end

local dummy = ecs.system "dummy"

dummy.singleton "init"

dummy.depend "init"

function dummy:init()
    print ("Dummy init")
    self.init:print()

    local e1 = world:new_entity(0, "foo")
    local e2 = world:new_entity(e1, "foobar")
    print(string.format("foo %d is parent of %d", e1, e2))
end

function dummy:update()
    print ("Dummy update")
    for _, e in world:each "foo" do
        print("foo remove:", e.eid)
        world:remove_entity(e.eid)
    end

    world:new_entity(0, "foobar")
    for _, e in world:each "foobar" do
        print("2. Dummy foobar", e.eid)
    end
end

function dummy.new:foobar(eid)
    local e = world[eid]
    assert(e)
    print("foobar.new event:", eid)
end

function dummy.remove:foobar(eid)
    print("foobar.remove event:", eid)
end

local dby = ecs.system "dependby"
dby.dependby "dummy"

function dby:init()
    print("in dby:init()")
end
