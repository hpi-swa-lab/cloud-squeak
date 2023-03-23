as yet unclassified
keepClass: aClass

	^ self keepList anySatisfy: [:prefix | aClass category beginsWith: prefix]