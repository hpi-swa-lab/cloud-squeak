enumerating
doFirst: block

	block value: self.
	
	self childrenDo: [:node |
		node doFirst: block].