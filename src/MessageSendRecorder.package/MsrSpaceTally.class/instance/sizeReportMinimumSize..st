as yet unclassified
sizeReportMinimumSize: limit
	| sorted |

	sorted := (self references sorted: [:a :b | 
		(self sizes at: a toObject ifAbsent: 1) >= (self sizes at: b toObject ifAbsent: 1)
	]) first: (self references size min: limit).

	^self sizes at: sorted last toObject ifAbsent: 1. 
