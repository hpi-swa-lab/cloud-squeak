as yet unclassified
deleteProjects

	Transcript showln: 'Deleting projects...'.
	Project allProjects copy do: [:p |
		ProjectHistory forget: p.
		Project deletingProject: p].
	Project clearCurrent.
	
	self cleanupDisplay.
	
	ActiveHand := nil.
	ActiveWorld := nil.
	ActiveEvent := nil.
	World := nil.
	ScriptingSystem := nil.
	Sensor := nil.
	CustomEventsRegistry := nil.
	TextConstants removeAll.
	(Url classPool at: #SchemeRegistry) removeKey: 'git' ifAbsent: [].
	(FileServices classPool at: #FileReaderRegistry) removeAll.
	
	ChangeSet removeChangeSetsNamedSuchThat: [:cs | true].
	Smalltalk at: #OCompletionTable ifPresent: [:c | c reset].
	
	Smalltalk garbageCollect