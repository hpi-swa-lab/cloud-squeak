chrome trace
methodTally
	^(((self wrappers asArray sorted: #counter descending) copyFrom: 1 to: 100) collect: [:ea | 
		ea counter asString, ' ', ea clientMethod sourceClass,'>>',ea clientMethod selector])
