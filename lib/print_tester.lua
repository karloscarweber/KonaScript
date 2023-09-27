-- lib/print_tester.lua

local print_tester = {}


print_tester.printf = function(s,...)
  return io.write(s:format(...))
end

print_tester.tryit = function()
  local values = {".",".",".",".",".",".",".",".",}
  for _,k in ipairs(values) do
    io.write(k)
  end
  io.write('\n')
end

return print_tester
