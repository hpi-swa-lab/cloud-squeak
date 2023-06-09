ui requests
saveFilenameRequest: queryString initialAnswer: defaultAnswer 
	"Open a FileSaverDialog to ask for a place and filename to use for saving a file. The initial suggestion for the filename is defaultAnswer but the user may choose any existing file or type in a new name entirely"

	self askForProvidedAnswerTo: queryString ifSupplied: [:answer | 
		^ answer = #default
				ifTrue: [defaultAnswer]
				ifFalse: [answer]].

	self error: 'No user response possible'