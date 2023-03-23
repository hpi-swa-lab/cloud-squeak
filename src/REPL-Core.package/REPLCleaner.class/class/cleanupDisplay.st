as yet unclassified
cleanupDisplay

	| priorBits |
	priorBits := Display bits.
	(Display setExtent: 1 @ 1 depth: 32) beDisplay.
	"FIXME: seems hacky but saves a lot of space"
	Display bits unpin.
	priorBits := nil.
	Display := nil