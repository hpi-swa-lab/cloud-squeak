as yet unclassified
spaceTallyInstancesPackage: name depth: depth limit: limit
	"
	self spaceTallyInstancesPackage: 'FileSystem' 
	"
	|st|

	st := MsrSpaceTally new depth: depth;
		name: 'spacetally_package_', name;
		yourself.
	
	 (PackageInfo named: name) classes do: [ :each |
		st on: each
	
	].	

	^st sizeReport: limit