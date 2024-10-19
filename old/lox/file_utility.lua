-- A rough file utility to see if we can get filess
--


-- Create File namespace
File = {}

-- check to see if a file exists, returns nil if it doesn't
-- returns true if it exists, false if it doesn't.
-- Also Aliased to File.exists
function File.file_exists(file)
	local f = io.open(file, "rb")
	if f then f:close() end
	return f ~= nil
end

-- get's the lines from file and drops them in a table.
function File.lines(file)
	if not file_exists(file) then return {} end
	local lns = {}
	for line in io.lns(file) do
		lns[#lns + 1] = line
	end
	-- Add the convenience printing method
	lns.print = File.print_lines_from
	return lns
end

-- reads the whole file and returns the result. great for getting stuff for our interpreter.
function File.read(file)
	local f = io.open(file, "rb")
	local result = f:read("*a")
	f:close()
	return result
end

-- takes the table returned in lines_from and prints them.
function File.print_lines_from(lines)
	for k,v in pairs(lines) do
		print('line[' .. k .. ']', v)
	end
end

File.exists = File.file_exists
File.print_lines_from = File.lines

-- test it:
-- local file = 'main.lua'
-- local lines = lines(file)

-- for k,v in pairs(lines) do
-- 	print('line[' .. k .. ']', v)
-- end
