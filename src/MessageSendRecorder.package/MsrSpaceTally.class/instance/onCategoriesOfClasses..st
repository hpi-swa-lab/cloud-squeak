as yet unclassified
onCategoriesOfClasses: listOfClasses
	|categories totalSize size categoryObject originalIgnoreBlock |

	categories := listOfClasses groupBy: [:ea | ea category].
	
	totalSize := 0.
	
	originalIgnoreBlock := self ignoreBlock.
	
	ignoreBlock := [ :from :other | (originalIgnoreBlock value: from value: other) or: [(other isKindOf: Class)]].
	
	
	categories keysAndValuesDo: [ :category :classes |
			size := 0.
			categoryObject := MsrSpaceTallyClassCategory new
					name: category; 
					yourself.
			self references add: (MsrSpaceTallyReference new fromObject: rootObject; selector: 'root'; toObject: categoryObject; indent: 0; yourself).
			classes withIndexDo: [ :eachClass :index |
				self references add: (MsrSpaceTallyReference new fromObject: categoryObject; selector: 'classInCategory'; toObject: eachClass; indent: 1; yourself).
				size := size + (self spaceForInstance: eachClass depth: self depth - 2).
				
				(sizes includesKey: eachClass class) ifFalse: [
					self references add: (MsrSpaceTallyReference new fromObject: categoryObject; selector: 'metaClassInCategory'; toObject: eachClass class; indent: 1; yourself).
					size := size + (self spaceForInstance: eachClass class depth: self depth - 2).
				]

			].
			self sizes at: categoryObject put: size.
			
			totalSize := totalSize + size.
		].
	self sizes at: rootObject put: (self sizes at: rootObject) + totalSize.
	
	ignoreBlock := originalIgnoreBlock.
	