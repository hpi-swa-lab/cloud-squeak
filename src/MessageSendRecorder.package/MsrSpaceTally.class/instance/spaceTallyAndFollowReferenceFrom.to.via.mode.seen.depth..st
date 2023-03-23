as yet unclassified
spaceTallyAndFollowReferenceFrom: anObject to: other via: index mode: mode seen: seenObjectsOrNil depth: depth
	(self followReferenceFrom: anObject to: other) 
		ifTrue: [
			"experimental finding roots of heap of objects"
			"currentRoot ifNotNil: [
				roots at: other ifPresent: [ :rootReference |
					rootReference ifNotNil: [
						currentRoot children add: rootReference.
						currentRoot children addAll: rootReference children.
						roots at: other put: nil.
					]	   
				]
			]."
	
			maxCounter ifNotNil: [
				counter > maxCounter ifTrue: [^0].
			
			].
			
	
			
			((seenObjectsOrNil includes: other) or: [(sizes includesKey: other)]) 
				ifTrue: [
					^0 "alread seen"
				]
				ifFalse: [
					self addReferenceFrom: anObject to: other index: index mode: mode indent: self depth - depth. 
					^(self spaceForInstance: other depth: depth seen: seenObjectsOrNil)
				].
			
		]
	ifFalse: [
		^0
		"^(anObject respondsTo: #byteSize) ifTrue: [anObject byteSize] ifFalse: [anObject basicSize * 8] "
		
		"we are in a 64 bit system"
	].
	