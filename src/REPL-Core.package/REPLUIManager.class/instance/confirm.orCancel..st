ui requests
confirm: aString orCancel: cancelBlock
	self askForProvidedAnswerTo: aString ifSupplied: [:answer | 
		^ (answer = #cancel or: [answer isNil]) 
			ifTrue: [cancelBlock value]
			ifFalse: [answer]].

	self error: 'No user response possible'