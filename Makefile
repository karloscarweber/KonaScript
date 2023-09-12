default:
	lua main.lua

generate:
	lua lox/generateast_tool.lua

printer:
	lua lox/AstPrinter.lua
