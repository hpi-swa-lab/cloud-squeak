as yet unclassified
reportOn: o
	|st|
	st := MsrSpaceTally new depth: 30.
	st name: 'spacetally_object'.
	st maxCounter: 100000.
	st ignoreBlock: [:from :to | to == Object].
	st on: o.	
	^st sizeReport: 10