scripting
doIt: aString 

	|  escapedString command process output tmpFile |
	"We're using -e with a double-quoted string to pass our (possibly) multi-line string. A heredoc that was perfectly valid when used in the shell still didn't seem to work here"
	tmpFile := Smalltalk imagePath asFile / 'tmp_applescript_file'.
	FileStream forceNewFileNamed: tmpFile fullName do: [ :fs | fs nextPutAll: aString ].

	escapedString := self makeSafeForMultiline: aString.
	command := '/usr/bin/osascript -ss ', $" asString, tmpFile fullName, $" asString.
	process := PipeableOSProcess waitForCommand: command.
	process succeeded ifFalse: [ self error: process errorUpToEndOfFile ].
	output := process output withoutTrailingBlanks.
	process closePipes. "Per http://forum.world.st/Proper-way-to-use-many-PipeableOSProcesses-td69586.html"
	^ output.
