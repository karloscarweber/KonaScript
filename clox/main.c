// hello_world.c
#include <stdio.h>
#include "common.h"
#include "chunk.h"
#include "debug.h"
#include "vm.h"
#include "value.h"

int main(int argc, const char* argv[]) {
  initVM();

  if (argc == 1){
    repl();
  } else if (argc == 2) {
    runFile(argv[1]);
  } else {
    fprintf(stderr, "Usage: clox [path]\n");
    exit(64);
  }

  freeVM();
  return 0;
}
