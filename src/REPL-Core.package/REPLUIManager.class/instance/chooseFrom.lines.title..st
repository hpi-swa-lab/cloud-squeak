ui requests
chooseFrom: aList lines: linesArray title: aString
	self askForProvidedAnswerTo: aString ifSupplied: [:answer | 
		(answer = #cancel or: [answer isNil]) ifTrue: [^ 0].
		^ aList indexOf: answer].

	^ 1