as yet unclassified
cleanPackageInfo

	(self environment info packages instVarNamed: #packages) removeKey: 'MonticelloMocks'.
	MethodReference compile: 'isLocalSelector ^ self actualClass includesLocalSelector: self methodSymbol'.
	self environment info packages flushEmptyPackages