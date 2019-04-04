local ecs = ... 

local stat_system = ecs.system "stat_system"

local MsgUtil = ecs.import "utils.msg"

function stat_system:update()
    local icount, ocount = MsgUtil.message_count()
    print("------ input message:", icount) 
    print("------ output message:", ocount) 
end
