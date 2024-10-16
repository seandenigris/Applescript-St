Class {
	#name : #AsError,
	#superclass : #Object,
	#instVars : [
		'message',
		'number'
	],
	#category : #'Mac OSA-Core'
}

{ #category : #private }
AsError class >> fromString: aString [
	
	| matcher |
	matcher := self regex.
	(matcher matches: aString) ifFalse: [ self error: 'Not a valid AsError' ].
	^ self new
		message: (matcher subexpression: 2);
		number: (matcher subexpression: 3) asNumber;
		yourself
]

{ #category : #private }
AsError class >> isClassFor: aString [

	^ self regex matches: aString
]

{ #category : #private }
AsError class >> regex [

	^ '\d+\:\d+\: execution error\: (.*) \(-?(\d+)\)' asRegex
]

{ #category : #accessing }
AsError >> message [

	^ message
]

{ #category : #accessing }
AsError >> message: anObject [

	message := anObject
]

{ #category : #accessing }
AsError >> number [

	^ number
]

{ #category : #accessing }
AsError >> number: anObject [

	number := anObject
]
