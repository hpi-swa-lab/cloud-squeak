as yet unclassified
safeCeanupImage

	[
		[self cleanupImage] on: Error do: [:error |
			FileStream stdout
				lf;
				lf;
				nextPutAll: '********* ERROR **********';
				lf;
				print: error.
			error printVerboseOn: FileStream stdout.
			FileStream stdout
				lf;
				flush]] forkNamed: 'THE SQUEAK'