#include <stdio.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

int main() {
    const char* filename = "config.lua";
    lua_State *L = luaL_newstate();
    if(luaL_dofile(L, filename)) {
        return luaL_error(L, "%s", lua_tostring(L, -1));
    }
    lua_getglobal(L, "width");
    int isnum = 0;
    lua_Integer w = lua_tointegerx(L, -1, &isnum);
    if (isnum) {
        printf("width = %lld\n", w);
    }
    return 0;
}
