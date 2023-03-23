as yet unclassified
deleteClassOrganizations.
	ClassDescription allSubInstancesDo: [ :ea | 
		
		ea organization: nil.	
	]