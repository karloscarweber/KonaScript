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

		for _, type in ipairs(types) do
			local className = trim((split(type, ":"))[1])
			local fields = (split(type, ":"))[2]
			fields = trim(fields)
			defineType(file, baseName, className, fields)
		end

	file:write("}")
	file:write("\n")
	file:close()

end

function defineType(file, baseName, className, fieldList)
	file:write("	[\"" .. className .. "\"]" .. " = function ")

	-- Constructor
	local fields = split(fieldList, ", ")

	local buffer = "("

	for key, value in string.gmatch(fieldList, "(%w+)%s*(%w+)") do
		print("key: " .. key .. ", value: " .. value)
		buffer = buffer .. value .. ","
	end
	buffer = buffer .. "nilme)\n"
	buffer = string.gsub(buffer, ",nilme", "")

	buffer = buffer .. "		" .. "local t = {}\n"
	for key, value in string.gmatch(fieldList, "(%w+)%s*(%w+)") do
		buffer = buffer .. "		t." .. value .. " = " .. value .. "\n"
	end
	buffer = buffer .. "		return t\n"

	file:write(buffer)

	file:write("	end,\n")
	-- Fields
	file:write("\n")
end

function GenerateAst(directory)
	local outputDir = directory
	local list = {
		"Binary   : Expr left, Token operator, Expr right",
		"Grouping : Expr expression",
		"Literal  : Object value",
		"Unary    : Token operator, Expr right",
	}
	defineAst(outputDir, "Expr", list)
end

GenerateAst("./lox/types")
