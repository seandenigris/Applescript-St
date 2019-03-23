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

]

{ #category : #accessing }
OsaScript >> script: aString [ 

	scriptSource := aString.
]
