-- test_file.lua
require 'dots' -- Require the testing framework

require 'my_other_code' -- require your other code to test

-- A Sample Test file.
local task = Dots.Task.new("Test Framework")

-- Test the testing framework
task:add("Add a test to a test framework.", function(r)
  local falsey = true
  local str = "string"
  local thing = 5
  r._equal(thing,5,"5 and 5 are not equal")
  r._truthy(true,"This is not Truthy")
  r._false(falsey,"This is not false!")
end)
