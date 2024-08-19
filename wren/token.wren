// Token.wren
// Where the token class definition can be found.

// Token
// The token class represents tokens that the scanner makes as it scans the code.
//
class Token {

  type { _type }
  lexeme { _lexeme }
  literal { _literal }
  line { _line }

  // Constructs a new token.
  construct new(type, lexeme, literal, line) {
    _type = type
    _lexeme = lexeme
    _literal = literal
    _line = line

    if(literal == null) {
      _literal = "nil"
    }
  }

  // to String function
  toString { _type + " => [" + _lexeme + "] " + _literal }

  // description function
  description { "(line:" + line + ") - " + type + "  " + lexeme + " " + literal }
}

// Token Types
// Token Types include special characters, and reserved words.
// They are global here because we need to access them
// in a lot of spots, will probably name space these later.

// tokens:
//
//  Single Character Tokens
//    LEFT_PAREN, RIGHT_PAREN, LEFT_BRACE, RIGHT_BRACE, COMMA, DOT, MINUS, PLUS,
//     SEMICOLON, SLASH, STAR, BANG,
//
//  One or Two Character tokens
//    BANG_EQUAL, EQUAL, EQUAL_EQUAL, GREATER, GREATER_EQUAL, LESS, LESS_EQUAL,
//
//  Literals
//    IDENTIFIER, STRING, NUMBER,
//
//  Keywords
//    AND, BREAK, CASE, CONTINUE, CLASS, DEF, DO, ELSE, END, ENUM, FALSE, FOR,
//    FUN, GOTO, IF, IN, IS, LET, MODULE, NIL, NOT, OR, REPEAT, RETURN, SELF,
//    SUPER, SWITCH, THEN, TRUE, UNTIL, UNLESS, WHEN, WHILE
//
//    EOF

var TokenType = [
"LEFT_PAREN",
"RIGHT_PAREN",
"LEFT_BRACE",
"RIGHT_BRACE",
"COMMA",
"DOT",
"MINUS",
"PLUS",
"SEMICOLON",
"SLASH",
"STAR",
"BANG",
"BANG_EQUAL",
"EQUAL",
"EQUAL_EQUAL",
"GREATER",
"GREATER_EQUAL",
"LESS",
"LESS_EQUAL",
"IDENTIFIER",
"STRING",
"NUMBER",
"AND",
"BREAK",
"CASE",
"CONTINUE",
"CLASS",
"DEF",
"DO",
"ELSE",
"END",
"ENUM",
"FALSE",
"FOR",
"FUN",
"GOTO",
"IF",
"IN",
"IS",
"LET",
"MODULE",
"NIL",
"NOT",
"OR",
"REPEAT",
"RETURN",
"SELF",
"SUPER",
"SWITCH",
"THEN",
"TRUE",
"UNTIL",
"UNLESS",
"WHEN",
"WHILE",
"EOF",
]

var Keywords = [
  "and",
  "break",
  "case",
  "continue",
  "class",
  "def",
  "do",
  "else",
  "end",
  "enum",
  "false",
  "for",
  "fun",
  "goto",
  "if",
  "in",
  "is",
  "let",
  "module",
  "nil",
  "not",
  "or",
  "repeat",
  "return",
  "self",
  "super",
  "switch",
  "then",
  "true",
  "until",
  "unless",
  "when",
  "while"
]
