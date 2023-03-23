as yet unclassified
customSpaceForInstance: anObject depth: anInteger seen: seenObjectsOrNil

	| ctxt class basicSize depth total |
	seenObjectsOrNil ifNotNil: [
		(seenObjectsOrNil ifAbsentAdd: anObject) ifFalse: [^ 0]].
	(sizes includesKey: anObject) ifTrue: [^0]. "don't count double"
	sizes at: anObject put: -1. "working on it"
			
	ctxt := thisContext.
	class := ctxt objectClass: anObject.
	basicSize := 0.
	total := class isVariable
		ifTrue: [class byteSizeOfInstanceOfSize: (basicSize := ctxt objectSize: anObject)]
		ifFalse: [class isImmediateClass ifTrue: [0] ifFalse: [class byteSizeOfInstance]].
	(depth := anInteger - 1) >= 0 ifTrue: [
		anObject isCompiledCode
			ifTrue: [
				anObject literalsDo: [:literal | |other|
					total := total + (self spaceTallyAndFollowReferenceFrom: anObject to: literal via: literal mode: #literal seen: seenObjectsOrNil depth: depth).
				]]				
			ifFalse: [
				(class instSpec between: 2 and: 4) ifTrue: [ "only indexable objects, no bytes etc."
					1 to: basicSize do: [:index | |other|
						other :=  (ctxt object: anObject basicAt: index).
						(self followReferenceFrom: anObject to: other) ifTrue: [
							total := total + (self spaceTallyAndFollowReferenceFrom: anObject to: other via: index mode: #basic seen: seenObjectsOrNil depth: depth).
							]]].
				1 to: class instSize do: [:index | |other|
					other := (ctxt object: anObject instVarAt: index).
					total := total + (self spaceTallyAndFollowReferenceFrom: anObject to: other via: index mode: #var seen: seenObjectsOrNil depth: depth).
				]]].
	
	sizes at: anObject put: total. 
	
	^ total