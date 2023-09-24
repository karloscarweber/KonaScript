-- lox/test/test_scanner.lua

-- Test the scanner
require 'dots' -- Require the testing framework
require 'lox/scanner'

-- A Sample Test file.
local scanner_test = Dots.Test:new("scanner")

-- Test the testing framework
scanner_test:add("[test_scanner] Instantiation", function(r)
  local scanner = Scanner:new("Some random Source")
  local scanner2 = Scanner:new("Another Random Source")
  r:_truthy(scanner, "Scanner is not initialized")
  r:_truthy(scanner2, "Scanner is not initialized")

  r:_shape(scanner, {source="string", tokens={}, start="number", line="number",current="number"}, "Scanner object not in expected shape")

  return r
end)
--
-- scanner_test:add("Add another little thing to these tests.", function(r)
--   local silly = "silly"
--   local tab = {name="", address="", cars={"ford","honda","mini"}}
--   r:_truthy(silly == "silly", "Silly Does not match and why not?")
--   r:_shape(tab,{name="string",address="string",cars="table", ["___cars"]={"string"}})
--   return r
-- end)
