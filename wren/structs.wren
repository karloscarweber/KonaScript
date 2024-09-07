// Token.wren
// Where the token class definition can be found.

// type check the tokens during initialization
import "/modules/wren-assert/Assert" for Assert

// Token Types
// Token Types include special characters, and reserved words.
// They are global here because we need to access them
// in a lot of spots, will probably name space these later.
var TokensTypes = [
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

var TokenMap = {
  "(":   "LEFT_PAREN",
  ")":   "RIGHT_PAREN",
  "[":   "LEFT_BRACE",
  "]":   "RIGHT_BRACE",
  "{":   "LEFT_BRACKET",
  "}":   "RIGHT_BRACKET",
  ",":   "COMMA",
  ".":   "DOT",
  "-":   "MINUS",
  "+":   "PLUS",
  "/":   "SLASH",
  "*":   "STAR",
  "!":   "BANG",
  "!=":  "BANG_EQUAL",
  "=":   "EQUAL",
  "==":  "EQUAL_EQUAL",
  ">":   "GREATER",
  ">=":  "GREATER_EQUAL",
  "<":   "LESS",
  "<=":  "LESS_EQUAL",
  "\%":   "MODULO",
  "^":   "CARAT",
  "#":   "POUND",
  "&":   "AND",
  "|":   "PIPE",
  "?":   "QUESTION",
  ":":   "COLON",
  "@":   "SNAIL",
  "<<":  "LESS_LESS",
  ">>":  "GREATER_GREATER",
  "..":  "DOT_DOT",
  "...": "DOT_DOT_DOT",
  "**":  "STAR_STAR",
  "IDENTIFIER": "IDENTIFIER",
  "STRING": "STRING", // "STRING CONTENTS"
  "NUMBER": "NUMBER",

  // KEYWORDS AND STUFF
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

/**
 * The token class represents tokens that the scanner makes as it scans the
 * code.
 *
 * some values are optional, such as the literal and the lexeme
 */
class Token {

  type { _type }
  lexeme { _lexeme }
  literal { _literal }
  line { _line }

  type=(value) { _type = value }
  lexeme=(value) { _lexeme = value }
  literal=(value) { _literal = value }
  line=(value) { _line = value }

  /**
   * Constructs a new token.
   *
   * @param {String} type A Type found in `Tokens.all`.
   * @param {Number} start The start of the token in the source
   * @param {Number} length The length of the token.
   * @param {Number} line Line number the token is found on.
   */
  construct new(type, start, length, line) {
    _type = type
    _start = start
    _length = length
    _line = line
  }

  // Constructs an empty token
  construct new() {
    _type = ""
    _start = ""
    _length = ""
    _line = ""
  }

  /**
   * Returns a printable String
   *
   * @return {String} A printable string for debugging.
   */
  toString { paddedType + " => " + _lexeme }
  paddedType {
    var buff = "[%(_type)"
    while (buff.count < 12) {
      buff = buff + " "
    }
    return buff + "]"
  }

  /**
   * Returns a printable description
   *
   * @return {String} A printable string for debugging.
   */
  description { "(line:" + line + ") - " + type + "  " + lexeme + " " + literal }

  // returns the token for the index
  static typeFor(index) { TokenMap[index] }
}

class Tokens {

  /**
   * Returns a set of all tokens in TokenTypes
   *
   * @return {Sequence[String]} A Set of strings, all token types in TokenTypes.
   */
  static all { TokensTypes }

  /**
   * Checks for the presence of a token, and returns it's code if it's present.
   *
   * @return {String/false} Either a token code, or false.
   */
  static has(token) {
    if (all.contains(token)) {
      return all[token]
    }
    return false
  }

}

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

class Keywords {

  /**
   * Returns all keywords in AllKeywords
   *
   * @return {Sequence[String]} A set of strings.
   */
  static all { AllKeywords }

  /**
   * checks to see if a given lexeme is a valid token
   *
   * @return {String} Returns the token code if it's a Keyword, otherwise false
   */
  static [lexeme] {
    if (all.containsKey(lexeme)) {
      return all[lexeme]
    }
    return false
  }

}

/**
 * Local
 * Representation of a local value
 */
class Local {
  name { _name }
  length { _length }
  depth { _depth }
  isUpvalue { _isUpvalue }
  construct new(name, length, depth, isUpvalue) {
    _name = name
    _length = length
    _depth = depth
    _isUpvalue = isUpvalue
  }
}
