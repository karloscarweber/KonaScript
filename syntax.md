# Syntax

An attempt at documenting the syntax of the language I'm working on.

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
nil -- Represents a nil value.
anInteger = 99 -- an int value
aFloat = 19.99 -- a float
aString = "Hi I'm a string" -- a string
ASymbol = :fantastic -- a symbol, which is just a string, but converted to the memory address of the name, every symbol shares the same address.
aHash = {fantastic: fantastic, "garbled key": nil, age: 99, address: {addr1: "999 overflow dr", addr2:"Salt Lake City UT"}} -- Hashes are multi dimensional arrays.
aFunction = def  end -- a function declaration, does nothng.
aHash.myFunction = aFunction.handle -- you can store functions into hashes.
```

Hashes are like Dictionaries and Arrays at the same time. Omitting a key for a value just means that the value can only be referenced by their place in the sequence. In fact, just like Lua, there is a hash array, and an array array, reference by a number.
```stim
list = {"cheese", "crackers",numskull="whatever"}
list.count
> 2
list.0
> cheese
list.crackers
> nil
list.numskull
> whatever
```

The `.` character is the index operator. It tries to find the following index in the preceding object/value. So `myObject.value` is the same as `myObject["value"]`.

Assigning a value to an empty key in a hash will make that key:
```stim
friends = {}
friends.best = "Collin"
friends.indexes.count
> 1
friends.best
> Collin
```

You can add values directly to a list using the shovel:
```stim
list = {"_why", "Matz", "Marco"}
list << "Joel"
list.count
> 4
```

The shovel can also be used to concatenate strings:
```stim
cheeses = "Cheddar"
cheeses << ", Gouda" << ", Provologne"
```

Functions are first class value object thingies. They can be created, assigned, passed around, invoked, and disappeared by setting them to nil. They act as closures, and enclose their surrounding environment when referencing values from outside of them. They are nice. parenthesis are optional when invoking functions.
```stim
def funky(name)
	print name
end
funky "karl"
> karl
funky("karl")
> karl
funky
>
funky.handle
> <function 1904883>
```

You can store a reference to the function by grabbing it's handle:
```stim
fresh = funky.handle
```

If you reference a function, and it's not immediately followed by a `.handle` declaration then it's assumed that your calling it. so

Now calling the function requires an explicit call:
```stim
fresh.call()
fresh.()
```

Adding the function

In this way we maintain expressive DSL like syntax, with First Class Function citizens. The `def` syntax is then syntactic sugar

Everything is also an Object, So you can do this:
```stim
namer = Function.new(name) print name end
# makes a function named namer
# or even this:
function_hash = {def funky(name) print name end,}
function_hash.0 "dude"
> "dude"
```

## Reserved words
and       break     case      continue  class
def       do        else      elseif    end
enum      false     for       function  if
in        module    nil       not       or
repeat    return    struct    super     switch
then      true      until     unless    when
while

## Other Tokens
+     -     *     /     %     ^     #
&     &&    @     =     ||    <<    !
==    !=    <=    >=    <     >
(     )     {     }     [     ]
;     :     ,     .

## idioms
||=     ::=   Memoize Operator, expands to an assignment to the lefthand Name if
							it is nil by adding `if Name == nil` to the end of the statement
							and replacing `||=` with `=`. Pretty simple one.

# An Attempt at Extended BNF description

{A} means 0 or more As, [A] means an optional A.

block   ::=   {stat} [retstat]

stat    ::=   `;` |
              varlist `=` explist |
              functioncall |
              break |
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

functiondef ::= function funcbody | def funcbody

funcbody ::= `(` [parlist] `)` block end

parlist ::= namelist [`,` `*`] | `*`

tableconstructor ::= `{` [fieldlist] `}`

fieldlist ::= field {fieldsep field} [fieldsep]

field ::= `[` exp `]` `:` exp | Name `:` exp | exp | Name `:`

fieldsep ::= `,` | `;`

binop ::= `+` | `-` | `*` | `/` | `//` | `^` | `%` | `&` |
          `~` | `|` | `>>` | `<<` | `.` | `<` | `<=` |
          `>` | `>=` | `==` | `~=` | and | or | `<<` | `&&`

unop ::= `-` | not | `#` | `!` | `&`


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
