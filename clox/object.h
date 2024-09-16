#ifndef clox_object_h
#define clox_object_h

#include "common.h"
#include "value.h"

#define OBJ_TYPE(value)      (AS_OBJ(value)->type)

typedef enum {
	OBJ_STRING,
} ObjType;

struct Obj {
	ObjType type;
};

struct ObjString {
	Obj obj;
	int length;
	char* chars;
};

#endif
