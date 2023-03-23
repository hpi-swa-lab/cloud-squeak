enumerating
doLast: block

	self childrenDo: [:node |
		node doLast: block].
	
	block value: self.