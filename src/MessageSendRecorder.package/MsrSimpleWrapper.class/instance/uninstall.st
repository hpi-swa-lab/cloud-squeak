installing
uninstall
	| currentMethod |
	currentMethod := self compiledMethod methodClass methodDictionary
		at: self compiledMethod selector.
		
	currentMethod ~= self ifTrue: [
		"self error: 'someone else changed the method dictionary in the meantime, this is dangerous'"
		
		^self "ingore it...."
	].
	
	self compiledMethod methodClass methodDictionary
		at: self compiledMethod selector
		put: previousMethod.