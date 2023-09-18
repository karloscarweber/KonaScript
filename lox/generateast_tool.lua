-- We're doing this in Lua of course because we live life on Hard Mode
--
-- This file is meant to gnerate other files for us. Specifically Abstract syntax tree Classes.
--

require 'lox/helpers'

function tablelength(the_table)
  local count = 0
  for _ in pairs(the_table) do count = count + 1 end
  return count
end

function defineAst(directory, baseName, types)
	local path = directory .. "/" .. baseName .. ".lua"
	local file = io.open(path, "w")

	file:write("-- lox/types/Expr.lua\n")
	file:write("\n")
	file:write(baseName .. " = {\n")

		-- defineVisitor(file, baseName, types)

		for _, type in ipairs(types) do
			local className = trim((split(type, ":"))[1])
			local fields = (split(type, ":"))[2]
			fields = trim(fields)
			defineType(file, baseName, className, fields)
		end

		-- file:write("\n")
		-- file:write("	abstract <R> R accept(Visitor<R> visitor);")

	file:write("}")
	file:write("\n")
	file:close()

end

-- Defines a type.
function defineType(file, baseName, className, fieldList)
	file:write("	[\"" .. className .. "\"]" .. " = function ")

	-- Constructor
	-- local fields = split(fieldList, ", ")
	local buffer = "("

	-- Store parameters in fields.
	for key, value in string.gmatch(fieldList, "(%w+)%s*(%w+)") do
		-- print("key: " .. key .. ", value: " .. value)
		buffer = buffer .. value .. ","
	end
	buffer = buffer .. "nilme)\n"
	buffer = string.gsub(buffer, ",nilme", "")

	-- Build prototype
	buffer = buffer .. "		" .. "local t = {}\n"
	buffer = buffer .. "		" .. "t.__typeName = " .. "\"" .. className .. "\"\n"
	-- Fields to their keys
	for key, value in string.gmatch(fieldList, "(%w+)%s*(%w+)") do
		buffer = buffer .. "		t." .. value .. " = " .. value .. "\n"
	end

	-- accept visitor pattern stuff.
	buffer = buffer .. "		t.accept = function(visitor)\n"
	buffer = buffer .. "			return visitor.visit" .. className .. baseName .. "(t)\n"
	buffer = buffer .. "		end\n"

	-- Close out the prototype definition.
	buffer = buffer .. "		return t\n"
	file:write(buffer)

	-- Close the type
	file:write("	end,\n")
	file:write("\n")
end

function defineVisitor(writer, baseName, types)
	writer:write("	interface Visitor<R> {")

	for _, type in ipairs(types) do
		local typeName = trim(split(type, ":")[1])
		writer:write("		R visit" .. typeName .. baseName .. "(" .. typeName .. " " .. string.lower(baseName) .. ")\n")
	end

	writer:write("	}")
end

function GenerateAst(directory)
	local outputDir = directory
	defineAst(outputDir, "Expr", {
		"Binary   : Expr left, Token operator, Expr right",
		"Grouping : Expr expression",
		"Literal  : Object value",
		"Unary    : Token operator, Expr right",
		"Variable : Token name"
	})

	defineAst(outputDir, "Stmt", {
		"Expression : Expr expression",
		"Print      : Expr expression",
		"Var        : Token name, Expr initializer"
	})

end

GenerateAst("./lox/types")
