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
      table.insert(self.results, task:execute())
    else
      print("Error, Tasks found can't be executed. No Execute Command.")
    end
  end
  -- print("Executed tests")
  self:print_results()
end

function Dots:print_results()
  local test_string, error_list, test_count = "Testing: ", {}, 0


  -- table.dump(self.results)

  -- Iterate over the Tests
  for _,r in ipairs(self.results) do
    for _,d in ipairs(r) do
      -- Go through the results in the tests now.
      for k,t in ipairs(d.results) do
        test_count = test_count + 1
        if t.pass == true then
          test_string = test_string.."."
        else
          test_string = test_string.."x"
          local errors_string = ""
          if t.errors ~= nil and type(t.errors) == 'table' then
            for k,v in ipairs(t.errors) do
              errors_string = "    "..errors_string .. v .. "\n"
            end
          end

          table.insert(error_list, "Test Failed in: "..d.name.."\n".."["..t.name.."] "
          ..t.message.."\n"..errors_string)
        end
      end
    end
  end

  test_string = test_string .. "\n"

  -- Now that we have our results, print them.
  print("________________________________________________________________________________")
  print(test_string)
  print(test_count.." Assertions, "..tostring(#error_list).." Failures.\n")

  if #error_list < 1 then
    print("No errors.")
  else
    print("Errors!")
    for _,v in ipairs(error_list) do
      print(v)
    end
  end

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
    tests = {},
    results = {},
  }
  setmetatable(tusk, Task)
  self.__index = self


  -- scan filelist
  if type(filelist) == 'table' then
    for _,f in ipairs(filelist) do
      -- load the files safely, printing an error, and skipping a test,
      -- if there is an error.
      if File.exists(f) then

        -- Move tests stuff around
        local old_test_destination = Dots.test_destination
        Dots.test_destination = tusk.tests

        local file = File.read(f)
        local succeeded, response = pcall( load(file) )

        -- move the tests over
        tusk.tests = Dots.test_destination
        -- Reset the task destination to the original destination
        Dots.test_destination = old_test_destination

        if succeeded ~= true then
          print("Tests Failed to load. Found syntax errors: ["..response.."]")
        end
      else
        print("File doesn't exist for test: "..f)
      end
    end
  end

  return tusk
end

function Task:execute()
  for _,v in ipairs(self.tests) do
    -- execute the test
    local assertion_object = Dots.AssertionsObject:new()
    local ok, response = pcall( v.funk(assertion_object) )

    -- probably have to look at the assertion_object for the test results when
    -- it doesn't error out.
    local result = {
      name = v.name,
      results = assertion_object.results,
    }
    -- store the result in the results thing.
    table.insert(self.results, result)
  end
  return self.results
end

-- Create an assertion object
-- errors is optional, when it's not, it's an Array of Error Messages.
function Dots.Assertion(name, status, message, errors)
  if message == nil then message = "" end
  return {
    name = name,
    pass = status,
    message = message,
    errors = errors
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
-- _shape tests the types of keys and not their values.
function Dots.AssertionsObject:_shape(value, control, message)
  if type(value) ~= 'table' then
    -- return failure, value not table.
    table.insert(self.results, Assertion("_shape_assertion", false, message))
    return nil
  end

  local res = self:___recursiveShape(value, control)
  local status = true
  if #res > 0 then status = false end
  table.insert(self.results, Assertion("_shape_assertion", status, message, res))
  return nil
end

-- only called by shape, checks a table to make sure that it matches, recursively.
-- checking shape assumes that a table value is being checked, and that we
-- only check the types and presence of keys and values.
function Dots.AssertionsObject:___recursiveShape(value, control)
  local res = {}
  for k,v in pairs(control) do
    if value[k] == nil then
      table.insert(res, "Missing key: " .. tostring(k))
    end
    local tv = type(value[k])
    if tv ~= v and type(v) ~= 'table' then
      table.insert(res, "Index ["..tostring(k).."] is type("..tv..") expected: type("..type(v)..")")
    end
    if type(v) == 'table' then
      local rs = self:___recursiveShape(value[k],control[k])
      if #rs > 0 then table.insert(res, rs) end
    end
  end
  return res
end

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
    error = nil, -- A string is put here when it fails with an error code.
    tests = {}
  }
  setmetatable(t, Dots.Test)
  self.__index = self
  return t
end

-- adds an actual assertion block to the test
function Dots.Test:add(test_name, funk)
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
