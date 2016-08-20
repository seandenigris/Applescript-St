tests
testDoIt

	| result |
	result := Applescript doIt: 'tell application "Finder"
	get item 1 of {"one", "two", "three"}
end tell'.
	self assert: result equals: '"one"'.