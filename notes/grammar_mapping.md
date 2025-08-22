# Grammar Mapping

So to build out the compiler, instead of the tokenizer, or scanner, a bit better I want to do a grammar mapping. This maps the grammar to token sequences by using the Grammar as a guide. This should help me to make the compiler better... I think.

The compiler now is kind of a single pass compiler, with no look ahead, what we want is a multi-pass compiler, that's a little recursive. We want to split up parts of the code into parseable blocks, line up the blocks as opcodes, then replace difficult opcodes with optimized opcode after an analysis step.

Anyways, let's work through the grammar
