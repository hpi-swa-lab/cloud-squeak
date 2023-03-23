as yet unclassified
spaceTallyAWS
	|st|

	st := MsrSpaceTally new depth: 20.
	st name: 'aws-report'.

	"st class compile: 'followReferenceFrom: anObject to: other ^true'."

	Object allSubclasses do: [:ea | st on: ea ].
	
	FileDirectory default forceNewFileNamed: st name,'.txt' do: [:stream | 
		stream nextPutAll: (st sizeReport: 1000)
	].
	FileDirectory default forceNewFileNamed: st name,'.json' do: [:stream |
		stream nextPutAll: (st sizeReportJSON: 2000)
	].