as yet unclassified
visualize

	| items total form x y canvas |
	items := FileStream readOnlyFileNamed: '~/REPLCleaner.sizes.json' do: [:f |
		f contents lines collect: [:line | | parts |
			parts := line splitBy: String tab.
			{parts first. parts second asNumber}]].
	total := items inject: 0 into: [:s :i | s + i second].
	form := Form extent: total sqrt ceiling asPoint depth: 32.
	canvas := form getCanvas.
	
	x := 1.
	y := 1.
	items do: [:item | | color origin |
		color := Color random.
		origin := x @ y.
		
		1 to: item second do: [:index |
			form colorAt: x @ y put: color.
			x := x + 1.
			x > form width ifTrue: [
				y := y + 1.
				x := 1]].
		canvas drawString: item first at: origin].
	
	(form scaledToHeight: 600) asMorph openInWorld