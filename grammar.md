# Grammar
Trying to write a Grammer almost as small as Lua's in Extended BNF. To start, we'll mirror Lua's Grammar, then make changes. {A} means 0 or more As. [A] means an optional A. Names and repetitions terminated by a quotation mark "?", are optional.

To begin, the program is a number of declarations ending with an **EOF** termination symbol.
```grammar
program            → { BLOCK } EOF ;
```

### Declarations
Each program is a series of successive declarations. Declarations are used to assign the value of a variable.
```grammar
declaration        → { modDecl | funDecl | varDecl | statement } ;
modDecl            → ("module"|"class") CONSTANT ( "<" CONSTANT )? {declaration} "end" ;
funDecl            → "def" IDENTIFIER ( "(" PARAMS? ")" | "" PARAMS "" { BLOCK } "end" ;
varDecl            → IDENTIFIER ( "=" expression )? (";" | "\n" )? ;
```

### Statements
Statements product side effects, but don't create bindings.
```grammar
statement          → expression
                   | doStmt
                   | forStmt
                   | ifStmt
                   | printStmt
                   | returnStmt
                   | whileStmt
                   | block ;
exprStmt           → expression ;
doStmt             → "do" statement "end" (whileStmt | unlessStmt | untilStmt )?
forStmt            → "for" "("? ( varDecl | exprStmt | ";" )
                     expression? ";"
                     expression? ")"?
                     doStmt ;
ifStmt             → "if" "("? expression ")"? "do" ;
forInStmt          → "for" (IDENTIFIER, IDENTIFIER?) "in" IDENTIFIER block ;
whileStmt          → "while" ["("] expression [")"] block?
printStmt          → "print" expression ( ";" | "\n" ] ;
returnStmt         → "return" expression? ( ";" | "\n" )?
whileStmt          → "while" expression? doStmt ;
block              → "{" declaration "}" | "do" declaration "end" ;
```
Note that although blocks have two syntax patterns, either surrounded by curly braces, or by a "do" "end" pair, They cannot be used interchangeably.

### Expressions
Expressions return values, they don't make declarations. Expressions are usually part of a declaration.

```grammar
expression         → assignment ;
assignment         → { call "."} IDENTIFIER "=" assignment | logic_or ;
;
logic_or           → logic_nad { "or" logic_and}
logic_and          → equality { "and" equality } ;
equality           → comparison { ( "!=" | "==" | "is" | "not" ) "} ;
comparision        → term { ( ">"  | ">=" | "<" | "<=" ) term } ;
term               → factor { ( "-"  | "+" ) factor } ;
factor             → unary { ( "/" | "*") unary } ;
unary              → ( "!", "-" ") unary | call ;
primary            → "true" | "false" | "nil" | "self" | NUMBER | STRING | IDENTIFIER | CONSTANT | "(" expression ")" | "super" "." IDENTIFIER ;
```

### Reused rules
Like in Lox's grammar, we're reusing some rules to make things more succinct above.
```grammar
function           → IDENTIFIER ["("] parameters? [")"] block ;
parameters         → IDENTIFIER [ ":" CONSTANT] { "," IDENTIFIER (":" CONSTANT)? } ;
arguments          → expression { "," expression } ;
```

## Lexical Grammer
```grammar
NUMBER             → { DIGIT } ( "." { DIGIT } )? ;
STRING             → "\"" {any char except "\"">} "\"" ;
IDENTIFIER         → ALPHA { ALPHA | DIGIT } ;
CONSTANT           → "A" ... "Z" { ALPHA | DIGIT } ;
ALPHA              → "a" ... "z" | "A" ... "Z" | "_" ;
DIGIT              → "0" ... "9" ;
```
**Names** or **Identifiers** are strings of latin letters, digits, and underscores. They cannot begin with a digit or a reserved word. Identifiers are used to name variables, table fields, and labels.

**keywords** are reserved words used to build language constructs, these are reserved words and cannot be used as *Names* or *Identifiers*. **Keywords** are case sensitive, and in a case sensitive language won't be trigged by *Names* or *Identifiers* with the same characters but different case.
```
  and       break     case      continue  class
  def       do        else      end       enum
  false     for       fun       goto      if
  in        let       module    nil       not
  or        repeat    return    self      super
  switch    then      true      until     unless
  when      while
```

Other tokens:
```
  +     -     *     /     %     ^
  &     ~     |     <<    >>    //    ||=
  ==    !=    <=    >=    <     >     =
  (     )     {     }     [     ]     ::
  ;     :     ,     .     ..    ...
```

Comments are delimited by a **Hash** symbol: `#`.
```
# This is a comment
```

## Sample Code?:
```ruby

# for statement
for i, v in values do print(i,v) end

class Constant < Thing
end
module Constant
end
```

