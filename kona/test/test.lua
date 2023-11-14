-- lox/test.lua

-- patch the package loading paths to get our libs.
package.path = "./?/init.lua;"..package.path
require 'dots'

-- Setup Testing Context
context = Dots:new()

tasky = Dots.Task:new("Basic Test", Dots.tests_in('kona/test'))
context:add(tasky)
context:execute()

-- parse each one in order, logging syntax errors.
-- Add green dots for successful tests.
-- print the logged errors at the end.
