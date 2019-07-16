Class {
	#name : #OsaScript,
	#superclass : #Object,
	#instVars : [
		'recompilableOutput',
		'scriptSource'
	],
	#category : 'SimpleApplescript-Core'
}

{ #category : #'as yet unclassified' }
OsaScript class >> run: aString [

	| command |
	command := self new
		script: aString;
		recompilableOutput.
	^ command run.
]

{ #category : #'as yet unclassified' }
OsaScript >> initialize [

	super initialize.
	recompilableOutput := false.
]

{ #category : #configuration }
OsaScript >> recompilableOutput [
	"From the man page:
		osascript normally prints its results in human-readable form:
    strings do not have quotes around them, characters are not
    escaped, braces for lists and records are omitted, etc.  This is
    generally more useful, but can introduce ambiguities...  To see the results in an unam-
    biguous form that could be recompiled into the same value, use
    the s modifier."

	recompilableOutput := true.
]

{ #category : #'as yet unclassified' }
OsaScript >> run [

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

	"Implementation note: previously tried using temp files. See Applescript-St/src/SimpleApplescript/Applescript.class.st, removed in commit 8feac02 on 2019-07-16"

]

{ #category : #accessing }
OsaScript >> script: aString [ 

	scriptSource := aString.
]
