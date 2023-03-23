printing
printError: aString
	"Print the error aString to the client."
	(aString findTokens: String crlf) do: [ :line |
		self print:  String crlf,  (self class colorize: line with: self class colorBad)		
	]

