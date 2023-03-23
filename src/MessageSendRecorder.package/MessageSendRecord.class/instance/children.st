accessing
children
	
	| result |
	result := OrderedCollection new.
	
	firstChild ifNotNil: [
		firstChild selfAndAllSiblingsDo: [ :each |
			result addLast: each. 
		
		].		
	].
	^result