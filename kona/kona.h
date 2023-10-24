// kona.h
// Headers for the Kona runtime VM thing
//
// KonaScript
// Kona is a programming language written in Lua and C running on the LuaJit VM.
//

#define KONA_VERSION   "KonaScript 0.0.1"
#define KONA_COPYRIGHT "Copyright (C) 2023 Karl Oscar Weber"
#define KONA_URL       "https://konascript.org"
#define KONA_COPYMORE  "Kona is built on LuaJIT by Mike Pall"


// probably move this to the VM thing.
typedef enum {
  INTERPRET_OK,
  INTERPRET_COMPILE_ERROR,
  INTERPRET_RUNTIME_ERROR
} InterpretResult;
