tests
testDoItReturningTrue

	| result |
	result := Applescript doIt: 'true'.
	self assert: result equals: true.