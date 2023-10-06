-- party pat

-- figure out some builder stuff

-- makes a string with a metatable of type String.
String_metatable = {}
String_metatable = {
  __index = function(tab, key)
    if key == 'type' then
      return String_metatable.type
    elseif type(string[key]) == 'function' then
      return string[key](tab, )
    else
      print(tab, key)
    end
  end,
  __str_length = {},
  type = "String"
}
setmetatable(string, String_metatable)
-- function String(str)
--   setmetatable(str, String_metatable)
--   return str
-- end

function vardy(builder)
  if type(builder) == "table" then
    for key, value in ipairs(builder) do
      if type(value) == "table" then
        print(key .. " (table)")
        vardy(value)
      else
        print(key .. " " .. value)
      end
    end
  else
    error("vardy accepts a table builder, not all this gobbledy gook.")
  end
end

vardy {
    "Does this work",
    {
      "complex",
      "app",
      {
        "thing"
      }
    }
}

vardy{"Does this work"}



