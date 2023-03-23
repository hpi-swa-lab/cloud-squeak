ui requests
chooseFrom: labelList values: valueList lines: linesArray title: aString
	self askForProvidedAnswerTo: aString ifSupplied: [:answer | 
		(answer = #cancel or: [answer isNil]) ifTrue: [^ nil].
		^ valueList at: (labelList indexOf: answer) ifAbsent: [
				answer isNumber 
					ifTrue: [valueList at: answer ifAbsent: [nil]]
					ifFalse: [nil]]].
	
	^ valueList first