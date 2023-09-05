-- token_type.lua
print("token_type loaded")

LEFT_PAREN = "("
RIGHT_PAREN = ")"
LEFT_BRACE = "{"
RIGHT_BRACE = "}"
COMMA = ""
DOT = "."
MINUS = "-"
PLUS = "+"
SEMICOLON = ";"
SLASH = "/"
STAR = "*"
BANG = "!"
BANG_EQUAL = "!="
EQUAL = "="
EQUAL_EQUAL = "=="
GREATER = ">"
GREATER_EQUAL = ">="
LESS = "<"
LESS_EQUAL = "<="
IDENTIFIER = "identifier"
STRING = "string"
NUMBER = "number"
AND = "and"
CLASS = "class"
ELSE = "else"
FALSE = "false"
FUN = "fun"
FOR = "for"
IF = "if"
NIL = "nil"
OR = "or"
PRINT = "print"
RETURN = "return"
SUPER = "super"
THIS = "this"
TRUE = "true"
VAR = "var"
WHILE = "while"
EOF = "End of File"


ALL_TOKENS = {
["LEFT_PAREN"] = LEFT_PAREN,
["RIGHT_PAREN"] = RIGHT_PAREN,
["LEFT_BRACE"] = LEFT_BRACE,
["RIGHT_BRACE"] = RIGHT_BRACE,
["COMMA"] = COMMA,
["DOT"] = DOT,
["MINUS"] = MINUS,
["PLUS"] = PLUS,
["SEMICOLON"] = SEMICOLON,
["SLASH"] = SLASH,
["STAR"] = STAR,
["BANG"] = BANG,
["BANG_EQUAL"] = BANG_EQUAL,
["EQUAL"] = EQUAL,
["EQUAL_EQUAL"] = EQUAL_EQUAL,
["GREATER"] = GREATER,
["GREATER_EQUAL"] = GREATER_EQUAL,
["LESS"] = LESS,
["LESS_EQUAL"] = LESS_EQUAL,
["IDENTIFIER"] = IDENTIFIER,
["STRING"] = STRING,
["NUMBER"] = NUMBER,
["AND"] = AND,
["CLASS"] = CLASS,
["ELSE"] = ELSE,
["FALSE"] = FALSE,
["FUN"] = FUN,
["FOR"] = FOR,
["IF"] = IF,
["NIL"] = NIL,
["OR"] = OR,
["PRINT"] = PRINT,
["RETURN"] = RETURN,
["SUPER"] = SUPER,
["THIS"] = THIS,
["TRUE"] = TRUE,
["VAR"] = VAR,
["WHILE"] = WHILE,
["EOF"] = EOF,
}

AT = ALL_TOKENS
-- tt = token_types
-- all_tokens = {}

-- function DeCat_Strings (strings)
--   for token in string.gmatch(strings, "[^%s]+") do
--     print(token)
--     all_tokens[token] = true
--   end
-- end

-- DeCat_Strings(tt.symbols)
-- DeCat_Strings(tt.smol)
-- DeCat_Strings(tt.literals)
-- DeCat_Strings(tt.keyword)
-- DeCat_Strings(tt.eof)
