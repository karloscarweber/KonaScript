-- lox/test/test_environment.lua

-- Test the scanner
require 'dots' -- Require the testing framework
require 'lox/environment'
require 'lox/token'

local environment_test = Dots.Test:new("environment")

-- Test the initialization of a test environment
environment_test:add("[test_environment] Environment:new()", function(r)
  local env = Environment:new()
  local env2 = Environment:new()
  r:_truthy(env, "Environment is not initialized")
  r:_truthy(env2, "Environment is not initialized")
  return r
end)

-- Test the shape of a new environment
environment_test:add("[test_environment] Environment:new()", function(r)
  local env = Environment:new()
  r:_shape(env, {values={}}, "Environment object doesn't have what we're expecting in it's shape.")
  return r
end)

-- Test the definition and retrieval of variables.
environment_test:add("[test_environment] Environment:define(), Environment:get()", function(r)
  local env = Environment:new()

  env:define("name", "Kathryn")
  env:define("rank", "Captain")
  env:define("assignment", "Voyager")

  local name_token = Token(IDENTIFIER, "name", "name", 0)
  local rank_token = Token(IDENTIFIER, "rank", "rank", 0)
  local assi_token = Token(IDENTIFIER, "assignment", "assignment", 0)

  r:_truthy(env:get(name_token), "name assignment failed.")
  r:_truthy(env:get(rank_token), "rank assignment failed.")
  r:_truthy(env:get(assi_token), "assignment assignment failed.")

  r:_match(env:get(name_token), "Kathryn", "Appropriate value not retrieved.")
  r:_match(env:get(rank_token), "Captain", "Appropriate value not retrieved.")
  r:_match(env:get(assi_token), "Voyager", "Appropriate value not retrieved.")

  return r
end)

-- Test the failure of getting a variable.
environment_test:add("[test_environment] Environment:define(), Environment:get()", function(r)
  local env = Environment:new()
  local name_token = Token(IDENTIFIER, "name", "name", 0)

  -- in order to test that an error was thrown and to get back
  -- a status and error message for that error, it's necessary
  -- to call your function inside of an anonymous function inside
  -- of pcall:
  local status, err = pcall(function () env:get(name_token) end)
  local error_string = "Undefined Variable 'name'"
  r:_truthy(string.match(err, error_string),"Unexpected Error String:\n" .. err .. "\n Expecting: "..error_string)
  return r
end)
