# Wren build
I'm trying out a build using Wren. Wren has *almost* everything I want. If this works out well I won't even need my own language, just my own parser for a dialect of Wren. The move to using Wren as the host language is also inspired by how great Wren's syntax and idioms are. It's remarkable how expressive and simple the little language is.

Kona is a Browser focused Programming language for making front ends and websites. It doesn't use Javascript. and we don't care about it. It's a replacement. It's meant to be minimal. It's meant for larger applications that run in the browser, not tiny little things. (which seems odd because KONA is minimal). (Maybe make it for minimal small stuff too?)

## Goals
* Natively parse and write HTML, and JSON
* Embed in the browser
* Port the VM and parser straight to WASM
* Composable Templates built in
* event based model

# Reduced syntax set:
To get KONA bootstrapped and built with the basics we're going for a reduced set of keywords and capabilities. Making, like, a fancy calculator.

## Reduced Reserved words
we're changing the reserved words list to be greatly reduced and to match the words reserved in Wren. We want to add a few reserved words of our own to add the pieces we want. But for now let's just keep it simple.
```
as break class construct continue else false for foreign if import in is null return static super this true var while
```

## Reduced Symbol tokens
```
(     )     {     }     [     ]
,     .     -     +    /     *
!     !=     =    ==    >     >=
<     <=     %     ^
#     &      &&    |    ?     :
@      <<    >>     ..    ...
**
```

# Reduced BNF description

{A} means 0 or more As, [A] means an optional A.

block   ::=   {stat} [retstat]

stat    ::=   `;` |
              varlist `=` explist |
              functioncall |
              break |
              do block end |
              while exp do block end |
              if exp then block {elseif exp then block} [else block] end |
              for Name `=` exp `,` [`,` exp] do block end |
              for namelist in explist do block end |
              function funcname funcbody

retstat  ::=   return [explist] [`;`]

funcname ::=  Name {`.` Name}

varlist  ::=  var {`,` var}

var      ::= Name | prefixexp `[` exp `]` | prefixexp `.` Name

namelist ::= Name {`,` Name}

explist ::= exp {`,` exp}

exp		  ::= nil | false | true | Numeral | LiteralString |
            `*` | functiondef | prefixexp |
            tabelconstructor | exp binop exp | unop exp

prefixexp ::= var | functioncall | `(` exp `)`

functioncall ::= Name `(` { parlist } `)`

args ::= `(` [explist] `)` | tableconstructor | LiteralString

functiondef ::= def funcbody

funcbody    ::=  { `(` [parlist] `)` } block end ||
                 { `(` [parlist] `)` } `{` block `}`

parlist ::= namelist [`,` `*`] | `*`

tableconstructor ::= `{` [fieldlist] `}`

fieldlist ::= field {fieldsep field} [fieldsep]

field ::= `[` exp `]` `:` exp | Name `:` exp | exp | Name `:`

fieldsep ::= `,`

binop ::= `+` | `-` | `*` | `/` | `//` | `^` | `%` | `&` |
          `~` | `|` | `>>` | `<<` | `.` | `<` | `<=` |
          `>` | `>=` | `==` | `~=` | and | or | `<<` | `&&`

unop ::= `-` | not | `#` | `!` | `&`
