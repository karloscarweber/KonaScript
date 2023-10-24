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

-- splits a string based on a separator
function mysplit (inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

str = {}
-- normalizes the filenames from sample.lua, to sample_lua
str.nrmlz_filename = function(name)
  return string.gsub(name,"(%.)","_")
end
-- strips comments from a lua string
str.strip_comments = function(str)
  local m, d;
  m, d = string.find(str, "--", 1, true)
  if m ~= nil then
    if m > 1 then
      return string.sub(str,1,m-1)
    end
  else
    return str
  end
  return ""
end
-- escapes the quote characters in the string
str.esc_str = function(str)
  return string.gsub(str,"\"","\\\"")
end

-- makes a c encoded string of a lua file.
function makestring(file)
  local name = str.nrmlz_filename(file)
  local buffer = "const char* " .. name .. " = \n"

  -- build the buffer
  for line in io.lines(file) do
    buffer = buffer.."\""..str.esc_str(str.strip_comments(line))
    buffer = buffer.." \""
    buffer = buffer.."\n"
  end

  buffer = buffer..";"
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
    local f = io.open(k..".h", "w")
    f:write(v)
    f:close()
  end

end

combine()
