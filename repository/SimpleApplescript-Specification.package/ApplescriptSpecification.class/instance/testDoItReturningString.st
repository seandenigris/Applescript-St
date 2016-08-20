tests
testDoItReturningString

	| result |
	result := Applescript doIt: '"a string"'.
	self assert: result equals: 'a string'.