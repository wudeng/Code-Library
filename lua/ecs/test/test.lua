--package.cpath=";../../build/clualib/?.so;"
package.path="./?.lua;"..package.path

require "log"


-- test solve_depend

TEST = true

local system = require "system"

print (system)

local test = {
    a = { depend = { "b", "c" } },
    b = { depend = { "c" } },
    c = {},
    d = { depend = { "b", "a" } },
}

local list = system._solve_depend(test)
assert(table.concat(list) == "cbad")

-- test ecs

local ecs = require "ecs"
--local modules = require "module"

--local m = modules "test/system;test/component"
local module_searchdirs = "./?.lua"
local w = ecs.new_world { modules = {
                "test.system.dummy",
                "test.system.init",
                "test.component.foobar" },
                module_path = module_searchdirs,
                update_first = {"init" },
                update_last = {"dummy"},
            }

print("--------- Step 1 -----------")
w.update()

print("--------- Step 2 -----------")
w.enable_system("dummy", true)
w.update()

print("disable dummy system")
w.enable_system("dummy", false)

print("--------- Step 3 -----------")
w:new_entity(0, "foobar")
w.update()
