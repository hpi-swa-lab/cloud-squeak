as yet unclassified
writeSizes

	FileStream forceNewFileNamed: '/home/tom/a.json' do: [:f |
		SpaceTally new systemWideSpaceTally do: [:x |
			f nextPutAll: x analyzedClassName.
			f tab.
			f nextPutAll: x spaceForInstances asString.
			f lf]]