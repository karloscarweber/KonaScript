# Grammar
Trying to write a Grammer almost as small as Lua's in Extended BNF. To start, we'll mirror Lua's Grammar, then make changes. {A} means 0 or more As. [A] means an optional A.

**Names** or **Identifiers** are strings of latin letters, digits, and underscores. They cannot begin with a digit or a reserved word. Identifiers are used to name variables, table fields, and labels.

**keywords** are reserved words used to build language constructs, these are reserved words and cannot be used as *Names* or *Identifiers*. **Keywords** are case sensitive, and in a case sensitive language won't be trigged by *Names* or *Identifires* with the same characters but different case.
```
  and     break   do       else     elseif    end
  false   for     func     goto     if        in
  let     nil     not      or       repeat    return
  then    true    until    while    when      unless
```

Other tokens:
```
  +     -     *     /     %     ^
  &     ~     |     <<    >>    //    ||=
  ==    !=    <=    >=    <     >     =
  (     )     {     }     [     ]     ::
  ;     :     ,     .     ..    ...
```

Comments are delimited by a **Hash** symbol: `#`.
```
# This is a comment
```



```
  chunk ::= block

  block ::= {stat} [retstat]
```
