as yet unclassified
sizeReport: limit
	| minimumSize|

	self references isEmpty ifTrue: [^''].

	minimumSize  := self sizeReportMinimumSize: limit.	
	^((references select: [:ea |	
		(self totalSizeOf: ea toObject) >= minimumSize  
	]) collect: [:each | |indentString|	 
	
		indentString := ((1 to: each indent) collect: [:ea  | String tab]) joinSeparatedBy: '' .
		indentString,(self totalSizeOf: each toObject), ' ', each selectorOrIndex , ' -> ', ((self printObject: each toObject ) truncateTo: 100), ' [',each toObject className,']' 
	]) joinSeparatedBy: String crlf