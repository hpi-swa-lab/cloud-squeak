as yet unclassified
findLargeMethods

	^ ((((self systemNavigation allMethodsSelect: [:m | true]) sort: [:m :a | m compiledMethod mySize > a compiledMethod mySize]) first: 50) collect: [:m | {m. m compiledMethod mySize asBytesDescription}]) joinSeparatedBy: String crlf