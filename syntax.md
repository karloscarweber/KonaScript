# Syntax

An attempt at documenting the syntax

## Variables
You can declare variables with the `=` operator.
```stim
variable = 0
```

We can do math:
```stim
5 + 10
> 15
10 / 2
> 5
```

There are several primitive types:
```stim
nil # Represents a nil value.
anInteger = 99
aFloat = 19.99
aString = "Hi I'm a string"
ASymbol = :fantastic
aHash = {fantastic=:fantastic, "garbled"= nil,}
aFunction = function () end
aHash.myFunction = aFunction
```

Hashes are like Dictionaries and Arrays at the same time. Each value is added in sequence and their sequence is guaranteed. Omitting a key for a value just means that the value can only be referenced by their place in the sequence.
```stim
list = {"cheese", "crackers",numskull="whatever"}
list.count
> 3
list.0
> "cheese"
list.crackers
> nil
list.numskull
> "whatever"
```

Assigning a value to an empty key in a hash will make that key:
```stim
friends = {}
friends.best = "Collin"
```

You can add values directly to a list using the shovel:
```stim
list = {"_why", "Matz", "Marco"}
list << "Amazing"
```

The shovel can also be used to concatenate strings:
```stim
cheeses = "Cheddar"
cheeses << ", Gouda" << ", Provologne"
```

Functions are first class value object thingies. They can be created, assigned, passed around, invoked, and disappeared by setting them to nil. The act as closures, and enclose their surrounding environment when referencing values from outside of them. They are nice. parenthesis are optional
```stim
def funky(name) print name end
funky "karl"
> karl
```

You can store a reference to the function by grabbing it's handle:
```stim
fresh = funky.handle
```

Now calling the function requires an explicit call:
```stim
fresh.call()
fresh.()
```

In this way we maintain expressive DSL like syntax, with First Class Function citizens.

Everything is also an Object, So you can do this:
```stim
namer = Function.new(name) print name end
# makes a function named namer
# or even this:
function_hash = {def funky(name) print name end,}
function_hash.0 "dude"
> "dude"
```




# An Attempt at Extended BNF description

{A} means 0 or more As, [A] means an opional A.


block   ::=   {stat} [retstat]

stat    ::=   `;` |
              varlist `=` explist |
              functioncall |
              label |
              break |
              goto Name |
              do block end |
              while exp do block end |
              repeat block until exp |
              if exp then block {elseif exp then block} [else block] end |
              for Name `=` exp `,` [`,` exp] do block end |
              for namelist in explist do block end |
              function funcname funcbody | |
              local function Name funcbody |
              local namelist [`=` explist]

retstat ::=   return [explist] [`;`]

label   ::=   `::` Name `::`

funcname ::=  Name {`.` Name} [`:` Name]

varlist  ::=  var {`,` var}

var      ::= Name | prefixexp `[` exp `]` | prefixexp `.` Name

namelist ::= Name {`,` Name}

explist ::= exp {`,` exp}

exp ::= nil | false | true | Numeral | LiteralString |
            `...` | functiondef | prefixexp |
            tabelconstructor | exp binop exp | unop exp

prefixexp ::= var | functioncall | `(` exp `)`

functioncall ::= prefixexp args | refixexp `:` Name args

args ::= `(` [explist] `)` | tableconstructor | LiteralString

functiondef ::= function funcbody

funcbody ::= `(` [parlist] `)` block end

parlist ::= namelist [`,` `...`] | `...`

tableconstructor ::= `{` [fieldlist] `}`

fieldlist ::= field {fieldsep field} [fieldsep]

field ::= `[` exp `]` `=` exp | Name `=` exp | exp

fieldsep ::= `,` | `;`

binop ::= `+` | `-` | `*` | `/` | `//` | `^` | `%` | `&` |
          `~` | `|` | `>>` | `<<` | `..` | `<` | `<=` |
          `>` | `>=` | `==` | `~=` | and | or

unop ::= `-` | not | `#` | `~`


block means a block of code
stat means statement.
varlist means variable list
explist means a list of expressions
exp means expression
Name means and identifier or name
funcname means a function name
funcbody means a function body
retstat means return statement
label means ??????
unop means unary operator
