as yet unclassified
cleanCollectionsTextCategory

	RunArray class removeSelector: #scanFrom:.
	UTF8TextConverter removeSelector: #nextChunkTextFromStream:.
	String removeSelector: #asTextFromHtml.
	(PackageInfo named: 'Collections-Text') classes reversed do: [:class | class removeFromSystem]