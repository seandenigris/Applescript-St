Class {
	#name : #ApplescriptSpecification,
	#superclass : #TestCase,
	#category : 'SimpleApplescript-Specifications'
}

{ #category : #tests }
ApplescriptSpecification >> testDoIt [

	| result |
	result := Applescript doIt: 'get item 1 of {"one", "two", "three"}'.
	self assert: (result = '"one"').
]

{ #category : #tests }
ApplescriptSpecification >> testDoItError [

	self should: [ Applescript doIt: 'get item 1 of {"one"'] raise: Error whoseDescriptionIncludes: 'syntax error:' description: ''.

]
