accessing
selectorOrIndex
	selector ifNotNil: [:s | ^'#',s].
	
	^ ' at: ', index