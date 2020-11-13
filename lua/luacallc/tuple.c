#include "lauxlib.h"

int t_tuple (lua_State *L) {
    lua_Integer op = luaL_optinteger(L, 1, 0);
    if (op == 0) {
        int i;
        for (i = 1; !lua_isnone(L, lua_upvalueindex(i)); i++) {
            lua_pushvalue(L, lua_upvalueindex(i));
        }
        return i-1;
    } else {
        luaL_argcheck(L, 0<op && op<=256, 1, "index out of range");
        if (lua_isnone(L, lua_upvalueindex(op))) {
            return 0;
        }
        lua_pushvalue(L, lua_upvalueindex(op));
        return 1;
    } 
}

int lnew (lua_State *L) {
    int top = lua_gettop(L);
    lua_pushcclosure(L, t_tuple, top);
    return 1;
}

static const struct luaL_Reg funcs [] = {
    {"new", lnew},
    {NULL, NULL}
};

int luaopen_tuple(lua_State *L) {
    luaL_newlib(L, funcs);
    return 1;
}
