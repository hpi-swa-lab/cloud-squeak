ui requests
inform: aString
	"Nothing to be done here"
	self askForProvidedAnswerTo: aString ifSupplied: [:answer | 
		^ answer].