evaluating
valueWithReceiver: anObject arguments: anArrayOfObjects record: record

	RecorderCode := true.
	

	record beginTime: Time highResClock.
	RecorderCode := false.
	
	^[
		"self clientMethod valueWithReceiver: anObject arguments: anArrayOfObjects"
		super valueWithReceiver: anObject arguments: anArrayOfObjects record: record
		
		] ensure: [
		RecorderCode := true. 
		record endTime: Time highResClock .
		"record extension duration: (Duration  milliSeconds: (record extension endTime - record extension time))."
	]
	