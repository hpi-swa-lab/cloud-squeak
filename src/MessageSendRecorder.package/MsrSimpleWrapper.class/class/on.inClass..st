method-wrapper
on:  selector inClass: class
	^self new methodReference: (MethodReference class: class selector: selector)