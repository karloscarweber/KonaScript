# Konajs
The JavaScript *FM* (Function Machine) implementation of KonaScript. Purpose of this machine is to scan, interpret, and translate Kona and execute it in a Functional Machine. Rather than implement a complete virtual machine in Javascript, the Function machine provides an *environment* and consistent API to replicate KonaScript on the web. KonaJS is implemented with Function code, rather than bytecode, it's a similar process to how Kona is implemented locally, by our code to equivalent Lua and executing it in a controlled environment.

In the hope of limiting the operations, or functions, Kona STILL uses a narrow set of function operations that could be represented With a byte.

## Design:
Kona's Function Machine is split into a few parts:
  * Scanner - Scans Kona Code and produces a Token Collection.
  * Tokens  - Collects Kona Tokens, and their definitions to transform into Functions
  * VM      - The virtual machine/environment that handles IO, and executes the kona functions.
  * stdlib  - A collection of Standard library features, and Kona code, used to provide the Kona Environment.
