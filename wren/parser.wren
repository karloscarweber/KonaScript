// Scanner.wren

// parses Kona code into Wren.
// Eventually We'll modify the Wren compiler directly to generate Wren byte code
// from Kona Source code.
// Heavily based on the Wren compiler to make our job easier down the line.
import "io"      for Stdin, Stdout, Directory
//import "/structs"  for Token, Keywords, Local
import "/modules/Extensions/error"  for Error
import "/modules/StringTools" for StringTools
import "/values" for VAL


// Constants
var MAX_LOCALS = 256
var MAX_UPVALUES = 256
//var MAX_CONSTANTS = (1 << 16) // Don't know how to do this yet
var MAX_CONSTANTS = 1024
var MAX_JUMP = 1024
var MAX_INTERPOLATION_NESTING = 8
var MAX_VARIABLE_NAME = 64
var ERROR_MESSAGE_SIZE = (80 + MAX_VARIABLE_NAME + 15)

/* local data structures */
// Token Types
// Token Types include special characters, and reserved words.
// They are global here because we need to access them
// in a lot of spots, will probably name space these later.
// TK.LEFT_PAREN // RETURNS THE NUMBER
// Tokens Namespace
class Tokens {
  static tokens {
    if (__tokens == null) __tokens = []
    return __tokens
  }
  static tokenLiterals {
    if (__token_literals == null) __token_literals = {}
    return __token_literals
  }
  static add(raw) {
    tokens.add(raw)
    tokenLiterals[raw] = (tokens.count - 1)
  }
  // receives an index, which is a number, and returns the string
  static [index] { tokens[index] }
  static get(index) { tokenLiterals[index] }
  static LEFT_PAREN { 0 }
  static RIGHT_PAREN { 1 }
  static LEFT_BRACE { 2 }
  static RIGHT_BRACE { 3 }
  static LEFT_BRACKET { 4 }
  static RIGHT_BRACKET { 5 }
  static COMMA { 6 }
  static DOT { 7 }
  static MINUS { 8 }
  static PLUS { 9 }
  static SLASH { 10 }
  static STAR { 11 }
  static BANG { 12 }
  static BANG_EQUAL { 13 }
  static EQUAL { 14 }
  static EQUAL_EQUAL { 15 }
  static GREATER { 16 }
  static GREATER_EQUAL { 17 }
  static LESS { 18 }
  static LESS_EQUAL { 19 }
  static MODULO { 20 }
  static CARAT { 21 }
  static POUND { 22 }
  static AND { 23 }
  static AND_AND { 24 }
  static PIPE { 25 }
  static QUESTION { 26 }
  static COLON { 27 }
  static SNAIL { 28 }
  static LESS_LESS { 29 }
  static GREATER_GREATER { 30 }
  static DOT_DOT { 31 }
  static DOT_DOT_DOT { 32 }
  static STAR_STAR { 33 }
  // KEYWORDS AND STUFF
  static AS  { 34 }
  static BREAK  { 35 }
  static CLASS  { 36 }
  static CONSTRUCT  { 37 }
  static CONTINUE  { 38 }
  static ELSE  { 39 }
  static FALSE  { 40 }
  static FOR  { 41 }
  static FOREIGN  { 42 }
  static IF  { 43 }
  static IMPORT  { 44 }
  static IN  { 45 }
  static IS  { 46 }
  static NULL  { 47 }
  static RETURN  { 48 }
  static REQUIRE  { 49 }
  static STATIC  { 50 }
  static SUPER  { 51 }
  static THIS  { 52 }
  static TRUE  { 53 }
  static VAR  { 54 }
  static WHILE  { 55 }
  static FIELD  { 56 }
  static STATIC_FIELD  { 57 }
  static NAME  { 58 }
  static NUMBER  { 59 }
  static STRING { 60 }
  static INTERPOLATION { 61 }
  static LINE { 62 }
  static ERROR { 63 }
  static EOF  { 64 }
}
var TK = Tokens
TK.add("(")              //        "LEFT_PAREN",
TK.add(")")              //       "RIGHT_PAREN",
TK.add("{")              //        "LEFT_BRACE",
TK.add("}")              //       "RIGHT_BRACE",
TK.add("[")              //      "LEFT_BRACKET",
TK.add("]")              //     "RIGHT_BRACKET",
TK.add(",")              //             "COMMA",
TK.add(".")              //               "DOT",
TK.add("-")              //             "MINUS",
TK.add("+")              //              "PLUS",
TK.add("/")              //             "SLASH",
TK.add("*")              //              "STAR",
TK.add("!")              //              "BANG",
TK.add("!=")             //        "BANG_EQUAL",
TK.add("=")              //             "EQUAL",
TK.add("==")             //       "EQUAL_EQUAL",
TK.add(">")              //           "GREATER",
TK.add(">=")             //     "GREATER_EQUAL",
TK.add("<")              //              "LESS",
TK.add("<=")             //        "LESS_EQUAL",
TK.add("\%")             //            "MODULO",
TK.add("^")              //             "CARAT",
TK.add("#")              //             "POUND",
TK.add("&")              //               "AND",
TK.add("&&")             //           "AND_AND",
TK.add("|")              //              "PIPE",
TK.add("?")              //          "QUESTION",
TK.add(":")              //             "COLON",
TK.add("@")              //             "SNAIL",
TK.add("<<")             //         "LESS_LESS",
TK.add(">>")             //   "GREATER_GREATER",
TK.add("..")             //           "DOT_DOT",
TK.add("...")            //       "DOT_DOT_DOT",
TK.add("**")             //         "STAR_STAR",
TK.add("as")             //                "AS",
TK.add("break")          //             "BREAK",
TK.add("class")          //             "CLASS",
TK.add("construct")      //         "CONSTRUCT",
TK.add("continue")       //          "CONTINUE",
TK.add("else")           //              "ELSE",
TK.add("false")          //             "FALSE",
TK.add("for")            //               "FOR",
TK.add("foreign")        //           "FOREIGN",
TK.add("if")             //                "IF",
TK.add("import")         //            "IMPORT",
TK.add("in")             //                "IN",
TK.add("is")             //                "IS",
TK.add("null")           //              "NULL",
TK.add("return")         //            "RETURN",
TK.add("require")        //           "REQUIRE",
TK.add("static")         //            "STATIC",
TK.add("super")          //             "SUPER",
TK.add("this")           //              "THIS",
TK.add("true")           //              "TRUE",
TK.add("var")            //               "VAR",
TK.add("while")          //             "WHILE",
TK.add("FIELD")          //             "FIELD",
TK.add("STATIC_FIELD")   //      "STATIC_FIELD",
TK.add("NAME")           //              "NAME",
TK.add("NUMBER")         //            "NUMBER",
TK.add("STRING")         //            "STRING",
TK.add("INTERPOLATION")  //     "INTERPOLATION",
TK.add("LINE")           //              "LINE",
TK.add("ERROR")          //             "ERROR",
TK.add("EOF")            //               "EOF",

/**
 * The token class represents tokens that the scanner makes as it scans the
 * code.
 *
 * some values are optional, such as the literal and the lexeme
 */
class Token {
  static new(type, start, length, line, value) {
    return { 
      "type": type, 
      "start": start, 
      "length": length, 
      "line": line,
      "value": value }
  }
  static new() { new(null,null,null,null,null)}
  static toString(token) {
    return "%(TK[token["type"]]) %(token["start"])[%(token["length"])]:%(token["line"]) = %(token["value"]) "
  }
}

/**
 * Local
 * Representation of a local value
 */
class Local {
  static new(name, length, depth, isUpvalue) {
    var local = {
      "name": name,
      "length": length,
      "depth": depth,
      "isUpvalue": isUpvalue
    }
    return local
  }
}

class CompilerUpvalue {
  static new(index, isLocal) {
    var local = { "index": index, "isLocal": isLocal }
    return local
  }
}

var nameCharacters = [
 "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
 "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","A","A","Z",
 "_"]
var digitCharacters = ["0","1","2","3","4","5","6","7","8","9",]

// static function container for stuff
class Isa {
  
  static nameCharacters { 
    if (__nameCharacters) return __nameCharacters
    __nameCharacters = [
     "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
     "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","A","A","Z",
     "_"]
     return __nameCharacters
  }
  static digitCharacters {
    if (__digitCharacters) return __digitCharacters
    __digitCharacters = ["0","1","2","3","4","5","6","7","8","9",]
     return __digitCharacters 
  }
 
 // acceptable end characters
 static name(c)  { nameCharacters.contains(c) }
 
 // digit(_)
 // checks if the supplied character is a digit
 static digit(c) { digitCharacters.contains(c) }
 
 // digiNameric(_)
 // checks to see if the supplied character is alphanumeric and can include
 // an underscore. It's silly, I know.
 static digiNameric(c) { name(c) || digit(c) }
 
 // newline(_)
 // retruns true if supplied character is a new line.
 static newline(c) { c=="\n" }
 
 // returns true if c is whitespace but not a newline.
 static whitespace(c) { (c==" "||c=="/r"||c=="/t") }

}

// An attempt to write a parser in wren for fun.
// It parses Wren at first, then it should parse The theoretical Kona
class Parser {

  /*
    Compiler stuff
  */

  // scanTokens
  // The main loop to scan tokens in the provided source
  scanTokens() {
    // begins at _start=0 and _current=0, which would get the first character
    // After we make a token match, somewhere in scanTokens we advance() then
    // start at the beginning of whatever comes next.
    while (isAtEnd() == false) {
      skipWhiteSpace()
      _tokenStart = _currentPos
      nextToken()
    }

    // We're making byte code so at the end we always add and EOF token.
    _tokens.add(Token.new("EOF", "", "", 1))
    return _tokens
  }

  // spitTokens
  // Method to print the tokens that have been scanned.
  spitTokens() {
    for (token in _tokens) {
      System.print(Token.toString(token))
    }
  }

  /*
    Token  Creation

    Methods that transform a lexeme into a token and move the parser along.
  */
  skipWhiteSpace() {
    while (true) {
      var c = peek()
      if (c == " ")  {
        advance()
      } else  if (c == "/r") {
        advance()
      } else  if (c == "/t") {
        advance()
      } else  if (c == "/n") {
        // we advance the line number forward to track lines. but otherwise, treat
        // this like other whitespace.
        _currentLine = _currentLine + 1
        advance()
        break
      } else {
        break
      }
    }

  }
  

  // nameOrKeyword
  // adds a nameOrKeyword token to the list of tokens
  nameOrKeyword() {
    while ( isAlphaNumeric( peek() ) ) { advance() }

    var lit = _source[_start..._current]
    var type = TK.get[lit]
    if (!type) {
      addToken("NAME", TK[lit])
    } else {
      addToken(type)
    }
  }

  // number
  // adds a number literal to the list of tokens
  number() {
    while (isDigit(peek())) { advance() }
    if (peek() == "." && isDigit(peekNext())) {
      advance()
      while (isDigit(peek())) { advance() }
    }

    addToken("NUMBER")
  }

  // string()
  // adds a string literal to the list of tokens
  string() {
    advance()
    while (peek() != "\"" && !isAtEnd() ) {   //"
      if (peek() == "\n") { _currentLine = _currentLine + 1 }
      advance()
    }

    if (isAtEnd()) {
      Error.failure("unterminated string. at line: %(_currentLine)")
      return null
    }

    advance()

    // We advance the start one to avoid the Quotation mark. and use the
    // exclusive `...` range operator which excludes the later number.
    addToken("STRING", _source[(_start+1)...(_current)])
  }

  // getCurrent()
  // gets the current character
  getCurrent() { getCurrent(0) }

  /**
   * Gets the current character
   */
  getCurrent(step) {
    if (isAtEnd()) {
      return "\0"
    }
    return _source[_current+step.._current+step]
  }
  
  
  


  // makeToken(_)
  // makes a token and adds it to the party.
  // accepts the token index
  // the way the parser works is that it sets the parser's current token
  // to this.
  makeToken(type, value) {
    var token = Token.new()
    token["type"] = type
    token["start"] = _tokenStart
    token["length"] = currentTokenLength
    token["line"] = _currentLine
    token["value"] = value
    
    // forces newlines to appear on the line they appear.
    // otherwise they would be on the next line.
    if (type == TK.LINE) token["line"] = token["line"] - 1
    tokens.add(token)
    return token
  }
  
  // for when we don't have values for a token
  makeToken(type) { makeToken(type, null) }

  /*
    Utilities
  */

  // isAtEnd
  // checks against the end of the document
  isAtEnd() { _currentPos == _source.count - 1 }
  currentTokenLength { currentLexeme.count }
  
  // Parsing -------------------------------------------------------------------

  // Lex the next token and store it in [next]
  nextToken() {
  
    // references the tokens
    _previous = _current
    _current = _next // notice that we don't set _next here, we do it somewhere else.

    // if we're out of tokens, don't tokenize more.
    if (_next.type == TK.EOF) return
    if (_current.type == TK.EOF) return
    
    // The loop works to match tokens, tokens are made inside this loop.
    // each token has a kind of character that begins it's parsing. Then
    // more detailed logic is applied to continue advancing 
    while (peekChar() != "\0") {
      _tokenStart = _currentPos
      
      // get the next Character, and advances the character checker
      var c = nextChar()
      // from here on out currentPos is advanced, so we can't count on that,
      // to get the current character, because we already have it. 
      // massive switch statement
      if (c == "(") {
        // Because we're modeling this parser after Wren, we need to count the
        // unmatched '(' when we're in an interpolated expression
        if (_numParens > 0) parens[_numParens - 1] = parens[_numParens - 1] + 1
        makeToken(TK.LEFT_PAREN)
      } else  if (c == ")") {
        // If we're interpolating, then count the ')'
        if (_numParens > 0 && ((parens[_numParens - 1]) - 1) == 0) {
          // Final ")", so the interpolation ends
          // now begins next portion of the template string
          _numParens = _numParens - 1
          //readString() // fill this in soon
        }
        makeToken(TK.RIGHT_PAREN)
      } else if (c == "{") {
        makeToken(TK.LEFT_BRACE)
      } else if (c == "}") {
        makeToken(TK.RIGHT_BRACE)
      } else if (c == "[") {
        makeToken(TK.LEFT_BRACKET)
      } else if (c == "]") {
        makeToken(TK.RIGHT_BRACKET)
      } else if (c == ",") {
        makeToken(TK.COMMA)
      } else if (c == ".") {
        if (peekChar() == ".") {
          nextChar()
          if (peekChar() == ".") {
            nextChar()
            makeToken(TK.DOT_DOT_DOT)
            break
          }
          makeToken(TK.DOT_DOT)
          break
        }
        makeToken(TK.DOT)
      } else if (c == "-") {
        makeToken(TK.MINUS)
      } else if (c == "+") {
        makeToken(TK.MINUS)
      } else if (c == "*") {
        if (peekChar() == "*") {
          nextChar()
          makeToken(TK.STAR_STAR)
          break
        }
        makeToken(TK.STAR)
      } else if (c == "!") {
        if (peekChar() == "=") {
          nextChar()
          makeToken(TK.BANG_EQUAL)
          break
        }
        makeToken(TK.BANG)
      } else if (c == "=") {
        if (peekChar() == "=") {
          nextChar()
          makeToken(TK.EQUAL_EQUAL)
          break
        }
        makeToken(TK.EQUAL)
      } else if (c == "<") {
      
        if (peekChar() == "<") {
          nextChar()
          makeToken(TK.LESS_LESS)
          break
        } else if (peekChar() == "=") {
          nextChar()
          makeToken(TK.LESS_EQUAL)
          break
        }
        
        makeToken(TK.LESS)
      } else if (c == ">") {
        
        if (peekChar() == ">") {
          nextChar()
          makeToken(TK.GREATER_GREATER)
          break
        } else if (peekChar() == "=") {
          nextChar()
          makeToken(TK.GREATER_EQUAL)
          break
        }
        
        makeToken(TK.GREATER)
      } else if (Isa.name(c)) {
        // This block should be moved to a function that grabs all the charac-
        // ters for the name and adds the token. Doing it here for brevity
        // and simplicity first.
        while (Isa.name(peekChar())) nextChar()
        var cl = currentLexeme
        
        if (TK.get(cl)) {
          makeToken(TK.get(cl), cl)
        } else {
          makeToken(TK.NAME, cl)  
        }
      } else if (Isa.whitespace(c)) {
        // do nothing
      } else if (Isa.newline(c)) {
        makeToken(TK.LINE)
      } else {
        // catch all other tokens as null token for now.
        makeToken(TK.NULL)
      }
      
      //}
      // } else  if (c == "!") {
      //   if (match("=") == true) { addToken("!=") } else {  addToken("!") }
      // } else  if (c == "=") {
      //   if (match("=") == true) { addToken("==") } else { addToken("=") }
      // } else  if (c == "<") {
      //   if (match("=") == true) { addToken("<=") } else { addToken("<") }
      // } else  if (c == ">") {
      //   if (match("=") == true) { addToken(">=") } else { addToken(">") }
      // } else  if (c=="/") {
      //   if (match("/")) {
      //     // comments go to the end of the line
      //     // so we try to consume everythign we can.
      //     while ( peek() != "\n" && !isAtEnd() ) { advance() }
      //   } else {
      //     addToken("/")
      //   }
      // } else  if (c == "\"") { /*"*/
      //   // We call the special string method to figure out what to do.
      //   string()
      // } else  if (isDigit(c)) {
      //   number()
      // } else  if (isName(c)) {
      //   System.print("Supposeedly a keyword %(c)")
      //   nameOrKeyword()
      // }

    }
    
    // If we get to this point, it' means we've reached the end of the source
    _tokenStart = _currentPos
  }

  // peeks at the next character, doesn't consume it.
  peekChar() { _source[_currentPos] }
  // peeks at the next character
  peekNextChar() {
    // Don't read past the end of the source file
    if (peekChar() == "\0") return "\0"
    return currentChar(1)
  }

  // Get the next character
  // advances the current position forward
  nextChar() {
    var c = peekChar()
    _currentPos = _currentPos + 1
    if (c == "\n") _currentLine = _currentLine + 1
    return c
  }
  
  // returns the type of the current token
  peek() { _current.type }
  // returns the type of the next token
  peekNext() { _next.type }
  
  // returns true if we match a token type
  match(expected) {
    if (peek() != expected) return false
    nextToken()
    return true
  }
  
  // isWhitespace
  // returns true if the peeked token is whitespace
  isWhitespace() {
    var c = peek()
    if (c==" "||c=="/r"||c=="/t"||c=="/n") {
      return true
    }
    return false
  }
  
  // isName
  // Checks to see if the current character is a name
  isName(c) { Isa.name(c) }

  /**
   * Skips the current character and moves on to the next. Used to advance over
   * whitespace.
   */
  skip() { advance() }
  advance() { _currentPos = _currentPos + 1 }
  
  /*
    Accessors
    For testing purposes
  */
  source { _source }
  source=(value) { _source = value }
  tokens { _tokens }
  currentChar { currentChar(0) } // current character
  currentLexeme { source[_tokenStart..(_currentPos - 1)] }
  
  /*
    Constructors
  */
  // constructor with source
  construct new(source) { _source = source}
  static new() { new("hello friends (){},;\0") }
  
  // Starts the scanner
  // creates a list of tokens that can then be compiled.
  konaScan() {    
    // setup state
    _module = "Main"
    
    // Add a null terminator if it's not there.
    // We need to do this because Strings in Wren don't have null terminators.
    // that's a C thing. And we need that C thing.
    if (_source[_source.count - 1] != "\0") _source = _source + "\0"
    
    // we're storing tokens in our parser because it's a trial run of the real thing
    /// and we want to figure out how this works
    _tokens = []
    
    _tokenStart = 0 // The start of the current inspection pointer
    _currentPos = 0 // the current inspection pointer position
    _currentLine = 1 // The current line
    _numParens = 0
    
    // tokens
    // set up the null tokens
    _next = Token.new(TK.ERROR, 0, 0, 0, VAL.UNDEFINED)
    _current = null
    _previous = null
    
    _parens = 255 // maximum number of parens
    _numParens = 0 // current number of parens, important for nested stuff.
    
    // while the current count is less, advance.
    while (!isAtEnd()) {
      nextToken()
    }
    
    makeToken(TK.EOF)
  }

  // Scans Tokens
  scanToken() {

    // At this point advance() moves the token forward one step ahead of start.
    // Starting from the beginning it would be _start = 0, _current = 1.
    // use _source[_start..._current] to get the current character. the `..` is
    // exclusive. That means it leaves off index at the end. _current will
    // always be at least ahead by 1.
    //
    // Some of our matchers below also advance, but don't advance at the end of
    // their blocks. This is because to do so would the move the _start forward
    // to many places.
    var c = advance()

    // massive switch statement
    if (c == "(") {
      addToken("(")
    } else  if (c == ")") {
      addToken(")")
    } else  if (c == "{") {
      addToken("{")
    } else  if (c == "}") {
      addToken("}")
    } else  if (c == "[") {
      addToken("[")
    } else  if (c == "]") {
      addToken("]")
    } else  if (c == ",") {
      addToken(",")
    } else  if (c == ".") {
      addToken(".")
    } else  if (c == "-") {
      addToken("-")
    } else  if (c == "+") {
      addToken("+")
    } else  if (c == ";") {
      addToken(";")
    } else  if (c == "*") {
      addToken("*")
    } else  if (c == "!") {
      if (match("=") == true) { addToken("!=") } else {  addToken("!") }
    } else  if (c == "=") {
      if (match("=") == true) { addToken("==") } else { addToken("=") }
    } else  if (c == "<") {
      if (match("=") == true) { addToken("<=") } else { addToken("<") }
    } else  if (c == ">") {
      if (match("=") == true) { addToken(">=") } else { addToken(">") }
    } else  if (c=="/") {
      if (match("/")) {
        // comments go to the end of the line
        // so we try to consume everythign we can.
        while ( peek() != "\n" && !isAtEnd() ) { advance() }
      } else {
        addToken("/")
      }
    } else  if (c == " ")  {
      // We do nothing here to fall through scanner.
      // If we're not at the end, the scanner will start over at the next
      // character.
    } else  if (c == "/r") { /* Do Nothing */
    } else  if (c == "/t") { /* Do Nothing */
    } else  if (c == "\"") { /*"*/
      // We call the special string method to figure out what to do.
      string()
    } else  if (isDigit(c)) {
      number()
    } else  if (isName(c)) {
      System.print("Supposeedly a keyword %(c)")
      nameOrKeyword()
    }
  }
}
