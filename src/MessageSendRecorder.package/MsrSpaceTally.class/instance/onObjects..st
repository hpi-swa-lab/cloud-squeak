as yet unclassified
onObjects: objects
	|restObject size |
	restObject := MsrSpaceTallyLabel new label: 'REST'; yourself.
	self references add: (MsrSpaceTallyReference new fromObject: rootObject; selector: 'rest'; toObject: restObject; indent: 0; yourself).	
		
	size := 0.
	"allReferences := self references."
	
	[
		objects withIndexDo: [ :object :index| 
			((self sizes at: object ifAbsent: [nil]) isNil 
				and: [maxCounter isNil or: [counter < maxCounter]]
				and: [self followReferenceFrom: restObject to: object ]
				and: [(object isKindOf: MsrSpaceTallyReference) not])
				ifTrue:  [
					"experimental root finding?"
					"aRoot := (MsrSpaceTallyReference new fromObject: restObject; selector: 'inRest'; toObject: object; indent: 1; children: OrderedCollection new; yourself).
					currentRoot := aRoot.
					references :=  aRoot children.
					references add: aRoot.
					roots at: object put: aRoot."
					
					
					references add: (MsrSpaceTallyReference new fromObject: restObject; selector: 'inRest'; toObject: object; indent: 1; children: OrderedCollection new; yourself).


					size := size + (self spaceForInstance: object depth: self depth - 2).			
			]
		].
	] ensure: [
		"self references: allReferences."
		self sizes at: restObject put:  size.	
		self sizes at: rootObject put: (self sizes at: rootObject) + size.
	]

	
