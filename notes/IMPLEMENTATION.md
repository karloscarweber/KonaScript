# IMPLEMENTATION

I've been reading a lot of stuff about Lua and it's implementation that has given me ideas about how to manage this whole thing.

Lua only has one complex data type, the table, and because that's all it's got, it's optimized for a lot of cool shit. String based keys are fast, any value can be used as a key, and tables that are being used as arrays are fast like arrays. In fact there are two tables for every table, a string based indexed table, and an integer based index table. This optimization makes lookups very fast. Certain object oriented behavior can be replicated, or synthesized using these patterns. Having only one complex data type also means that Lua can remain very simple and easy to reason about.

The design and implementation of the new language, Kona, then can be optimized to use Lua's strengths, while avoid it's weaknesses.

The hope for Kona is to make User Interface code on the web much easier to write and work with, while providing well documented and useful atomic pieces for working with this code.

Kona will be compiled to Lua, but run in a mildly customized LuaJIT environment. LuaJIT is REALLY fast, 10 to 50 times faster than Lua proper. I say mildly customized because I want to define the environment and interface of Kona 100% in Lua, this means changing defaults and translating Kona code to an intermediary Lua dialect. It's just Lua, but I'll add a ton of very specific functions and behaviour to get it to do what we want. I expect little, if anything will need to be written in C. Although even if we do need to implement somethings in C, I've already got a working version of the runtime using LuaJIT, compiled from C, so that means we can include it in the library, and then call the functions directly.

# Values in objects
In Lua the values of an object, or in almost every case, is stored directly in the value spot of an index.
```Lua
local object = {name = "Jim Kirk", rank = "Captain"}

-- Keys are: [name, rank]
-- Values are: ["Jim Kirk", "Captain"]
```

But following the value and access semantics of Lua means direct access to an objects/tables members and values. I think what we want is proxied access through accessor methods.

```Lua
local object = {}
object["name"] = function()
	return self.___values["name"]
end
object["name="] = function(new_value)
	return self.___values["name"] = new_value
end
```
The `["name="]` is a borrowed ruby idiom that wraps the assignment method of a property of an object rather than exposing the property directly. The internal structure of an object should then be something like this:
```Lua
Object = {
	___values = {},
	___proxys = {},
	__index = {}, -- The tables own index, packed with default Object methods
	__children = {},
	__parent = {}, -- a virutal reference to it's parent. maybe a weak reference.
	-- __siblings -- a virtual link to it's siblings
	-- metatable
}
```

Syntactically we'll interpret an assignment to a variable in an object as something like this:
```Kona
object = {}
object.name = "Spock"
```
Translated to:
```Lua
local object = declare_local_object(local_context, {})
object["name="]("Spock") -- Gets the local object named objct, then uses the assignment function stored at ["name="]
```

We're borrowing and using as much of Lua as possible, while adding syntactic sugar around the language. Lua is flexible enough that we can do this without much overhead.

### Some documents that I've found interesting about Lua

 * [The Implementation of Lua 5](https://www.lua.org/doc/jucs05.pdf)
 * [The Evolution of Lua](https://www.lua.org/doc/hopl.pdf)
 * [Exceptions in Lua](https://www.lua.org/gems/lpg113.pdf)
 * [Lua Array Utility](https://github.com/stephannv/lua.util)

### More ideas
Another thing I've been thinking about is using the language to write the language, To bootstrap core features from a smaller set of features. One such thing is postfix and prefix control statements that accept custom blocks. Like the `do {code} unless`. Why can't `unless` be written in kona? AND be a protected keyword.

### Some documents I Like about Programming languages generally:

* [The Next 700 ProgrammingLanguages](https://homepages.inf.ed.ac.uk/wadler/papers/papers-we-love/landin-next-700.pdf)
* [Article about compiling C to WebAssembly](https://surma.dev/things/c-to-webassembly/)
