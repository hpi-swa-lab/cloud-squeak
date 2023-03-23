running
run: aSelector with: arguments in: aReceiver

	"do nothing"
	^ self compiledMethod valueWithReceiver: aReceiver arguments: arguments.
	