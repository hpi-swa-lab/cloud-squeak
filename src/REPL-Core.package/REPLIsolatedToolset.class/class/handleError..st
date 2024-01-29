as yet unclassified
handleError: error

	FileStream stdout
		lf;
		lf;
		nextPutAll: '********* ERROR **********';
		lf;
		print: error.
	error printVerboseOn: FileStream stdout.
	FileStream stdout
		lf;
		flush.
	Processor terminateActive.