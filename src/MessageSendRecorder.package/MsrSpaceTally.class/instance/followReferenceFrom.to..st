as yet unclassified
followReferenceFrom: anObject to: other
	^((false
		"(other isKindOf: Class)"
		"or: [(other isKindOf: Metaclass)]"
		or: [other isKindOf: Environment]
		or: [other class isImmediateClass]
		or: [other isNil]) 
			or: [other isBoolean]

			"take myself out of the equasion" 
			"or: [other class == MsrSpaceTally]
			or: [other class == MsrSpaceTallyReference]
			or: [other == references]
			or: [other == (references instVarNamed: #array)])"
			
				or: [ignoreBlock value: anObject value: other] 
	) not