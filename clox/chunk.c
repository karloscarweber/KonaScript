// chunk.c
#include <stdlib.h>

#include "chunk.h"
#include "memory.h"

// initialize a chunk for fun.
void initChunk(Chunk* chunk) {
  chunk->count = 0;
  chunk->capacity = 0;
  chunk->code = NULL;
}

// WriteChunk writes a chunk bitch
void writeChunk(Chunk* chunk, uint8_t byte) {
  // Grow the capacity if it's not big enought
  if (chunk->capacity < chunk->count +1) {
    int oldCapacity = chunk->capacity;
    chunk->capacity = GROW_CAPACITY(oldCapacity);
    chunk->code = GROW_ARRAY(uint8_t, chunk->code, oldCapacity, chunk->capacity);
  }

  // Actually write the chunk
  chunk->code[chunk->count] = byte;
  chunk->count++;
}

// freeChunk frees a chunk from memory
void freeChunk(Chunk* chunk) {
  FREE_ARRAY(uint8_t, chunk->code, chunk->capacity);
  initChunk(chunk);
}
