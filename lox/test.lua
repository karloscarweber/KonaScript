-- lox/test.lua
require 'dots'

-- Setup Testing Context
context = Dots:new()

tasky = Dots.Task:new("Basic Test", Dots.tests_in('lox/test'))
context:add(tasky)

context:execute()

-- parse each one in order, logging syntax errors.

-- Add green dots for successful tests.

-- print the logged errors at the end.


-- Run Tests
-- tests = {}
-- Test = {}
-- function Test:new(summary, funk)
--   local t = {
--     summary = summary,
--     funk = funk,
--   }
--   return t
-- end
