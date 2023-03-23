installation
install

	super install.
	unwrappedMethod := self unwrappedMethod.
	counter := 0.
	
	
	self assert: unwrappedMethod notNil