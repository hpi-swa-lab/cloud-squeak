as yet unclassified
minimalShutDownQuitting: aBoolean

	self minimalStartUpList do: [:name | Smalltalk at: name ifPresent: [:cls | cls shutDown: aBoolean]]