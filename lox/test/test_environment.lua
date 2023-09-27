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


-- Test the shape of a new environment
environment_test:add("[test_environment] Environment:define(), Environment:get()", function(r)
  local env = Environment:new()

  env:define("name", "Kathryn")
  env:define("rank", "Captain")
  env:define("assignment", "Voyager")

  local name_token = Token(IDENTIFIER, "name", "name", 0)


  r:_truthy(env:get(name_token), "name assignment failed.")
  -- r:_truthy(env.get('rank'), "rank assignment failed.")
  -- r:_truthy(env.get('assignment'), "assignment assignment failed.")

  return r
end)
