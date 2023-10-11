// chunk.c
#include <stdlib.h>

#include "chunk.h"
#include "memory.h"
#include "value.h"

// initialize a chunk for fun.
void initChunk(Chunk* chunk) {
  chunk->count = 0;
  chunk->capacity = 0;
  chunk->code = NULL;
  chunk->lines = NULL;
  initValueArray(&chunk->constants);
}

// WriteChunk writes a chunk bitch
void writeChunk(Chunk* chunk, uint8_t byte, int line) {
  // Grow the capacity if it's not big enought
  if (chunk->capacity < chunk->count +1) {
    int oldCapacity = chunk->capacity;
    chunk->capacity = GROW_CAPACITY(oldCapacity);
    chunk->code = GROW_ARRAY(uint8_t, chunk->code, oldCapacity, chunk->capacity);
    chunk->lines = GROW_ARRAY(int, chunk->lines, oldCapacity, chunk->capacity);
  }

  // Actually write the chunk
  chunk->code[chunk->count] = byte;
  chunk->lines[chunk->count] = line;
  chunk->count++;
}

// Adds a constant to a chunk
int addConstant(Chunk* chunk, Value value) {
  writeValueArray(&chunk->constants, value);
  return chunk->constants.count - 1;
}

// freeChunk frees a chunk from memory
void freeChunk(Chunk* chunk) {
  FREE_ARRAY(uint8_t, chunk->code, chunk->capacity);
  FREE_ARRAY(int, chunk->lines, chunk->capacity);
  initChunk(chunk);
}
