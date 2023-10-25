# Kona
Kona (or Konascript), is a small programming language for the web.

## Domains?:
* kona.sh
* kona-lang.org (redirects to kona.sh)
* konascript.org (redirects to kona.sh)

### Brew name?:
* kna?
* brew install konascript
### file name:
* kna
* install.kna

## Why?
Javascript is not the best. It's getting better, but ya know what... we could do better. I want a language that supports an expressive syntax to construct and manipulate Nested UI, in HTML. One that is purpose built for the needs of the web and it's interface, and one that responds to and makes UI responsive and interactive.

Purpose built for the web.

Composability is also a goal. Templating that works and looks like it belongs in the language, with language semantics to compile template strings into cacheable and quick templates. Contexts should be first class constructs, and it should be so damn easy that it's sick.

Animation: Expressive syntax to manipulate values over time, to broadcast the change of those values, and to provide in language facilities to ease from one value to another.

Buildable, Objects broadcast their initialization to their containing block and receive and bubble up event changes. Facilities for building view hierarchies. This requires a system to keep track of parent/child relationships. Probably reserving some variables to track these element would make sense.

```ruby
class Element
  def init(name)
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

DOM ready, an expressive API for querying, modifying, and monitoring the DOM. Responds to DOM changes by removing or adding corresponding DOM elements in code.

template able: Expressive syntax for creating, composing, and rendering xml based template systems, like SVG and HTML.
```ruby
	class NameTag < Element

		# You can write html directly into a Kona file. The template is stored as a special
		# Template type. Which is a concatenated string. The template is assigned to the name of
		# the custom tag that you declare, in the case of this template, it's nametag
		<nametag name="jimbo" data-controller="another attribute">
			<p>My Name</p>
		</nametag>

	end
```

The template syntax above is syntactic sugar for something like this:
```ruby
	ButtonList = Class.inheritFrom(Element)
	ButtonList.template = Template("nameTag", [[<nameTag name="jimbo" data-controller="another attribute">
		<p>My Name</p>
	</nameTag>]], {["name"] = "jimbo", ["data-controller"] = "another attribute"})
```

The `Template` class is important in this instance. By convention, the name of the template tag matches the containing object's name. But this doesn't have to be the case. giving the template an explicit assignment to local variable is also possible.
```ruby
	template_name = <nameTag name="jimbo" data-controller="another attribute">
			<p>My Name</p>
	</nameTag>
```

Objects can also be constructed almost instantly from valid JSON. Although always sanitize your inputs:
```json
obj = {
	"person": {
		"name": "Jim Kirk",
		"address": {
			"street": "55 Rosa Parks Dr",
			"street2": "",
			"city": "Victory City",
			"state": "California",
			"zip": "90210",
		},
		"phone": "555-992-5050"
	}
}
obj.type
# > <Object: 0x600002a58160> {
```

Valid string identifiers can omit enclosing quotes, but this wouldn't be valid json:

```json
{
	cars: [
		{
			make:"Mazda",
			model:"3",
			price:1399900,
		},
	]
}
```

Built in Facilities for sanitization of common input and for the validation of that input.

Object Oriented and Functional. Everything is an object, but functions are also first class objects. A simplified inheritance chain. Able to modify an existing object through inheritance, mixins, includes, and extends. Or maybe just a couple of those. First class functions are kinda interesting, when mixed with Object oriented programming. In Ruby, for example, everything is an object and you send messages to objects to get them to do stuff. If functions are first class objects then they can be stored. what's the default message that you send to a function? What are the default messages for objects?

Modular: Have a simple environment and module system.

Micro: A small surface area with a few sharp and powerful tools. Able to quickly build UI Interactions, and cool stuff with only a few attributes, but be small enough to never think twice about embedding it. Small surface area also means that it's easy to parse, and it's difficult to confuse with HTML and CSS.

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

    broadcast :someOtherEvent
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

Broadcast always broadcasts downward and bubble always broadcasts upwards. Separating the parent/child reception of this activity gives us some interesting opportunities. Brodcasting to a whole application could be achieved through a root object:

```ruby
window.broadcast :somethingNew
```

Bindable: An extension of events, and similar to how publishers and observers work in SwiftUI, we should have a system to Instantiate objects that observer the change of values in other objects and receive updates on these changes. This should also be something that builders tap in to so that they can re-run subsystems that rely on the built state of certain objects.

```ruby
# set up a cabinet storage spot
cabinet = {cheese: "Gouda"}

# make a plate, but pass a binding variable to it.
plate = Plate.new($cabinet.cheese)

# This then creates a callback in cabinet for whenever cheese changes, or cabinet dies.
# as the binding is passed to Plate, it could be used, or not. if a reference to the binding
# is saved somewhere in the context of Plate, then an event listener is created in Plate:

class Plate
	def init(cheese)
		# cheese is implicitly checked to see if it's a binding
		# if it is then a the value is saved and change callbacks
		# are created on self.
		@cheese = cheese
	end
end

# what the implicit binding looks like:
plate.when :cheese_changed do |event|
	# we're adding this event listener directly to the
end
# because cheese is a binding, not the value, we can add a subscriber,
# in this case, it's plate that is subscribing
cheese.add_subscriber(plate, for_event: :cheese_changed)

#for event is implied to be the proxys name, but when this is set is important.
# When you create a binding at a call site: Plate.new($cabinet.cheese), The binding/proxy
# object is made in that context, not in the init block that is subsequently called.
# by the time cheese reaches that block, it's already a proxy renamed to be a local variable
# in that block
```

I'm not sure how this one will work exactly though. It will need to be a fundamental thing in the language to allow redefining a variable and propagating that value downward in an efficient and easy way.

Maybe the `$` symbol is a proxy operator that makes a proxy object for a value, and that proxy object is what's passed downward. `$` could also check to see if the object passed to it is already a proxy, and if it is, then it doesn't re-proxy it. Maybe like this:

```lua

local all_proxies = {}

Proxy = function(value)
	t = {}
	t.___value = value

	setmetatable(t, {
		___value = value,
		__index = {
			return self.___value
		},
		__new_index = function(key, value)
			self.___value = value
		end,
	})

	all_proxies.add(value)
end

-- calls to `$value`, are transformed to this:
-- make_or_get_proxy(value)
function make_or_get_proxy(value_or_object)
	if type(value_or_object == proxy)
		return value_or_object
	else
		value_or_object = Proxy(value_or_object)
	end
end

-- set up a cabinet storage spot
cabinet = {cheese="Gouda"}

-- make a plate, but pass a binding variable to it.
local cheese_binding = make_or_get_proxy(cabinet.cheese)
plate = Plate:new(cheese_binding)
```

oh crap, this won't work. When you're tryin to index a value: `container.value_youre_indexing`, you're looking for that key in the object. In order to properly proxy and propagate a value's changes, you'll need to add a proxy to the containing object: `container` in this case. and that proxy will then grab the value for a value table, or pass along changes. Quite a bit of state will need to be set up in that instance.

So for this to work every object will need to have a metatable with `__index` and `__new_index` set up to look up the values that are just values, and return the proxies value for those that are not values. this is because we want to prevent direct assignments or reassignments of the proxied value, which could erase the proxy. I think we'll solve that by rewriting the assignment operator for objects to be something like this:
```lua
object = NewObject{cheese="Gouda"}

-- instead of object.cheese = "Cheddar"
object["cheese="]("Cheddar")
```
That means we index the `cheese=` function in object and pass it the value instead of directly setting the value. getters and setters are default proxies that we make for objects. Perhaps that does a lot of the work that we need for a proxy.


MetaProgrammatic: First class facilities for Meta programming, Although the design should strive for a simplified meta programming paradigm. Write code that writes code, but not actually too much code.

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
  def << (String) -> String
  def + (String) -> String
  def pop () -> String
end

# The protocol Syntax registers a global String Protocol attached to the String Class
# but you can store a reference to this protocol
string_Protocol = String.protocol
```

What about parameter names in functions? Their optional, but recommended. Additionaly you can pass an object in place of a parameter list and Kona will try to match the keys in order, first by popping matching keys, then by passing the remaining values in order, like variadic parameters.

Check types at runtime: Using protocols we should add some builtin Object functions:
```ruby
myObject.conformsTo(String)

# or make it only in function calls with types you get a special method:
def funky fresh:->String, bacon:->String|nil
  conforms? fresh:, bacon:
  puts fresh + bacon
end
```

Named Parameters: Functions on Objects/Collections should, or can use Named Parameters.
Symbol by Default Index: Symbolized or named keys on Collections by default, so you can do: a = {whatever="loser"} and you can access it's index with: a.whatever (ACTUALLY THIS IS BAD! What about methods on a collection object that match a named dictionary entry?) Maybe all objects should have internal storage for the basic types, and exposed methods will just use that internal storage. So that we can still do that dynamic object stuff. Not sure about this. Exposing more of Lua's semantics and power will make the language more flexible, but not exactly the idiomatic feeling that we're looking for.

Pattern Matching: When using named parameters in function calls or in collection constructors, locally named variables will be used to fill in the gaps.
```ruby
# Optional Type annotations.
def funky(fresh:->String,bacon:->String)
	sandwhich = {fresh:, bacon:}
	eat(sandwhich:)
end
```

PROTOCOLS: Like in Swift, are named, an Object will have parameters, and expected input types


Data objects versus behaviour: Pure Data objects should be a possibilty at least. Something that just represents data and can be passed around, but that holds a lot inside of it. Maybe Classes are really Collections with associated data on lookup?

# Galaxy brain idea
So I was thinking, what if everything is an object? Right I already thought of that, but what if Blocks, Arrays, Collections, Builders, and Class Bodys are all pretty much the same type of object. A Builder object. What if everything is a builder object and once it builds you can iterate, query, redefine, stuff inside.

Let's look at an array:
```ruby

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

The defining characteristics are that the values are sequential and the keys are integers. Ok, cool, but we can make a Hash or a Dictionary that does the same thing:
```ruby
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

A generic constructor function could figure out whats a member value, and what's a function. Even for dictionaries. I mean it would be pretty cool to make a class, then query the class with `each`. or to redefine the each function for an array, but just for that ONE array that you've got, simply by setting a key during it's construction.


## Another Galaxy brain idea
What if we take a feather out of Ruby's hat, but go one step further. What if, within the body of a builder, we can redefine the syntax for postfix and prefix operators, and what happens with them. I'm thinking `name = "Jim"` being redefined  to `["name="]("Jim")`, which is something that Ruby does, and the `name=` function is dynamically set. Ruby translates the syntax when it's added. What if we could do a little more than redefine getters and setters, but redefine prefix and postfix actions too?

```lua
	Tools = {
		-- redefine the assignment operator.
		["___postfix_function_="] = function(symbol, first, second) do
			-- make a function to assign the new variable.
			self[first.."="] = function(v)
				self.___values[second] = v
			end
			-- make a new function to access the new variable.
			self[first] = function()
				self.___values[first]
			end
		end
	}

	-- called internally from a table:
	local ObjectTable = {}
	function ObjectTable:new()
		local t = { __index = {}}
	end

	setmetatable(ObjectTable,ObjectTable)
	ObjectTable.__index = function()
	end

	-- function Parser:new(tokens)
	-- 	t = {
	-- 		current = 1,
	-- 		tokens = tokens,
	-- 		["ParserError"] = ParserError,
	-- 	}
	-- 	setmetatable(t,self)
	-- 	self.__index = self
	-- 	return t
	-- end


```
