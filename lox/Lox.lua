-- lox/Lox.lua
-- create the Lox namespace
--

require 'lox/scanner'
require 'lox/file_utility'

Lox = {}

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
		return lox_string
	else
		-- maybe spit out a failure
		return nil
	end
end

function Lox:runPrompt()
	io.write("start Lox Prompt:\n\n") -- io.write, writes that thing
	io.flush() -- flushes the buffer
	repeat
	  io.write("> ") -- io.write, writes that thing to the buffer
	  io.flush() -- flushes the buffer
	  input=io.read() -- reads the input, or recieves it on enter.
		print("input")
		print(input)
		Lox.run(input)
	  -- scan = Scanner:new(input)
	  -- scan:scanTokens()
	  -- scan:spitTokens()
	  if input ~= "exit" then load(input) end
	  -- print("")
	until input == "exit"
end

function Lox.run(source)
	local scanner = Scanner:new(source)
	tokens = scanner:scanTokens()

	for _, token in ipairs(tokens) do
		io.write(token.toString .. "\n")
	end

end

function Lox.error(token, message)
	if token.type == TokenType.EOF then
		report(token.line, " at end", message)
	else
		report(token.line, " at '" .. token.lexeme .. "'", message)
	end
end

-- Starts up the Lox interpreter to get things rolling.
Lox:main()
