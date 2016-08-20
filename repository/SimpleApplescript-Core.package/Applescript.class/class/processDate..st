private
processDate: aString 

	| dateString weekdayStripped |
	dateString := aString copyFrom: 7 to: aString size - 1.
	weekdayStripped := dateString copyAfter: Character space.
	^ weekdayStripped asDateAndTime.