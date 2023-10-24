// kona.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "kona.h"

#define kona_c

// linking to LuaJIT here
#include "../luajit/src/lua.h"
#include "../luajit/src/lauxlib.h"
#include "../luajit/src/lualib.h"
#include "../luajit/src/luajit.h"
#include "konaconf.h"

#include "kona_lua.h"
#include "sample_lua.h"

// Setup static Variables
static lua_State *globalL = NULL;
static const char *progname = KONA_PROGNAME;
static char *empty_argv[2] = { NULL, NULL };

// prints usage of the Kona
static void print_usage(void) {
  fputs("usage: ", stderr);
  fputs(progname, stderr);
  fputs(" [options]... [script [args]...].\n"
  "  If you can't tell you write kona then add options after.\n"
  "  Eventually you can pipe a script to it.\n",
  stderr);
  fflush(stderr);
}

static void print_version(void) {
  fputs(KONA_VERSION " -- " KONA_COPYRIGHT ". "KONA_URL "\n", stdout);
  fputs(KONA_COPYMORE "\n", stdout);
  fputs(LUAJIT_VERSION " -- " LUAJIT_COPYRIGHT ". " LUAJIT_URL "\n", stdout);
}


// placeholder interpret command, converts Kona to Lua, our special blend, to be run by the interpreter thingy.
int interpret(const char* source) {
  printf("%s", source);
//   Chunk chunk;
//   initChunk(&chunk);
//
//   if (!compile(source, &chunk)) {
//     freeChunk(&chunk);
//     return INTERPRET_COMPILE_ERROR;
//   }
//
//   vm.chunk = &chunk;
//   vm.ip = vm.chunk->code;
//
//   InterpretResult result = run();
//
//   freeChunk(&chunk);
  return 0;
}

// perhaps just ignore everything above. rewrite everyting we can in Lua first, then we'll worry about speed or whatever.

static void repl() {
  char line[1024];
  for(;;) {
    printf("> ");

    if (!fgets(line, sizeof(line), stdin)) {
      printf("\n");
      break;
    }

    interpret(line);
    // printf("interpret(line); \n");
  }
}

// add message thing
static void l_message(const char *msg)
{
  if (progname) { fputs(progname, stderr); fputc(':', stderr); fputc(' ', stderr); }
  fputs(msg, stderr); fputc('\n', stderr);
  fflush(stderr);
}

static int report(lua_State *L, int status)
{
  if (status && !lua_isnil(L, -1)) {
    const char *msg = lua_tostring(L, -1);
    if (msg == NULL) msg = "(error object is not a string)";
    l_message(msg);
    lua_pop(L, 1);
  }
  return status;
}

static char* readFile(const char* path) {
  FILE* file = fopen(path, "rb");
  if (file == NULL) {
    fprintf(stderr, "Could not open file \"%s\".\n", path);
    exit(74);
  }

  fseek(file, 0L, SEEK_END);
  size_t fileSize = ftell(file);
  rewind(file);

  char* buffer = (char*)malloc(fileSize + 1);
  if (buffer == NULL) {
    fprintf(stderr, "Not enough memory to read \"%s\".\n", path);
    exit(74);
  }

  size_t bytesRead = fread(buffer, sizeof(char), fileSize, file);
  if (bytesRead < fileSize) {
    fprintf(stderr, "Could not read file \"%s\".\n", path);
    exit(74);
  }

  buffer[bytesRead] = '\0';

  fclose(file);
  return buffer;
}

static void runFile(const char* path) {
  char* source = readFile(path);
  // interpret the result and compile it to a Lua string buffer + a Kona String Buffer.
  int result = interpret(source);
  free(source);

  if (result == INTERPRET_COMPILE_ERROR) exit(65);
  if (result == INTERPRET_RUNTIME_ERROR) exit(70);
}
//
// int main(int argc, char **argv) {
//   // start VM, which is luaJit with loaded libraries
//
//   lua_State *L;
//   int dofile;
//   L = lua_open();
//   lua_gc(L, LUA_GCSTOP, 0);
//   luaL_openlibs(L);
//   lua_gc(L, LUA_GCRESTART, -1);
//
//   if (L == NULL) {
//     l_message("cannot create state: not enough memory");
//     return EXIT_FAILURE;
//   }
//
//   dofile = luaL_dofile(L, "kona.lua");
//   // dofile = luaL_loadstring(L, "print \"Hello World.\"");
//   // dofile = luaL_dostring(L, "print \"Hello World.\"\0");
//   if (dofile == 0) {
//     lua_getglobal(L, "Kona_start");
//     lua_call(L,0,0);
//   } else {
//     printf("Unable to run kona.lua\n");
//   }
//
//   lua_close(L);
//
//   exit(64);
//   return 0;
// }
//

lua_State *L;
int main() {
  int dofile;
  L = lua_open();
  luaL_openlibs(L);

  printf("%s", sample_lua);

  // dofile = luaL_dofile(L, "kona.lua");
  // dofile = luaL_dostring(L, "require(\"interpreter\")");

  // dofile = luaL_dostring(L, "print(package.path)");

  if (dofile == 0) {
    // lua_call(L,0,0);
    lua_getglobal(L, "Kona_start");
    lua_call(L,0,0);
  } else {
    printf("Unable to run kona.lua, (%d)\n", dofile);
  }

  lua_close(L);

  exit(64);
  return 0;
}
