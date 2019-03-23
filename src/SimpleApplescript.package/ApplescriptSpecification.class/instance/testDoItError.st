tests
testDoItError

	self should: [ Applescript doIt: 'get item 1 of {"one"'] raise: Error whoseDescriptionIncludes: 'syntax error:' description: ''.
