# Stim

An attempt to write a small programming language or DSL in LUA to make UI and code stuff for websites that's really great.

## Why?
Javascript is not the best. It's getting better, but ya know what... we could do better. I want a language that supports an expressive syntax to construct and manipulate Nested UI. One that is purpose built for the needs of the web and it's interface, and one that responds to and makes UI responsive and interactive.

Purpose built for the web.

Composablitiy is also a goal. Templating that works and looks like it belongs in the language, with language semantics to compile template strings into cacheable and quick templates. Contexts should be first class constructs, and it should be so damn easy that it's sick.

Animation: Expressive syntax to manipulate values over time, to broadcast the change of those values, and to provide in language facilities to ease from one value to another.

Buildable, Objects broadcast their initililization to their containing block and are can natively recieve and bubble up event changes. Facilities for building view hiearchies that are pretty great, If I do say so myself.

DOM ready, an expressive API for querying, modifying, and monitoring the DOM.

Builtin Facilities for sanitization of common input and for the validation of that input.

Object Oriented and Functional. Everything is an object, but functions are also first class objects. A simplified inheritance chain. Able to modify an existing object through inheritance, mixins, includes, and extends. Or maybe just a couple of those.

Modular: Have a simple environment and module system.

Micro: A small surface area with a few sharp and powerful tools. Able to quickly build UI Interactions, and cool stuff with only a few attribtues, but be small enough to never think twice about embedding it. Small surface area also means that it's easy to parse, and it's difficult to confuse with HTML and CSS.

Eventable, Ability to attache lifecycle callbacks to any object or element, along with

MetaProgramatic: First class facilities for Meta programming, Although the design should strive for a simplified metaprogamming paradigm. Write code that writes code, but not actually too much code.

Simple Syntax: Although we want the language to be expressive, we also don't want the language to have too many ways to do something. Keeping the language simple to parse with as few features as possible until we get what we want is paramount. More complicated features could be written in Stim itself, hopefully to get the Lua bytecode parser to bless us.

Builtin Testing Framework: Make it easy to test this mother fucker.

Duck Typing, but builtin Type annotations for runtime type checking. A pretty good system for building Runtime Type Checkers into the thing. So that Functions can have parameter markers and Return markers for all the basic types, and collection types too.
```stim
# Optional TypeAnnotations
def funky fresh:->String, bacon:->String
  puts fresh + bacon
end ->String

# What about Collections?
->Collection[->String] or ->Collection[->Object]

# You can declare you're own types/protocols using a protocol syntax:
String->
  def << ->String end ->String
  def + ->String end ->String
  def pop end ->String
end
```

Check types at runtime: Using protocols we should add some builtin Object functions:
```stim
myObject.conformsTo(String)

# or make it only in function calls with types you get a special method:
def funky fresh:->String, bacon:->String|nil
  conforms? fresh:, bacon:
  puts fresh + bacon
end
```

Named Parameters: Functions on Objects/Collections should use Named Parameters.
Symbol by Default Index: Symbolized or named keys on Collections by default, so you can do: a = {whatever="loser"} and you can access it's index with: a.whatever (ACTUALLY THIS IS BAD! What about methods on a collection object that match a named dictionary entry?) Maybe all objects should have internal storage for the basic types, and exposed methods will just use that internal storage. So that we can still do that dynamic object stuff.

Pattern Matching: When using named parameters in function calls or in collection constructors, locally named variables will be used to fill in the giblets.
```stim
# Optional Type annotations.
def funky(fresh:@String,bacon:@String)
  puts
end
```

PROTOCOLS: Like in Swift, are named, an Object will have parameters, and expected input types
