private
processList: returnString

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