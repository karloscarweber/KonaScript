// kona_vm.h
#ifndef kona_vm_h
#define kona_vm_h


// include these when we write them.
// #include "object.h"
// #include "table.h"
// #include "value.h"


// We're going to set up some max frame sizes and stack maxes.
// This means we can't nest too deeply right now. At least not yet.
#define FRAMES_MAX 64
#define STACK_MAX (FRAMES_MAX * UINT8_COUNT)

// CallFrame struct
// An Object that contains a closure, an instruction pointer, and the number 
// of Slots the CallFrame has. Slots are usually locals. In the case of a
// function, that's passed arguments.
// we're storing this in a Value so that we can use an object for these slots
// instead sometimes. We're clever. But Value in the Kona VM is also a floating
// point number.
typedef struct {
	ObjClosure* closure;
	uint8_t* ip;
	Value* slots;
} CallFrame;

// VM struct
// the object that manages the state of the Kona VM, is the VM. Surprising.
// It keeps track of everything in the VM. Values, Objects, Functions, etc...
// It also manages state for the Garbage collector.
typedef struct {
	CallFrame frames[FRAMES_MAX]; // holds the frames
	int frameCount; // holds the current frame count
	Value stack[STACK_MAX]; // Can't remember what this does.
	Value* stackTop; // A pointer to the top of the stack
	Table globals; // A table of globals. These are top level Objects
	Table strings; // Table of strings. In Kona Strings are "Interned".
	Table symbols; // Table of symbols.
	ObjString* initString; // This is the string "init". We save it here so that
	// we don't have to make it and dump it everywhere. We check function names
	// against this string to see if it's an initializer.
	ObjUpvalue* openUpvalues; // used by the garbage collector to find unused
	// upvalues ready to head to the dump.
	
	size_t bytesAllocated; // tracks how much memory our VM is using.
	size_t nextGC; // A size that tracks when our next garbage collection pass
	// will take place.
	Obj* objects; // all objects that are gonna be garbage are stored here.
	int grayCount; // number of gray objects
	int grayCapacity; // gray capacity. This is simple
	Obj** grayStack; // This is a pointer pointer to an Obj, pointer. Dark magic.
} VM;

// InterpretResult enum
// gives us a class of errors.
typedef enum {
	INTERPRET_OK,
	INTERPRET_COMPILE_ERROR,
	INTERPRET_RUNTIME_ERROR
} InterpretResult;

// sets a variable named vm of the type VM to be external. That means it can be
// accessed by other files in our program. It makes it Global in this context.
extern VM vm;

// initVM() -> Void
// starts the virtual machine by allocating memory for it and setting default
// values. 
void initVM();

// freeVM -> void
// frees a VM from memory. Kona only supports a single VM at the moment, so it
// closes old yeller out and kills it.
void freeVM();

// interpret(const char* source)
// The interpret function accepts a char* named source, which is a pointer to a
// region of memory where we have string of characters. In this case that string
// is our source code.
// Returns InterpretResult, defined above, which could be OK, or a couple of
// errors.
InterpretResult interpret(const char* source);

// push(Value value);
// pushes a value onto the stack. Kona is a stack based virtual Machine, so
// values are pushed and popped. Unsurprisingly it accepts a Value.
void push(Value value);

// pop() -> Value
// Pops a value off the stack, and returns it.
Value pop();

#endif
