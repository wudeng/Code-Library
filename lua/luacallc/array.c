#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#define checkarray(L) \
    luaL_checkudata(L, 1, "array")

typedef struct array {
    int length;
    int a[1];
} array;

static int lnew(lua_State *L) {
    array *ptr;
    // get array size
    int size = luaL_checkinteger(L, 1);
    // create userdata and push to stack
    int len = sizeof(struct array) + sizeof(int) * (size - 1);
    ptr = (array *)lua_newuserdata(L, len);
    ptr->length = size;
    luaL_setmetatable(L, "array");
    return 1;
}

static int lset(lua_State *L) {
    array *ptr = checkarray(L);
    int index = lua_tointeger(L, 2);
    int value = lua_tointeger(L, 3);
    ptr->a[index] = value;
    return 0;
}

static int lget(lua_State *L) {
    array *ptr = checkarray(L);
    int index = lua_tointeger(L, 2);
    int val = ptr->a[index];
    lua_pushinteger(L, val);
    return 1;
}


static const struct luaL_Reg arraylib_f [] = {
    {"new", lnew},
    {NULL, NULL}
};

static const struct luaL_Reg arraylib_m [] = {
    {"__newindex", lset},
    {"__index", lget},
    {NULL, NULL}
};

int luaopen_array(lua_State *L) {
    luaL_newmetatable(L, "array");
    luaL_setfuncs(L, arraylib_m, 0);
    luaL_newlib(L, arraylib_f);
    return 1;
}
