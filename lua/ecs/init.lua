require "import"
local require = import(...)

local ecs = require "ecs"
ecs.modules = require "module"
return ecs
