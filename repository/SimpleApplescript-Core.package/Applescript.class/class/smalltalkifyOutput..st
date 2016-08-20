private
smalltalkifyOutput: aString 

	| isList |
	isList := aString isEmpty not and: [ aString first = ${ and: [ aString last = $} ] ].
	isList ifTrue: [ ^ self processList: aString ].
	^ self processAtom: aString.