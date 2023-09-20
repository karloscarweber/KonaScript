-- lox/test.lua
require 'lox/helpers/dir'
require 'dots'

-- Setup Testing Context
local context = Dots:new()

context:add(Dots.Task:new())

-- test file for all of lox lua

-- Begin test helper

  -- grab all files from test directory
  -- function scandir(directory)
  --   local i, t, popen = 0, {}, io.popen
  --   local pfile = popen('ls -a "'..directory..'"')
  --   for filename in pfile:lines() do
  --     i = i + 1
  --     t[i] = filename
  --   end
  --   pfile:close()
  --   return t
  -- end

-- parse each on in order, logging syntax errors.

-- Add green dots for successful tests.

-- print the logged errors at the end.

print("Running tests")

-- Run Tests
tests = {}
Test = {}
function Test:new(summary, funk)
  local t = {
    summary = summary,
    funk = funk,
  }
  return t
end
