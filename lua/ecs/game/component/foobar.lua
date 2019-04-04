local ecs = ...

local move = ecs.component "move" {
    pos = {
        default = {
            x = 0,
            y = 0,
            z = 0,
        },
    },
    sync = true,
}

function move:set_position(pos)
    self.pos.x = pos.x
    self.pos.y = pos.y
    self.pos.z = pos.z
    self.sync = false
end

local player = ecs.component "player" {
    age = {
        type = "integer",
        default = function()
            return 0xf
        end,
    }
}

local hero = ecs.component "hero" {
    heroid = -1, -- 类型
}

local heroes = ecs.component "heroes"

function heroes:new()
    return {}
end
