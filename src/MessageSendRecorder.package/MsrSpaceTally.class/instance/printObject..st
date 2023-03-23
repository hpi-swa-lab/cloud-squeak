as yet unclassified
printObject: object
	|s|
	[
		s := object asString
	] on: Error do: [ :err |
		s := 'a ', object class name
	].
	^s