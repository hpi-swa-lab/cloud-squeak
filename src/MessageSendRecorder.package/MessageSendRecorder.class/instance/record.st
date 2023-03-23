recording
record

	|  result |
	MsrMethodWrapper recorderCode: true.
	isFirstRecording := self topRecord isEmpty.
	recordingProcess := Processor activeProcess.
	
	instrumentationTime := [(wrappers := self createWrappers, self createWrappersForRandom)
		do: [:wrapper | wrapper install]] timeToRun.

	[[
		recordTime := [result := self sendMessage] timeToRun.
		^ result]
		ensure: [
			self reset.
			deinstrumentationTime := [wrappers do: [:wrapper | wrapper uninstall]] timeToRun.
			]
		
	] on: MsrRecordNotFound do: [:ex |
		deinstrumentationTime := [wrappers do: [:wrapper | wrapper uninstall]] timeToRun.
		wrappers := #().
		self notify: ('Re-recording failed. Expected record id {1} not found during a message send for parent {2}.' format: {ex expectedChildId. ex parentRecord printDetails})
	] on: Error, Halt, Warning do: [:ex |
		deinstrumentationTime := [wrappers do: [:wrapper | wrapper uninstall]] timeToRun.
		wrappers := #().
		ex pass].	
	
	MsrMethodWrapper recorderCode: false.
	^ nil