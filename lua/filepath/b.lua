local name,path=...
print(name,path)
print(...)
local p = path:match("^(.+)[%./][^%./]+")
print(p)
