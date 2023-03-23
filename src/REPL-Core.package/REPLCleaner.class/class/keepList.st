as yet unclassified
keepList
	|list|

	list := #('Kernel-' 'Collections-' 'Files-' 'PackageInfo-' 'Compiler-' 'System-' 'Traits-' 'Environments-' 'Regex-Core' 'Chronology-Core' 'Multilingual-' 'Compression-' '********************' 'Network-Kernel' 'Network-Exceptions' 'Regex' 'REPL-Core').

	self shouldDeleteMetacello ifFalse: [ 
		list := list, #('OSProcess-' 'JSON' 'WebClient-Core' 'SqueakSSL-' 'Network-' 'STON-' 'Gofer-' 'Monticello-' 'Metacello-' 'MonticelloTonel-' 'MonticelloFileTree-')].
	
	WriteSpaceTally ifTrue: [ 
		list := list, #('MessageSendRecorder-SpaceTally' 'JSON')].
	^list 