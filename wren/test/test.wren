// test.wren
import "../modules/wren-testie/testie" for Testie
import "../modules/wren-assert/Assert" for Assert

import "../scanner" for Scanner

// Loads wren test stuff supposedly.
var suite = Testie.new("Scanner") {|it, skip|

  it.should("<Scanner> parses a simple line") {
    var scanner = Scanner.new()
    scanner.source = "thing = \"whatever\""
    scanner.scanTokens()
    // scanner.spitTokens()

    Assert.ok(true)

    // System.print("Scanner started")
    // var scanner = Scanner.new()
    // scanner.source = "thing = \"whatever\""
    // System.print(scanner.source)
    // scanner.scanTokens()
    // System.print()
    // scanner.spitTokens()
  }

  /* Unit Test Utilities */
  it.should("<Scanner> tests alphanumerics properly") {
    var s = Scanner.new()
    Assert.notOk(s.isAlpha("0"))
    Assert.notOk(s.isAlpha("1"))
    Assert.notOk(s.isAlpha("2"))
    Assert.notOk(s.isAlpha("7"))
    Assert.notOk(s.isAlpha("$"))
    Assert.notOk(s.isAlpha("("))
    Assert.notOk(s.isAlpha("="))
    Assert.ok(s.isAlpha("_"))

    Assert.ok(s.isDigit("0"))
    Assert.ok(s.isDigit("1"))
    Assert.ok(s.isDigit("2"))
    Assert.ok(s.isDigit("7"))

    Assert.notOk(s.isAlphaNumeric(""))

    var bs = "*(fjpff7493"
    Assert.notOk(s.isAlphaNumeric(bs[0]))
    Assert.notOk(s.isAlphaNumeric(bs[1]))
    Assert.ok(s.isAlphaNumeric(bs[2]))
    Assert.ok(s.isAlphaNumeric(bs[3]))
  }

  it.should("<Scanner> discovers identifiers properly") {
    var s = Scanner.new("var identifier")
    s.scanTokens()
  }

  it.should("<Scanner> discovers keywords properly") {
    var s = Scanner.new("var identifier")
    s.scanTokens()
    var tok = s.tokens[0]
    // System.print(s.tokens[0])
    Assert.equal(tok.type, "KEYWORD", "\"%(tok.type)\" Token expected to be a \"KEYWORD\".")
    // Assert.equal(tok.lexeme, "var", "\"%(tok.lexeme)\" lexeme expected to be a \"var\".")
    Assert.equal(tok.literal, "", "\"%(tok.literal)\" expected to be \"whatever\".")
  }

}
suite.run()
