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
