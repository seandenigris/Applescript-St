"
I execute Applescript scripts via my class side #doIt:.

I am a bare-bones replacement for the class of the same name in the Applescript project (on Squeaksource) because the required plugin does not work on the new Cocoa Cog VMs.
"
Class {
	#name : #Applescript,
	#superclass : #SuRunnable,
	#instVars : [
		'targetApplication'
	],
	#category : #'SimpleApplescript-Core'
}

{ #category : #scripting }
Applescript class >> doIt: aString [ 

	^ self new
		template: aString;
		output

]

{ #category : #private }
Applescript class >> escapeDoubleQuotesIn: aString [
	"Should be in String, but this is all very experimental, so I'm keeping it contained"

	^ aString copyReplaceAll: '"' with: '\"' asTokens: false.
]

{ #category : #private }
Applescript class >> escapeTabsIn: aString [ 

	^ aString copyWithout: Character tab.
]

{ #category : #accessing }
Applescript class >> exampleError [
	<gtExample>
	
	^ self 
		given: []
		when: [ self doIt: 'error "oops"' ]
		then: [ :result |
			result message should equal: 'oops'.
			result number should equal: 2700. "the default" ]
]

{ #category : #examples }
Applescript class >> exampleTell [
	<gtExample>
	
	^ self 
		given: []
		when: [ self tell: 'Safari' to: 'get name' ]
		then: [ :result |
			result should equal: 'Safari' ]
]

{ #category : #private }
Applescript class >> makeSafeForMultiline: aString [

	| tabsEscaped |
	tabsEscaped := self escapeTabsIn: aString.
	^ self escapeDoubleQuotesIn: tabsEscaped.
]

{ #category : #scripting }
Applescript class >> say: aString [
	"Example: self say: 'Hello world'"

	self doIt: 'say ', aString surroundedByDoubleQuotes.
]

{ #category : #scripting }
Applescript class >> say: speechString using: voiceName [
	"
	voiceName - A system voice installed on your Mac. Not all voices are installed by Default. You can view/add voices in Preferences->Accessibility->Speech
	
	Examples: 
		self say: 'Daddy, I want a pony!' using: 'Princess'.
		self say: 'You damn kids get off my lawn!' using: 'Bahh'.
	"

	self doIt: 'say ', speechString surroundedByDoubleQuotes, ' using ', voiceName surroundedByDoubleQuotes.
]

{ #category : #scripting }
Applescript class >> tell: applicationString to: script [
	^ self new
		targetApplication: applicationString;
		template: script;
		output
]

{ #category : #scripting }
Applescript >> output [

	| output |
	output := OsaScript run: self string.
	^ self smalltalkifyOutput: output trimmed.
]

{ #category : #private }
Applescript >> processAtom: aString [

	| isApplescriptString |
	aString = 'true' ifTrue: [ ^ true ].
	aString = 'false' ifTrue: [ ^ false ].
	(aString beginsWith: 'date ') ifTrue: [ ^ self processDate: aString ].
	isApplescriptString := aString isEmpty not and: [ aString first = $" and: [ aString last = $" ] ].
	isApplescriptString ifTrue: [ ^ self processString: aString ].
	(NumberParser isNumber: aString) ifTrue: [ ^ aString asNumber ].
	(AsError isClassFor: aString) ifTrue: [ ^ AsError fromString: aString ].
	^ ApplescriptReference on: aString.
]

{ #category : #private }
Applescript >> processDate: aString [ 

	| dateString weekdayStripped |
	dateString := aString copyFrom: 7 to: aString size - 1.
	weekdayStripped := dateString copyAfter: Character space.
	^ weekdayStripped asDateAndTime.
]

{ #category : #private }
Applescript >> processList: returnString [

	| delimiter item contents listParser result listClose |
	delimiter := ', ' asPParser.
	listClose := $} asPParser.
	item := (delimiter / listClose) negate plus flatten.
	contents := (item separatedBy: delimiter) ==> [ :nodes | nodes reject: [ :n | n = ', ' ] ].
	listParser := ${ asPParser, contents optional, listClose ==> #second.
	result := listParser parse: returnString.
	^ result isNil
		ifTrue: [ OrderedCollection new ]
		ifFalse: [ result collect: [ :e | self smalltalkifyOutput: e ] ].
]

{ #category : #private }
Applescript >> processRecord: aString [ 
	'{who:"Matt", town:"Ojai"}'.
	self shouldBeImplemented.
]

{ #category : #private }
Applescript >> processString: aString [ 

	| rawString |
	rawString := self stripQuotesFrom: aString.
	^ rawString copyReplaceAll: '\"' with: '"'.
]

{ #category : #scripting }
Applescript >> run [

	^ self output
]

{ #category : #private }
Applescript >> smalltalkifyOutput: aString [ 

	| isList |
	isList := aString isEmpty not and: [ aString first = ${ and: [ aString last = $} ] ].
	isList ifTrue: [ ^ self processList: aString ].
	^ self processAtom: aString trimRight.
]

{ #category : #accessing }
Applescript >> string [
	
	^ String streamContents: [ :str |
		self targetApplication 
			ifNotNil: [ :target | 
				str << 'tell application "' << target << '"'.
				str lf; lf ].
			
		str << self basicCommandString.
		
		self targetApplication ifNotNil: [ 
			str
				lf; lf;
				nextPutAll: 'end tell' ] ].
]

{ #category : #private }
Applescript >> stripQuotesFrom: aStringReturnedFromApplescript [

	aStringReturnedFromApplescript ifEmpty: [ ^ aStringReturnedFromApplescript ].
	^ aStringReturnedFromApplescript
		copyFrom: 2
		to: aStringReturnedFromApplescript size - 1.
]

{ #category : #accessing }
Applescript >> targetApplication [

	^ targetApplication
]

{ #category : #accessing }
Applescript >> targetApplication: anObject [

	targetApplication := anObject
]

{ #category : #accessing }
Applescript >> tell: aString [
	self targetApplication: aString
]
