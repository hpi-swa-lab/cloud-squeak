as yet unclassified
findPinned

	^ Array streamContents: [:s | self systemNavigation allObjectsDo: [:x | (x isPinned and: [x isNumber not]) ifTrue: [s nextPut: x]]]