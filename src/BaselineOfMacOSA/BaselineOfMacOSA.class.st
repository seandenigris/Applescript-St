Class {
	#name : #BaselineOfMacOSA,
	#superclass : #BaselineOf,
	#category : #BaselineOfMacOSA
}

{ #category : #baseline }
BaselineOfMacOSA >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [
			spec
				baseline: #'PharoEnhancements' with: [
					spec repository: 'github://seandenigris/Pharo-Enhancements' ];
				baseline: #'OSShell' with: [
				spec repository: 'github://seandenigris/Pharo-Shell' ];
				baseline: #'Superuser' with: [
				spec repository: 'github://seandenigris/Superuser' ].
			spec
				package: #'Mac OSA-Core'
					with: [ spec requires: #(OSShell PharoEnhancements Superuser) ];
				package: #'Mac OSA-Specification'
					with: [ spec requires: #(#'Mac OSA-Core') ].
			spec group: #'Core' with: #(#'Mac OSA-Core') ]
]
