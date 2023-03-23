literals
allLiteralsDo: aBlock
	"This method is necessary to show the breakpoint-flag in the browser."
	
	aBlock value: #break.
	method allLiteralsDo: aBlock.