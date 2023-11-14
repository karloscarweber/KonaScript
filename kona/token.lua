-- Token.lua
-- Token and Token Type
-- Has a small structure for making tokens

-- local ffi = require("ffi")

-- Creates a Token Object, which is just, like, a collection of some stuff.
function Token (type, lexeme, literal, line)
  if literal == nil then literal = 'nil' end
  local t = {
    type = type,
    lexeme = lexeme,
    literal = literal,
    line = line,
  }
  return t
end

-- transforms a token to a string
function Token_toString(t)
  return "" .. ALL_TOKENS[t.type] .. " =>  " .. t.lexeme .. "  `" .. t.literal .. "`"
end

-- gets a description of a token
function Token_description(t)
  return "(line:" .. t.line .. ") - " .. ALL_TOKENS[t.type] .. "  " .. t.lexeme .. " `" .. t.literal .. "`"
end

-- Token Types
-- Token Types include special characters, and reserved words.
-- They are global here because we need to access them
-- in a lot of spots, will probably name space these later.
LEFT_PAREN=0;RIGHT_PAREN=1;LEFT_BRACE=2;RIGHT_BRACE=3;COMMA=4;DOT=5;MINUS=6;PLUS=7;SEMICOLON=8;SLASH=9;STAR=10;BANG=11;BANG_EQUAL=12;EQUAL=13;EQUAL_EQUAL=14;GREATER=15;GREATER_EQUAL=16;LESS=17;LESS_EQUAL=18;IDENTIFIER=19;STRING=20;NUMBER=21;AND=22;CLASS=23;ELSE=24;FALSE=25;FUN=26;FOR=27;IF=28;NIL=29;OR=30;PRINT=31;RETURN=32;SUPER=33;THIS=34;TRUE=35;VAR=36;WHILE=37;EOF=38

-- ALL_TOKENS or AT gives us a lookup of the tokens
-- as strings, useful for inspection purposes
ALL_TOKENS={}
AT=ALL_TOKENS; AT[LEFT_PAREN]="LEFT_PAREN"; AT[RIGHT_PAREN]="RIGHT_PAREN"; AT[LEFT_BRACE]="LEFT_BRACE"; AT[RIGHT_BRACE]="RIGHT_BRACE"; AT[COMMA]="COMMA";AT[DOT]="DOT";AT[MINUS]="MINUS";AT[PLUS]="PLUS";AT[SEMICOLON]="SEMICOLON";AT[SLASH]="SLASH";AT[STAR]="STAR";AT[BANG]="BANG";AT[BANG_EQUAL]="BANG_EQUAL";AT[EQUAL]="EQUAL";AT[EQUAL_EQUAL]="EQUAL_EQUAL";AT[GREATER]="GREATER";AT[GREATER_EQUAL]="GREATER_EQUAL";AT[LESS]="LESS";AT[LESS_EQUAL]="LESS_EQUAL";AT[IDENTIFIER]="IDENTIFIER";AT[STRING]="STRING";AT[NUMBER]="NUMBER";AT[AND]="AND";AT[CLASS]="CLASS";AT[ELSE]="ELSE";AT[FALSE]="FALSE";AT[FUN]="FUN";AT[FOR]="FOR";AT[IF]="IF";AT[NIL]="NIL";AT[OR]="OR";AT[PRINT]="PRINT";AT[RETURN]="RETURN";AT[SUPER]="SUPER";AT[THIS]="THIS";AT[TRUE]="TRUE";AT[VAR]="VAR";AT[WHILE]="WHILE";AT[EOF]="EOF";
-- this gets us a zero based array, which we want.

TokenType=ALL_TOKENS

-- Some Tests of the Token System.
-- print("test that it works")
-- print(RIGHT_PAREN)
-- print(NUMBER)
-- ALL_TOKENS[STRING] = "STRING"
-- print(ALL_TOKENS[RIGHT_PAREN])
-- print(ALL_TOKENS[NUMBER])

-- t = Token(LEFT_PAREN, "(", "(", 1)
-- print(Token_toString(t))
-- print(Token_description(t))
-- print("")
-- d = Token(STRING, "Whatever Man.", "\"Whatever Man.\"", 1)
-- print(Token_toString(d))
-- print(Token_description(d))
-- print("")
-- e = Token(STRING, 15, 15, 1)
-- print(Token_toString(e))
-- print(Token_description(e))

