tests
testDoItReturningString
	"Leave this failing until all other Applescript types have been handled. Otherwise there will be ambiguity between e.g. {one} and '{one}'."

	| result |
	result := Applescript doIt: '"a string"'.
	self assert: result equals: 'a string'.