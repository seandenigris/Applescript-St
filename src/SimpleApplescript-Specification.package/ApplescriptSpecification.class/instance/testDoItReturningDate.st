tests
testDoItReturningDate

	| result |
	result := Applescript doIt: 'date "Wednesday, May 25, 2005 12:00:00 AM"'.
	self assert: result equals: 'May 25, 2005 12:00:00AM' asDateAndTime.