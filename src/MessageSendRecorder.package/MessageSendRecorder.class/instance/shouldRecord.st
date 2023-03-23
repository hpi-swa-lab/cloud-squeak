recording - callbacks
shouldRecord

	^active == true and: [Processor activeProcess == recordingProcess]