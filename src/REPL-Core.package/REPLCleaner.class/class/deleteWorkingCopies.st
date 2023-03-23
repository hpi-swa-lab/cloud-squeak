as yet unclassified
deleteWorkingCopies

	Transcript showln: 'Starting to delete packages ...'.
	SystemChangeNotifier uniqueInstance doSilently: [ | toDelete actualToDelete |
		ClassDescription logCompiledSources: false.
		
		"UIManager is in ToolBuilder- but we need it everywhere"
		UIManager category: 'System-Applications'.
		
		"breaks in unload"
		PreferenceBrowser class compile: 'unregisterFromFlaps'.
		Project class compile: 'uiManager ^ DummyUIManager new'.
		
		toDelete := (MCWorkingCopy allManagers reject: [:wc | #('Kernel' 'Collections' 'Files' 'Network' 'PackageInfo' 'Compiler' 'System' 'Traits' 'Environments' 'SqueakSSL' 'WebClient' 'Regex-Core' 'Chronology-Core' 'JSON' 'Metacello' 'Gofer' 'STON' 'OSProcess' 'Multilingual' 'Compression' 'CommandLine' '********************' 'Ocompletion' 'VB-Regex' 'Tools' 'REPL-Core') anySatisfy: [:name | wc package name beginsWith: name]]) reversed.
		actualToDelete := toDelete first: (toDelete size * 1) rounded.
		SBToggledCode comment: '' active: 0 do: {
			[(toDelete copyFrom: (toDelete size * 0.16) rounded to: (toDelete size * 0.175) rounded) do: [:p | Transcript showln: p]]}.
		Transcript showln: 'Deleting...'.
		actualToDelete do: [:category |
			Transcript showln: category.
			category unload]]