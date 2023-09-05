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
