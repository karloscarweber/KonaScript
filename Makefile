default:
	cd clox
	clang -o clox/main clox/main.c clox/chunk.c clox/memory.c clox/debug.c clox/value.c clox/vm.c clox/compiler.c clox/scanner.c
	./clox/main

olddefault:
	lua main.lua

test:
	lua lox/test.lua

generate:
	lua lox/generateast_tool.lua

printer:
	lua lox/AstPrinter.lua
