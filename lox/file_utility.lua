-- A rough file utility to see if we can get filess
--

-- check to see if a file exists, returns nil if it doesn't
function file_exists(file)
	local f = io.open(file, "rb")
	if f then f:close() end
	return f ~= nil
end

-- get's the lines from file and drops them in a table.
function lines_from(file)
	if not file_exists(file) then return {} end
	local lines = {}
	for line in io.lines(file) do
		lines[#lines + 1] = line
	end
	return lines
end

-- reads the whole file and returns the result. great for getting stuff for our interpreter.
function read_whole_file(file)
	local thing = io.open(file, "rb")
	local result = thing:read("a")
	return result
end

-- takes the table returned in lines_from and prints them.
function print_lines_from(lines)
	for k,v in pairs(lines) do
		print('line[' .. k .. ']', v)
	end
end

-- Create File namespace
File = {
	file_exists = file_exists,
	lines_from = lines_from,
	read_whole_file = read_whole_file,
	print_lines_from = print_lines_from,
}

-- test it:
-- local file = 'main.lua'
-- local lines = lines_from(file)

-- for k,v in pairs(lines) do
-- 	print('line[' .. k .. ']', v)
-- end
