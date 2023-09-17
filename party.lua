-- party pat

-- figure out some builder stuff

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

-- vardy{"Does this work"}
