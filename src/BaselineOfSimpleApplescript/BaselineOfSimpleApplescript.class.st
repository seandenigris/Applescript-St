Class {
	#name : #BaselineOfSimpleApplescript,
	#superclass : #BaselineOf,
	#category : #BaselineOfSimpleApplescript
}

{ #category : #baseline }
BaselineOfSimpleApplescript >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [
			spec
				baseline: 'PharoEnhancements' with: [
					spec repository: 'github://seandenigris/Pharo-Enhancements' ];
				baseline: 'OSShell' with: [
				spec repository: 'github://seandenigris/Pharo-Shell' ];
				baseline: 'Superuser' with: [
				spec repository: 'github://seandenigris/Superuser' ].
			spec
				package: 'SimpleApplescript-Core'
					with: [ spec requires: #('OSShell' 'PharoEnhancements' 'Superuser') ];
				package: 'SimpleApplescript-Specification'
					with: [ spec requires: #('SimpleApplescript-Core') ].
			spec group: 'Core' with: #('SimpleApplescript-Core') ]
]
