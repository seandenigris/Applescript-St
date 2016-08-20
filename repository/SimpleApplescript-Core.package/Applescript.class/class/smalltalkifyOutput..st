scripting
smalltalkifyOutput: aString 

	| isList |
	isList := aString first = ${ and: [ aString last = $} ].
	isList ifTrue: [ ^ self processList: aString ].
	^ self processAtom: aString.