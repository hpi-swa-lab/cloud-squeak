as yet unclassified
on: object
	references add: (MsrSpaceTallyReference new fromObject: #root; selector: ''; toObject: object; indent: 0; yourself).
	self spaceForInstance: object.
	