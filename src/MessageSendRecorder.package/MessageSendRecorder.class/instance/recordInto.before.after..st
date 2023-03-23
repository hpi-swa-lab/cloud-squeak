public
recordInto: record before: someBeforeBlocks after: someAfterBlocks
	"Record additional information into a specific record."
	
	self assert: [self topRecord firstChild].
	self assert: [self topRecord includes: record].

	record class == MessageSend ifTrue: [self halt].

	currentRecord := record.
	
	^ self
		record: #specificCall
		before: someBeforeBlocks
		after: someAfterBlocks