ui requests
confirm: queryString
	self askForProvidedAnswerTo: queryString ifSupplied: [:answer | 
		^ answer].

	self error: 'No user response possible'