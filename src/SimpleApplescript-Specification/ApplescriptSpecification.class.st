Class {
	#name : #ApplescriptSpecification,
	#superclass : #TestCase,
	#category : 'SimpleApplescript-Specification'
}

{ #category : #tests }
ApplescriptSpecification >> testDoIt [

	| result |
	result := Applescript doIt: 'tell application "Finder"
	get item 1 of {"one", "two", "three"}
end tell'.
	self assert: result equals: 'one'.
]

{ #category : #tests }
ApplescriptSpecification >> testDoItError [

	self should: [ Applescript doIt: 'get item 1 of {"one"'] raise: Error whoseDescriptionIncludes: 'syntax error:' description: ''.

]

{ #category : #tests }
ApplescriptSpecification >> testDoItReturningDate [

	| result |
	result := Applescript doIt: 'date "Wednesday, May 25, 2005 12:00:00 AM"'.
	self assert: result equals: 'May 25, 2005 12:00:00AM' asDateAndTime.
]

{ #category : #tests }
ApplescriptSpecification >> testDoItReturningFalse [

	| result |
	result := Applescript doIt: 'false'.
	self assert: result equals: false.
]

{ #category : #tests }
ApplescriptSpecification >> testDoItReturningList [

	| result |
	result := Applescript doIt: 'tell application "Finder"
	get {"one", "two", "three"}
end tell'.
	self assert: result equals: { 'one'. 'two'. 'three' }.
]

{ #category : #tests }
ApplescriptSpecification >> testDoItReturningString [

	| result |
	result := Applescript doIt: '"a string"'.
	self assert: result equals: 'a string'.
]

{ #category : #tests }
ApplescriptSpecification >> testDoItReturningTrue [

	| result |
	result := Applescript doIt: 'true'.
	self assert: result equals: true.
]
