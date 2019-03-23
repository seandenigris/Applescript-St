tests
testDoItReturningFalse

	| result |
	result := Applescript doIt: 'false'.
	self assert: result equals: false.