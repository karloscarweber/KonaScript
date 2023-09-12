# IMPLEMENTATION

I've been reading a lot of stuff about Lua and it's implementation that has given me ideas about how to manage this whole thing.

Lua only has one complex data type, the table, and because that's all it's got, it's optimized for a lot of cool shit. String based keys are fast, any value can be used as a key, and tables that are being used as arrays are fast like arrays. In fact there are two tables for every table, a string based indexed table, and an integer based index table. This optimization makes lookups very fast. Certain object oriented behaviour can be replicated, or synthesized using these patterns. Having only one complex data type also means that Lua can remain very simple and easy to reason about.

The design and implementation of the new language, Kona, then can be optimized to use Lua's strengths, while avoid it's weaknesses.

The hope for Kona is to make User Interface code on the web much easier to write and work with, while providing well documented and useful atomic pieces for working with this code.

### Some documents that I've found interesteing about Lua

 * [The Implementation of Lua 5](https://www.lua.org/doc/jucs05.pdf)
 * [The Evolution of Lua](https://www.lua.org/doc/hopl.pdf)
