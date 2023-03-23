accessing - convenience
countSubtree
	| sum |
	sum := 0.
	self childrenDo: [ :each |
		sum   := sum + each countSubtree 		
	].
	^ sum + 1
	