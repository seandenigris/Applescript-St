Class {
	#name : #ApplescriptReference,
	#superclass : #Object,
	#instVars : [
		'string'
	],
	#category : 'SimpleApplescript-Core'
}

{ #category : #'instance creation' }
ApplescriptReference class >> on: aString [

	^ self new string: aString.
]

{ #category : #'as yet unclassified' }
ApplescriptReference >> string: aString [

	 string := aString.
]
