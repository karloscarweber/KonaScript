# Wren build
I'm trying out a build using Wren. Wren has *almost* everything I want. If this works out well I won't even need my own language, just my own parser for a dialect of Wren. The move to using Wren as the host language is also inspired by how great Wren's syntax and idioms are. It's remarkable how expressive and simple the little language is.

Kona is a Browser focused Programming language for making front ends and websites. It doesn't use Javascript. and we don't care about it. It's a replacement. It's meant to be minimal. It's meant for larger applications that run in the browser, not tiny little things. (which seems odd because KONA is minimal). (Maybe make it for minimal small stuff too?)

This is an important distinction because although wren is pretty small, and clocks in at around 200 KB in a WASM build, (with another 100 KB of the js harness), it's still pretty big to send across the wire to your browser. Basic websites, or sites with basic functionality shouldn't rely on a whole new programming language being dumped in to their environment.

The other issue is that the current implementation of WASM in browsers doesn't allow direct access to key javascript apis. So it's kind of a bummer. This is a first step to hopefully overcome that.

If that all fails, the language can still be very effective as a UI focused language if attached to a rendering harness. Like a Game engine, one of the main uses of Wren, the host VM.

## VM Target
Kona's goals are to target the wren VM, by replacing it's compiler. Additions and changes to the syntax will complicate the implementation. But by focusing on emitting valid VM byte code, from parsed code, we can take advantage of the work to get a small language working.

## Goals
* Natively parse and write Kona, HTML, and JSON.
* Embed in the browser.
* Port the VM and parser straight to WASM.
* Composable Templates built in.
* Event based interaction model.
* Built in DOM module to model, and manipulate the DOM.
* Bundler type version control for modules.
* Markup and data diffing built in to morph between states.

### Scanner design:
The Scanner scans for tokens, produces a linked AST tree, and then emits Valid Wren code. Its' the first step to a fully functional parser in *C* to replace Wren's front end. But of course the first step is to Scan for tokens and to display the syntax tree.

Parser, scans/lexes code to produce tokens.
* Make Parser
* Parser accepts code
* parse scans code to produce tokens

Compiler
* Compiler accepts tokens to produce pseudo code
* Pseudo code is optimized to produce Byte Code
* Byte Code is sent to the VM with a bow to be run.

The target is the wren VM. So Wren Byte Code is the eventual output. Which I think is great. We can focus on the front end for a while knowing we have a reliable backend waiting for us. Additionally, there are a lot of features of the Wren VM, that we can use creatively to achieve the ergonomics we're looking for.



# syntax set:
To get KONA bootstrapped and built with the basics we're going for a reduced set of keywords and capabilities. Making, like, a fancy calculator.

## Reserved words
we're changing the reserved words list to be greatly reduced and to match the words reserved in Wren. We want to add a few reserved words of our own to add the pieces we want. But for now let's just keep it simple.
```
as break class construct continue else false for foreign if import in is null return require static super this true var while
```

## Symbol tokens
```
(     )     {     }     [     ]
,     .     -     +     /     *
!     !=     =    ==    >     >=
<     <=     %     ^
#     &      &&    |    ?     :
@      <<    >>    ..   ...
**
```

# BNF description

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
