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

-- local splitted = string.split(string._testdata.test_file, "add")
-- print(splitted)

-- get_delimter

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
    -- print("length?")
    -- print(tostring(#lines[line]))
    line = line + 1
    i = i + #lines[line];
    -- print("now i:")
    -- print(tostring(i))
  end

  return line
end

d = get_delimiter_indices(string._testdata.test_file, "task:add")
wl = which_line(string._testdata.test_file, d[1])
print(tostring(wl))
-- print(tostring(d))
-- s = string._testdata.test_file
