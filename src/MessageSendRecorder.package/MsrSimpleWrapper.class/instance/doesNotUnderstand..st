error handling
doesNotUnderstand: aMessage

	previousMethod ifNotNil: [^ aMessage sendTo: previousMethod].
	super doesNotUnderstand: aMessage