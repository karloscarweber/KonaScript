-- scanner.lua
-- Is the scanner for the thing.
require('lox/token_type')
require('lox/token')

Scanner = {

  source="hello friends (){},;",
  tokens={},
  start=1,
  current=1,
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
  },

}

function Scanner:new(source)
  local u = {
	  source=source,
	  tokens={},
	  start=1,
	  current=1,
	  line=1,
  }
  -- for k, v in ipairs(Scanner) do u[k] = v end
  setmetatable(u, self)
  self.__index = self
  self.scanTokenFunctions.supertable = u
  return u
end

function Scanner:scanTokens()
  while self:isAtEnd() == false  do
    -- We are at the beginning of the next lexeme
    self.start = self.current
    self:scanToken()
  end

  self.tokens[(#self.tokens + 1)] = Token(EOF, "", "", self.line)
  return self.tokens
end

function Scanner:spitTokens ()
	for _, v in ipairs(self.tokens) do
		print(v.toString)
	end
end

Scanner.scanTokenFunctions = {
  ["("] = function (s) s:addToken(LEFT_PAREN) end,
  [")"] = function (s) s:addToken(RIGHT_PAREN) end,
  ["{"] = function (s) s:addToken(LEFT_BRACE) end,
  ["}"] = function (s) s:addToken(RIGHT_BRACE) end,
  [","] = function (s) s:addToken(COMMA) end,
  ["."] = function (s) s:addToken(DOT) end,
  ["-"] = function (s) s:addToken(MINUS) end,
  ["+"] = function (s) s:addToken(PLUS) end,
  [";"] = function (s) s:addToken(SEMICOLON) end,
  ["*"] = function (s) s:addToken(STAR) end,
  ["!"] = function (s)
    s:addToken(s:match('=') and BANG_EQUAL or BANG)
  end,
  ["="] = function (s)
    s:addToken(s:match('=') and EQUAL_EQUAL or EQUAL)
  end,
  ["<"] = function (s)
    s:addToken(s:match('=') and LESS_EQUAL or LESS)
  end,
  [">"] = function (s)
    s:addToken(s:match('=') and GREATER_EQUAL or GREATER)
  end,
  ["/"] = function (s)
    if (s:match('/')) then
      -- A comment goes until the end of the line.
      while ( s:peek() ~= '\n' and (not s:isAtEnd()) ) do
        s:advance()
      end
    else
      s:addToken(SLASH);
    end
  end,
  [" "]  = function (s) --[[ Do nothing --]] end,
  ["\r"] = function (s) --[[ Do nothing --]] end,
  ["\t"] = function (s) --[[ Do nothing --]] end,
  ["\n"] = function (s)
    s.line = s.line + 1
  end,
  ["\""] = function (s) s:string() end,
}


local stf = Scanner.scanTokenFunctions
local stfmt = {}

stf.supertable = {}

stf.mt = stfmt
setmetatable(stf, stf.mt)
stfmt.__index = function (table, key)
  if table.supertable:isDigit(key) then
    table.supertable:number()
  elseif table.supertable:isAlpha(key) then
    table.supertable:identifier()
  else
    error("Unexpected Character "..key..", at line "..table.supertable.line, 2)
  end
end

function Scanner:scanToken ()
  local c = self:advance()
  local tokenFunction = self.scanTokenFunctions[c]
  if tokenFunction ~= nil then tokenFunction(self) end
end

function Scanner:identifier()
  while self:isAlphaNumeric(self:peek()) do self:advance() end

  local so,s,c = self.source,self.start,self.current
  local text = string.sub(so, s, c);

  local type = self.keywords[text];
  if (type == nil) then type = IDENTIFIER end
  self:addToken(type);
end

function Scanner:number()
  while self:isDigit(self:peek()) do self:advance() end
  if (self:peek() == '.' and self:isDigit(self:peekNext())) then
    -- Consume the "."
    self:advance()

    while (self:isDigit(self:peek())) do self:advance() end
  end
  local so,s,c = self.source,self.start,self.current

  self:addToken(NUMBER, tonumber(string.sub(so, s, c)))

end

function Scanner:string()
  while (self:peek() ~= '"' and not self:isAtEnd() ) do
    if (self:peek() == '\n') then self.line = self.line + 1 end
    self:advance()
  end

  -- we only hit this error if we never get this string terminated.
  if self:isAtEnd() and not (string.sub(self.source, self.current, self.current) == "\"") then
    error("unterminated string. at line: " .. self.line)
    return
  end

  self:advance()

  self:addToken(STRING, string.sub(self.source, self.start + 1, self.current - 1))
end

function Scanner:match(expected)
  if (self:isAtEnd()) then return false end
  if (string.sub(self.source, self.current, self.current) ~= expected) then return false end

  self.current = self.current + 1;
  return true;
end

function Scanner:peek()
  if (self:isAtEnd()) then return '\0' end
  return string.sub(self.source, self.current, self.current)
end

function Scanner:peekNext()
  if (self.current + 1 >= #self.source) then return '\0' end
  return string.sub(self.source, (self.current + 1), (self.current + 1))
end

-- looks at the previous character
function Scanner:peekBack()
  -- short circuits to see if it's the end.
  if (self.current == #self.source) then return '\0' end
  return string.sub(self.source, (self.current), (self.current))
end

function Scanner:isAlpha(c)
  return (c >= 'a' and c <= 'z') or
         (c >= 'A' and c <= 'Z') or
          c == '_';
end

function Scanner:isAlphaNumeric(c)
  return self:isAlpha(c) or self:isDigit(c)
end

function Scanner:isDigit(c)
  return c >= '0' and c <= '9'
end

function Scanner:isAtEnd()
  return self.current >= #self.source
end

function Scanner:advance()
  self.current = self.current + 1
  return string.sub(self.source, (self.current), (self.current))
end

function Scanner:addToken(type, literal)
  local text = string.sub(self.source, self.start, self.current)
  self.tokens[(#self.tokens + 1)] = Token(type, text, "", self.line)
end

-- scan = Scanner:new("this should be good {}()")
-- scan:scanTokens()
