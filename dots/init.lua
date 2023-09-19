-- init.lua

-- dots entry point

require 'lox/helpers/dir'

Dots = {}

-- makes a new dots namespace thing.
-- used to start building a test sequence.
-- returns an object that references the Dots table as a
-- metatable. The returned object runs the tasks found in the tasks
--
-- @directory [String] A string representing the directory to search.
-- @prefix [String] A prefix for the files to grab for the tests,
--   defaults to 'test_'
Dots.new = function(directory, prefix)
  prfx = prefix
  if prefix == nil then
    -- we don't need a prefix then.
    local prfx = "test_"
  end

  local files = Dir.scandir(directory, '.lua')

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
  return Dir.scandir(dir, pre)
end

-- You add tasks to a Dots instance, and then execute them.

-- Namespace for the Task object
Dots.Task = {}

-- Makes a new dots task
-- the task is used to run the code in a test_*.lua file, then records the
-- result and returns it to the core instance running lua.
-- the code is run in different Lua State so as not to pollute the test state.

-- used to start building a list of files to test.
Dots.Task.new = function(filelist)
  local task = {
    tests = {}, -- a Dots.Task.Test object goes here.
    -- a test has:
    results = {} -- filled with the results of the tests.
  }
  setmetatable(task, Task)

  -- scan filelist
  if type(filelist) == 'table' then
    for _,f in filelist do
      -- scan file for tests
    end
  end

  return task
end

-- Adds a new test in a test file to the Task bundle thing.
Dots.Task.add = function(summary, funk) {
  local  new_test = {
    summary = summary,
    funk = funk
  }
  self.tests[#self.tests + 1] = new_test
  return self
}

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
  scan_file = function(filename)
    -- open the file and read the contents
    -- split the file based on whitespace and new lines
    -- find test function definitions in the style of:
    -- ```lua
    --    t.add_test("A test to add.", function()
    --      -- Code to execute.
    --    end)
    -- ```
    --
    local lines = {}
    for line in io.lines(filename) do
      lines[#lines + 1] = line
    end
    local tests = {}

    for i,l in ipairs(lines) do
      print("line: ["..tostring(i).."] "..l)
    end

  end,
}

-- Test prototype, found when scanning the test files.
Dots.Task.Test = {
  name = "",
  file = "",
  line = "",
  error = nil -- A string is put here when it fails with an error code.
}

-- code run to setup the environment for a task
Dots.Task.setup = {}

-- function to run code before you execute each test in a task.
Dots.Task.before = {}

-- function to run code after each test in a task.
Dots.Task.after = {}

-- Completes the task and adds the results to the parent list of results to await
-- output.
Dots.Task.complete = {}

Dots.Task.
