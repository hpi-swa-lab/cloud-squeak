as yet unclassified
writeSpaceTally

	(WriteSpaceTally ifNil: [false]) ifFalse: [^ self].
	
	(Smalltalk at: #MsrSpaceTally) writeSpaceTally. "dynamic class lookup to let it garbage collect..."
	
