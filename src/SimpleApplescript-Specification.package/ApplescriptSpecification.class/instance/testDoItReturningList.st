tests
testDoItReturningList

	| result |
	result := Applescript doIt: 'tell application "Finder"
	get {"one", "two", "three"}
end tell'.
	self assert: result equals: { 'one'. 'two'. 'three' }.