chrome trace
asChromeTrace
	| events |
	events := OrderedCollection new.
	self allRecordsBegin: [:record | 
		events add: (record asChromeTraceIn: self)
	] end: [:record | 
		"BEGIN END events have problems... so use X"
	].
	
	^  {
		#traceEvents -> events
	} as: Dictionary
