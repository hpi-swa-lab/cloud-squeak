instance creation
on: anObject except: aCollection
	^ self new 
		goal: anObject;
		excludedObjects: aCollection;
		search;
		open