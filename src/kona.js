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
      line:1,
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
    while (KS.isAlpha(KS.peek(s)) || KS.isDigit(KS.peek(s)) ) { KS.advance(s) }
    return KS.makeToken(s, KS.identifierType(s));
  },
  isDigit: function(ch) {
    var c = KS.chc(ch);
    return (c >= 48 && c <= 57);
    /* "0" == 48, "9" == 57 */
  },
  makeToken: function(s,type) {
    return {
      type: type,
      start: s.start,
      length: s.current - s.start, // by the time makeToken is called, advance() is first called, making start one ahead of s.current.
      line: s.line
    }
  },
  // skipWhitespace()
  checkKeyword: function (s,lookahead,type) {
    if (KTL[type] == KS.word(s,lookahead)) {
      return type;
    }
    return KT.IDENTIFIER
  },
  identifierType: function (s) {
    switch(KS.char(s)) {
      case 'a': return checkKeyword(s,2,KT.AND); break;
      case 'b': return checkKeyword(s,4,KT.BREAK); break;
      case 'c':
        switch (KS.peek(s)) {
            case 'a': return checkKeyword(s,3,KT.CASE); break;
            case 'o': return checkKeyword(s,7,KT.CONTINUE); break;
            case 'l': return checkKeyword(s,4,KT.CLASS); break;
        }
        break;
      case 'd':
        switch (KS.peek(s)) {
          case 'e': return checkKeyword(s,2,KT.DEF); break;
          case 'o': return checkKeyword(s,1,KT.DO); break;
        }
        break;
      case 'e':
        switch (KS.peek(s)) {
          case 'l': return checkKeyword(s,3,KT.ELSE); break;
          case 'n':
            switch (KS.doublePeek(s)) {
              case 'd': return checkKeyword(s,2,KT.END); break;
              case 'u': return checkKeyword(s,3,KT.ENUM); break;
            }
            break;
        }
        break;
      case 'f':
        switch (KS.peek(s)) {
          case 'a': return checkKeyword(s,4,KT.FALSE); break;
          case 'o': return checkKeyword(s,2,KT.FOR); break;
          case 'u': return checkKeyword(s,2,KT.FUN); break;
        }
        break;
      case 'g': return checkKeyword(s,3,KT.GOTO); break;
      case 'i':
        switch (KS.peek(s)) {
          case 'f': return checkKeyword(s,1,KT.IF); break;
          case 'n': return checkKeyword(s,1,KT.IN); break;
        }
        break;
      case 'l': return checkKeyword(s,2,KT.LET); break;
      case 'm': return checkKeyword(s,5,KT.MODULE); break;
      // case 'n': return checkKeyword(s,2,KT.NOT); break;
      case 'n':
        switch (KS.peek(s)) {
          case 'i': return checkKeyword(s,2,KT.NIL); break;
          case 'o': return checkKeyword(s,2,KT.NOT); break;
        }
        break;
      case 'o': return checkKeyword(s,1,KT.OR); break;
      case 'r':
        // e is assumed so we double peek
        switch (KS.doublePeek(s)) {
          case 'p': return checkKeyword(s,5,KT.REPEAT); break;
          case 't': return checkKeyword(s,5,KT.RETURN); break;
        }
        break;
      case 's':
        switch (KS.peek(s)) {
          case 'e': return checkKeyword(s,3,KT.SELF); break;
          case 'u': return checkKeyword(s,4,KT.SUPER); break;
          case 'w': return checkKeyword(s,5,KT.SWITCH); break;
        }
        break;
      case 't':
        switch (KS.peek(s)) {
          case 'h': return checkKeyword(s,3,KT.THEN); break;
          case 'r': return checkKeyword(s,3,KT.TRUE); break;
        }
        break;
      case 'u':
        // n is assumed so we double peek
        switch (KS.doublePeek(s)) {
          case 't': return checkKeyword(s,4,KT.UNTIL); break;
          case 'l': return checkKeyword(s,5,KT.UNLESS); break;
        }
        break;
      case 'w':
        // h is assumed so we double peek
        switch (KS.doublePeek(s)) {
          case 'e': return checkKeyword(s,3,KT.WHEN); break;
          case 'i': return checkKeyword(s,4,KT.WHILE); break;
        }
        break;
      default: // default is identifier
        return KT.IDENTIFIER
    }
  },
  number: function(s) { // returns a Token
    while (KS.isDigit(KS.peek(s))) { KS.advance(s)};
    // look for a decimal point
    if (KS.peek(s) == '.' && KS.isDigit(KS.peekNext(s))) {
      KS.advance(s);
      while (KS.isDigit(KS.peek(s))) { KS.advance(s)};
    }
    return KS.makeToken(s,KT.NUMBER);
  },
  string: function(s) {
    while (KS.peek(s) != '"' || KS.peek(s) != '\\') {KS.advance(s)};
    // check for a \ for an escape sequence. we will of course handle this
    // later. Than add the escape sequenced value to the string.
    return KS.makeToken(s,KT.STRING);
  },
  peek: function(s) { return s.source.substr(s.current+1,1) }, // returns one character ahead of current character.
  doublePeek: function(s) { return s.source.substr(s.current+2,1) }, // returns one character double ahead of current character.
  TRIPLEPeek: function(s) { return s.source.substr(s.current+3,1) }, // returns one character TRIPLE ahead of current character.
  char: function(s) { return s.source.substr(s.current,1) }, // gets the current character
  advanceChar: function(s) { return s.source.substr(s.current-1,1) },
  word: function(s,lookahead) { return s.source.substr(s.start,1+lookahead) }, // get the current word
  advance: function(s) { // Advances the character
    s.current = s.current+1;
    return KS.advanceChar(s);
  },
  isAtEnd: function(s){
    if (s.current == s.source.length) { return true }
    return false
  },
  scanToken: function(s){
    // skip whitespace
    s.start = s.current;
    if (KS.isAtEnd(s)) { return KS.makeToken(s, KT.EOF) }

    var c = KS.advance(s);

    if (KS.isAlpha(c)) { return KS.identifier(s) }
    if (KS.isDigit(c)) { return KS.number(s) }

    switch (c) {
        case '(': return makeToken(s, KT.LEFT_PAREN); break;
        case ')': return makeToken(s, KT.RIGHT_PAREN); break;
        case '{': return makeToken(s, KT.LEFT_BRACE); break;
        case '}': return makeToken(s, KT.RIGHT_BRACE); break;
        case '[': return makeToken(s, KT.LEFT_BRACKET); break;
        case ']': return makeToken(s, KT.RIGHT_BRACKET); break;
        case '+': return makeToken(s, KT.PLUS); break;
        case '-': return makeToken(s, KT.MINUS); break;
        case '%': return makeToken(s, KT.SPRINT); break;
        case '^': return makeToken(s, KT.CARAT); break;
        case '&': return makeToken(s, KT.AMPERSAND); break;
        case '~': return makeToken(s, KT.TILDE); break;
        case ';': return makeToken(s, KT.SEMICOLON); break;
        case ',': return makeToken(s, KT.COMMA); break;
        case '?': return makeToken(s, KT.QUESTION); break;
        case '"': return KS.string(s); break;
        case "'": return KS.string(s); break;
        case '`': return makeToken(s, KT.BACKTICK); break;
        case '\\': return makeToken(s, KT.BACKSLASH); break;
        case '*':
          if (KS.peek(s) == '*') { return makeToken(s, KT.STAR) }
          return makeToken(s, KT.STAR_STAR); break;
        case ':':
          if (KS.peek(s) == ':') { return makeToken(s, KT.COLON_COLON) }
          return makeToken(s, KT.COLON); break;
        case '<':
          if (KS.peek(s) == '<') { return makeToken(s, KT.LESS_LESS) }
          else if (KS.peek(s) == '=') { return makeToken(s, KT.LESS_EQUAL) }
          return makeToken(s, KT.LESS); break;
        case '>':
          if (KS.peek(s) == '>') { return makeToken(s, KT.GREATER_GREATER) }
          else if (KS.peek(s) == '=') { return makeToken(s, KT.GREATER_EQUAL) }
          return makeToken(s, KT.GREATER); break;
        case '/':
          if (KS.peek(s) == '/') { return makeToken(s, KT.DOUBLE_SLASH) }
          return makeToken(s, KT.SLASH); break;
        case '=':
          if (KS.peek(s) == '=') { return makeToken(s, KT.EQUAL_EQUAL) }
          return makeToken(s, KT.EQUAL); break;
        case '!':
          if (KS.peek(s) == '=') { return makeToken(s, KT.BANG_EQUAL) }
          return makeToken(s, KT.BANG); break;
        case '|':
          if (KS.peek(s) == '=') { return makeToken(s, KT.PIPE_EQUAL) }
          else if (KS.peek(s) == '|') {
            if (KS.peek(s) == '=') { return makeToken(s, KT.MEMO_IDIOM) }
            return makeToken(s, KT.PIPE_PIPE);
          }
          return makeToken(s, KT.PIPE); break;
        case '.':
          if (KS.peek(s) == '.') {
            if (KS.doublePeek(s) == '.') { return makeToken(s, KT.DOT_DOT_DOT) }
            return makeToken(s, KT.DOT_DOT);
          }
          return makeToken(s, KT.DOT); break;
        case '||=': return makeToken(s, KT.PIPE); break;
        default:
          break;
    }
    console.log("unexpected character")
  },
  // scans characters and saves them as... tokens
  scan: function(s){
    while (!KS.isAtEnd(s)) {
      console.log("character: ", KS.char(s));
      var token = KS.scanToken(s);
      s.tokens.push(token);
    }
  },
}
Kona.tokens = {

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
    BANG_EQUAL:      0x16, PIPE_EQUAL:      0x17,
    LESS:            0x18, LESS_EQUAL:      0x19,
    GREATER:         0x1A, GREATER_EQUAL:   0x1B,

    SEMICOLON:       0x1C, COLON:           0x1D,
    COMMA:           0x1E, DOT:             0x1F,
    DOT_DOT:         0x20, DOT_DOT_DOT:     0x21,
    COLON_COLON:     0x22,
    QUESTION:        0x23, BANG:            0x24,

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

    // EXTRAS that should be put above but I don't want to recount everything now.
    // PIPE_PIPE_EQUAL:0x13, // same as memo idiom
    PIPE_PIPE:      0x4C,
    STAR_STAR:      0x4D,
    QUOTE:          0x4E,
    SINGLE_QUOTE:   0x4F,
    BACKTICK:       0x50,
    BACKSLASH:      0x51,
}
// List token Literals here for quick reference in the matcher.
// Token literals are only added
Kona.tokenLiterals = {}
KTL = Kona.tokenLiterals
// GROUPINGS
KTL[0x01] = "("; KTL[0x02] = ")";
KTL[0x03] = "{"; KTL[0x04] = "}";
KTL[0x05] = "["; KTL[0x06] = "]";

KTL[0x07] = "+"; KTL[0x08] = "-";
KTL[0x09] = "*"; KTL[0x0A] = "/";
KTL[0x0B] = "%"; KTL[0x0C] = "^";
KTL[0x0D] = "&"; KTL[0x0E] = "~";
KTL[0x0F] = "|"; KTL[0x10] = "<<";
KTL[0x11] = ">>";KTL[0x12] = "//";
KTL[0x13] = "||=";
KTL[0x14] = "="; KTL[0x15] = "==";
KTL[0x16] = "!=";KTL[0x17] = "|=";
KTL[0x18] = "<"; KTL[0x19] = "<=";
KTL[0x1A] = ">"; KTL[0x1B] = ">=";
KTL[0x1C] = ";"; KTL[0x1D] = ":";
KTL[0x1E] = ","; KTL[0x1F] = ".";
KTL[0x20] = "..";KTL[0x21] = "...";
KTL[0x22] = "::";
KTL[0x23] = "?"; KTL[0x24] = "!";

KTL[0x28] = "nil";

// Keywords
KTL[0x29] = "and";    KTL[0x2A] = "break";
KTL[0x2B] = "case";   KTL[0x2C] = "continue";
KTL[0x2D] = "class";  KTL[0x2E] = "def";
KTL[0x2F] = "do";     KTL[0x30] = "else";
KTL[0x31] = "end";    KTL[0x32] = "enum";
KTL[0x33] = "false";  KTL[0x34] = "for";
KTL[0x35] = "fun";    KTL[0x36] = "goto";
KTL[0x37] = "if";     KTL[0x38] = "in";
KTL[0x39] = "let";    KTL[0x3A] = "module";
KTL[0x3B] = "not";
KTL[0x3C] = "or";     KTL[0x3D] = "repeat";
KTL[0x3E] = "return"; KTL[0x3F] = "self";
KTL[0x40] = "super";  KTL[0x41] = "switch";
KTL[0x42] = "then";   KTL[0x43] = "true";
KTL[0x44] = "until";  KTL[0x45] = "unless";
KTL[0x46] = "when";   KTL[0x47] = "while";
KTL[0x4C] = "||";     KTL[0x4D] = "**";
KTL[0x4E] = '"';      KTL[0x4F] = "'";
KTL[0x50] = '`';      KTL[0x51] = "\\";

Kona.precedence = { // sorted low to high
  NONE:0,
  ASSIGNMENT:1, // = ||= |=
  OR:2,         // OR, ||
  AND:3,        // AND
  EQUALITY:4,   // == !=
  COMPARISON:5, // < > <= >=
  TERM:6,       // + -
  FACTOR:7,     // * / % ^
  UNARY:8,      // . () << >> & $ ? !
  PRIMARY:9
}
Kona.precedences = ["none","assignment","or","and","equality","comparison","term","factor","unary","primary"]
// Symbol tokens:
// ```
//   (     )     {     }     [     ]
//   +     -     *     /     %     ^
//   &     ~     |     <<    >>    //    ||=
//   ==    !=    |=    <=    >=    <     >     =
//   ;     :     ,     .     ..    ...   ::
//   ?     !     ||    "     '     `     \
// ```

Kona.keywords = {}

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
Kona.funcops = {}
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
