-- lox/test/test_scanner.lua

-- Test the scanner
require 'dots' -- Require the testing framework
require 'lox/scanner'

-- A Sample Test file.
local scanner_test = Dots.Test:new("scanner")

-- Test the testing framework
scanner_test:add("[test_scanner] Scanner:new", function(r)
  local scanner = Scanner:new("Some random Source")
  local scanner2 = Scanner:new("Another Random Source")
  r:_truthy(scanner, "Scanner is not initialized")
  r:_truthy(scanner2, "Scanner is not initialized")
  r:_shape(scanner, {source="string", tokens={}, start="number", line="number",current="number"}, "Scanner object not in expected shape")
  r:_truthy((tostring(scanner) ~= tostring(scanner2)), "Scanners are identical, not expected."..tostring(scanner).." == "..tostring(scanner2))
  return r
end)

scanner_test:add("[test_scanner] Scanner:Advance, Scanner:isAtEnd", function(r)
  local scanner = Scanner:new("blank")
  scanner:advance()
  scanner:advance()
  r:_truthy((scanner.current > 2), "Scanner does not advance.")
  scanner:advance()
  scanner:advance()
  scanner:advance()
  r:_truthy(scanner:isAtEnd() , "Scanner Does not accurately detect the end.")
  return r
end)


scanner_test:add("[test_scanner] Scanner:EndOfFile", function(r)
  local scanner = Scanner:new("hello hello hello hello ")
  r:_truthy(scanner, "Scanner Doesn't detect the end of file accurately.")
  return r
end)


scanner_test:add("[test_scanner] Scanner:scanTokens", function(r)
  local scanner = Scanner:new("identifer = \"5\"")
  r:_truthy(scanner, "Scanner is not initialized")
  return r
end)
