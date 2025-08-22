# Development Plan

The next version of Kona will be based on the CLOX parser we already built, but be built in WAT, or (Web Assembly Text Format)[https://webassembly.github.io/spec/core/text/index.html]. The idea is to use _wat2wasm_ to compile our initial interpreter, written in WAT. Then write a new compiler written in Kona that compiles our Kona VM interpreter to WAT and then WASM. So Kona will be written in Kona. like you do.

I guess the first thing to do is to build something stupid in WAT and get it working. A cool resource for playing around with that is this (wat2wasm demo)[https://webassembly.github.io/wabt/demo/wat2wasm/].


## Steps
- [ ] Build a WAT compiler in Rust. Compiles an Intermediate language, we'll call it Rook, into WAT.
- [ ] Write kona in Rook, that compiles to WAT, to then get WAT working.
- [ ] Write a new compiler in KONA, using KONA WAT binaries, that compiles KONA to WAT.
- [ ] Now be awesome.
