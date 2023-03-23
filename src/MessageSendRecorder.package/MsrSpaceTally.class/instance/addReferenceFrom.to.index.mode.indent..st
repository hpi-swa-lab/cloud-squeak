as yet unclassified
addReferenceFrom: anObject to: other index: index  mode: mode indent: indent
	| ref |
	references ifNil: [^self].
	
	

	ref := (MsrSpaceTallyReference new fromObject: anObject; index: index; toObject: other; indent: indent; yourself).
	
	mode = #var ifTrue: [
		ref selector: (anObject class allInstVarNames at: index ifAbsent: index).
	].
	
	
	
	references add: ref.
	
	counter := counter + 1.
	