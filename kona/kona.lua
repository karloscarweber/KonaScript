-- kona.lua

-- An attempt at writing a front end completely in Lua for the Kona scripting language thing.

Kona = {
  hadError=false,
  hadRuntimeError=false,
  exit=false,
  -- interpreter=Interpreter:new()
}

function Kona:main(...)
  -- print("Hello friends")
  args = {...}
  if (#args > 1) then
    print('Usage: jlox [script]')
  elseif #args == 1 then
    -- Kona:runFile(args[1])
  else
    Kona:runPrompt()
  end
end

function Kona:run(input)
  print("Trying to load a chunk")
  print(input)
  chunk = load(input)
  chunk()
end

-- Runs a command prompt that loops and accepts program input.
function Kona:runPrompt()
  io.write("start Kona Prompt:") -- io.write, writes that thing
  io.flush()
  repeat
    io.write("> ") -- io.write, writes that thing to the buffer
    io.flush() -- flushes the buffer
    input=io.read() -- reads the input, or recieves it on enter.
    print("reading the buffer")
    if not (input == "exit") then
      print(input)
      -- here we probably need to check for errors
      Kona:run(input)
      -- Kona.hadError = false
    end
    print("after input?")
  until input == "exit" or Kona.exit == true
end

Kona_start = function()
  Kona:main()
end

-- Kona_start()

-- return Kona, Kona_start
