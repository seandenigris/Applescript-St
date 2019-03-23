as yet unclassified
run

	| process commandTemplate flags commandString |
	commandTemplate := '/usr/bin/osascript {1} <<END_S
{2}
END_S'.
	flags := recompilableOutput
		ifTrue: [ '-ss' ]
		ifFalse: [ '' ].
	commandString := commandTemplate format: { flags. scriptSource }.
	commandString := commandString copyReplaceAll: Character cr asString with: Character lf asString.
	process := PipeableOSProcess waitForCommand: commandString.
	process succeeded ifFalse: [ self error: process errorUpToEndOfFile ].
	process close; closePipes.
	^ process output trimRight.
