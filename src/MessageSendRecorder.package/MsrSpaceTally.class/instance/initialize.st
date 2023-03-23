as yet unclassified
initialize
	sizes := IdentityDictionary new.

	rootObject := Object new.
	sizes at: rootObject put: 0.
	
	
	references := OrderedCollection new.	
	roots :=  IdentityDictionary new.
	counter := 0.

	"ignoreBlock := [:object :other | false]"
	ignoreBlock :=  [ :object :other	|
		(false 
		or: [other == Display] "because of their hard references in compiled methods"
		or: [other == Sensor]
		or: [other == Processor]
		or: [other isKindOf: Project] "lots of class variables etc"
		or: [other isKindOf: PasteUpMorph])
		or: [other isKindOf: SystemWindow]
	]

	