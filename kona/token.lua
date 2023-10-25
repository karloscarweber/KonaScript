-- Token.lua
-- Token and Token Type
-- Has a small structure for making tokens

local ffi = require("ffi")

-- Creates a Token Object, which is just, like, a collection of some stuff.
function Token (type, lexeme, literal, line)
  local t = {}
  t.type = type
  t.lexeme = lexeme
  t.literal = literal
  t.line = line
  if literal == nil then literal = 'nil' end
  -- t.toString = "" .. type .. " => [" .. lexeme .. "] " .. literal
  -- t.description = "(line:" .. line .. ") - " .. type .. "  " .. lexeme .. " " .. literal
  return t
end

-- create a new C data structure that we have access to called Token.
ffi.cdef[[
typedef struct {
  uint8_t type;
  uint8_t line;
  char *lexeme;
  char *literal;
} token;
]]

-- Initializer for Token Object
function Token(type, lexeme, literal, line)
  return ffi.new("token", n)
end


-- Token Types
LEFT_PAREN = 0
RIGHT_PAREN = 1
LEFT_BRACE = 2
RIGHT_BRACE = 3
COMMA = 4
DOT = 5
MINUS = 6
PLUS = 7
SEMICOLON = 8
SLASH = 9
STAR = 10
BANG = 11
BANG_EQUAL = 12
EQUAL = 13
EQUAL_EQUAL = 14
GREATER = 15
GREATER_EQUAL = 16
LESS = 17
LESS_EQUAL = 18
IDENTIFIER = 19
STRING = 20
NUMBER = 21
AND = 22
CLASS = 23
ELSE = 24
FALSE = 25
FUN = 26
FOR = 27
IF = 28
NIL = 29
OR = 30
PRINT = 31
RETURN = 32
SUPER = 33
THIS = 34
TRUE = 35
VAR = 36
WHILE = 37
EOF = 38

-- this is unused
ALL_TOKENS = {
RIGHT_PAREN,
LEFT_BRACE,
RIGHT_BRACE,
COMMA,
DOT,
MINUS,
PLUS,
SEMICOLON,
SLASH,
STAR,
BANG,
BANG_EQUAL,
EQUAL,
EQUAL_EQUAL,
GREATER,
GREATER_EQUAL,
LESS,
LESS_EQUAL,
IDENTIFIER,
STRING,
NUMBER,
AND,
CLASS,
ELSE,
FALSE,
FUN,
FOR,
IF,
NIL,
OR,
PRINT,
RETURN,
SUPER,
THIS,
TRUE,
VAR,
WHILE,
EOF,
}

-- this gets us a zero based array, which we want.
ALL_TOKENS[0] = LEFT_PAREN

TokenType = ALL_TOKENS
