// Scanner.wren

// TODO: Rename to Compiler.
// Compiles Kona code into Wren.
// Eventually We'll modify the Wren compiler directly to generate Wren byte code
// from Kona Source code.
import "io"      for Stdin, Stdout, Directory
import "/token"  for Token, Keywords
import "/error"  for Error
import "/modules/StringTools" for StringTools

// an attempt to write a scanner in wren for fun.
class Scanner {

  /*
    State Setup
  */
  setupState() {
    _source = "hello friends (){},;\0"
    _tokens = []
    _start = 0 // The start of the current inspection pointer
    _current = 0 // the current inspection pointer position
    _line = 1

    // acceptable end characters
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
    _source = value // StringTools.ensureValudeEnding(value)
  }
  tokens { _tokens }
  current { _current }

  /*
    Constructors
  */
  // constructor with source
  // use this when parsing and scanning new code
  construct new(source) {
    setupState()
    if(source != null) {
      // _source = StringTools.ensureValidEnding(source)
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
    // begins at _start=0 and _current=0, which would get the first character
    // After we make a token match, somewhere in scanTokens we advance() then
    // start at the beginning of whatever comes next.
    while (isAtEnd() == false) {
      skipWhiteSpace()
      _start = _current
      scanToken()
    }

    // We're making byte code so at the end we always add and EOF token.
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
        _line = _line + 1
        advance()
        break
      } else {
        break
      }
    }

  }

  // identifier
  // adds an identifier token to the list of tokens
  identifierOrKeyword() {
    while ( isAlphaNumeric( peek() ) ) { advance() }

    var type = Keywords[_source[_start..._current]]
    if (!type) {
      addToken("IDENTIFIER", _source[_start..._current])
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
      if (peek() == "\n") { _line = _line + 1 }
      advance()
    }

    if (isAtEnd()) {
      Error.failure("unterminated string. at line: %(_line)")
      return null
    }

    advance()

    // We advance the start one to avoid the Quotation mark. and use the
    // exclusive `...` range operator which excludes the later number.
    addToken("STRING", _source[(_start+1)...(_current)])
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

  // peek()
  // peeks at the next character
  peek() { peek(0) }

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
    _tokens.add(Token.new(type, _source[_start.._current-1], literal, _line))
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
  isAtEnd() { _current >= _source.count }

  // advance()
  // advances the character checker forward.
  advance() {
    _current = _current + 1
    return getCurrent()
  }

  /**
   * Skips the current character and moves on to the next. Used to advance over
   * whitespace.
   */
  skip() { }

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
    } else  if (isAlphaNumeric(c)) {
      identifierOrKeyword()
    }
  }

  /*
    Definitions
  */

}
