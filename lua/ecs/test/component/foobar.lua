local ecs = ...

local foo = ecs.component "foo" {
}

local foobar = ecs.component "foobar" {
    x = 0.0,
    y = 0.0,    
}

-- init function
function foobar:foobar()
    print("foobar new:", self.x, self.y)
    self.temp = 0
end

function foobar:delete()
    print("foobar delete:", self.x, self.y)
end

function foobar:print()
    print("foobar print:", self.x, self.y, self.temp)
end

