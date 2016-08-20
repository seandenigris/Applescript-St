private
makeSafeForMultiline: aString

	| tabsEscaped |
	tabsEscaped := self escapeTabsIn: aString.
	^ self escapeDoubleQuotesIn: tabsEscaped.