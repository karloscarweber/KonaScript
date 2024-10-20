.PHONY: kona

# You may get a build error without `export MACOSX_DEPLOYMENT_TARGET=14.06`
# if so, export that shit.
#default:
#	cd clox
#	clang -o clox/main clox/main.c clox/chunk.c clox/memory.c clox/debug.c clox/value.c clox/vm.c clox/compiler.c clox/scanner.c clox/object.c clox/table.c
#	./clox/main

default:
	@ $(MAKE) -f util/c.make NAME=clox MODE=release SOURCE_DIR=c
	@ cp build/clox clox 

#	cd clox
#	clang -o clox/main clox/main.c clox/chunk.c clox/memory.c clox/debug.c clox/value.c clox/vm.c clox/compiler.c clox/scanner.c clox/object.c clox/table.c

olddefault:
	lua main.lua

test:
	luajit lox/test.lua

generate:
	lua lox/generateast_tool.lua

printer:
	lua lox/AstPrinter.lua

##
##
##
# Get Kona bootstrapped
prebuild:
	cd LuaJIT; make;

concat:
	cd kona; luajit concatenater.lua

# Test Kona's Lua code.
konatest:
	luajit kona/test/test.lua

# Build and run Kona.
kona:
	cd kona; luajit concatenater.lua
	clang -o kona/kona kona/kona.c LuaJit/src/libluajit.so
	./kona/kona

konaclean:
	rm kona/kona;
