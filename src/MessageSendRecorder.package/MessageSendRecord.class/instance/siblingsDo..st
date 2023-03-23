enumerating
siblingsDo: block

	nextSibling ifNil: [^self].
	
	block value: nextSibling. 
	
	^nextSibling siblingsDo: block