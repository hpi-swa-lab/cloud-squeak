chrome trace
asChromeTraceSaveOnFileNamed: fileName
	| bufferSize event |

	eventCounter := 0.
	"manually create  a JSON file, because of performance issues with growing big strings, and writing directly in streams"
	FileDirectory default forceNewFileNamed: fileName do: [:stream | |stringBuffer|		
		bufferSize :=   100 * 1024.
		stringBuffer := WriteStream on: (String new: bufferSize).
		stringBuffer << '{"traceEvents":['.
			
		self allRecordsBegin: [:record | 
			event := record asChromeTraceIn: self.
			eventCounter := eventCounter + 1.
						
			stringBuffer position > (0.8 * bufferSize) ifTrue: [
				"flush"
				stream << stringBuffer contents. 
				stringBuffer position: 0.
			].
			
			event jsonWriteOn: stringBuffer.
			"stringBuffer << each asJsonString."

			stringBuffer << ','.
		] end: [:record | 
		"BEGIN END events have problems... so use X"
		].
	
		stringBuffer << ']}'.	
		stream << stringBuffer contents.
	].