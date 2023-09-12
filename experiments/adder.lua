-- adder.lua

start = 0
do
  incrementer = function()
    start = start + 1
  end
  while start < 10 do
    incrementer()
    print(start)
  end
end
