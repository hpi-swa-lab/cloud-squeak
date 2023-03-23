as yet unclassified
writeSpaceTally

	| st report json objects |

	Transcript showln: 'Write Space Tally'.
	objects := SystemNavigation allObjects.
	"since we create new object during iteration... we want to freeze them here"
	st := MsrSpaceTally new depth: 30.
	st name: 'spacetally_aws'.
	st ignoreBlock: [:from :to | false].
	"st class compile: 'followReferenceFrom: anObject to: other ^true'."
	"Object allSubclasses do: [:ea | st on: ea ]."
	st onAllCategories.
	st onObjects: objects.
	"go through the rest"
	json := st sizeReportJSON: 4000.
	FileDirectory default
		forceNewFileNamed: 'aws-report.json'
		do: [:stream | stream nextPutAll: json].
	
	report := st sizeReport: 4000.
	FileDirectory default
		forceNewFileNamed: 'aws-report.txt'
		do: [:stream | stream nextPutAll: report].
	
