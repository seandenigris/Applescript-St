tests
testDoIt

	| result |
	result := Applescript doIt: 'get item 1 of {"one", "two", "three"}'.
	self assert: (result = '"one"').