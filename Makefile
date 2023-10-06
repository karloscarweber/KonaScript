default:
	cd clox
	clang -o clox/main clox/main.c clox/chunk.c clox/memory.c clox/debug.c
	./clox/main

olddefault:
	lua main.lua

test:
	lua lox/test.lua

generate:
	lua lox/generateast_tool.lua

printer:
	lua lox/AstPrinter.lua
