#include <stdio.h>
#include <stdlib.h>

#include "common.h"
#include "compiler.h"
#include "scanner.h"

typedef struct {
	Token current;
	Token previous;
	bool hadError;
	bool panicMode;
} Parser;

Parser parser;

static void errorAt(Token* token, const char* message) {
	if (parser.panicMode) return;
	parser.panicMode = true;
	fprintf(stderr, "[line %d] Error", token->line);
	
	if (token->type == TOKEN_EOF) {
		fprintf(stderr, " at end");
	} else if (token->type == TOKEN_ERROR) {
		// Nothing.
	} else {
		fprintf(stderr, " at '%.*s'", token->length, token->start);
	}
	
	fprintf(stderr, ": %s\n", message);
	parser.hadError = true;
}

static void error(const char* message) {
	errorAt(&parser.previous, message);
}

static void errorAtCurrent(const char* message) {
	errorAt(&parser.current, message);
}

static void advance() {
	parser.previous = parser.current;
	
	for (;;) {
		parser.current = scanToken();
		if (parser.current.type != TOKEN_ERROR) break;
		
		errorAtCurrent(parser.current.start);
	}
}

bool compile(const char* source, Chunk* chunk) {
	initScanner(source);
	
	parser.hadError = false;
	parser.panicMode = false;
	
	advance();
	experession();
	consume(TOKEN_EOF, "Expect end of expression.");
	return !parser.hadError;
}
