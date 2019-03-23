private
processAtom: aString

	| isApplescriptString |
	aString = 'true' ifTrue: [ ^ true ].
	aString = 'false' ifTrue: [ ^ false ].
	(aString beginsWith: 'date ') ifTrue: [ ^ self processDate: aString ].
	isApplescriptString := aString isEmpty not and: [ aString first = $" and: [ aString last = $" ] ].
	isApplescriptString ifTrue: [ ^ self processString: aString ].
	^ ApplescriptReference on: aString.