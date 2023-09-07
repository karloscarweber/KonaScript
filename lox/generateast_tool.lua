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

	file:write("-- lox\n")
	file:write("\n")
	file:write("--import nothing\n")
	file:write("\n")
	file:write(baseName .. " = {\n")

		for _, type in ipairs(types) do
			local className = (split(type, ":"))[1]
			className = trim(className)
			local fields = (split(type, ":"))[2]
			fields = trim(fields)
			defineType(file, baseName, className, fields)
		end

	file:write("end\n")
	file:write("\n\r")
	file:close()

end

function defineType(file, baseName, className, fieldList)
	file:write("		function " .. className .. " ()\n")

	-- Constructor
	file:write("			function " .. fieldList .. " ()\n")
	local fields = split(fieldList, ", ")
	for _, field in ipairs(fields) do
		local name = split(field, " ")[1]
		file:write("				this." .. name .. " = " .. name .. "\n")
	end

	file:write("			end\n")

	-- Fields
	file:write("\n")
	for _, field in ipairs(fields) do
		file:write("		final " .. field .. ";\n")
	end

	file:write("}\n")

end

function GenerateAst(directory)
	-- if not (tablelength(arg) == 1) then
	-- 	print("some errors")
	-- end

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
