as yet unclassified
minimalStartupResuming: aBoolean

	Transcript cr; show: 'Startup'.
	
	self minimalStartUpList do: [:name | Smalltalk at: name ifPresent: [:cls | cls startUp: aBoolean]].
	
	

	
	FileDirectory
		setDefaultDirectoryClass;
		setDefaultDirectory: (FileDirectory dirPathFor: Smalltalk imageName).
		
	
	Transcript cr; show: 'FileDirectory: ', FileDirectory default.