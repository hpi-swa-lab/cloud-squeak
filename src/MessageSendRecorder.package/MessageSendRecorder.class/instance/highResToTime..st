chrome trace
highResToTime: aNumber

	^((aNumber / Time highResClockTicksPerMillisecond) * 1000.0)  asFloat   rounded " / 1000.0 / 1000.0"
	
