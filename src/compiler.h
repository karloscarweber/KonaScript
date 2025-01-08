#ifndef kona_compiler_h
#define kona_compiler_h

#include "object.h"

ObjFunction* compile(const char* source);
void markCompilerRoots();

#endif
