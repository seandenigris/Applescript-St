private
processAtom: aString

	| isApplescriptString |
	aString = 'true' ifTrue: [ ^ true ].
	aString = 'false' ifTrue: [ ^ false ].
	(aString beginsWith: 'date ') ifTrue: [ ^ self processDate: aString ].
	isApplescriptString := aString first = $" and: [ aString last = $" ].
	isApplescriptString ifTrue: [ ^ self stripQuotesFrom: aString ].
	^ ApplescriptReference on: aString.