evaluating
valueWithReceiver: anObject arguments: anArrayOfObjects

	RecorderCode == true ifTrue: [
		^self clientMethod valueWithReceiver: anObject arguments: anArrayOfObjects].	

	^ random withArgs: anArrayOfObjects executeMethod: unwrappedMethod