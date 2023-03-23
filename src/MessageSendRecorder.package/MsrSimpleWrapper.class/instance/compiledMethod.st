private
compiledMethod

	previousMethod ifNotNil: [^ previousMethod].
	^ self methodReference compiledMethod