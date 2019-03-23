private
smalltalkifyOutput: aString 

	aString = 'true' ifTrue: [ ^ true ].
	aString = 'false' ifTrue: [ ^ false ].
	^ aString.