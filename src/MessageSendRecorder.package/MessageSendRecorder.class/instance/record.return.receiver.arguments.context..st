recording - callbacks
record: returningRecord return: anReturnObject receiver: aReceiverObject arguments: someArgumentObjects context: aContext
	"Returns from a message send. Record information, then find the correct parent record to continue recording. Support non-local returns."
	
	
	(recordingMode == #duration) ifTrue: [
		(returningRecord endTime - returningRecord beginTime) < self minimumHighResDuration ifTrue: [
			returningRecord extension filteredChildren: returningRecord countSubtree. 
			returningRecord removeAllChildren. "don't record everything"
		]
	].	
	

	self
		recordInto: returningRecord
		return: anReturnObject
		receiver: aReceiverObject
		arguments: someArgumentObjects
		context: aContext.
	
	currentRecord == returningRecord
		ifTrue: [currentRecord := currentRecord parent]
		ifFalse: [ "Non-local return."
			currentRecord := currentRecord parent.
			[currentRecord == returningRecord]
				whileFalse: [currentRecord := currentRecord parent].	
			currentRecord := currentRecord parent].