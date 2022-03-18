Class {
	#name : #OsaScript,
	#superclass : #Object,
	#instVars : [
		'recompilableOutput',
		'target',
		'scriptSource',
		'children',
		'errorsToStdout'
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

{ #category : #accessing }
OsaScript class >> run: aString [

	| command |
	command := self new
		source: aString;
		yourself.
	^ command run.
]

{ #category : #configuration }
OsaScript >> errorsToStdout [
	"See setter comment"

	^ errorsToStdout ifNil: [ true ].
]

{ #category : #configuration }
OsaScript >> errorsToStdout: aBoolean [
	"From the man page:
		osascript normally prints script errors to stderr, so downstream
              clients only see valid results.  When running automated tests,
              however, using the o modifier lets you distinguish script errors,
              which you care about matching, from other diagnostic output, which
              you don't."

	errorsToStdout := aBoolean.
]

{ #category : #configuration }
OsaScript >> isOutputRecompilable [
	"See setter comment"

	^ recompilableOutput ifNil: [ true ].
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

	^ Smalltalk tools shell new outputOf: self runCommand.
]

{ #category : #accessing }
OsaScript >> runCommand [

	| commandTemplate flags commandString hasFlags |
	commandTemplate := '/usr/bin/osascript {1} <<END_S
{2}
END_S'.
	hasFlags := self isOutputRecompilable or: [ self errorsToStdout ].
	flags := hasFlags
		ifTrue: [ 
			String streamContents: [ :fstr |
				fstr << '-s'.
				self isOutputRecompilable ifTrue: [ fstr << 's' ].
				self errorsToStdout ifTrue: [ fstr << 'o' ] ] ]
		ifFalse: [ '' ].
	commandString := commandTemplate format: { flags. scriptSource }.
	^ commandString withUnixLineEndings.

	"Implementation note:
		- Adapted from https://apple.stackexchange.com/a/141721/9507. Didn't work without changing to Unix line endings, probably related to the HEREDOC
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
