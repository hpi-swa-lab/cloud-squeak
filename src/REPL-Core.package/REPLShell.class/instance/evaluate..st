evaluating
evaluate: aString

	| value |
	"Evaluate aString and answer resuting value."
	value := self evaluator evaluate: aString onError: [:err |
		(err lastError isKindOf: Error)
			ifTrue: [self interface printError: err lastError description, String crlfcrlf, err lastError signalerContext longStack withUnixLineEndings]
			ifFalse: [self interface printError: err lastError asString withUnixLineEndings].
		^ nil].
	value ifNil: [^ nil].
	(value isString and: value isSymbol not) ifTrue: [^ value].
	^ value printString