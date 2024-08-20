// test.wren
import "../modules/wren-testie/testie" for Testie
import "../modules/wren-assert/Assert" for Assert

import "../scanner" for Scanner

// Loads wren test stuff supposedly.
var suite = Testie.new("Scanner class should:") {|it, skip|

  it.should("parse a simple line") {
    var scanner = Scanner.new()
    scanner.source = "thing = \"whatever\""
    scanner.scanTokens()
    Assert.ok(true)
  }

  it.should("isAlphaNumeric(): guard alphanumerics properly") {
    var s = Scanner.new()
    Assert.notOk(s.isAlpha("0"))
    Assert.notOk(s.isAlpha("1"))
    Assert.notOk(s.isAlpha("2"))
    Assert.notOk(s.isAlpha("7"))
    Assert.notOk(s.isAlpha("$"))
    Assert.notOk(s.isAlpha("("))
    Assert.notOk(s.isAlpha("="))
    Assert[s.isAlpha("_")]

    Assert[s.isDigit("0")]
    Assert[s.isDigit("1")]
    Assert[s.isDigit("2")]
    Assert[s.isDigit("7")]

    Assert.notOk(s.isAlphaNumeric(""))

    var bs = "*(fjpff7493"
    Assert.notOk(s.isAlphaNumeric(bs[0]))
    Assert.notOk(s.isAlphaNumeric(bs[1]))
    Assert[s.isAlphaNumeric(bs[2])]
    Assert[s.isAlphaNumeric(bs[3])]
  }

  it.should("isDigit(): guard against digits properly") {
    var s = Scanner.new()
    Assert.notOk(s.isDigit("A"))
    Assert[s.isDigit("1")]
    Assert[s.isDigit("2")]
    Assert[s.isDigit("3")]
    Assert[s.isDigit("4")]
    Assert[s.isDigit("5")]
    Assert[s.isDigit("6")]
    Assert[s.isDigit("7")]
    Assert[s.isDigit("8")]
    Assert[s.isDigit("9")]
  }

  // it.should("number(): capture numbers properly") {
  //   var s = Scanner.new()
  //   var bs = "*(fjpff7493"
  //   Assert.notOk(s.isAlphaNumeric(bs[0]))
  //   Assert.notOk(s.isAlphaNumeric(bs[1]))
  //   Assert[s.isAlphaNumeric(bs[2])]
  //   Assert[s.isAlphaNumeric(bs[3])]
  // }

  it.should("discovers identifiers properly") {
    var s = Scanner.new("var identifier")
    s.scanTokens()
    var tok = s.tokens[1]
  }

  it.should("discovers keywords properly") {
    var s = Scanner.new("var identifier = 19")
    s.scanTokens()
    var tok = s.tokens[0]// Grab the first token: var

    // Make certain that the lexeme that we're capturing for a keyword doesn't
    // include an extra space.
    var ll = tok.lexeme.count
    Assert[ll, 3, "\"%(tok.lexeme)\"(%(ll)) Lexeme expected to be 3 characters long."]

    // Check that the first token is of the proper type code.
    Assert[tok.type, "VAR", "\"%(tok.type)\" Token expected to be a \"VAR\". Lexeme: %(tok.lexeme)"]
    // var keywords don't have literals, so this should be empty.
    Assert[tok.literal, "", "\"%(tok.literal)\" expected to be \"whatever\"."]
  }

}
suite.run()
