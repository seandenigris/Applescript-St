as yet unclassified
makeSafeForMultiline: aString

	| tabsEscaped |
	tabsEscaped := self escapeTabsIn: aString.
	^ self escapeDoubleQuotesIn: tabsEscaped.