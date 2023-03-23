private
minimumHighResDuration
	minimumHighResDuration ifNil: [
		minimumHighResDuration := Time highResClockTicksPerMillisecond* 0.001. "ignore everything under a microsecond"
 	].

	^minimumHighResDuration