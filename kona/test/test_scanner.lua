-- kona/test/test_token.lua
-- Testing the file: kona/token.lua

-- Test that the token stuff works.
require 'dots' -- Require the testing framework
require 'kona/syntax/token'

-- A Sample Test file.
local token_test = Dots.Test:new("tokens")

-- Test the testing framework
token_test:add("[test_scanner] Scanner:new", function(r)
  local tk = Token("brunette","brown","brownhair",5)
  r:_truthy((tk.type == "brunette"),"WHAT! She's not a brunette")
  -- r:_truthy(scanner, "Scanner is not initialized")
  -- r:_truthy(scanner2, "Scanner is not initialized")
  -- r:_shape(scanner, {source="string", tokens={}, start="number", line="number",current="number"}, "Scanner object not in expected shape")
  -- r:_truthy((tostring(scanner) ~= tostring(scanner2)), "Scanners are identical, not expected."..tostring(scanner).." == "..tostring(scanner2))
  return r
end)
--
-- token_test:add("[test_scanner] Scanner:Advance, Scanner:isAtEnd", function(r)
--   local scanner = Scanner:new("blank")
--   scanner:advance()
--   scanner:advance()
--   r:_truthy((scanner.current > 2), "Scanner does not advance.")
--   scanner:advance()
--   scanner:advance()
--   scanner:advance()
--   r:_truthy(scanner:isAtEnd() , "Scanner Does not accurately detect the end.")
--   return r
-- end)
--
-- -- Test that the scanner can see the end of the file
-- token_test:add("[test_scanner] Scanner:EndOfFile", function(r)
--   local scanner = Scanner:new("hello hello hello hello ")
--   r:_truthy(false, "Scanner Doesn't detect the end of file accurately.")
--   return r
-- end)
--
-- -- Test that the scanner can see that we're at the end of a file
-- -- even though the last character is a quotation mark.
-- token_test:add("[test_scanner] Scanner:scanTokens", function(r)
--   local scanner = Scanner:new("identifer = \"5\"")
--   r:_truthy(false, "Scanner doesn't bug out when we scanTokens with a failed ending identifier.")
--   return r
-- end)
