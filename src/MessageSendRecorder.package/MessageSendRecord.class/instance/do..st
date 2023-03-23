enumerating
do: block

	firstChild ifNil: [^self].
	
	block value: firstChild. 
	
	firstChild siblingsDo: block
	
