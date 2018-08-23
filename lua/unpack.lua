local person = {
    name = "wudeng",
    sex = "male",
    age = 33
}

local function print_person_info(age, name, sex)
    print (string.format("age=%d, name=%s, sex=%s", age, name, sex))
end


local function gen_unpack_f(f)
    local nparam = debug.getinfo(f, "u").nparams
    local src = {}
    for i = 1, nparam do
        local name = debug.getlocal(f, i)
        table.insert(src, "param."..name)
    end
    local str = "return function(param) return ".. table.concat(src, ",") .. " end"
    print(str)
    return (load(str))()
end

local function make_cb(f)
    return function(obj)
        f(gen_unpack_f(f)(obj))
    end
end

print_person_info(gen_unpack_f(print_person_info)(person))
make_cb(print_person_info)(person)
