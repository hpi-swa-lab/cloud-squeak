as yet unclassified
spaceTallyInstancesStructurePackage: name depth: depth limit: limit
	
	|st|

	st := MsrSpaceTally new depth: depth;
		name: 'spacetally_package_', name;
		yourself.
	
	 (PackageInfo named: name) classes do: [ :each |
		st on: each
	
	].	

	^st sizeReportStructure: limit