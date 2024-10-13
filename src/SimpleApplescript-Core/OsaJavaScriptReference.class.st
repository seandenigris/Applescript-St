Class {
	#name : #OsaJavaScriptReference,
	#superclass : #Object,
	#instVars : [
		'string'
	],
	#category : #'SimpleApplescript-Core'
}

{ #category : #'instance creation' }
OsaJavaScriptReference class >> classFor: aString [

	^ self allSubclasses 
		detect: [ :cls | cls isClassFor: aString ]
		ifNone: [ self ]
]

{ #category : #'instance creation' }
OsaJavaScriptReference class >> on: aString [

	| cls |
	cls := self classFor: aString.
	^ cls new string: aString.
]

{ #category : #'as yet unclassified' }
OsaJavaScriptReference >> displayStringOn: aStream [

	string ifNotNil: [ aStream << string ]
]

{ #category : #'as yet unclassified' }
OsaJavaScriptReference >> doesNotUnderstand: aMessage [
	
	^ OsaJavaScript do: self string, '.', aMessage selector, '()'
	"^ self person
		ifNotNil: [ :info | aMessage sendTo: info ]
		ifNil: [ super doesNotUnderstand: aMessage ]."
]

{ #category : #'as yet unclassified' }
OsaJavaScriptReference >> printOn: aStream [

	self printFromDisplayStringOn: aStream
]

{ #category : #accessing }
OsaJavaScriptReference >> string [
	^ string
]

{ #category : #'as yet unclassified' }
OsaJavaScriptReference >> string: aString [

	 string := aString.
]
