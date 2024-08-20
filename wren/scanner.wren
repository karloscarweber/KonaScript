// Scanner.wren

// TODO: Rename to Compiler.
// Compiles Kona code into Wren.
// Eventually We'll modify the Wren compiler directly to generate Wren bytecode
// from Kona Source code.
import "io" for Stdin, Stdout, Directory
import "/token" for Token, Keywords
import "/error" for Error

// an attempt to write a scanner in wren for fun.
class Scanner {

  /*
    State Setup
  */
  setupState() {
    _source = "hello friends (){},;\n"
    _tokens = []
    _start = 0
    _current = 0
    _line = 1

    // acceptable end characters
    _endings = ["\n","\r","\0"]
    _alphaCharacters = [
    "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
    "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","A","A","Z",
    "_"]
    _digitCharacters = ["0","1","2","3","4","5","6","7","8","9",]
  }

  /*
    Accessors
  */
  source { _source }
  source=(value) {
    if (!_endings.contains(value[(value.count-1)..(value.count-1)])) {
      _source = value + "\0"
    } else {
      _source = value
    }
  }
  tokens { _tokens }

  /*
    Constructors
  */
  // constructor with source
  // use this when parsing and scanning new code
  construct new(source) {
    setupState()
    if(source != null) {
      _source = source
    }
  }

  // constructor without source
  // use this for kicks and giggles.
  construct new() { setupState() }

  /*
    Scanner stuff
  */

  // scanTokens
  // The main loop to scan tokens in the provided source
  scanTokens() {
    while (isAtEnd() == false) {
      _start = _current
      scanToken()
    }

    _tokens.add(Token.new("EOF", "", "", 1))
    return _tokens
  }

  // spitTokens
  // Method to print the tokens that have been scanned.
  spitTokens() {
    for (token in _tokens) {
      System.print(token.toString)
    }
  }

  /*
    Token  Creation

    Methods that transform a lexeme into a token and move the scanner along.
  */

  // identifier
  // adds an identifier token to the list of tokens
  identifier() {
    while ( isAlphaNumeric( peek() ) ) { advance() }

    // This next part will need to be rewritten
    // in Lua, you can use strings as indexes, so here we're checking
    // to see if the current identifier is a keyword, if not, then
    // the type is an IDENTIFIER.
    var type = Keywords[_source[_start...(_current)]]
    if (!type) { type = "IDENTIFIER" }
    addToken(type)
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
      if (peek() == "\n") { _line = _line + 1 }
      advance()
    }

    if (isAtEnd() ) {
      Error.failure("unterminated string. at line: %(_line)")
      return null
    }

    advance()

    // String token literals don't include their quotation marks,
    // The first and last character in the string.
    addToken("STRING", _source[(_start+1)..(_current-1)])
  }

  // match(_)
  // checks against an expected value
  match(expected) {
    if ( isAtEnd() || getCurrent() != expected ) {
      return false
    }

    _current = _current + 1
    return true
  }

  // getCurrent()
  // gets the current character
  getCurrent() {
    return getCurrent(0)
  }

  // getCurrent(_)
  // gets the current character
  getCurrent(step) {
    return _source[(_current+step)..(_current+step)]
  }

  // peek()
  // peeks at the next character
  peek() {
    return peek(0)
  }

  // peek(_)
  // peeks at the next character, at step
  peek(step) {
    if (isAtEnd()) {
      return "\0"
    }
    return getCurrent()
  }

  // peekNext()
  // peeks at the next next character
  peekNext() {
    if (_current + 1 >= _source.count) {
      return "\0"
    }
    return getCurrent(1)
  }

  // peekBack()
  // peeks at the previous character
  peekBack() {
    // short circuits to see if it's the end.
    if (_current == _source.count) {
      return "\0"
    }
    return getCurrent(-1)
  }

  // addToken(_)
  // Adds a token of given type.
  // type is probably a keyword.
  addToken(type) {
    _tokens.add(Token.new(type, _source[_start.._current-1], "", _line))
  }

  // addToken(_,_)
  // Adds a token of give type, with literal provided.
  addToken(type, literal) {
    _tokens.add(Token.new(type, _source[_start.._current], literal, _line))
  }

  /*
    Utilities
  */
  // isAlpha(_)
  // checks the character to see if it's alphabetic
  isAlpha(c) { _alphaCharacters.contains(c) }

  // isDigit(_)
  // checks if the supplied character is a digit
  isDigit(c) { _digitCharacters.contains(c) }

  // isAlphaNumeric(_)
  // checks to see if the supplied character is alphanumeric
  isAlphaNumeric(c) { isAlpha(c) || isDigit(c) }

  // isAtEnd
  // checks against the end of the document
  isAtEnd() {
    // System.print("End: (%(_current))..(%(_source.count)) %(_current >= _source.count)")
    return _current >= (_source.count -1)
  }

  // advance()
  // advances the character checker forward.
  advance() {
    _current = _current + 1
    return getCurrent()
  }

  // Scans Tokens
  scanToken () {
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
        while ( peek() != "\n" && !isAtEnd() ) { advance() }
      } else {
        addToken("/")
      }
    } else  if (c == " ")  { /* Do Nothing */
    } else  if (c == "/r") { /* Do Nothing */
    } else  if (c == "/t") { /* Do Nothing */
    } else  if (c == "/n") {
      _line = _line + 1
    } else  if (c == "\"") { /*"*/
      string()
    } else  if (isAlphaNumeric(c)) {
      identifier()
    }
  }

  /*
    Definitions
  */

}
