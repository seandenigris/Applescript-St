"
I execute Applescript scripts via my class side #doIt:.

I am a bare-bones replacement for the class of the same name in the Applescript project (on Squeaksource) because the required plugin does not work on the new Cocoa Cog VMs.
"
Class {
	#name : #Applescript,
	#superclass : #Object,
	#category : 'SimpleApplescript'
}

{ #category : #'as yet unclassified' }
Applescript class >> asOldManSay: aString [
	"self asOldManSay: 'you damn kids get off my lawn'"

	self doIt: 'say ', aString surroundedByDoubleQuotes, ' using "Bahh"'.
]

{ #category : #'as yet unclassified' }
Applescript class >> asYoungGirlSay: aString [ 

	self doIt: 'say ', aString surroundedByDoubleQuotes, ' using "Princess"'.
]

{ #category : #scripting }
Applescript class >> doIt: aString [ 

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

]

{ #category : #private }
Applescript class >> escapeDoubleQuotesIn: aString [
	"Should be in String, but this is all very experimental, so I'm keeping it contained"

	^ aString copyReplaceAll: '"' with: '\"' asTokens: false.
]

{ #category : #'as yet unclassified' }
Applescript class >> escapeTabsIn: aString [ 

	^ aString copyWithout: Character tab.
]

{ #category : #'as yet unclassified' }
Applescript class >> makeSafeForMultiline: aString [

	| tabsEscaped |
	tabsEscaped := self escapeTabsIn: aString.
	^ self escapeDoubleQuotesIn: tabsEscaped.
]

{ #category : #'as yet unclassified' }
Applescript class >> say: aString [ 

	self doIt: 'say ', aString surroundedByDoubleQuotes.
]

{ #category : #private }
Applescript class >> smalltalkifyOutput: aString [ 

	aString = 'true' ifTrue: [ ^ true ].
	aString = 'false' ifTrue: [ ^ false ].
	^ aString.
]
