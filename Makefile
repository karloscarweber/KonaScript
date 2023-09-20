default:
	lua main.lua

test:
	lua -i lox/test.lua

generate:
	lua lox/generateast_tool.lua

printer:
	lua lox/AstPrinter.lua
