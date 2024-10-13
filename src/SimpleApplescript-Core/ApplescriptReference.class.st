Class {
	#name : #ApplescriptReference,
	#superclass : #Object,
	#instVars : [
		'string'
	],
	#category : #'SimpleApplescript-Core'
}

{ #category : #'instance creation' }
ApplescriptReference class >> on: aString [

	^ self new string: aString.
]

{ #category : #'as yet unclassified' }
ApplescriptReference >> get: aString via: applicationString [

	^ Applescript 
		tell: applicationString
		to: 'get ', aString, ' of ', self string
]

{ #category : #accessing }
ApplescriptReference >> string [
	^ string
]

{ #category : #'as yet unclassified' }
ApplescriptReference >> string: aString [

	 string := aString.
]
