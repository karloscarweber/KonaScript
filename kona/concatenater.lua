-- concatenater

-- embeds lua into c files and then drops that puppy into the build proccess
require 'ffi'

-- gets the length of a table
table.count = function(tab)
  local length = 0;
  for i in ipairs(tab) do
    length = length + 1
  end
  return length
end
local files = {}

-- Lua implementation of PHP scandir function
-- function scandir(directory)
--     local i, t, popen, cmd = 0, {}, io.popen, ""
--
--     if directory == nil then
--       cmd = 'ls -a '
--     else
--       cmd = 'ls -a "'..directory..'"'
--     end
--
--     local pfile = popen(cmd)
--     for filename in pfile:lines() do
--         i = i + 1
--         t[i] = filename
--     end
--     pfile:close()
--     return t
-- end

-- makes a c encoded string of a lua file.
function makestring(file)
  local name = string.gsub(file,"(%.)","_")
  local buffer = "const char* "..name.." = \"\\\n"

  -- build the buffer
  for line in io.lines(file) do
    buffer = buffer .. string.gsub(line,"\"","\\\"") .. " \\\n"
  end

  buffer = buffer.."\";"
  return name, buffer
end

function combine()

  local files = {'sample.lua', 'kona.lua'}
  local prepped_files = {}

  for i, file in ipairs(files) do
    local name, str = makestring(file)
    prepped_files[name] = str
  end

  for k,v in pairs(prepped_files) do
    print(k)
    -- print(v)
    local f = io.open(k..".h", "w")
    f:write(v)
    f:close()
  end

  -- print()
end

combine()
