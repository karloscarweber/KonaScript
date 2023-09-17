-- Token
-- Has a small structure for making tokens
print("Token loaded")

-- Creates a Token Object, which is just, like, a collection of some stuff.
function Token (type, lexeme, literal, line)
  local t = {}
  t.type = type
  t.lexeme = lexeme
  t.literal = literal
  t.line = line
  if literal == nil then literal = 'nil' end
  t.toString = "[" .. type .. "]  " .. lexeme .. " " .. literal
  t.description = "(line:" .. line .. ") - " .. type .. "  " .. lexeme .. " " .. literal
  return t
end
