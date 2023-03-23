enumerating
lastSibling

	nextSibling ifNil: [^self].
	
	^nextSibling lastSibling