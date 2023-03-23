as yet unclassified
cleanSystemCategory

	| keepList |
	DummySoundSystem class compile: 'unload'.
	keepList := #(#PrimitiveError #ExceptionInFFICallError #SecurityManager #SmalltalkImage #SystemDictionary #SystemNavigation #SystemOrganizer #SystemVersion #ClassReference #MethodReference #ExternalObjectTable #Preferences #Preference #PragmaPreference #DeepCopier #Locale #LocaleID #ObjectFinalizer #ObjectFinalizerCollection #WeakFinalizationList #WeakFinalizerItem #WeakRegistry #UIManager #AppRegistry #ToolSet #----------- #SpaceTally #SpaceTallyItem), ((PackageInfo named: 'System-Change Notification') classes collect: #name), ((PackageInfo named: 'System-Object Events') classes collect: #name).
	(PackageInfo named: 'System') classes reversed do: [:class | (keepList includes: class name) ifFalse: [class removeFromSystem]].
	
	"not in System- but keeps some unwanted references"
	EventSensor removeFromSystem.
	
	Preferences becomeForward: REPLPreferences.
	PragmaPreference removeFromSystem.
	Preference removeFromSystem