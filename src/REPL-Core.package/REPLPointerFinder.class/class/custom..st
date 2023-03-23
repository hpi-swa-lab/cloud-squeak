as yet unclassified
custom: anObject

	| finder |
	finder := self new
		goal: anObject;
		search.
	^ finder pointerList