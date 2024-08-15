-- kona/syntax/token.lua
-- Token and Token Type
-- Has a small structure for making tokens

-- local ffi = require("ffi")

-- Creates a Token Object
--  type: the token type
--  lexeme: the actual representation of whatever it is.
--  literal: the literal characters that represent the token.
--  line: the line the token is on in the source file
--  length: the length of the token.
function Token (type, lexeme, literal, line)
  if literal == nil then literal = 'nil' end
  local t = {
    type = type,
    lexeme = lexeme,
    literal = literal,
    line = line,
    length = #literal,
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

-- tokens:
--
--  Single Character Tokens
--    LEFT_PAREN, RIGHT_PAREN, LEFT_BRACE, RIGHT_BRACE, COMMA, DOT, MINUS, PLUS,
--     SEMICOLON, SLASH, STAR, BANG,
--
--  One or Two Character tokens
--    BANG_EQUAL, EQUAL, EQUAL_EQUAL, GREATER, GREATER_EQUAL, LESS, LESS_EQUAL,
--
--  Literals
--    IDENTIFIER, STRING, NUMBER,
--
--  Keywords
--    AND, BREAK, CASE, CONTINUE, CLASS, DEF, DO, ELSE, END, ENUM, FALSE, FOR,
--    FUN, GOTO, IF, IN, IS, LET, MODULE, NIL, NOT, OR, REPEAT, RETURN, SELF,
--    SUPER, SWITCH, THEN, TRUE, UNTIL, UNLESS, WHEN, WHILE
--
--    EOF

LEFT_PAREN=0;RIGHT_PAREN=1;LEFT_BRACE=2;RIGHT_BRACE=3;COMMA=4;DOT=5;MINUS=6;PLUS=7;SEMICOLON=8;SLASH=9;STAR=10;BANG=11;BANG_EQUAL=12;EQUAL=13;EQUAL_EQUAL=14;GREATER=15;GREATER_EQUAL=16;LESS=17;LESS_EQUAL=18;IDENTIFIER=19;STRING=20;NUMBER=21;AND=22;BREAK=24;CASE=25;CONTINUE=26;CLASS=27;DEF=28;DO=29;ELSE=30;END=31;ENUM=32;FALSE=33;FOR=34;FUN=35;GOTO=36;IF=37;IN=38;IS=39;LET=40;MODULE=41;NIL=42;NOT=43;OR=44;REPEAT=45;RETURN=46;SELF=47;SUPER=48;SWITCH=49;THEN=50;TRUE=51;UNTIL=52;UNLESS=53;WHEN=54;WHILE=55;EOF=56;

-- ALL_TOKENS or AT gives us a lookup of the tokens
-- as strings, useful for inspection purposes
ALL_TOKENS={}
AT=ALL_TOKENS; AT[LEFT_PAREN]="LEFT_PAREN"; AT[RIGHT_PAREN]="RIGHT_PAREN"; AT[LEFT_BRACE]="LEFT_BRACE"; AT[RIGHT_BRACE]="RIGHT_BRACE"; AT[COMMA]="COMMA";AT[DOT]="DOT";AT[MINUS]="MINUS";AT[PLUS]="PLUS";AT[SEMICOLON]="SEMICOLON";AT[SLASH]="SLASH";AT[STAR]="STAR";AT[BANG]="BANG";AT[BANG_EQUAL]="BANG_EQUAL";AT[EQUAL]="EQUAL";AT[EQUAL_EQUAL]="EQUAL_EQUAL";AT[GREATER]="GREATER";AT[GREATER_EQUAL]="GREATER_EQUAL";AT[LESS]="LESS";AT[LESS_EQUAL]="LESS_EQUAL";AT[IDENTIFIER]="IDENTIFIER";AT[STRING]="STRING";AT[NUMBER]="NUMBER";AT[AND]="AND";AT[BREAK]="BREAK";AT[CASE]="CASE";AT[CONTINUE]="CONTINUE";AT[CLASS]="CLASS";AT[DEF]="DEF";AT[DO]="DO";AT[ELSE]="ELSE";AT[END]="END";AT[ENUM]="ENUM";AT[FALSE]="FALSE";AT[FOR]="FOR";AT[FUN]="FUN";AT[GOTO]="GOTO";AT[IF]="IF";AT[IN]="IN";AT[IS]="IS";AT[LET]="LET";AT[MODULE]="MODULE";AT[NIL]="NIL";AT[NOT]="NOT";AT[OR]="OR";AT[REPEAT]="REPEAT";AT[RETURN]="RETURN";AT[SELF]="SELF";AT[SUPER]="SUPER";AT[SWITCH]="SWITCH";AT[THEN]="THEN";AT[TRUE]="TRUE";AT[UNTIL]="UNTIL";AT[UNLESS]="UNLESS";AT[WHEN]="WHEN";AT[WHILE]="WHILE";AT[EOF]="EOF";
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

