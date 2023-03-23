as yet unclassified
spaceForCategories

	^ (((self environment organization categories collect: [:c |
		{
			c.
			(self environment organization classesIn: c)
				inject: 0
				into: [:sum :cls | sum + (SpaceTally new spaceForInstance: cls depth: 3)]}]) sort: [:a :b | a second > b second]) first: 30) collect: [:a | {a first. a second asBytesDescription}]