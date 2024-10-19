-- lox/Environment.lua

-- The Environment of Lox is stored in a table.
Environment = {}

-- create a new Lox environment
function Environment:new()
  local environment = {}
  environment.values = {}

  setmetatable(environment, self)
  self.__index = self

  return environment
end

-- define a name with a value in the lox environment
function Environment:define(name, value)
  self.values[name] = value
end

-- get the value stored at name in the lox environment
function Environment:get(name)
  if self.values[name.lexeme] == nil then
    error("Undefined Variable '" .. name.lexeme .. "'.", 2)
  else
    return self.values[name.lexeme]
  end
end
