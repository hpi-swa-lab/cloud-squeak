as yet unclassified
cleanMultilingualCategory

	| keepList |
	keepList := #(#TextConverter #UTF8TextConverter #UndefinedConversion #MultiByteFileStream #MultiByteBinaryOrTextStream #Latin1Environment #LanguageEnvironment), ((PackageInfo named: 'Multilingual-Encodings') classes collect: #name), ((PackageInfo named: 'Multilingual-Scanning') classes collect: #name).
	(PackageInfo named: 'Multilingual') classes reversed do: [:class | (keepList includes: class name) ifFalse: [class removeFromSystem]].
	
	EncodedCharSet classPool
		at: #EncodedCharSets
		put: (Array new: 256 withAll: Unicode).
	EncodedCharSet class removeSelector: #initialize.
	Unicode classPool at: #GeneralCategory put: (SparseLargeTable new: 1)