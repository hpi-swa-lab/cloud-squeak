ui requests
request: queryString initialAnswer: defaultAnswer
	self askForProvidedAnswerTo: queryString ifSupplied: [:answer | 
		^ answer = #default
				ifTrue: [defaultAnswer]
				ifFalse: [answer]].

	self error: 'No user response possible'