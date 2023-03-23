as yet unclassified
spaceForInstance: anObject depth: anInteger seen: seenObjectsOrNil
	|result|
	seenObjectsOrNil ifNotNil: [(seenObjectsOrNil includes: anObject) ifTrue: [^ 0]].	
	(sizes includesKey: anObject) ifTrue: [^0]. "don't count double"
	

	result := sizes at: anObject ifAbsent: [ |size|
		size :=  self customSpaceForInstance: anObject depth: anInteger seen: seenObjectsOrNil.
		(anObject class isImmediateClass) ifFalse: [
			"or: [anObject isNumber] or: [anObject isString] "
			 sizes at: anObject put: size.
		].
		size		
	].

	seenObjectsOrNil ifNotNil: [seenObjectsOrNil add: anObject]. "don't want to count it again"
	^result.