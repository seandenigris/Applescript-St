scripting
escapeDoubleQuotesIn: aString
	"Should be in String, but this is all very experimental, so I'm keeping it contained"

	^ aString copyReplaceAll: '"' with: '\"' asTokens: false.