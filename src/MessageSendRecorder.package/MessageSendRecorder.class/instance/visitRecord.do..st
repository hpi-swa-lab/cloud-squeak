private
visitRecord: record do: aBlock

	aBlock value: record.
	record childrenDo: [:child |
		self visitRecord: child do: aBlock			
	]