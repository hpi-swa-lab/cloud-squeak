application
search

	Smalltalk garbageCollect.
	
	self initialize.
	
	[
		[toDo isEmpty or: [self followObject: toDo removeFirst]] whileFalse.
		toDo isEmpty and: [toDoNext isEmpty not]] whileTrue: [
		toDo := toDoNext.
		toDoNext := OrderedCollection new: 5000].
	
	self buildList