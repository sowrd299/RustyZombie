//A c-program to run lua CTTM 

#include<stdio.h>

//import lua
#include<lua.h>
#include<lauxlib.h>
#include<lualib.h>

int main(void){
    printf("Loading CTTM...\n\n");
    lua_State *L;
    L = luaL_newstate();
    luaL_openlibs(L);
    if(luaL_loadfile(L, "main.lua")){
       //if loadfile does not return 0 
       printf("Failed to load ./src/main.lua\n");
       return 1;
    }
    if(lua_pcall(L,0,0,0)){
        //if pcall does not return 0
        printf("Failed to execute\n");
        return 2;
    }
    return 0;
}
