private
processString: aString 

	| rawString |
	rawString := self stripQuotesFrom: aString.
	^ rawString copyReplaceAll: '\"' with: '"'.