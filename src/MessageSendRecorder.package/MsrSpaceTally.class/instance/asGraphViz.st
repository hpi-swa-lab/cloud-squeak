as yet unclassified
asGraphViz
	| graph addObject |  

	references ifNil: [^nil].


	(Smalltalk at: #GraphViz) ifFalse: [Error new:'please install GraphViz'].

	graph := (Smalltalk at: #GraphViz) new
		beDirected;
		name: self name;
		add: #graph with: {#overlap -> #scale. 
			#concentrate -> #true. 
			#rankdir -> #LR.
			#ratio -> #compress.
			#page -> '100,100'.
			#size -> '100,100'.
			#center ->1.
			#ranksep -> 0.25};
		"
		add: #edge with: {#arrowsize -> 0.75};
		add: #node with: {#shape -> #box};
		"
		yourself.	
	"
	graph add: 3 with: {#label -> 'Hello'}.
	graph add: 3 -> 4.
	graph add: 3 -> 5.
	"

	addObject := [ :obj | |size|
		size := sizes at: obj ifAbsent: [1].
		
		graph add: obj identityHash with: {
			#label -> ((obj asString truncateTo: 20), ' (',size,')').
			#fontsize -> (size sqrt + 5).
			#width -> (size sqrt / Float pi * 2).
			#fillcolor -> #gray.
			#shape -> #circle.
		}		
	].

	references do: [ :each |
		addObject value: each first.
		addObject value: each third.		

		graph add: (each first identityHash -> each third identityHash)
	].

	^graph
