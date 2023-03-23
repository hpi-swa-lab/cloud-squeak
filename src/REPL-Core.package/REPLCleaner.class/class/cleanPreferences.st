as yet unclassified
cleanPreferences

	| dict |
	Transcript showln: 'Cleaning preferences...'.
	
	dict := Preferences instVarNamed: #preferencesDictionary.
	(dict keys reject: [:selector | | name cls |
		name := (selector splitBy: '>') first.
		cls := Smalltalk classNamed: name.
		cls isNil or: [self keepClass: cls]]) do: [:key | dict removeKey: key].
	"maybe this better?"
	dict removeAll.
	
	(Preferences classPool at: #Parameters) keys do: [:key | ((key includesSubstring: 'Font') or: [(key includesSubstring: 'font') or: [key = #HaloSpecs or: [(key includesSubstring: 'Color') or: [key includesSubstring: 'color']]]]) ifTrue: [(Preferences classPool at: #Parameters) removeKey: key]].
	
	((Preferences classPool at: #Parameters) at: #PersonalDictionaryOfPreferences)
		at: #cpuWatcherEnabled
			put: nil;
		at: #automaticFlapLayout
			put: nil;
		at: #classicNavigatorEnabled
			put: nil;
		at: #navigatorOnLeftEdge
			put: nil