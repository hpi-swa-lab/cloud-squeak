evaluating
valueWithReceiver: anObject arguments: anArrayOfObjects

	| context record returnValue |	

	

	"cheap COP using one global variable to limit scope"	
	RecorderCode == true ifTrue: [
		^  self clientMethod valueWithReceiver: anObject arguments: anArrayOfObjects].	

	recorder shouldRecord ifFalse: [
		^ self clientMethod valueWithReceiver: anObject arguments: anArrayOfObjects].
	
	RecorderCode := true.
	
	counter := counter + 1.
	
	counter > MaxCalls ifTrue: [
		self uninstall. 		
	].
	
	
	unwrappedMethod ifNotNil: [
		context := thisContext sender "run:with:in:" sender.
		record := (recorder
			recordSendId: (numCallsBefore := numCallsBefore + 1)
			method: unwrappedMethod
			receiver: anObject
			arguments: anArrayOfObjects
			context: context).
	].
	RecorderCode := false.
		
	returnValue := self valueWithReceiver: anObject arguments: anArrayOfObjects record: record.
		

	RecorderCode := true.
	
	record ifNotNil: [
		recorder
			record: record
			return: returnValue
			receiver: anObject
			arguments: anArrayOfObjects
			context: context.
	].
	RecorderCode := false.
	
	^ returnValue