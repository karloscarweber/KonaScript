# Grammar
These grammar rules are less verbose. a rule followed by a `*` means zero or more.

To begin, the program is a number of declarations ending with an **EOF** termination symbol.
```grammar
program            → declaration* EOF
```

### Declarations
Each program is a series of successive declarations. Declarations are used to assign values to a variable.
```grammar
declaration        → classDecl
                   | funDecl 
                   | statement
classDecl          → "class" constant ( "<" constant )? block 
funDecl            → "def" name parameterlist?  block 
```

### Statements
Statements produce side effects, but don't create bindings.
```grammar
statement          → expression
                   | doStmt
                   | forStmt
                   | ifStmt
                   | printStmt
                   | returnStmt
                   | whileStmt
                   | block
exprStmt           → expression
doStmt             → "do" statement "end" (whileStmt | unlessStmt | untilStmt )?
forStmt            → "for" "("? ( varDecl | exprStmt | ";" )
                     expression? ";"
                     expression? ")"?
                     doStmt
ifStmt             → "if" "("? expression ")"? block
elseblock          → "elsif" declaration* end | "elsif" block
forInStmt          → "for" (name, name?) "in" name block ;
whileStmt          → "while" ["("] expression [")"] block?
printStmt          → "print" expression ( ";" | "\n" ] ;
returnStmt         → "return" expression? ( ";" | "\n" )?
whileStmt          → "while" expression? doStmt ;
block              → "{" declaration* "}" | "do" declaration* "end" ;
```
Note that although blocks have two syntax patterns, either surrounded by curly braces, or by a "do" "end" pair, They cannot be used interchangeably.

### Expressions
Expressions return values, they don't make declarations. Expressions are usually part of a declaration. They include operators, logical operators, and calls to functions. Assuming that everything returns a value, we'll have lots of expressions.

Separating the grammar this way means that we can organize things based on order of operations when it comes to an expression, as execution, and evaluation changes based on the operator.

Implicit assignment, is when you have a name immediately followed by a colon, and an expression terminator, like a comma, or a semicolon, or a newline. In those situations, Kona will try to find a corresponding name in the surrounding or immediate scope to assign to that name. Helpful when using the snail accessor: `@name:` which will set the value of `name` in an object function, if it's supplied with a local identified by `name`.

```grammar
expression         → assignment
assignment         → ( ( call "." )? name)* "=" assignment
                   | ( ( call "." )? name)* ":" (ws | "," | newline )
                   | logic_or

logic_or           → logic_and ( ( "||" | "or" ) logic_and )* 
logic_and          → equality ( ("&&" | "and" ) equality )* 
equality           → comparison ( ( "!=" | "==" | "not" ) )* ;
comparision        → term ( ( ">"  | ">=" | "<" | "<=" ) term )* ;
term               → factor ( ( "-"  | "+" ) factor )* ;
factor             → unary ( ( "/" | "*") unary )* ;

unary              → ( "!", "-", "#" ) unary | call ;
subscript          → name "[" (digit+ | range | stringlit) "]"
call               → primary ( "(" arguments? ")" | "." name )*
                   | primary ( arguments? )* newline
primary            → "true" | "false" | "nil" | "self" | number | string | name | constant | "(" expression ")" | "super" "." name

objectLiteral      → "{" (name ":" (primary | "" ) ","? )* "}"
arraylit           → "[" ((digit+ | string) "," )* "]"
```

## operators
```grammar
binop              → "+"  | "-"  | "*"  | "/"  | "//" | "^"   | "%"  | "&" | "~" |
                     "|"  | ">>" | "<<" | ".." | "..."| "<"   | "<=" | ">" |
                     ">=" | "==" | "~=" | "&&" | "||" | "and" | "or"
unop               → "-" | "!" | "#" | "not" | "@"
```

### Reused rules
Like in Lox's grammar, we're reusing some rules to make things more succinct above.
```grammar
function           → name parameters block
                   | name "(" parameters ")" block
parameters         → param ("," param)*
param              → name ( ":" (const | typelist ) )*
typelist           → "[" ( const "," )* "]"
arguments          → expression ( "," expression )*
```

## String Templates
```grammar
template           → "<" name ">" (string | ttag )* "<" name ">"
ttag               → ("{{" (("#" | "/")? name)* attribute* "}}")*
attribute          → attrname "=" stringlit
attrname           → name ( name | - )*
```

## Lexical Grammer
```grammar
ws                 → " " | "  " | newline, "space, tab, or newline"
newline            → ``
stringlit          → "\"" string "\""
string             → ( "any char except \"" )*
const              → A .. Z name*
symbol             → ":" (name | digit+ )
name               → alpha ( alpha | digit )*
alpha              → a .. z | A .. Z | _
range              → digit+ (".." | "...") digit+
number             → digit+ ( "." digit+ )?
digit              → 0 .. 9
```
**Names** are strings of latin letters, digits, and underscores. They cannot begin with a digit or a reserved word. Identifiers are used to name variables, map/hash fields, and labels.

**keywords** are reserved words used to build language constructs, these are reserved words and cannot be used as *Names* or *Identifiers*. **Keywords** are case sensitive, and in a case sensitive language won't be trigged by *Names* or *Identifiers* with the same characters but different case.
```
  and       break     case      catch     continue
  class     def       do        else      end       
  enum      false     for       fun       goto      
  if        in        let       module    nil       
  not       or        repeat    return    self      
  super     switch    then      true      try       
  until     unless    when      while
```

Other tokens:
```
  +     -     *     /     %     ^
  &     ~     |     <<    >>    //    ||=
  ==    !=    <=    >=    <     >     =
  (     )     {     }     [     ]     ::
  ;     :     ,     .     ..    ...   ?
  ->    =>   /*    */
```

Comments are delimited by double slashes: `//`.
```
// This is a comment
```

multiline comments are delimited by open and close comments, like in C:
```
/*
  This is a multiline
  comment
  that works great.
*/
```

## Sample Code?:
```ruby
# literals:
"Hello friends"
15
16.1
0xfff

# names
hello
Constant
Class_or_Whatever

# assignment
name = "karl"
name, age = "karl", 37; print("thewords")

# for statement
for i, v in values do print(i,v) end
for i, v in values {
  print(i,v)
}
values.each |v| print(v)
values.each do |v|
  print v
end

class Constant < Thing
end
class Constant
end

Constant {
  thing: value,
  otherthing: othervalue,
}

# Object Literal is just like JSON.
lit = {
  whatever: "It's a string",
  loser: 5,
  
}
lit.count
# > 2

lit.toJson
# > { "whatever": "It's a string", "loser": 5 }

# A JSON string is automatically converted to an object literal. Except for 
# function definitions.

# Enums are cool
MyEnum = enum [
  :first,
  :second,
  :disqualified,
  :99,
]

```
