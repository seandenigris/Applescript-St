as yet unclassified
run: aString

	| command |
	command := self new
		script: aString;
		recompilableOutput.
	^ command run.