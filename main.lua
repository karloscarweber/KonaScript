-- main.lua
require('scanner')
require('token')

local input
repeat
  io.write("> ") -- io.write, writes that thing to the buffer
  io.flush() -- flushes the buffer
  input=io.read() -- reads the input, or recieves it on enter.
  load(input)
until input == "exit"

-- It's possible to write a REPL if you just do something wiht the input, and scann it, and lex it, then load the code, then execute the code. I think.
