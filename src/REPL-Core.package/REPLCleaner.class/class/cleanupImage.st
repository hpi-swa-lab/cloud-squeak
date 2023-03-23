as yet unclassified
cleanupImage
	"startup code in new, minimal image"

	FileStream startUp: true.
	TranscriptStream redirectToStdOut: true.
	ToolSet default: REPLIsolatedToolset.
	
	Transcript showln: 'Starting to clean image ...'.
	self printObjectSpaceSize.
	
	Smalltalk cleanUp: true.
	
	self deleteProcesses.
	self deleteProjects.
	
	self printObjectSpaceSize.
	
	self deleteMostPackages.
	self deleteLargeMethods.
	self cleanPackageInfo.
	Smalltalk allClassesDo: [:c | c organization: nil].
	Smalltalk garbageCollect.
	Symbol rehash.
	self environment undeclared removeAll.
	HashedCollection allSubInstancesDo: [:collection | collection isReadOnlyObject ifFalse: [collection compact]].
	
	Smalltalk garbageCollect.
	self findPinned do: #unpin.
	Smalltalk garbageCollect.
	
	Transcript showln: 'Cleaned!'.
	
	self printObjectSpaceSize.
	self saveFinal.
	
	self writeSpaceTally.
	
	Transcript showln: 'Now launching telnet'.
	REPLStartUp new open
	"TODO: save a new minimal image and launch the function handler"