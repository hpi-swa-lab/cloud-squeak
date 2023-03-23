recording
sendMessage
	"Simulate what method wrappers would do to the outermost message send."

	| node receiver arguments method returnValue  |
	node := self topRecord.
	receiver := self topRecord parent.
	method := self topRecord method.
	arguments := #().

	self recordingMode == #specificCall ifTrue: [
		^ receiver value].

	self
		recordInto: node
		receiver: receiver
		arguments: arguments
		context: thisContext.

	self recordingMode == #duration ifTrue: [
		node beginTime: Time highResClock.
	].
	
	MsrMethodWrapper recorderCode: false.
	returnValue := receiver value.
	MsrMethodWrapper recorderCode: true.
	
	self recordingMode == #duration ifTrue: [	
		node endTime: Time highResClock.
	].

	self
		recordInto: node
		return: returnValue
		receiver: receiver
		arguments: arguments
		context: thisContext.
			
	^ returnValue
