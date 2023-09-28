-- main.lua
-- require('lox/scanner')

require('lox/Lox')

-- Starts up the Lox interpreter to get things rolling.
-- Lox:main()

local input
local scan
repeat
  io.write("> ") -- io.write, writes that thing to the buffer
  io.flush() -- flushes the buffer
  input=io.read() -- reads the input, or receives it on enter.
  scan = Scanner:new(input)
  scan:scanTokens()
  scan:spitTokens()
  -- load(input)
until input == "exit"

-- It's possible to write a REPL if you just do something wiht the input, and scann it, and lex it, then load the code, then execute the code. I think.


-- local pipe = io.popen(stdout)
-- repeat
--     local c = pipe:read(1)
--     if c == 'stop' then
--         -- Do something with the char received
--         io.write(c)  io.flush()
--     end
-- until not c
-- pipe:close()
