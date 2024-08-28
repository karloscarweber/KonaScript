// test.wren
import "../modules/wren-testie/testie" for Testie
import "../modules/wren-assert/Assert" for Assert

import "../compiler" for Compiler

// Loads wren test stuff supposedly.
var suite = Testie.new("Compiler should spit tokens:") {|it, skip|

  it.should("parse a simple line") {
    var scanner = Compiler.new("thing = \"whatever\"")
    scanner.scanTokens()
    scanner.spitTokens()
  }

}

// Run the tests
suite.run()
