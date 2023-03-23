installing
install
	| tempPreviousMethod |
	tempPreviousMethod := self compiledMethod methodClass methodDictionary
		at: self compiledMethod selector.
		
	tempPreviousMethod isCompiledMethod not ifTrue: [
		self error: 'Someone else also wraps methods'].
	previousMethod := tempPreviousMethod.
	
	
	self compiledMethod methodClass methodDictionary
		at: self compiledMethod selector
		put: self.