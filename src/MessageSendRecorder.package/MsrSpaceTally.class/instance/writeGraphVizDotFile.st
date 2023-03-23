as yet unclassified
writeGraphVizDotFile
	|graphViz|
	graphViz := self asGraphViz.
	graphViz generator writeDotFile.
	
	^graphViz