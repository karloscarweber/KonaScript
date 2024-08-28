// namespacetest.wren

class thing {
  static name { "thing" }
  static yell { "Whats UP!" }
}

class otherthing {
  static thing { thing }

  static name { "otherthing" }
}

var stm = System

stm.print(thing)
stm.print(otherthing)
stm.print(otherthing.thing.yell)
