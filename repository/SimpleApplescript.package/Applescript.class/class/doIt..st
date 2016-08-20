scripting
doIt: aString 

	| process escapedString output |
	escapedString := self escapeDoubleQuotesIn: aString.
	process := PipeableOSProcess waitForCommand: '/usr/bin/osascript -ss -e "', escapedString, '"'.
	process succeeded ifFalse: [ self error: process errorUpToEndOfFile ].
	output := process output withoutTrailingBlanks.
	process closePipes. "Per http://forum.world.st/Proper-way-to-use-many-PipeableOSProcesses-td69586.html"
	^ output.
