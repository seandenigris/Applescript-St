Class {
	#name : #OsaScript,
	#superclass : #Object,
	#instVars : [
		'recompilableOutput',
		'target',
		'scriptSource',
		'children'
	],
	#category : #'SimpleApplescript-Core'
}

{ #category : #example }
OsaScript class >> example [
	<sampleInstance>

	^ OsaScript new
			target: 'Terminal';
			source: 'activate
		do script "{script}"';
			yourself.

]

{ #category : #'as yet unclassified' }
OsaScript class >> run: aString [

	| command |
	command := self new
		source: aString;
		isOutputRecompilable;
		yourself.
	^ command run.
]

{ #category : #'as yet unclassified' }
OsaScript >> initialize [

	super initialize.
	recompilableOutput := false.
]

{ #category : #configuration }
OsaScript >> isOutputRecompilable [
	"See setter comment"

	^ recompilableOutput.
]

{ #category : #configuration }
OsaScript >> isOutputRecompilable: aBoolean [
	"From the man page:
		osascript normally prints its results in human-readable form:
    strings do not have quotes around them, characters are not
    escaped, braces for lists and records are omitted, etc.  This is
    generally more useful, but can introduce ambiguities...  To see the results in an unam-
    biguous form that could be recompiled into the same value, use
    the s modifier."

	recompilableOutput := aBoolean.
]

{ #category : #'as yet unclassified' }
OsaScript >> run [

	| process |
	process := PipeableOSProcess waitForCommand: self runCommand.
	process succeeded ifFalse: [ self error: process errorUpToEndOfFile ].
	process close; closePipes.
	^ process output trimRight.
]

{ #category : #'as yet unclassified' }
OsaScript >> runCommand [

	| commandTemplate flags commandString |
	commandTemplate := '/usr/bin/osascript {1} <<END_S
{2}
END_S'.
	flags := recompilableOutput
		ifTrue: [ '-ss' ]
		ifFalse: [ '' ].
	commandString := commandTemplate format: { flags. scriptSource }.
	^ commandString copyReplaceAll: Character cr asString with: Character lf asString.

	"Implementation note:
		- Previously tried using temp files. See Applescript-St/src/SimpleApplescript/Applescript.class.st, removed in commit 8feac02 on 2019-07-16. OSShell also tried this approach."
]

{ #category : #accessing }
OsaScript >> source [
	^ scriptSource ifNil: [ scriptSource := '' ]
]

{ #category : #accessing }
OsaScript >> source: aString [
	scriptSource := aString
]

{ #category : #'as yet unclassified' }
OsaScript >> target: applicationName [
	target := applicationName
]

{ #category : #scripting }
OsaScript >> tell: applicationString to: script [
	"Limitation: currently one 'tell' per script"
	| template tellScript |
	template := 'tell application "{app}"
	{script}
end tell'.
	tellScript := template format: { 
		#app -> applicationString.
		#script -> script } asDictionary.
	self source: self source, Character lf asString, tellScript
]
