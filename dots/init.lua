-- init.lua

-- dots entry point
require 'lox/helpers/dir'
require 'lox/file_utility'
require 'lox/helpers'

Dots = {}

-- makes a new dots context thing.
-- used to start building a test sequence.
-- returns an object that references the Dots table as a
-- metatable. The returned object runs the tasks found in the tasks
--
-- @directory [String] A string representing the directory to search.
-- @prefix [String] A prefix for the files to grab for the tests,
--   defaults to 'test_'
--
-- Returns -> Dots[Object]
--    tasks [Array], an Array of tasks to execute
--    tasks [Array], an Array where new tests are added.
function Dots:new()
  t = {tasks = {}, results = {}, test_destination = {}}
  setmetatable(t, Dots)
  self.__index = self
  return t
end

-- Add a task to the Dots Namespace
-- A task is a collection of tests, Usually assembled by domain, that run
-- together in random order.
function Dots:add(task)
  self.tasks[#self.tasks + 1] = task
  return self -- return self to chain task adding.
end

-- Execute the tasks associated with a context
function Dots:execute()
  for _,task in ipairs(self.tasks) do
    if task.execute ~= nil and type(task.execute) == 'function' then
      print("Executing test")
      table.insert(self.results, task:execute())
    else
      print("something is not right")
    end
  end
  print("Executed tests")
  self:print_results()
end

function Dots:print_results()
  -- for _,v in ipairs(self.results) do
  -- end
  table.dump(self.results)
end

-- tests_in,
-- constructs a list of files with a prefix, that contain tests.
--
-- @directory [String] A string representing the directory to search,
--   defaults to 'test'
-- @prefix [String] A prefix for the files to grab for the tests,
--   defaults to 'test_'
--
-- @returns {Collection} A Collection(Array) of files to search for tests.
--
-- Usage:
--
-- ```lua
--   local test_files = Dots.tests_in('tests', 'tests_')
-- ```
Dots.tests_in = function(directory, prefix)
  local dir, pre = directory, prefix
  if dir == nil then dir = 'test' end
  if pre == nil then pre = 'test_' end
  return Dir.filter(dir, pre, nil)
end

-- You add tasks to a Dots instance, and then execute them.

-- Namespace for the Task object
Dots.Task = {}
Task = Dots.Task

-- Makes a new dots task
-- the task is used to run the code in a test_*.lua file, then records the
-- result and returns it to the core instance running lua.
-- the code is run in different Lua State so as not to pollute the test state.

-- used to start building a list of files to test.
function Task:new(name, filelist)
  local tusk = {
    name = name,
    tests = {}, -- a Dots.Task.Test objects goes here.
    -- a test has results:
    results = {} -- filled with the results of the tests.
  }
  setmetatable(tusk, Task)
  self.__index = self

  -- Set the task destination to the current task
  local old_test_destination = Dots.test_destination
  Dots.test_destination = tusk.tests

  -- scan filelist
  if type(filelist) == 'table' then
    for _,f in ipairs(filelist) do
      -- load the files safely, printing an error, and skipping a test,
      -- if there is an error.
      if File.exists(f) then
        local file = File.read(f)
        local succeeded, response = pcall( load(file) )

        if succeeded ~= true then
          print("Tests Failed to load. Found syntax errors: "..response)
        end
      else
        print("File doesn't exist for test: "..f)
      end
    end
  end

  -- move the tests over
  tusk.tests = Dots.test_destination

  -- Reset the task destination to the original destination
  Dots.test_destination = old_test_destination

  return tusk
end

-- Adds a new test in a test file to the Task bundle thing.
-- function Task:add(summary, funk)
--   print("Task being added")
--   local new_test = {
--     summary = summary,
--     funk = funk
--   }
--   self.tests[#self.tests + 1] = new_test
--   return self
-- end

function Task:execute()
  print("... executing test")
  for _,v in ipairs(self.tests) do

    print("trying to run a test:")
    print(v.name)
    -- execute the test
    local assertion_object = Dots.AssertionsObject:new()
    print("type of v.funk: "..type(v.funk))
    print("type of assertion_object: "..type(assertion_object))
    local ok, response = pcall( v.funk(assertion_object) )

    print("assertion_object")
    table.dump(assertion_object.results)

    -- probably have to look at the assertion_object for the test results when
    -- it doesn't error out.
    local result = {
      name = v.name,
      ok = ok,
      results = results,
    }
    -- store the result in the results thing.
    table.insert(self.results, result)
  end
  return self.results
end

-- Test namespace
-- Task.Test = {}

-- Create an assertion object
function Dots.Assertion(name, status, message)
  return {
    name = "",
    pass = status,
    message = message
  }
end

Assertion = Dots.Assertion
Dots.AssertionsObject = {}
function Dots.AssertionsObject:new()
  t = {results = {}}
  setmetatable(t, Dots.AssertionsObject)
  self.__index = self
  return t
end
  -- debug_data = function() end,
function Dots.AssertionsObject:_equal(value, control, message)
  local status = true
  if value ~= control then status = false end
  table.insert(self.results, Assertion("_equal_assertion", status, message))
  return nil
end
function Dots.AssertionsObject:_truthy(value, message)
  local status = true
  if not value then status = false end
  table.insert(self.results, Assertion("_truthy_assertion", status, message))
  return nil
end
function Dots.AssertionsObject:_false(value, message)
  local status = true
  if value then status = false end
  table.insert(self.results, Assertion("_false_assertion", status, message))
  return nil
end
function Dots.AssertionsObject:_match(value, control, message)
  local status = true
  if value ~= control then status = false end
  table.insert(self.results, Assertion("_match_assertion", status, message))
  return nil
end
function Dots.AssertionsObject:_shape(value, control, message)
  if type(value) ~= 'table' then
    -- return failure, value not table.
    table.insert(self.results, Assertion("_shape_assertion", false, message))
    return nil
  end

  local res = self:___recursiveShape(value, control)
  local status = true
  if #res > 0 then status = false end
  table.insert(self.results, Assertion("_shape_assertion", status, message))
  return nil
end
  -- only called by shape, checks a table to make sure that it matches, recursively.
  -- checking shape assumes that a table value is being checked, and that we
  -- only check the types and presence of keys and values.
  --
function Dots.AssertionsObject:___recursiveShape(value, control)
  local res = {}
  for k,v in ipairs(control) do
    if value[k] == nil then
      table.insert(res, "Missing key: " .. tostring(k))
    end
    local tv = type(value[k])
    if tv ~= v then
      table.insert(res, "Index: "..tostring(k).." is "..tv..", expected: "..v)
    end
    if v == 'table' then
      local rs = ___recursiveShape(value[k],control["___"..tostring(k)])
      if #rs > 0 then table.insert(res,rs) end
    end
  end
  return res
end


-- Utilities for the testing framework.
Dots._utilities = {

  -- You know what would be cool! is that with scan file
  -- we would find the tests, and report syntax errors in the tests file while
  -- still parsing the rest of the file. We just need a really light token grammer.
  -- basically we'll split the file based on common test declarations, then execute
  -- the code between these declarations.
  --
  -- example `task:add(` is starting token for the task, split there.
  -- other token splits can be `task:before(`, `task:after`, and `task:complete`.
  -- When an error is encountered when parsing a test then we'll report that before we
  -- run the tests.
  -- scan_file = function(filename)
    -- open the file and read the contents
    -- split the file based on whitespace and new lines
    -- find test function definitions in the style of:
    -- ```lua
    --    t.add_test("A test to add.", function()
    --      -- Code to execute.
    --    end)
    -- ```
    --
--     local lines = {}
--     for line in io.lines(filename) do
--       lines[#lines + 1] = line
--     end
--     local tests = {}
--
--     for i,l in ipairs(lines) do
--       print("line: ["..tostring(i).."] "..l)
--     end

  -- end,
}

-- Test prototype, found when scanning the test files.
Dots.Test = {}

-- creates a new Test object
--
-- Use this in your test files to create a new test then add it to the list of all tests.
function Dots.Test:new(name)
  -- Save this debug stuff for later.
  -- print("calling function of Dots.Test:new  ")
  -- print(debug.getinfo(2))
  -- make the new Test prototype
  t = {
    name = name, -- name of the test
    file = "", -- figure out how to get the filename from the caller
    error = nil -- A string is put here when it fails with an error code.
  }
  setmetatable(t, Dots.Test)
  self.__index = self
  return t
end

-- adds an actual assertion block to the test
function Dots.Test:add(test_name, funk)
  print("Adding test: ".. test_name)
  if funk == nil then print("funk was nil for that last test") end
  table.insert(Dots.test_destination, {name=test_name, funk=funk})
end

-- code run to setup the environment for a task
function Dots.Test:setup()
end

-- function to run code before you execute each test in a task.
function Dots.Test:before()
end

-- function to run code after each test in a task.
function Dots.Test:after()
end

-- Completes the task and adds the results to the parent list of results to await
-- output.
function Dots.Test:complete()
end

-- Dots.Task.
