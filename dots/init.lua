-- init.lua

-- dots entry point
require 'lox/helpers/dir'
require 'lox/file_utility'

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
  local results = {}
  for _,task in ipairs(self.tasks) do
    if task.execute ~= nil and type(task.execute) == 'function' then
      local r = task.execute()
      table.insert(results, r)
    end
  end
  table.insert(self.results, results)
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

  -- Set the task destination to the current task
  local old_test_destination = Dots.test_destination
  Dots.test_destination = tusk

  -- scan filelist
  if type(filelist) == 'table' then
    for _,f in ipairs(filelist) do
      -- load the files safely, printing an error, and skipping a test,
      -- if there is an error.
      if File.exists(f) then
        local file = File.read(f)
        local succeeded, response = pcall( load(file) )

        if succeeded ~= true then
          -- Damn it failed
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
function Task:add(summary, funk)
  local  new_test = {
    summary = summary,
    funk = funk
  }
  self.tests[#self.tests + 1] = new_test
  return self
end

function Task:execute()
  -- sequential
  for _,v in ipairs(tests) do
    -- execute the test
    local ok, response = pcall( v.funk() )
    local result = {
      test_name = v.summary,
      ok = ok,
      response = response
    }
    -- store the result in the results thing.
    table.insert(self.results, result)
  end
end

Task.Test = {}

-- Create an assertion object
function Task.Test.Assertion(name, status, message)
  local result = {
    name = "",
    pass = status,
    message = message,
    results = {}
  }
  return result
end

Assertion = Task.Test.Assertion

Dots.AssertionsObject = {
  new = function()
    t = {results = {}}
    setmetatable(t, Dots.AssertionsObject)
    return t
  end,
  debug_data = function() end,
  _equal = function(value, control, message)
    local status = true
    if value ~= control then status = false end
    return Assertion("_match_assertion", status, message)
  end,
  _truthy = function(value, message)
    local status = true
    if not value then status = false end
    return Assertion("_false_assertion", status, message)
  end,
  _false = function(value, message)
    local status = true
    if value then status = false end
    return Assertion("_false_assertion", status, message)
  end,
  _match = function(value, control, message)
    local status = true
    if value ~= control then status = false end
    return Assertion("_match_assertion", status, message)
  end,
  _shape = function(value, control, message)
    if type(value) ~= 'table' then
      -- return failure, value not table.
      return Assertion("_shape_assertion",false, message)
    end

    local res = self:___recursiveShape(value, control)
    local status = true
    if #res > 0 then status = false end
    return Assertion("_shape_assertion",status, message)
  end,
  -- only called by shape, checks a table to make sure that it matches, recursively.
  -- checking shape assumes that a table value is being checked, and that we
  -- only check the types and presence of keys and values.
  --
  ___recursiveShape = function(value, control)
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
}

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
Dots.Test = {
  name = "",
  file = "",
  line = "",
  error = nil -- A string is put here when it fails with an error code.
}

-- creates a new Test object
--
-- Use this in your test files to create a new test then add it to the list of all tests.
function Dots.Test:new()
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
