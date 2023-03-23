*REPL-Core
mySize ^ (self respondsTo: #byteSize) ifTrue: [self byteSize] ifFalse: [self basicSize * 8]