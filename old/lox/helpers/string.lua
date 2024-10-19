-- lox/helpers/string.lua

-- string extensions

-- checks to see if a string ends with another string
-- doesn't coerce the string.
string.endswith = function(str, suffix)
  if suffix ~= nil then
    if string.sub(str, -(#suffix)) == suffix then
      return true
    end
  end
  -- suffix is nil so everything is false
  -- or, substring check didn't return true
  return false
end

string.beginswith = function(str, prefix)
  if prefix ~= nil then
    if string.sub(str, 1, #prefix) == prefix then
      return true
    end
  end
  return false
end

-- splits a string
string.split = function(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end

  local t= {}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

-- test string splitter
string._testdata = {}
string._testdata.test_file = [[
  -- Test the testing framework
  task:add("Add a test to a test framework.", function(r)
    local falsey = true
    local str = "string"
    local thing = 5
    r._equal(thing,5,"5 and 5 are not equal")
    r._truthy(true,"This is not Truthy")
    r._false(falsey,"This is not false!")
  end)

  -- Test the testing framework
  task:add("Add a test to a test framework.", function(r)
    local falsey = true
    local str = "string"
    local thing = 5
    r._equal(thing,5,"5 and 5 are not equal")
    r._truthy(true,"This is not Truthy")
    r._false(falsey,"This is not false!")
  end)
]]

-- string extensions to check if a string is AlphaNumeric
string.isAlpha = function(c)
  return (c >= 'a' and c <= 'z') or
         (c >= 'A' and c <= 'Z') or
          c == '_';
end

string.isDigit = function(c)
  return c >= '0' and c <= '9'
end

string.isAlphaNumeric = function(c)
  return string.isAlpha(c) or string.isDigit(c)
end

string.each = function(str, func)
  for i=1, #str do
  local c = str:sub(i,i)
    func(c)
  end
end

-- check for a valid filename
string.isValidFilename = function(c)
  local valid = true
  string.each(c, function(cc)
    if not( (cc >= 'a' and cc <= 'z') or (cc >= 'A' and cc <= 'Z') or cc == '_' or cc == '.' ) then
      valid = false
    end
  end)
  return valid
end

-- get_delimter
-- an iterator that returns a multiline string, line by line
-- Usage
-- ```lua
--   local lines = {}
--   for line in magiclines(str) do
--     lines[#lines + 1] = line
--   end
-- ```
function magiclines(s)
  if s:sub(-1)~="\n" then s=s.."\n" end
  return s:gmatch("(.-)\n")
end

get_delimiter_indices = function(str, sep)
  local i, t = 0, {}
  while true do
    i = string.find(str, sep, i+1)
    if i == nil then break end
    table.insert(t, i)
  end
  return t
end

-- gets the line of an index from a string
which_line = function(str,index)
  local lines, i, line = {}, 1, 0

  -- start by storing each line, line by line
  for line in magiclines(str) do
    lines[#lines + 1] = line
  end

  while i < index do
    line = line + 1
    i = i + #lines[line];
  end

  return line
end

-- d = get_delimiter_indices(string._testdata.test_file, "task:add")
-- wl = which_line(string._testdata.test_file, d[1])
-- print(tostring(wl))
-- print(tostring(d))
-- s = string._testdata.test_file
