as yet unclassified
deleteProcesses

	Transcript showln: 'Starting to delete processes ...'.
	Project current uiProcess terminate.
	Sensor eventTicklerProcess terminate.
	Sensor interruptWatcherProcess terminate