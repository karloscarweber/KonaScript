// kona.js

// Establish Kona namespace
Kona = {}

// a Chunk of Kona Code:
Kona.chunk = {}

// Kona Tokens and Grammer are defined here.
Kona.tokens = {
  // keywords:[],
  // symbols:[],
  // binary_operators:[],
  // unary_operations:[],
  // statements:[],
  // declarations:[],
  // lexicon:[], // The lexical grammer,
}

/*
** Scanner
**
** The Kona scanner object thing
*/
Kona.scanner = {
  // make a new scanner object
  new: function(src){
    var s = {
      start:0,
      current:0,
      line:0,
      source:src,
      tokens:[]}
    Kona.scanner.scan(s);
    return s;
  },
  chc: function(c) {
    return c.charCodeAt(0);
  },
  isAlpha: function(ch){
    var c = KS.chc(ch);
    return (c >= 97 && c <= 122) ||
     (c >= 65 && c <= 90) ||
     c == 95;
     /* "a" == 97, "z" == 122, "A" == 65, "Z" == 90, "_" == 95 */
  },
  identifier: function(s) {
    while (KS.isAlpha(KS.peek(s)) || KS.isDigit(KS.peek(s)) ) { advance() }
    return KS.makeToken(s, KS.identifierType());
  },
  isDigit: function(ch) {
    var c = KS.chc(ch);
    return (c >= 48 && c <= 57);
    /* "0" == 48, "9" == 57 */
  },
  makeToken: function(s, type) {
    token = {
      type: type,
      start: s.start,
      length: s.current - s.start, // by the time makeToken is called, advance() is first called, making start one ahead of s.current.
      line: s.line
    }
  },
  // skipWhitespace()
  checkKeyword: function (s, start, length, rest, type) {
    if (s.current - s.start == start + length && ) {
      return type;
    }
    return KT.IDENTIFIER
  },
  identifierType: function (s) {
    switch(s.substring(s.start,s.current)) {
      case 'a':
        return checkKeyword(1,2,"nd", KT.AND);
        break;
      default:
        return KT.AND
    }
  },
  peek: function(s) { return s.source.substr(s.current+1,1) },
  char: function(s) { return s.source.substr(s.current,1) },
  advance: function(s) {
    s.current = s.current+1;
    return KS.char(s);
  },
  isAtEnd: function(s){
    if (s.current == s.source.length) { return true }
    return false
  },
  scanToken: function(s){
    // skip whitespace
    s.start = s.current;
    if (KS.isAtEnd(s)) { return KS.makeToken(s, KT.EOF) }

    var c = KS.advance();

    if (KS.isAlpha(c)) return KS.identifier(s);
    if (KS.isDigit(c)) return KS.number(s);

  },
  // scans the tokens and saves them as... tokens
  scan: function(s){
    while (!KS.isAtEnd(s)) {
      console.log(KS.char(s));
      KS.advance(s);
    }
  },
}
Kona.tokens = {
    // Single-character tokens.
    NULL_TERMINATOR: 0x00,
    // GROUPINGS
    LEFT_PAREN:      0x01, RIGHT_PAREN:     0x02,
    LEFT_BRACE:      0x03, RIGHT_BRACE:     0x04,
    LEFT_BRACKET:    0x05, RIGHT_BRACKET:   0x06,

    PLUS:            0x07, MINUS:           0x08,
    STAR:            0x09, SLASH:           0x0A,
    SPRINT:          0x0B, CARAT:           0x0C,
    AMPERSAND:       0x0D, TILDE:           0x0E,
    PIPE:            0x0F, LESS_LESS:       0x10,
    GREATER_GREATER: 0x11, DOUBLE_SLASH:    0x12,
    MEMO_IDIOM:      0x13,
    EQUAL:           0x14, EQUAL_EQUAL:     0x15,
    NOT_EQUAL:       0x16, PIPE_EQUAL:      0x17,
    LESS:            0x18, LESS_EQUAL:      0x19,
    GREATER:         0x1A, GREATER_EQUAL:   0x1B,


    SEMICOLON:       0x1C, COLON:           0x1D,
    COMMA:           0x1E, DOT:             0x1F,
    DOT_DOT:         0x20, DOT_DOT_DOT:     0x21,
    COLON_COLON:     0x22,
    QUESTION:        0x23, EXCLAMATION:     0x24,

    // Literals
    IDENTIFIER:      0x25,
    STRING:          0x26,
    NUMBER:          0x27,
    NIL:             0x28,

    // Keywords
    AND:     0x29,  BREAK:   0x2A,
    CASE:    0x2B,  CONTINUE:0x2C,
    CLASS:   0x2D,  DEF:     0x2E,
    DO:      0x2F,  ELSE:    0x30,
    END:     0x31,  ENUM:    0x32,
    FALSE:   0x33,  FOR:     0x34,
    FUN:     0x35,  GOTO:    0x36,
    IF:      0x37,  IN:      0x38,
    LET:     0x39,  MODULE:  0x3A,
    //NIL:   0x28,
    NOT:     0x3B,
    OR:      0x3C,  REPEAT:  0x3D,
    RETURN:  0x3E,  SELF:    0x3F,
    SUPER:   0x40,  SWITCH:  0x41,
    THEN:    0x42,  TRUE:    0x43,
    UNTIL:   0x44,  UNLESS:  0x45,
    WHEN:    0x46,  WHILE:   0x47,

    // UTILITY
    NEWLINE:        0x48,
    CARRIAGE:       0x49,
    ERROR:          0x4A,
    EOF:            0x4B,
}
Kona.precedence = { // sorted low to high
  NONE,
  ASSIGNMENT, // = ||=
  OR,         // OR, ||
  AND,        // AND
  EQUALITY,   // == !=
  COMPARISON, // < > <= >=
  TERM,       // + -
  FACTOR,     // * / % ^
  UNARY,      // . () << >> & $ ? !
  PRIMARY
}
// Other tokens:
// ```
//   (     )     {     }     [     ]
//   +     -     *     /     %     ^
//   &     ~     |     <<    >>    //    ||=
//   ==    ~=    <=    >=    <     >     =
//   ;     :     ,     .     ..    ...   ::
//   ?     !
// ```

Kona.keywords = {
}

// MAKE SOME DECISIONS
const KS = Kona.scanner
const KT = Kona.tokens

// Compiles Kona tokens into function code.
Kona.compiler = {}
// A collection of Kona primitive types
Kona.types = [
  /* Number  */ { new:"", proto:{}, definition:"" },
  /* String  */ { new:"", proto:{}, definition:"" },
  /* Closure */ { new:"", proto:{}, definition:"" },
  /* Array   */ { new:"", proto:{}, definition:"" },
  /* Hash    */ { new:"", proto:{}, definition:"" },
  /* Table   */ { new:"", proto:{}, definition:"" },
]

// Function operations, This is what the
Kona.funops = {}
// Kona Standard library of Kona script function stuff.
Kona.stdlib = {}
// Kona Virtual machine.
// This is the object that is executed, and looped to get the Kona environment running.
Kona.vm = {
  constants:[],
  symbols:[],
  strings:[],
  chunks:[],
  object:[],
  interpret:function(src){
    var chunk = {}
    Kona.vm.chunks.append(chunk)
    return Kona.compile(src,chunk)
  } // interprets Kona code.
}

scanny = Kona.scanner.new("5 + 10");
