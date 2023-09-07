# Stim

An attempt to write a small programming language or DSL in LUA to make UI and code stuff for websites that's really great.

## Names?:
	* Stim
	* Canned  .org - available
	* Can
	* Stimpack
	* Pound
	* Kona
	* Case
	* Kiki
	* Jiji

## Why?
Javascript is not the best. It's getting better, but ya know what... we could do better. I want a language that supports an expressive syntax to construct and manipulate Nested UI. One that is purpose built for the needs of the web and it's interface, and one that responds to and makes UI responsive and interactive.

Purpose built for the web.

Composablitiy is also a goal. Templating that works and looks like it belongs in the language, with language semantics to compile template strings into cacheable and quick templates. Contexts should be first class constructs, and it should be so damn easy that it's sick.

Animation: Expressive syntax to manipulate values over time, to broadcast the change of those values, and to provide in language facilities to ease from one value to another.

Buildable, Objects broadcast their initililization to their containing block and are can natively recieve and bubble up event changes. Facilities for building view hiearchies that are pretty great, If I do say so myself. This requires a system to keep track of parent/child relationships. Probably reserving some variables to track these element would make sense.
```stim
class Element
  def initialize(name)
    @name = name
  end
end

element = Element.new "Mommy"
element << Element.new "Son" # anonymously adds a child element.
element.children
# > <Collection: 0x600002a58160> {
# >   <Element: 0x600002a58140>,
# > }
```

DOM ready, an expressive API for querying, modifying, and monitoring the DOM.

Builtin Facilities for sanitization of common input and for the validation of that input.

Object Oriented and Functional. Everything is an object, but functions are also first class objects. A simplified inheritance chain. Able to modify an existing object through inheritance, mixins, includes, and extends. Or maybe just a couple of those.

Modular: Have a simple environment and module system.

Micro: A small surface area with a few sharp and powerful tools. Able to quickly build UI Interactions, and cool stuff with only a few attribtues, but be small enough to never think twice about embedding it. Small surface area also means that it's easy to parse, and it's difficult to confuse with HTML and CSS.

Eventable, Ability to attach lifecycle callbacks to any object or element, along with triggered events from arbitrary events:
```ruby
class Element
  # ... element code

  when :someEventHappened do |event|
    # Do something in the context of this class with the event.
  end
end
```

Event listeners using `when` are functions that register themselves with the broadcast/listening subsystem thingy. I suppose we would also need to keep track of broadcasting or bubbling events too. So maybe this:
```ruby
class Element
  # ... element code
  def somethingCool
    # Do something cool

    broadcast(:someOtherEvent)
    # Broadcast a generic event here, named someOtherEvent.
    # The Event is broadcast from the global context and then filters down through the
    # The children chain
  end

  def somethingElse
    # Do something else.

    bubble(:anotherCoolEvent)
    # This command bubbles the event upwards along the ancestry chain of the element.
  end
end
```


MetaProgrammatic: First class facilities for Meta programming, Although the design should strive for a simplified metaprogamming paradigm. Write code that writes code, but not actually too much code.

Simple Syntax: Although we want the language to be expressive, we also don't want the language to have too many ways to do something. Keeping the language simple to parse with as few features as possible until we get what we want is paramount. More complicated features could be written in Stim itself, hopefully to get the Lua bytecode parser to bless us.

Builtin Testing Framework: Make it easy to test this mother fucker.

Duck Typing, but builtin Type annotations for runtime type checking. A pretty good system for building Runtime Type Checkers into the thing. So that Functions can have parameter markers and Return markers for all the basic types, and collection types too.
```ruby
# Optional TypeAnnotations
def funky(fresh: String, bacon: String) -> nil
  puts fresh + bacon
end

# What about Collections?
Collection[String] or ->Collection[->Object]
Collection[Int]

# You can declare you're own types/protocols using a protocol syntax:
Protocol String
  def << (String) ->String
  def + (String) ->String
  def pop ->String
end

# The protocol Syntax registers a global String Protocol attached to the String Class
# but you can store a reference to this protocol
string_Protocol = String.protocol

```

Check types at runtime: Using protocols we should add some builtin Object functions:
```ruby
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
def funky(fresh:->String,bacon:->String)
  puts
end
```

PROTOCOLS: Like in Swift, are named, an Object will have parameters, and expected input types


Data objects versus behaviour: Pure Data objects should be a possibilty at least. Something that just represents data and can be passed around, but that holds a lot inside of it. Maybe Classes are really Collections with associated data on lookup?

# Galaxy brain idea
So I was thinking, what if everything is an object? Right I already thought of that, but what if Blocks, Arrays, Collections, Builders, and Class Bodys are all pretty much the same type of object. A Builder object. What if everything is a builder object and once it builds you can iterate, query, redefine, stuff inside.

Let's look at an array:
```stim

	# Make an array
	list = {"literally", "just", "strings"}
	list.count
	# > 3

	list.each do |k, v| puts v end
	# > literally
	# > just
	# > strings

	list.each do |k, v| puts k end
	# > 0
	# > 1
	# > 2
```

The defining characeristics are that the values are sequential and the keys are integers. Ok, cool, but we can make a Hash or a Dictionary that does the same thing:
```stim
	# Make a Dictionary/Hash
	list = { 0:"literally", 1:"just", 2:"strings"}
	list.count
	# > 3

	list[0]
	# > literally
```

What if the construction for either of these are basically the same?
```ruby
	# Make a monster
	monster = {
		0: "thing",
		1: "another thign",
		name: "Demigorgon"
	}
	monster.name
	# > Demigorgon

	monster.count
	# > 3

	monster[0]
	# > thing

	monster[2]
	# > Demigorgon
```

Not bad, We can have arrays that have methods or properties. But what if we want an array that has those things, but that aren't counted among the values of the array? Maybe we can do a special construction for that:
```lua
	function Array(members)
		local array = {}
		array.__members = {}
		array.count = function() __members.count end
		array.each = function(block)
			local transformation = {}
			for k,v in __members do
				transformation = if_true((block(k,v)) -- adds to transformation if it's true.
			end
			return transformation
		end
		return array
	end

	-- make an Array
	names = {"Jim", "Kim", "Tim"}
	names.each(function (k,v) do
		puts k
	end)
	-- > Jim
	-- > Kim
	-- > Tim
```

A generic cunstructor function could figure out whats a member value, and what's a function. Even for dictionaries. I mean it would be pretty cool to make a class, then query the class with `each`. or to redefine the each function for an array, but just for that ONE array that you've got, simply by setting a key during it's construction.
