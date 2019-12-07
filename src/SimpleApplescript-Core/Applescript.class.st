"
I execute Applescript scripts via my class side #doIt:.

I am a bare-bones replacement for the class of the same name in the Applescript project (on Squeaksource) because the required plugin does not work on the new Cocoa Cog VMs.
"
Class {
	#name : #Applescript,
	#superclass : #Object,
	#category : 'SimpleApplescript-Core'
}

{ #category : #scripting }
Applescript class >> doIt: aString [ 

	| output |
	output := OsaScript run: aString.
	^ self smalltalkifyOutput: output.

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

{ #category : #private }
Applescript class >> makeSafeForMultiline: aString [

	| tabsEscaped |
	tabsEscaped := self escapeTabsIn: aString.
	^ self escapeDoubleQuotesIn: tabsEscaped.
]

{ #category : #private }
Applescript class >> processAtom: aString [

	| isApplescriptString |
	aString = 'true' ifTrue: [ ^ true ].
	aString = 'false' ifTrue: [ ^ false ].
	(aString beginsWith: 'date ') ifTrue: [ ^ self processDate: aString ].
	isApplescriptString := aString isEmpty not and: [ aString first = $" and: [ aString last = $" ] ].
	isApplescriptString ifTrue: [ ^ self processString: aString ].
	^ ApplescriptReference on: aString.
]

{ #category : #private }
Applescript class >> processDate: aString [ 

	| dateString weekdayStripped |
	dateString := aString copyFrom: 7 to: aString size - 1.
	weekdayStripped := dateString copyAfter: Character space.
	^ weekdayStripped asDateAndTime.
]

{ #category : #private }
Applescript class >> processList: returnString [

	| delimiter item contents listParser result listClose |
	delimiter := ', ' asParser.
	listClose := $} asParser.
	item := (delimiter / listClose) negate plus flatten.
	contents := (item separatedBy: delimiter) ==> [ :nodes | nodes reject: [ :n | n = ', ' ] ].
	listParser := ${ asParser, contents optional, listClose ==> #second.
	result := listParser parse: returnString.
	^ result isNil
		ifTrue: [ OrderedCollection new ]
		ifFalse: [ result collect: [ :e | self smalltalkifyOutput: e ] ].
]

{ #category : #private }
Applescript class >> processRecord: aString [ 
	'{who:"Matt", town:"Ojai"}'.
	self shouldBeImplemented.
]

{ #category : #private }
Applescript class >> processString: aString [ 

	| rawString |
	rawString := self stripQuotesFrom: aString.
	^ rawString copyReplaceAll: '\"' with: '"'.
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

{ #category : #private }
Applescript class >> smalltalkifyOutput: aString [ 

	| isList |
	isList := aString isEmpty not and: [ aString first = ${ and: [ aString last = $} ] ].
	isList ifTrue: [ ^ self processList: aString ].
	^ self processAtom: aString.
]

{ #category : #private }
Applescript class >> stripQuotesFrom: aStringReturnedFromApplescript [

	aStringReturnedFromApplescript ifEmpty: [ ^ aStringReturnedFromApplescript ].
	^ aStringReturnedFromApplescript
		copyFrom: 2
		to: aStringReturnedFromApplescript size - 1.
]

{ #category : #scripting }
Applescript class >> tell: applicationString to: script [
	| template fullScript |
	template := 'tell application "{app}"
	{script}
end tell'.
	fullScript := template format: { 
		#app -> applicationString.
		#script -> script } asDictionary.
	self doIt: fullScript
]
