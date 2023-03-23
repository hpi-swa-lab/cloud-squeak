private
visitRecord: record begin: beginBlock end: endBlock

	beginBlock value: record.
	record childrenDo: [:child |
		self visitRecord: child begin: beginBlock end: endBlock.
	].
	endBlock value: record