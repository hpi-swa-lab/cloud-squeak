as yet unclassified
saveFinal

	| resuming name |
	self minimalShutDownQuitting: false.
	name := Smalltalk imageName.
	Smalltalk imageName: (FileDirectory default fullNameFor: 'aws-final.image') asSqueakPathName.
	resuming := Smalltalk snapshotPrimitive.
	resuming == true
		ifTrue: [
			FileStream startUp: true.
			Transcript showln: 'Squeak Minimal Launching ...'.
			self minimalStartupResuming: true.
			Transcript showln: 'Telnet port: 8080'.
			REPLStartUp new open]
		ifFalse: [
			"old world"
			Smalltalk imageName: name.
			self minimalStartupResuming: false]