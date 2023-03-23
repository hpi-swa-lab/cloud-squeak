as yet unclassified
sizeReportJSON: limit

	| dict |
	dict := (self sizeReportStructure: limit).
	dict ifNil: [^''].
	^(self sizeReportAsJSON: dict ) asJsonString