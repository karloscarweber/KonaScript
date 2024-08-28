// test.wren
import "../modules/wren-testie/testie" for Testie
import "../modules/wren-assert/Assert" for Assert

import "../token" for Token, Tokens, Keywords
import "../modules/Extensions/error"  for Error
import "../modules/extensions/Shovel" for Shovel

var TokenTest = Testie.new("Token class should:") {|it, skip|

  it.should("Keywords class should return codes") {
    var result = Keywords["as"]
    Assert[result, "AS", "Keywords didn't return 'as', instead: %(result)"]
  }

  it.should("Make the right tokens from input.") {

    var tokens = Shovel.new()

    tokens << Token.new(Keywords["as"],        "as",        null, 1)
    tokens << Token.new(Keywords["break"],     "break",     null, 1)
    tokens << Token.new(Keywords["class"],     "class",     null, 1)
    tokens << Token.new(Keywords["construct"], "construct", null, 1)
    tokens << Token.new(Keywords["continue"],  "continue",  null, 1)
    tokens << Token.new(Keywords["else"],      "else",      null, 1)
    tokens << Token.new(Keywords["false"],     "false",     null, 1)
    tokens << Token.new(Keywords["for"],       "for",       null, 1)
    tokens << Token.new(Keywords["foreign"],   "foreign",   null, 1)
    tokens << Token.new(Keywords["if"],        "if",        null, 1)
    tokens << Token.new(Keywords["import"],    "import",    null, 1)
    tokens << Token.new(Keywords["in"],        "in",        null, 1)
    tokens << Token.new(Keywords["is"],        "is",        null, 1)
    tokens << Token.new(Keywords["null"],      "null",      null, 1)
    tokens << Token.new(Keywords["return"],    "return",    null, 1)
    tokens << Token.new(Keywords["static"],    "static",    null, 1)
    tokens << Token.new(Keywords["super"],     "super",     null, 1)
    tokens << Token.new(Keywords["this"],      "this",      null, 1)
    tokens << Token.new(Keywords["true"],      "true",      null, 1)
    tokens << Token.new(Keywords["var"],       "var",       null, 1)
    tokens << Token.new(Keywords["while"],     "while",     null, 1)

    // Assert[tokens[0], false, "Token isn't false! type: %(tokens[0].type), literal: %(tokens[0].literal), lexeme: %(tokens[0].lexeme), line: %(tokens[0].line)."]
    // System.print(tokens[0])

    Assert[tokens[0].type,  "AS",        "Token isn't The correct type: %(tokens[0].type)"]
    Assert[tokens[1].type,  "BREAK",     "Token isn't The correct type: %(tokens[1].type)"]
    Assert[tokens[2].type,  "CLASS",     "Token isn't The correct type: %(tokens[2].type)"]
    Assert[tokens[3].type,  "CONSTRUCT", "Token isn't The correct type: %(tokens[3].type)"]
    Assert[tokens[4].type,  "CONTINUE",  "Token isn't The correct type: %(tokens[4].type)"]
    Assert[tokens[5].type,  "ELSE",      "Token isn't The correct type: %(tokens[5].type)"]
    Assert[tokens[6].type,  "FALSE",     "Token isn't The correct type: %(tokens[6].type)"]
    Assert[tokens[7].type,  "FOR",       "Token isn't The correct type: %(tokens[7].type)"]
    Assert[tokens[8].type,  "FOREIGN",   "Token isn't The correct type: %(tokens[8].type)"]
    Assert[tokens[9].type,  "IF",        "Token isn't The correct type: %(tokens[9].type)"]
    Assert[tokens[10].type, "IMPORT",    "Token isn't The correct type: %(tokens[10].type)"]
    Assert[tokens[11].type, "IN",        "Token isn't The correct type: %(tokens[11].type)"]
    Assert[tokens[12].type, "IS",        "Token isn't The correct type: %(tokens[12].type)"]
    Assert[tokens[13].type, "NULL",      "Token isn't The correct type: %(tokens[13].type)"]
    Assert[tokens[14].type, "RETURN",    "Token isn't The correct type: %(tokens[14].type)"]
    Assert[tokens[15].type, "STATIC",    "Token isn't The correct type: %(tokens[15].type)"]
    Assert[tokens[16].type, "SUPER",     "Token isn't The correct type: %(tokens[16].type)"]
    Assert[tokens[17].type, "THIS",      "Token isn't The correct type: %(tokens[17].type)"]
    Assert[tokens[18].type, "TRUE",    "Token isn't The correct type: %(tokens[18].type)"]
    Assert[tokens[19].type, "VAR",    "Token isn't The correct type: %(tokens[19].type)"]
    Assert[tokens[20].type, "WHILE",     "Token isn't The correct type: %(tokens[20].type)"]

  }

}

TokenTest.run()
