-- experiments/intercept_globals.lua

--[[
In class blocks it's easier to write functions and variable
declarations as though they are just... variables. without
declaring them as local variables.
--]]


--[[
class Cheese
  cheese_type = "My Favorite type"

  def platter()
    @cheese_type
  end
end
--]]

--[[
In Lua, first off there are no class definitions. So we'd need to add that. Which we can do. You know. But after that, any time you either try to access a global variable, or make a new one you try to access the current environment held in `_ENV`, and hit up the metatable there.
--]]

-- makes a class definition
function MakeClassSpaceInDo(environment,namespace)
  setmetatable(_ENV, {
    __newindex = function(table, key, value)
      rawset(namespace, key, value)
    end,
    -- set the metatable's index for the enironment to the Cheese!
    __index = namespace
  })
end

-- setup a class Namespace
StandardObjectFunctions = {
  new = function()
    local t = {}

  end
}

-- open the class definitions
Cheese = {} do MakeClassSpaceInDo(_ENV, Cheese);
  -- capture a local variable, named self,
  local self = Cheese
  value = "I love this cheese"
  cheeses = {"gouda","cheddar","provolone"}
  function printCheese()
    for _,v in ipairs(self.cheeses) do
      print(v)
    end
  end
  function addCheese(cheese)
    table.insert(self.cheeses, cheese)
  end
  -- Close the class definition
end setmetatable(_ENV, nil)

Cheese.new()

Cheese.addCheese("swiss") -- adds a cheese

Cheese.printCheese() -- prints some cheese

--[[
So we could simulate the following, if we wanted to:

class Cheese

  @value = "I love this cheese"
  @cheeses = {"gouda","cheddar","provolone"}
  def printCheese
    @cheeses.each |v|
      print(v)
    end
  end
  def addCheese(cheese)
    @cheeses << cheese
  end
end
--]]

-- Damn, wait... I'm forgetting instantiation.
