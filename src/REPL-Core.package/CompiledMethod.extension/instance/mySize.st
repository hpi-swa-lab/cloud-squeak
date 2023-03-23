*REPL-Core
mySize ^ self byteSize + (self literals inject: 0 into: [:s :i | s + i mySize])