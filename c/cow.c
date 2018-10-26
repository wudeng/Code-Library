#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>

#include "lua.h"
#include "lauxlib.h"

// This is a Lua-callable function.
// It prints out a cow uttering the user's string.
static int say(lua_State *L) {

    char *str;
    asprintf(&str, "cowsay %s", lua_tostring(L, -1));
    system(str);
    free(str);

    return 0;
}

// This is the module's initialization function.
// It's called implicitly by Lua when the module loads.
int luaopen_cow(lua_State *L) {

    static const struct luaL_Reg cow_lib[] = {
        {"say", say},
        {NULL, NULL}
    };

    luaL_newlib(L, cow_lib);

    return 1;
}
