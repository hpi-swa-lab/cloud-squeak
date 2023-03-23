as yet unclassified
sizeReportStructure: limit
	| result minimumSize stack|

	self references isEmpty ifTrue: [^nil].

	minimumSize := self sizeReportMinimumSize: limit.	
	result := {#indent -> -1. #object -> #root. #selectorOrIndex -> nil.  #children -> OrderedCollection new. #size -> (self totalSizeOf: rootObject)} as: Dictionary.
	stack := OrderedCollection new.
	stack add: result. 


	(references 
		select: [:ea |	
			(self totalSizeOf: ea toObject) >= minimumSize  
		]
	) do: [:each | | node |
		node := {
			#indent -> each indent.
			#size -> (self totalSizeOf: each toObject).
			#selectorOrIndex -> each selectorOrIndex.
			#object -> each toObject.
			#children -> OrderedCollection new.	
		} as: Dictionary.
				
		[(node at: #indent) <= (stack last at: #indent)]   whileTrue: [
			stack removeLast. 
		].		
		(stack last at: #children) add: node. 
		stack add: node
	].

	 ^result