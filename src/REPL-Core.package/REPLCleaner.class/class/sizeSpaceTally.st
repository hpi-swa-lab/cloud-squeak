as yet unclassified
sizeSpaceTally

	^ (SpaceTally new systemWideSpaceTally
		inject: 0
		into: [:s :i | s + i spaceForInstances]) asBytesDescription