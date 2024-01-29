as yet unclassified
save

	| resuming name |
	name := Smalltalk imageName.
	Smalltalk imageName: 'aws.image'.
	resuming := Smalltalk snapshotPrimitive.
	resuming == true
		ifTrue: ["new world"
		self safeCeanupImage]
		ifFalse: [
			"old world"
			Smalltalk imageName: name.
			OSProcess command: ((WSL ifNil: [false])
				ifTrue: ['wsl  xterm -e "/usr/bin/squeak/squeak -vm-display-null -headless ~/Tracing/aws.image"']
				ifFalse: ['gnome-terminal -e "/usr/bin/squeak/squeak -vm-display-null -headless aws.image"'])]