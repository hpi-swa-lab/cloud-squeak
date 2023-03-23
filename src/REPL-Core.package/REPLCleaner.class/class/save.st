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
				ifTrue: ['wsl  xterm -e "~/Dropbox/hpi/Squeak/pivr-bundle/Squeak6.1alpha-22185-64bit-All-in-One.app/Contents/Linux-x86_64/bin/spur64 -vm-display-null -headless ~/Tracing/aws.image"']
				ifFalse: ['gnome-terminal -e "/home/tom/Code/squeak/Squeak6.1alpha-22446-64bit-202206021410-Linux-x64/bin/squeak -vm-display-null -headless aws.image"'])]