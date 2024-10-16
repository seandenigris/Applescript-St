Class {
	#name : #OsaJavaScript,
	#superclass : #SuRunnable,
	#instVars : [
		'targetApplication'
	],
	#category : #'Mac OSA-Core'
}

{ #category : #scripting }
OsaJavaScript class >> do: script [
	^ self new
		template: script;
		output
]

{ #category : #scripting }
OsaJavaScript class >> doIt: aString [ 

	^ self new
		template: aString;
		output
]

{ #category : #private }
OsaJavaScript class >> escapeDoubleQuotesIn: aString [
	"Should be in String, but this is all very experimental, so I'm keeping it contained"

	^ aString copyReplaceAll: '"' with: '\"' asTokens: false.
]

{ #category : #private }
OsaJavaScript class >> escapeTabsIn: aString [ 

	^ aString copyWithout: Character tab.
]

{ #category : #accessing }
OsaJavaScript class >> exampleError [
	<gtExample>
	
	^ self 
		given: []
		when: [ self doIt: 'error "oops"' ]
		then: [ :result |
			result message should equal: 'oops'.
			result number should equal: 2700. "the default" ]
]

{ #category : #examples }
OsaJavaScript class >> exampleTell [
	<gtExample>
	
	^ self 
		given: []
		when: [ self tell: 'Safari' to: 'get name' ]
		then: [ :result |
			result should equal: 'Safari' ]
]

{ #category : #private }
OsaJavaScript class >> makeSafeForMultiline: aString [

	| tabsEscaped |
	tabsEscaped := self escapeTabsIn: aString.
	^ self escapeDoubleQuotesIn: tabsEscaped.
]

{ #category : #'as yet unclassified' }
OsaJavaScript >> dateParser [

	| space time timezone |
	space := Character space asPParser.
	time := #digit asPParser plus, $: asPParser, #digit asPParser plus, $: asPParser, #digit asPParser plus.
	timezone := 'GMT' asPParser, ('-' asPParser / '+' asPParser), #digit asPParser plus flatten, ' (' asPParser, $) asPParser negate plus, $) asPParser ==> [ :nodes | nodes second, nodes third ].
	^ Week dayNameParser, space, (Month nameParser, space, #digit asPParser plus flatten, space, #digit asPParser plus flatten, space, time flatten, space) flatten, timezone end ==> [ :nodes | (nodes third, nodes fourth) asDateAndTime ].
	
	"Implementation note: first considered hand parsing, but then would have to wrap in error block to test for a match, and might accidentally coerce non dates...
	
	tzDescriptionStripped := 'Fri Oct 11 2024 19:57:14 GMT-0400 (Eastern Daylight Time)' copyUpTo: $(.
tokens := tzDescriptionStripped trimRight splitOn: Character space.
tokens at: tokens size put: (tokens last allButFirst: 'GMT' size).
dateAndTimeString := String streamContents: [ :str |
	tokens allButFirst
		do: [ :token | str << token ]
		separatedBy: [ str space ] ].
dateAndTimeString asDateAndTime"
]

{ #category : #scripting }
OsaJavaScript >> output [

	| output |
	output := OsaScript new
		beJavaScript;
		source: self string;
		run.
	^ self smalltalkifyOutput: output trimmed.
]

{ #category : #private }
OsaJavaScript >> processAtom: aString [

	| isApplescriptString |
	aString = 'true' ifTrue: [ ^ true ].
	aString = 'false' ifTrue: [ ^ false ].
	(self dateParser matches: aString) ifTrue: [ ^ self dateParser parse: aString ].
	isApplescriptString := aString isEmpty not and: [ aString first = $" and: [ aString last = $" ] ].
	isApplescriptString ifTrue: [ ^ self processString: aString ].
	(NumberParser isNumber: aString) ifTrue: [ ^ aString asNumber ].
	(AsError isClassFor: aString) ifTrue: [ ^ AsError fromString: aString ].
	^ OsaJavaScriptReference on: aString
]

{ #category : #private }
OsaJavaScript >> processDate: aString [ 

	| tzDescriptionStripped tokens dateAndTimeString |
	tzDescriptionStripped := aString copyUpTo: $(.
	tokens := tzDescriptionStripped trimRight splitOn: Character space.
	tokens at: tokens size put: (tokens last allButFirst: 'GMT' size).
	dateAndTimeString := String streamContents: [ :str |
		tokens allButFirst "strip weekday name"
			do: [ :token | str << token ]
			separatedBy: [ str space ] ].
	^ dateAndTimeString asDateAndTime
]

{ #category : #private }
OsaJavaScript >> processList: returnString [

	| delimiter item contents listParser result listClose |
	delimiter := ', ' asPParser.
	listClose := $] asPParser.
	item := (delimiter / listClose) negate plus flatten.
	contents := (item separatedBy: delimiter) ==> [ :nodes | nodes reject: [ :n | n = ', ' ] ].
	listParser := $[ asPParser, contents optional, listClose ==> #second.
	result := listParser parse: returnString.
	^ result isNil
		ifTrue: [ OrderedCollection new ]
		ifFalse: [ result collect: [ :e | self smalltalkifyOutput: e ] ].
]

{ #category : #private }
OsaJavaScript >> processRecord: aString [ 
	'{who:"Matt", town:"Ojai"}'.
	self shouldBeImplemented.
]

{ #category : #private }
OsaJavaScript >> processString: aString [ 

	| rawString |
	rawString := self stripQuotesFrom: aString.
	^ rawString copyReplaceAll: '\"' with: '"'.
]

{ #category : #scripting }
OsaJavaScript >> run [

	^ self output
]

{ #category : #private }
OsaJavaScript >> smalltalkifyOutput: aString [ 

	| isList |
	isList := aString isEmpty not and: [ aString first = $[ and: [ aString last = $] ] ].
	isList ifTrue: [ ^ self processList: aString ].
	^ self processAtom: aString.
]

{ #category : #private }
OsaJavaScript >> stripQuotesFrom: aStringReturnedFromApplescript [

	aStringReturnedFromApplescript ifEmpty: [ ^ aStringReturnedFromApplescript ].
	^ aStringReturnedFromApplescript
		copyFrom: 2
		to: aStringReturnedFromApplescript size - 1.
]

{ #category : #accessing }
OsaJavaScript >> targetApplication [

	^ targetApplication
]

{ #category : #accessing }
OsaJavaScript >> targetApplication: anObject [

	targetApplication := anObject
]

{ #category : #accessing }
OsaJavaScript >> tell: aString [
	self targetApplication: aString
]
