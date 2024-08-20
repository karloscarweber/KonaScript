// Token.wren
// Where the token class definition can be found.

// Token Types
// Token Types include special characters, and reserved words.
// They are global here because we need to access them
// in a lot of spots, will probably name space these later.
var TokenTypes = [
  "LEFT_PAREN",
  "RIGHT_PAREN",
  "LEFT_BRACE",
  "RIGHT_BRACE",
  "LEFT_BRACKET",
  "RIGHT_BRACKET",
  "COMMA",
  "DOT",
  "MINUS",
  "PLUS",
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
  "MODULO",
  "CARAT",
  "POUND",
  "AND",
  "AND_AND",
  "PIPE",
  "QUESTION",
  "COLON",
  "SNAIL",
  "LESS_LESS",
  "GREATER_GREATER",
  "DOT_DOT",
  "DOT_DOT_DOT",
  "STAR_STAR",
  "IDENTIFIER",
  "STRING", // "STRING CONTENTS"
  "NUMBER",

  // KEYWORDS AND STUFF
  "AS",
  "BREAK",
  "CLASS",
  "CONSTRUCT",
  "CONTINUE",
  "ELSE",
  "FALSE",
  "FOR",
  "FOREIGN",
  "IF",
  "IMPORT",
  "IN",
  "IS",
  "NULL",
  "RETURN",
  "STATIC",
  "SUPER",
  "THIS",
  "TRUE",
  "VAR",
  "WHILE",
  "EOF",
]

var AllKeywords = {
  "as":        "AS",
  "break":     "BREAK",
  "class":     "CLASS",
  "construct": "CONSTRUCT",
  "continue":  "CONTINUE",
  "else":      "ELSE",
  "false":     "FALSE",
  "for":       "FOR",
  "foreign":   "FOREIGN",
  "if":        "IF",
  "import":    "IMPORT",
  "in":        "IN",
  "is":        "IS",
  "null":      "NULL",
  "return":    "RETURN",
  "static":    "STATIC",
  "super":     "SUPER",
  "this":      "THIS",
  "true":      "TRUE",
  "var":       "VAR",
  "while":     "WHILE",
}

// Token
// The token class represents tokens that the scanner makes as it scans the code.
class Token {

  type { _type }
  lexeme { _lexeme }
  literal { _literal }
  line { _line }

  /**
   * Constructs a new token.
   *
   *  params:
   *    type:    String found in Tokens.all
   *    lexeme:  String
   *    literal: String
   *    line:    Number
   */
  construct new(type, lexeme, literal, line) {
    _type = type
    _lexeme = lexeme
    _literal = literal
    _line = line

    if(literal == null) {
      _literal = "null"
    }
  }

  // to String function
  toString { _type + " => [" + _lexeme + "] " + _literal }

  // description function
  description { "(line:" + line + ") - " + type + "  " + lexeme + " " + literal }
}

class Tokens {

  /**
   * Returns all tokens in TokenTypes
   */
  static all { TokenTypes }

  /**
   * Checks for the presence of token
   */
  static [token] {
    if (TokenTypes.contains(token)) {
      return TokenTypes[token]
    }
    return false
  }

}

class Keywords {

  /**
   * checks to see if a given lexeme is a valid token
   *
   * returns the token code if true, otherwise false
   */
  static [lexeme] {
    if (AllKeywords.containsKey(lexeme)) {
      return AllKeywords[lexeme]
    }
    return false
  }

}
