local ecs = ...
local world = ecs.world

-- single object
local init = ecs.component "init" {
    banner = ""
} 

function init:print()
    print(self.banner)
end

local init_system = ecs.system "init"

init_system.singleton "init"    -- depend singleton components

function init_system:init()
    print ("Init system")
    self.init.banner = "Hello"
end

function init_system:update()
    print "Init update"
end
