-- lox/Environment.lua

-- The Environment variable thing
LoxEnvironment = function()
  local t = {}
  t.values = {}
  t.define = function(name, value)
    t.values[name] = value
  end
  t.get = function(name)
    if t.values[name.lexeme] == nil then
      error("Undefined Variable '" .. name.lexeme .. "'.")
    else
      return t.values[name.lexeme]
    end
  end
  return t
end
