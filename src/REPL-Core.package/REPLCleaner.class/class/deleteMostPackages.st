as yet unclassified
deleteMostPackages

	Transcript showln: 'Starting to delete packages ...'.
	SystemChangeNotifier uniqueInstance doSilently: [ | toDelete |
		ClassDescription logCompiledSources: false.
		
		String compile: 'translated ^self'.
		
		"UIManager is in ToolBuilder- but we need it everywhere"
		UIManager category: 'System-Applications'.
		"from probes package"
		(Context respondsTo: #markQuickStep) ifTrue: [thisContext markQuickStep].
		
		"breaks in unload"
		PreferenceBrowser class compile: 'unregisterFromFlaps'.
		Project class compile: 'uiManager ^ DummyUIManager new'.
		GeeMailMorph class compile: 'unload'.
		DefaultExternalDropHandler class compile: 'unload'.
		AbstractLauncher class compile: 'deactivate'.
		
		toDelete := (self environment organization categories reject: [:category | self keepList anySatisfy: [:name | category beginsWith: name]]) reversed.
		toDelete := toDelete, ((toDelete collect: [:name | (name splitBy: '-') first]) reject: [:prefix | self keepList includes: prefix, '-']) withoutDuplicates.
		self cleanPreferences.
		
		"do this first as a bunch of test categories share a prefix with out keepList"
		TestCase allSubclasses do: #removeFromSystem.
		CustomHelp allSubclasses do: #removeFromSystem.
		
		Transcript showln: 'Deleting...'.
		toDelete withIndexDo: [:category :index |
			Transcript showln: ('{1}/{2} {3}' format: {index. toDelete size. category}).
			(PackageInfo named: category) extensionMethods do: [:method | (self keepClass: method actualClass) ifTrue: [method actualClass removeSelector: method selector]].
			
			self environment organization removeSystemCategory: category].
		
		"want to keep only the extension methods"
		self environment organization removeSystemCategory: 'Tools-Debugger'.
		
		"keeps some references"
		SystemChangeNotifier uniqueInstance releaseAll.
		EventManager cleanUp: true.
		self shouldDeleteMetacello ifFalse: [MetacelloProjectRegistration registry: MetacelloProjectRegistry new].
		Beeper clearDefault.
		(ImageSegmentLoader classPool at: #CompactClasses)
			at: 16 put: nil;
			at: 10 put: nil;
			at: 9 put: nil.
		SystemNavigation classPool at: #Default put: nil.
		(Smalltalk globals instVarNamed: #observers) copy do: [:o | Smalltalk globals removeObserver: o].
		EFontBDFFontReader removeFromSystem.
		EFontBDFFontReaderForRanges removeFromSystem.
		StrikeFontSet removeFromSystem.
		ExternalSettings registeredClients removeAll.
		
		String compile: 'displayProgressFrom: min to: max during: aBlock aBlock value: [:x | ]'.
		
		"large methods that lazy-initialize variables"
		UCSTable class removeSelector: #initializeGB2312Table.
		UCSTable class removeSelector: #initializeJISX0208Table.
		UCSTable class removeSelector: #initializeKSX1001Table.
		"disables decoding of these encodings"
		UCSTable classPool at: #KSX1001Table put: nil.
		UCSTable classPool at: #JISX0208Table put: nil.
		UCSTable classPool at: #GB2312Table put: nil.
		Unicode classPool at: #DecimalProperty put: nil.
		
		"remove some specifically large categories"
		Object compile: 'environment ^ self class environment'.
		self cleanSystemCategory.
		self cleanMultilingualCategory.
		self cleanCollectionsTextCategory.
		
		Object flushDependents.
		Behavior flushObsoleteSubclasses.
		Symbol cleanUp.
		Undeclared rehash]