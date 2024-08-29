// test.wren
import "../modules/wren-testie/testie" for Testie
import "../modules/wren-assert/Assert" for Assert

import "../kona" for Kona

var Parser = Kona.Parser

// Loads wren test stuff supposedly.
var suite = Testie.new("Compiler class should:") {|it, skip|

  it.should("start up") {
    var parser = Parser.new("{json:\"value\"}")
    parser.konaScan()
    Assert.ok(true)
    parser.spitTokens()
  }

  //it.should("parse a simple line") {
  //  var scanner = Parser.new("thing = \"whatever\"")
  //  scanner.scanTokens()
  //  Assert.ok(true)
  //}
//
//  it.should("isAlphaNumeric(): guard alphanumerics properly") {
//    var s = Parser.new()
//    Assert.notOk(s.isAlpha("0"))
//    Assert.notOk(s.isAlpha("1"))
//    Assert.notOk(s.isAlpha("2"))
//    Assert.notOk(s.isAlpha("7"))
//    Assert.notOk(s.isAlpha("$"))
//    Assert.notOk(s.isAlpha("("))
//    Assert.notOk(s.isAlpha("="))
//    Assert[s.isAlpha("_")]
//    Assert[s.isDigit("0")]
//    Assert[s.isDigit("1")]
//    Assert[s.isDigit("2")]
//    Assert[s.isDigit("7")]
//    Assert.notOk(s.isAlphaNumeric(""))
//    Assert.notOk(s.isAlphaNumeric("*"))
//    Assert.notOk(s.isAlphaNumeric("("))
//    Assert[s.isAlphaNumeric("f")]
//    Assert[s.isAlphaNumeric("j")]
//  }
//
//  it.should("isDigit(): guard against digits properly") {
//    var s = Parser.new()
//    Assert.notOk(s.isDigit("A"))
//    Assert[s.isDigit("1")]
//    Assert[s.isDigit("2")]
//    Assert[s.isDigit("3")]
//    Assert[s.isDigit("4")]
//    Assert[s.isDigit("5")]
//    Assert[s.isDigit("6")]
//    Assert[s.isDigit("7")]
//    Assert[s.isDigit("8")]
//    Assert[s.isDigit("9")]
//  }
//
//  it.should("number(): capture numbers properly") {
//    var s = Parser.new("var 99.65")
//    s.scanTokens()
//    var tok = s.tokens[1]
//
//    // Make certain that the lexeme that we're capturing for a number is the
//    // right size.
//    var ll = tok.lexeme.count
//    Assert[ll, 5, "\"%(tok.lexeme)\"(%(ll)) Lexeme expected to be 5 characters long."]
//
//    // Check that the first token is of the proper type code.
//    Assert[tok.type, "NUMBER", "\"%(tok.type)\" Token expected to be a \"NUMBER\". Lexeme: %(tok.lexeme)"]
//    // var keywords don't have literals, so this should be empty.
//    Assert[tok.literal, "", "\"%(tok.literal)\" expected to be \"whatever\"."]
//
//    var d = Parser.new("var 20030")
//    d.scanTokens()
//    var tok2 = d.tokens[1]
//
//    Assert[tok2.literal]
//  }
//
//  it.should("skip white space, tabs and spaces, appropriately") {
//    var s = Parser.new("var identifier")
//    s.scanTokens()
//
//    var tok = s.tokens[0]
//    var ll = tok.lexeme.count
//    Assert[ll, 3, "\"%(tok.lexeme)\"(%(ll)) Lexeme expected to be 3 characters long."]
//
//    var tok2 = s.tokens[1]
//    ll = tok2.lexeme.count
//    Assert[ll, 10, "\"%(tok2.lexeme)\"(%(ll)) Lexeme expected to be 10 characters long."]
//    Assert[tok2.lexeme, "identifier", "\"%(tok2.lexeme)\" Lexeme expected to be: \"identifier\"."]
//    Assert[ll, 10, "\"%(tok2.lexeme)\"(%(ll)) Lexeme expected to be 10 characters long."]
//  }
//
//  it.should("discovers identifiers properly") {
//    var s = Parser.new("var identifier")
//    s.scanTokens()
//    var tok = s.tokens[1]
//    var ll = tok.lexeme.count
//    Assert[ll, 10, "\"%(tok.lexeme)\"(%(ll)) Lexeme expected to be 10 characters long."]
//    Assert[tok.lexeme, "identifier", "\"%(tok.lexeme)\" Lexeme expected to be: \"identifier\"."]
//  }
//
//  it.should("parse strings properly") {
//    var s = Parser.new("var name = \"Karl\"")
//    s.scanTokens()
//    var tok = s.tokens[3]
//    var ll = tok.lexeme.count
//    // Assert[ll, 10, "\"%(tok.lexeme)\"(%(ll)) Lexeme expected to be 10 characters long."]
//    Assert[tok.type, "Karl", "\"%(tok.type)\" type expected to be: \"string\"."]
//  }
//
//  it.should("discovers keywords properly") {
//    var s = Parser.new("var identifier = 19")
//    s.scanTokens()
//    var tok = s.tokens[0]// Grab the first token: var
//
//    // Make certain that the lexeme that we're capturing for a keyword doesn't
//    // include an extra space.
//    var ll = tok.lexeme.count
//    Assert[ll, 3, "\"%(tok.lexeme)\"(%(ll)) Lexeme expected to be 3 characters long."]
//
//    // Check that the first token is of the proper type code.
//    Assert[tok.type, "VAR", "\"%(tok.type)\" Token expected to be a \"VAR\". Lexeme: %(tok.lexeme)"]
//    // var keywords don't have literals, so this should be empty.
//    Assert[tok.literal, "", "\"%(tok.literal)\" expected to be \"whatever\"."]
//  }
//
//  it.should("protect against going out of bounds with advance()") {
//    var s = Parser.new("0123456789")
//                // 0 starts here
//    s.advance() // 1 Inaugural advance in scanToken,
//    s.advance() // 2
//    s.advance() // 3
//    s.advance() // 4
//    s.advance() // 5
//    s.advance() // 6
//    s.advance() // 7
//    s.advance() // 8
//    s.advance() // 9
//    Assert[s.current, 9, "It's not 9.  %(s.current)"]
//    s.advance() // 10
//    Assert[s.isAtEnd(), true, "It's not time? %(s.current), %(s.source.count)"]
//  }

}

// Run the tests
suite.run()
