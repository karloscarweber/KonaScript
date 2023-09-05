-- scanner.lua
-- Is the scanner for the thing.
require('token_type')
require('token')
print("Scanner loaded")

Scanner = {

  source="",
  tokens={},
  start=0,
  current=0,
  line=1,

  keywords = {
  ["and"]    = AND,
  ["class"]  = CLASS,
  ["else"]   = ELSE,
  ["false"]  = FOR,
  ["for"]    = FOR,
  ["fun"]    = FUN,
  ["if"]     = IF,
  ["nil"]    = NIL,
  ["or"]     = OR,
  ["print"]  = PRINT,
  ["return"] = RETURN,
  ["super"]  = SUPER,
  ["this"]   = THIS,
  ["true"]   = TRUE,
  ["var"]    = VAR,
  ["while"]  = WHILE,
  },AND

  -- -- constructor thing
  -- -- Accepts the code to tokenize
  -- new = function (source)
  --   local u = {}
  --   for k, v in pairs(scanner) do u[k] = v end
  --   u.source = source
  --   return setmetatable(u, getmetatable(scanner))
  -- end,

  -- scan_tokens = function ()
  --   while(!is_at_end()) do
  --     -- We are at the beginning of th enext lexeme
  --     start = current
  --     scanToken()
  --   end
  -- end,

}

function Scanner:new ()
  local u = {}
  for k, v in pairs(self) do u[k] = v end
  u.source = source
  return setmetatable(u, getmetatable(self))
end

function Scanner:scan_tokens ()
  while(is_at_end() == false) do
    -- We are at the beginning of the next lexeme
    start = current
    scanToken()
  end
  -- Not written yet.
  tokens.add(Token.new(tokens.eof, "", nil, line))
  return tokens
end

Scanner.scanTokenFunctions = {
  ["("] = function (s) s.addToken(LEFT_PAREN) end,
  [")"] = function (s) s.addToken(RIGHT_PAREN) end,
  ["{"] = function (s) s.addToken(LEFT_BRACE) end,
  ["}"] = function (s) s.addToken(RIGHT_BRACE) end,
  [","] = function (s) s.addToken(COMMA) end,
  ["."] = function (s) s.addToken(DOT) end,
  ["-"] = function (s) s.addToken(MINUS) end,
  ["+"] = function (s) s.addToken(PLUS) end,
  [";"] = function (s) s.addToken(SEMICOLON) end,
  ["*"] = function (s) s.addToken(STAR) end,
  ["!"] = function (s)
    s.addToken(match('=') and BANG_EQUAL or BANG)
  end,
  ["="] = function (s)
    s.addToken(match('=') and EQUAL_EQUAL or EQUAL)
  end,
  ["<"] = function (s)
    s.addToken(match('=') and LESS_EQUAL or LESS)
  end,
  [">"] = function (s)
    s.addToken(match('=') and GREATER_EQUAL or GREATER)
  end,
  ["/"] = function (s)
    if (match('/')) then
      s.addToken(LEFT_PAREN)
    else
      s.addToken(SLASH);
    end
  end,
  [" "] = function (s) s.addToken(LEFT_PAREN) end,
  ["\r"] = function (s) s.addToken(LEFT_PAREN) end,
  ["\t"] = function (s) s.addToken(LEFT_PAREN) end,
  ["\n"] = function (s) s.addToken(LEFT_PAREN) end,
  ["\""] = function (s) s.addToken(LEFT_PAREN) end,
}

 -- create an empty meta table in scanTokenFunctions
Scanner.scanTokenFunctions.mt = {}
-- set the meta table of our main table to be the mt table we just made
setmetatable(Scanner.scanTokenFunctions, Scanner.scanTokenFunctions.mt)
-- set the __index function of the meta table to do some magic.
Scanner.scanTokenFunctions.mt.__index = function (table, key)
  if isDigit(n) then
  else if isAlpha(n) then
    print("nothing")
  else
    error("Unexpected Character "..n..", at line "..line, 2)
  end
end

function Scanner:scan_token ()
  c = advance()
end
