as yet unclassified
processString: aString 

	| rawString |
	rawString := self stripQuotesFrom: aString.
	^ rawString copyReplaceAll: '\"' with: '"'.