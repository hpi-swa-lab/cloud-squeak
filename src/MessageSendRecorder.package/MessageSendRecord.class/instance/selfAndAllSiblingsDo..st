enumerating
selfAndAllSiblingsDo: block
	
	block value: self.
	nextSibling ifNotNil: [
		nextSibling selfAndAllSiblingsDo: block.
	]