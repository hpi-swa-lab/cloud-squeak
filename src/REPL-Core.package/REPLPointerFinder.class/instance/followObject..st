private
followObject: anObject

	(self excludedObjects includes: anObject)
		ifTrue: [^ false].
	anObject outboundPointersDo: [:ea |
		(self follow: ea from: anObject)
			ifTrue: [^ true]].
	^ false