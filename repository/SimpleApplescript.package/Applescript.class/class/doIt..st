scripting
doIt: aString 

	| process |
	process := PipeableOSProcess waitForCommand: '/usr/bin/osascript -ss -e ''', aString, ''''.
	process succeeded ifFalse: [ self error: process errorUpToEndOfFile ].
	process close; closePipes.
	^ self smalltalkifyOutput: process output trimRight.
