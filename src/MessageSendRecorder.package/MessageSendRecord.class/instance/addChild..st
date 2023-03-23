enumerating
addChild: aRecord

	firstChild ifNil: [
		firstChild := aRecord.
		^aRecord
	].

	firstChild lastSibling nextSibling: aRecord.
	
	^aRecord
	