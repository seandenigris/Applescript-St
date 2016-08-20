scripting
stripQuotesFrom: aStringReturnedFromApplescript

	aStringReturnedFromApplescript ifEmpty: [ ^ aStringReturnedFromApplescript ].
	^ aStringReturnedFromApplescript
		copyFrom: 2
		to: aStringReturnedFromApplescript size - 1.