enumerating
getNextSibling

	| answerNext |
	self isTopRecord ifTrue: [^ nil].
	
	answerNext := false.
	self parent childrenDo: [:child |
		answerNext ifTrue: [^ child].
		child == self ifTrue: [answerNext := true]].
	^ nil