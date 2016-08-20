private
doIt: aString 

	| output |
	output := OsaScript run: aString.
	^ self smalltalkifyOutput: output.
