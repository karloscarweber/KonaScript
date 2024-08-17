# Syntax

An attempt at documenting the syntax of the language I'm working on.

## Variables
You can declare variables with the `=` operator.
```kona
variable = 0
```

We can do math:
```kona
5 + 10
> 15
10 / 2
> 5
```

There are several primitive types:
```kona
nil -- Represents a nil value.
anInteger = 99 -- an int value
aFloat = 19.99 -- a float
aString = "Hi I'm a string" -- a string
aSymbol = :fantastic -- a symbol, which is just a string, but converted to the memory address of the name, every symbol shares the same address.
aHash = {fantastic: fantastic, "garbled key": nil, age: 99, address: {addr1: "999 overflow dr", addr2:"Salt Lake City UT"}} -- Hashes are multi dimensional arrays.
aFunction = def  end -- a function declaration, does nothng.
aHash.myFunction = aFunction.handle -- you can store functions into hashes.
```

Listing the types:
	* Nil
	* Int
	* Float
	* String
	* Symbol
	* Hash
	* Function

You can check the type of an element using the `is` operator:
```kona
thing = "Whatever"
hyper = :text
is(hyper)
> Symbol
hyper is Symbol
> true
thing is hyper
> false
```

You can also check against a collection of types:
```kona
types = [:String, :Symbol]
buffalo = fun shout(words) { print words}
buffalo is types
> false
types << :Function
bufallo is types
> true
```

Types are resolved by giving a class a name. These names are constants, and are implicitly represented by symbols. Simply giving a name to a class will set a new type:
```kona
class GymRat
end
```

Kona is weakly typed, but has a light type system that you can iteratively adopt, method and function definitions can enforce types for their parameters:
```kona
def shout( words: String ) {
	print words
}

def upcase( words: String ) -> String {
	// code to upcase words.
}

shout "I do what I Want!"
> "I do what I Want!"
shout :stuff
> ERROR: <parameter:words> of <Function:shout> requires a String, Symbol provided: line 32: shout :stuff
```

Type checking happens at runtime, so asserting that a parameter for a function needs to be a `String` will get checked when you try to call that function. Some folks don't like that, and think we should have some compile time checks. I honestly feel that maybe you should write some tests.

Identifiers are alphanumeric and can contain underscores:
```kona
myFavorite_thing99 = :cheese
> :cheese
```

There's a special postfix assignment operator for identifiers:
```kona
name: "Karl"
```

Leaving the postfix empty will attempt to fill the identifier with an identifier of the same name in the current context. This is a lightweight pattern matching thingy, and very useful for building objects:

```kona
make: "Mazda"
model: 3
car: {make:,model:}
print car
>
> <Object 1904883> {make: "Mazda", model: 3}
```

This syntax does not work in Function declarations however. Postfix colons are reserved there for setting optional types.

```kona
def flip str: String
	/* flip some strings */
end
flip "bill"
> "llib"
car: {name:"Mazda 3"}
flip car
> TypeError: Parameter "name:" of function "flip(str: String) -> Object?", is expected to be a string.
```

You can set the return type of a function using a small arrow:
```kona
def flip str: String -> String
	/* flip some strings */
end
```

Leaving this blank will implicitly set an optional return type of Anything. `Object?`.

Hashes are like Dictionaries and Arrays at the same time. Omitting a key for a value just means that the value can only be referenced by their place in the sequence. In fact, just like Lua, there is a hash array, and an array array, reference by a number.
```kona
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
```kona
friends = {}
friends.best = "Collin"
friends.indexes.count
> 1
friends.best
> Collin
```

You can add values directly to a list using the shovel:
```kona
list = {"_why", "Matz", "Marco"}
list << "Joel"
list.count
> 4
```

The shovel can also be used to concatenate strings:
```kona
cheeses = "Cheddar"
cheeses << ", Gouda" << ", Provologne"
```

Functions are first class value objects. They can be created, assigned, passed around, invoked, and disappeared by setting them to nil. They act as closures, and enclose their surrounding environment when referencing values from outside of them. They are nice. parenthesis are optional when invoking functions.
```kona
def funky name
	print name
end
funky "karl"
> karl
funky
>
&funky
> <function 1904883>
```

You can store a reference to the function by grabbing it's handle:
```kona
fresh = &funky
> <function 1904883>
print fresh
> <function 1904883>
```

If you reference a function, and it's not immediately preceded by a `&` prefix declaration then it's assumed that your calling it.

Now calling the function requires an explicit call:
```kona
fresh()
fresh()
```

In this way we maintain an expressive DSL like syntax, with First Class Function citizens. The `def` syntax is then syntactic sugar for making a function in a context, and assigning it to a name.

Everything is also an Object, So you can do this:
```kona
namer = Function.new(:name) print name end
// makes a function named namer

// or even this:
function_hash = {def funky(name) print name end,}
function_hash.0 = "dude"
> "dude"
function_hash.funky "fresh"
> "fresh"
function_hash.0
> "dude"
```

## Types
Kona has a selection of primitive and basic types.

## Optionals
You can reference or require data optionally, returning `nil` if what you're referencing just isn't around:

```kona
town = { people: { "jim", "Scott", "Hikaru", }, restaurants: { "McDonalds", "Wendy's", } }
print town.people?
> { "jim", "Scott", "Hikaru" }
print town.restuarants?
> { "McDonalds", "Wendy's" }
print town.schools?
> nil
print town.schools
> Error: Missing element for Key: :schools
```

## HTML
HTML is parsed natively in Kona. HTML written directly in the source code is implicitly stored in a template element that matches the string. You can also save the template to a variable and render it later.
```kona
<p class="really_bold">This is So Bold!</p>
> <HTML::p 2504382>
title_template = <h1>This is a title.</h1>
> <HTML::title_template 2504382>
```

As implied, HTML are also templates. You can define slots to be replaced in HTML templates by using mustache or handlebars syntax:
```kona
<list>
	{{#each person as name}}
		<li>{{name}}</li>
	{{/each}}
</list>

list {person:["bill","bob","beverly",]}
> <list>
> 	<li>bill</li>
> 	<li>bob</li>
> 	<li>beverly</li>
> <list>
```

Missing context values supplied to a template are simply ignored.

You can also add custom elements or helpers to HTML templates, and achieve nested custom behaviour.
```kona
class list < Element

	<template>
		{{#each person as name}}
			<li>{{name}}</li>
		{{/each}}
	<template/>
end
```

Reference HTML Document thing: https://html.spec.whatwg.org/multipage/introduction.html#a-quick-introduction-to-html

## Reserved words
and       break     case      continue  class
def       do        else      end       enum
false     for       fun       goto      if
in        is        let       module    nil
not       or        repeat    return    self
super     switch    then      true      until
unless    when      while

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
fieldsep means field separator
retstat means return statement
label means ??????
unop means unary operator
binop means binary operator


# Reduced syntax set:
To get stuff bootstrapped and built with the basics we're going for a reduced set of keywords and capabilities. Making, like a fancy calculator.


## Reduced Reserved words
```
return
if        then      else      end
true      false     nil
not       or        and
while     break     continue
do				def
class     self      super
```

## Reduced Tokens
```
+     -     *     /     %     ^
=
!     ==    !=    <=    >=    <     >
**
#     &     &&    @     |     <<
(     )     {     }     [     ]
;     :     ,     .     ?     ->
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
