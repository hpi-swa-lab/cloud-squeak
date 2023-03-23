as yet unclassified
sizeReportAsJSON: node
	^{
		#size -> (node at: #size).
		#selector -> (node at: #selectorOrIndex).
		#class ->  (node at: #object) class asString. 
		#id ->  (node at: #object) identityHash. 
		#label -> ((self printObject: (node at: #object)) truncateTo: 100).
		#children -> ((node at: #children) collect: [ :ea | self sizeReportAsJSON: ea])
	} as: Dictionary
	
	
	

	