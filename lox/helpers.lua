-- lox/helpers.lua
--
-- get's the table length of a table
--

require('lox/token_type')

function tablelength(the_table)
  local count = 0
  for _ in pairs(the_table) do count = count + 1 end
  return count
end

-- takes a string and splits it based on a delimter, defaulting to empty space
function split(inputstr, sep)
	local sep = sep
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	-- (%w+)%s*=%s*(%w+)
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

-- Trims white space from the beginning and end of a string.
function trim(str)
	local st = ""
	st = string.gsub(str, "^%s+", "")
	st = string.gsub(st, "%s+$", "")
	return st
end

-- A totally unnecessary object that let's us append strings in a nice little interface.
function StringBuilder()
	local t = {}
		t.buffer = ""
		t.append = function(str) t.buffer = t.buffer .. str end
		t.toString = function() return t.buffer end
	return t
end

-- add a has value function to table
-- returns true if the
function table.has_value (tab, val)
  for _, value in ipairs(tab) do
  	if value == val then
    	return true
  	end
  end

  return false
end

-- indent function
function string.indent(depth)
	local buff, ord = "", 0
if depth == nil then depth = 1 end
	while ord < depth do
		buff = buff .. " "
		ord = ord + 1
	end
	return buff
end

-- Dumps a table
function table.dump(tab, indent)
	local ind = tonumber(indent)
	if ind == nil then ind = 1 end
	local indie = string.indent(ind)
	for key, value in ipairs(tab) do
		if type(value) == 'table' then
			print(indie.."["..tostring(key).."] : "..tostring(value).." ("..tostring(#value)..")")
			table.dump(value, (ind+1))
		else
			print(indie.."["..tostring(key).."] : "..tostring(value))
		end
	end
end
