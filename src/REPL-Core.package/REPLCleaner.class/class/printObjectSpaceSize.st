as yet unclassified
printObjectSpaceSize

	Transcript showln: 'Object Space Size: ', (((Smalltalk vmParameterAt: 3) * 1.0e-6) rounded asString, 'MB')