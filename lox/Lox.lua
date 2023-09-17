-- lox/Lox.lua
-- create the Lox namespace
--

require 'lox/interpreter'
require 'lox/scanner'
require 'lox/file_utility'

Lox = {
	hadError=false,
	hadRuntimeError=false,
	exit=false,
	interpreter=Interpreter:new()
}

function Lox:main(...)
	args = {...}
	if (#args > 1) then
		print('Usage: jlox [script]')
	elseif #args == 1 then
		Lox:runFile(args[1])
	else
		Lox:runPrompt()
	end
end

-- runs the file found at file path, and returns the files string, ready for parsing.
-- Otherwise returns nil
function Lox:runFile(file_path)
	if file_exists(file_path) then
		local file = io.open(file_path, "rb")
		local lox_string = file:read("a")
		Lox.run(lox_string)

		if Lox.hadError then
			Lox.exit = true
		end

		if Lox.hadRuntimeError then
			Lox.exit = true
		end

		return lox_string
	else
		-- maybe spit out a failure
		return nil
	end
end

-- Runs a comand prompt that loops and accepts program input.
function Lox:runPrompt()
	io.write("start Lox Prompt:\n\n") -- io.write, writes that thing
	io.flush()
	repeat
	  io.write("> ") -- io.write, writes that thing to the buffer
	  io.flush() -- flushes the buffer
	  input=io.read() -- reads the input, or recieves it on enter.
		if input ~= "exit" then
			load(input)
			Lox.run(input)
			Lox.hadError = false
		end
	until input == "exit" or Lox.exit == true
end

function Lox.run(source)
	local scanner = Scanner:new(source)
	tokens = scanner:scanTokens()
	local parser = Parser:new(tokens)
	local expression = parser:parse()

	if Lox.hadError then return end

	lox.interpreter.interpret(expression)

	-- print(AstPrinter().print(expression))

	-- for _, token in ipairs(tokens) do
	-- 	io.write(token.toString .. "\n")
	-- end
end

function Lox.error(line, message)
	report(line, "", message)
end

function Lox.runtimeError(error)
	print(error.getMessage() .. "\n[line " .. error.token.line .. "]")
	Lox.hadRuntimeError = true
end

function report(line, where, message)
	print("[line " .. line .. "] Error" + where ": " .. message)
	Lox.hadError = true
end

function Lox.token_error(token, message)
	if token.type == TokenType.EOF then
		report(token.line, " at end", message)
	else
		report(token.line, " at '" .. token.lexeme .. "'", message)
	end
end

-- Starts up the Lox interpreter to get things rolling.
Lox:main()
